
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	f04a                	sd	s2,32(sp)
       a:	ec4e                	sd	s3,24(sp)
       c:	0080                	addi	s0,sp,64
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
       e:	4785                	li	a5,1
      10:	07fe                	slli	a5,a5,0x1f
      12:	fcf43023          	sd	a5,-64(s0)
      16:	57fd                	li	a5,-1
      18:	fcf43423          	sd	a5,-56(s0)

  for(int ai = 0; ai < 2; ai++){
      1c:	fc040493          	addi	s1,s0,-64
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      20:	20100993          	li	s3,513
    uint64 addr = addrs[ai];
      24:	0004b903          	ld	s2,0(s1)
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      28:	85ce                	mv	a1,s3
      2a:	854a                	mv	a0,s2
      2c:	00006097          	auipc	ra,0x6
      30:	670080e7          	jalr	1648(ra) # 669c <open>
    if(fd >= 0){
      34:	00055e63          	bgez	a0,50 <copyinstr1+0x50>
  for(int ai = 0; ai < 2; ai++){
      38:	04a1                	addi	s1,s1,8
      3a:	fd040793          	addi	a5,s0,-48
      3e:	fef493e3          	bne	s1,a5,24 <copyinstr1+0x24>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      42:	70e2                	ld	ra,56(sp)
      44:	7442                	ld	s0,48(sp)
      46:	74a2                	ld	s1,40(sp)
      48:	7902                	ld	s2,32(sp)
      4a:	69e2                	ld	s3,24(sp)
      4c:	6121                	addi	sp,sp,64
      4e:	8082                	ret
      printf("open(%p) returned %d, not -1\n", addr, fd);
      50:	862a                	mv	a2,a0
      52:	85ca                	mv	a1,s2
      54:	00007517          	auipc	a0,0x7
      58:	b3c50513          	addi	a0,a0,-1220 # 6b90 <malloc+0xfa>
      5c:	00007097          	auipc	ra,0x7
      60:	97e080e7          	jalr	-1666(ra) # 69da <printf>
      exit(1);
      64:	4505                	li	a0,1
      66:	00006097          	auipc	ra,0x6
      6a:	5f6080e7          	jalr	1526(ra) # 665c <exit>

000000000000006e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      6e:	0000b797          	auipc	a5,0xb
      72:	50a78793          	addi	a5,a5,1290 # b578 <uninit>
      76:	0000e697          	auipc	a3,0xe
      7a:	c1268693          	addi	a3,a3,-1006 # dc88 <buf>
    if(uninit[i] != '\0'){
      7e:	0007c703          	lbu	a4,0(a5)
      82:	e709                	bnez	a4,8c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      84:	0785                	addi	a5,a5,1
      86:	fed79ce3          	bne	a5,a3,7e <bsstest+0x10>
      8a:	8082                	ret
{
      8c:	1141                	addi	sp,sp,-16
      8e:	e406                	sd	ra,8(sp)
      90:	e022                	sd	s0,0(sp)
      92:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      94:	85aa                	mv	a1,a0
      96:	00007517          	auipc	a0,0x7
      9a:	b1a50513          	addi	a0,a0,-1254 # 6bb0 <malloc+0x11a>
      9e:	00007097          	auipc	ra,0x7
      a2:	93c080e7          	jalr	-1732(ra) # 69da <printf>
      exit(1);
      a6:	4505                	li	a0,1
      a8:	00006097          	auipc	ra,0x6
      ac:	5b4080e7          	jalr	1460(ra) # 665c <exit>

00000000000000b0 <opentest>:
{
      b0:	1101                	addi	sp,sp,-32
      b2:	ec06                	sd	ra,24(sp)
      b4:	e822                	sd	s0,16(sp)
      b6:	e426                	sd	s1,8(sp)
      b8:	1000                	addi	s0,sp,32
      ba:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      bc:	4581                	li	a1,0
      be:	00007517          	auipc	a0,0x7
      c2:	b0a50513          	addi	a0,a0,-1270 # 6bc8 <malloc+0x132>
      c6:	00006097          	auipc	ra,0x6
      ca:	5d6080e7          	jalr	1494(ra) # 669c <open>
  if(fd < 0){
      ce:	02054663          	bltz	a0,fa <opentest+0x4a>
  close(fd);
      d2:	00006097          	auipc	ra,0x6
      d6:	5b2080e7          	jalr	1458(ra) # 6684 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00007517          	auipc	a0,0x7
      e0:	b0c50513          	addi	a0,a0,-1268 # 6be8 <malloc+0x152>
      e4:	00006097          	auipc	ra,0x6
      e8:	5b8080e7          	jalr	1464(ra) # 669c <open>
  if(fd >= 0){
      ec:	02055563          	bgez	a0,116 <opentest+0x66>
}
      f0:	60e2                	ld	ra,24(sp)
      f2:	6442                	ld	s0,16(sp)
      f4:	64a2                	ld	s1,8(sp)
      f6:	6105                	addi	sp,sp,32
      f8:	8082                	ret
    printf("%s: open echo failed!\n", s);
      fa:	85a6                	mv	a1,s1
      fc:	00007517          	auipc	a0,0x7
     100:	ad450513          	addi	a0,a0,-1324 # 6bd0 <malloc+0x13a>
     104:	00007097          	auipc	ra,0x7
     108:	8d6080e7          	jalr	-1834(ra) # 69da <printf>
    exit(1);
     10c:	4505                	li	a0,1
     10e:	00006097          	auipc	ra,0x6
     112:	54e080e7          	jalr	1358(ra) # 665c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     116:	85a6                	mv	a1,s1
     118:	00007517          	auipc	a0,0x7
     11c:	ae050513          	addi	a0,a0,-1312 # 6bf8 <malloc+0x162>
     120:	00007097          	auipc	ra,0x7
     124:	8ba080e7          	jalr	-1862(ra) # 69da <printf>
    exit(1);
     128:	4505                	li	a0,1
     12a:	00006097          	auipc	ra,0x6
     12e:	532080e7          	jalr	1330(ra) # 665c <exit>

0000000000000132 <truncate2>:
{
     132:	7179                	addi	sp,sp,-48
     134:	f406                	sd	ra,40(sp)
     136:	f022                	sd	s0,32(sp)
     138:	ec26                	sd	s1,24(sp)
     13a:	e84a                	sd	s2,16(sp)
     13c:	e44e                	sd	s3,8(sp)
     13e:	1800                	addi	s0,sp,48
     140:	89aa                	mv	s3,a0
  unlink("truncfile");
     142:	00007517          	auipc	a0,0x7
     146:	ade50513          	addi	a0,a0,-1314 # 6c20 <malloc+0x18a>
     14a:	00006097          	auipc	ra,0x6
     14e:	562080e7          	jalr	1378(ra) # 66ac <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     152:	60100593          	li	a1,1537
     156:	00007517          	auipc	a0,0x7
     15a:	aca50513          	addi	a0,a0,-1334 # 6c20 <malloc+0x18a>
     15e:	00006097          	auipc	ra,0x6
     162:	53e080e7          	jalr	1342(ra) # 669c <open>
     166:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     168:	4611                	li	a2,4
     16a:	00007597          	auipc	a1,0x7
     16e:	ac658593          	addi	a1,a1,-1338 # 6c30 <malloc+0x19a>
     172:	00006097          	auipc	ra,0x6
     176:	50a080e7          	jalr	1290(ra) # 667c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     17a:	40100593          	li	a1,1025
     17e:	00007517          	auipc	a0,0x7
     182:	aa250513          	addi	a0,a0,-1374 # 6c20 <malloc+0x18a>
     186:	00006097          	auipc	ra,0x6
     18a:	516080e7          	jalr	1302(ra) # 669c <open>
     18e:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     190:	4605                	li	a2,1
     192:	00007597          	auipc	a1,0x7
     196:	aa658593          	addi	a1,a1,-1370 # 6c38 <malloc+0x1a2>
     19a:	8526                	mv	a0,s1
     19c:	00006097          	auipc	ra,0x6
     1a0:	4e0080e7          	jalr	1248(ra) # 667c <write>
  if(n != -1){
     1a4:	57fd                	li	a5,-1
     1a6:	02f51b63          	bne	a0,a5,1dc <truncate2+0xaa>
  unlink("truncfile");
     1aa:	00007517          	auipc	a0,0x7
     1ae:	a7650513          	addi	a0,a0,-1418 # 6c20 <malloc+0x18a>
     1b2:	00006097          	auipc	ra,0x6
     1b6:	4fa080e7          	jalr	1274(ra) # 66ac <unlink>
  close(fd1);
     1ba:	8526                	mv	a0,s1
     1bc:	00006097          	auipc	ra,0x6
     1c0:	4c8080e7          	jalr	1224(ra) # 6684 <close>
  close(fd2);
     1c4:	854a                	mv	a0,s2
     1c6:	00006097          	auipc	ra,0x6
     1ca:	4be080e7          	jalr	1214(ra) # 6684 <close>
}
     1ce:	70a2                	ld	ra,40(sp)
     1d0:	7402                	ld	s0,32(sp)
     1d2:	64e2                	ld	s1,24(sp)
     1d4:	6942                	ld	s2,16(sp)
     1d6:	69a2                	ld	s3,8(sp)
     1d8:	6145                	addi	sp,sp,48
     1da:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1dc:	862a                	mv	a2,a0
     1de:	85ce                	mv	a1,s3
     1e0:	00007517          	auipc	a0,0x7
     1e4:	a6050513          	addi	a0,a0,-1440 # 6c40 <malloc+0x1aa>
     1e8:	00006097          	auipc	ra,0x6
     1ec:	7f2080e7          	jalr	2034(ra) # 69da <printf>
    exit(1);
     1f0:	4505                	li	a0,1
     1f2:	00006097          	auipc	ra,0x6
     1f6:	46a080e7          	jalr	1130(ra) # 665c <exit>

00000000000001fa <createtest>:
{
     1fa:	7139                	addi	sp,sp,-64
     1fc:	fc06                	sd	ra,56(sp)
     1fe:	f822                	sd	s0,48(sp)
     200:	f426                	sd	s1,40(sp)
     202:	f04a                	sd	s2,32(sp)
     204:	ec4e                	sd	s3,24(sp)
     206:	e852                	sd	s4,16(sp)
     208:	0080                	addi	s0,sp,64
  name[0] = 'a';
     20a:	06100793          	li	a5,97
     20e:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     212:	fc040523          	sb	zero,-54(s0)
     216:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     21a:	fc840a13          	addi	s4,s0,-56
     21e:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     222:	06400913          	li	s2,100
    name[1] = '0' + i;
     226:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     22a:	85ce                	mv	a1,s3
     22c:	8552                	mv	a0,s4
     22e:	00006097          	auipc	ra,0x6
     232:	46e080e7          	jalr	1134(ra) # 669c <open>
    close(fd);
     236:	00006097          	auipc	ra,0x6
     23a:	44e080e7          	jalr	1102(ra) # 6684 <close>
  for(i = 0; i < N; i++){
     23e:	2485                	addiw	s1,s1,1
     240:	0ff4f493          	zext.b	s1,s1
     244:	ff2491e3          	bne	s1,s2,226 <createtest+0x2c>
  name[0] = 'a';
     248:	06100793          	li	a5,97
     24c:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     250:	fc040523          	sb	zero,-54(s0)
     254:	03000493          	li	s1,48
    unlink(name);
     258:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     25c:	06400913          	li	s2,100
    name[1] = '0' + i;
     260:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     264:	854e                	mv	a0,s3
     266:	00006097          	auipc	ra,0x6
     26a:	446080e7          	jalr	1094(ra) # 66ac <unlink>
  for(i = 0; i < N; i++){
     26e:	2485                	addiw	s1,s1,1
     270:	0ff4f493          	zext.b	s1,s1
     274:	ff2496e3          	bne	s1,s2,260 <createtest+0x66>
}
     278:	70e2                	ld	ra,56(sp)
     27a:	7442                	ld	s0,48(sp)
     27c:	74a2                	ld	s1,40(sp)
     27e:	7902                	ld	s2,32(sp)
     280:	69e2                	ld	s3,24(sp)
     282:	6a42                	ld	s4,16(sp)
     284:	6121                	addi	sp,sp,64
     286:	8082                	ret

0000000000000288 <bigwrite>:
{
     288:	711d                	addi	sp,sp,-96
     28a:	ec86                	sd	ra,88(sp)
     28c:	e8a2                	sd	s0,80(sp)
     28e:	e4a6                	sd	s1,72(sp)
     290:	e0ca                	sd	s2,64(sp)
     292:	fc4e                	sd	s3,56(sp)
     294:	f852                	sd	s4,48(sp)
     296:	f456                	sd	s5,40(sp)
     298:	f05a                	sd	s6,32(sp)
     29a:	ec5e                	sd	s7,24(sp)
     29c:	e862                	sd	s8,16(sp)
     29e:	e466                	sd	s9,8(sp)
     2a0:	1080                	addi	s0,sp,96
     2a2:	8caa                	mv	s9,a0
  unlink("bigwrite");
     2a4:	00007517          	auipc	a0,0x7
     2a8:	9c450513          	addi	a0,a0,-1596 # 6c68 <malloc+0x1d2>
     2ac:	00006097          	auipc	ra,0x6
     2b0:	400080e7          	jalr	1024(ra) # 66ac <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b8:	20200b93          	li	s7,514
     2bc:	00007a17          	auipc	s4,0x7
     2c0:	9aca0a13          	addi	s4,s4,-1620 # 6c68 <malloc+0x1d2>
     2c4:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     2c6:	0000e997          	auipc	s3,0xe
     2ca:	9c298993          	addi	s3,s3,-1598 # dc88 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2ce:	6a8d                	lui	s5,0x3
     2d0:	1c9a8a93          	addi	s5,s5,457 # 31c9 <fourteen+0x2d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2d4:	85de                	mv	a1,s7
     2d6:	8552                	mv	a0,s4
     2d8:	00006097          	auipc	ra,0x6
     2dc:	3c4080e7          	jalr	964(ra) # 669c <open>
     2e0:	892a                	mv	s2,a0
    if(fd < 0){
     2e2:	04054a63          	bltz	a0,336 <bigwrite+0xae>
     2e6:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     2e8:	8626                	mv	a2,s1
     2ea:	85ce                	mv	a1,s3
     2ec:	854a                	mv	a0,s2
     2ee:	00006097          	auipc	ra,0x6
     2f2:	38e080e7          	jalr	910(ra) # 667c <write>
      if(cc != sz){
     2f6:	04951e63          	bne	a0,s1,352 <bigwrite+0xca>
    for(i = 0; i < 2; i++){
     2fa:	3c7d                	addiw	s8,s8,-1
     2fc:	fe0c16e3          	bnez	s8,2e8 <bigwrite+0x60>
    close(fd);
     300:	854a                	mv	a0,s2
     302:	00006097          	auipc	ra,0x6
     306:	382080e7          	jalr	898(ra) # 6684 <close>
    unlink("bigwrite");
     30a:	8552                	mv	a0,s4
     30c:	00006097          	auipc	ra,0x6
     310:	3a0080e7          	jalr	928(ra) # 66ac <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     314:	1d74849b          	addiw	s1,s1,471
     318:	fb549ee3          	bne	s1,s5,2d4 <bigwrite+0x4c>
}
     31c:	60e6                	ld	ra,88(sp)
     31e:	6446                	ld	s0,80(sp)
     320:	64a6                	ld	s1,72(sp)
     322:	6906                	ld	s2,64(sp)
     324:	79e2                	ld	s3,56(sp)
     326:	7a42                	ld	s4,48(sp)
     328:	7aa2                	ld	s5,40(sp)
     32a:	7b02                	ld	s6,32(sp)
     32c:	6be2                	ld	s7,24(sp)
     32e:	6c42                	ld	s8,16(sp)
     330:	6ca2                	ld	s9,8(sp)
     332:	6125                	addi	sp,sp,96
     334:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     336:	85e6                	mv	a1,s9
     338:	00007517          	auipc	a0,0x7
     33c:	94050513          	addi	a0,a0,-1728 # 6c78 <malloc+0x1e2>
     340:	00006097          	auipc	ra,0x6
     344:	69a080e7          	jalr	1690(ra) # 69da <printf>
      exit(1);
     348:	4505                	li	a0,1
     34a:	00006097          	auipc	ra,0x6
     34e:	312080e7          	jalr	786(ra) # 665c <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     352:	86aa                	mv	a3,a0
     354:	8626                	mv	a2,s1
     356:	85e6                	mv	a1,s9
     358:	00007517          	auipc	a0,0x7
     35c:	94050513          	addi	a0,a0,-1728 # 6c98 <malloc+0x202>
     360:	00006097          	auipc	ra,0x6
     364:	67a080e7          	jalr	1658(ra) # 69da <printf>
        exit(1);
     368:	4505                	li	a0,1
     36a:	00006097          	auipc	ra,0x6
     36e:	2f2080e7          	jalr	754(ra) # 665c <exit>

0000000000000372 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     372:	7139                	addi	sp,sp,-64
     374:	fc06                	sd	ra,56(sp)
     376:	f822                	sd	s0,48(sp)
     378:	f426                	sd	s1,40(sp)
     37a:	f04a                	sd	s2,32(sp)
     37c:	ec4e                	sd	s3,24(sp)
     37e:	e852                	sd	s4,16(sp)
     380:	e456                	sd	s5,8(sp)
     382:	e05a                	sd	s6,0(sp)
     384:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     386:	00007517          	auipc	a0,0x7
     38a:	92a50513          	addi	a0,a0,-1750 # 6cb0 <malloc+0x21a>
     38e:	00006097          	auipc	ra,0x6
     392:	31e080e7          	jalr	798(ra) # 66ac <unlink>
     396:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     39a:	20100a93          	li	s5,513
     39e:	00007997          	auipc	s3,0x7
     3a2:	91298993          	addi	s3,s3,-1774 # 6cb0 <malloc+0x21a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     3a6:	4b05                	li	s6,1
     3a8:	5a7d                	li	s4,-1
     3aa:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ae:	85d6                	mv	a1,s5
     3b0:	854e                	mv	a0,s3
     3b2:	00006097          	auipc	ra,0x6
     3b6:	2ea080e7          	jalr	746(ra) # 669c <open>
     3ba:	84aa                	mv	s1,a0
    if(fd < 0){
     3bc:	06054b63          	bltz	a0,432 <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
     3c0:	865a                	mv	a2,s6
     3c2:	85d2                	mv	a1,s4
     3c4:	00006097          	auipc	ra,0x6
     3c8:	2b8080e7          	jalr	696(ra) # 667c <write>
    close(fd);
     3cc:	8526                	mv	a0,s1
     3ce:	00006097          	auipc	ra,0x6
     3d2:	2b6080e7          	jalr	694(ra) # 6684 <close>
    unlink("junk");
     3d6:	854e                	mv	a0,s3
     3d8:	00006097          	auipc	ra,0x6
     3dc:	2d4080e7          	jalr	724(ra) # 66ac <unlink>
  for(int i = 0; i < assumed_free; i++){
     3e0:	397d                	addiw	s2,s2,-1
     3e2:	fc0916e3          	bnez	s2,3ae <badwrite+0x3c>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3e6:	20100593          	li	a1,513
     3ea:	00007517          	auipc	a0,0x7
     3ee:	8c650513          	addi	a0,a0,-1850 # 6cb0 <malloc+0x21a>
     3f2:	00006097          	auipc	ra,0x6
     3f6:	2aa080e7          	jalr	682(ra) # 669c <open>
     3fa:	84aa                	mv	s1,a0
  if(fd < 0){
     3fc:	04054863          	bltz	a0,44c <badwrite+0xda>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     400:	4605                	li	a2,1
     402:	00007597          	auipc	a1,0x7
     406:	83658593          	addi	a1,a1,-1994 # 6c38 <malloc+0x1a2>
     40a:	00006097          	auipc	ra,0x6
     40e:	272080e7          	jalr	626(ra) # 667c <write>
     412:	4785                	li	a5,1
     414:	04f50963          	beq	a0,a5,466 <badwrite+0xf4>
    printf("write failed\n");
     418:	00007517          	auipc	a0,0x7
     41c:	8b850513          	addi	a0,a0,-1864 # 6cd0 <malloc+0x23a>
     420:	00006097          	auipc	ra,0x6
     424:	5ba080e7          	jalr	1466(ra) # 69da <printf>
    exit(1);
     428:	4505                	li	a0,1
     42a:	00006097          	auipc	ra,0x6
     42e:	232080e7          	jalr	562(ra) # 665c <exit>
      printf("open junk failed\n");
     432:	00007517          	auipc	a0,0x7
     436:	88650513          	addi	a0,a0,-1914 # 6cb8 <malloc+0x222>
     43a:	00006097          	auipc	ra,0x6
     43e:	5a0080e7          	jalr	1440(ra) # 69da <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00006097          	auipc	ra,0x6
     448:	218080e7          	jalr	536(ra) # 665c <exit>
    printf("open junk failed\n");
     44c:	00007517          	auipc	a0,0x7
     450:	86c50513          	addi	a0,a0,-1940 # 6cb8 <malloc+0x222>
     454:	00006097          	auipc	ra,0x6
     458:	586080e7          	jalr	1414(ra) # 69da <printf>
    exit(1);
     45c:	4505                	li	a0,1
     45e:	00006097          	auipc	ra,0x6
     462:	1fe080e7          	jalr	510(ra) # 665c <exit>
  }
  close(fd);
     466:	8526                	mv	a0,s1
     468:	00006097          	auipc	ra,0x6
     46c:	21c080e7          	jalr	540(ra) # 6684 <close>
  unlink("junk");
     470:	00007517          	auipc	a0,0x7
     474:	84050513          	addi	a0,a0,-1984 # 6cb0 <malloc+0x21a>
     478:	00006097          	auipc	ra,0x6
     47c:	234080e7          	jalr	564(ra) # 66ac <unlink>

  exit(0);
     480:	4501                	li	a0,0
     482:	00006097          	auipc	ra,0x6
     486:	1da080e7          	jalr	474(ra) # 665c <exit>

000000000000048a <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     48a:	711d                	addi	sp,sp,-96
     48c:	ec86                	sd	ra,88(sp)
     48e:	e8a2                	sd	s0,80(sp)
     490:	e4a6                	sd	s1,72(sp)
     492:	e0ca                	sd	s2,64(sp)
     494:	fc4e                	sd	s3,56(sp)
     496:	f852                	sd	s4,48(sp)
     498:	f456                	sd	s5,40(sp)
     49a:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     49c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     49e:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     4a2:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4a6:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     4aa:	40000a93          	li	s5,1024
    name[0] = 'z';
     4ae:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     4b2:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     4b6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ba:	01b7571b          	srliw	a4,a4,0x1b
     4be:	009707bb          	addw	a5,a4,s1
     4c2:	4057d69b          	sraiw	a3,a5,0x5
     4c6:	0306869b          	addiw	a3,a3,48
     4ca:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     4ce:	8bfd                	andi	a5,a5,31
     4d0:	9f99                	subw	a5,a5,a4
     4d2:	0307879b          	addiw	a5,a5,48
     4d6:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     4da:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     4de:	854a                	mv	a0,s2
     4e0:	00006097          	auipc	ra,0x6
     4e4:	1cc080e7          	jalr	460(ra) # 66ac <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4e8:	85d2                	mv	a1,s4
     4ea:	854a                	mv	a0,s2
     4ec:	00006097          	auipc	ra,0x6
     4f0:	1b0080e7          	jalr	432(ra) # 669c <open>
    if(fd < 0){
     4f4:	00054963          	bltz	a0,506 <outofinodes+0x7c>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4f8:	00006097          	auipc	ra,0x6
     4fc:	18c080e7          	jalr	396(ra) # 6684 <close>
  for(int i = 0; i < nzz; i++){
     500:	2485                	addiw	s1,s1,1
     502:	fb5496e3          	bne	s1,s5,4ae <outofinodes+0x24>
     506:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     508:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     50c:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     510:	40000993          	li	s3,1024
    name[0] = 'z';
     514:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     518:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     51c:	41f4d71b          	sraiw	a4,s1,0x1f
     520:	01b7571b          	srliw	a4,a4,0x1b
     524:	009707bb          	addw	a5,a4,s1
     528:	4057d69b          	sraiw	a3,a5,0x5
     52c:	0306869b          	addiw	a3,a3,48
     530:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     534:	8bfd                	andi	a5,a5,31
     536:	9f99                	subw	a5,a5,a4
     538:	0307879b          	addiw	a5,a5,48
     53c:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     540:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     544:	8552                	mv	a0,s4
     546:	00006097          	auipc	ra,0x6
     54a:	166080e7          	jalr	358(ra) # 66ac <unlink>
  for(int i = 0; i < nzz; i++){
     54e:	2485                	addiw	s1,s1,1
     550:	fd3492e3          	bne	s1,s3,514 <outofinodes+0x8a>
  }
}
     554:	60e6                	ld	ra,88(sp)
     556:	6446                	ld	s0,80(sp)
     558:	64a6                	ld	s1,72(sp)
     55a:	6906                	ld	s2,64(sp)
     55c:	79e2                	ld	s3,56(sp)
     55e:	7a42                	ld	s4,48(sp)
     560:	7aa2                	ld	s5,40(sp)
     562:	6125                	addi	sp,sp,96
     564:	8082                	ret

0000000000000566 <copyin>:
{
     566:	7159                	addi	sp,sp,-112
     568:	f486                	sd	ra,104(sp)
     56a:	f0a2                	sd	s0,96(sp)
     56c:	eca6                	sd	s1,88(sp)
     56e:	e8ca                	sd	s2,80(sp)
     570:	e4ce                	sd	s3,72(sp)
     572:	e0d2                	sd	s4,64(sp)
     574:	fc56                	sd	s5,56(sp)
     576:	f85a                	sd	s6,48(sp)
     578:	f45e                	sd	s7,40(sp)
     57a:	f062                	sd	s8,32(sp)
     57c:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     57e:	4785                	li	a5,1
     580:	07fe                	slli	a5,a5,0x1f
     582:	faf43023          	sd	a5,-96(s0)
     586:	57fd                	li	a5,-1
     588:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < 2; ai++){
     58c:	fa040913          	addi	s2,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     590:	20100b93          	li	s7,513
     594:	00006a97          	auipc	s5,0x6
     598:	74ca8a93          	addi	s5,s5,1868 # 6ce0 <malloc+0x24a>
    int n = write(fd, (void*)addr, 8192);
     59c:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     59e:	4b05                	li	s6,1
    if(pipe(fds) < 0){
     5a0:	f9840c13          	addi	s8,s0,-104
    uint64 addr = addrs[ai];
     5a4:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5a8:	85de                	mv	a1,s7
     5aa:	8556                	mv	a0,s5
     5ac:	00006097          	auipc	ra,0x6
     5b0:	0f0080e7          	jalr	240(ra) # 669c <open>
     5b4:	84aa                	mv	s1,a0
    if(fd < 0){
     5b6:	08054b63          	bltz	a0,64c <copyin+0xe6>
    int n = write(fd, (void*)addr, 8192);
     5ba:	8652                	mv	a2,s4
     5bc:	85ce                	mv	a1,s3
     5be:	00006097          	auipc	ra,0x6
     5c2:	0be080e7          	jalr	190(ra) # 667c <write>
    if(n >= 0){
     5c6:	0a055063          	bgez	a0,666 <copyin+0x100>
    close(fd);
     5ca:	8526                	mv	a0,s1
     5cc:	00006097          	auipc	ra,0x6
     5d0:	0b8080e7          	jalr	184(ra) # 6684 <close>
    unlink("copyin1");
     5d4:	8556                	mv	a0,s5
     5d6:	00006097          	auipc	ra,0x6
     5da:	0d6080e7          	jalr	214(ra) # 66ac <unlink>
    n = write(1, (char*)addr, 8192);
     5de:	8652                	mv	a2,s4
     5e0:	85ce                	mv	a1,s3
     5e2:	855a                	mv	a0,s6
     5e4:	00006097          	auipc	ra,0x6
     5e8:	098080e7          	jalr	152(ra) # 667c <write>
    if(n > 0){
     5ec:	08a04c63          	bgtz	a0,684 <copyin+0x11e>
    if(pipe(fds) < 0){
     5f0:	8562                	mv	a0,s8
     5f2:	00006097          	auipc	ra,0x6
     5f6:	07a080e7          	jalr	122(ra) # 666c <pipe>
     5fa:	0a054463          	bltz	a0,6a2 <copyin+0x13c>
    n = write(fds[1], (char*)addr, 8192);
     5fe:	8652                	mv	a2,s4
     600:	85ce                	mv	a1,s3
     602:	f9c42503          	lw	a0,-100(s0)
     606:	00006097          	auipc	ra,0x6
     60a:	076080e7          	jalr	118(ra) # 667c <write>
    if(n > 0){
     60e:	0aa04763          	bgtz	a0,6bc <copyin+0x156>
    close(fds[0]);
     612:	f9842503          	lw	a0,-104(s0)
     616:	00006097          	auipc	ra,0x6
     61a:	06e080e7          	jalr	110(ra) # 6684 <close>
    close(fds[1]);
     61e:	f9c42503          	lw	a0,-100(s0)
     622:	00006097          	auipc	ra,0x6
     626:	062080e7          	jalr	98(ra) # 6684 <close>
  for(int ai = 0; ai < 2; ai++){
     62a:	0921                	addi	s2,s2,8
     62c:	fb040793          	addi	a5,s0,-80
     630:	f6f91ae3          	bne	s2,a5,5a4 <copyin+0x3e>
}
     634:	70a6                	ld	ra,104(sp)
     636:	7406                	ld	s0,96(sp)
     638:	64e6                	ld	s1,88(sp)
     63a:	6946                	ld	s2,80(sp)
     63c:	69a6                	ld	s3,72(sp)
     63e:	6a06                	ld	s4,64(sp)
     640:	7ae2                	ld	s5,56(sp)
     642:	7b42                	ld	s6,48(sp)
     644:	7ba2                	ld	s7,40(sp)
     646:	7c02                	ld	s8,32(sp)
     648:	6165                	addi	sp,sp,112
     64a:	8082                	ret
      printf("open(copyin1) failed\n");
     64c:	00006517          	auipc	a0,0x6
     650:	69c50513          	addi	a0,a0,1692 # 6ce8 <malloc+0x252>
     654:	00006097          	auipc	ra,0x6
     658:	386080e7          	jalr	902(ra) # 69da <printf>
      exit(1);
     65c:	4505                	li	a0,1
     65e:	00006097          	auipc	ra,0x6
     662:	ffe080e7          	jalr	-2(ra) # 665c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     666:	862a                	mv	a2,a0
     668:	85ce                	mv	a1,s3
     66a:	00006517          	auipc	a0,0x6
     66e:	69650513          	addi	a0,a0,1686 # 6d00 <malloc+0x26a>
     672:	00006097          	auipc	ra,0x6
     676:	368080e7          	jalr	872(ra) # 69da <printf>
      exit(1);
     67a:	4505                	li	a0,1
     67c:	00006097          	auipc	ra,0x6
     680:	fe0080e7          	jalr	-32(ra) # 665c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     684:	862a                	mv	a2,a0
     686:	85ce                	mv	a1,s3
     688:	00006517          	auipc	a0,0x6
     68c:	6a850513          	addi	a0,a0,1704 # 6d30 <malloc+0x29a>
     690:	00006097          	auipc	ra,0x6
     694:	34a080e7          	jalr	842(ra) # 69da <printf>
      exit(1);
     698:	4505                	li	a0,1
     69a:	00006097          	auipc	ra,0x6
     69e:	fc2080e7          	jalr	-62(ra) # 665c <exit>
      printf("pipe() failed\n");
     6a2:	00006517          	auipc	a0,0x6
     6a6:	6be50513          	addi	a0,a0,1726 # 6d60 <malloc+0x2ca>
     6aa:	00006097          	auipc	ra,0x6
     6ae:	330080e7          	jalr	816(ra) # 69da <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	00006097          	auipc	ra,0x6
     6b8:	fa8080e7          	jalr	-88(ra) # 665c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6bc:	862a                	mv	a2,a0
     6be:	85ce                	mv	a1,s3
     6c0:	00006517          	auipc	a0,0x6
     6c4:	6b050513          	addi	a0,a0,1712 # 6d70 <malloc+0x2da>
     6c8:	00006097          	auipc	ra,0x6
     6cc:	312080e7          	jalr	786(ra) # 69da <printf>
      exit(1);
     6d0:	4505                	li	a0,1
     6d2:	00006097          	auipc	ra,0x6
     6d6:	f8a080e7          	jalr	-118(ra) # 665c <exit>

00000000000006da <copyout>:
{
     6da:	7159                	addi	sp,sp,-112
     6dc:	f486                	sd	ra,104(sp)
     6de:	f0a2                	sd	s0,96(sp)
     6e0:	eca6                	sd	s1,88(sp)
     6e2:	e8ca                	sd	s2,80(sp)
     6e4:	e4ce                	sd	s3,72(sp)
     6e6:	e0d2                	sd	s4,64(sp)
     6e8:	fc56                	sd	s5,56(sp)
     6ea:	f85a                	sd	s6,48(sp)
     6ec:	f45e                	sd	s7,40(sp)
     6ee:	f062                	sd	s8,32(sp)
     6f0:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     6f2:	4785                	li	a5,1
     6f4:	07fe                	slli	a5,a5,0x1f
     6f6:	faf43023          	sd	a5,-96(s0)
     6fa:	57fd                	li	a5,-1
     6fc:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < 2; ai++){
     700:	fa040913          	addi	s2,s0,-96
    int fd = open("README", 0);
     704:	00006b97          	auipc	s7,0x6
     708:	69cb8b93          	addi	s7,s7,1692 # 6da0 <malloc+0x30a>
    int n = read(fd, (void*)addr, 8192);
     70c:	6a09                	lui	s4,0x2
    if(pipe(fds) < 0){
     70e:	f9840b13          	addi	s6,s0,-104
    n = write(fds[1], "x", 1);
     712:	4a85                	li	s5,1
     714:	00006c17          	auipc	s8,0x6
     718:	524c0c13          	addi	s8,s8,1316 # 6c38 <malloc+0x1a2>
    uint64 addr = addrs[ai];
     71c:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     720:	4581                	li	a1,0
     722:	855e                	mv	a0,s7
     724:	00006097          	auipc	ra,0x6
     728:	f78080e7          	jalr	-136(ra) # 669c <open>
     72c:	84aa                	mv	s1,a0
    if(fd < 0){
     72e:	08054763          	bltz	a0,7bc <copyout+0xe2>
    int n = read(fd, (void*)addr, 8192);
     732:	8652                	mv	a2,s4
     734:	85ce                	mv	a1,s3
     736:	00006097          	auipc	ra,0x6
     73a:	f3e080e7          	jalr	-194(ra) # 6674 <read>
    if(n > 0){
     73e:	08a04c63          	bgtz	a0,7d6 <copyout+0xfc>
    close(fd);
     742:	8526                	mv	a0,s1
     744:	00006097          	auipc	ra,0x6
     748:	f40080e7          	jalr	-192(ra) # 6684 <close>
    if(pipe(fds) < 0){
     74c:	855a                	mv	a0,s6
     74e:	00006097          	auipc	ra,0x6
     752:	f1e080e7          	jalr	-226(ra) # 666c <pipe>
     756:	08054f63          	bltz	a0,7f4 <copyout+0x11a>
    n = write(fds[1], "x", 1);
     75a:	8656                	mv	a2,s5
     75c:	85e2                	mv	a1,s8
     75e:	f9c42503          	lw	a0,-100(s0)
     762:	00006097          	auipc	ra,0x6
     766:	f1a080e7          	jalr	-230(ra) # 667c <write>
    if(n != 1){
     76a:	0b551263          	bne	a0,s5,80e <copyout+0x134>
    n = read(fds[0], (void*)addr, 8192);
     76e:	8652                	mv	a2,s4
     770:	85ce                	mv	a1,s3
     772:	f9842503          	lw	a0,-104(s0)
     776:	00006097          	auipc	ra,0x6
     77a:	efe080e7          	jalr	-258(ra) # 6674 <read>
    if(n > 0){
     77e:	0aa04563          	bgtz	a0,828 <copyout+0x14e>
    close(fds[0]);
     782:	f9842503          	lw	a0,-104(s0)
     786:	00006097          	auipc	ra,0x6
     78a:	efe080e7          	jalr	-258(ra) # 6684 <close>
    close(fds[1]);
     78e:	f9c42503          	lw	a0,-100(s0)
     792:	00006097          	auipc	ra,0x6
     796:	ef2080e7          	jalr	-270(ra) # 6684 <close>
  for(int ai = 0; ai < 2; ai++){
     79a:	0921                	addi	s2,s2,8
     79c:	fb040793          	addi	a5,s0,-80
     7a0:	f6f91ee3          	bne	s2,a5,71c <copyout+0x42>
}
     7a4:	70a6                	ld	ra,104(sp)
     7a6:	7406                	ld	s0,96(sp)
     7a8:	64e6                	ld	s1,88(sp)
     7aa:	6946                	ld	s2,80(sp)
     7ac:	69a6                	ld	s3,72(sp)
     7ae:	6a06                	ld	s4,64(sp)
     7b0:	7ae2                	ld	s5,56(sp)
     7b2:	7b42                	ld	s6,48(sp)
     7b4:	7ba2                	ld	s7,40(sp)
     7b6:	7c02                	ld	s8,32(sp)
     7b8:	6165                	addi	sp,sp,112
     7ba:	8082                	ret
      printf("open(README) failed\n");
     7bc:	00006517          	auipc	a0,0x6
     7c0:	5ec50513          	addi	a0,a0,1516 # 6da8 <malloc+0x312>
     7c4:	00006097          	auipc	ra,0x6
     7c8:	216080e7          	jalr	534(ra) # 69da <printf>
      exit(1);
     7cc:	4505                	li	a0,1
     7ce:	00006097          	auipc	ra,0x6
     7d2:	e8e080e7          	jalr	-370(ra) # 665c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7d6:	862a                	mv	a2,a0
     7d8:	85ce                	mv	a1,s3
     7da:	00006517          	auipc	a0,0x6
     7de:	5e650513          	addi	a0,a0,1510 # 6dc0 <malloc+0x32a>
     7e2:	00006097          	auipc	ra,0x6
     7e6:	1f8080e7          	jalr	504(ra) # 69da <printf>
      exit(1);
     7ea:	4505                	li	a0,1
     7ec:	00006097          	auipc	ra,0x6
     7f0:	e70080e7          	jalr	-400(ra) # 665c <exit>
      printf("pipe() failed\n");
     7f4:	00006517          	auipc	a0,0x6
     7f8:	56c50513          	addi	a0,a0,1388 # 6d60 <malloc+0x2ca>
     7fc:	00006097          	auipc	ra,0x6
     800:	1de080e7          	jalr	478(ra) # 69da <printf>
      exit(1);
     804:	4505                	li	a0,1
     806:	00006097          	auipc	ra,0x6
     80a:	e56080e7          	jalr	-426(ra) # 665c <exit>
      printf("pipe write failed\n");
     80e:	00006517          	auipc	a0,0x6
     812:	5e250513          	addi	a0,a0,1506 # 6df0 <malloc+0x35a>
     816:	00006097          	auipc	ra,0x6
     81a:	1c4080e7          	jalr	452(ra) # 69da <printf>
      exit(1);
     81e:	4505                	li	a0,1
     820:	00006097          	auipc	ra,0x6
     824:	e3c080e7          	jalr	-452(ra) # 665c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     828:	862a                	mv	a2,a0
     82a:	85ce                	mv	a1,s3
     82c:	00006517          	auipc	a0,0x6
     830:	5dc50513          	addi	a0,a0,1500 # 6e08 <malloc+0x372>
     834:	00006097          	auipc	ra,0x6
     838:	1a6080e7          	jalr	422(ra) # 69da <printf>
      exit(1);
     83c:	4505                	li	a0,1
     83e:	00006097          	auipc	ra,0x6
     842:	e1e080e7          	jalr	-482(ra) # 665c <exit>

0000000000000846 <truncate1>:
{
     846:	711d                	addi	sp,sp,-96
     848:	ec86                	sd	ra,88(sp)
     84a:	e8a2                	sd	s0,80(sp)
     84c:	e4a6                	sd	s1,72(sp)
     84e:	e0ca                	sd	s2,64(sp)
     850:	fc4e                	sd	s3,56(sp)
     852:	f852                	sd	s4,48(sp)
     854:	f456                	sd	s5,40(sp)
     856:	1080                	addi	s0,sp,96
     858:	8a2a                	mv	s4,a0
  unlink("truncfile");
     85a:	00006517          	auipc	a0,0x6
     85e:	3c650513          	addi	a0,a0,966 # 6c20 <malloc+0x18a>
     862:	00006097          	auipc	ra,0x6
     866:	e4a080e7          	jalr	-438(ra) # 66ac <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     86a:	60100593          	li	a1,1537
     86e:	00006517          	auipc	a0,0x6
     872:	3b250513          	addi	a0,a0,946 # 6c20 <malloc+0x18a>
     876:	00006097          	auipc	ra,0x6
     87a:	e26080e7          	jalr	-474(ra) # 669c <open>
     87e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     880:	4611                	li	a2,4
     882:	00006597          	auipc	a1,0x6
     886:	3ae58593          	addi	a1,a1,942 # 6c30 <malloc+0x19a>
     88a:	00006097          	auipc	ra,0x6
     88e:	df2080e7          	jalr	-526(ra) # 667c <write>
  close(fd1);
     892:	8526                	mv	a0,s1
     894:	00006097          	auipc	ra,0x6
     898:	df0080e7          	jalr	-528(ra) # 6684 <close>
  int fd2 = open("truncfile", O_RDONLY);
     89c:	4581                	li	a1,0
     89e:	00006517          	auipc	a0,0x6
     8a2:	38250513          	addi	a0,a0,898 # 6c20 <malloc+0x18a>
     8a6:	00006097          	auipc	ra,0x6
     8aa:	df6080e7          	jalr	-522(ra) # 669c <open>
     8ae:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     8b0:	02000613          	li	a2,32
     8b4:	fa040593          	addi	a1,s0,-96
     8b8:	00006097          	auipc	ra,0x6
     8bc:	dbc080e7          	jalr	-580(ra) # 6674 <read>
  if(n != 4){
     8c0:	4791                	li	a5,4
     8c2:	0cf51e63          	bne	a0,a5,99e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     8c6:	40100593          	li	a1,1025
     8ca:	00006517          	auipc	a0,0x6
     8ce:	35650513          	addi	a0,a0,854 # 6c20 <malloc+0x18a>
     8d2:	00006097          	auipc	ra,0x6
     8d6:	dca080e7          	jalr	-566(ra) # 669c <open>
     8da:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     8dc:	4581                	li	a1,0
     8de:	00006517          	auipc	a0,0x6
     8e2:	34250513          	addi	a0,a0,834 # 6c20 <malloc+0x18a>
     8e6:	00006097          	auipc	ra,0x6
     8ea:	db6080e7          	jalr	-586(ra) # 669c <open>
     8ee:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     8f0:	02000613          	li	a2,32
     8f4:	fa040593          	addi	a1,s0,-96
     8f8:	00006097          	auipc	ra,0x6
     8fc:	d7c080e7          	jalr	-644(ra) # 6674 <read>
     900:	8aaa                	mv	s5,a0
  if(n != 0){
     902:	ed4d                	bnez	a0,9bc <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     904:	02000613          	li	a2,32
     908:	fa040593          	addi	a1,s0,-96
     90c:	8526                	mv	a0,s1
     90e:	00006097          	auipc	ra,0x6
     912:	d66080e7          	jalr	-666(ra) # 6674 <read>
     916:	8aaa                	mv	s5,a0
  if(n != 0){
     918:	e971                	bnez	a0,9ec <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     91a:	4619                	li	a2,6
     91c:	00006597          	auipc	a1,0x6
     920:	57c58593          	addi	a1,a1,1404 # 6e98 <malloc+0x402>
     924:	854e                	mv	a0,s3
     926:	00006097          	auipc	ra,0x6
     92a:	d56080e7          	jalr	-682(ra) # 667c <write>
  n = read(fd3, buf, sizeof(buf));
     92e:	02000613          	li	a2,32
     932:	fa040593          	addi	a1,s0,-96
     936:	854a                	mv	a0,s2
     938:	00006097          	auipc	ra,0x6
     93c:	d3c080e7          	jalr	-708(ra) # 6674 <read>
  if(n != 6){
     940:	4799                	li	a5,6
     942:	0cf51d63          	bne	a0,a5,a1c <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     946:	02000613          	li	a2,32
     94a:	fa040593          	addi	a1,s0,-96
     94e:	8526                	mv	a0,s1
     950:	00006097          	auipc	ra,0x6
     954:	d24080e7          	jalr	-732(ra) # 6674 <read>
  if(n != 2){
     958:	4789                	li	a5,2
     95a:	0ef51063          	bne	a0,a5,a3a <truncate1+0x1f4>
  unlink("truncfile");
     95e:	00006517          	auipc	a0,0x6
     962:	2c250513          	addi	a0,a0,706 # 6c20 <malloc+0x18a>
     966:	00006097          	auipc	ra,0x6
     96a:	d46080e7          	jalr	-698(ra) # 66ac <unlink>
  close(fd1);
     96e:	854e                	mv	a0,s3
     970:	00006097          	auipc	ra,0x6
     974:	d14080e7          	jalr	-748(ra) # 6684 <close>
  close(fd2);
     978:	8526                	mv	a0,s1
     97a:	00006097          	auipc	ra,0x6
     97e:	d0a080e7          	jalr	-758(ra) # 6684 <close>
  close(fd3);
     982:	854a                	mv	a0,s2
     984:	00006097          	auipc	ra,0x6
     988:	d00080e7          	jalr	-768(ra) # 6684 <close>
}
     98c:	60e6                	ld	ra,88(sp)
     98e:	6446                	ld	s0,80(sp)
     990:	64a6                	ld	s1,72(sp)
     992:	6906                	ld	s2,64(sp)
     994:	79e2                	ld	s3,56(sp)
     996:	7a42                	ld	s4,48(sp)
     998:	7aa2                	ld	s5,40(sp)
     99a:	6125                	addi	sp,sp,96
     99c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     99e:	862a                	mv	a2,a0
     9a0:	85d2                	mv	a1,s4
     9a2:	00006517          	auipc	a0,0x6
     9a6:	49650513          	addi	a0,a0,1174 # 6e38 <malloc+0x3a2>
     9aa:	00006097          	auipc	ra,0x6
     9ae:	030080e7          	jalr	48(ra) # 69da <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00006097          	auipc	ra,0x6
     9b8:	ca8080e7          	jalr	-856(ra) # 665c <exit>
    printf("aaa fd3=%d\n", fd3);
     9bc:	85ca                	mv	a1,s2
     9be:	00006517          	auipc	a0,0x6
     9c2:	49a50513          	addi	a0,a0,1178 # 6e58 <malloc+0x3c2>
     9c6:	00006097          	auipc	ra,0x6
     9ca:	014080e7          	jalr	20(ra) # 69da <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9ce:	8656                	mv	a2,s5
     9d0:	85d2                	mv	a1,s4
     9d2:	00006517          	auipc	a0,0x6
     9d6:	49650513          	addi	a0,a0,1174 # 6e68 <malloc+0x3d2>
     9da:	00006097          	auipc	ra,0x6
     9de:	000080e7          	jalr	ra # 69da <printf>
    exit(1);
     9e2:	4505                	li	a0,1
     9e4:	00006097          	auipc	ra,0x6
     9e8:	c78080e7          	jalr	-904(ra) # 665c <exit>
    printf("bbb fd2=%d\n", fd2);
     9ec:	85a6                	mv	a1,s1
     9ee:	00006517          	auipc	a0,0x6
     9f2:	49a50513          	addi	a0,a0,1178 # 6e88 <malloc+0x3f2>
     9f6:	00006097          	auipc	ra,0x6
     9fa:	fe4080e7          	jalr	-28(ra) # 69da <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9fe:	8656                	mv	a2,s5
     a00:	85d2                	mv	a1,s4
     a02:	00006517          	auipc	a0,0x6
     a06:	46650513          	addi	a0,a0,1126 # 6e68 <malloc+0x3d2>
     a0a:	00006097          	auipc	ra,0x6
     a0e:	fd0080e7          	jalr	-48(ra) # 69da <printf>
    exit(1);
     a12:	4505                	li	a0,1
     a14:	00006097          	auipc	ra,0x6
     a18:	c48080e7          	jalr	-952(ra) # 665c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a1c:	862a                	mv	a2,a0
     a1e:	85d2                	mv	a1,s4
     a20:	00006517          	auipc	a0,0x6
     a24:	48050513          	addi	a0,a0,1152 # 6ea0 <malloc+0x40a>
     a28:	00006097          	auipc	ra,0x6
     a2c:	fb2080e7          	jalr	-78(ra) # 69da <printf>
    exit(1);
     a30:	4505                	li	a0,1
     a32:	00006097          	auipc	ra,0x6
     a36:	c2a080e7          	jalr	-982(ra) # 665c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     a3a:	862a                	mv	a2,a0
     a3c:	85d2                	mv	a1,s4
     a3e:	00006517          	auipc	a0,0x6
     a42:	48250513          	addi	a0,a0,1154 # 6ec0 <malloc+0x42a>
     a46:	00006097          	auipc	ra,0x6
     a4a:	f94080e7          	jalr	-108(ra) # 69da <printf>
    exit(1);
     a4e:	4505                	li	a0,1
     a50:	00006097          	auipc	ra,0x6
     a54:	c0c080e7          	jalr	-1012(ra) # 665c <exit>

0000000000000a58 <writetest>:
{
     a58:	715d                	addi	sp,sp,-80
     a5a:	e486                	sd	ra,72(sp)
     a5c:	e0a2                	sd	s0,64(sp)
     a5e:	fc26                	sd	s1,56(sp)
     a60:	f84a                	sd	s2,48(sp)
     a62:	f44e                	sd	s3,40(sp)
     a64:	f052                	sd	s4,32(sp)
     a66:	ec56                	sd	s5,24(sp)
     a68:	e85a                	sd	s6,16(sp)
     a6a:	e45e                	sd	s7,8(sp)
     a6c:	0880                	addi	s0,sp,80
     a6e:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     a70:	20200593          	li	a1,514
     a74:	00006517          	auipc	a0,0x6
     a78:	46c50513          	addi	a0,a0,1132 # 6ee0 <malloc+0x44a>
     a7c:	00006097          	auipc	ra,0x6
     a80:	c20080e7          	jalr	-992(ra) # 669c <open>
  if(fd < 0){
     a84:	0a054d63          	bltz	a0,b3e <writetest+0xe6>
     a88:	89aa                	mv	s3,a0
     a8a:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a8c:	44a9                	li	s1,10
     a8e:	00006a17          	auipc	s4,0x6
     a92:	47aa0a13          	addi	s4,s4,1146 # 6f08 <malloc+0x472>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a96:	00006b17          	auipc	s6,0x6
     a9a:	4aab0b13          	addi	s6,s6,1194 # 6f40 <malloc+0x4aa>
  for(i = 0; i < N; i++){
     a9e:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     aa2:	8626                	mv	a2,s1
     aa4:	85d2                	mv	a1,s4
     aa6:	854e                	mv	a0,s3
     aa8:	00006097          	auipc	ra,0x6
     aac:	bd4080e7          	jalr	-1068(ra) # 667c <write>
     ab0:	0a951563          	bne	a0,s1,b5a <writetest+0x102>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     ab4:	8626                	mv	a2,s1
     ab6:	85da                	mv	a1,s6
     ab8:	854e                	mv	a0,s3
     aba:	00006097          	auipc	ra,0x6
     abe:	bc2080e7          	jalr	-1086(ra) # 667c <write>
     ac2:	0a951b63          	bne	a0,s1,b78 <writetest+0x120>
  for(i = 0; i < N; i++){
     ac6:	2905                	addiw	s2,s2,1
     ac8:	fd591de3          	bne	s2,s5,aa2 <writetest+0x4a>
  close(fd);
     acc:	854e                	mv	a0,s3
     ace:	00006097          	auipc	ra,0x6
     ad2:	bb6080e7          	jalr	-1098(ra) # 6684 <close>
  fd = open("small", O_RDONLY);
     ad6:	4581                	li	a1,0
     ad8:	00006517          	auipc	a0,0x6
     adc:	40850513          	addi	a0,a0,1032 # 6ee0 <malloc+0x44a>
     ae0:	00006097          	auipc	ra,0x6
     ae4:	bbc080e7          	jalr	-1092(ra) # 669c <open>
     ae8:	84aa                	mv	s1,a0
  if(fd < 0){
     aea:	0a054663          	bltz	a0,b96 <writetest+0x13e>
  i = read(fd, buf, N*SZ*2);
     aee:	7d000613          	li	a2,2000
     af2:	0000d597          	auipc	a1,0xd
     af6:	19658593          	addi	a1,a1,406 # dc88 <buf>
     afa:	00006097          	auipc	ra,0x6
     afe:	b7a080e7          	jalr	-1158(ra) # 6674 <read>
  if(i != N*SZ*2){
     b02:	7d000793          	li	a5,2000
     b06:	0af51663          	bne	a0,a5,bb2 <writetest+0x15a>
  close(fd);
     b0a:	8526                	mv	a0,s1
     b0c:	00006097          	auipc	ra,0x6
     b10:	b78080e7          	jalr	-1160(ra) # 6684 <close>
  if(unlink("small") < 0){
     b14:	00006517          	auipc	a0,0x6
     b18:	3cc50513          	addi	a0,a0,972 # 6ee0 <malloc+0x44a>
     b1c:	00006097          	auipc	ra,0x6
     b20:	b90080e7          	jalr	-1136(ra) # 66ac <unlink>
     b24:	0a054563          	bltz	a0,bce <writetest+0x176>
}
     b28:	60a6                	ld	ra,72(sp)
     b2a:	6406                	ld	s0,64(sp)
     b2c:	74e2                	ld	s1,56(sp)
     b2e:	7942                	ld	s2,48(sp)
     b30:	79a2                	ld	s3,40(sp)
     b32:	7a02                	ld	s4,32(sp)
     b34:	6ae2                	ld	s5,24(sp)
     b36:	6b42                	ld	s6,16(sp)
     b38:	6ba2                	ld	s7,8(sp)
     b3a:	6161                	addi	sp,sp,80
     b3c:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     b3e:	85de                	mv	a1,s7
     b40:	00006517          	auipc	a0,0x6
     b44:	3a850513          	addi	a0,a0,936 # 6ee8 <malloc+0x452>
     b48:	00006097          	auipc	ra,0x6
     b4c:	e92080e7          	jalr	-366(ra) # 69da <printf>
    exit(1);
     b50:	4505                	li	a0,1
     b52:	00006097          	auipc	ra,0x6
     b56:	b0a080e7          	jalr	-1270(ra) # 665c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b5a:	864a                	mv	a2,s2
     b5c:	85de                	mv	a1,s7
     b5e:	00006517          	auipc	a0,0x6
     b62:	3ba50513          	addi	a0,a0,954 # 6f18 <malloc+0x482>
     b66:	00006097          	auipc	ra,0x6
     b6a:	e74080e7          	jalr	-396(ra) # 69da <printf>
      exit(1);
     b6e:	4505                	li	a0,1
     b70:	00006097          	auipc	ra,0x6
     b74:	aec080e7          	jalr	-1300(ra) # 665c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b78:	864a                	mv	a2,s2
     b7a:	85de                	mv	a1,s7
     b7c:	00006517          	auipc	a0,0x6
     b80:	3d450513          	addi	a0,a0,980 # 6f50 <malloc+0x4ba>
     b84:	00006097          	auipc	ra,0x6
     b88:	e56080e7          	jalr	-426(ra) # 69da <printf>
      exit(1);
     b8c:	4505                	li	a0,1
     b8e:	00006097          	auipc	ra,0x6
     b92:	ace080e7          	jalr	-1330(ra) # 665c <exit>
    printf("%s: error: open small failed!\n", s);
     b96:	85de                	mv	a1,s7
     b98:	00006517          	auipc	a0,0x6
     b9c:	3e050513          	addi	a0,a0,992 # 6f78 <malloc+0x4e2>
     ba0:	00006097          	auipc	ra,0x6
     ba4:	e3a080e7          	jalr	-454(ra) # 69da <printf>
    exit(1);
     ba8:	4505                	li	a0,1
     baa:	00006097          	auipc	ra,0x6
     bae:	ab2080e7          	jalr	-1358(ra) # 665c <exit>
    printf("%s: read failed\n", s);
     bb2:	85de                	mv	a1,s7
     bb4:	00006517          	auipc	a0,0x6
     bb8:	3e450513          	addi	a0,a0,996 # 6f98 <malloc+0x502>
     bbc:	00006097          	auipc	ra,0x6
     bc0:	e1e080e7          	jalr	-482(ra) # 69da <printf>
    exit(1);
     bc4:	4505                	li	a0,1
     bc6:	00006097          	auipc	ra,0x6
     bca:	a96080e7          	jalr	-1386(ra) # 665c <exit>
    printf("%s: unlink small failed\n", s);
     bce:	85de                	mv	a1,s7
     bd0:	00006517          	auipc	a0,0x6
     bd4:	3e050513          	addi	a0,a0,992 # 6fb0 <malloc+0x51a>
     bd8:	00006097          	auipc	ra,0x6
     bdc:	e02080e7          	jalr	-510(ra) # 69da <printf>
    exit(1);
     be0:	4505                	li	a0,1
     be2:	00006097          	auipc	ra,0x6
     be6:	a7a080e7          	jalr	-1414(ra) # 665c <exit>

0000000000000bea <writebig>:
{
     bea:	7139                	addi	sp,sp,-64
     bec:	fc06                	sd	ra,56(sp)
     bee:	f822                	sd	s0,48(sp)
     bf0:	f426                	sd	s1,40(sp)
     bf2:	f04a                	sd	s2,32(sp)
     bf4:	ec4e                	sd	s3,24(sp)
     bf6:	e852                	sd	s4,16(sp)
     bf8:	e456                	sd	s5,8(sp)
     bfa:	e05a                	sd	s6,0(sp)
     bfc:	0080                	addi	s0,sp,64
     bfe:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     c00:	20200593          	li	a1,514
     c04:	00006517          	auipc	a0,0x6
     c08:	3cc50513          	addi	a0,a0,972 # 6fd0 <malloc+0x53a>
     c0c:	00006097          	auipc	ra,0x6
     c10:	a90080e7          	jalr	-1392(ra) # 669c <open>
  if(fd < 0){
     c14:	08054263          	bltz	a0,c98 <writebig+0xae>
     c18:	8a2a                	mv	s4,a0
     c1a:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     c1c:	0000d997          	auipc	s3,0xd
     c20:	06c98993          	addi	s3,s3,108 # dc88 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     c24:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     c28:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     c2c:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     c30:	864a                	mv	a2,s2
     c32:	85ce                	mv	a1,s3
     c34:	8552                	mv	a0,s4
     c36:	00006097          	auipc	ra,0x6
     c3a:	a46080e7          	jalr	-1466(ra) # 667c <write>
     c3e:	07251b63          	bne	a0,s2,cb4 <writebig+0xca>
  for(i = 0; i < MAXFILE; i++){
     c42:	2485                	addiw	s1,s1,1
     c44:	ff5494e3          	bne	s1,s5,c2c <writebig+0x42>
  close(fd);
     c48:	8552                	mv	a0,s4
     c4a:	00006097          	auipc	ra,0x6
     c4e:	a3a080e7          	jalr	-1478(ra) # 6684 <close>
  fd = open("big", O_RDONLY);
     c52:	4581                	li	a1,0
     c54:	00006517          	auipc	a0,0x6
     c58:	37c50513          	addi	a0,a0,892 # 6fd0 <malloc+0x53a>
     c5c:	00006097          	auipc	ra,0x6
     c60:	a40080e7          	jalr	-1472(ra) # 669c <open>
     c64:	8a2a                	mv	s4,a0
  n = 0;
     c66:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c68:	40000993          	li	s3,1024
     c6c:	0000d917          	auipc	s2,0xd
     c70:	01c90913          	addi	s2,s2,28 # dc88 <buf>
  if(fd < 0){
     c74:	04054f63          	bltz	a0,cd2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     c78:	864e                	mv	a2,s3
     c7a:	85ca                	mv	a1,s2
     c7c:	8552                	mv	a0,s4
     c7e:	00006097          	auipc	ra,0x6
     c82:	9f6080e7          	jalr	-1546(ra) # 6674 <read>
    if(i == 0){
     c86:	c525                	beqz	a0,cee <writebig+0x104>
    } else if(i != BSIZE){
     c88:	0b351f63          	bne	a0,s3,d46 <writebig+0x15c>
    if(((int*)buf)[0] != n){
     c8c:	00092683          	lw	a3,0(s2)
     c90:	0c969a63          	bne	a3,s1,d64 <writebig+0x17a>
    n++;
     c94:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c96:	b7cd                	j	c78 <writebig+0x8e>
    printf("%s: error: creat big failed!\n", s);
     c98:	85da                	mv	a1,s6
     c9a:	00006517          	auipc	a0,0x6
     c9e:	33e50513          	addi	a0,a0,830 # 6fd8 <malloc+0x542>
     ca2:	00006097          	auipc	ra,0x6
     ca6:	d38080e7          	jalr	-712(ra) # 69da <printf>
    exit(1);
     caa:	4505                	li	a0,1
     cac:	00006097          	auipc	ra,0x6
     cb0:	9b0080e7          	jalr	-1616(ra) # 665c <exit>
      printf("%s: error: write big file failed\n", s, i);
     cb4:	8626                	mv	a2,s1
     cb6:	85da                	mv	a1,s6
     cb8:	00006517          	auipc	a0,0x6
     cbc:	34050513          	addi	a0,a0,832 # 6ff8 <malloc+0x562>
     cc0:	00006097          	auipc	ra,0x6
     cc4:	d1a080e7          	jalr	-742(ra) # 69da <printf>
      exit(1);
     cc8:	4505                	li	a0,1
     cca:	00006097          	auipc	ra,0x6
     cce:	992080e7          	jalr	-1646(ra) # 665c <exit>
    printf("%s: error: open big failed!\n", s);
     cd2:	85da                	mv	a1,s6
     cd4:	00006517          	auipc	a0,0x6
     cd8:	34c50513          	addi	a0,a0,844 # 7020 <malloc+0x58a>
     cdc:	00006097          	auipc	ra,0x6
     ce0:	cfe080e7          	jalr	-770(ra) # 69da <printf>
    exit(1);
     ce4:	4505                	li	a0,1
     ce6:	00006097          	auipc	ra,0x6
     cea:	976080e7          	jalr	-1674(ra) # 665c <exit>
      if(n == MAXFILE - 1){
     cee:	10b00793          	li	a5,267
     cf2:	02f48b63          	beq	s1,a5,d28 <writebig+0x13e>
  close(fd);
     cf6:	8552                	mv	a0,s4
     cf8:	00006097          	auipc	ra,0x6
     cfc:	98c080e7          	jalr	-1652(ra) # 6684 <close>
  if(unlink("big") < 0){
     d00:	00006517          	auipc	a0,0x6
     d04:	2d050513          	addi	a0,a0,720 # 6fd0 <malloc+0x53a>
     d08:	00006097          	auipc	ra,0x6
     d0c:	9a4080e7          	jalr	-1628(ra) # 66ac <unlink>
     d10:	06054963          	bltz	a0,d82 <writebig+0x198>
}
     d14:	70e2                	ld	ra,56(sp)
     d16:	7442                	ld	s0,48(sp)
     d18:	74a2                	ld	s1,40(sp)
     d1a:	7902                	ld	s2,32(sp)
     d1c:	69e2                	ld	s3,24(sp)
     d1e:	6a42                	ld	s4,16(sp)
     d20:	6aa2                	ld	s5,8(sp)
     d22:	6b02                	ld	s6,0(sp)
     d24:	6121                	addi	sp,sp,64
     d26:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     d28:	8626                	mv	a2,s1
     d2a:	85da                	mv	a1,s6
     d2c:	00006517          	auipc	a0,0x6
     d30:	31450513          	addi	a0,a0,788 # 7040 <malloc+0x5aa>
     d34:	00006097          	auipc	ra,0x6
     d38:	ca6080e7          	jalr	-858(ra) # 69da <printf>
        exit(1);
     d3c:	4505                	li	a0,1
     d3e:	00006097          	auipc	ra,0x6
     d42:	91e080e7          	jalr	-1762(ra) # 665c <exit>
      printf("%s: read failed %d\n", s, i);
     d46:	862a                	mv	a2,a0
     d48:	85da                	mv	a1,s6
     d4a:	00006517          	auipc	a0,0x6
     d4e:	31e50513          	addi	a0,a0,798 # 7068 <malloc+0x5d2>
     d52:	00006097          	auipc	ra,0x6
     d56:	c88080e7          	jalr	-888(ra) # 69da <printf>
      exit(1);
     d5a:	4505                	li	a0,1
     d5c:	00006097          	auipc	ra,0x6
     d60:	900080e7          	jalr	-1792(ra) # 665c <exit>
      printf("%s: read content of block %d is %d\n", s,
     d64:	8626                	mv	a2,s1
     d66:	85da                	mv	a1,s6
     d68:	00006517          	auipc	a0,0x6
     d6c:	31850513          	addi	a0,a0,792 # 7080 <malloc+0x5ea>
     d70:	00006097          	auipc	ra,0x6
     d74:	c6a080e7          	jalr	-918(ra) # 69da <printf>
      exit(1);
     d78:	4505                	li	a0,1
     d7a:	00006097          	auipc	ra,0x6
     d7e:	8e2080e7          	jalr	-1822(ra) # 665c <exit>
    printf("%s: unlink big failed\n", s);
     d82:	85da                	mv	a1,s6
     d84:	00006517          	auipc	a0,0x6
     d88:	32450513          	addi	a0,a0,804 # 70a8 <malloc+0x612>
     d8c:	00006097          	auipc	ra,0x6
     d90:	c4e080e7          	jalr	-946(ra) # 69da <printf>
    exit(1);
     d94:	4505                	li	a0,1
     d96:	00006097          	auipc	ra,0x6
     d9a:	8c6080e7          	jalr	-1850(ra) # 665c <exit>

0000000000000d9e <unlinkread>:
{
     d9e:	7179                	addi	sp,sp,-48
     da0:	f406                	sd	ra,40(sp)
     da2:	f022                	sd	s0,32(sp)
     da4:	ec26                	sd	s1,24(sp)
     da6:	e84a                	sd	s2,16(sp)
     da8:	e44e                	sd	s3,8(sp)
     daa:	1800                	addi	s0,sp,48
     dac:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	30e50513          	addi	a0,a0,782 # 70c0 <malloc+0x62a>
     dba:	00006097          	auipc	ra,0x6
     dbe:	8e2080e7          	jalr	-1822(ra) # 669c <open>
  if(fd < 0){
     dc2:	0e054563          	bltz	a0,eac <unlinkread+0x10e>
     dc6:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     dc8:	4615                	li	a2,5
     dca:	00006597          	auipc	a1,0x6
     dce:	32658593          	addi	a1,a1,806 # 70f0 <malloc+0x65a>
     dd2:	00006097          	auipc	ra,0x6
     dd6:	8aa080e7          	jalr	-1878(ra) # 667c <write>
  close(fd);
     dda:	8526                	mv	a0,s1
     ddc:	00006097          	auipc	ra,0x6
     de0:	8a8080e7          	jalr	-1880(ra) # 6684 <close>
  fd = open("unlinkread", O_RDWR);
     de4:	4589                	li	a1,2
     de6:	00006517          	auipc	a0,0x6
     dea:	2da50513          	addi	a0,a0,730 # 70c0 <malloc+0x62a>
     dee:	00006097          	auipc	ra,0x6
     df2:	8ae080e7          	jalr	-1874(ra) # 669c <open>
     df6:	84aa                	mv	s1,a0
  if(fd < 0){
     df8:	0c054863          	bltz	a0,ec8 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     dfc:	00006517          	auipc	a0,0x6
     e00:	2c450513          	addi	a0,a0,708 # 70c0 <malloc+0x62a>
     e04:	00006097          	auipc	ra,0x6
     e08:	8a8080e7          	jalr	-1880(ra) # 66ac <unlink>
     e0c:	ed61                	bnez	a0,ee4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     e0e:	20200593          	li	a1,514
     e12:	00006517          	auipc	a0,0x6
     e16:	2ae50513          	addi	a0,a0,686 # 70c0 <malloc+0x62a>
     e1a:	00006097          	auipc	ra,0x6
     e1e:	882080e7          	jalr	-1918(ra) # 669c <open>
     e22:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     e24:	460d                	li	a2,3
     e26:	00006597          	auipc	a1,0x6
     e2a:	31258593          	addi	a1,a1,786 # 7138 <malloc+0x6a2>
     e2e:	00006097          	auipc	ra,0x6
     e32:	84e080e7          	jalr	-1970(ra) # 667c <write>
  close(fd1);
     e36:	854a                	mv	a0,s2
     e38:	00006097          	auipc	ra,0x6
     e3c:	84c080e7          	jalr	-1972(ra) # 6684 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     e40:	660d                	lui	a2,0x3
     e42:	0000d597          	auipc	a1,0xd
     e46:	e4658593          	addi	a1,a1,-442 # dc88 <buf>
     e4a:	8526                	mv	a0,s1
     e4c:	00006097          	auipc	ra,0x6
     e50:	828080e7          	jalr	-2008(ra) # 6674 <read>
     e54:	4795                	li	a5,5
     e56:	0af51563          	bne	a0,a5,f00 <unlinkread+0x162>
  if(buf[0] != 'h'){
     e5a:	0000d717          	auipc	a4,0xd
     e5e:	e2e74703          	lbu	a4,-466(a4) # dc88 <buf>
     e62:	06800793          	li	a5,104
     e66:	0af71b63          	bne	a4,a5,f1c <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e6a:	4629                	li	a2,10
     e6c:	0000d597          	auipc	a1,0xd
     e70:	e1c58593          	addi	a1,a1,-484 # dc88 <buf>
     e74:	8526                	mv	a0,s1
     e76:	00006097          	auipc	ra,0x6
     e7a:	806080e7          	jalr	-2042(ra) # 667c <write>
     e7e:	47a9                	li	a5,10
     e80:	0af51c63          	bne	a0,a5,f38 <unlinkread+0x19a>
  close(fd);
     e84:	8526                	mv	a0,s1
     e86:	00005097          	auipc	ra,0x5
     e8a:	7fe080e7          	jalr	2046(ra) # 6684 <close>
  unlink("unlinkread");
     e8e:	00006517          	auipc	a0,0x6
     e92:	23250513          	addi	a0,a0,562 # 70c0 <malloc+0x62a>
     e96:	00006097          	auipc	ra,0x6
     e9a:	816080e7          	jalr	-2026(ra) # 66ac <unlink>
}
     e9e:	70a2                	ld	ra,40(sp)
     ea0:	7402                	ld	s0,32(sp)
     ea2:	64e2                	ld	s1,24(sp)
     ea4:	6942                	ld	s2,16(sp)
     ea6:	69a2                	ld	s3,8(sp)
     ea8:	6145                	addi	sp,sp,48
     eaa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     eac:	85ce                	mv	a1,s3
     eae:	00006517          	auipc	a0,0x6
     eb2:	22250513          	addi	a0,a0,546 # 70d0 <malloc+0x63a>
     eb6:	00006097          	auipc	ra,0x6
     eba:	b24080e7          	jalr	-1244(ra) # 69da <printf>
    exit(1);
     ebe:	4505                	li	a0,1
     ec0:	00005097          	auipc	ra,0x5
     ec4:	79c080e7          	jalr	1948(ra) # 665c <exit>
    printf("%s: open unlinkread failed\n", s);
     ec8:	85ce                	mv	a1,s3
     eca:	00006517          	auipc	a0,0x6
     ece:	22e50513          	addi	a0,a0,558 # 70f8 <malloc+0x662>
     ed2:	00006097          	auipc	ra,0x6
     ed6:	b08080e7          	jalr	-1272(ra) # 69da <printf>
    exit(1);
     eda:	4505                	li	a0,1
     edc:	00005097          	auipc	ra,0x5
     ee0:	780080e7          	jalr	1920(ra) # 665c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ee4:	85ce                	mv	a1,s3
     ee6:	00006517          	auipc	a0,0x6
     eea:	23250513          	addi	a0,a0,562 # 7118 <malloc+0x682>
     eee:	00006097          	auipc	ra,0x6
     ef2:	aec080e7          	jalr	-1300(ra) # 69da <printf>
    exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00005097          	auipc	ra,0x5
     efc:	764080e7          	jalr	1892(ra) # 665c <exit>
    printf("%s: unlinkread read failed", s);
     f00:	85ce                	mv	a1,s3
     f02:	00006517          	auipc	a0,0x6
     f06:	23e50513          	addi	a0,a0,574 # 7140 <malloc+0x6aa>
     f0a:	00006097          	auipc	ra,0x6
     f0e:	ad0080e7          	jalr	-1328(ra) # 69da <printf>
    exit(1);
     f12:	4505                	li	a0,1
     f14:	00005097          	auipc	ra,0x5
     f18:	748080e7          	jalr	1864(ra) # 665c <exit>
    printf("%s: unlinkread wrong data\n", s);
     f1c:	85ce                	mv	a1,s3
     f1e:	00006517          	auipc	a0,0x6
     f22:	24250513          	addi	a0,a0,578 # 7160 <malloc+0x6ca>
     f26:	00006097          	auipc	ra,0x6
     f2a:	ab4080e7          	jalr	-1356(ra) # 69da <printf>
    exit(1);
     f2e:	4505                	li	a0,1
     f30:	00005097          	auipc	ra,0x5
     f34:	72c080e7          	jalr	1836(ra) # 665c <exit>
    printf("%s: unlinkread write failed\n", s);
     f38:	85ce                	mv	a1,s3
     f3a:	00006517          	auipc	a0,0x6
     f3e:	24650513          	addi	a0,a0,582 # 7180 <malloc+0x6ea>
     f42:	00006097          	auipc	ra,0x6
     f46:	a98080e7          	jalr	-1384(ra) # 69da <printf>
    exit(1);
     f4a:	4505                	li	a0,1
     f4c:	00005097          	auipc	ra,0x5
     f50:	710080e7          	jalr	1808(ra) # 665c <exit>

0000000000000f54 <linktest>:
{
     f54:	1101                	addi	sp,sp,-32
     f56:	ec06                	sd	ra,24(sp)
     f58:	e822                	sd	s0,16(sp)
     f5a:	e426                	sd	s1,8(sp)
     f5c:	e04a                	sd	s2,0(sp)
     f5e:	1000                	addi	s0,sp,32
     f60:	892a                	mv	s2,a0
  unlink("lf1");
     f62:	00006517          	auipc	a0,0x6
     f66:	23e50513          	addi	a0,a0,574 # 71a0 <malloc+0x70a>
     f6a:	00005097          	auipc	ra,0x5
     f6e:	742080e7          	jalr	1858(ra) # 66ac <unlink>
  unlink("lf2");
     f72:	00006517          	auipc	a0,0x6
     f76:	23650513          	addi	a0,a0,566 # 71a8 <malloc+0x712>
     f7a:	00005097          	auipc	ra,0x5
     f7e:	732080e7          	jalr	1842(ra) # 66ac <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f82:	20200593          	li	a1,514
     f86:	00006517          	auipc	a0,0x6
     f8a:	21a50513          	addi	a0,a0,538 # 71a0 <malloc+0x70a>
     f8e:	00005097          	auipc	ra,0x5
     f92:	70e080e7          	jalr	1806(ra) # 669c <open>
  if(fd < 0){
     f96:	10054763          	bltz	a0,10a4 <linktest+0x150>
     f9a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f9c:	4615                	li	a2,5
     f9e:	00006597          	auipc	a1,0x6
     fa2:	15258593          	addi	a1,a1,338 # 70f0 <malloc+0x65a>
     fa6:	00005097          	auipc	ra,0x5
     faa:	6d6080e7          	jalr	1750(ra) # 667c <write>
     fae:	4795                	li	a5,5
     fb0:	10f51863          	bne	a0,a5,10c0 <linktest+0x16c>
  close(fd);
     fb4:	8526                	mv	a0,s1
     fb6:	00005097          	auipc	ra,0x5
     fba:	6ce080e7          	jalr	1742(ra) # 6684 <close>
  if(link("lf1", "lf2") < 0){
     fbe:	00006597          	auipc	a1,0x6
     fc2:	1ea58593          	addi	a1,a1,490 # 71a8 <malloc+0x712>
     fc6:	00006517          	auipc	a0,0x6
     fca:	1da50513          	addi	a0,a0,474 # 71a0 <malloc+0x70a>
     fce:	00005097          	auipc	ra,0x5
     fd2:	6ee080e7          	jalr	1774(ra) # 66bc <link>
     fd6:	10054363          	bltz	a0,10dc <linktest+0x188>
  unlink("lf1");
     fda:	00006517          	auipc	a0,0x6
     fde:	1c650513          	addi	a0,a0,454 # 71a0 <malloc+0x70a>
     fe2:	00005097          	auipc	ra,0x5
     fe6:	6ca080e7          	jalr	1738(ra) # 66ac <unlink>
  if(open("lf1", 0) >= 0){
     fea:	4581                	li	a1,0
     fec:	00006517          	auipc	a0,0x6
     ff0:	1b450513          	addi	a0,a0,436 # 71a0 <malloc+0x70a>
     ff4:	00005097          	auipc	ra,0x5
     ff8:	6a8080e7          	jalr	1704(ra) # 669c <open>
     ffc:	0e055e63          	bgez	a0,10f8 <linktest+0x1a4>
  fd = open("lf2", 0);
    1000:	4581                	li	a1,0
    1002:	00006517          	auipc	a0,0x6
    1006:	1a650513          	addi	a0,a0,422 # 71a8 <malloc+0x712>
    100a:	00005097          	auipc	ra,0x5
    100e:	692080e7          	jalr	1682(ra) # 669c <open>
    1012:	84aa                	mv	s1,a0
  if(fd < 0){
    1014:	10054063          	bltz	a0,1114 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1018:	660d                	lui	a2,0x3
    101a:	0000d597          	auipc	a1,0xd
    101e:	c6e58593          	addi	a1,a1,-914 # dc88 <buf>
    1022:	00005097          	auipc	ra,0x5
    1026:	652080e7          	jalr	1618(ra) # 6674 <read>
    102a:	4795                	li	a5,5
    102c:	10f51263          	bne	a0,a5,1130 <linktest+0x1dc>
  close(fd);
    1030:	8526                	mv	a0,s1
    1032:	00005097          	auipc	ra,0x5
    1036:	652080e7          	jalr	1618(ra) # 6684 <close>
  if(link("lf2", "lf2") >= 0){
    103a:	00006597          	auipc	a1,0x6
    103e:	16e58593          	addi	a1,a1,366 # 71a8 <malloc+0x712>
    1042:	852e                	mv	a0,a1
    1044:	00005097          	auipc	ra,0x5
    1048:	678080e7          	jalr	1656(ra) # 66bc <link>
    104c:	10055063          	bgez	a0,114c <linktest+0x1f8>
  unlink("lf2");
    1050:	00006517          	auipc	a0,0x6
    1054:	15850513          	addi	a0,a0,344 # 71a8 <malloc+0x712>
    1058:	00005097          	auipc	ra,0x5
    105c:	654080e7          	jalr	1620(ra) # 66ac <unlink>
  if(link("lf2", "lf1") >= 0){
    1060:	00006597          	auipc	a1,0x6
    1064:	14058593          	addi	a1,a1,320 # 71a0 <malloc+0x70a>
    1068:	00006517          	auipc	a0,0x6
    106c:	14050513          	addi	a0,a0,320 # 71a8 <malloc+0x712>
    1070:	00005097          	auipc	ra,0x5
    1074:	64c080e7          	jalr	1612(ra) # 66bc <link>
    1078:	0e055863          	bgez	a0,1168 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    107c:	00006597          	auipc	a1,0x6
    1080:	12458593          	addi	a1,a1,292 # 71a0 <malloc+0x70a>
    1084:	00006517          	auipc	a0,0x6
    1088:	22c50513          	addi	a0,a0,556 # 72b0 <malloc+0x81a>
    108c:	00005097          	auipc	ra,0x5
    1090:	630080e7          	jalr	1584(ra) # 66bc <link>
    1094:	0e055863          	bgez	a0,1184 <linktest+0x230>
}
    1098:	60e2                	ld	ra,24(sp)
    109a:	6442                	ld	s0,16(sp)
    109c:	64a2                	ld	s1,8(sp)
    109e:	6902                	ld	s2,0(sp)
    10a0:	6105                	addi	sp,sp,32
    10a2:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    10a4:	85ca                	mv	a1,s2
    10a6:	00006517          	auipc	a0,0x6
    10aa:	10a50513          	addi	a0,a0,266 # 71b0 <malloc+0x71a>
    10ae:	00006097          	auipc	ra,0x6
    10b2:	92c080e7          	jalr	-1748(ra) # 69da <printf>
    exit(1);
    10b6:	4505                	li	a0,1
    10b8:	00005097          	auipc	ra,0x5
    10bc:	5a4080e7          	jalr	1444(ra) # 665c <exit>
    printf("%s: write lf1 failed\n", s);
    10c0:	85ca                	mv	a1,s2
    10c2:	00006517          	auipc	a0,0x6
    10c6:	10650513          	addi	a0,a0,262 # 71c8 <malloc+0x732>
    10ca:	00006097          	auipc	ra,0x6
    10ce:	910080e7          	jalr	-1776(ra) # 69da <printf>
    exit(1);
    10d2:	4505                	li	a0,1
    10d4:	00005097          	auipc	ra,0x5
    10d8:	588080e7          	jalr	1416(ra) # 665c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    10dc:	85ca                	mv	a1,s2
    10de:	00006517          	auipc	a0,0x6
    10e2:	10250513          	addi	a0,a0,258 # 71e0 <malloc+0x74a>
    10e6:	00006097          	auipc	ra,0x6
    10ea:	8f4080e7          	jalr	-1804(ra) # 69da <printf>
    exit(1);
    10ee:	4505                	li	a0,1
    10f0:	00005097          	auipc	ra,0x5
    10f4:	56c080e7          	jalr	1388(ra) # 665c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10f8:	85ca                	mv	a1,s2
    10fa:	00006517          	auipc	a0,0x6
    10fe:	10650513          	addi	a0,a0,262 # 7200 <malloc+0x76a>
    1102:	00006097          	auipc	ra,0x6
    1106:	8d8080e7          	jalr	-1832(ra) # 69da <printf>
    exit(1);
    110a:	4505                	li	a0,1
    110c:	00005097          	auipc	ra,0x5
    1110:	550080e7          	jalr	1360(ra) # 665c <exit>
    printf("%s: open lf2 failed\n", s);
    1114:	85ca                	mv	a1,s2
    1116:	00006517          	auipc	a0,0x6
    111a:	11a50513          	addi	a0,a0,282 # 7230 <malloc+0x79a>
    111e:	00006097          	auipc	ra,0x6
    1122:	8bc080e7          	jalr	-1860(ra) # 69da <printf>
    exit(1);
    1126:	4505                	li	a0,1
    1128:	00005097          	auipc	ra,0x5
    112c:	534080e7          	jalr	1332(ra) # 665c <exit>
    printf("%s: read lf2 failed\n", s);
    1130:	85ca                	mv	a1,s2
    1132:	00006517          	auipc	a0,0x6
    1136:	11650513          	addi	a0,a0,278 # 7248 <malloc+0x7b2>
    113a:	00006097          	auipc	ra,0x6
    113e:	8a0080e7          	jalr	-1888(ra) # 69da <printf>
    exit(1);
    1142:	4505                	li	a0,1
    1144:	00005097          	auipc	ra,0x5
    1148:	518080e7          	jalr	1304(ra) # 665c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    114c:	85ca                	mv	a1,s2
    114e:	00006517          	auipc	a0,0x6
    1152:	11250513          	addi	a0,a0,274 # 7260 <malloc+0x7ca>
    1156:	00006097          	auipc	ra,0x6
    115a:	884080e7          	jalr	-1916(ra) # 69da <printf>
    exit(1);
    115e:	4505                	li	a0,1
    1160:	00005097          	auipc	ra,0x5
    1164:	4fc080e7          	jalr	1276(ra) # 665c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1168:	85ca                	mv	a1,s2
    116a:	00006517          	auipc	a0,0x6
    116e:	11e50513          	addi	a0,a0,286 # 7288 <malloc+0x7f2>
    1172:	00006097          	auipc	ra,0x6
    1176:	868080e7          	jalr	-1944(ra) # 69da <printf>
    exit(1);
    117a:	4505                	li	a0,1
    117c:	00005097          	auipc	ra,0x5
    1180:	4e0080e7          	jalr	1248(ra) # 665c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1184:	85ca                	mv	a1,s2
    1186:	00006517          	auipc	a0,0x6
    118a:	13250513          	addi	a0,a0,306 # 72b8 <malloc+0x822>
    118e:	00006097          	auipc	ra,0x6
    1192:	84c080e7          	jalr	-1972(ra) # 69da <printf>
    exit(1);
    1196:	4505                	li	a0,1
    1198:	00005097          	auipc	ra,0x5
    119c:	4c4080e7          	jalr	1220(ra) # 665c <exit>

00000000000011a0 <validatetest>:
{
    11a0:	7139                	addi	sp,sp,-64
    11a2:	fc06                	sd	ra,56(sp)
    11a4:	f822                	sd	s0,48(sp)
    11a6:	f426                	sd	s1,40(sp)
    11a8:	f04a                	sd	s2,32(sp)
    11aa:	ec4e                	sd	s3,24(sp)
    11ac:	e852                	sd	s4,16(sp)
    11ae:	e456                	sd	s5,8(sp)
    11b0:	e05a                	sd	s6,0(sp)
    11b2:	0080                	addi	s0,sp,64
    11b4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11b6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    11b8:	00006997          	auipc	s3,0x6
    11bc:	12098993          	addi	s3,s3,288 # 72d8 <malloc+0x842>
    11c0:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11c2:	6a85                	lui	s5,0x1
    11c4:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    11c8:	85a6                	mv	a1,s1
    11ca:	854e                	mv	a0,s3
    11cc:	00005097          	auipc	ra,0x5
    11d0:	4f0080e7          	jalr	1264(ra) # 66bc <link>
    11d4:	01251f63          	bne	a0,s2,11f2 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11d8:	94d6                	add	s1,s1,s5
    11da:	ff4497e3          	bne	s1,s4,11c8 <validatetest+0x28>
}
    11de:	70e2                	ld	ra,56(sp)
    11e0:	7442                	ld	s0,48(sp)
    11e2:	74a2                	ld	s1,40(sp)
    11e4:	7902                	ld	s2,32(sp)
    11e6:	69e2                	ld	s3,24(sp)
    11e8:	6a42                	ld	s4,16(sp)
    11ea:	6aa2                	ld	s5,8(sp)
    11ec:	6b02                	ld	s6,0(sp)
    11ee:	6121                	addi	sp,sp,64
    11f0:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11f2:	85da                	mv	a1,s6
    11f4:	00006517          	auipc	a0,0x6
    11f8:	0f450513          	addi	a0,a0,244 # 72e8 <malloc+0x852>
    11fc:	00005097          	auipc	ra,0x5
    1200:	7de080e7          	jalr	2014(ra) # 69da <printf>
      exit(1);
    1204:	4505                	li	a0,1
    1206:	00005097          	auipc	ra,0x5
    120a:	456080e7          	jalr	1110(ra) # 665c <exit>

000000000000120e <bigdir>:
{
    120e:	711d                	addi	sp,sp,-96
    1210:	ec86                	sd	ra,88(sp)
    1212:	e8a2                	sd	s0,80(sp)
    1214:	e4a6                	sd	s1,72(sp)
    1216:	e0ca                	sd	s2,64(sp)
    1218:	fc4e                	sd	s3,56(sp)
    121a:	f852                	sd	s4,48(sp)
    121c:	f456                	sd	s5,40(sp)
    121e:	f05a                	sd	s6,32(sp)
    1220:	ec5e                	sd	s7,24(sp)
    1222:	1080                	addi	s0,sp,96
    1224:	8baa                	mv	s7,a0
  unlink("bd");
    1226:	00006517          	auipc	a0,0x6
    122a:	0e250513          	addi	a0,a0,226 # 7308 <malloc+0x872>
    122e:	00005097          	auipc	ra,0x5
    1232:	47e080e7          	jalr	1150(ra) # 66ac <unlink>
  fd = open("bd", O_CREATE);
    1236:	20000593          	li	a1,512
    123a:	00006517          	auipc	a0,0x6
    123e:	0ce50513          	addi	a0,a0,206 # 7308 <malloc+0x872>
    1242:	00005097          	auipc	ra,0x5
    1246:	45a080e7          	jalr	1114(ra) # 669c <open>
  if(fd < 0){
    124a:	0c054c63          	bltz	a0,1322 <bigdir+0x114>
  close(fd);
    124e:	00005097          	auipc	ra,0x5
    1252:	436080e7          	jalr	1078(ra) # 6684 <close>
  for(i = 0; i < N; i++){
    1256:	4901                	li	s2,0
    name[0] = 'x';
    1258:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    125c:	fa040a13          	addi	s4,s0,-96
    1260:	00006997          	auipc	s3,0x6
    1264:	0a898993          	addi	s3,s3,168 # 7308 <malloc+0x872>
  for(i = 0; i < N; i++){
    1268:	1f400b13          	li	s6,500
    name[0] = 'x';
    126c:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
    1270:	41f9571b          	sraiw	a4,s2,0x1f
    1274:	01a7571b          	srliw	a4,a4,0x1a
    1278:	012707bb          	addw	a5,a4,s2
    127c:	4067d69b          	sraiw	a3,a5,0x6
    1280:	0306869b          	addiw	a3,a3,48
    1284:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    1288:	03f7f793          	andi	a5,a5,63
    128c:	9f99                	subw	a5,a5,a4
    128e:	0307879b          	addiw	a5,a5,48
    1292:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    1296:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
    129a:	85d2                	mv	a1,s4
    129c:	854e                	mv	a0,s3
    129e:	00005097          	auipc	ra,0x5
    12a2:	41e080e7          	jalr	1054(ra) # 66bc <link>
    12a6:	84aa                	mv	s1,a0
    12a8:	e959                	bnez	a0,133e <bigdir+0x130>
  for(i = 0; i < N; i++){
    12aa:	2905                	addiw	s2,s2,1
    12ac:	fd6910e3          	bne	s2,s6,126c <bigdir+0x5e>
  unlink("bd");
    12b0:	00006517          	auipc	a0,0x6
    12b4:	05850513          	addi	a0,a0,88 # 7308 <malloc+0x872>
    12b8:	00005097          	auipc	ra,0x5
    12bc:	3f4080e7          	jalr	1012(ra) # 66ac <unlink>
    name[0] = 'x';
    12c0:	07800993          	li	s3,120
    if(unlink(name) != 0){
    12c4:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
    12c8:	1f400a13          	li	s4,500
    name[0] = 'x';
    12cc:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
    12d0:	41f4d71b          	sraiw	a4,s1,0x1f
    12d4:	01a7571b          	srliw	a4,a4,0x1a
    12d8:	009707bb          	addw	a5,a4,s1
    12dc:	4067d69b          	sraiw	a3,a5,0x6
    12e0:	0306869b          	addiw	a3,a3,48
    12e4:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    12e8:	03f7f793          	andi	a5,a5,63
    12ec:	9f99                	subw	a5,a5,a4
    12ee:	0307879b          	addiw	a5,a5,48
    12f2:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    12f6:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
    12fa:	854a                	mv	a0,s2
    12fc:	00005097          	auipc	ra,0x5
    1300:	3b0080e7          	jalr	944(ra) # 66ac <unlink>
    1304:	ed29                	bnez	a0,135e <bigdir+0x150>
  for(i = 0; i < N; i++){
    1306:	2485                	addiw	s1,s1,1
    1308:	fd4492e3          	bne	s1,s4,12cc <bigdir+0xbe>
}
    130c:	60e6                	ld	ra,88(sp)
    130e:	6446                	ld	s0,80(sp)
    1310:	64a6                	ld	s1,72(sp)
    1312:	6906                	ld	s2,64(sp)
    1314:	79e2                	ld	s3,56(sp)
    1316:	7a42                	ld	s4,48(sp)
    1318:	7aa2                	ld	s5,40(sp)
    131a:	7b02                	ld	s6,32(sp)
    131c:	6be2                	ld	s7,24(sp)
    131e:	6125                	addi	sp,sp,96
    1320:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1322:	85de                	mv	a1,s7
    1324:	00006517          	auipc	a0,0x6
    1328:	fec50513          	addi	a0,a0,-20 # 7310 <malloc+0x87a>
    132c:	00005097          	auipc	ra,0x5
    1330:	6ae080e7          	jalr	1710(ra) # 69da <printf>
    exit(1);
    1334:	4505                	li	a0,1
    1336:	00005097          	auipc	ra,0x5
    133a:	326080e7          	jalr	806(ra) # 665c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    133e:	fa040613          	addi	a2,s0,-96
    1342:	85de                	mv	a1,s7
    1344:	00006517          	auipc	a0,0x6
    1348:	fec50513          	addi	a0,a0,-20 # 7330 <malloc+0x89a>
    134c:	00005097          	auipc	ra,0x5
    1350:	68e080e7          	jalr	1678(ra) # 69da <printf>
      exit(1);
    1354:	4505                	li	a0,1
    1356:	00005097          	auipc	ra,0x5
    135a:	306080e7          	jalr	774(ra) # 665c <exit>
      printf("%s: bigdir unlink failed", s);
    135e:	85de                	mv	a1,s7
    1360:	00006517          	auipc	a0,0x6
    1364:	ff050513          	addi	a0,a0,-16 # 7350 <malloc+0x8ba>
    1368:	00005097          	auipc	ra,0x5
    136c:	672080e7          	jalr	1650(ra) # 69da <printf>
      exit(1);
    1370:	4505                	li	a0,1
    1372:	00005097          	auipc	ra,0x5
    1376:	2ea080e7          	jalr	746(ra) # 665c <exit>

000000000000137a <pgbug>:
{
    137a:	7179                	addi	sp,sp,-48
    137c:	f406                	sd	ra,40(sp)
    137e:	f022                	sd	s0,32(sp)
    1380:	ec26                	sd	s1,24(sp)
    1382:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1384:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1388:	00009497          	auipc	s1,0x9
    138c:	c7848493          	addi	s1,s1,-904 # a000 <big>
    1390:	fd840593          	addi	a1,s0,-40
    1394:	6088                	ld	a0,0(s1)
    1396:	00005097          	auipc	ra,0x5
    139a:	2fe080e7          	jalr	766(ra) # 6694 <exec>
  pipe(big);
    139e:	6088                	ld	a0,0(s1)
    13a0:	00005097          	auipc	ra,0x5
    13a4:	2cc080e7          	jalr	716(ra) # 666c <pipe>
  exit(0);
    13a8:	4501                	li	a0,0
    13aa:	00005097          	auipc	ra,0x5
    13ae:	2b2080e7          	jalr	690(ra) # 665c <exit>

00000000000013b2 <badarg>:
{
    13b2:	7139                	addi	sp,sp,-64
    13b4:	fc06                	sd	ra,56(sp)
    13b6:	f822                	sd	s0,48(sp)
    13b8:	f426                	sd	s1,40(sp)
    13ba:	f04a                	sd	s2,32(sp)
    13bc:	ec4e                	sd	s3,24(sp)
    13be:	e852                	sd	s4,16(sp)
    13c0:	0080                	addi	s0,sp,64
    13c2:	64b1                	lui	s1,0xc
    13c4:	35048493          	addi	s1,s1,848 # c350 <uninit+0xdd8>
    argv[0] = (char*)0xffffffff;
    13c8:	597d                	li	s2,-1
    13ca:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    13ce:	fc040a13          	addi	s4,s0,-64
    13d2:	00005997          	auipc	s3,0x5
    13d6:	7f698993          	addi	s3,s3,2038 # 6bc8 <malloc+0x132>
    argv[0] = (char*)0xffffffff;
    13da:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    13de:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    13e2:	85d2                	mv	a1,s4
    13e4:	854e                	mv	a0,s3
    13e6:	00005097          	auipc	ra,0x5
    13ea:	2ae080e7          	jalr	686(ra) # 6694 <exec>
  for(int i = 0; i < 50000; i++){
    13ee:	34fd                	addiw	s1,s1,-1
    13f0:	f4ed                	bnez	s1,13da <badarg+0x28>
  exit(0);
    13f2:	4501                	li	a0,0
    13f4:	00005097          	auipc	ra,0x5
    13f8:	268080e7          	jalr	616(ra) # 665c <exit>

00000000000013fc <copyinstr2>:
{
    13fc:	7155                	addi	sp,sp,-208
    13fe:	e586                	sd	ra,200(sp)
    1400:	e1a2                	sd	s0,192(sp)
    1402:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1404:	f6840793          	addi	a5,s0,-152
    1408:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    140c:	07800713          	li	a4,120
    1410:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1414:	0785                	addi	a5,a5,1
    1416:	fed79de3          	bne	a5,a3,1410 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    141a:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    141e:	f6840513          	addi	a0,s0,-152
    1422:	00005097          	auipc	ra,0x5
    1426:	28a080e7          	jalr	650(ra) # 66ac <unlink>
  if(ret != -1){
    142a:	57fd                	li	a5,-1
    142c:	0ef51063          	bne	a0,a5,150c <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1430:	20100593          	li	a1,513
    1434:	f6840513          	addi	a0,s0,-152
    1438:	00005097          	auipc	ra,0x5
    143c:	264080e7          	jalr	612(ra) # 669c <open>
  if(fd != -1){
    1440:	57fd                	li	a5,-1
    1442:	0ef51563          	bne	a0,a5,152c <copyinstr2+0x130>
  ret = link(b, b);
    1446:	f6840513          	addi	a0,s0,-152
    144a:	85aa                	mv	a1,a0
    144c:	00005097          	auipc	ra,0x5
    1450:	270080e7          	jalr	624(ra) # 66bc <link>
  if(ret != -1){
    1454:	57fd                	li	a5,-1
    1456:	0ef51b63          	bne	a0,a5,154c <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    145a:	00007797          	auipc	a5,0x7
    145e:	14e78793          	addi	a5,a5,334 # 85a8 <malloc+0x1b12>
    1462:	f4f43c23          	sd	a5,-168(s0)
    1466:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    146a:	f5840593          	addi	a1,s0,-168
    146e:	f6840513          	addi	a0,s0,-152
    1472:	00005097          	auipc	ra,0x5
    1476:	222080e7          	jalr	546(ra) # 6694 <exec>
  if(ret != -1){
    147a:	57fd                	li	a5,-1
    147c:	0ef51963          	bne	a0,a5,156e <copyinstr2+0x172>
  int pid = fork();
    1480:	00005097          	auipc	ra,0x5
    1484:	1d4080e7          	jalr	468(ra) # 6654 <fork>
  if(pid < 0){
    1488:	10054363          	bltz	a0,158e <copyinstr2+0x192>
  if(pid == 0){
    148c:	12051463          	bnez	a0,15b4 <copyinstr2+0x1b8>
    1490:	00009797          	auipc	a5,0x9
    1494:	0e078793          	addi	a5,a5,224 # a570 <big.0>
    1498:	0000a697          	auipc	a3,0xa
    149c:	0d868693          	addi	a3,a3,216 # b570 <big.0+0x1000>
      big[i] = 'x';
    14a0:	07800713          	li	a4,120
    14a4:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    14a8:	0785                	addi	a5,a5,1
    14aa:	fed79de3          	bne	a5,a3,14a4 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    14ae:	0000a797          	auipc	a5,0xa
    14b2:	0c078123          	sb	zero,194(a5) # b570 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    14b6:	00008797          	auipc	a5,0x8
    14ba:	c1a78793          	addi	a5,a5,-998 # 90d0 <malloc+0x263a>
    14be:	6390                	ld	a2,0(a5)
    14c0:	6794                	ld	a3,8(a5)
    14c2:	6b98                	ld	a4,16(a5)
    14c4:	f2c43823          	sd	a2,-208(s0)
    14c8:	f2d43c23          	sd	a3,-200(s0)
    14cc:	f4e43023          	sd	a4,-192(s0)
    14d0:	6f9c                	ld	a5,24(a5)
    14d2:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    14d6:	f3040593          	addi	a1,s0,-208
    14da:	00005517          	auipc	a0,0x5
    14de:	6ee50513          	addi	a0,a0,1774 # 6bc8 <malloc+0x132>
    14e2:	00005097          	auipc	ra,0x5
    14e6:	1b2080e7          	jalr	434(ra) # 6694 <exec>
    if(ret != -1){
    14ea:	57fd                	li	a5,-1
    14ec:	0af50e63          	beq	a0,a5,15a8 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    14f0:	85be                	mv	a1,a5
    14f2:	00006517          	auipc	a0,0x6
    14f6:	f0650513          	addi	a0,a0,-250 # 73f8 <malloc+0x962>
    14fa:	00005097          	auipc	ra,0x5
    14fe:	4e0080e7          	jalr	1248(ra) # 69da <printf>
      exit(1);
    1502:	4505                	li	a0,1
    1504:	00005097          	auipc	ra,0x5
    1508:	158080e7          	jalr	344(ra) # 665c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    150c:	862a                	mv	a2,a0
    150e:	f6840593          	addi	a1,s0,-152
    1512:	00006517          	auipc	a0,0x6
    1516:	e5e50513          	addi	a0,a0,-418 # 7370 <malloc+0x8da>
    151a:	00005097          	auipc	ra,0x5
    151e:	4c0080e7          	jalr	1216(ra) # 69da <printf>
    exit(1);
    1522:	4505                	li	a0,1
    1524:	00005097          	auipc	ra,0x5
    1528:	138080e7          	jalr	312(ra) # 665c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    152c:	862a                	mv	a2,a0
    152e:	f6840593          	addi	a1,s0,-152
    1532:	00006517          	auipc	a0,0x6
    1536:	e5e50513          	addi	a0,a0,-418 # 7390 <malloc+0x8fa>
    153a:	00005097          	auipc	ra,0x5
    153e:	4a0080e7          	jalr	1184(ra) # 69da <printf>
    exit(1);
    1542:	4505                	li	a0,1
    1544:	00005097          	auipc	ra,0x5
    1548:	118080e7          	jalr	280(ra) # 665c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    154c:	f6840593          	addi	a1,s0,-152
    1550:	86aa                	mv	a3,a0
    1552:	862e                	mv	a2,a1
    1554:	00006517          	auipc	a0,0x6
    1558:	e5c50513          	addi	a0,a0,-420 # 73b0 <malloc+0x91a>
    155c:	00005097          	auipc	ra,0x5
    1560:	47e080e7          	jalr	1150(ra) # 69da <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	00005097          	auipc	ra,0x5
    156a:	0f6080e7          	jalr	246(ra) # 665c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    156e:	863e                	mv	a2,a5
    1570:	f6840593          	addi	a1,s0,-152
    1574:	00006517          	auipc	a0,0x6
    1578:	e6450513          	addi	a0,a0,-412 # 73d8 <malloc+0x942>
    157c:	00005097          	auipc	ra,0x5
    1580:	45e080e7          	jalr	1118(ra) # 69da <printf>
    exit(1);
    1584:	4505                	li	a0,1
    1586:	00005097          	auipc	ra,0x5
    158a:	0d6080e7          	jalr	214(ra) # 665c <exit>
    printf("fork failed\n");
    158e:	00006517          	auipc	a0,0x6
    1592:	2ca50513          	addi	a0,a0,714 # 7858 <malloc+0xdc2>
    1596:	00005097          	auipc	ra,0x5
    159a:	444080e7          	jalr	1092(ra) # 69da <printf>
    exit(1);
    159e:	4505                	li	a0,1
    15a0:	00005097          	auipc	ra,0x5
    15a4:	0bc080e7          	jalr	188(ra) # 665c <exit>
    exit(747); // OK
    15a8:	2eb00513          	li	a0,747
    15ac:	00005097          	auipc	ra,0x5
    15b0:	0b0080e7          	jalr	176(ra) # 665c <exit>
  int st = 0;
    15b4:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    15b8:	f5440513          	addi	a0,s0,-172
    15bc:	00005097          	auipc	ra,0x5
    15c0:	0a8080e7          	jalr	168(ra) # 6664 <wait>
  if(st != 747){
    15c4:	f5442703          	lw	a4,-172(s0)
    15c8:	2eb00793          	li	a5,747
    15cc:	00f71663          	bne	a4,a5,15d8 <copyinstr2+0x1dc>
}
    15d0:	60ae                	ld	ra,200(sp)
    15d2:	640e                	ld	s0,192(sp)
    15d4:	6169                	addi	sp,sp,208
    15d6:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    15d8:	00006517          	auipc	a0,0x6
    15dc:	e4850513          	addi	a0,a0,-440 # 7420 <malloc+0x98a>
    15e0:	00005097          	auipc	ra,0x5
    15e4:	3fa080e7          	jalr	1018(ra) # 69da <printf>
    exit(1);
    15e8:	4505                	li	a0,1
    15ea:	00005097          	auipc	ra,0x5
    15ee:	072080e7          	jalr	114(ra) # 665c <exit>

00000000000015f2 <truncate3>:
{
    15f2:	7175                	addi	sp,sp,-144
    15f4:	e506                	sd	ra,136(sp)
    15f6:	e122                	sd	s0,128(sp)
    15f8:	fc66                	sd	s9,56(sp)
    15fa:	0900                	addi	s0,sp,144
    15fc:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15fe:	60100593          	li	a1,1537
    1602:	00005517          	auipc	a0,0x5
    1606:	61e50513          	addi	a0,a0,1566 # 6c20 <malloc+0x18a>
    160a:	00005097          	auipc	ra,0x5
    160e:	092080e7          	jalr	146(ra) # 669c <open>
    1612:	00005097          	auipc	ra,0x5
    1616:	072080e7          	jalr	114(ra) # 6684 <close>
  pid = fork();
    161a:	00005097          	auipc	ra,0x5
    161e:	03a080e7          	jalr	58(ra) # 6654 <fork>
  if(pid < 0){
    1622:	08054b63          	bltz	a0,16b8 <truncate3+0xc6>
  if(pid == 0){
    1626:	ed65                	bnez	a0,171e <truncate3+0x12c>
    1628:	fca6                	sd	s1,120(sp)
    162a:	f8ca                	sd	s2,112(sp)
    162c:	f4ce                	sd	s3,104(sp)
    162e:	f0d2                	sd	s4,96(sp)
    1630:	ecd6                	sd	s5,88(sp)
    1632:	e8da                	sd	s6,80(sp)
    1634:	e4de                	sd	s7,72(sp)
    1636:	e0e2                	sd	s8,64(sp)
    1638:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    163c:	4a85                	li	s5,1
    163e:	00005997          	auipc	s3,0x5
    1642:	5e298993          	addi	s3,s3,1506 # 6c20 <malloc+0x18a>
      int n = write(fd, "1234567890", 10);
    1646:	4a29                	li	s4,10
    1648:	00006b17          	auipc	s6,0x6
    164c:	e38b0b13          	addi	s6,s6,-456 # 7480 <malloc+0x9ea>
      read(fd, buf, sizeof(buf));
    1650:	f7840c13          	addi	s8,s0,-136
    1654:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1658:	85d6                	mv	a1,s5
    165a:	854e                	mv	a0,s3
    165c:	00005097          	auipc	ra,0x5
    1660:	040080e7          	jalr	64(ra) # 669c <open>
    1664:	84aa                	mv	s1,a0
      if(fd < 0){
    1666:	06054f63          	bltz	a0,16e4 <truncate3+0xf2>
      int n = write(fd, "1234567890", 10);
    166a:	8652                	mv	a2,s4
    166c:	85da                	mv	a1,s6
    166e:	00005097          	auipc	ra,0x5
    1672:	00e080e7          	jalr	14(ra) # 667c <write>
      if(n != 10){
    1676:	09451563          	bne	a0,s4,1700 <truncate3+0x10e>
      close(fd);
    167a:	8526                	mv	a0,s1
    167c:	00005097          	auipc	ra,0x5
    1680:	008080e7          	jalr	8(ra) # 6684 <close>
      fd = open("truncfile", O_RDONLY);
    1684:	4581                	li	a1,0
    1686:	854e                	mv	a0,s3
    1688:	00005097          	auipc	ra,0x5
    168c:	014080e7          	jalr	20(ra) # 669c <open>
    1690:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1692:	865e                	mv	a2,s7
    1694:	85e2                	mv	a1,s8
    1696:	00005097          	auipc	ra,0x5
    169a:	fde080e7          	jalr	-34(ra) # 6674 <read>
      close(fd);
    169e:	8526                	mv	a0,s1
    16a0:	00005097          	auipc	ra,0x5
    16a4:	fe4080e7          	jalr	-28(ra) # 6684 <close>
    for(int i = 0; i < 100; i++){
    16a8:	397d                	addiw	s2,s2,-1
    16aa:	fa0917e3          	bnez	s2,1658 <truncate3+0x66>
    exit(0);
    16ae:	4501                	li	a0,0
    16b0:	00005097          	auipc	ra,0x5
    16b4:	fac080e7          	jalr	-84(ra) # 665c <exit>
    16b8:	fca6                	sd	s1,120(sp)
    16ba:	f8ca                	sd	s2,112(sp)
    16bc:	f4ce                	sd	s3,104(sp)
    16be:	f0d2                	sd	s4,96(sp)
    16c0:	ecd6                	sd	s5,88(sp)
    16c2:	e8da                	sd	s6,80(sp)
    16c4:	e4de                	sd	s7,72(sp)
    16c6:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    16c8:	85e6                	mv	a1,s9
    16ca:	00006517          	auipc	a0,0x6
    16ce:	d8650513          	addi	a0,a0,-634 # 7450 <malloc+0x9ba>
    16d2:	00005097          	auipc	ra,0x5
    16d6:	308080e7          	jalr	776(ra) # 69da <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	00005097          	auipc	ra,0x5
    16e0:	f80080e7          	jalr	-128(ra) # 665c <exit>
        printf("%s: open failed\n", s);
    16e4:	85e6                	mv	a1,s9
    16e6:	00006517          	auipc	a0,0x6
    16ea:	d8250513          	addi	a0,a0,-638 # 7468 <malloc+0x9d2>
    16ee:	00005097          	auipc	ra,0x5
    16f2:	2ec080e7          	jalr	748(ra) # 69da <printf>
        exit(1);
    16f6:	4505                	li	a0,1
    16f8:	00005097          	auipc	ra,0x5
    16fc:	f64080e7          	jalr	-156(ra) # 665c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1700:	862a                	mv	a2,a0
    1702:	85e6                	mv	a1,s9
    1704:	00006517          	auipc	a0,0x6
    1708:	d8c50513          	addi	a0,a0,-628 # 7490 <malloc+0x9fa>
    170c:	00005097          	auipc	ra,0x5
    1710:	2ce080e7          	jalr	718(ra) # 69da <printf>
        exit(1);
    1714:	4505                	li	a0,1
    1716:	00005097          	auipc	ra,0x5
    171a:	f46080e7          	jalr	-186(ra) # 665c <exit>
    171e:	fca6                	sd	s1,120(sp)
    1720:	f8ca                	sd	s2,112(sp)
    1722:	f4ce                	sd	s3,104(sp)
    1724:	f0d2                	sd	s4,96(sp)
    1726:	ecd6                	sd	s5,88(sp)
    1728:	e8da                	sd	s6,80(sp)
    172a:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    172e:	60100a93          	li	s5,1537
    1732:	00005a17          	auipc	s4,0x5
    1736:	4eea0a13          	addi	s4,s4,1262 # 6c20 <malloc+0x18a>
    int n = write(fd, "xxx", 3);
    173a:	498d                	li	s3,3
    173c:	00006b17          	auipc	s6,0x6
    1740:	d74b0b13          	addi	s6,s6,-652 # 74b0 <malloc+0xa1a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1744:	85d6                	mv	a1,s5
    1746:	8552                	mv	a0,s4
    1748:	00005097          	auipc	ra,0x5
    174c:	f54080e7          	jalr	-172(ra) # 669c <open>
    1750:	84aa                	mv	s1,a0
    if(fd < 0){
    1752:	04054863          	bltz	a0,17a2 <truncate3+0x1b0>
    int n = write(fd, "xxx", 3);
    1756:	864e                	mv	a2,s3
    1758:	85da                	mv	a1,s6
    175a:	00005097          	auipc	ra,0x5
    175e:	f22080e7          	jalr	-222(ra) # 667c <write>
    if(n != 3){
    1762:	07351063          	bne	a0,s3,17c2 <truncate3+0x1d0>
    close(fd);
    1766:	8526                	mv	a0,s1
    1768:	00005097          	auipc	ra,0x5
    176c:	f1c080e7          	jalr	-228(ra) # 6684 <close>
  for(int i = 0; i < 150; i++){
    1770:	397d                	addiw	s2,s2,-1
    1772:	fc0919e3          	bnez	s2,1744 <truncate3+0x152>
    1776:	e4de                	sd	s7,72(sp)
    1778:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    177a:	f9c40513          	addi	a0,s0,-100
    177e:	00005097          	auipc	ra,0x5
    1782:	ee6080e7          	jalr	-282(ra) # 6664 <wait>
  unlink("truncfile");
    1786:	00005517          	auipc	a0,0x5
    178a:	49a50513          	addi	a0,a0,1178 # 6c20 <malloc+0x18a>
    178e:	00005097          	auipc	ra,0x5
    1792:	f1e080e7          	jalr	-226(ra) # 66ac <unlink>
  exit(xstatus);
    1796:	f9c42503          	lw	a0,-100(s0)
    179a:	00005097          	auipc	ra,0x5
    179e:	ec2080e7          	jalr	-318(ra) # 665c <exit>
    17a2:	e4de                	sd	s7,72(sp)
    17a4:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    17a6:	85e6                	mv	a1,s9
    17a8:	00006517          	auipc	a0,0x6
    17ac:	cc050513          	addi	a0,a0,-832 # 7468 <malloc+0x9d2>
    17b0:	00005097          	auipc	ra,0x5
    17b4:	22a080e7          	jalr	554(ra) # 69da <printf>
      exit(1);
    17b8:	4505                	li	a0,1
    17ba:	00005097          	auipc	ra,0x5
    17be:	ea2080e7          	jalr	-350(ra) # 665c <exit>
    17c2:	e4de                	sd	s7,72(sp)
    17c4:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    17c6:	862a                	mv	a2,a0
    17c8:	85e6                	mv	a1,s9
    17ca:	00006517          	auipc	a0,0x6
    17ce:	cee50513          	addi	a0,a0,-786 # 74b8 <malloc+0xa22>
    17d2:	00005097          	auipc	ra,0x5
    17d6:	208080e7          	jalr	520(ra) # 69da <printf>
      exit(1);
    17da:	4505                	li	a0,1
    17dc:	00005097          	auipc	ra,0x5
    17e0:	e80080e7          	jalr	-384(ra) # 665c <exit>

00000000000017e4 <exectest>:
{
    17e4:	715d                	addi	sp,sp,-80
    17e6:	e486                	sd	ra,72(sp)
    17e8:	e0a2                	sd	s0,64(sp)
    17ea:	f84a                	sd	s2,48(sp)
    17ec:	0880                	addi	s0,sp,80
    17ee:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    17f0:	00005797          	auipc	a5,0x5
    17f4:	3d878793          	addi	a5,a5,984 # 6bc8 <malloc+0x132>
    17f8:	fcf43023          	sd	a5,-64(s0)
    17fc:	00006797          	auipc	a5,0x6
    1800:	cdc78793          	addi	a5,a5,-804 # 74d8 <malloc+0xa42>
    1804:	fcf43423          	sd	a5,-56(s0)
    1808:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    180c:	00006517          	auipc	a0,0x6
    1810:	cd450513          	addi	a0,a0,-812 # 74e0 <malloc+0xa4a>
    1814:	00005097          	auipc	ra,0x5
    1818:	e98080e7          	jalr	-360(ra) # 66ac <unlink>
  pid = fork();
    181c:	00005097          	auipc	ra,0x5
    1820:	e38080e7          	jalr	-456(ra) # 6654 <fork>
  if(pid < 0) {
    1824:	04054763          	bltz	a0,1872 <exectest+0x8e>
    1828:	fc26                	sd	s1,56(sp)
    182a:	84aa                	mv	s1,a0
  if(pid == 0) {
    182c:	ed41                	bnez	a0,18c4 <exectest+0xe0>
    close(1);
    182e:	4505                	li	a0,1
    1830:	00005097          	auipc	ra,0x5
    1834:	e54080e7          	jalr	-428(ra) # 6684 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1838:	20100593          	li	a1,513
    183c:	00006517          	auipc	a0,0x6
    1840:	ca450513          	addi	a0,a0,-860 # 74e0 <malloc+0xa4a>
    1844:	00005097          	auipc	ra,0x5
    1848:	e58080e7          	jalr	-424(ra) # 669c <open>
    if(fd < 0) {
    184c:	04054263          	bltz	a0,1890 <exectest+0xac>
    if(fd != 1) {
    1850:	4785                	li	a5,1
    1852:	04f50d63          	beq	a0,a5,18ac <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    1856:	85ca                	mv	a1,s2
    1858:	00006517          	auipc	a0,0x6
    185c:	ca850513          	addi	a0,a0,-856 # 7500 <malloc+0xa6a>
    1860:	00005097          	auipc	ra,0x5
    1864:	17a080e7          	jalr	378(ra) # 69da <printf>
      exit(1);
    1868:	4505                	li	a0,1
    186a:	00005097          	auipc	ra,0x5
    186e:	df2080e7          	jalr	-526(ra) # 665c <exit>
    1872:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1874:	85ca                	mv	a1,s2
    1876:	00006517          	auipc	a0,0x6
    187a:	bda50513          	addi	a0,a0,-1062 # 7450 <malloc+0x9ba>
    187e:	00005097          	auipc	ra,0x5
    1882:	15c080e7          	jalr	348(ra) # 69da <printf>
     exit(1);
    1886:	4505                	li	a0,1
    1888:	00005097          	auipc	ra,0x5
    188c:	dd4080e7          	jalr	-556(ra) # 665c <exit>
      printf("%s: create failed\n", s);
    1890:	85ca                	mv	a1,s2
    1892:	00006517          	auipc	a0,0x6
    1896:	c5650513          	addi	a0,a0,-938 # 74e8 <malloc+0xa52>
    189a:	00005097          	auipc	ra,0x5
    189e:	140080e7          	jalr	320(ra) # 69da <printf>
      exit(1);
    18a2:	4505                	li	a0,1
    18a4:	00005097          	auipc	ra,0x5
    18a8:	db8080e7          	jalr	-584(ra) # 665c <exit>
    if(exec("echo", echoargv) < 0){
    18ac:	fc040593          	addi	a1,s0,-64
    18b0:	00005517          	auipc	a0,0x5
    18b4:	31850513          	addi	a0,a0,792 # 6bc8 <malloc+0x132>
    18b8:	00005097          	auipc	ra,0x5
    18bc:	ddc080e7          	jalr	-548(ra) # 6694 <exec>
    18c0:	02054163          	bltz	a0,18e2 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    18c4:	fdc40513          	addi	a0,s0,-36
    18c8:	00005097          	auipc	ra,0x5
    18cc:	d9c080e7          	jalr	-612(ra) # 6664 <wait>
    18d0:	02951763          	bne	a0,s1,18fe <exectest+0x11a>
  if(xstatus != 0)
    18d4:	fdc42503          	lw	a0,-36(s0)
    18d8:	cd0d                	beqz	a0,1912 <exectest+0x12e>
    exit(xstatus);
    18da:	00005097          	auipc	ra,0x5
    18de:	d82080e7          	jalr	-638(ra) # 665c <exit>
      printf("%s: exec echo failed\n", s);
    18e2:	85ca                	mv	a1,s2
    18e4:	00006517          	auipc	a0,0x6
    18e8:	c2c50513          	addi	a0,a0,-980 # 7510 <malloc+0xa7a>
    18ec:	00005097          	auipc	ra,0x5
    18f0:	0ee080e7          	jalr	238(ra) # 69da <printf>
      exit(1);
    18f4:	4505                	li	a0,1
    18f6:	00005097          	auipc	ra,0x5
    18fa:	d66080e7          	jalr	-666(ra) # 665c <exit>
    printf("%s: wait failed!\n", s);
    18fe:	85ca                	mv	a1,s2
    1900:	00006517          	auipc	a0,0x6
    1904:	c2850513          	addi	a0,a0,-984 # 7528 <malloc+0xa92>
    1908:	00005097          	auipc	ra,0x5
    190c:	0d2080e7          	jalr	210(ra) # 69da <printf>
    1910:	b7d1                	j	18d4 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    1912:	4581                	li	a1,0
    1914:	00006517          	auipc	a0,0x6
    1918:	bcc50513          	addi	a0,a0,-1076 # 74e0 <malloc+0xa4a>
    191c:	00005097          	auipc	ra,0x5
    1920:	d80080e7          	jalr	-640(ra) # 669c <open>
  if(fd < 0) {
    1924:	02054a63          	bltz	a0,1958 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1928:	4609                	li	a2,2
    192a:	fb840593          	addi	a1,s0,-72
    192e:	00005097          	auipc	ra,0x5
    1932:	d46080e7          	jalr	-698(ra) # 6674 <read>
    1936:	4789                	li	a5,2
    1938:	02f50e63          	beq	a0,a5,1974 <exectest+0x190>
    printf("%s: read failed\n", s);
    193c:	85ca                	mv	a1,s2
    193e:	00005517          	auipc	a0,0x5
    1942:	65a50513          	addi	a0,a0,1626 # 6f98 <malloc+0x502>
    1946:	00005097          	auipc	ra,0x5
    194a:	094080e7          	jalr	148(ra) # 69da <printf>
    exit(1);
    194e:	4505                	li	a0,1
    1950:	00005097          	auipc	ra,0x5
    1954:	d0c080e7          	jalr	-756(ra) # 665c <exit>
    printf("%s: open failed\n", s);
    1958:	85ca                	mv	a1,s2
    195a:	00006517          	auipc	a0,0x6
    195e:	b0e50513          	addi	a0,a0,-1266 # 7468 <malloc+0x9d2>
    1962:	00005097          	auipc	ra,0x5
    1966:	078080e7          	jalr	120(ra) # 69da <printf>
    exit(1);
    196a:	4505                	li	a0,1
    196c:	00005097          	auipc	ra,0x5
    1970:	cf0080e7          	jalr	-784(ra) # 665c <exit>
  unlink("echo-ok");
    1974:	00006517          	auipc	a0,0x6
    1978:	b6c50513          	addi	a0,a0,-1172 # 74e0 <malloc+0xa4a>
    197c:	00005097          	auipc	ra,0x5
    1980:	d30080e7          	jalr	-720(ra) # 66ac <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1984:	fb844703          	lbu	a4,-72(s0)
    1988:	04f00793          	li	a5,79
    198c:	00f71863          	bne	a4,a5,199c <exectest+0x1b8>
    1990:	fb944703          	lbu	a4,-71(s0)
    1994:	04b00793          	li	a5,75
    1998:	02f70063          	beq	a4,a5,19b8 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    199c:	85ca                	mv	a1,s2
    199e:	00006517          	auipc	a0,0x6
    19a2:	ba250513          	addi	a0,a0,-1118 # 7540 <malloc+0xaaa>
    19a6:	00005097          	auipc	ra,0x5
    19aa:	034080e7          	jalr	52(ra) # 69da <printf>
    exit(1);
    19ae:	4505                	li	a0,1
    19b0:	00005097          	auipc	ra,0x5
    19b4:	cac080e7          	jalr	-852(ra) # 665c <exit>
    exit(0);
    19b8:	4501                	li	a0,0
    19ba:	00005097          	auipc	ra,0x5
    19be:	ca2080e7          	jalr	-862(ra) # 665c <exit>

00000000000019c2 <pipe1>:
{
    19c2:	711d                	addi	sp,sp,-96
    19c4:	ec86                	sd	ra,88(sp)
    19c6:	e8a2                	sd	s0,80(sp)
    19c8:	e862                	sd	s8,16(sp)
    19ca:	1080                	addi	s0,sp,96
    19cc:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    19ce:	fa840513          	addi	a0,s0,-88
    19d2:	00005097          	auipc	ra,0x5
    19d6:	c9a080e7          	jalr	-870(ra) # 666c <pipe>
    19da:	ed35                	bnez	a0,1a56 <pipe1+0x94>
    19dc:	e4a6                	sd	s1,72(sp)
    19de:	fc4e                	sd	s3,56(sp)
    19e0:	84aa                	mv	s1,a0
  pid = fork();
    19e2:	00005097          	auipc	ra,0x5
    19e6:	c72080e7          	jalr	-910(ra) # 6654 <fork>
    19ea:	89aa                	mv	s3,a0
  if(pid == 0){
    19ec:	c951                	beqz	a0,1a80 <pipe1+0xbe>
  } else if(pid > 0){
    19ee:	18a05d63          	blez	a0,1b88 <pipe1+0x1c6>
    19f2:	e0ca                	sd	s2,64(sp)
    19f4:	f852                	sd	s4,48(sp)
    close(fds[1]);
    19f6:	fac42503          	lw	a0,-84(s0)
    19fa:	00005097          	auipc	ra,0x5
    19fe:	c8a080e7          	jalr	-886(ra) # 6684 <close>
    total = 0;
    1a02:	89a6                	mv	s3,s1
    cc = 1;
    1a04:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1a06:	0000ca17          	auipc	s4,0xc
    1a0a:	282a0a13          	addi	s4,s4,642 # dc88 <buf>
    1a0e:	864a                	mv	a2,s2
    1a10:	85d2                	mv	a1,s4
    1a12:	fa842503          	lw	a0,-88(s0)
    1a16:	00005097          	auipc	ra,0x5
    1a1a:	c5e080e7          	jalr	-930(ra) # 6674 <read>
    1a1e:	85aa                	mv	a1,a0
    1a20:	10a05963          	blez	a0,1b32 <pipe1+0x170>
    1a24:	0000c797          	auipc	a5,0xc
    1a28:	26478793          	addi	a5,a5,612 # dc88 <buf>
    1a2c:	00b4863b          	addw	a2,s1,a1
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1a30:	0007c683          	lbu	a3,0(a5)
    1a34:	0ff4f713          	zext.b	a4,s1
    1a38:	0ce69b63          	bne	a3,a4,1b0e <pipe1+0x14c>
    1a3c:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    1a3e:	0785                	addi	a5,a5,1
    1a40:	fec498e3          	bne	s1,a2,1a30 <pipe1+0x6e>
      total += n;
    1a44:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    1a48:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    1a4c:	678d                	lui	a5,0x3
    1a4e:	fd27f0e3          	bgeu	a5,s2,1a0e <pipe1+0x4c>
        cc = sizeof(buf);
    1a52:	893e                	mv	s2,a5
    1a54:	bf6d                	j	1a0e <pipe1+0x4c>
    1a56:	e4a6                	sd	s1,72(sp)
    1a58:	e0ca                	sd	s2,64(sp)
    1a5a:	fc4e                	sd	s3,56(sp)
    1a5c:	f852                	sd	s4,48(sp)
    1a5e:	f456                	sd	s5,40(sp)
    1a60:	f05a                	sd	s6,32(sp)
    1a62:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    1a64:	85e2                	mv	a1,s8
    1a66:	00006517          	auipc	a0,0x6
    1a6a:	af250513          	addi	a0,a0,-1294 # 7558 <malloc+0xac2>
    1a6e:	00005097          	auipc	ra,0x5
    1a72:	f6c080e7          	jalr	-148(ra) # 69da <printf>
    exit(1);
    1a76:	4505                	li	a0,1
    1a78:	00005097          	auipc	ra,0x5
    1a7c:	be4080e7          	jalr	-1052(ra) # 665c <exit>
    1a80:	e0ca                	sd	s2,64(sp)
    1a82:	f852                	sd	s4,48(sp)
    1a84:	f456                	sd	s5,40(sp)
    1a86:	f05a                	sd	s6,32(sp)
    1a88:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1a8a:	fa842503          	lw	a0,-88(s0)
    1a8e:	00005097          	auipc	ra,0x5
    1a92:	bf6080e7          	jalr	-1034(ra) # 6684 <close>
    for(n = 0; n < N; n++){
    1a96:	0000cb17          	auipc	s6,0xc
    1a9a:	1f2b0b13          	addi	s6,s6,498 # dc88 <buf>
    1a9e:	416004bb          	negw	s1,s6
    1aa2:	0ff4f493          	zext.b	s1,s1
    1aa6:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1aaa:	40900a13          	li	s4,1033
    1aae:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1ab0:	6a85                	lui	s5,0x1
    1ab2:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x31>
{
    1ab6:	87da                	mv	a5,s6
        buf[i] = seq++;
    1ab8:	0097873b          	addw	a4,a5,s1
    1abc:	00e78023          	sb	a4,0(a5) # 3000 <sbrklast+0x44>
      for(i = 0; i < SZ; i++)
    1ac0:	0785                	addi	a5,a5,1
    1ac2:	ff279be3          	bne	a5,s2,1ab8 <pipe1+0xf6>
      if(write(fds[1], buf, SZ) != SZ){
    1ac6:	8652                	mv	a2,s4
    1ac8:	85de                	mv	a1,s7
    1aca:	fac42503          	lw	a0,-84(s0)
    1ace:	00005097          	auipc	ra,0x5
    1ad2:	bae080e7          	jalr	-1106(ra) # 667c <write>
    1ad6:	01451e63          	bne	a0,s4,1af2 <pipe1+0x130>
    1ada:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    1ade:	24a5                	addiw	s1,s1,9
    1ae0:	0ff4f493          	zext.b	s1,s1
    1ae4:	fd5999e3          	bne	s3,s5,1ab6 <pipe1+0xf4>
    exit(0);
    1ae8:	4501                	li	a0,0
    1aea:	00005097          	auipc	ra,0x5
    1aee:	b72080e7          	jalr	-1166(ra) # 665c <exit>
        printf("%s: pipe1 oops 1\n", s);
    1af2:	85e2                	mv	a1,s8
    1af4:	00006517          	auipc	a0,0x6
    1af8:	a7c50513          	addi	a0,a0,-1412 # 7570 <malloc+0xada>
    1afc:	00005097          	auipc	ra,0x5
    1b00:	ede080e7          	jalr	-290(ra) # 69da <printf>
        exit(1);
    1b04:	4505                	li	a0,1
    1b06:	00005097          	auipc	ra,0x5
    1b0a:	b56080e7          	jalr	-1194(ra) # 665c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1b0e:	85e2                	mv	a1,s8
    1b10:	00006517          	auipc	a0,0x6
    1b14:	a7850513          	addi	a0,a0,-1416 # 7588 <malloc+0xaf2>
    1b18:	00005097          	auipc	ra,0x5
    1b1c:	ec2080e7          	jalr	-318(ra) # 69da <printf>
          return;
    1b20:	64a6                	ld	s1,72(sp)
    1b22:	6906                	ld	s2,64(sp)
    1b24:	79e2                	ld	s3,56(sp)
    1b26:	7a42                	ld	s4,48(sp)
}
    1b28:	60e6                	ld	ra,88(sp)
    1b2a:	6446                	ld	s0,80(sp)
    1b2c:	6c42                	ld	s8,16(sp)
    1b2e:	6125                	addi	sp,sp,96
    1b30:	8082                	ret
    if(total != N * SZ){
    1b32:	6785                	lui	a5,0x1
    1b34:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x31>
    1b38:	02f98363          	beq	s3,a5,1b5e <pipe1+0x19c>
    1b3c:	f456                	sd	s5,40(sp)
    1b3e:	f05a                	sd	s6,32(sp)
    1b40:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1b42:	85ce                	mv	a1,s3
    1b44:	00006517          	auipc	a0,0x6
    1b48:	a5c50513          	addi	a0,a0,-1444 # 75a0 <malloc+0xb0a>
    1b4c:	00005097          	auipc	ra,0x5
    1b50:	e8e080e7          	jalr	-370(ra) # 69da <printf>
      exit(1);
    1b54:	4505                	li	a0,1
    1b56:	00005097          	auipc	ra,0x5
    1b5a:	b06080e7          	jalr	-1274(ra) # 665c <exit>
    1b5e:	f456                	sd	s5,40(sp)
    1b60:	f05a                	sd	s6,32(sp)
    1b62:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1b64:	fa842503          	lw	a0,-88(s0)
    1b68:	00005097          	auipc	ra,0x5
    1b6c:	b1c080e7          	jalr	-1252(ra) # 6684 <close>
    wait(&xstatus);
    1b70:	fa440513          	addi	a0,s0,-92
    1b74:	00005097          	auipc	ra,0x5
    1b78:	af0080e7          	jalr	-1296(ra) # 6664 <wait>
    exit(xstatus);
    1b7c:	fa442503          	lw	a0,-92(s0)
    1b80:	00005097          	auipc	ra,0x5
    1b84:	adc080e7          	jalr	-1316(ra) # 665c <exit>
    1b88:	e0ca                	sd	s2,64(sp)
    1b8a:	f852                	sd	s4,48(sp)
    1b8c:	f456                	sd	s5,40(sp)
    1b8e:	f05a                	sd	s6,32(sp)
    1b90:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1b92:	85e2                	mv	a1,s8
    1b94:	00006517          	auipc	a0,0x6
    1b98:	a2c50513          	addi	a0,a0,-1492 # 75c0 <malloc+0xb2a>
    1b9c:	00005097          	auipc	ra,0x5
    1ba0:	e3e080e7          	jalr	-450(ra) # 69da <printf>
    exit(1);
    1ba4:	4505                	li	a0,1
    1ba6:	00005097          	auipc	ra,0x5
    1baa:	ab6080e7          	jalr	-1354(ra) # 665c <exit>

0000000000001bae <exitwait>:
{
    1bae:	715d                	addi	sp,sp,-80
    1bb0:	e486                	sd	ra,72(sp)
    1bb2:	e0a2                	sd	s0,64(sp)
    1bb4:	fc26                	sd	s1,56(sp)
    1bb6:	f84a                	sd	s2,48(sp)
    1bb8:	f44e                	sd	s3,40(sp)
    1bba:	f052                	sd	s4,32(sp)
    1bbc:	ec56                	sd	s5,24(sp)
    1bbe:	0880                	addi	s0,sp,80
    1bc0:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    1bc2:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    1bc4:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    1bc8:	06400a13          	li	s4,100
    pid = fork();
    1bcc:	00005097          	auipc	ra,0x5
    1bd0:	a88080e7          	jalr	-1400(ra) # 6654 <fork>
    1bd4:	84aa                	mv	s1,a0
    if(pid < 0){
    1bd6:	02054a63          	bltz	a0,1c0a <exitwait+0x5c>
    if(pid){
    1bda:	c151                	beqz	a0,1c5e <exitwait+0xb0>
      if(wait(&xstate) != pid){
    1bdc:	854e                	mv	a0,s3
    1bde:	00005097          	auipc	ra,0x5
    1be2:	a86080e7          	jalr	-1402(ra) # 6664 <wait>
    1be6:	04951063          	bne	a0,s1,1c26 <exitwait+0x78>
      if(i != xstate) {
    1bea:	fbc42783          	lw	a5,-68(s0)
    1bee:	05279a63          	bne	a5,s2,1c42 <exitwait+0x94>
  for(i = 0; i < 100; i++){
    1bf2:	2905                	addiw	s2,s2,1
    1bf4:	fd491ce3          	bne	s2,s4,1bcc <exitwait+0x1e>
}
    1bf8:	60a6                	ld	ra,72(sp)
    1bfa:	6406                	ld	s0,64(sp)
    1bfc:	74e2                	ld	s1,56(sp)
    1bfe:	7942                	ld	s2,48(sp)
    1c00:	79a2                	ld	s3,40(sp)
    1c02:	7a02                	ld	s4,32(sp)
    1c04:	6ae2                	ld	s5,24(sp)
    1c06:	6161                	addi	sp,sp,80
    1c08:	8082                	ret
      printf("%s: fork failed\n", s);
    1c0a:	85d6                	mv	a1,s5
    1c0c:	00006517          	auipc	a0,0x6
    1c10:	84450513          	addi	a0,a0,-1980 # 7450 <malloc+0x9ba>
    1c14:	00005097          	auipc	ra,0x5
    1c18:	dc6080e7          	jalr	-570(ra) # 69da <printf>
      exit(1);
    1c1c:	4505                	li	a0,1
    1c1e:	00005097          	auipc	ra,0x5
    1c22:	a3e080e7          	jalr	-1474(ra) # 665c <exit>
        printf("%s: wait wrong pid\n", s);
    1c26:	85d6                	mv	a1,s5
    1c28:	00006517          	auipc	a0,0x6
    1c2c:	9b050513          	addi	a0,a0,-1616 # 75d8 <malloc+0xb42>
    1c30:	00005097          	auipc	ra,0x5
    1c34:	daa080e7          	jalr	-598(ra) # 69da <printf>
        exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00005097          	auipc	ra,0x5
    1c3e:	a22080e7          	jalr	-1502(ra) # 665c <exit>
        printf("%s: wait wrong exit status\n", s);
    1c42:	85d6                	mv	a1,s5
    1c44:	00006517          	auipc	a0,0x6
    1c48:	9ac50513          	addi	a0,a0,-1620 # 75f0 <malloc+0xb5a>
    1c4c:	00005097          	auipc	ra,0x5
    1c50:	d8e080e7          	jalr	-626(ra) # 69da <printf>
        exit(1);
    1c54:	4505                	li	a0,1
    1c56:	00005097          	auipc	ra,0x5
    1c5a:	a06080e7          	jalr	-1530(ra) # 665c <exit>
      exit(i);
    1c5e:	854a                	mv	a0,s2
    1c60:	00005097          	auipc	ra,0x5
    1c64:	9fc080e7          	jalr	-1540(ra) # 665c <exit>

0000000000001c68 <twochildren>:
{
    1c68:	1101                	addi	sp,sp,-32
    1c6a:	ec06                	sd	ra,24(sp)
    1c6c:	e822                	sd	s0,16(sp)
    1c6e:	e426                	sd	s1,8(sp)
    1c70:	e04a                	sd	s2,0(sp)
    1c72:	1000                	addi	s0,sp,32
    1c74:	892a                	mv	s2,a0
    1c76:	3e800493          	li	s1,1000
    int pid1 = fork();
    1c7a:	00005097          	auipc	ra,0x5
    1c7e:	9da080e7          	jalr	-1574(ra) # 6654 <fork>
    if(pid1 < 0){
    1c82:	02054c63          	bltz	a0,1cba <twochildren+0x52>
    if(pid1 == 0){
    1c86:	c921                	beqz	a0,1cd6 <twochildren+0x6e>
      int pid2 = fork();
    1c88:	00005097          	auipc	ra,0x5
    1c8c:	9cc080e7          	jalr	-1588(ra) # 6654 <fork>
      if(pid2 < 0){
    1c90:	04054763          	bltz	a0,1cde <twochildren+0x76>
      if(pid2 == 0){
    1c94:	c13d                	beqz	a0,1cfa <twochildren+0x92>
        wait(0);
    1c96:	4501                	li	a0,0
    1c98:	00005097          	auipc	ra,0x5
    1c9c:	9cc080e7          	jalr	-1588(ra) # 6664 <wait>
        wait(0);
    1ca0:	4501                	li	a0,0
    1ca2:	00005097          	auipc	ra,0x5
    1ca6:	9c2080e7          	jalr	-1598(ra) # 6664 <wait>
  for(int i = 0; i < 1000; i++){
    1caa:	34fd                	addiw	s1,s1,-1
    1cac:	f4f9                	bnez	s1,1c7a <twochildren+0x12>
}
    1cae:	60e2                	ld	ra,24(sp)
    1cb0:	6442                	ld	s0,16(sp)
    1cb2:	64a2                	ld	s1,8(sp)
    1cb4:	6902                	ld	s2,0(sp)
    1cb6:	6105                	addi	sp,sp,32
    1cb8:	8082                	ret
      printf("%s: fork failed\n", s);
    1cba:	85ca                	mv	a1,s2
    1cbc:	00005517          	auipc	a0,0x5
    1cc0:	79450513          	addi	a0,a0,1940 # 7450 <malloc+0x9ba>
    1cc4:	00005097          	auipc	ra,0x5
    1cc8:	d16080e7          	jalr	-746(ra) # 69da <printf>
      exit(1);
    1ccc:	4505                	li	a0,1
    1cce:	00005097          	auipc	ra,0x5
    1cd2:	98e080e7          	jalr	-1650(ra) # 665c <exit>
      exit(0);
    1cd6:	00005097          	auipc	ra,0x5
    1cda:	986080e7          	jalr	-1658(ra) # 665c <exit>
        printf("%s: fork failed\n", s);
    1cde:	85ca                	mv	a1,s2
    1ce0:	00005517          	auipc	a0,0x5
    1ce4:	77050513          	addi	a0,a0,1904 # 7450 <malloc+0x9ba>
    1ce8:	00005097          	auipc	ra,0x5
    1cec:	cf2080e7          	jalr	-782(ra) # 69da <printf>
        exit(1);
    1cf0:	4505                	li	a0,1
    1cf2:	00005097          	auipc	ra,0x5
    1cf6:	96a080e7          	jalr	-1686(ra) # 665c <exit>
        exit(0);
    1cfa:	00005097          	auipc	ra,0x5
    1cfe:	962080e7          	jalr	-1694(ra) # 665c <exit>

0000000000001d02 <forkfork>:
{
    1d02:	7179                	addi	sp,sp,-48
    1d04:	f406                	sd	ra,40(sp)
    1d06:	f022                	sd	s0,32(sp)
    1d08:	ec26                	sd	s1,24(sp)
    1d0a:	1800                	addi	s0,sp,48
    1d0c:	84aa                	mv	s1,a0
    int pid = fork();
    1d0e:	00005097          	auipc	ra,0x5
    1d12:	946080e7          	jalr	-1722(ra) # 6654 <fork>
    if(pid < 0){
    1d16:	04054163          	bltz	a0,1d58 <forkfork+0x56>
    if(pid == 0){
    1d1a:	cd29                	beqz	a0,1d74 <forkfork+0x72>
    int pid = fork();
    1d1c:	00005097          	auipc	ra,0x5
    1d20:	938080e7          	jalr	-1736(ra) # 6654 <fork>
    if(pid < 0){
    1d24:	02054a63          	bltz	a0,1d58 <forkfork+0x56>
    if(pid == 0){
    1d28:	c531                	beqz	a0,1d74 <forkfork+0x72>
    wait(&xstatus);
    1d2a:	fdc40513          	addi	a0,s0,-36
    1d2e:	00005097          	auipc	ra,0x5
    1d32:	936080e7          	jalr	-1738(ra) # 6664 <wait>
    if(xstatus != 0) {
    1d36:	fdc42783          	lw	a5,-36(s0)
    1d3a:	ebbd                	bnez	a5,1db0 <forkfork+0xae>
    wait(&xstatus);
    1d3c:	fdc40513          	addi	a0,s0,-36
    1d40:	00005097          	auipc	ra,0x5
    1d44:	924080e7          	jalr	-1756(ra) # 6664 <wait>
    if(xstatus != 0) {
    1d48:	fdc42783          	lw	a5,-36(s0)
    1d4c:	e3b5                	bnez	a5,1db0 <forkfork+0xae>
}
    1d4e:	70a2                	ld	ra,40(sp)
    1d50:	7402                	ld	s0,32(sp)
    1d52:	64e2                	ld	s1,24(sp)
    1d54:	6145                	addi	sp,sp,48
    1d56:	8082                	ret
      printf("%s: fork failed", s);
    1d58:	85a6                	mv	a1,s1
    1d5a:	00006517          	auipc	a0,0x6
    1d5e:	8b650513          	addi	a0,a0,-1866 # 7610 <malloc+0xb7a>
    1d62:	00005097          	auipc	ra,0x5
    1d66:	c78080e7          	jalr	-904(ra) # 69da <printf>
      exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	00005097          	auipc	ra,0x5
    1d70:	8f0080e7          	jalr	-1808(ra) # 665c <exit>
{
    1d74:	0c800493          	li	s1,200
        int pid1 = fork();
    1d78:	00005097          	auipc	ra,0x5
    1d7c:	8dc080e7          	jalr	-1828(ra) # 6654 <fork>
        if(pid1 < 0){
    1d80:	00054f63          	bltz	a0,1d9e <forkfork+0x9c>
        if(pid1 == 0){
    1d84:	c115                	beqz	a0,1da8 <forkfork+0xa6>
        wait(0);
    1d86:	4501                	li	a0,0
    1d88:	00005097          	auipc	ra,0x5
    1d8c:	8dc080e7          	jalr	-1828(ra) # 6664 <wait>
      for(int j = 0; j < 200; j++){
    1d90:	34fd                	addiw	s1,s1,-1
    1d92:	f0fd                	bnez	s1,1d78 <forkfork+0x76>
      exit(0);
    1d94:	4501                	li	a0,0
    1d96:	00005097          	auipc	ra,0x5
    1d9a:	8c6080e7          	jalr	-1850(ra) # 665c <exit>
          exit(1);
    1d9e:	4505                	li	a0,1
    1da0:	00005097          	auipc	ra,0x5
    1da4:	8bc080e7          	jalr	-1860(ra) # 665c <exit>
          exit(0);
    1da8:	00005097          	auipc	ra,0x5
    1dac:	8b4080e7          	jalr	-1868(ra) # 665c <exit>
      printf("%s: fork in child failed", s);
    1db0:	85a6                	mv	a1,s1
    1db2:	00006517          	auipc	a0,0x6
    1db6:	86e50513          	addi	a0,a0,-1938 # 7620 <malloc+0xb8a>
    1dba:	00005097          	auipc	ra,0x5
    1dbe:	c20080e7          	jalr	-992(ra) # 69da <printf>
      exit(1);
    1dc2:	4505                	li	a0,1
    1dc4:	00005097          	auipc	ra,0x5
    1dc8:	898080e7          	jalr	-1896(ra) # 665c <exit>

0000000000001dcc <reparent2>:
{
    1dcc:	1101                	addi	sp,sp,-32
    1dce:	ec06                	sd	ra,24(sp)
    1dd0:	e822                	sd	s0,16(sp)
    1dd2:	e426                	sd	s1,8(sp)
    1dd4:	1000                	addi	s0,sp,32
    1dd6:	32000493          	li	s1,800
    int pid1 = fork();
    1dda:	00005097          	auipc	ra,0x5
    1dde:	87a080e7          	jalr	-1926(ra) # 6654 <fork>
    if(pid1 < 0){
    1de2:	00054f63          	bltz	a0,1e00 <reparent2+0x34>
    if(pid1 == 0){
    1de6:	c915                	beqz	a0,1e1a <reparent2+0x4e>
    wait(0);
    1de8:	4501                	li	a0,0
    1dea:	00005097          	auipc	ra,0x5
    1dee:	87a080e7          	jalr	-1926(ra) # 6664 <wait>
  for(int i = 0; i < 800; i++){
    1df2:	34fd                	addiw	s1,s1,-1
    1df4:	f0fd                	bnez	s1,1dda <reparent2+0xe>
  exit(0);
    1df6:	4501                	li	a0,0
    1df8:	00005097          	auipc	ra,0x5
    1dfc:	864080e7          	jalr	-1948(ra) # 665c <exit>
      printf("fork failed\n");
    1e00:	00006517          	auipc	a0,0x6
    1e04:	a5850513          	addi	a0,a0,-1448 # 7858 <malloc+0xdc2>
    1e08:	00005097          	auipc	ra,0x5
    1e0c:	bd2080e7          	jalr	-1070(ra) # 69da <printf>
      exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00005097          	auipc	ra,0x5
    1e16:	84a080e7          	jalr	-1974(ra) # 665c <exit>
      fork();
    1e1a:	00005097          	auipc	ra,0x5
    1e1e:	83a080e7          	jalr	-1990(ra) # 6654 <fork>
      fork();
    1e22:	00005097          	auipc	ra,0x5
    1e26:	832080e7          	jalr	-1998(ra) # 6654 <fork>
      exit(0);
    1e2a:	4501                	li	a0,0
    1e2c:	00005097          	auipc	ra,0x5
    1e30:	830080e7          	jalr	-2000(ra) # 665c <exit>

0000000000001e34 <createdelete>:
{
    1e34:	7135                	addi	sp,sp,-160
    1e36:	ed06                	sd	ra,152(sp)
    1e38:	e922                	sd	s0,144(sp)
    1e3a:	e526                	sd	s1,136(sp)
    1e3c:	e14a                	sd	s2,128(sp)
    1e3e:	fcce                	sd	s3,120(sp)
    1e40:	f8d2                	sd	s4,112(sp)
    1e42:	f4d6                	sd	s5,104(sp)
    1e44:	f0da                	sd	s6,96(sp)
    1e46:	ecde                	sd	s7,88(sp)
    1e48:	e8e2                	sd	s8,80(sp)
    1e4a:	e4e6                	sd	s9,72(sp)
    1e4c:	e0ea                	sd	s10,64(sp)
    1e4e:	fc6e                	sd	s11,56(sp)
    1e50:	1100                	addi	s0,sp,160
    1e52:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    1e54:	4901                	li	s2,0
    1e56:	4991                	li	s3,4
    pid = fork();
    1e58:	00004097          	auipc	ra,0x4
    1e5c:	7fc080e7          	jalr	2044(ra) # 6654 <fork>
    1e60:	84aa                	mv	s1,a0
    if(pid < 0){
    1e62:	04054263          	bltz	a0,1ea6 <createdelete+0x72>
    if(pid == 0){
    1e66:	cd31                	beqz	a0,1ec2 <createdelete+0x8e>
  for(pi = 0; pi < NCHILD; pi++){
    1e68:	2905                	addiw	s2,s2,1
    1e6a:	ff3917e3          	bne	s2,s3,1e58 <createdelete+0x24>
    1e6e:	4491                	li	s1,4
    wait(&xstatus);
    1e70:	f6c40913          	addi	s2,s0,-148
    1e74:	854a                	mv	a0,s2
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	7ee080e7          	jalr	2030(ra) # 6664 <wait>
    if(xstatus != 0)
    1e7e:	f6c42a83          	lw	s5,-148(s0)
    1e82:	0e0a9663          	bnez	s5,1f6e <createdelete+0x13a>
  for(pi = 0; pi < NCHILD; pi++){
    1e86:	34fd                	addiw	s1,s1,-1
    1e88:	f4f5                	bnez	s1,1e74 <createdelete+0x40>
  name[0] = name[1] = name[2] = 0;
    1e8a:	f6040923          	sb	zero,-142(s0)
    1e8e:	03000913          	li	s2,48
    1e92:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    1e94:	4d25                	li	s10,9
    1e96:	07000c93          	li	s9,112
      fd = open(name, 0);
    1e9a:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1e9e:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1ea0:	07400b13          	li	s6,116
    1ea4:	a28d                	j	2006 <createdelete+0x1d2>
      printf("fork failed\n", s);
    1ea6:	85ee                	mv	a1,s11
    1ea8:	00006517          	auipc	a0,0x6
    1eac:	9b050513          	addi	a0,a0,-1616 # 7858 <malloc+0xdc2>
    1eb0:	00005097          	auipc	ra,0x5
    1eb4:	b2a080e7          	jalr	-1238(ra) # 69da <printf>
      exit(1);
    1eb8:	4505                	li	a0,1
    1eba:	00004097          	auipc	ra,0x4
    1ebe:	7a2080e7          	jalr	1954(ra) # 665c <exit>
      name[0] = 'p' + pi;
    1ec2:	0709091b          	addiw	s2,s2,112
    1ec6:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    1eca:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1ece:	f7040913          	addi	s2,s0,-144
    1ed2:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1ed6:	4a51                	li	s4,20
    1ed8:	a081                	j	1f18 <createdelete+0xe4>
          printf("%s: create failed\n", s);
    1eda:	85ee                	mv	a1,s11
    1edc:	00005517          	auipc	a0,0x5
    1ee0:	60c50513          	addi	a0,a0,1548 # 74e8 <malloc+0xa52>
    1ee4:	00005097          	auipc	ra,0x5
    1ee8:	af6080e7          	jalr	-1290(ra) # 69da <printf>
          exit(1);
    1eec:	4505                	li	a0,1
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	76e080e7          	jalr	1902(ra) # 665c <exit>
          name[1] = '0' + (i / 2);
    1ef6:	01f4d79b          	srliw	a5,s1,0x1f
    1efa:	9fa5                	addw	a5,a5,s1
    1efc:	4017d79b          	sraiw	a5,a5,0x1
    1f00:	0307879b          	addiw	a5,a5,48
    1f04:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1f08:	854a                	mv	a0,s2
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	7a2080e7          	jalr	1954(ra) # 66ac <unlink>
    1f12:	04054063          	bltz	a0,1f52 <createdelete+0x11e>
      for(i = 0; i < N; i++){
    1f16:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1f18:	0304879b          	addiw	a5,s1,48
    1f1c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1f20:	85ce                	mv	a1,s3
    1f22:	854a                	mv	a0,s2
    1f24:	00004097          	auipc	ra,0x4
    1f28:	778080e7          	jalr	1912(ra) # 669c <open>
        if(fd < 0){
    1f2c:	fa0547e3          	bltz	a0,1eda <createdelete+0xa6>
        close(fd);
    1f30:	00004097          	auipc	ra,0x4
    1f34:	754080e7          	jalr	1876(ra) # 6684 <close>
        if(i > 0 && (i % 2 ) == 0){
    1f38:	fc905fe3          	blez	s1,1f16 <createdelete+0xe2>
    1f3c:	0014f793          	andi	a5,s1,1
    1f40:	dbdd                	beqz	a5,1ef6 <createdelete+0xc2>
      for(i = 0; i < N; i++){
    1f42:	2485                	addiw	s1,s1,1
    1f44:	fd449ae3          	bne	s1,s4,1f18 <createdelete+0xe4>
      exit(0);
    1f48:	4501                	li	a0,0
    1f4a:	00004097          	auipc	ra,0x4
    1f4e:	712080e7          	jalr	1810(ra) # 665c <exit>
            printf("%s: unlink failed\n", s);
    1f52:	85ee                	mv	a1,s11
    1f54:	00005517          	auipc	a0,0x5
    1f58:	6ec50513          	addi	a0,a0,1772 # 7640 <malloc+0xbaa>
    1f5c:	00005097          	auipc	ra,0x5
    1f60:	a7e080e7          	jalr	-1410(ra) # 69da <printf>
            exit(1);
    1f64:	4505                	li	a0,1
    1f66:	00004097          	auipc	ra,0x4
    1f6a:	6f6080e7          	jalr	1782(ra) # 665c <exit>
      exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	00004097          	auipc	ra,0x4
    1f74:	6ec080e7          	jalr	1772(ra) # 665c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f78:	054bf863          	bgeu	s7,s4,1fc8 <createdelete+0x194>
      if(fd >= 0)
    1f7c:	06055863          	bgez	a0,1fec <createdelete+0x1b8>
    for(pi = 0; pi < NCHILD; pi++){
    1f80:	2485                	addiw	s1,s1,1
    1f82:	0ff4f493          	zext.b	s1,s1
    1f86:	07648863          	beq	s1,s6,1ff6 <createdelete+0x1c2>
      name[0] = 'p' + pi;
    1f8a:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1f8e:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    1f92:	4581                	li	a1,0
    1f94:	8562                	mv	a0,s8
    1f96:	00004097          	auipc	ra,0x4
    1f9a:	706080e7          	jalr	1798(ra) # 669c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f9e:	01f5579b          	srliw	a5,a0,0x1f
    1fa2:	dbf9                	beqz	a5,1f78 <createdelete+0x144>
    1fa4:	fc098ae3          	beqz	s3,1f78 <createdelete+0x144>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1fa8:	f7040613          	addi	a2,s0,-144
    1fac:	85ee                	mv	a1,s11
    1fae:	00005517          	auipc	a0,0x5
    1fb2:	6aa50513          	addi	a0,a0,1706 # 7658 <malloc+0xbc2>
    1fb6:	00005097          	auipc	ra,0x5
    1fba:	a24080e7          	jalr	-1500(ra) # 69da <printf>
        exit(1);
    1fbe:	4505                	li	a0,1
    1fc0:	00004097          	auipc	ra,0x4
    1fc4:	69c080e7          	jalr	1692(ra) # 665c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1fc8:	fa054ce3          	bltz	a0,1f80 <createdelete+0x14c>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1fcc:	f7040613          	addi	a2,s0,-144
    1fd0:	85ee                	mv	a1,s11
    1fd2:	00005517          	auipc	a0,0x5
    1fd6:	6ae50513          	addi	a0,a0,1710 # 7680 <malloc+0xbea>
    1fda:	00005097          	auipc	ra,0x5
    1fde:	a00080e7          	jalr	-1536(ra) # 69da <printf>
        exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	678080e7          	jalr	1656(ra) # 665c <exit>
        close(fd);
    1fec:	00004097          	auipc	ra,0x4
    1ff0:	698080e7          	jalr	1688(ra) # 6684 <close>
    1ff4:	b771                	j	1f80 <createdelete+0x14c>
  for(i = 0; i < N; i++){
    1ff6:	2a85                	addiw	s5,s5,1
    1ff8:	2a05                	addiw	s4,s4,1
    1ffa:	2905                	addiw	s2,s2,1
    1ffc:	0ff97913          	zext.b	s2,s2
    2000:	47d1                	li	a5,20
    2002:	00fa8a63          	beq	s5,a5,2016 <createdelete+0x1e2>
      if((i == 0 || i >= N/2) && fd < 0){
    2006:	001ab993          	seqz	s3,s5
    200a:	015d27b3          	slt	a5,s10,s5
    200e:	00f9e9b3          	or	s3,s3,a5
    2012:	84e6                	mv	s1,s9
    2014:	bf9d                	j	1f8a <createdelete+0x156>
    2016:	03000993          	li	s3,48
    201a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    201e:	4b11                	li	s6,4
      unlink(name);
    2020:	f7040a13          	addi	s4,s0,-144
  for(i = 0; i < N; i++){
    2024:	08400a93          	li	s5,132
  name[0] = name[1] = name[2] = 0;
    2028:	84da                	mv	s1,s6
      name[0] = 'p' + i;
    202a:	f7240823          	sb	s2,-144(s0)
      name[1] = '0' + i;
    202e:	f73408a3          	sb	s3,-143(s0)
      unlink(name);
    2032:	8552                	mv	a0,s4
    2034:	00004097          	auipc	ra,0x4
    2038:	678080e7          	jalr	1656(ra) # 66ac <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    203c:	34fd                	addiw	s1,s1,-1
    203e:	f4f5                	bnez	s1,202a <createdelete+0x1f6>
  for(i = 0; i < N; i++){
    2040:	2905                	addiw	s2,s2,1
    2042:	0ff97913          	zext.b	s2,s2
    2046:	2985                	addiw	s3,s3,1
    2048:	0ff9f993          	zext.b	s3,s3
    204c:	fd591ee3          	bne	s2,s5,2028 <createdelete+0x1f4>
}
    2050:	60ea                	ld	ra,152(sp)
    2052:	644a                	ld	s0,144(sp)
    2054:	64aa                	ld	s1,136(sp)
    2056:	690a                	ld	s2,128(sp)
    2058:	79e6                	ld	s3,120(sp)
    205a:	7a46                	ld	s4,112(sp)
    205c:	7aa6                	ld	s5,104(sp)
    205e:	7b06                	ld	s6,96(sp)
    2060:	6be6                	ld	s7,88(sp)
    2062:	6c46                	ld	s8,80(sp)
    2064:	6ca6                	ld	s9,72(sp)
    2066:	6d06                	ld	s10,64(sp)
    2068:	7de2                	ld	s11,56(sp)
    206a:	610d                	addi	sp,sp,160
    206c:	8082                	ret

000000000000206e <linkunlink>:
{
    206e:	711d                	addi	sp,sp,-96
    2070:	ec86                	sd	ra,88(sp)
    2072:	e8a2                	sd	s0,80(sp)
    2074:	e4a6                	sd	s1,72(sp)
    2076:	e0ca                	sd	s2,64(sp)
    2078:	fc4e                	sd	s3,56(sp)
    207a:	f852                	sd	s4,48(sp)
    207c:	f456                	sd	s5,40(sp)
    207e:	f05a                	sd	s6,32(sp)
    2080:	ec5e                	sd	s7,24(sp)
    2082:	e862                	sd	s8,16(sp)
    2084:	e466                	sd	s9,8(sp)
    2086:	e06a                	sd	s10,0(sp)
    2088:	1080                	addi	s0,sp,96
    208a:	84aa                	mv	s1,a0
  unlink("x");
    208c:	00005517          	auipc	a0,0x5
    2090:	bac50513          	addi	a0,a0,-1108 # 6c38 <malloc+0x1a2>
    2094:	00004097          	auipc	ra,0x4
    2098:	618080e7          	jalr	1560(ra) # 66ac <unlink>
  pid = fork();
    209c:	00004097          	auipc	ra,0x4
    20a0:	5b8080e7          	jalr	1464(ra) # 6654 <fork>
  if(pid < 0){
    20a4:	04054363          	bltz	a0,20ea <linkunlink+0x7c>
    20a8:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    20aa:	06100913          	li	s2,97
    20ae:	c111                	beqz	a0,20b2 <linkunlink+0x44>
    20b0:	4905                	li	s2,1
    20b2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    20b6:	41c65ab7          	lui	s5,0x41c65
    20ba:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c536e5>
    20be:	6a0d                	lui	s4,0x3
    20c0:	039a0a1b          	addiw	s4,s4,57 # 3039 <sbrklast+0x7d>
    if((x % 3) == 0){
    20c4:	000ab9b7          	lui	s3,0xab
    20c8:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99323>
    20cc:	09b2                	slli	s3,s3,0xc
    20ce:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    20d2:	4b85                	li	s7,1
      unlink("x");
    20d4:	00005b17          	auipc	s6,0x5
    20d8:	b64b0b13          	addi	s6,s6,-1180 # 6c38 <malloc+0x1a2>
      link("cat", "x");
    20dc:	00005c97          	auipc	s9,0x5
    20e0:	5ccc8c93          	addi	s9,s9,1484 # 76a8 <malloc+0xc12>
      close(open("x", O_RDWR | O_CREATE));
    20e4:	20200c13          	li	s8,514
    20e8:	a089                	j	212a <linkunlink+0xbc>
    printf("%s: fork failed\n", s);
    20ea:	85a6                	mv	a1,s1
    20ec:	00005517          	auipc	a0,0x5
    20f0:	36450513          	addi	a0,a0,868 # 7450 <malloc+0x9ba>
    20f4:	00005097          	auipc	ra,0x5
    20f8:	8e6080e7          	jalr	-1818(ra) # 69da <printf>
    exit(1);
    20fc:	4505                	li	a0,1
    20fe:	00004097          	auipc	ra,0x4
    2102:	55e080e7          	jalr	1374(ra) # 665c <exit>
      close(open("x", O_RDWR | O_CREATE));
    2106:	85e2                	mv	a1,s8
    2108:	855a                	mv	a0,s6
    210a:	00004097          	auipc	ra,0x4
    210e:	592080e7          	jalr	1426(ra) # 669c <open>
    2112:	00004097          	auipc	ra,0x4
    2116:	572080e7          	jalr	1394(ra) # 6684 <close>
    211a:	a031                	j	2126 <linkunlink+0xb8>
      unlink("x");
    211c:	855a                	mv	a0,s6
    211e:	00004097          	auipc	ra,0x4
    2122:	58e080e7          	jalr	1422(ra) # 66ac <unlink>
  for(i = 0; i < 100; i++){
    2126:	34fd                	addiw	s1,s1,-1
    2128:	c895                	beqz	s1,215c <linkunlink+0xee>
    x = x * 1103515245 + 12345;
    212a:	035907bb          	mulw	a5,s2,s5
    212e:	00fa07bb          	addw	a5,s4,a5
    2132:	893e                	mv	s2,a5
    if((x % 3) == 0){
    2134:	02079713          	slli	a4,a5,0x20
    2138:	9301                	srli	a4,a4,0x20
    213a:	03370733          	mul	a4,a4,s3
    213e:	9305                	srli	a4,a4,0x21
    2140:	0017169b          	slliw	a3,a4,0x1
    2144:	9f35                	addw	a4,a4,a3
    2146:	9f99                	subw	a5,a5,a4
    2148:	dfdd                	beqz	a5,2106 <linkunlink+0x98>
    } else if((x % 3) == 1){
    214a:	fd7799e3          	bne	a5,s7,211c <linkunlink+0xae>
      link("cat", "x");
    214e:	85da                	mv	a1,s6
    2150:	8566                	mv	a0,s9
    2152:	00004097          	auipc	ra,0x4
    2156:	56a080e7          	jalr	1386(ra) # 66bc <link>
    215a:	b7f1                	j	2126 <linkunlink+0xb8>
  if(pid)
    215c:	020d0563          	beqz	s10,2186 <linkunlink+0x118>
    wait(0);
    2160:	4501                	li	a0,0
    2162:	00004097          	auipc	ra,0x4
    2166:	502080e7          	jalr	1282(ra) # 6664 <wait>
}
    216a:	60e6                	ld	ra,88(sp)
    216c:	6446                	ld	s0,80(sp)
    216e:	64a6                	ld	s1,72(sp)
    2170:	6906                	ld	s2,64(sp)
    2172:	79e2                	ld	s3,56(sp)
    2174:	7a42                	ld	s4,48(sp)
    2176:	7aa2                	ld	s5,40(sp)
    2178:	7b02                	ld	s6,32(sp)
    217a:	6be2                	ld	s7,24(sp)
    217c:	6c42                	ld	s8,16(sp)
    217e:	6ca2                	ld	s9,8(sp)
    2180:	6d02                	ld	s10,0(sp)
    2182:	6125                	addi	sp,sp,96
    2184:	8082                	ret
    exit(0);
    2186:	4501                	li	a0,0
    2188:	00004097          	auipc	ra,0x4
    218c:	4d4080e7          	jalr	1236(ra) # 665c <exit>

0000000000002190 <forktest>:
{
    2190:	7179                	addi	sp,sp,-48
    2192:	f406                	sd	ra,40(sp)
    2194:	f022                	sd	s0,32(sp)
    2196:	ec26                	sd	s1,24(sp)
    2198:	e84a                	sd	s2,16(sp)
    219a:	e44e                	sd	s3,8(sp)
    219c:	1800                	addi	s0,sp,48
    219e:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    21a0:	4481                	li	s1,0
    21a2:	3e800913          	li	s2,1000
    pid = fork();
    21a6:	00004097          	auipc	ra,0x4
    21aa:	4ae080e7          	jalr	1198(ra) # 6654 <fork>
    if(pid < 0)
    21ae:	08054263          	bltz	a0,2232 <forktest+0xa2>
    if(pid == 0)
    21b2:	c115                	beqz	a0,21d6 <forktest+0x46>
  for(n=0; n<N; n++){
    21b4:	2485                	addiw	s1,s1,1
    21b6:	ff2498e3          	bne	s1,s2,21a6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    21ba:	85ce                	mv	a1,s3
    21bc:	00005517          	auipc	a0,0x5
    21c0:	53c50513          	addi	a0,a0,1340 # 76f8 <malloc+0xc62>
    21c4:	00005097          	auipc	ra,0x5
    21c8:	816080e7          	jalr	-2026(ra) # 69da <printf>
    exit(1);
    21cc:	4505                	li	a0,1
    21ce:	00004097          	auipc	ra,0x4
    21d2:	48e080e7          	jalr	1166(ra) # 665c <exit>
      exit(0);
    21d6:	00004097          	auipc	ra,0x4
    21da:	486080e7          	jalr	1158(ra) # 665c <exit>
    printf("%s: no fork at all!\n", s);
    21de:	85ce                	mv	a1,s3
    21e0:	00005517          	auipc	a0,0x5
    21e4:	4d050513          	addi	a0,a0,1232 # 76b0 <malloc+0xc1a>
    21e8:	00004097          	auipc	ra,0x4
    21ec:	7f2080e7          	jalr	2034(ra) # 69da <printf>
    exit(1);
    21f0:	4505                	li	a0,1
    21f2:	00004097          	auipc	ra,0x4
    21f6:	46a080e7          	jalr	1130(ra) # 665c <exit>
      printf("%s: wait stopped early\n", s);
    21fa:	85ce                	mv	a1,s3
    21fc:	00005517          	auipc	a0,0x5
    2200:	4cc50513          	addi	a0,a0,1228 # 76c8 <malloc+0xc32>
    2204:	00004097          	auipc	ra,0x4
    2208:	7d6080e7          	jalr	2006(ra) # 69da <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	44e080e7          	jalr	1102(ra) # 665c <exit>
    printf("%s: wait got too many\n", s);
    2216:	85ce                	mv	a1,s3
    2218:	00005517          	auipc	a0,0x5
    221c:	4c850513          	addi	a0,a0,1224 # 76e0 <malloc+0xc4a>
    2220:	00004097          	auipc	ra,0x4
    2224:	7ba080e7          	jalr	1978(ra) # 69da <printf>
    exit(1);
    2228:	4505                	li	a0,1
    222a:	00004097          	auipc	ra,0x4
    222e:	432080e7          	jalr	1074(ra) # 665c <exit>
  if (n == 0) {
    2232:	d4d5                	beqz	s1,21de <forktest+0x4e>
  for(; n > 0; n--){
    2234:	00905b63          	blez	s1,224a <forktest+0xba>
    if(wait(0) < 0){
    2238:	4501                	li	a0,0
    223a:	00004097          	auipc	ra,0x4
    223e:	42a080e7          	jalr	1066(ra) # 6664 <wait>
    2242:	fa054ce3          	bltz	a0,21fa <forktest+0x6a>
  for(; n > 0; n--){
    2246:	34fd                	addiw	s1,s1,-1
    2248:	f8e5                	bnez	s1,2238 <forktest+0xa8>
  if(wait(0) != -1){
    224a:	4501                	li	a0,0
    224c:	00004097          	auipc	ra,0x4
    2250:	418080e7          	jalr	1048(ra) # 6664 <wait>
    2254:	57fd                	li	a5,-1
    2256:	fcf510e3          	bne	a0,a5,2216 <forktest+0x86>
}
    225a:	70a2                	ld	ra,40(sp)
    225c:	7402                	ld	s0,32(sp)
    225e:	64e2                	ld	s1,24(sp)
    2260:	6942                	ld	s2,16(sp)
    2262:	69a2                	ld	s3,8(sp)
    2264:	6145                	addi	sp,sp,48
    2266:	8082                	ret

0000000000002268 <kernmem>:
{
    2268:	715d                	addi	sp,sp,-80
    226a:	e486                	sd	ra,72(sp)
    226c:	e0a2                	sd	s0,64(sp)
    226e:	fc26                	sd	s1,56(sp)
    2270:	f84a                	sd	s2,48(sp)
    2272:	f44e                	sd	s3,40(sp)
    2274:	f052                	sd	s4,32(sp)
    2276:	ec56                	sd	s5,24(sp)
    2278:	e85a                	sd	s6,16(sp)
    227a:	0880                	addi	s0,sp,80
    227c:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    227e:	4485                	li	s1,1
    2280:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    2282:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    2286:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2288:	69b1                	lui	s3,0xc
    228a:	35098993          	addi	s3,s3,848 # c350 <uninit+0xdd8>
    228e:	1003d937          	lui	s2,0x1003d
    2292:	090e                	slli	s2,s2,0x3
    2294:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002bcf8>
    pid = fork();
    2298:	00004097          	auipc	ra,0x4
    229c:	3bc080e7          	jalr	956(ra) # 6654 <fork>
    if(pid < 0){
    22a0:	02054963          	bltz	a0,22d2 <kernmem+0x6a>
    if(pid == 0){
    22a4:	c529                	beqz	a0,22ee <kernmem+0x86>
    wait(&xstatus);
    22a6:	8556                	mv	a0,s5
    22a8:	00004097          	auipc	ra,0x4
    22ac:	3bc080e7          	jalr	956(ra) # 6664 <wait>
    if(xstatus != -1)  // did kernel kill child?
    22b0:	fbc42783          	lw	a5,-68(s0)
    22b4:	05479e63          	bne	a5,s4,2310 <kernmem+0xa8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    22b8:	94ce                	add	s1,s1,s3
    22ba:	fd249fe3          	bne	s1,s2,2298 <kernmem+0x30>
}
    22be:	60a6                	ld	ra,72(sp)
    22c0:	6406                	ld	s0,64(sp)
    22c2:	74e2                	ld	s1,56(sp)
    22c4:	7942                	ld	s2,48(sp)
    22c6:	79a2                	ld	s3,40(sp)
    22c8:	7a02                	ld	s4,32(sp)
    22ca:	6ae2                	ld	s5,24(sp)
    22cc:	6b42                	ld	s6,16(sp)
    22ce:	6161                	addi	sp,sp,80
    22d0:	8082                	ret
      printf("%s: fork failed\n", s);
    22d2:	85da                	mv	a1,s6
    22d4:	00005517          	auipc	a0,0x5
    22d8:	17c50513          	addi	a0,a0,380 # 7450 <malloc+0x9ba>
    22dc:	00004097          	auipc	ra,0x4
    22e0:	6fe080e7          	jalr	1790(ra) # 69da <printf>
      exit(1);
    22e4:	4505                	li	a0,1
    22e6:	00004097          	auipc	ra,0x4
    22ea:	376080e7          	jalr	886(ra) # 665c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    22ee:	0004c683          	lbu	a3,0(s1)
    22f2:	8626                	mv	a2,s1
    22f4:	85da                	mv	a1,s6
    22f6:	00005517          	auipc	a0,0x5
    22fa:	42a50513          	addi	a0,a0,1066 # 7720 <malloc+0xc8a>
    22fe:	00004097          	auipc	ra,0x4
    2302:	6dc080e7          	jalr	1756(ra) # 69da <printf>
      exit(1);
    2306:	4505                	li	a0,1
    2308:	00004097          	auipc	ra,0x4
    230c:	354080e7          	jalr	852(ra) # 665c <exit>
      exit(1);
    2310:	4505                	li	a0,1
    2312:	00004097          	auipc	ra,0x4
    2316:	34a080e7          	jalr	842(ra) # 665c <exit>

000000000000231a <MAXVAplus>:
{
    231a:	7139                	addi	sp,sp,-64
    231c:	fc06                	sd	ra,56(sp)
    231e:	f822                	sd	s0,48(sp)
    2320:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    2322:	4785                	li	a5,1
    2324:	179a                	slli	a5,a5,0x26
    2326:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    232a:	fc843783          	ld	a5,-56(s0)
    232e:	c3b9                	beqz	a5,2374 <MAXVAplus+0x5a>
    2330:	f426                	sd	s1,40(sp)
    2332:	f04a                	sd	s2,32(sp)
    2334:	ec4e                	sd	s3,24(sp)
    2336:	89aa                	mv	s3,a0
    wait(&xstatus);
    2338:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    233c:	54fd                	li	s1,-1
    pid = fork();
    233e:	00004097          	auipc	ra,0x4
    2342:	316080e7          	jalr	790(ra) # 6654 <fork>
    if(pid < 0){
    2346:	02054b63          	bltz	a0,237c <MAXVAplus+0x62>
    if(pid == 0){
    234a:	c539                	beqz	a0,2398 <MAXVAplus+0x7e>
    wait(&xstatus);
    234c:	854a                	mv	a0,s2
    234e:	00004097          	auipc	ra,0x4
    2352:	316080e7          	jalr	790(ra) # 6664 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2356:	fc442783          	lw	a5,-60(s0)
    235a:	06979563          	bne	a5,s1,23c4 <MAXVAplus+0xaa>
  for( ; a != 0; a <<= 1){
    235e:	fc843783          	ld	a5,-56(s0)
    2362:	0786                	slli	a5,a5,0x1
    2364:	fcf43423          	sd	a5,-56(s0)
    2368:	fc843783          	ld	a5,-56(s0)
    236c:	fbe9                	bnez	a5,233e <MAXVAplus+0x24>
    236e:	74a2                	ld	s1,40(sp)
    2370:	7902                	ld	s2,32(sp)
    2372:	69e2                	ld	s3,24(sp)
}
    2374:	70e2                	ld	ra,56(sp)
    2376:	7442                	ld	s0,48(sp)
    2378:	6121                	addi	sp,sp,64
    237a:	8082                	ret
      printf("%s: fork failed\n", s);
    237c:	85ce                	mv	a1,s3
    237e:	00005517          	auipc	a0,0x5
    2382:	0d250513          	addi	a0,a0,210 # 7450 <malloc+0x9ba>
    2386:	00004097          	auipc	ra,0x4
    238a:	654080e7          	jalr	1620(ra) # 69da <printf>
      exit(1);
    238e:	4505                	li	a0,1
    2390:	00004097          	auipc	ra,0x4
    2394:	2cc080e7          	jalr	716(ra) # 665c <exit>
      *(char*)a = 99;
    2398:	fc843783          	ld	a5,-56(s0)
    239c:	06300713          	li	a4,99
    23a0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    23a4:	fc843603          	ld	a2,-56(s0)
    23a8:	85ce                	mv	a1,s3
    23aa:	00005517          	auipc	a0,0x5
    23ae:	39650513          	addi	a0,a0,918 # 7740 <malloc+0xcaa>
    23b2:	00004097          	auipc	ra,0x4
    23b6:	628080e7          	jalr	1576(ra) # 69da <printf>
      exit(1);
    23ba:	4505                	li	a0,1
    23bc:	00004097          	auipc	ra,0x4
    23c0:	2a0080e7          	jalr	672(ra) # 665c <exit>
      exit(1);
    23c4:	4505                	li	a0,1
    23c6:	00004097          	auipc	ra,0x4
    23ca:	296080e7          	jalr	662(ra) # 665c <exit>

00000000000023ce <bigargtest>:
{
    23ce:	7179                	addi	sp,sp,-48
    23d0:	f406                	sd	ra,40(sp)
    23d2:	f022                	sd	s0,32(sp)
    23d4:	ec26                	sd	s1,24(sp)
    23d6:	1800                	addi	s0,sp,48
    23d8:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    23da:	00005517          	auipc	a0,0x5
    23de:	37e50513          	addi	a0,a0,894 # 7758 <malloc+0xcc2>
    23e2:	00004097          	auipc	ra,0x4
    23e6:	2ca080e7          	jalr	714(ra) # 66ac <unlink>
  pid = fork();
    23ea:	00004097          	auipc	ra,0x4
    23ee:	26a080e7          	jalr	618(ra) # 6654 <fork>
  if(pid == 0){
    23f2:	c121                	beqz	a0,2432 <bigargtest+0x64>
  } else if(pid < 0){
    23f4:	0a054263          	bltz	a0,2498 <bigargtest+0xca>
  wait(&xstatus);
    23f8:	fdc40513          	addi	a0,s0,-36
    23fc:	00004097          	auipc	ra,0x4
    2400:	268080e7          	jalr	616(ra) # 6664 <wait>
  if(xstatus != 0)
    2404:	fdc42503          	lw	a0,-36(s0)
    2408:	e555                	bnez	a0,24b4 <bigargtest+0xe6>
  fd = open("bigarg-ok", 0);
    240a:	4581                	li	a1,0
    240c:	00005517          	auipc	a0,0x5
    2410:	34c50513          	addi	a0,a0,844 # 7758 <malloc+0xcc2>
    2414:	00004097          	auipc	ra,0x4
    2418:	288080e7          	jalr	648(ra) # 669c <open>
  if(fd < 0){
    241c:	0a054063          	bltz	a0,24bc <bigargtest+0xee>
  close(fd);
    2420:	00004097          	auipc	ra,0x4
    2424:	264080e7          	jalr	612(ra) # 6684 <close>
}
    2428:	70a2                	ld	ra,40(sp)
    242a:	7402                	ld	s0,32(sp)
    242c:	64e2                	ld	s1,24(sp)
    242e:	6145                	addi	sp,sp,48
    2430:	8082                	ret
    2432:	00008797          	auipc	a5,0x8
    2436:	03e78793          	addi	a5,a5,62 # a470 <args.1>
    243a:	00008697          	auipc	a3,0x8
    243e:	12e68693          	addi	a3,a3,302 # a568 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2442:	00005717          	auipc	a4,0x5
    2446:	32670713          	addi	a4,a4,806 # 7768 <malloc+0xcd2>
    244a:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    244c:	07a1                	addi	a5,a5,8
    244e:	fed79ee3          	bne	a5,a3,244a <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2452:	00008797          	auipc	a5,0x8
    2456:	1007bb23          	sd	zero,278(a5) # a568 <args.1+0xf8>
    exec("echo", args);
    245a:	00008597          	auipc	a1,0x8
    245e:	01658593          	addi	a1,a1,22 # a470 <args.1>
    2462:	00004517          	auipc	a0,0x4
    2466:	76650513          	addi	a0,a0,1894 # 6bc8 <malloc+0x132>
    246a:	00004097          	auipc	ra,0x4
    246e:	22a080e7          	jalr	554(ra) # 6694 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2472:	20000593          	li	a1,512
    2476:	00005517          	auipc	a0,0x5
    247a:	2e250513          	addi	a0,a0,738 # 7758 <malloc+0xcc2>
    247e:	00004097          	auipc	ra,0x4
    2482:	21e080e7          	jalr	542(ra) # 669c <open>
    close(fd);
    2486:	00004097          	auipc	ra,0x4
    248a:	1fe080e7          	jalr	510(ra) # 6684 <close>
    exit(0);
    248e:	4501                	li	a0,0
    2490:	00004097          	auipc	ra,0x4
    2494:	1cc080e7          	jalr	460(ra) # 665c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2498:	85a6                	mv	a1,s1
    249a:	00005517          	auipc	a0,0x5
    249e:	3ae50513          	addi	a0,a0,942 # 7848 <malloc+0xdb2>
    24a2:	00004097          	auipc	ra,0x4
    24a6:	538080e7          	jalr	1336(ra) # 69da <printf>
    exit(1);
    24aa:	4505                	li	a0,1
    24ac:	00004097          	auipc	ra,0x4
    24b0:	1b0080e7          	jalr	432(ra) # 665c <exit>
    exit(xstatus);
    24b4:	00004097          	auipc	ra,0x4
    24b8:	1a8080e7          	jalr	424(ra) # 665c <exit>
    printf("%s: bigarg test failed!\n", s);
    24bc:	85a6                	mv	a1,s1
    24be:	00005517          	auipc	a0,0x5
    24c2:	3aa50513          	addi	a0,a0,938 # 7868 <malloc+0xdd2>
    24c6:	00004097          	auipc	ra,0x4
    24ca:	514080e7          	jalr	1300(ra) # 69da <printf>
    exit(1);
    24ce:	4505                	li	a0,1
    24d0:	00004097          	auipc	ra,0x4
    24d4:	18c080e7          	jalr	396(ra) # 665c <exit>

00000000000024d8 <stacktest>:
{
    24d8:	7179                	addi	sp,sp,-48
    24da:	f406                	sd	ra,40(sp)
    24dc:	f022                	sd	s0,32(sp)
    24de:	ec26                	sd	s1,24(sp)
    24e0:	1800                	addi	s0,sp,48
    24e2:	84aa                	mv	s1,a0
  pid = fork();
    24e4:	00004097          	auipc	ra,0x4
    24e8:	170080e7          	jalr	368(ra) # 6654 <fork>
  if(pid == 0) {
    24ec:	c115                	beqz	a0,2510 <stacktest+0x38>
  } else if(pid < 0){
    24ee:	04054463          	bltz	a0,2536 <stacktest+0x5e>
  wait(&xstatus);
    24f2:	fdc40513          	addi	a0,s0,-36
    24f6:	00004097          	auipc	ra,0x4
    24fa:	16e080e7          	jalr	366(ra) # 6664 <wait>
  if(xstatus == -1)  // kernel killed child?
    24fe:	fdc42503          	lw	a0,-36(s0)
    2502:	57fd                	li	a5,-1
    2504:	04f50763          	beq	a0,a5,2552 <stacktest+0x7a>
    exit(xstatus);
    2508:	00004097          	auipc	ra,0x4
    250c:	154080e7          	jalr	340(ra) # 665c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2510:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2512:	80078793          	addi	a5,a5,-2048
    2516:	8007c603          	lbu	a2,-2048(a5)
    251a:	85a6                	mv	a1,s1
    251c:	00005517          	auipc	a0,0x5
    2520:	36c50513          	addi	a0,a0,876 # 7888 <malloc+0xdf2>
    2524:	00004097          	auipc	ra,0x4
    2528:	4b6080e7          	jalr	1206(ra) # 69da <printf>
    exit(1);
    252c:	4505                	li	a0,1
    252e:	00004097          	auipc	ra,0x4
    2532:	12e080e7          	jalr	302(ra) # 665c <exit>
    printf("%s: fork failed\n", s);
    2536:	85a6                	mv	a1,s1
    2538:	00005517          	auipc	a0,0x5
    253c:	f1850513          	addi	a0,a0,-232 # 7450 <malloc+0x9ba>
    2540:	00004097          	auipc	ra,0x4
    2544:	49a080e7          	jalr	1178(ra) # 69da <printf>
    exit(1);
    2548:	4505                	li	a0,1
    254a:	00004097          	auipc	ra,0x4
    254e:	112080e7          	jalr	274(ra) # 665c <exit>
    exit(0);
    2552:	4501                	li	a0,0
    2554:	00004097          	auipc	ra,0x4
    2558:	108080e7          	jalr	264(ra) # 665c <exit>

000000000000255c <textwrite>:
{
    255c:	7179                	addi	sp,sp,-48
    255e:	f406                	sd	ra,40(sp)
    2560:	f022                	sd	s0,32(sp)
    2562:	ec26                	sd	s1,24(sp)
    2564:	1800                	addi	s0,sp,48
    2566:	84aa                	mv	s1,a0
  pid = fork();
    2568:	00004097          	auipc	ra,0x4
    256c:	0ec080e7          	jalr	236(ra) # 6654 <fork>
  if(pid == 0) {
    2570:	c115                	beqz	a0,2594 <textwrite+0x38>
  } else if(pid < 0){
    2572:	02054963          	bltz	a0,25a4 <textwrite+0x48>
  wait(&xstatus);
    2576:	fdc40513          	addi	a0,s0,-36
    257a:	00004097          	auipc	ra,0x4
    257e:	0ea080e7          	jalr	234(ra) # 6664 <wait>
  if(xstatus == -1)  // kernel killed child?
    2582:	fdc42503          	lw	a0,-36(s0)
    2586:	57fd                	li	a5,-1
    2588:	02f50c63          	beq	a0,a5,25c0 <textwrite+0x64>
    exit(xstatus);
    258c:	00004097          	auipc	ra,0x4
    2590:	0d0080e7          	jalr	208(ra) # 665c <exit>
    *addr = 10;
    2594:	47a9                	li	a5,10
    2596:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00004097          	auipc	ra,0x4
    25a0:	0c0080e7          	jalr	192(ra) # 665c <exit>
    printf("%s: fork failed\n", s);
    25a4:	85a6                	mv	a1,s1
    25a6:	00005517          	auipc	a0,0x5
    25aa:	eaa50513          	addi	a0,a0,-342 # 7450 <malloc+0x9ba>
    25ae:	00004097          	auipc	ra,0x4
    25b2:	42c080e7          	jalr	1068(ra) # 69da <printf>
    exit(1);
    25b6:	4505                	li	a0,1
    25b8:	00004097          	auipc	ra,0x4
    25bc:	0a4080e7          	jalr	164(ra) # 665c <exit>
    exit(0);
    25c0:	4501                	li	a0,0
    25c2:	00004097          	auipc	ra,0x4
    25c6:	09a080e7          	jalr	154(ra) # 665c <exit>

00000000000025ca <manywrites>:
{
    25ca:	7159                	addi	sp,sp,-112
    25cc:	f486                	sd	ra,104(sp)
    25ce:	f0a2                	sd	s0,96(sp)
    25d0:	eca6                	sd	s1,88(sp)
    25d2:	e8ca                	sd	s2,80(sp)
    25d4:	e4ce                	sd	s3,72(sp)
    25d6:	ec66                	sd	s9,24(sp)
    25d8:	1880                	addi	s0,sp,112
    25da:	8caa                	mv	s9,a0
  for(int ci = 0; ci < nchildren; ci++){
    25dc:	4901                	li	s2,0
    25de:	4991                	li	s3,4
    int pid = fork();
    25e0:	00004097          	auipc	ra,0x4
    25e4:	074080e7          	jalr	116(ra) # 6654 <fork>
    25e8:	84aa                	mv	s1,a0
    if(pid < 0){
    25ea:	04054063          	bltz	a0,262a <manywrites+0x60>
    if(pid == 0){
    25ee:	c12d                	beqz	a0,2650 <manywrites+0x86>
  for(int ci = 0; ci < nchildren; ci++){
    25f0:	2905                	addiw	s2,s2,1
    25f2:	ff3917e3          	bne	s2,s3,25e0 <manywrites+0x16>
    25f6:	4491                	li	s1,4
    wait(&st);
    25f8:	f9840913          	addi	s2,s0,-104
    int st = 0;
    25fc:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    2600:	854a                	mv	a0,s2
    2602:	00004097          	auipc	ra,0x4
    2606:	062080e7          	jalr	98(ra) # 6664 <wait>
    if(st != 0)
    260a:	f9842503          	lw	a0,-104(s0)
    260e:	12051363          	bnez	a0,2734 <manywrites+0x16a>
  for(int ci = 0; ci < nchildren; ci++){
    2612:	34fd                	addiw	s1,s1,-1
    2614:	f4e5                	bnez	s1,25fc <manywrites+0x32>
    2616:	e0d2                	sd	s4,64(sp)
    2618:	fc56                	sd	s5,56(sp)
    261a:	f85a                	sd	s6,48(sp)
    261c:	f45e                	sd	s7,40(sp)
    261e:	f062                	sd	s8,32(sp)
    2620:	e86a                	sd	s10,16(sp)
  exit(0);
    2622:	00004097          	auipc	ra,0x4
    2626:	03a080e7          	jalr	58(ra) # 665c <exit>
    262a:	e0d2                	sd	s4,64(sp)
    262c:	fc56                	sd	s5,56(sp)
    262e:	f85a                	sd	s6,48(sp)
    2630:	f45e                	sd	s7,40(sp)
    2632:	f062                	sd	s8,32(sp)
    2634:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    2636:	00005517          	auipc	a0,0x5
    263a:	22250513          	addi	a0,a0,546 # 7858 <malloc+0xdc2>
    263e:	00004097          	auipc	ra,0x4
    2642:	39c080e7          	jalr	924(ra) # 69da <printf>
      exit(1);
    2646:	4505                	li	a0,1
    2648:	00004097          	auipc	ra,0x4
    264c:	014080e7          	jalr	20(ra) # 665c <exit>
    2650:	e0d2                	sd	s4,64(sp)
    2652:	fc56                	sd	s5,56(sp)
    2654:	f85a                	sd	s6,48(sp)
    2656:	f45e                	sd	s7,40(sp)
    2658:	f062                	sd	s8,32(sp)
    265a:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    265c:	06200793          	li	a5,98
    2660:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    2664:	0619079b          	addiw	a5,s2,97
    2668:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    266c:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    2670:	f9840513          	addi	a0,s0,-104
    2674:	00004097          	auipc	ra,0x4
    2678:	038080e7          	jalr	56(ra) # 66ac <unlink>
    267c:	47f9                	li	a5,30
    267e:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    2680:	f9840b93          	addi	s7,s0,-104
    2684:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    2688:	6a8d                	lui	s5,0x3
    268a:	0000bc17          	auipc	s8,0xb
    268e:	5fec0c13          	addi	s8,s8,1534 # dc88 <buf>
        for(int i = 0; i < ci+1; i++){
    2692:	8a26                	mv	s4,s1
    2694:	02094b63          	bltz	s2,26ca <manywrites+0x100>
          int fd = open(name, O_CREATE | O_RDWR);
    2698:	85da                	mv	a1,s6
    269a:	855e                	mv	a0,s7
    269c:	00004097          	auipc	ra,0x4
    26a0:	000080e7          	jalr	ra # 669c <open>
    26a4:	89aa                	mv	s3,a0
          if(fd < 0){
    26a6:	04054763          	bltz	a0,26f4 <manywrites+0x12a>
          int cc = write(fd, buf, sz);
    26aa:	8656                	mv	a2,s5
    26ac:	85e2                	mv	a1,s8
    26ae:	00004097          	auipc	ra,0x4
    26b2:	fce080e7          	jalr	-50(ra) # 667c <write>
          if(cc != sz){
    26b6:	05551f63          	bne	a0,s5,2714 <manywrites+0x14a>
          close(fd);
    26ba:	854e                	mv	a0,s3
    26bc:	00004097          	auipc	ra,0x4
    26c0:	fc8080e7          	jalr	-56(ra) # 6684 <close>
        for(int i = 0; i < ci+1; i++){
    26c4:	2a05                	addiw	s4,s4,1
    26c6:	fd4959e3          	bge	s2,s4,2698 <manywrites+0xce>
        unlink(name);
    26ca:	f9840513          	addi	a0,s0,-104
    26ce:	00004097          	auipc	ra,0x4
    26d2:	fde080e7          	jalr	-34(ra) # 66ac <unlink>
      for(int iters = 0; iters < howmany; iters++){
    26d6:	fffd079b          	addiw	a5,s10,-1
    26da:	8d3e                	mv	s10,a5
    26dc:	fbdd                	bnez	a5,2692 <manywrites+0xc8>
      unlink(name);
    26de:	f9840513          	addi	a0,s0,-104
    26e2:	00004097          	auipc	ra,0x4
    26e6:	fca080e7          	jalr	-54(ra) # 66ac <unlink>
      exit(0);
    26ea:	4501                	li	a0,0
    26ec:	00004097          	auipc	ra,0x4
    26f0:	f70080e7          	jalr	-144(ra) # 665c <exit>
            printf("%s: cannot create %s\n", s, name);
    26f4:	f9840613          	addi	a2,s0,-104
    26f8:	85e6                	mv	a1,s9
    26fa:	00005517          	auipc	a0,0x5
    26fe:	1b650513          	addi	a0,a0,438 # 78b0 <malloc+0xe1a>
    2702:	00004097          	auipc	ra,0x4
    2706:	2d8080e7          	jalr	728(ra) # 69da <printf>
            exit(1);
    270a:	4505                	li	a0,1
    270c:	00004097          	auipc	ra,0x4
    2710:	f50080e7          	jalr	-176(ra) # 665c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2714:	86aa                	mv	a3,a0
    2716:	660d                	lui	a2,0x3
    2718:	85e6                	mv	a1,s9
    271a:	00004517          	auipc	a0,0x4
    271e:	57e50513          	addi	a0,a0,1406 # 6c98 <malloc+0x202>
    2722:	00004097          	auipc	ra,0x4
    2726:	2b8080e7          	jalr	696(ra) # 69da <printf>
            exit(1);
    272a:	4505                	li	a0,1
    272c:	00004097          	auipc	ra,0x4
    2730:	f30080e7          	jalr	-208(ra) # 665c <exit>
    2734:	e0d2                	sd	s4,64(sp)
    2736:	fc56                	sd	s5,56(sp)
    2738:	f85a                	sd	s6,48(sp)
    273a:	f45e                	sd	s7,40(sp)
    273c:	f062                	sd	s8,32(sp)
    273e:	e86a                	sd	s10,16(sp)
      exit(st);
    2740:	00004097          	auipc	ra,0x4
    2744:	f1c080e7          	jalr	-228(ra) # 665c <exit>

0000000000002748 <copyinstr3>:
{
    2748:	7179                	addi	sp,sp,-48
    274a:	f406                	sd	ra,40(sp)
    274c:	f022                	sd	s0,32(sp)
    274e:	ec26                	sd	s1,24(sp)
    2750:	1800                	addi	s0,sp,48
  sbrk(8192);
    2752:	6509                	lui	a0,0x2
    2754:	00004097          	auipc	ra,0x4
    2758:	f90080e7          	jalr	-112(ra) # 66e4 <sbrk>
  uint64 top = (uint64) sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00004097          	auipc	ra,0x4
    2762:	f86080e7          	jalr	-122(ra) # 66e4 <sbrk>
  if((top % PGSIZE) != 0){
    2766:	03451793          	slli	a5,a0,0x34
    276a:	e3c9                	bnez	a5,27ec <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    276c:	4501                	li	a0,0
    276e:	00004097          	auipc	ra,0x4
    2772:	f76080e7          	jalr	-138(ra) # 66e4 <sbrk>
  if(top % PGSIZE){
    2776:	03451793          	slli	a5,a0,0x34
    277a:	e3d9                	bnez	a5,2800 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    277c:	fff50493          	addi	s1,a0,-1 # 1fff <createdelete+0x1cb>
  *b = 'x';
    2780:	07800793          	li	a5,120
    2784:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2788:	8526                	mv	a0,s1
    278a:	00004097          	auipc	ra,0x4
    278e:	f22080e7          	jalr	-222(ra) # 66ac <unlink>
  if(ret != -1){
    2792:	57fd                	li	a5,-1
    2794:	08f51363          	bne	a0,a5,281a <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2798:	20100593          	li	a1,513
    279c:	8526                	mv	a0,s1
    279e:	00004097          	auipc	ra,0x4
    27a2:	efe080e7          	jalr	-258(ra) # 669c <open>
  if(fd != -1){
    27a6:	57fd                	li	a5,-1
    27a8:	08f51863          	bne	a0,a5,2838 <copyinstr3+0xf0>
  ret = link(b, b);
    27ac:	85a6                	mv	a1,s1
    27ae:	8526                	mv	a0,s1
    27b0:	00004097          	auipc	ra,0x4
    27b4:	f0c080e7          	jalr	-244(ra) # 66bc <link>
  if(ret != -1){
    27b8:	57fd                	li	a5,-1
    27ba:	08f51e63          	bne	a0,a5,2856 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    27be:	00006797          	auipc	a5,0x6
    27c2:	dea78793          	addi	a5,a5,-534 # 85a8 <malloc+0x1b12>
    27c6:	fcf43823          	sd	a5,-48(s0)
    27ca:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    27ce:	fd040593          	addi	a1,s0,-48
    27d2:	8526                	mv	a0,s1
    27d4:	00004097          	auipc	ra,0x4
    27d8:	ec0080e7          	jalr	-320(ra) # 6694 <exec>
  if(ret != -1){
    27dc:	57fd                	li	a5,-1
    27de:	08f51c63          	bne	a0,a5,2876 <copyinstr3+0x12e>
}
    27e2:	70a2                	ld	ra,40(sp)
    27e4:	7402                	ld	s0,32(sp)
    27e6:	64e2                	ld	s1,24(sp)
    27e8:	6145                	addi	sp,sp,48
    27ea:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    27ec:	0347d513          	srli	a0,a5,0x34
    27f0:	6785                	lui	a5,0x1
    27f2:	40a7853b          	subw	a0,a5,a0
    27f6:	00004097          	auipc	ra,0x4
    27fa:	eee080e7          	jalr	-274(ra) # 66e4 <sbrk>
    27fe:	b7bd                	j	276c <copyinstr3+0x24>
    printf("oops\n");
    2800:	00005517          	auipc	a0,0x5
    2804:	0c850513          	addi	a0,a0,200 # 78c8 <malloc+0xe32>
    2808:	00004097          	auipc	ra,0x4
    280c:	1d2080e7          	jalr	466(ra) # 69da <printf>
    exit(1);
    2810:	4505                	li	a0,1
    2812:	00004097          	auipc	ra,0x4
    2816:	e4a080e7          	jalr	-438(ra) # 665c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    281a:	862a                	mv	a2,a0
    281c:	85a6                	mv	a1,s1
    281e:	00005517          	auipc	a0,0x5
    2822:	b5250513          	addi	a0,a0,-1198 # 7370 <malloc+0x8da>
    2826:	00004097          	auipc	ra,0x4
    282a:	1b4080e7          	jalr	436(ra) # 69da <printf>
    exit(1);
    282e:	4505                	li	a0,1
    2830:	00004097          	auipc	ra,0x4
    2834:	e2c080e7          	jalr	-468(ra) # 665c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2838:	862a                	mv	a2,a0
    283a:	85a6                	mv	a1,s1
    283c:	00005517          	auipc	a0,0x5
    2840:	b5450513          	addi	a0,a0,-1196 # 7390 <malloc+0x8fa>
    2844:	00004097          	auipc	ra,0x4
    2848:	196080e7          	jalr	406(ra) # 69da <printf>
    exit(1);
    284c:	4505                	li	a0,1
    284e:	00004097          	auipc	ra,0x4
    2852:	e0e080e7          	jalr	-498(ra) # 665c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2856:	86aa                	mv	a3,a0
    2858:	8626                	mv	a2,s1
    285a:	85a6                	mv	a1,s1
    285c:	00005517          	auipc	a0,0x5
    2860:	b5450513          	addi	a0,a0,-1196 # 73b0 <malloc+0x91a>
    2864:	00004097          	auipc	ra,0x4
    2868:	176080e7          	jalr	374(ra) # 69da <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	00004097          	auipc	ra,0x4
    2872:	dee080e7          	jalr	-530(ra) # 665c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2876:	863e                	mv	a2,a5
    2878:	85a6                	mv	a1,s1
    287a:	00005517          	auipc	a0,0x5
    287e:	b5e50513          	addi	a0,a0,-1186 # 73d8 <malloc+0x942>
    2882:	00004097          	auipc	ra,0x4
    2886:	158080e7          	jalr	344(ra) # 69da <printf>
    exit(1);
    288a:	4505                	li	a0,1
    288c:	00004097          	auipc	ra,0x4
    2890:	dd0080e7          	jalr	-560(ra) # 665c <exit>

0000000000002894 <rwsbrk>:
{
    2894:	1101                	addi	sp,sp,-32
    2896:	ec06                	sd	ra,24(sp)
    2898:	e822                	sd	s0,16(sp)
    289a:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    289c:	6509                	lui	a0,0x2
    289e:	00004097          	auipc	ra,0x4
    28a2:	e46080e7          	jalr	-442(ra) # 66e4 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    28a6:	57fd                	li	a5,-1
    28a8:	06f50463          	beq	a0,a5,2910 <rwsbrk+0x7c>
    28ac:	e426                	sd	s1,8(sp)
    28ae:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    28b0:	7579                	lui	a0,0xffffe
    28b2:	00004097          	auipc	ra,0x4
    28b6:	e32080e7          	jalr	-462(ra) # 66e4 <sbrk>
    28ba:	57fd                	li	a5,-1
    28bc:	06f50963          	beq	a0,a5,292e <rwsbrk+0x9a>
    28c0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    28c2:	20100593          	li	a1,513
    28c6:	00005517          	auipc	a0,0x5
    28ca:	04250513          	addi	a0,a0,66 # 7908 <malloc+0xe72>
    28ce:	00004097          	auipc	ra,0x4
    28d2:	dce080e7          	jalr	-562(ra) # 669c <open>
    28d6:	892a                	mv	s2,a0
  if(fd < 0){
    28d8:	06054963          	bltz	a0,294a <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    28dc:	6785                	lui	a5,0x1
    28de:	94be                	add	s1,s1,a5
    28e0:	40000613          	li	a2,1024
    28e4:	85a6                	mv	a1,s1
    28e6:	00004097          	auipc	ra,0x4
    28ea:	d96080e7          	jalr	-618(ra) # 667c <write>
    28ee:	862a                	mv	a2,a0
  if(n >= 0){
    28f0:	06054a63          	bltz	a0,2964 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    28f4:	85a6                	mv	a1,s1
    28f6:	00005517          	auipc	a0,0x5
    28fa:	03250513          	addi	a0,a0,50 # 7928 <malloc+0xe92>
    28fe:	00004097          	auipc	ra,0x4
    2902:	0dc080e7          	jalr	220(ra) # 69da <printf>
    exit(1);
    2906:	4505                	li	a0,1
    2908:	00004097          	auipc	ra,0x4
    290c:	d54080e7          	jalr	-684(ra) # 665c <exit>
    2910:	e426                	sd	s1,8(sp)
    2912:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2914:	00005517          	auipc	a0,0x5
    2918:	fbc50513          	addi	a0,a0,-68 # 78d0 <malloc+0xe3a>
    291c:	00004097          	auipc	ra,0x4
    2920:	0be080e7          	jalr	190(ra) # 69da <printf>
    exit(1);
    2924:	4505                	li	a0,1
    2926:	00004097          	auipc	ra,0x4
    292a:	d36080e7          	jalr	-714(ra) # 665c <exit>
    292e:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2930:	00005517          	auipc	a0,0x5
    2934:	fb850513          	addi	a0,a0,-72 # 78e8 <malloc+0xe52>
    2938:	00004097          	auipc	ra,0x4
    293c:	0a2080e7          	jalr	162(ra) # 69da <printf>
    exit(1);
    2940:	4505                	li	a0,1
    2942:	00004097          	auipc	ra,0x4
    2946:	d1a080e7          	jalr	-742(ra) # 665c <exit>
    printf("open(rwsbrk) failed\n");
    294a:	00005517          	auipc	a0,0x5
    294e:	fc650513          	addi	a0,a0,-58 # 7910 <malloc+0xe7a>
    2952:	00004097          	auipc	ra,0x4
    2956:	088080e7          	jalr	136(ra) # 69da <printf>
    exit(1);
    295a:	4505                	li	a0,1
    295c:	00004097          	auipc	ra,0x4
    2960:	d00080e7          	jalr	-768(ra) # 665c <exit>
  close(fd);
    2964:	854a                	mv	a0,s2
    2966:	00004097          	auipc	ra,0x4
    296a:	d1e080e7          	jalr	-738(ra) # 6684 <close>
  unlink("rwsbrk");
    296e:	00005517          	auipc	a0,0x5
    2972:	f9a50513          	addi	a0,a0,-102 # 7908 <malloc+0xe72>
    2976:	00004097          	auipc	ra,0x4
    297a:	d36080e7          	jalr	-714(ra) # 66ac <unlink>
  fd = open("README", O_RDONLY);
    297e:	4581                	li	a1,0
    2980:	00004517          	auipc	a0,0x4
    2984:	42050513          	addi	a0,a0,1056 # 6da0 <malloc+0x30a>
    2988:	00004097          	auipc	ra,0x4
    298c:	d14080e7          	jalr	-748(ra) # 669c <open>
    2990:	892a                	mv	s2,a0
  if(fd < 0){
    2992:	02054963          	bltz	a0,29c4 <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2996:	4629                	li	a2,10
    2998:	85a6                	mv	a1,s1
    299a:	00004097          	auipc	ra,0x4
    299e:	cda080e7          	jalr	-806(ra) # 6674 <read>
    29a2:	862a                	mv	a2,a0
  if(n >= 0){
    29a4:	02054d63          	bltz	a0,29de <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    29a8:	85a6                	mv	a1,s1
    29aa:	00005517          	auipc	a0,0x5
    29ae:	fae50513          	addi	a0,a0,-82 # 7958 <malloc+0xec2>
    29b2:	00004097          	auipc	ra,0x4
    29b6:	028080e7          	jalr	40(ra) # 69da <printf>
    exit(1);
    29ba:	4505                	li	a0,1
    29bc:	00004097          	auipc	ra,0x4
    29c0:	ca0080e7          	jalr	-864(ra) # 665c <exit>
    printf("open(rwsbrk) failed\n");
    29c4:	00005517          	auipc	a0,0x5
    29c8:	f4c50513          	addi	a0,a0,-180 # 7910 <malloc+0xe7a>
    29cc:	00004097          	auipc	ra,0x4
    29d0:	00e080e7          	jalr	14(ra) # 69da <printf>
    exit(1);
    29d4:	4505                	li	a0,1
    29d6:	00004097          	auipc	ra,0x4
    29da:	c86080e7          	jalr	-890(ra) # 665c <exit>
  close(fd);
    29de:	854a                	mv	a0,s2
    29e0:	00004097          	auipc	ra,0x4
    29e4:	ca4080e7          	jalr	-860(ra) # 6684 <close>
  exit(0);
    29e8:	4501                	li	a0,0
    29ea:	00004097          	auipc	ra,0x4
    29ee:	c72080e7          	jalr	-910(ra) # 665c <exit>

00000000000029f2 <sbrkbasic>:
{
    29f2:	715d                	addi	sp,sp,-80
    29f4:	e486                	sd	ra,72(sp)
    29f6:	e0a2                	sd	s0,64(sp)
    29f8:	ec56                	sd	s5,24(sp)
    29fa:	0880                	addi	s0,sp,80
    29fc:	8aaa                	mv	s5,a0
  pid = fork();
    29fe:	00004097          	auipc	ra,0x4
    2a02:	c56080e7          	jalr	-938(ra) # 6654 <fork>
  if(pid < 0){
    2a06:	04054063          	bltz	a0,2a46 <sbrkbasic+0x54>
  if(pid == 0){
    2a0a:	e925                	bnez	a0,2a7a <sbrkbasic+0x88>
    a = sbrk(TOOMUCH);
    2a0c:	40000537          	lui	a0,0x40000
    2a10:	00004097          	auipc	ra,0x4
    2a14:	cd4080e7          	jalr	-812(ra) # 66e4 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2a18:	57fd                	li	a5,-1
    2a1a:	04f50763          	beq	a0,a5,2a68 <sbrkbasic+0x76>
    2a1e:	fc26                	sd	s1,56(sp)
    2a20:	f84a                	sd	s2,48(sp)
    2a22:	f44e                	sd	s3,40(sp)
    2a24:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    2a26:	400007b7          	lui	a5,0x40000
    2a2a:	97aa                	add	a5,a5,a0
      *b = 99;
    2a2c:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2a30:	6705                	lui	a4,0x1
      *b = 99;
    2a32:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffee878>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2a36:	953a                	add	a0,a0,a4
    2a38:	fef51de3          	bne	a0,a5,2a32 <sbrkbasic+0x40>
    exit(1);
    2a3c:	4505                	li	a0,1
    2a3e:	00004097          	auipc	ra,0x4
    2a42:	c1e080e7          	jalr	-994(ra) # 665c <exit>
    2a46:	fc26                	sd	s1,56(sp)
    2a48:	f84a                	sd	s2,48(sp)
    2a4a:	f44e                	sd	s3,40(sp)
    2a4c:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2a4e:	00005517          	auipc	a0,0x5
    2a52:	f3250513          	addi	a0,a0,-206 # 7980 <malloc+0xeea>
    2a56:	00004097          	auipc	ra,0x4
    2a5a:	f84080e7          	jalr	-124(ra) # 69da <printf>
    exit(1);
    2a5e:	4505                	li	a0,1
    2a60:	00004097          	auipc	ra,0x4
    2a64:	bfc080e7          	jalr	-1028(ra) # 665c <exit>
    2a68:	fc26                	sd	s1,56(sp)
    2a6a:	f84a                	sd	s2,48(sp)
    2a6c:	f44e                	sd	s3,40(sp)
    2a6e:	f052                	sd	s4,32(sp)
      exit(0);
    2a70:	4501                	li	a0,0
    2a72:	00004097          	auipc	ra,0x4
    2a76:	bea080e7          	jalr	-1046(ra) # 665c <exit>
  wait(&xstatus);
    2a7a:	fbc40513          	addi	a0,s0,-68
    2a7e:	00004097          	auipc	ra,0x4
    2a82:	be6080e7          	jalr	-1050(ra) # 6664 <wait>
  if(xstatus == 1){
    2a86:	fbc42703          	lw	a4,-68(s0)
    2a8a:	4785                	li	a5,1
    2a8c:	02f70263          	beq	a4,a5,2ab0 <sbrkbasic+0xbe>
    2a90:	fc26                	sd	s1,56(sp)
    2a92:	f84a                	sd	s2,48(sp)
    2a94:	f44e                	sd	s3,40(sp)
    2a96:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    2a98:	4501                	li	a0,0
    2a9a:	00004097          	auipc	ra,0x4
    2a9e:	c4a080e7          	jalr	-950(ra) # 66e4 <sbrk>
    2aa2:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2aa4:	4901                	li	s2,0
    b = sbrk(1);
    2aa6:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2aa8:	6a05                	lui	s4,0x1
    2aaa:	388a0a13          	addi	s4,s4,904 # 1388 <pgbug+0xe>
    2aae:	a025                	j	2ad6 <sbrkbasic+0xe4>
    2ab0:	fc26                	sd	s1,56(sp)
    2ab2:	f84a                	sd	s2,48(sp)
    2ab4:	f44e                	sd	s3,40(sp)
    2ab6:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2ab8:	85d6                	mv	a1,s5
    2aba:	00005517          	auipc	a0,0x5
    2abe:	ee650513          	addi	a0,a0,-282 # 79a0 <malloc+0xf0a>
    2ac2:	00004097          	auipc	ra,0x4
    2ac6:	f18080e7          	jalr	-232(ra) # 69da <printf>
    exit(1);
    2aca:	4505                	li	a0,1
    2acc:	00004097          	auipc	ra,0x4
    2ad0:	b90080e7          	jalr	-1136(ra) # 665c <exit>
    2ad4:	84be                	mv	s1,a5
    b = sbrk(1);
    2ad6:	854e                	mv	a0,s3
    2ad8:	00004097          	auipc	ra,0x4
    2adc:	c0c080e7          	jalr	-1012(ra) # 66e4 <sbrk>
    if(b != a){
    2ae0:	04951b63          	bne	a0,s1,2b36 <sbrkbasic+0x144>
    *b = 1;
    2ae4:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2ae8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2aec:	2905                	addiw	s2,s2,1
    2aee:	ff4913e3          	bne	s2,s4,2ad4 <sbrkbasic+0xe2>
  pid = fork();
    2af2:	00004097          	auipc	ra,0x4
    2af6:	b62080e7          	jalr	-1182(ra) # 6654 <fork>
    2afa:	892a                	mv	s2,a0
  if(pid < 0){
    2afc:	04054e63          	bltz	a0,2b58 <sbrkbasic+0x166>
  c = sbrk(1);
    2b00:	4505                	li	a0,1
    2b02:	00004097          	auipc	ra,0x4
    2b06:	be2080e7          	jalr	-1054(ra) # 66e4 <sbrk>
  c = sbrk(1);
    2b0a:	4505                	li	a0,1
    2b0c:	00004097          	auipc	ra,0x4
    2b10:	bd8080e7          	jalr	-1064(ra) # 66e4 <sbrk>
  if(c != a + 1){
    2b14:	0489                	addi	s1,s1,2
    2b16:	04950f63          	beq	a0,s1,2b74 <sbrkbasic+0x182>
    printf("%s: sbrk test failed post-fork\n", s);
    2b1a:	85d6                	mv	a1,s5
    2b1c:	00005517          	auipc	a0,0x5
    2b20:	ee450513          	addi	a0,a0,-284 # 7a00 <malloc+0xf6a>
    2b24:	00004097          	auipc	ra,0x4
    2b28:	eb6080e7          	jalr	-330(ra) # 69da <printf>
    exit(1);
    2b2c:	4505                	li	a0,1
    2b2e:	00004097          	auipc	ra,0x4
    2b32:	b2e080e7          	jalr	-1234(ra) # 665c <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2b36:	872a                	mv	a4,a0
    2b38:	86a6                	mv	a3,s1
    2b3a:	864a                	mv	a2,s2
    2b3c:	85d6                	mv	a1,s5
    2b3e:	00005517          	auipc	a0,0x5
    2b42:	e8250513          	addi	a0,a0,-382 # 79c0 <malloc+0xf2a>
    2b46:	00004097          	auipc	ra,0x4
    2b4a:	e94080e7          	jalr	-364(ra) # 69da <printf>
      exit(1);
    2b4e:	4505                	li	a0,1
    2b50:	00004097          	auipc	ra,0x4
    2b54:	b0c080e7          	jalr	-1268(ra) # 665c <exit>
    printf("%s: sbrk test fork failed\n", s);
    2b58:	85d6                	mv	a1,s5
    2b5a:	00005517          	auipc	a0,0x5
    2b5e:	e8650513          	addi	a0,a0,-378 # 79e0 <malloc+0xf4a>
    2b62:	00004097          	auipc	ra,0x4
    2b66:	e78080e7          	jalr	-392(ra) # 69da <printf>
    exit(1);
    2b6a:	4505                	li	a0,1
    2b6c:	00004097          	auipc	ra,0x4
    2b70:	af0080e7          	jalr	-1296(ra) # 665c <exit>
  if(pid == 0)
    2b74:	00091763          	bnez	s2,2b82 <sbrkbasic+0x190>
    exit(0);
    2b78:	4501                	li	a0,0
    2b7a:	00004097          	auipc	ra,0x4
    2b7e:	ae2080e7          	jalr	-1310(ra) # 665c <exit>
  wait(&xstatus);
    2b82:	fbc40513          	addi	a0,s0,-68
    2b86:	00004097          	auipc	ra,0x4
    2b8a:	ade080e7          	jalr	-1314(ra) # 6664 <wait>
  exit(xstatus);
    2b8e:	fbc42503          	lw	a0,-68(s0)
    2b92:	00004097          	auipc	ra,0x4
    2b96:	aca080e7          	jalr	-1334(ra) # 665c <exit>

0000000000002b9a <sbrkmuch>:
{
    2b9a:	7179                	addi	sp,sp,-48
    2b9c:	f406                	sd	ra,40(sp)
    2b9e:	f022                	sd	s0,32(sp)
    2ba0:	ec26                	sd	s1,24(sp)
    2ba2:	e84a                	sd	s2,16(sp)
    2ba4:	e44e                	sd	s3,8(sp)
    2ba6:	e052                	sd	s4,0(sp)
    2ba8:	1800                	addi	s0,sp,48
    2baa:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2bac:	4501                	li	a0,0
    2bae:	00004097          	auipc	ra,0x4
    2bb2:	b36080e7          	jalr	-1226(ra) # 66e4 <sbrk>
    2bb6:	892a                	mv	s2,a0
  a = sbrk(0);
    2bb8:	4501                	li	a0,0
    2bba:	00004097          	auipc	ra,0x4
    2bbe:	b2a080e7          	jalr	-1238(ra) # 66e4 <sbrk>
    2bc2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2bc4:	06400537          	lui	a0,0x6400
    2bc8:	9d05                	subw	a0,a0,s1
    2bca:	00004097          	auipc	ra,0x4
    2bce:	b1a080e7          	jalr	-1254(ra) # 66e4 <sbrk>
  if (p != a) {
    2bd2:	0ca49a63          	bne	s1,a0,2ca6 <sbrkmuch+0x10c>
  char *eee = sbrk(0);
    2bd6:	4501                	li	a0,0
    2bd8:	00004097          	auipc	ra,0x4
    2bdc:	b0c080e7          	jalr	-1268(ra) # 66e4 <sbrk>
    2be0:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2be2:	00a4f963          	bgeu	s1,a0,2bf4 <sbrkmuch+0x5a>
    *pp = 1;
    2be6:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2be8:	6705                	lui	a4,0x1
    *pp = 1;
    2bea:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2bee:	94ba                	add	s1,s1,a4
    2bf0:	fef4ede3          	bltu	s1,a5,2bea <sbrkmuch+0x50>
  *lastaddr = 99;
    2bf4:	064007b7          	lui	a5,0x6400
    2bf8:	06300713          	li	a4,99
    2bfc:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ee877>
  a = sbrk(0);
    2c00:	4501                	li	a0,0
    2c02:	00004097          	auipc	ra,0x4
    2c06:	ae2080e7          	jalr	-1310(ra) # 66e4 <sbrk>
    2c0a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2c0c:	757d                	lui	a0,0xfffff
    2c0e:	00004097          	auipc	ra,0x4
    2c12:	ad6080e7          	jalr	-1322(ra) # 66e4 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2c16:	57fd                	li	a5,-1
    2c18:	0af50563          	beq	a0,a5,2cc2 <sbrkmuch+0x128>
  c = sbrk(0);
    2c1c:	4501                	li	a0,0
    2c1e:	00004097          	auipc	ra,0x4
    2c22:	ac6080e7          	jalr	-1338(ra) # 66e4 <sbrk>
  if(c != a - PGSIZE){
    2c26:	80048793          	addi	a5,s1,-2048
    2c2a:	80078793          	addi	a5,a5,-2048
    2c2e:	0af51863          	bne	a0,a5,2cde <sbrkmuch+0x144>
  a = sbrk(0);
    2c32:	4501                	li	a0,0
    2c34:	00004097          	auipc	ra,0x4
    2c38:	ab0080e7          	jalr	-1360(ra) # 66e4 <sbrk>
    2c3c:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2c3e:	6505                	lui	a0,0x1
    2c40:	00004097          	auipc	ra,0x4
    2c44:	aa4080e7          	jalr	-1372(ra) # 66e4 <sbrk>
    2c48:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2c4a:	0aa49a63          	bne	s1,a0,2cfe <sbrkmuch+0x164>
    2c4e:	4501                	li	a0,0
    2c50:	00004097          	auipc	ra,0x4
    2c54:	a94080e7          	jalr	-1388(ra) # 66e4 <sbrk>
    2c58:	6785                	lui	a5,0x1
    2c5a:	97a6                	add	a5,a5,s1
    2c5c:	0af51163          	bne	a0,a5,2cfe <sbrkmuch+0x164>
  if(*lastaddr == 99){
    2c60:	064007b7          	lui	a5,0x6400
    2c64:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ee877>
    2c68:	06300793          	li	a5,99
    2c6c:	0af70963          	beq	a4,a5,2d1e <sbrkmuch+0x184>
  a = sbrk(0);
    2c70:	4501                	li	a0,0
    2c72:	00004097          	auipc	ra,0x4
    2c76:	a72080e7          	jalr	-1422(ra) # 66e4 <sbrk>
    2c7a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2c7c:	4501                	li	a0,0
    2c7e:	00004097          	auipc	ra,0x4
    2c82:	a66080e7          	jalr	-1434(ra) # 66e4 <sbrk>
    2c86:	40a9053b          	subw	a0,s2,a0
    2c8a:	00004097          	auipc	ra,0x4
    2c8e:	a5a080e7          	jalr	-1446(ra) # 66e4 <sbrk>
  if(c != a){
    2c92:	0aa49463          	bne	s1,a0,2d3a <sbrkmuch+0x1a0>
}
    2c96:	70a2                	ld	ra,40(sp)
    2c98:	7402                	ld	s0,32(sp)
    2c9a:	64e2                	ld	s1,24(sp)
    2c9c:	6942                	ld	s2,16(sp)
    2c9e:	69a2                	ld	s3,8(sp)
    2ca0:	6a02                	ld	s4,0(sp)
    2ca2:	6145                	addi	sp,sp,48
    2ca4:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2ca6:	85ce                	mv	a1,s3
    2ca8:	00005517          	auipc	a0,0x5
    2cac:	d7850513          	addi	a0,a0,-648 # 7a20 <malloc+0xf8a>
    2cb0:	00004097          	auipc	ra,0x4
    2cb4:	d2a080e7          	jalr	-726(ra) # 69da <printf>
    exit(1);
    2cb8:	4505                	li	a0,1
    2cba:	00004097          	auipc	ra,0x4
    2cbe:	9a2080e7          	jalr	-1630(ra) # 665c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2cc2:	85ce                	mv	a1,s3
    2cc4:	00005517          	auipc	a0,0x5
    2cc8:	da450513          	addi	a0,a0,-604 # 7a68 <malloc+0xfd2>
    2ccc:	00004097          	auipc	ra,0x4
    2cd0:	d0e080e7          	jalr	-754(ra) # 69da <printf>
    exit(1);
    2cd4:	4505                	li	a0,1
    2cd6:	00004097          	auipc	ra,0x4
    2cda:	986080e7          	jalr	-1658(ra) # 665c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2cde:	86aa                	mv	a3,a0
    2ce0:	8626                	mv	a2,s1
    2ce2:	85ce                	mv	a1,s3
    2ce4:	00005517          	auipc	a0,0x5
    2ce8:	da450513          	addi	a0,a0,-604 # 7a88 <malloc+0xff2>
    2cec:	00004097          	auipc	ra,0x4
    2cf0:	cee080e7          	jalr	-786(ra) # 69da <printf>
    exit(1);
    2cf4:	4505                	li	a0,1
    2cf6:	00004097          	auipc	ra,0x4
    2cfa:	966080e7          	jalr	-1690(ra) # 665c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2cfe:	86d2                	mv	a3,s4
    2d00:	8626                	mv	a2,s1
    2d02:	85ce                	mv	a1,s3
    2d04:	00005517          	auipc	a0,0x5
    2d08:	dc450513          	addi	a0,a0,-572 # 7ac8 <malloc+0x1032>
    2d0c:	00004097          	auipc	ra,0x4
    2d10:	cce080e7          	jalr	-818(ra) # 69da <printf>
    exit(1);
    2d14:	4505                	li	a0,1
    2d16:	00004097          	auipc	ra,0x4
    2d1a:	946080e7          	jalr	-1722(ra) # 665c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2d1e:	85ce                	mv	a1,s3
    2d20:	00005517          	auipc	a0,0x5
    2d24:	dd850513          	addi	a0,a0,-552 # 7af8 <malloc+0x1062>
    2d28:	00004097          	auipc	ra,0x4
    2d2c:	cb2080e7          	jalr	-846(ra) # 69da <printf>
    exit(1);
    2d30:	4505                	li	a0,1
    2d32:	00004097          	auipc	ra,0x4
    2d36:	92a080e7          	jalr	-1750(ra) # 665c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2d3a:	86aa                	mv	a3,a0
    2d3c:	8626                	mv	a2,s1
    2d3e:	85ce                	mv	a1,s3
    2d40:	00005517          	auipc	a0,0x5
    2d44:	df050513          	addi	a0,a0,-528 # 7b30 <malloc+0x109a>
    2d48:	00004097          	auipc	ra,0x4
    2d4c:	c92080e7          	jalr	-878(ra) # 69da <printf>
    exit(1);
    2d50:	4505                	li	a0,1
    2d52:	00004097          	auipc	ra,0x4
    2d56:	90a080e7          	jalr	-1782(ra) # 665c <exit>

0000000000002d5a <sbrkarg>:
{
    2d5a:	7179                	addi	sp,sp,-48
    2d5c:	f406                	sd	ra,40(sp)
    2d5e:	f022                	sd	s0,32(sp)
    2d60:	ec26                	sd	s1,24(sp)
    2d62:	e84a                	sd	s2,16(sp)
    2d64:	e44e                	sd	s3,8(sp)
    2d66:	1800                	addi	s0,sp,48
    2d68:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2d6a:	6505                	lui	a0,0x1
    2d6c:	00004097          	auipc	ra,0x4
    2d70:	978080e7          	jalr	-1672(ra) # 66e4 <sbrk>
    2d74:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2d76:	20100593          	li	a1,513
    2d7a:	00005517          	auipc	a0,0x5
    2d7e:	dde50513          	addi	a0,a0,-546 # 7b58 <malloc+0x10c2>
    2d82:	00004097          	auipc	ra,0x4
    2d86:	91a080e7          	jalr	-1766(ra) # 669c <open>
    2d8a:	84aa                	mv	s1,a0
  unlink("sbrk");
    2d8c:	00005517          	auipc	a0,0x5
    2d90:	dcc50513          	addi	a0,a0,-564 # 7b58 <malloc+0x10c2>
    2d94:	00004097          	auipc	ra,0x4
    2d98:	918080e7          	jalr	-1768(ra) # 66ac <unlink>
  if(fd < 0)  {
    2d9c:	0404c163          	bltz	s1,2dde <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2da0:	6605                	lui	a2,0x1
    2da2:	85ca                	mv	a1,s2
    2da4:	8526                	mv	a0,s1
    2da6:	00004097          	auipc	ra,0x4
    2daa:	8d6080e7          	jalr	-1834(ra) # 667c <write>
    2dae:	04054663          	bltz	a0,2dfa <sbrkarg+0xa0>
  close(fd);
    2db2:	8526                	mv	a0,s1
    2db4:	00004097          	auipc	ra,0x4
    2db8:	8d0080e7          	jalr	-1840(ra) # 6684 <close>
  a = sbrk(PGSIZE);
    2dbc:	6505                	lui	a0,0x1
    2dbe:	00004097          	auipc	ra,0x4
    2dc2:	926080e7          	jalr	-1754(ra) # 66e4 <sbrk>
  if(pipe((int *) a) != 0){
    2dc6:	00004097          	auipc	ra,0x4
    2dca:	8a6080e7          	jalr	-1882(ra) # 666c <pipe>
    2dce:	e521                	bnez	a0,2e16 <sbrkarg+0xbc>
}
    2dd0:	70a2                	ld	ra,40(sp)
    2dd2:	7402                	ld	s0,32(sp)
    2dd4:	64e2                	ld	s1,24(sp)
    2dd6:	6942                	ld	s2,16(sp)
    2dd8:	69a2                	ld	s3,8(sp)
    2dda:	6145                	addi	sp,sp,48
    2ddc:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2dde:	85ce                	mv	a1,s3
    2de0:	00005517          	auipc	a0,0x5
    2de4:	d8050513          	addi	a0,a0,-640 # 7b60 <malloc+0x10ca>
    2de8:	00004097          	auipc	ra,0x4
    2dec:	bf2080e7          	jalr	-1038(ra) # 69da <printf>
    exit(1);
    2df0:	4505                	li	a0,1
    2df2:	00004097          	auipc	ra,0x4
    2df6:	86a080e7          	jalr	-1942(ra) # 665c <exit>
    printf("%s: write sbrk failed\n", s);
    2dfa:	85ce                	mv	a1,s3
    2dfc:	00005517          	auipc	a0,0x5
    2e00:	d7c50513          	addi	a0,a0,-644 # 7b78 <malloc+0x10e2>
    2e04:	00004097          	auipc	ra,0x4
    2e08:	bd6080e7          	jalr	-1066(ra) # 69da <printf>
    exit(1);
    2e0c:	4505                	li	a0,1
    2e0e:	00004097          	auipc	ra,0x4
    2e12:	84e080e7          	jalr	-1970(ra) # 665c <exit>
    printf("%s: pipe() failed\n", s);
    2e16:	85ce                	mv	a1,s3
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	74050513          	addi	a0,a0,1856 # 7558 <malloc+0xac2>
    2e20:	00004097          	auipc	ra,0x4
    2e24:	bba080e7          	jalr	-1094(ra) # 69da <printf>
    exit(1);
    2e28:	4505                	li	a0,1
    2e2a:	00004097          	auipc	ra,0x4
    2e2e:	832080e7          	jalr	-1998(ra) # 665c <exit>

0000000000002e32 <argptest>:
{
    2e32:	1101                	addi	sp,sp,-32
    2e34:	ec06                	sd	ra,24(sp)
    2e36:	e822                	sd	s0,16(sp)
    2e38:	e426                	sd	s1,8(sp)
    2e3a:	e04a                	sd	s2,0(sp)
    2e3c:	1000                	addi	s0,sp,32
    2e3e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2e40:	4581                	li	a1,0
    2e42:	00005517          	auipc	a0,0x5
    2e46:	d4e50513          	addi	a0,a0,-690 # 7b90 <malloc+0x10fa>
    2e4a:	00004097          	auipc	ra,0x4
    2e4e:	852080e7          	jalr	-1966(ra) # 669c <open>
  if (fd < 0) {
    2e52:	02054b63          	bltz	a0,2e88 <argptest+0x56>
    2e56:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2e58:	4501                	li	a0,0
    2e5a:	00004097          	auipc	ra,0x4
    2e5e:	88a080e7          	jalr	-1910(ra) # 66e4 <sbrk>
    2e62:	567d                	li	a2,-1
    2e64:	00c505b3          	add	a1,a0,a2
    2e68:	8526                	mv	a0,s1
    2e6a:	00004097          	auipc	ra,0x4
    2e6e:	80a080e7          	jalr	-2038(ra) # 6674 <read>
  close(fd);
    2e72:	8526                	mv	a0,s1
    2e74:	00004097          	auipc	ra,0x4
    2e78:	810080e7          	jalr	-2032(ra) # 6684 <close>
}
    2e7c:	60e2                	ld	ra,24(sp)
    2e7e:	6442                	ld	s0,16(sp)
    2e80:	64a2                	ld	s1,8(sp)
    2e82:	6902                	ld	s2,0(sp)
    2e84:	6105                	addi	sp,sp,32
    2e86:	8082                	ret
    printf("%s: open failed\n", s);
    2e88:	85ca                	mv	a1,s2
    2e8a:	00004517          	auipc	a0,0x4
    2e8e:	5de50513          	addi	a0,a0,1502 # 7468 <malloc+0x9d2>
    2e92:	00004097          	auipc	ra,0x4
    2e96:	b48080e7          	jalr	-1208(ra) # 69da <printf>
    exit(1);
    2e9a:	4505                	li	a0,1
    2e9c:	00003097          	auipc	ra,0x3
    2ea0:	7c0080e7          	jalr	1984(ra) # 665c <exit>

0000000000002ea4 <sbrkbugs>:
{
    2ea4:	1141                	addi	sp,sp,-16
    2ea6:	e406                	sd	ra,8(sp)
    2ea8:	e022                	sd	s0,0(sp)
    2eaa:	0800                	addi	s0,sp,16
  int pid = fork();
    2eac:	00003097          	auipc	ra,0x3
    2eb0:	7a8080e7          	jalr	1960(ra) # 6654 <fork>
  if(pid < 0){
    2eb4:	02054263          	bltz	a0,2ed8 <sbrkbugs+0x34>
  if(pid == 0){
    2eb8:	ed0d                	bnez	a0,2ef2 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2eba:	00004097          	auipc	ra,0x4
    2ebe:	82a080e7          	jalr	-2006(ra) # 66e4 <sbrk>
    sbrk(-sz);
    2ec2:	40a0053b          	negw	a0,a0
    2ec6:	00004097          	auipc	ra,0x4
    2eca:	81e080e7          	jalr	-2018(ra) # 66e4 <sbrk>
    exit(0);
    2ece:	4501                	li	a0,0
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	78c080e7          	jalr	1932(ra) # 665c <exit>
    printf("fork failed\n");
    2ed8:	00005517          	auipc	a0,0x5
    2edc:	98050513          	addi	a0,a0,-1664 # 7858 <malloc+0xdc2>
    2ee0:	00004097          	auipc	ra,0x4
    2ee4:	afa080e7          	jalr	-1286(ra) # 69da <printf>
    exit(1);
    2ee8:	4505                	li	a0,1
    2eea:	00003097          	auipc	ra,0x3
    2eee:	772080e7          	jalr	1906(ra) # 665c <exit>
  wait(0);
    2ef2:	4501                	li	a0,0
    2ef4:	00003097          	auipc	ra,0x3
    2ef8:	770080e7          	jalr	1904(ra) # 6664 <wait>
  pid = fork();
    2efc:	00003097          	auipc	ra,0x3
    2f00:	758080e7          	jalr	1880(ra) # 6654 <fork>
  if(pid < 0){
    2f04:	02054563          	bltz	a0,2f2e <sbrkbugs+0x8a>
  if(pid == 0){
    2f08:	e121                	bnez	a0,2f48 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2f0a:	00003097          	auipc	ra,0x3
    2f0e:	7da080e7          	jalr	2010(ra) # 66e4 <sbrk>
    sbrk(-(sz - 3500));
    2f12:	6785                	lui	a5,0x1
    2f14:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0xe>
    2f18:	40a7853b          	subw	a0,a5,a0
    2f1c:	00003097          	auipc	ra,0x3
    2f20:	7c8080e7          	jalr	1992(ra) # 66e4 <sbrk>
    exit(0);
    2f24:	4501                	li	a0,0
    2f26:	00003097          	auipc	ra,0x3
    2f2a:	736080e7          	jalr	1846(ra) # 665c <exit>
    printf("fork failed\n");
    2f2e:	00005517          	auipc	a0,0x5
    2f32:	92a50513          	addi	a0,a0,-1750 # 7858 <malloc+0xdc2>
    2f36:	00004097          	auipc	ra,0x4
    2f3a:	aa4080e7          	jalr	-1372(ra) # 69da <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	00003097          	auipc	ra,0x3
    2f44:	71c080e7          	jalr	1820(ra) # 665c <exit>
  wait(0);
    2f48:	4501                	li	a0,0
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	71a080e7          	jalr	1818(ra) # 6664 <wait>
  pid = fork();
    2f52:	00003097          	auipc	ra,0x3
    2f56:	702080e7          	jalr	1794(ra) # 6654 <fork>
  if(pid < 0){
    2f5a:	02054a63          	bltz	a0,2f8e <sbrkbugs+0xea>
  if(pid == 0){
    2f5e:	e529                	bnez	a0,2fa8 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2f60:	00003097          	auipc	ra,0x3
    2f64:	784080e7          	jalr	1924(ra) # 66e4 <sbrk>
    2f68:	67ad                	lui	a5,0xb
    2f6a:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x290>
    2f6e:	40a7853b          	subw	a0,a5,a0
    2f72:	00003097          	auipc	ra,0x3
    2f76:	772080e7          	jalr	1906(ra) # 66e4 <sbrk>
    sbrk(-10);
    2f7a:	5559                	li	a0,-10
    2f7c:	00003097          	auipc	ra,0x3
    2f80:	768080e7          	jalr	1896(ra) # 66e4 <sbrk>
    exit(0);
    2f84:	4501                	li	a0,0
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	6d6080e7          	jalr	1750(ra) # 665c <exit>
    printf("fork failed\n");
    2f8e:	00005517          	auipc	a0,0x5
    2f92:	8ca50513          	addi	a0,a0,-1846 # 7858 <malloc+0xdc2>
    2f96:	00004097          	auipc	ra,0x4
    2f9a:	a44080e7          	jalr	-1468(ra) # 69da <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	6bc080e7          	jalr	1724(ra) # 665c <exit>
  wait(0);
    2fa8:	4501                	li	a0,0
    2faa:	00003097          	auipc	ra,0x3
    2fae:	6ba080e7          	jalr	1722(ra) # 6664 <wait>
  exit(0);
    2fb2:	4501                	li	a0,0
    2fb4:	00003097          	auipc	ra,0x3
    2fb8:	6a8080e7          	jalr	1704(ra) # 665c <exit>

0000000000002fbc <sbrklast>:
{
    2fbc:	7179                	addi	sp,sp,-48
    2fbe:	f406                	sd	ra,40(sp)
    2fc0:	f022                	sd	s0,32(sp)
    2fc2:	ec26                	sd	s1,24(sp)
    2fc4:	e84a                	sd	s2,16(sp)
    2fc6:	e44e                	sd	s3,8(sp)
    2fc8:	e052                	sd	s4,0(sp)
    2fca:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2fcc:	4501                	li	a0,0
    2fce:	00003097          	auipc	ra,0x3
    2fd2:	716080e7          	jalr	1814(ra) # 66e4 <sbrk>
  if((top % 4096) != 0)
    2fd6:	03451793          	slli	a5,a0,0x34
    2fda:	ebd9                	bnez	a5,3070 <sbrklast+0xb4>
  sbrk(4096);
    2fdc:	6505                	lui	a0,0x1
    2fde:	00003097          	auipc	ra,0x3
    2fe2:	706080e7          	jalr	1798(ra) # 66e4 <sbrk>
  sbrk(10);
    2fe6:	4529                	li	a0,10
    2fe8:	00003097          	auipc	ra,0x3
    2fec:	6fc080e7          	jalr	1788(ra) # 66e4 <sbrk>
  sbrk(-20);
    2ff0:	5531                	li	a0,-20
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	6f2080e7          	jalr	1778(ra) # 66e4 <sbrk>
  top = (uint64) sbrk(0);
    2ffa:	4501                	li	a0,0
    2ffc:	00003097          	auipc	ra,0x3
    3000:	6e8080e7          	jalr	1768(ra) # 66e4 <sbrk>
    3004:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    3006:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0x6c>
  p[0] = 'x';
    300a:	07800993          	li	s3,120
    300e:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    3012:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    3016:	20200593          	li	a1,514
    301a:	854a                	mv	a0,s2
    301c:	00003097          	auipc	ra,0x3
    3020:	680080e7          	jalr	1664(ra) # 669c <open>
    3024:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    3026:	4605                	li	a2,1
    3028:	85ca                	mv	a1,s2
    302a:	00003097          	auipc	ra,0x3
    302e:	652080e7          	jalr	1618(ra) # 667c <write>
  close(fd);
    3032:	8552                	mv	a0,s4
    3034:	00003097          	auipc	ra,0x3
    3038:	650080e7          	jalr	1616(ra) # 6684 <close>
  fd = open(p, O_RDWR);
    303c:	4589                	li	a1,2
    303e:	854a                	mv	a0,s2
    3040:	00003097          	auipc	ra,0x3
    3044:	65c080e7          	jalr	1628(ra) # 669c <open>
  p[0] = '\0';
    3048:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    304c:	4605                	li	a2,1
    304e:	85ca                	mv	a1,s2
    3050:	00003097          	auipc	ra,0x3
    3054:	624080e7          	jalr	1572(ra) # 6674 <read>
  if(p[0] != 'x')
    3058:	fc04c783          	lbu	a5,-64(s1)
    305c:	03379463          	bne	a5,s3,3084 <sbrklast+0xc8>
}
    3060:	70a2                	ld	ra,40(sp)
    3062:	7402                	ld	s0,32(sp)
    3064:	64e2                	ld	s1,24(sp)
    3066:	6942                	ld	s2,16(sp)
    3068:	69a2                	ld	s3,8(sp)
    306a:	6a02                	ld	s4,0(sp)
    306c:	6145                	addi	sp,sp,48
    306e:	8082                	ret
    sbrk(4096 - (top % 4096));
    3070:	0347d513          	srli	a0,a5,0x34
    3074:	6785                	lui	a5,0x1
    3076:	40a7853b          	subw	a0,a5,a0
    307a:	00003097          	auipc	ra,0x3
    307e:	66a080e7          	jalr	1642(ra) # 66e4 <sbrk>
    3082:	bfa9                	j	2fdc <sbrklast+0x20>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	00003097          	auipc	ra,0x3
    308a:	5d6080e7          	jalr	1494(ra) # 665c <exit>

000000000000308e <sbrk8000>:
{
    308e:	1141                	addi	sp,sp,-16
    3090:	e406                	sd	ra,8(sp)
    3092:	e022                	sd	s0,0(sp)
    3094:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    3096:	80000537          	lui	a0,0x80000
    309a:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffee87c>
    309c:	00003097          	auipc	ra,0x3
    30a0:	648080e7          	jalr	1608(ra) # 66e4 <sbrk>
  volatile char *top = sbrk(0);
    30a4:	4501                	li	a0,0
    30a6:	00003097          	auipc	ra,0x3
    30aa:	63e080e7          	jalr	1598(ra) # 66e4 <sbrk>
  *(top-1) = *(top-1) + 1;
    30ae:	fff54783          	lbu	a5,-1(a0)
    30b2:	0785                	addi	a5,a5,1 # 1001 <linktest+0xad>
    30b4:	0ff7f793          	zext.b	a5,a5
    30b8:	fef50fa3          	sb	a5,-1(a0)
}
    30bc:	60a2                	ld	ra,8(sp)
    30be:	6402                	ld	s0,0(sp)
    30c0:	0141                	addi	sp,sp,16
    30c2:	8082                	ret

00000000000030c4 <execout>:
{
    30c4:	711d                	addi	sp,sp,-96
    30c6:	ec86                	sd	ra,88(sp)
    30c8:	e8a2                	sd	s0,80(sp)
    30ca:	e4a6                	sd	s1,72(sp)
    30cc:	e0ca                	sd	s2,64(sp)
    30ce:	fc4e                	sd	s3,56(sp)
    30d0:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    30d2:	4901                	li	s2,0
    30d4:	49bd                	li	s3,15
    int pid = fork();
    30d6:	00003097          	auipc	ra,0x3
    30da:	57e080e7          	jalr	1406(ra) # 6654 <fork>
    30de:	84aa                	mv	s1,a0
    if(pid < 0){
    30e0:	02054263          	bltz	a0,3104 <execout+0x40>
    } else if(pid == 0){
    30e4:	cd1d                	beqz	a0,3122 <execout+0x5e>
      wait((int*)0);
    30e6:	4501                	li	a0,0
    30e8:	00003097          	auipc	ra,0x3
    30ec:	57c080e7          	jalr	1404(ra) # 6664 <wait>
  for(int avail = 0; avail < 15; avail++){
    30f0:	2905                	addiw	s2,s2,1
    30f2:	ff3912e3          	bne	s2,s3,30d6 <execout+0x12>
    30f6:	f852                	sd	s4,48(sp)
    30f8:	f456                	sd	s5,40(sp)
  exit(0);
    30fa:	4501                	li	a0,0
    30fc:	00003097          	auipc	ra,0x3
    3100:	560080e7          	jalr	1376(ra) # 665c <exit>
    3104:	f852                	sd	s4,48(sp)
    3106:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    3108:	00004517          	auipc	a0,0x4
    310c:	75050513          	addi	a0,a0,1872 # 7858 <malloc+0xdc2>
    3110:	00004097          	auipc	ra,0x4
    3114:	8ca080e7          	jalr	-1846(ra) # 69da <printf>
      exit(1);
    3118:	4505                	li	a0,1
    311a:	00003097          	auipc	ra,0x3
    311e:	542080e7          	jalr	1346(ra) # 665c <exit>
    3122:	f852                	sd	s4,48(sp)
    3124:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
    3126:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
    3128:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
    312a:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
    312c:	854e                	mv	a0,s3
    312e:	00003097          	auipc	ra,0x3
    3132:	5b6080e7          	jalr	1462(ra) # 66e4 <sbrk>
        if(a == 0xffffffffffffffffLL)
    3136:	01450663          	beq	a0,s4,3142 <execout+0x7e>
        *(char*)(a + 4096 - 1) = 1;
    313a:	954e                	add	a0,a0,s3
    313c:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    3140:	b7f5                	j	312c <execout+0x68>
        sbrk(-4096);
    3142:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    3144:	01205a63          	blez	s2,3158 <execout+0x94>
        sbrk(-4096);
    3148:	854e                	mv	a0,s3
    314a:	00003097          	auipc	ra,0x3
    314e:	59a080e7          	jalr	1434(ra) # 66e4 <sbrk>
      for(int i = 0; i < avail; i++)
    3152:	2485                	addiw	s1,s1,1
    3154:	ff249ae3          	bne	s1,s2,3148 <execout+0x84>
      close(1);
    3158:	4505                	li	a0,1
    315a:	00003097          	auipc	ra,0x3
    315e:	52a080e7          	jalr	1322(ra) # 6684 <close>
      char *args[] = { "echo", "x", 0 };
    3162:	00004797          	auipc	a5,0x4
    3166:	a6678793          	addi	a5,a5,-1434 # 6bc8 <malloc+0x132>
    316a:	faf43423          	sd	a5,-88(s0)
    316e:	00004797          	auipc	a5,0x4
    3172:	aca78793          	addi	a5,a5,-1334 # 6c38 <malloc+0x1a2>
    3176:	faf43823          	sd	a5,-80(s0)
    317a:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    317e:	fa840593          	addi	a1,s0,-88
    3182:	00004517          	auipc	a0,0x4
    3186:	a4650513          	addi	a0,a0,-1466 # 6bc8 <malloc+0x132>
    318a:	00003097          	auipc	ra,0x3
    318e:	50a080e7          	jalr	1290(ra) # 6694 <exec>
      exit(0);
    3192:	4501                	li	a0,0
    3194:	00003097          	auipc	ra,0x3
    3198:	4c8080e7          	jalr	1224(ra) # 665c <exit>

000000000000319c <fourteen>:
{
    319c:	1101                	addi	sp,sp,-32
    319e:	ec06                	sd	ra,24(sp)
    31a0:	e822                	sd	s0,16(sp)
    31a2:	e426                	sd	s1,8(sp)
    31a4:	1000                	addi	s0,sp,32
    31a6:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    31a8:	00005517          	auipc	a0,0x5
    31ac:	bc050513          	addi	a0,a0,-1088 # 7d68 <malloc+0x12d2>
    31b0:	00003097          	auipc	ra,0x3
    31b4:	514080e7          	jalr	1300(ra) # 66c4 <mkdir>
    31b8:	e165                	bnez	a0,3298 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    31ba:	00005517          	auipc	a0,0x5
    31be:	a0650513          	addi	a0,a0,-1530 # 7bc0 <malloc+0x112a>
    31c2:	00003097          	auipc	ra,0x3
    31c6:	502080e7          	jalr	1282(ra) # 66c4 <mkdir>
    31ca:	e56d                	bnez	a0,32b4 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    31cc:	20000593          	li	a1,512
    31d0:	00005517          	auipc	a0,0x5
    31d4:	a4850513          	addi	a0,a0,-1464 # 7c18 <malloc+0x1182>
    31d8:	00003097          	auipc	ra,0x3
    31dc:	4c4080e7          	jalr	1220(ra) # 669c <open>
  if(fd < 0){
    31e0:	0e054863          	bltz	a0,32d0 <fourteen+0x134>
  close(fd);
    31e4:	00003097          	auipc	ra,0x3
    31e8:	4a0080e7          	jalr	1184(ra) # 6684 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    31ec:	4581                	li	a1,0
    31ee:	00005517          	auipc	a0,0x5
    31f2:	aa250513          	addi	a0,a0,-1374 # 7c90 <malloc+0x11fa>
    31f6:	00003097          	auipc	ra,0x3
    31fa:	4a6080e7          	jalr	1190(ra) # 669c <open>
  if(fd < 0){
    31fe:	0e054763          	bltz	a0,32ec <fourteen+0x150>
  close(fd);
    3202:	00003097          	auipc	ra,0x3
    3206:	482080e7          	jalr	1154(ra) # 6684 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    320a:	00005517          	auipc	a0,0x5
    320e:	af650513          	addi	a0,a0,-1290 # 7d00 <malloc+0x126a>
    3212:	00003097          	auipc	ra,0x3
    3216:	4b2080e7          	jalr	1202(ra) # 66c4 <mkdir>
    321a:	c57d                	beqz	a0,3308 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    321c:	00005517          	auipc	a0,0x5
    3220:	b3c50513          	addi	a0,a0,-1220 # 7d58 <malloc+0x12c2>
    3224:	00003097          	auipc	ra,0x3
    3228:	4a0080e7          	jalr	1184(ra) # 66c4 <mkdir>
    322c:	cd65                	beqz	a0,3324 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    322e:	00005517          	auipc	a0,0x5
    3232:	b2a50513          	addi	a0,a0,-1238 # 7d58 <malloc+0x12c2>
    3236:	00003097          	auipc	ra,0x3
    323a:	476080e7          	jalr	1142(ra) # 66ac <unlink>
  unlink("12345678901234/12345678901234");
    323e:	00005517          	auipc	a0,0x5
    3242:	ac250513          	addi	a0,a0,-1342 # 7d00 <malloc+0x126a>
    3246:	00003097          	auipc	ra,0x3
    324a:	466080e7          	jalr	1126(ra) # 66ac <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    324e:	00005517          	auipc	a0,0x5
    3252:	a4250513          	addi	a0,a0,-1470 # 7c90 <malloc+0x11fa>
    3256:	00003097          	auipc	ra,0x3
    325a:	456080e7          	jalr	1110(ra) # 66ac <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    325e:	00005517          	auipc	a0,0x5
    3262:	9ba50513          	addi	a0,a0,-1606 # 7c18 <malloc+0x1182>
    3266:	00003097          	auipc	ra,0x3
    326a:	446080e7          	jalr	1094(ra) # 66ac <unlink>
  unlink("12345678901234/123456789012345");
    326e:	00005517          	auipc	a0,0x5
    3272:	95250513          	addi	a0,a0,-1710 # 7bc0 <malloc+0x112a>
    3276:	00003097          	auipc	ra,0x3
    327a:	436080e7          	jalr	1078(ra) # 66ac <unlink>
  unlink("12345678901234");
    327e:	00005517          	auipc	a0,0x5
    3282:	aea50513          	addi	a0,a0,-1302 # 7d68 <malloc+0x12d2>
    3286:	00003097          	auipc	ra,0x3
    328a:	426080e7          	jalr	1062(ra) # 66ac <unlink>
}
    328e:	60e2                	ld	ra,24(sp)
    3290:	6442                	ld	s0,16(sp)
    3292:	64a2                	ld	s1,8(sp)
    3294:	6105                	addi	sp,sp,32
    3296:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3298:	85a6                	mv	a1,s1
    329a:	00005517          	auipc	a0,0x5
    329e:	8fe50513          	addi	a0,a0,-1794 # 7b98 <malloc+0x1102>
    32a2:	00003097          	auipc	ra,0x3
    32a6:	738080e7          	jalr	1848(ra) # 69da <printf>
    exit(1);
    32aa:	4505                	li	a0,1
    32ac:	00003097          	auipc	ra,0x3
    32b0:	3b0080e7          	jalr	944(ra) # 665c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    32b4:	85a6                	mv	a1,s1
    32b6:	00005517          	auipc	a0,0x5
    32ba:	92a50513          	addi	a0,a0,-1750 # 7be0 <malloc+0x114a>
    32be:	00003097          	auipc	ra,0x3
    32c2:	71c080e7          	jalr	1820(ra) # 69da <printf>
    exit(1);
    32c6:	4505                	li	a0,1
    32c8:	00003097          	auipc	ra,0x3
    32cc:	394080e7          	jalr	916(ra) # 665c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    32d0:	85a6                	mv	a1,s1
    32d2:	00005517          	auipc	a0,0x5
    32d6:	97650513          	addi	a0,a0,-1674 # 7c48 <malloc+0x11b2>
    32da:	00003097          	auipc	ra,0x3
    32de:	700080e7          	jalr	1792(ra) # 69da <printf>
    exit(1);
    32e2:	4505                	li	a0,1
    32e4:	00003097          	auipc	ra,0x3
    32e8:	378080e7          	jalr	888(ra) # 665c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    32ec:	85a6                	mv	a1,s1
    32ee:	00005517          	auipc	a0,0x5
    32f2:	9d250513          	addi	a0,a0,-1582 # 7cc0 <malloc+0x122a>
    32f6:	00003097          	auipc	ra,0x3
    32fa:	6e4080e7          	jalr	1764(ra) # 69da <printf>
    exit(1);
    32fe:	4505                	li	a0,1
    3300:	00003097          	auipc	ra,0x3
    3304:	35c080e7          	jalr	860(ra) # 665c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3308:	85a6                	mv	a1,s1
    330a:	00005517          	auipc	a0,0x5
    330e:	a1650513          	addi	a0,a0,-1514 # 7d20 <malloc+0x128a>
    3312:	00003097          	auipc	ra,0x3
    3316:	6c8080e7          	jalr	1736(ra) # 69da <printf>
    exit(1);
    331a:	4505                	li	a0,1
    331c:	00003097          	auipc	ra,0x3
    3320:	340080e7          	jalr	832(ra) # 665c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3324:	85a6                	mv	a1,s1
    3326:	00005517          	auipc	a0,0x5
    332a:	a5250513          	addi	a0,a0,-1454 # 7d78 <malloc+0x12e2>
    332e:	00003097          	auipc	ra,0x3
    3332:	6ac080e7          	jalr	1708(ra) # 69da <printf>
    exit(1);
    3336:	4505                	li	a0,1
    3338:	00003097          	auipc	ra,0x3
    333c:	324080e7          	jalr	804(ra) # 665c <exit>

0000000000003340 <diskfull>:
{
    3340:	b6010113          	addi	sp,sp,-1184
    3344:	48113c23          	sd	ra,1176(sp)
    3348:	48813823          	sd	s0,1168(sp)
    334c:	48913423          	sd	s1,1160(sp)
    3350:	49213023          	sd	s2,1152(sp)
    3354:	47313c23          	sd	s3,1144(sp)
    3358:	47413823          	sd	s4,1136(sp)
    335c:	47513423          	sd	s5,1128(sp)
    3360:	47613023          	sd	s6,1120(sp)
    3364:	45713c23          	sd	s7,1112(sp)
    3368:	45813823          	sd	s8,1104(sp)
    336c:	45913423          	sd	s9,1096(sp)
    3370:	45a13023          	sd	s10,1088(sp)
    3374:	43b13c23          	sd	s11,1080(sp)
    3378:	4a010413          	addi	s0,sp,1184
    337c:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    3380:	00005517          	auipc	a0,0x5
    3384:	a3050513          	addi	a0,a0,-1488 # 7db0 <malloc+0x131a>
    3388:	00003097          	auipc	ra,0x3
    338c:	324080e7          	jalr	804(ra) # 66ac <unlink>
  for(fi = 0; done == 0; fi++){
    3390:	4a81                	li	s5,0
    name[0] = 'b';
    3392:	06200d13          	li	s10,98
    name[1] = 'i';
    3396:	06900c93          	li	s9,105
    name[2] = 'g';
    339a:	06700c13          	li	s8,103
    unlink(name);
    339e:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33a2:	60200b93          	li	s7,1538
    33a6:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    33aa:	b9040a13          	addi	s4,s0,-1136
    33ae:	aa49                	j	3540 <diskfull+0x200>
      printf("%s: could not create file %s\n", s, name);
    33b0:	b7040613          	addi	a2,s0,-1168
    33b4:	b6843583          	ld	a1,-1176(s0)
    33b8:	00005517          	auipc	a0,0x5
    33bc:	a0850513          	addi	a0,a0,-1528 # 7dc0 <malloc+0x132a>
    33c0:	00003097          	auipc	ra,0x3
    33c4:	61a080e7          	jalr	1562(ra) # 69da <printf>
      break;
    33c8:	a821                	j	33e0 <diskfull+0xa0>
        close(fd);
    33ca:	854e                	mv	a0,s3
    33cc:	00003097          	auipc	ra,0x3
    33d0:	2b8080e7          	jalr	696(ra) # 6684 <close>
    close(fd);
    33d4:	854e                	mv	a0,s3
    33d6:	00003097          	auipc	ra,0x3
    33da:	2ae080e7          	jalr	686(ra) # 6684 <close>
  for(fi = 0; done == 0; fi++){
    33de:	2a85                	addiw	s5,s5,1 # 3001 <sbrklast+0x45>
  for(int i = 0; i < nzz; i++){
    33e0:	4481                	li	s1,0
    name[0] = 'z';
    33e2:	07a00993          	li	s3,122
    unlink(name);
    33e6:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33ea:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    33ee:	08000b13          	li	s6,128
    name[0] = 'z';
    33f2:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    33f6:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    33fa:	41f4d71b          	sraiw	a4,s1,0x1f
    33fe:	01b7571b          	srliw	a4,a4,0x1b
    3402:	009707bb          	addw	a5,a4,s1
    3406:	4057d69b          	sraiw	a3,a5,0x5
    340a:	0306869b          	addiw	a3,a3,48
    340e:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    3412:	8bfd                	andi	a5,a5,31
    3414:	9f99                	subw	a5,a5,a4
    3416:	0307879b          	addiw	a5,a5,48
    341a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    341e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3422:	854a                	mv	a0,s2
    3424:	00003097          	auipc	ra,0x3
    3428:	288080e7          	jalr	648(ra) # 66ac <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    342c:	85d2                	mv	a1,s4
    342e:	854a                	mv	a0,s2
    3430:	00003097          	auipc	ra,0x3
    3434:	26c080e7          	jalr	620(ra) # 669c <open>
    if(fd < 0)
    3438:	00054963          	bltz	a0,344a <diskfull+0x10a>
    close(fd);
    343c:	00003097          	auipc	ra,0x3
    3440:	248080e7          	jalr	584(ra) # 6684 <close>
  for(int i = 0; i < nzz; i++){
    3444:	2485                	addiw	s1,s1,1
    3446:	fb6496e3          	bne	s1,s6,33f2 <diskfull+0xb2>
  if(mkdir("diskfulldir") == 0)
    344a:	00005517          	auipc	a0,0x5
    344e:	96650513          	addi	a0,a0,-1690 # 7db0 <malloc+0x131a>
    3452:	00003097          	auipc	ra,0x3
    3456:	272080e7          	jalr	626(ra) # 66c4 <mkdir>
    345a:	12050c63          	beqz	a0,3592 <diskfull+0x252>
  unlink("diskfulldir");
    345e:	00005517          	auipc	a0,0x5
    3462:	95250513          	addi	a0,a0,-1710 # 7db0 <malloc+0x131a>
    3466:	00003097          	auipc	ra,0x3
    346a:	246080e7          	jalr	582(ra) # 66ac <unlink>
  for(int i = 0; i < nzz; i++){
    346e:	4481                	li	s1,0
    name[0] = 'z';
    3470:	07a00913          	li	s2,122
    unlink(name);
    3474:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    3478:	08000993          	li	s3,128
    name[0] = 'z';
    347c:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    3480:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    3484:	41f4d71b          	sraiw	a4,s1,0x1f
    3488:	01b7571b          	srliw	a4,a4,0x1b
    348c:	009707bb          	addw	a5,a4,s1
    3490:	4057d69b          	sraiw	a3,a5,0x5
    3494:	0306869b          	addiw	a3,a3,48
    3498:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    349c:	8bfd                	andi	a5,a5,31
    349e:	9f99                	subw	a5,a5,a4
    34a0:	0307879b          	addiw	a5,a5,48
    34a4:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    34a8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    34ac:	8552                	mv	a0,s4
    34ae:	00003097          	auipc	ra,0x3
    34b2:	1fe080e7          	jalr	510(ra) # 66ac <unlink>
  for(int i = 0; i < nzz; i++){
    34b6:	2485                	addiw	s1,s1,1
    34b8:	fd3492e3          	bne	s1,s3,347c <diskfull+0x13c>
  for(int i = 0; i < fi; i++){
    34bc:	03505f63          	blez	s5,34fa <diskfull+0x1ba>
    34c0:	4481                	li	s1,0
    name[0] = 'b';
    34c2:	06200b13          	li	s6,98
    name[1] = 'i';
    34c6:	06900a13          	li	s4,105
    name[2] = 'g';
    34ca:	06700993          	li	s3,103
    unlink(name);
    34ce:	b9040913          	addi	s2,s0,-1136
    name[0] = 'b';
    34d2:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    34d6:	b94408a3          	sb	s4,-1135(s0)
    name[2] = 'g';
    34da:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + i;
    34de:	0304879b          	addiw	a5,s1,48
    34e2:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    34e6:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    34ea:	854a                	mv	a0,s2
    34ec:	00003097          	auipc	ra,0x3
    34f0:	1c0080e7          	jalr	448(ra) # 66ac <unlink>
  for(int i = 0; i < fi; i++){
    34f4:	2485                	addiw	s1,s1,1
    34f6:	fd549ee3          	bne	s1,s5,34d2 <diskfull+0x192>
}
    34fa:	49813083          	ld	ra,1176(sp)
    34fe:	49013403          	ld	s0,1168(sp)
    3502:	48813483          	ld	s1,1160(sp)
    3506:	48013903          	ld	s2,1152(sp)
    350a:	47813983          	ld	s3,1144(sp)
    350e:	47013a03          	ld	s4,1136(sp)
    3512:	46813a83          	ld	s5,1128(sp)
    3516:	46013b03          	ld	s6,1120(sp)
    351a:	45813b83          	ld	s7,1112(sp)
    351e:	45013c03          	ld	s8,1104(sp)
    3522:	44813c83          	ld	s9,1096(sp)
    3526:	44013d03          	ld	s10,1088(sp)
    352a:	43813d83          	ld	s11,1080(sp)
    352e:	4a010113          	addi	sp,sp,1184
    3532:	8082                	ret
    close(fd);
    3534:	854e                	mv	a0,s3
    3536:	00003097          	auipc	ra,0x3
    353a:	14e080e7          	jalr	334(ra) # 6684 <close>
  for(fi = 0; done == 0; fi++){
    353e:	2a85                	addiw	s5,s5,1
    name[0] = 'b';
    3540:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    3544:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    3548:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    354c:	030a879b          	addiw	a5,s5,48
    3550:	b6f409a3          	sb	a5,-1165(s0)
    name[4] = '\0';
    3554:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    3558:	855a                	mv	a0,s6
    355a:	00003097          	auipc	ra,0x3
    355e:	152080e7          	jalr	338(ra) # 66ac <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3562:	85de                	mv	a1,s7
    3564:	855a                	mv	a0,s6
    3566:	00003097          	auipc	ra,0x3
    356a:	136080e7          	jalr	310(ra) # 669c <open>
    356e:	89aa                	mv	s3,a0
    if(fd < 0){
    3570:	e40540e3          	bltz	a0,33b0 <diskfull+0x70>
    3574:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    3576:	40000913          	li	s2,1024
    357a:	864a                	mv	a2,s2
    357c:	85d2                	mv	a1,s4
    357e:	854e                	mv	a0,s3
    3580:	00003097          	auipc	ra,0x3
    3584:	0fc080e7          	jalr	252(ra) # 667c <write>
    3588:	e52511e3          	bne	a0,s2,33ca <diskfull+0x8a>
    for(int i = 0; i < MAXFILE; i++){
    358c:	34fd                	addiw	s1,s1,-1
    358e:	f4f5                	bnez	s1,357a <diskfull+0x23a>
    3590:	b755                	j	3534 <diskfull+0x1f4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3592:	00005517          	auipc	a0,0x5
    3596:	84e50513          	addi	a0,a0,-1970 # 7de0 <malloc+0x134a>
    359a:	00003097          	auipc	ra,0x3
    359e:	440080e7          	jalr	1088(ra) # 69da <printf>
    35a2:	bd75                	j	345e <diskfull+0x11e>

00000000000035a4 <iputtest>:
{
    35a4:	1101                	addi	sp,sp,-32
    35a6:	ec06                	sd	ra,24(sp)
    35a8:	e822                	sd	s0,16(sp)
    35aa:	e426                	sd	s1,8(sp)
    35ac:	1000                	addi	s0,sp,32
    35ae:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    35b0:	00005517          	auipc	a0,0x5
    35b4:	86050513          	addi	a0,a0,-1952 # 7e10 <malloc+0x137a>
    35b8:	00003097          	auipc	ra,0x3
    35bc:	10c080e7          	jalr	268(ra) # 66c4 <mkdir>
    35c0:	04054563          	bltz	a0,360a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    35c4:	00005517          	auipc	a0,0x5
    35c8:	84c50513          	addi	a0,a0,-1972 # 7e10 <malloc+0x137a>
    35cc:	00003097          	auipc	ra,0x3
    35d0:	100080e7          	jalr	256(ra) # 66cc <chdir>
    35d4:	04054963          	bltz	a0,3626 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    35d8:	00005517          	auipc	a0,0x5
    35dc:	87850513          	addi	a0,a0,-1928 # 7e50 <malloc+0x13ba>
    35e0:	00003097          	auipc	ra,0x3
    35e4:	0cc080e7          	jalr	204(ra) # 66ac <unlink>
    35e8:	04054d63          	bltz	a0,3642 <iputtest+0x9e>
  if(chdir("/") < 0){
    35ec:	00005517          	auipc	a0,0x5
    35f0:	89450513          	addi	a0,a0,-1900 # 7e80 <malloc+0x13ea>
    35f4:	00003097          	auipc	ra,0x3
    35f8:	0d8080e7          	jalr	216(ra) # 66cc <chdir>
    35fc:	06054163          	bltz	a0,365e <iputtest+0xba>
}
    3600:	60e2                	ld	ra,24(sp)
    3602:	6442                	ld	s0,16(sp)
    3604:	64a2                	ld	s1,8(sp)
    3606:	6105                	addi	sp,sp,32
    3608:	8082                	ret
    printf("%s: mkdir failed\n", s);
    360a:	85a6                	mv	a1,s1
    360c:	00005517          	auipc	a0,0x5
    3610:	80c50513          	addi	a0,a0,-2036 # 7e18 <malloc+0x1382>
    3614:	00003097          	auipc	ra,0x3
    3618:	3c6080e7          	jalr	966(ra) # 69da <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00003097          	auipc	ra,0x3
    3622:	03e080e7          	jalr	62(ra) # 665c <exit>
    printf("%s: chdir iputdir failed\n", s);
    3626:	85a6                	mv	a1,s1
    3628:	00005517          	auipc	a0,0x5
    362c:	80850513          	addi	a0,a0,-2040 # 7e30 <malloc+0x139a>
    3630:	00003097          	auipc	ra,0x3
    3634:	3aa080e7          	jalr	938(ra) # 69da <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00003097          	auipc	ra,0x3
    363e:	022080e7          	jalr	34(ra) # 665c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3642:	85a6                	mv	a1,s1
    3644:	00005517          	auipc	a0,0x5
    3648:	81c50513          	addi	a0,a0,-2020 # 7e60 <malloc+0x13ca>
    364c:	00003097          	auipc	ra,0x3
    3650:	38e080e7          	jalr	910(ra) # 69da <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00003097          	auipc	ra,0x3
    365a:	006080e7          	jalr	6(ra) # 665c <exit>
    printf("%s: chdir / failed\n", s);
    365e:	85a6                	mv	a1,s1
    3660:	00005517          	auipc	a0,0x5
    3664:	82850513          	addi	a0,a0,-2008 # 7e88 <malloc+0x13f2>
    3668:	00003097          	auipc	ra,0x3
    366c:	372080e7          	jalr	882(ra) # 69da <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00003097          	auipc	ra,0x3
    3676:	fea080e7          	jalr	-22(ra) # 665c <exit>

000000000000367a <exitiputtest>:
{
    367a:	7179                	addi	sp,sp,-48
    367c:	f406                	sd	ra,40(sp)
    367e:	f022                	sd	s0,32(sp)
    3680:	ec26                	sd	s1,24(sp)
    3682:	1800                	addi	s0,sp,48
    3684:	84aa                	mv	s1,a0
  pid = fork();
    3686:	00003097          	auipc	ra,0x3
    368a:	fce080e7          	jalr	-50(ra) # 6654 <fork>
  if(pid < 0){
    368e:	04054663          	bltz	a0,36da <exitiputtest+0x60>
  if(pid == 0){
    3692:	ed45                	bnez	a0,374a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	77c50513          	addi	a0,a0,1916 # 7e10 <malloc+0x137a>
    369c:	00003097          	auipc	ra,0x3
    36a0:	028080e7          	jalr	40(ra) # 66c4 <mkdir>
    36a4:	04054963          	bltz	a0,36f6 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	76850513          	addi	a0,a0,1896 # 7e10 <malloc+0x137a>
    36b0:	00003097          	auipc	ra,0x3
    36b4:	01c080e7          	jalr	28(ra) # 66cc <chdir>
    36b8:	04054d63          	bltz	a0,3712 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    36bc:	00004517          	auipc	a0,0x4
    36c0:	79450513          	addi	a0,a0,1940 # 7e50 <malloc+0x13ba>
    36c4:	00003097          	auipc	ra,0x3
    36c8:	fe8080e7          	jalr	-24(ra) # 66ac <unlink>
    36cc:	06054163          	bltz	a0,372e <exitiputtest+0xb4>
    exit(0);
    36d0:	4501                	li	a0,0
    36d2:	00003097          	auipc	ra,0x3
    36d6:	f8a080e7          	jalr	-118(ra) # 665c <exit>
    printf("%s: fork failed\n", s);
    36da:	85a6                	mv	a1,s1
    36dc:	00004517          	auipc	a0,0x4
    36e0:	d7450513          	addi	a0,a0,-652 # 7450 <malloc+0x9ba>
    36e4:	00003097          	auipc	ra,0x3
    36e8:	2f6080e7          	jalr	758(ra) # 69da <printf>
    exit(1);
    36ec:	4505                	li	a0,1
    36ee:	00003097          	auipc	ra,0x3
    36f2:	f6e080e7          	jalr	-146(ra) # 665c <exit>
      printf("%s: mkdir failed\n", s);
    36f6:	85a6                	mv	a1,s1
    36f8:	00004517          	auipc	a0,0x4
    36fc:	72050513          	addi	a0,a0,1824 # 7e18 <malloc+0x1382>
    3700:	00003097          	auipc	ra,0x3
    3704:	2da080e7          	jalr	730(ra) # 69da <printf>
      exit(1);
    3708:	4505                	li	a0,1
    370a:	00003097          	auipc	ra,0x3
    370e:	f52080e7          	jalr	-174(ra) # 665c <exit>
      printf("%s: child chdir failed\n", s);
    3712:	85a6                	mv	a1,s1
    3714:	00004517          	auipc	a0,0x4
    3718:	78c50513          	addi	a0,a0,1932 # 7ea0 <malloc+0x140a>
    371c:	00003097          	auipc	ra,0x3
    3720:	2be080e7          	jalr	702(ra) # 69da <printf>
      exit(1);
    3724:	4505                	li	a0,1
    3726:	00003097          	auipc	ra,0x3
    372a:	f36080e7          	jalr	-202(ra) # 665c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    372e:	85a6                	mv	a1,s1
    3730:	00004517          	auipc	a0,0x4
    3734:	73050513          	addi	a0,a0,1840 # 7e60 <malloc+0x13ca>
    3738:	00003097          	auipc	ra,0x3
    373c:	2a2080e7          	jalr	674(ra) # 69da <printf>
      exit(1);
    3740:	4505                	li	a0,1
    3742:	00003097          	auipc	ra,0x3
    3746:	f1a080e7          	jalr	-230(ra) # 665c <exit>
  wait(&xstatus);
    374a:	fdc40513          	addi	a0,s0,-36
    374e:	00003097          	auipc	ra,0x3
    3752:	f16080e7          	jalr	-234(ra) # 6664 <wait>
  exit(xstatus);
    3756:	fdc42503          	lw	a0,-36(s0)
    375a:	00003097          	auipc	ra,0x3
    375e:	f02080e7          	jalr	-254(ra) # 665c <exit>

0000000000003762 <dirtest>:
{
    3762:	1101                	addi	sp,sp,-32
    3764:	ec06                	sd	ra,24(sp)
    3766:	e822                	sd	s0,16(sp)
    3768:	e426                	sd	s1,8(sp)
    376a:	1000                	addi	s0,sp,32
    376c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    376e:	00004517          	auipc	a0,0x4
    3772:	74a50513          	addi	a0,a0,1866 # 7eb8 <malloc+0x1422>
    3776:	00003097          	auipc	ra,0x3
    377a:	f4e080e7          	jalr	-178(ra) # 66c4 <mkdir>
    377e:	04054563          	bltz	a0,37c8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3782:	00004517          	auipc	a0,0x4
    3786:	73650513          	addi	a0,a0,1846 # 7eb8 <malloc+0x1422>
    378a:	00003097          	auipc	ra,0x3
    378e:	f42080e7          	jalr	-190(ra) # 66cc <chdir>
    3792:	04054963          	bltz	a0,37e4 <dirtest+0x82>
  if(chdir("..") < 0){
    3796:	00004517          	auipc	a0,0x4
    379a:	74250513          	addi	a0,a0,1858 # 7ed8 <malloc+0x1442>
    379e:	00003097          	auipc	ra,0x3
    37a2:	f2e080e7          	jalr	-210(ra) # 66cc <chdir>
    37a6:	04054d63          	bltz	a0,3800 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    37aa:	00004517          	auipc	a0,0x4
    37ae:	70e50513          	addi	a0,a0,1806 # 7eb8 <malloc+0x1422>
    37b2:	00003097          	auipc	ra,0x3
    37b6:	efa080e7          	jalr	-262(ra) # 66ac <unlink>
    37ba:	06054163          	bltz	a0,381c <dirtest+0xba>
}
    37be:	60e2                	ld	ra,24(sp)
    37c0:	6442                	ld	s0,16(sp)
    37c2:	64a2                	ld	s1,8(sp)
    37c4:	6105                	addi	sp,sp,32
    37c6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    37c8:	85a6                	mv	a1,s1
    37ca:	00004517          	auipc	a0,0x4
    37ce:	64e50513          	addi	a0,a0,1614 # 7e18 <malloc+0x1382>
    37d2:	00003097          	auipc	ra,0x3
    37d6:	208080e7          	jalr	520(ra) # 69da <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	00003097          	auipc	ra,0x3
    37e0:	e80080e7          	jalr	-384(ra) # 665c <exit>
    printf("%s: chdir dir0 failed\n", s);
    37e4:	85a6                	mv	a1,s1
    37e6:	00004517          	auipc	a0,0x4
    37ea:	6da50513          	addi	a0,a0,1754 # 7ec0 <malloc+0x142a>
    37ee:	00003097          	auipc	ra,0x3
    37f2:	1ec080e7          	jalr	492(ra) # 69da <printf>
    exit(1);
    37f6:	4505                	li	a0,1
    37f8:	00003097          	auipc	ra,0x3
    37fc:	e64080e7          	jalr	-412(ra) # 665c <exit>
    printf("%s: chdir .. failed\n", s);
    3800:	85a6                	mv	a1,s1
    3802:	00004517          	auipc	a0,0x4
    3806:	6de50513          	addi	a0,a0,1758 # 7ee0 <malloc+0x144a>
    380a:	00003097          	auipc	ra,0x3
    380e:	1d0080e7          	jalr	464(ra) # 69da <printf>
    exit(1);
    3812:	4505                	li	a0,1
    3814:	00003097          	auipc	ra,0x3
    3818:	e48080e7          	jalr	-440(ra) # 665c <exit>
    printf("%s: unlink dir0 failed\n", s);
    381c:	85a6                	mv	a1,s1
    381e:	00004517          	auipc	a0,0x4
    3822:	6da50513          	addi	a0,a0,1754 # 7ef8 <malloc+0x1462>
    3826:	00003097          	auipc	ra,0x3
    382a:	1b4080e7          	jalr	436(ra) # 69da <printf>
    exit(1);
    382e:	4505                	li	a0,1
    3830:	00003097          	auipc	ra,0x3
    3834:	e2c080e7          	jalr	-468(ra) # 665c <exit>

0000000000003838 <subdir>:
{
    3838:	1101                	addi	sp,sp,-32
    383a:	ec06                	sd	ra,24(sp)
    383c:	e822                	sd	s0,16(sp)
    383e:	e426                	sd	s1,8(sp)
    3840:	e04a                	sd	s2,0(sp)
    3842:	1000                	addi	s0,sp,32
    3844:	892a                	mv	s2,a0
  unlink("ff");
    3846:	00004517          	auipc	a0,0x4
    384a:	7fa50513          	addi	a0,a0,2042 # 8040 <malloc+0x15aa>
    384e:	00003097          	auipc	ra,0x3
    3852:	e5e080e7          	jalr	-418(ra) # 66ac <unlink>
  if(mkdir("dd") != 0){
    3856:	00004517          	auipc	a0,0x4
    385a:	6ba50513          	addi	a0,a0,1722 # 7f10 <malloc+0x147a>
    385e:	00003097          	auipc	ra,0x3
    3862:	e66080e7          	jalr	-410(ra) # 66c4 <mkdir>
    3866:	38051663          	bnez	a0,3bf2 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    386a:	20200593          	li	a1,514
    386e:	00004517          	auipc	a0,0x4
    3872:	6c250513          	addi	a0,a0,1730 # 7f30 <malloc+0x149a>
    3876:	00003097          	auipc	ra,0x3
    387a:	e26080e7          	jalr	-474(ra) # 669c <open>
    387e:	84aa                	mv	s1,a0
  if(fd < 0){
    3880:	38054763          	bltz	a0,3c0e <subdir+0x3d6>
  write(fd, "ff", 2);
    3884:	4609                	li	a2,2
    3886:	00004597          	auipc	a1,0x4
    388a:	7ba58593          	addi	a1,a1,1978 # 8040 <malloc+0x15aa>
    388e:	00003097          	auipc	ra,0x3
    3892:	dee080e7          	jalr	-530(ra) # 667c <write>
  close(fd);
    3896:	8526                	mv	a0,s1
    3898:	00003097          	auipc	ra,0x3
    389c:	dec080e7          	jalr	-532(ra) # 6684 <close>
  if(unlink("dd") >= 0){
    38a0:	00004517          	auipc	a0,0x4
    38a4:	67050513          	addi	a0,a0,1648 # 7f10 <malloc+0x147a>
    38a8:	00003097          	auipc	ra,0x3
    38ac:	e04080e7          	jalr	-508(ra) # 66ac <unlink>
    38b0:	36055d63          	bgez	a0,3c2a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    38b4:	00004517          	auipc	a0,0x4
    38b8:	6d450513          	addi	a0,a0,1748 # 7f88 <malloc+0x14f2>
    38bc:	00003097          	auipc	ra,0x3
    38c0:	e08080e7          	jalr	-504(ra) # 66c4 <mkdir>
    38c4:	38051163          	bnez	a0,3c46 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    38c8:	20200593          	li	a1,514
    38cc:	00004517          	auipc	a0,0x4
    38d0:	6e450513          	addi	a0,a0,1764 # 7fb0 <malloc+0x151a>
    38d4:	00003097          	auipc	ra,0x3
    38d8:	dc8080e7          	jalr	-568(ra) # 669c <open>
    38dc:	84aa                	mv	s1,a0
  if(fd < 0){
    38de:	38054263          	bltz	a0,3c62 <subdir+0x42a>
  write(fd, "FF", 2);
    38e2:	4609                	li	a2,2
    38e4:	00004597          	auipc	a1,0x4
    38e8:	6fc58593          	addi	a1,a1,1788 # 7fe0 <malloc+0x154a>
    38ec:	00003097          	auipc	ra,0x3
    38f0:	d90080e7          	jalr	-624(ra) # 667c <write>
  close(fd);
    38f4:	8526                	mv	a0,s1
    38f6:	00003097          	auipc	ra,0x3
    38fa:	d8e080e7          	jalr	-626(ra) # 6684 <close>
  fd = open("dd/dd/../ff", 0);
    38fe:	4581                	li	a1,0
    3900:	00004517          	auipc	a0,0x4
    3904:	6e850513          	addi	a0,a0,1768 # 7fe8 <malloc+0x1552>
    3908:	00003097          	auipc	ra,0x3
    390c:	d94080e7          	jalr	-620(ra) # 669c <open>
    3910:	84aa                	mv	s1,a0
  if(fd < 0){
    3912:	36054663          	bltz	a0,3c7e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3916:	660d                	lui	a2,0x3
    3918:	0000a597          	auipc	a1,0xa
    391c:	37058593          	addi	a1,a1,880 # dc88 <buf>
    3920:	00003097          	auipc	ra,0x3
    3924:	d54080e7          	jalr	-684(ra) # 6674 <read>
  if(cc != 2 || buf[0] != 'f'){
    3928:	4789                	li	a5,2
    392a:	36f51863          	bne	a0,a5,3c9a <subdir+0x462>
    392e:	0000a717          	auipc	a4,0xa
    3932:	35a74703          	lbu	a4,858(a4) # dc88 <buf>
    3936:	06600793          	li	a5,102
    393a:	36f71063          	bne	a4,a5,3c9a <subdir+0x462>
  close(fd);
    393e:	8526                	mv	a0,s1
    3940:	00003097          	auipc	ra,0x3
    3944:	d44080e7          	jalr	-700(ra) # 6684 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3948:	00004597          	auipc	a1,0x4
    394c:	6f058593          	addi	a1,a1,1776 # 8038 <malloc+0x15a2>
    3950:	00004517          	auipc	a0,0x4
    3954:	66050513          	addi	a0,a0,1632 # 7fb0 <malloc+0x151a>
    3958:	00003097          	auipc	ra,0x3
    395c:	d64080e7          	jalr	-668(ra) # 66bc <link>
    3960:	34051b63          	bnez	a0,3cb6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3964:	00004517          	auipc	a0,0x4
    3968:	64c50513          	addi	a0,a0,1612 # 7fb0 <malloc+0x151a>
    396c:	00003097          	auipc	ra,0x3
    3970:	d40080e7          	jalr	-704(ra) # 66ac <unlink>
    3974:	34051f63          	bnez	a0,3cd2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3978:	4581                	li	a1,0
    397a:	00004517          	auipc	a0,0x4
    397e:	63650513          	addi	a0,a0,1590 # 7fb0 <malloc+0x151a>
    3982:	00003097          	auipc	ra,0x3
    3986:	d1a080e7          	jalr	-742(ra) # 669c <open>
    398a:	36055263          	bgez	a0,3cee <subdir+0x4b6>
  if(chdir("dd") != 0){
    398e:	00004517          	auipc	a0,0x4
    3992:	58250513          	addi	a0,a0,1410 # 7f10 <malloc+0x147a>
    3996:	00003097          	auipc	ra,0x3
    399a:	d36080e7          	jalr	-714(ra) # 66cc <chdir>
    399e:	36051663          	bnez	a0,3d0a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    39a2:	00004517          	auipc	a0,0x4
    39a6:	72e50513          	addi	a0,a0,1838 # 80d0 <malloc+0x163a>
    39aa:	00003097          	auipc	ra,0x3
    39ae:	d22080e7          	jalr	-734(ra) # 66cc <chdir>
    39b2:	36051a63          	bnez	a0,3d26 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    39b6:	00004517          	auipc	a0,0x4
    39ba:	74a50513          	addi	a0,a0,1866 # 8100 <malloc+0x166a>
    39be:	00003097          	auipc	ra,0x3
    39c2:	d0e080e7          	jalr	-754(ra) # 66cc <chdir>
    39c6:	36051e63          	bnez	a0,3d42 <subdir+0x50a>
  if(chdir("./..") != 0){
    39ca:	00004517          	auipc	a0,0x4
    39ce:	76650513          	addi	a0,a0,1894 # 8130 <malloc+0x169a>
    39d2:	00003097          	auipc	ra,0x3
    39d6:	cfa080e7          	jalr	-774(ra) # 66cc <chdir>
    39da:	38051263          	bnez	a0,3d5e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    39de:	4581                	li	a1,0
    39e0:	00004517          	auipc	a0,0x4
    39e4:	65850513          	addi	a0,a0,1624 # 8038 <malloc+0x15a2>
    39e8:	00003097          	auipc	ra,0x3
    39ec:	cb4080e7          	jalr	-844(ra) # 669c <open>
    39f0:	84aa                	mv	s1,a0
  if(fd < 0){
    39f2:	38054463          	bltz	a0,3d7a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    39f6:	660d                	lui	a2,0x3
    39f8:	0000a597          	auipc	a1,0xa
    39fc:	29058593          	addi	a1,a1,656 # dc88 <buf>
    3a00:	00003097          	auipc	ra,0x3
    3a04:	c74080e7          	jalr	-908(ra) # 6674 <read>
    3a08:	4789                	li	a5,2
    3a0a:	38f51663          	bne	a0,a5,3d96 <subdir+0x55e>
  close(fd);
    3a0e:	8526                	mv	a0,s1
    3a10:	00003097          	auipc	ra,0x3
    3a14:	c74080e7          	jalr	-908(ra) # 6684 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3a18:	4581                	li	a1,0
    3a1a:	00004517          	auipc	a0,0x4
    3a1e:	59650513          	addi	a0,a0,1430 # 7fb0 <malloc+0x151a>
    3a22:	00003097          	auipc	ra,0x3
    3a26:	c7a080e7          	jalr	-902(ra) # 669c <open>
    3a2a:	38055463          	bgez	a0,3db2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3a2e:	20200593          	li	a1,514
    3a32:	00004517          	auipc	a0,0x4
    3a36:	78e50513          	addi	a0,a0,1934 # 81c0 <malloc+0x172a>
    3a3a:	00003097          	auipc	ra,0x3
    3a3e:	c62080e7          	jalr	-926(ra) # 669c <open>
    3a42:	38055663          	bgez	a0,3dce <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3a46:	20200593          	li	a1,514
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	7a650513          	addi	a0,a0,1958 # 81f0 <malloc+0x175a>
    3a52:	00003097          	auipc	ra,0x3
    3a56:	c4a080e7          	jalr	-950(ra) # 669c <open>
    3a5a:	38055863          	bgez	a0,3dea <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3a5e:	20000593          	li	a1,512
    3a62:	00004517          	auipc	a0,0x4
    3a66:	4ae50513          	addi	a0,a0,1198 # 7f10 <malloc+0x147a>
    3a6a:	00003097          	auipc	ra,0x3
    3a6e:	c32080e7          	jalr	-974(ra) # 669c <open>
    3a72:	38055a63          	bgez	a0,3e06 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3a76:	4589                	li	a1,2
    3a78:	00004517          	auipc	a0,0x4
    3a7c:	49850513          	addi	a0,a0,1176 # 7f10 <malloc+0x147a>
    3a80:	00003097          	auipc	ra,0x3
    3a84:	c1c080e7          	jalr	-996(ra) # 669c <open>
    3a88:	38055d63          	bgez	a0,3e22 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3a8c:	4585                	li	a1,1
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	48250513          	addi	a0,a0,1154 # 7f10 <malloc+0x147a>
    3a96:	00003097          	auipc	ra,0x3
    3a9a:	c06080e7          	jalr	-1018(ra) # 669c <open>
    3a9e:	3a055063          	bgez	a0,3e3e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3aa2:	00004597          	auipc	a1,0x4
    3aa6:	7de58593          	addi	a1,a1,2014 # 8280 <malloc+0x17ea>
    3aaa:	00004517          	auipc	a0,0x4
    3aae:	71650513          	addi	a0,a0,1814 # 81c0 <malloc+0x172a>
    3ab2:	00003097          	auipc	ra,0x3
    3ab6:	c0a080e7          	jalr	-1014(ra) # 66bc <link>
    3aba:	3a050063          	beqz	a0,3e5a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3abe:	00004597          	auipc	a1,0x4
    3ac2:	7c258593          	addi	a1,a1,1986 # 8280 <malloc+0x17ea>
    3ac6:	00004517          	auipc	a0,0x4
    3aca:	72a50513          	addi	a0,a0,1834 # 81f0 <malloc+0x175a>
    3ace:	00003097          	auipc	ra,0x3
    3ad2:	bee080e7          	jalr	-1042(ra) # 66bc <link>
    3ad6:	3a050063          	beqz	a0,3e76 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3ada:	00004597          	auipc	a1,0x4
    3ade:	55e58593          	addi	a1,a1,1374 # 8038 <malloc+0x15a2>
    3ae2:	00004517          	auipc	a0,0x4
    3ae6:	44e50513          	addi	a0,a0,1102 # 7f30 <malloc+0x149a>
    3aea:	00003097          	auipc	ra,0x3
    3aee:	bd2080e7          	jalr	-1070(ra) # 66bc <link>
    3af2:	3a050063          	beqz	a0,3e92 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3af6:	00004517          	auipc	a0,0x4
    3afa:	6ca50513          	addi	a0,a0,1738 # 81c0 <malloc+0x172a>
    3afe:	00003097          	auipc	ra,0x3
    3b02:	bc6080e7          	jalr	-1082(ra) # 66c4 <mkdir>
    3b06:	3a050463          	beqz	a0,3eae <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3b0a:	00004517          	auipc	a0,0x4
    3b0e:	6e650513          	addi	a0,a0,1766 # 81f0 <malloc+0x175a>
    3b12:	00003097          	auipc	ra,0x3
    3b16:	bb2080e7          	jalr	-1102(ra) # 66c4 <mkdir>
    3b1a:	3a050863          	beqz	a0,3eca <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3b1e:	00004517          	auipc	a0,0x4
    3b22:	51a50513          	addi	a0,a0,1306 # 8038 <malloc+0x15a2>
    3b26:	00003097          	auipc	ra,0x3
    3b2a:	b9e080e7          	jalr	-1122(ra) # 66c4 <mkdir>
    3b2e:	3a050c63          	beqz	a0,3ee6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3b32:	00004517          	auipc	a0,0x4
    3b36:	6be50513          	addi	a0,a0,1726 # 81f0 <malloc+0x175a>
    3b3a:	00003097          	auipc	ra,0x3
    3b3e:	b72080e7          	jalr	-1166(ra) # 66ac <unlink>
    3b42:	3c050063          	beqz	a0,3f02 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	67a50513          	addi	a0,a0,1658 # 81c0 <malloc+0x172a>
    3b4e:	00003097          	auipc	ra,0x3
    3b52:	b5e080e7          	jalr	-1186(ra) # 66ac <unlink>
    3b56:	3c050463          	beqz	a0,3f1e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3b5a:	00004517          	auipc	a0,0x4
    3b5e:	3d650513          	addi	a0,a0,982 # 7f30 <malloc+0x149a>
    3b62:	00003097          	auipc	ra,0x3
    3b66:	b6a080e7          	jalr	-1174(ra) # 66cc <chdir>
    3b6a:	3c050863          	beqz	a0,3f3a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3b6e:	00005517          	auipc	a0,0x5
    3b72:	86250513          	addi	a0,a0,-1950 # 83d0 <malloc+0x193a>
    3b76:	00003097          	auipc	ra,0x3
    3b7a:	b56080e7          	jalr	-1194(ra) # 66cc <chdir>
    3b7e:	3c050c63          	beqz	a0,3f56 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3b82:	00004517          	auipc	a0,0x4
    3b86:	4b650513          	addi	a0,a0,1206 # 8038 <malloc+0x15a2>
    3b8a:	00003097          	auipc	ra,0x3
    3b8e:	b22080e7          	jalr	-1246(ra) # 66ac <unlink>
    3b92:	3e051063          	bnez	a0,3f72 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	39a50513          	addi	a0,a0,922 # 7f30 <malloc+0x149a>
    3b9e:	00003097          	auipc	ra,0x3
    3ba2:	b0e080e7          	jalr	-1266(ra) # 66ac <unlink>
    3ba6:	3e051463          	bnez	a0,3f8e <subdir+0x756>
  if(unlink("dd") == 0){
    3baa:	00004517          	auipc	a0,0x4
    3bae:	36650513          	addi	a0,a0,870 # 7f10 <malloc+0x147a>
    3bb2:	00003097          	auipc	ra,0x3
    3bb6:	afa080e7          	jalr	-1286(ra) # 66ac <unlink>
    3bba:	3e050863          	beqz	a0,3faa <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3bbe:	00005517          	auipc	a0,0x5
    3bc2:	88250513          	addi	a0,a0,-1918 # 8440 <malloc+0x19aa>
    3bc6:	00003097          	auipc	ra,0x3
    3bca:	ae6080e7          	jalr	-1306(ra) # 66ac <unlink>
    3bce:	3e054c63          	bltz	a0,3fc6 <subdir+0x78e>
  if(unlink("dd") < 0){
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	33e50513          	addi	a0,a0,830 # 7f10 <malloc+0x147a>
    3bda:	00003097          	auipc	ra,0x3
    3bde:	ad2080e7          	jalr	-1326(ra) # 66ac <unlink>
    3be2:	40054063          	bltz	a0,3fe2 <subdir+0x7aa>
}
    3be6:	60e2                	ld	ra,24(sp)
    3be8:	6442                	ld	s0,16(sp)
    3bea:	64a2                	ld	s1,8(sp)
    3bec:	6902                	ld	s2,0(sp)
    3bee:	6105                	addi	sp,sp,32
    3bf0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3bf2:	85ca                	mv	a1,s2
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	32450513          	addi	a0,a0,804 # 7f18 <malloc+0x1482>
    3bfc:	00003097          	auipc	ra,0x3
    3c00:	dde080e7          	jalr	-546(ra) # 69da <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00003097          	auipc	ra,0x3
    3c0a:	a56080e7          	jalr	-1450(ra) # 665c <exit>
    printf("%s: create dd/ff failed\n", s);
    3c0e:	85ca                	mv	a1,s2
    3c10:	00004517          	auipc	a0,0x4
    3c14:	32850513          	addi	a0,a0,808 # 7f38 <malloc+0x14a2>
    3c18:	00003097          	auipc	ra,0x3
    3c1c:	dc2080e7          	jalr	-574(ra) # 69da <printf>
    exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00003097          	auipc	ra,0x3
    3c26:	a3a080e7          	jalr	-1478(ra) # 665c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3c2a:	85ca                	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	32c50513          	addi	a0,a0,812 # 7f58 <malloc+0x14c2>
    3c34:	00003097          	auipc	ra,0x3
    3c38:	da6080e7          	jalr	-602(ra) # 69da <printf>
    exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00003097          	auipc	ra,0x3
    3c42:	a1e080e7          	jalr	-1506(ra) # 665c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3c46:	85ca                	mv	a1,s2
    3c48:	00004517          	auipc	a0,0x4
    3c4c:	34850513          	addi	a0,a0,840 # 7f90 <malloc+0x14fa>
    3c50:	00003097          	auipc	ra,0x3
    3c54:	d8a080e7          	jalr	-630(ra) # 69da <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	00003097          	auipc	ra,0x3
    3c5e:	a02080e7          	jalr	-1534(ra) # 665c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3c62:	85ca                	mv	a1,s2
    3c64:	00004517          	auipc	a0,0x4
    3c68:	35c50513          	addi	a0,a0,860 # 7fc0 <malloc+0x152a>
    3c6c:	00003097          	auipc	ra,0x3
    3c70:	d6e080e7          	jalr	-658(ra) # 69da <printf>
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	00003097          	auipc	ra,0x3
    3c7a:	9e6080e7          	jalr	-1562(ra) # 665c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3c7e:	85ca                	mv	a1,s2
    3c80:	00004517          	auipc	a0,0x4
    3c84:	37850513          	addi	a0,a0,888 # 7ff8 <malloc+0x1562>
    3c88:	00003097          	auipc	ra,0x3
    3c8c:	d52080e7          	jalr	-686(ra) # 69da <printf>
    exit(1);
    3c90:	4505                	li	a0,1
    3c92:	00003097          	auipc	ra,0x3
    3c96:	9ca080e7          	jalr	-1590(ra) # 665c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3c9a:	85ca                	mv	a1,s2
    3c9c:	00004517          	auipc	a0,0x4
    3ca0:	37c50513          	addi	a0,a0,892 # 8018 <malloc+0x1582>
    3ca4:	00003097          	auipc	ra,0x3
    3ca8:	d36080e7          	jalr	-714(ra) # 69da <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00003097          	auipc	ra,0x3
    3cb2:	9ae080e7          	jalr	-1618(ra) # 665c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3cb6:	85ca                	mv	a1,s2
    3cb8:	00004517          	auipc	a0,0x4
    3cbc:	39050513          	addi	a0,a0,912 # 8048 <malloc+0x15b2>
    3cc0:	00003097          	auipc	ra,0x3
    3cc4:	d1a080e7          	jalr	-742(ra) # 69da <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00003097          	auipc	ra,0x3
    3cce:	992080e7          	jalr	-1646(ra) # 665c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3cd2:	85ca                	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	39c50513          	addi	a0,a0,924 # 8070 <malloc+0x15da>
    3cdc:	00003097          	auipc	ra,0x3
    3ce0:	cfe080e7          	jalr	-770(ra) # 69da <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00003097          	auipc	ra,0x3
    3cea:	976080e7          	jalr	-1674(ra) # 665c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3cee:	85ca                	mv	a1,s2
    3cf0:	00004517          	auipc	a0,0x4
    3cf4:	3a050513          	addi	a0,a0,928 # 8090 <malloc+0x15fa>
    3cf8:	00003097          	auipc	ra,0x3
    3cfc:	ce2080e7          	jalr	-798(ra) # 69da <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00003097          	auipc	ra,0x3
    3d06:	95a080e7          	jalr	-1702(ra) # 665c <exit>
    printf("%s: chdir dd failed\n", s);
    3d0a:	85ca                	mv	a1,s2
    3d0c:	00004517          	auipc	a0,0x4
    3d10:	3ac50513          	addi	a0,a0,940 # 80b8 <malloc+0x1622>
    3d14:	00003097          	auipc	ra,0x3
    3d18:	cc6080e7          	jalr	-826(ra) # 69da <printf>
    exit(1);
    3d1c:	4505                	li	a0,1
    3d1e:	00003097          	auipc	ra,0x3
    3d22:	93e080e7          	jalr	-1730(ra) # 665c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3d26:	85ca                	mv	a1,s2
    3d28:	00004517          	auipc	a0,0x4
    3d2c:	3b850513          	addi	a0,a0,952 # 80e0 <malloc+0x164a>
    3d30:	00003097          	auipc	ra,0x3
    3d34:	caa080e7          	jalr	-854(ra) # 69da <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00003097          	auipc	ra,0x3
    3d3e:	922080e7          	jalr	-1758(ra) # 665c <exit>
    printf("chdir dd/../../dd failed\n", s);
    3d42:	85ca                	mv	a1,s2
    3d44:	00004517          	auipc	a0,0x4
    3d48:	3cc50513          	addi	a0,a0,972 # 8110 <malloc+0x167a>
    3d4c:	00003097          	auipc	ra,0x3
    3d50:	c8e080e7          	jalr	-882(ra) # 69da <printf>
    exit(1);
    3d54:	4505                	li	a0,1
    3d56:	00003097          	auipc	ra,0x3
    3d5a:	906080e7          	jalr	-1786(ra) # 665c <exit>
    printf("%s: chdir ./.. failed\n", s);
    3d5e:	85ca                	mv	a1,s2
    3d60:	00004517          	auipc	a0,0x4
    3d64:	3d850513          	addi	a0,a0,984 # 8138 <malloc+0x16a2>
    3d68:	00003097          	auipc	ra,0x3
    3d6c:	c72080e7          	jalr	-910(ra) # 69da <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	00003097          	auipc	ra,0x3
    3d76:	8ea080e7          	jalr	-1814(ra) # 665c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3d7a:	85ca                	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	3d450513          	addi	a0,a0,980 # 8150 <malloc+0x16ba>
    3d84:	00003097          	auipc	ra,0x3
    3d88:	c56080e7          	jalr	-938(ra) # 69da <printf>
    exit(1);
    3d8c:	4505                	li	a0,1
    3d8e:	00003097          	auipc	ra,0x3
    3d92:	8ce080e7          	jalr	-1842(ra) # 665c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3d96:	85ca                	mv	a1,s2
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	3d850513          	addi	a0,a0,984 # 8170 <malloc+0x16da>
    3da0:	00003097          	auipc	ra,0x3
    3da4:	c3a080e7          	jalr	-966(ra) # 69da <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00003097          	auipc	ra,0x3
    3dae:	8b2080e7          	jalr	-1870(ra) # 665c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3db2:	85ca                	mv	a1,s2
    3db4:	00004517          	auipc	a0,0x4
    3db8:	3dc50513          	addi	a0,a0,988 # 8190 <malloc+0x16fa>
    3dbc:	00003097          	auipc	ra,0x3
    3dc0:	c1e080e7          	jalr	-994(ra) # 69da <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00003097          	auipc	ra,0x3
    3dca:	896080e7          	jalr	-1898(ra) # 665c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	40050513          	addi	a0,a0,1024 # 81d0 <malloc+0x173a>
    3dd8:	00003097          	auipc	ra,0x3
    3ddc:	c02080e7          	jalr	-1022(ra) # 69da <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00003097          	auipc	ra,0x3
    3de6:	87a080e7          	jalr	-1926(ra) # 665c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3dea:	85ca                	mv	a1,s2
    3dec:	00004517          	auipc	a0,0x4
    3df0:	41450513          	addi	a0,a0,1044 # 8200 <malloc+0x176a>
    3df4:	00003097          	auipc	ra,0x3
    3df8:	be6080e7          	jalr	-1050(ra) # 69da <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00003097          	auipc	ra,0x3
    3e02:	85e080e7          	jalr	-1954(ra) # 665c <exit>
    printf("%s: create dd succeeded!\n", s);
    3e06:	85ca                	mv	a1,s2
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	41850513          	addi	a0,a0,1048 # 8220 <malloc+0x178a>
    3e10:	00003097          	auipc	ra,0x3
    3e14:	bca080e7          	jalr	-1078(ra) # 69da <printf>
    exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	00003097          	auipc	ra,0x3
    3e1e:	842080e7          	jalr	-1982(ra) # 665c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3e22:	85ca                	mv	a1,s2
    3e24:	00004517          	auipc	a0,0x4
    3e28:	41c50513          	addi	a0,a0,1052 # 8240 <malloc+0x17aa>
    3e2c:	00003097          	auipc	ra,0x3
    3e30:	bae080e7          	jalr	-1106(ra) # 69da <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00003097          	auipc	ra,0x3
    3e3a:	826080e7          	jalr	-2010(ra) # 665c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3e3e:	85ca                	mv	a1,s2
    3e40:	00004517          	auipc	a0,0x4
    3e44:	42050513          	addi	a0,a0,1056 # 8260 <malloc+0x17ca>
    3e48:	00003097          	auipc	ra,0x3
    3e4c:	b92080e7          	jalr	-1134(ra) # 69da <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00003097          	auipc	ra,0x3
    3e56:	80a080e7          	jalr	-2038(ra) # 665c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3e5a:	85ca                	mv	a1,s2
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	43450513          	addi	a0,a0,1076 # 8290 <malloc+0x17fa>
    3e64:	00003097          	auipc	ra,0x3
    3e68:	b76080e7          	jalr	-1162(ra) # 69da <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	7ee080e7          	jalr	2030(ra) # 665c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3e76:	85ca                	mv	a1,s2
    3e78:	00004517          	auipc	a0,0x4
    3e7c:	44050513          	addi	a0,a0,1088 # 82b8 <malloc+0x1822>
    3e80:	00003097          	auipc	ra,0x3
    3e84:	b5a080e7          	jalr	-1190(ra) # 69da <printf>
    exit(1);
    3e88:	4505                	li	a0,1
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	7d2080e7          	jalr	2002(ra) # 665c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3e92:	85ca                	mv	a1,s2
    3e94:	00004517          	auipc	a0,0x4
    3e98:	44c50513          	addi	a0,a0,1100 # 82e0 <malloc+0x184a>
    3e9c:	00003097          	auipc	ra,0x3
    3ea0:	b3e080e7          	jalr	-1218(ra) # 69da <printf>
    exit(1);
    3ea4:	4505                	li	a0,1
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	7b6080e7          	jalr	1974(ra) # 665c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3eae:	85ca                	mv	a1,s2
    3eb0:	00004517          	auipc	a0,0x4
    3eb4:	45850513          	addi	a0,a0,1112 # 8308 <malloc+0x1872>
    3eb8:	00003097          	auipc	ra,0x3
    3ebc:	b22080e7          	jalr	-1246(ra) # 69da <printf>
    exit(1);
    3ec0:	4505                	li	a0,1
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	79a080e7          	jalr	1946(ra) # 665c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3eca:	85ca                	mv	a1,s2
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	45c50513          	addi	a0,a0,1116 # 8328 <malloc+0x1892>
    3ed4:	00003097          	auipc	ra,0x3
    3ed8:	b06080e7          	jalr	-1274(ra) # 69da <printf>
    exit(1);
    3edc:	4505                	li	a0,1
    3ede:	00002097          	auipc	ra,0x2
    3ee2:	77e080e7          	jalr	1918(ra) # 665c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3ee6:	85ca                	mv	a1,s2
    3ee8:	00004517          	auipc	a0,0x4
    3eec:	46050513          	addi	a0,a0,1120 # 8348 <malloc+0x18b2>
    3ef0:	00003097          	auipc	ra,0x3
    3ef4:	aea080e7          	jalr	-1302(ra) # 69da <printf>
    exit(1);
    3ef8:	4505                	li	a0,1
    3efa:	00002097          	auipc	ra,0x2
    3efe:	762080e7          	jalr	1890(ra) # 665c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3f02:	85ca                	mv	a1,s2
    3f04:	00004517          	auipc	a0,0x4
    3f08:	46c50513          	addi	a0,a0,1132 # 8370 <malloc+0x18da>
    3f0c:	00003097          	auipc	ra,0x3
    3f10:	ace080e7          	jalr	-1330(ra) # 69da <printf>
    exit(1);
    3f14:	4505                	li	a0,1
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	746080e7          	jalr	1862(ra) # 665c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3f1e:	85ca                	mv	a1,s2
    3f20:	00004517          	auipc	a0,0x4
    3f24:	47050513          	addi	a0,a0,1136 # 8390 <malloc+0x18fa>
    3f28:	00003097          	auipc	ra,0x3
    3f2c:	ab2080e7          	jalr	-1358(ra) # 69da <printf>
    exit(1);
    3f30:	4505                	li	a0,1
    3f32:	00002097          	auipc	ra,0x2
    3f36:	72a080e7          	jalr	1834(ra) # 665c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3f3a:	85ca                	mv	a1,s2
    3f3c:	00004517          	auipc	a0,0x4
    3f40:	47450513          	addi	a0,a0,1140 # 83b0 <malloc+0x191a>
    3f44:	00003097          	auipc	ra,0x3
    3f48:	a96080e7          	jalr	-1386(ra) # 69da <printf>
    exit(1);
    3f4c:	4505                	li	a0,1
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	70e080e7          	jalr	1806(ra) # 665c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3f56:	85ca                	mv	a1,s2
    3f58:	00004517          	auipc	a0,0x4
    3f5c:	48050513          	addi	a0,a0,1152 # 83d8 <malloc+0x1942>
    3f60:	00003097          	auipc	ra,0x3
    3f64:	a7a080e7          	jalr	-1414(ra) # 69da <printf>
    exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	6f2080e7          	jalr	1778(ra) # 665c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3f72:	85ca                	mv	a1,s2
    3f74:	00004517          	auipc	a0,0x4
    3f78:	0fc50513          	addi	a0,a0,252 # 8070 <malloc+0x15da>
    3f7c:	00003097          	auipc	ra,0x3
    3f80:	a5e080e7          	jalr	-1442(ra) # 69da <printf>
    exit(1);
    3f84:	4505                	li	a0,1
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	6d6080e7          	jalr	1750(ra) # 665c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3f8e:	85ca                	mv	a1,s2
    3f90:	00004517          	auipc	a0,0x4
    3f94:	46850513          	addi	a0,a0,1128 # 83f8 <malloc+0x1962>
    3f98:	00003097          	auipc	ra,0x3
    3f9c:	a42080e7          	jalr	-1470(ra) # 69da <printf>
    exit(1);
    3fa0:	4505                	li	a0,1
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	6ba080e7          	jalr	1722(ra) # 665c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3faa:	85ca                	mv	a1,s2
    3fac:	00004517          	auipc	a0,0x4
    3fb0:	46c50513          	addi	a0,a0,1132 # 8418 <malloc+0x1982>
    3fb4:	00003097          	auipc	ra,0x3
    3fb8:	a26080e7          	jalr	-1498(ra) # 69da <printf>
    exit(1);
    3fbc:	4505                	li	a0,1
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	69e080e7          	jalr	1694(ra) # 665c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3fc6:	85ca                	mv	a1,s2
    3fc8:	00004517          	auipc	a0,0x4
    3fcc:	48050513          	addi	a0,a0,1152 # 8448 <malloc+0x19b2>
    3fd0:	00003097          	auipc	ra,0x3
    3fd4:	a0a080e7          	jalr	-1526(ra) # 69da <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00002097          	auipc	ra,0x2
    3fde:	682080e7          	jalr	1666(ra) # 665c <exit>
    printf("%s: unlink dd failed\n", s);
    3fe2:	85ca                	mv	a1,s2
    3fe4:	00004517          	auipc	a0,0x4
    3fe8:	48450513          	addi	a0,a0,1156 # 8468 <malloc+0x19d2>
    3fec:	00003097          	auipc	ra,0x3
    3ff0:	9ee080e7          	jalr	-1554(ra) # 69da <printf>
    exit(1);
    3ff4:	4505                	li	a0,1
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	666080e7          	jalr	1638(ra) # 665c <exit>

0000000000003ffe <rmdot>:
{
    3ffe:	1101                	addi	sp,sp,-32
    4000:	ec06                	sd	ra,24(sp)
    4002:	e822                	sd	s0,16(sp)
    4004:	e426                	sd	s1,8(sp)
    4006:	1000                	addi	s0,sp,32
    4008:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    400a:	00004517          	auipc	a0,0x4
    400e:	47650513          	addi	a0,a0,1142 # 8480 <malloc+0x19ea>
    4012:	00002097          	auipc	ra,0x2
    4016:	6b2080e7          	jalr	1714(ra) # 66c4 <mkdir>
    401a:	e549                	bnez	a0,40a4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    401c:	00004517          	auipc	a0,0x4
    4020:	46450513          	addi	a0,a0,1124 # 8480 <malloc+0x19ea>
    4024:	00002097          	auipc	ra,0x2
    4028:	6a8080e7          	jalr	1704(ra) # 66cc <chdir>
    402c:	e951                	bnez	a0,40c0 <rmdot+0xc2>
  if(unlink(".") == 0){
    402e:	00003517          	auipc	a0,0x3
    4032:	28250513          	addi	a0,a0,642 # 72b0 <malloc+0x81a>
    4036:	00002097          	auipc	ra,0x2
    403a:	676080e7          	jalr	1654(ra) # 66ac <unlink>
    403e:	cd59                	beqz	a0,40dc <rmdot+0xde>
  if(unlink("..") == 0){
    4040:	00004517          	auipc	a0,0x4
    4044:	e9850513          	addi	a0,a0,-360 # 7ed8 <malloc+0x1442>
    4048:	00002097          	auipc	ra,0x2
    404c:	664080e7          	jalr	1636(ra) # 66ac <unlink>
    4050:	c545                	beqz	a0,40f8 <rmdot+0xfa>
  if(chdir("/") != 0){
    4052:	00004517          	auipc	a0,0x4
    4056:	e2e50513          	addi	a0,a0,-466 # 7e80 <malloc+0x13ea>
    405a:	00002097          	auipc	ra,0x2
    405e:	672080e7          	jalr	1650(ra) # 66cc <chdir>
    4062:	e94d                	bnez	a0,4114 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    4064:	00004517          	auipc	a0,0x4
    4068:	48450513          	addi	a0,a0,1156 # 84e8 <malloc+0x1a52>
    406c:	00002097          	auipc	ra,0x2
    4070:	640080e7          	jalr	1600(ra) # 66ac <unlink>
    4074:	cd55                	beqz	a0,4130 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    4076:	00004517          	auipc	a0,0x4
    407a:	49a50513          	addi	a0,a0,1178 # 8510 <malloc+0x1a7a>
    407e:	00002097          	auipc	ra,0x2
    4082:	62e080e7          	jalr	1582(ra) # 66ac <unlink>
    4086:	c179                	beqz	a0,414c <rmdot+0x14e>
  if(unlink("dots") != 0){
    4088:	00004517          	auipc	a0,0x4
    408c:	3f850513          	addi	a0,a0,1016 # 8480 <malloc+0x19ea>
    4090:	00002097          	auipc	ra,0x2
    4094:	61c080e7          	jalr	1564(ra) # 66ac <unlink>
    4098:	e961                	bnez	a0,4168 <rmdot+0x16a>
}
    409a:	60e2                	ld	ra,24(sp)
    409c:	6442                	ld	s0,16(sp)
    409e:	64a2                	ld	s1,8(sp)
    40a0:	6105                	addi	sp,sp,32
    40a2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    40a4:	85a6                	mv	a1,s1
    40a6:	00004517          	auipc	a0,0x4
    40aa:	3e250513          	addi	a0,a0,994 # 8488 <malloc+0x19f2>
    40ae:	00003097          	auipc	ra,0x3
    40b2:	92c080e7          	jalr	-1748(ra) # 69da <printf>
    exit(1);
    40b6:	4505                	li	a0,1
    40b8:	00002097          	auipc	ra,0x2
    40bc:	5a4080e7          	jalr	1444(ra) # 665c <exit>
    printf("%s: chdir dots failed\n", s);
    40c0:	85a6                	mv	a1,s1
    40c2:	00004517          	auipc	a0,0x4
    40c6:	3de50513          	addi	a0,a0,990 # 84a0 <malloc+0x1a0a>
    40ca:	00003097          	auipc	ra,0x3
    40ce:	910080e7          	jalr	-1776(ra) # 69da <printf>
    exit(1);
    40d2:	4505                	li	a0,1
    40d4:	00002097          	auipc	ra,0x2
    40d8:	588080e7          	jalr	1416(ra) # 665c <exit>
    printf("%s: rm . worked!\n", s);
    40dc:	85a6                	mv	a1,s1
    40de:	00004517          	auipc	a0,0x4
    40e2:	3da50513          	addi	a0,a0,986 # 84b8 <malloc+0x1a22>
    40e6:	00003097          	auipc	ra,0x3
    40ea:	8f4080e7          	jalr	-1804(ra) # 69da <printf>
    exit(1);
    40ee:	4505                	li	a0,1
    40f0:	00002097          	auipc	ra,0x2
    40f4:	56c080e7          	jalr	1388(ra) # 665c <exit>
    printf("%s: rm .. worked!\n", s);
    40f8:	85a6                	mv	a1,s1
    40fa:	00004517          	auipc	a0,0x4
    40fe:	3d650513          	addi	a0,a0,982 # 84d0 <malloc+0x1a3a>
    4102:	00003097          	auipc	ra,0x3
    4106:	8d8080e7          	jalr	-1832(ra) # 69da <printf>
    exit(1);
    410a:	4505                	li	a0,1
    410c:	00002097          	auipc	ra,0x2
    4110:	550080e7          	jalr	1360(ra) # 665c <exit>
    printf("%s: chdir / failed\n", s);
    4114:	85a6                	mv	a1,s1
    4116:	00004517          	auipc	a0,0x4
    411a:	d7250513          	addi	a0,a0,-654 # 7e88 <malloc+0x13f2>
    411e:	00003097          	auipc	ra,0x3
    4122:	8bc080e7          	jalr	-1860(ra) # 69da <printf>
    exit(1);
    4126:	4505                	li	a0,1
    4128:	00002097          	auipc	ra,0x2
    412c:	534080e7          	jalr	1332(ra) # 665c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    4130:	85a6                	mv	a1,s1
    4132:	00004517          	auipc	a0,0x4
    4136:	3be50513          	addi	a0,a0,958 # 84f0 <malloc+0x1a5a>
    413a:	00003097          	auipc	ra,0x3
    413e:	8a0080e7          	jalr	-1888(ra) # 69da <printf>
    exit(1);
    4142:	4505                	li	a0,1
    4144:	00002097          	auipc	ra,0x2
    4148:	518080e7          	jalr	1304(ra) # 665c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    414c:	85a6                	mv	a1,s1
    414e:	00004517          	auipc	a0,0x4
    4152:	3ca50513          	addi	a0,a0,970 # 8518 <malloc+0x1a82>
    4156:	00003097          	auipc	ra,0x3
    415a:	884080e7          	jalr	-1916(ra) # 69da <printf>
    exit(1);
    415e:	4505                	li	a0,1
    4160:	00002097          	auipc	ra,0x2
    4164:	4fc080e7          	jalr	1276(ra) # 665c <exit>
    printf("%s: unlink dots failed!\n", s);
    4168:	85a6                	mv	a1,s1
    416a:	00004517          	auipc	a0,0x4
    416e:	3ce50513          	addi	a0,a0,974 # 8538 <malloc+0x1aa2>
    4172:	00003097          	auipc	ra,0x3
    4176:	868080e7          	jalr	-1944(ra) # 69da <printf>
    exit(1);
    417a:	4505                	li	a0,1
    417c:	00002097          	auipc	ra,0x2
    4180:	4e0080e7          	jalr	1248(ra) # 665c <exit>

0000000000004184 <dirfile>:
{
    4184:	1101                	addi	sp,sp,-32
    4186:	ec06                	sd	ra,24(sp)
    4188:	e822                	sd	s0,16(sp)
    418a:	e426                	sd	s1,8(sp)
    418c:	e04a                	sd	s2,0(sp)
    418e:	1000                	addi	s0,sp,32
    4190:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4192:	20000593          	li	a1,512
    4196:	00004517          	auipc	a0,0x4
    419a:	3c250513          	addi	a0,a0,962 # 8558 <malloc+0x1ac2>
    419e:	00002097          	auipc	ra,0x2
    41a2:	4fe080e7          	jalr	1278(ra) # 669c <open>
  if(fd < 0){
    41a6:	0e054d63          	bltz	a0,42a0 <dirfile+0x11c>
  close(fd);
    41aa:	00002097          	auipc	ra,0x2
    41ae:	4da080e7          	jalr	1242(ra) # 6684 <close>
  if(chdir("dirfile") == 0){
    41b2:	00004517          	auipc	a0,0x4
    41b6:	3a650513          	addi	a0,a0,934 # 8558 <malloc+0x1ac2>
    41ba:	00002097          	auipc	ra,0x2
    41be:	512080e7          	jalr	1298(ra) # 66cc <chdir>
    41c2:	cd6d                	beqz	a0,42bc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    41c4:	4581                	li	a1,0
    41c6:	00004517          	auipc	a0,0x4
    41ca:	3da50513          	addi	a0,a0,986 # 85a0 <malloc+0x1b0a>
    41ce:	00002097          	auipc	ra,0x2
    41d2:	4ce080e7          	jalr	1230(ra) # 669c <open>
  if(fd >= 0){
    41d6:	10055163          	bgez	a0,42d8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    41da:	20000593          	li	a1,512
    41de:	00004517          	auipc	a0,0x4
    41e2:	3c250513          	addi	a0,a0,962 # 85a0 <malloc+0x1b0a>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	4b6080e7          	jalr	1206(ra) # 669c <open>
  if(fd >= 0){
    41ee:	10055363          	bgez	a0,42f4 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    41f2:	00004517          	auipc	a0,0x4
    41f6:	3ae50513          	addi	a0,a0,942 # 85a0 <malloc+0x1b0a>
    41fa:	00002097          	auipc	ra,0x2
    41fe:	4ca080e7          	jalr	1226(ra) # 66c4 <mkdir>
    4202:	10050763          	beqz	a0,4310 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4206:	00004517          	auipc	a0,0x4
    420a:	39a50513          	addi	a0,a0,922 # 85a0 <malloc+0x1b0a>
    420e:	00002097          	auipc	ra,0x2
    4212:	49e080e7          	jalr	1182(ra) # 66ac <unlink>
    4216:	10050b63          	beqz	a0,432c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    421a:	00004597          	auipc	a1,0x4
    421e:	38658593          	addi	a1,a1,902 # 85a0 <malloc+0x1b0a>
    4222:	00003517          	auipc	a0,0x3
    4226:	b7e50513          	addi	a0,a0,-1154 # 6da0 <malloc+0x30a>
    422a:	00002097          	auipc	ra,0x2
    422e:	492080e7          	jalr	1170(ra) # 66bc <link>
    4232:	10050b63          	beqz	a0,4348 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    4236:	00004517          	auipc	a0,0x4
    423a:	32250513          	addi	a0,a0,802 # 8558 <malloc+0x1ac2>
    423e:	00002097          	auipc	ra,0x2
    4242:	46e080e7          	jalr	1134(ra) # 66ac <unlink>
    4246:	10051f63          	bnez	a0,4364 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    424a:	4589                	li	a1,2
    424c:	00003517          	auipc	a0,0x3
    4250:	06450513          	addi	a0,a0,100 # 72b0 <malloc+0x81a>
    4254:	00002097          	auipc	ra,0x2
    4258:	448080e7          	jalr	1096(ra) # 669c <open>
  if(fd >= 0){
    425c:	12055263          	bgez	a0,4380 <dirfile+0x1fc>
  fd = open(".", 0);
    4260:	4581                	li	a1,0
    4262:	00003517          	auipc	a0,0x3
    4266:	04e50513          	addi	a0,a0,78 # 72b0 <malloc+0x81a>
    426a:	00002097          	auipc	ra,0x2
    426e:	432080e7          	jalr	1074(ra) # 669c <open>
    4272:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4274:	4605                	li	a2,1
    4276:	00003597          	auipc	a1,0x3
    427a:	9c258593          	addi	a1,a1,-1598 # 6c38 <malloc+0x1a2>
    427e:	00002097          	auipc	ra,0x2
    4282:	3fe080e7          	jalr	1022(ra) # 667c <write>
    4286:	10a04b63          	bgtz	a0,439c <dirfile+0x218>
  close(fd);
    428a:	8526                	mv	a0,s1
    428c:	00002097          	auipc	ra,0x2
    4290:	3f8080e7          	jalr	1016(ra) # 6684 <close>
}
    4294:	60e2                	ld	ra,24(sp)
    4296:	6442                	ld	s0,16(sp)
    4298:	64a2                	ld	s1,8(sp)
    429a:	6902                	ld	s2,0(sp)
    429c:	6105                	addi	sp,sp,32
    429e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    42a0:	85ca                	mv	a1,s2
    42a2:	00004517          	auipc	a0,0x4
    42a6:	2be50513          	addi	a0,a0,702 # 8560 <malloc+0x1aca>
    42aa:	00002097          	auipc	ra,0x2
    42ae:	730080e7          	jalr	1840(ra) # 69da <printf>
    exit(1);
    42b2:	4505                	li	a0,1
    42b4:	00002097          	auipc	ra,0x2
    42b8:	3a8080e7          	jalr	936(ra) # 665c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    42bc:	85ca                	mv	a1,s2
    42be:	00004517          	auipc	a0,0x4
    42c2:	2c250513          	addi	a0,a0,706 # 8580 <malloc+0x1aea>
    42c6:	00002097          	auipc	ra,0x2
    42ca:	714080e7          	jalr	1812(ra) # 69da <printf>
    exit(1);
    42ce:	4505                	li	a0,1
    42d0:	00002097          	auipc	ra,0x2
    42d4:	38c080e7          	jalr	908(ra) # 665c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    42d8:	85ca                	mv	a1,s2
    42da:	00004517          	auipc	a0,0x4
    42de:	2d650513          	addi	a0,a0,726 # 85b0 <malloc+0x1b1a>
    42e2:	00002097          	auipc	ra,0x2
    42e6:	6f8080e7          	jalr	1784(ra) # 69da <printf>
    exit(1);
    42ea:	4505                	li	a0,1
    42ec:	00002097          	auipc	ra,0x2
    42f0:	370080e7          	jalr	880(ra) # 665c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    42f4:	85ca                	mv	a1,s2
    42f6:	00004517          	auipc	a0,0x4
    42fa:	2ba50513          	addi	a0,a0,698 # 85b0 <malloc+0x1b1a>
    42fe:	00002097          	auipc	ra,0x2
    4302:	6dc080e7          	jalr	1756(ra) # 69da <printf>
    exit(1);
    4306:	4505                	li	a0,1
    4308:	00002097          	auipc	ra,0x2
    430c:	354080e7          	jalr	852(ra) # 665c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4310:	85ca                	mv	a1,s2
    4312:	00004517          	auipc	a0,0x4
    4316:	2c650513          	addi	a0,a0,710 # 85d8 <malloc+0x1b42>
    431a:	00002097          	auipc	ra,0x2
    431e:	6c0080e7          	jalr	1728(ra) # 69da <printf>
    exit(1);
    4322:	4505                	li	a0,1
    4324:	00002097          	auipc	ra,0x2
    4328:	338080e7          	jalr	824(ra) # 665c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    432c:	85ca                	mv	a1,s2
    432e:	00004517          	auipc	a0,0x4
    4332:	2d250513          	addi	a0,a0,722 # 8600 <malloc+0x1b6a>
    4336:	00002097          	auipc	ra,0x2
    433a:	6a4080e7          	jalr	1700(ra) # 69da <printf>
    exit(1);
    433e:	4505                	li	a0,1
    4340:	00002097          	auipc	ra,0x2
    4344:	31c080e7          	jalr	796(ra) # 665c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4348:	85ca                	mv	a1,s2
    434a:	00004517          	auipc	a0,0x4
    434e:	2de50513          	addi	a0,a0,734 # 8628 <malloc+0x1b92>
    4352:	00002097          	auipc	ra,0x2
    4356:	688080e7          	jalr	1672(ra) # 69da <printf>
    exit(1);
    435a:	4505                	li	a0,1
    435c:	00002097          	auipc	ra,0x2
    4360:	300080e7          	jalr	768(ra) # 665c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4364:	85ca                	mv	a1,s2
    4366:	00004517          	auipc	a0,0x4
    436a:	2ea50513          	addi	a0,a0,746 # 8650 <malloc+0x1bba>
    436e:	00002097          	auipc	ra,0x2
    4372:	66c080e7          	jalr	1644(ra) # 69da <printf>
    exit(1);
    4376:	4505                	li	a0,1
    4378:	00002097          	auipc	ra,0x2
    437c:	2e4080e7          	jalr	740(ra) # 665c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4380:	85ca                	mv	a1,s2
    4382:	00004517          	auipc	a0,0x4
    4386:	2ee50513          	addi	a0,a0,750 # 8670 <malloc+0x1bda>
    438a:	00002097          	auipc	ra,0x2
    438e:	650080e7          	jalr	1616(ra) # 69da <printf>
    exit(1);
    4392:	4505                	li	a0,1
    4394:	00002097          	auipc	ra,0x2
    4398:	2c8080e7          	jalr	712(ra) # 665c <exit>
    printf("%s: write . succeeded!\n", s);
    439c:	85ca                	mv	a1,s2
    439e:	00004517          	auipc	a0,0x4
    43a2:	2fa50513          	addi	a0,a0,762 # 8698 <malloc+0x1c02>
    43a6:	00002097          	auipc	ra,0x2
    43aa:	634080e7          	jalr	1588(ra) # 69da <printf>
    exit(1);
    43ae:	4505                	li	a0,1
    43b0:	00002097          	auipc	ra,0x2
    43b4:	2ac080e7          	jalr	684(ra) # 665c <exit>

00000000000043b8 <iref>:
{
    43b8:	715d                	addi	sp,sp,-80
    43ba:	e486                	sd	ra,72(sp)
    43bc:	e0a2                	sd	s0,64(sp)
    43be:	fc26                	sd	s1,56(sp)
    43c0:	f84a                	sd	s2,48(sp)
    43c2:	f44e                	sd	s3,40(sp)
    43c4:	f052                	sd	s4,32(sp)
    43c6:	ec56                	sd	s5,24(sp)
    43c8:	e85a                	sd	s6,16(sp)
    43ca:	e45e                	sd	s7,8(sp)
    43cc:	0880                	addi	s0,sp,80
    43ce:	8baa                	mv	s7,a0
    43d0:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    43d4:	00004a97          	auipc	s5,0x4
    43d8:	2dca8a93          	addi	s5,s5,732 # 86b0 <malloc+0x1c1a>
    mkdir("");
    43dc:	00004497          	auipc	s1,0x4
    43e0:	ddc48493          	addi	s1,s1,-548 # 81b8 <malloc+0x1722>
    link("README", "");
    43e4:	00003b17          	auipc	s6,0x3
    43e8:	9bcb0b13          	addi	s6,s6,-1604 # 6da0 <malloc+0x30a>
    fd = open("", O_CREATE);
    43ec:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    43f0:	00004997          	auipc	s3,0x4
    43f4:	1b898993          	addi	s3,s3,440 # 85a8 <malloc+0x1b12>
    43f8:	a891                	j	444c <iref+0x94>
      printf("%s: mkdir irefd failed\n", s);
    43fa:	85de                	mv	a1,s7
    43fc:	00004517          	auipc	a0,0x4
    4400:	2bc50513          	addi	a0,a0,700 # 86b8 <malloc+0x1c22>
    4404:	00002097          	auipc	ra,0x2
    4408:	5d6080e7          	jalr	1494(ra) # 69da <printf>
      exit(1);
    440c:	4505                	li	a0,1
    440e:	00002097          	auipc	ra,0x2
    4412:	24e080e7          	jalr	590(ra) # 665c <exit>
      printf("%s: chdir irefd failed\n", s);
    4416:	85de                	mv	a1,s7
    4418:	00004517          	auipc	a0,0x4
    441c:	2b850513          	addi	a0,a0,696 # 86d0 <malloc+0x1c3a>
    4420:	00002097          	auipc	ra,0x2
    4424:	5ba080e7          	jalr	1466(ra) # 69da <printf>
      exit(1);
    4428:	4505                	li	a0,1
    442a:	00002097          	auipc	ra,0x2
    442e:	232080e7          	jalr	562(ra) # 665c <exit>
      close(fd);
    4432:	00002097          	auipc	ra,0x2
    4436:	252080e7          	jalr	594(ra) # 6684 <close>
    443a:	a881                	j	448a <iref+0xd2>
    unlink("xx");
    443c:	854e                	mv	a0,s3
    443e:	00002097          	auipc	ra,0x2
    4442:	26e080e7          	jalr	622(ra) # 66ac <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4446:	397d                	addiw	s2,s2,-1
    4448:	04090e63          	beqz	s2,44a4 <iref+0xec>
    if(mkdir("irefd") != 0){
    444c:	8556                	mv	a0,s5
    444e:	00002097          	auipc	ra,0x2
    4452:	276080e7          	jalr	630(ra) # 66c4 <mkdir>
    4456:	f155                	bnez	a0,43fa <iref+0x42>
    if(chdir("irefd") != 0){
    4458:	8556                	mv	a0,s5
    445a:	00002097          	auipc	ra,0x2
    445e:	272080e7          	jalr	626(ra) # 66cc <chdir>
    4462:	f955                	bnez	a0,4416 <iref+0x5e>
    mkdir("");
    4464:	8526                	mv	a0,s1
    4466:	00002097          	auipc	ra,0x2
    446a:	25e080e7          	jalr	606(ra) # 66c4 <mkdir>
    link("README", "");
    446e:	85a6                	mv	a1,s1
    4470:	855a                	mv	a0,s6
    4472:	00002097          	auipc	ra,0x2
    4476:	24a080e7          	jalr	586(ra) # 66bc <link>
    fd = open("", O_CREATE);
    447a:	85d2                	mv	a1,s4
    447c:	8526                	mv	a0,s1
    447e:	00002097          	auipc	ra,0x2
    4482:	21e080e7          	jalr	542(ra) # 669c <open>
    if(fd >= 0)
    4486:	fa0556e3          	bgez	a0,4432 <iref+0x7a>
    fd = open("xx", O_CREATE);
    448a:	85d2                	mv	a1,s4
    448c:	854e                	mv	a0,s3
    448e:	00002097          	auipc	ra,0x2
    4492:	20e080e7          	jalr	526(ra) # 669c <open>
    if(fd >= 0)
    4496:	fa0543e3          	bltz	a0,443c <iref+0x84>
      close(fd);
    449a:	00002097          	auipc	ra,0x2
    449e:	1ea080e7          	jalr	490(ra) # 6684 <close>
    44a2:	bf69                	j	443c <iref+0x84>
    44a4:	03300493          	li	s1,51
    chdir("..");
    44a8:	00004997          	auipc	s3,0x4
    44ac:	a3098993          	addi	s3,s3,-1488 # 7ed8 <malloc+0x1442>
    unlink("irefd");
    44b0:	00004917          	auipc	s2,0x4
    44b4:	20090913          	addi	s2,s2,512 # 86b0 <malloc+0x1c1a>
    chdir("..");
    44b8:	854e                	mv	a0,s3
    44ba:	00002097          	auipc	ra,0x2
    44be:	212080e7          	jalr	530(ra) # 66cc <chdir>
    unlink("irefd");
    44c2:	854a                	mv	a0,s2
    44c4:	00002097          	auipc	ra,0x2
    44c8:	1e8080e7          	jalr	488(ra) # 66ac <unlink>
  for(i = 0; i < NINODE + 1; i++){
    44cc:	34fd                	addiw	s1,s1,-1
    44ce:	f4ed                	bnez	s1,44b8 <iref+0x100>
  chdir("/");
    44d0:	00004517          	auipc	a0,0x4
    44d4:	9b050513          	addi	a0,a0,-1616 # 7e80 <malloc+0x13ea>
    44d8:	00002097          	auipc	ra,0x2
    44dc:	1f4080e7          	jalr	500(ra) # 66cc <chdir>
}
    44e0:	60a6                	ld	ra,72(sp)
    44e2:	6406                	ld	s0,64(sp)
    44e4:	74e2                	ld	s1,56(sp)
    44e6:	7942                	ld	s2,48(sp)
    44e8:	79a2                	ld	s3,40(sp)
    44ea:	7a02                	ld	s4,32(sp)
    44ec:	6ae2                	ld	s5,24(sp)
    44ee:	6b42                	ld	s6,16(sp)
    44f0:	6ba2                	ld	s7,8(sp)
    44f2:	6161                	addi	sp,sp,80
    44f4:	8082                	ret

00000000000044f6 <openiputtest>:
{
    44f6:	7179                	addi	sp,sp,-48
    44f8:	f406                	sd	ra,40(sp)
    44fa:	f022                	sd	s0,32(sp)
    44fc:	ec26                	sd	s1,24(sp)
    44fe:	1800                	addi	s0,sp,48
    4500:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4502:	00004517          	auipc	a0,0x4
    4506:	1e650513          	addi	a0,a0,486 # 86e8 <malloc+0x1c52>
    450a:	00002097          	auipc	ra,0x2
    450e:	1ba080e7          	jalr	442(ra) # 66c4 <mkdir>
    4512:	04054263          	bltz	a0,4556 <openiputtest+0x60>
  pid = fork();
    4516:	00002097          	auipc	ra,0x2
    451a:	13e080e7          	jalr	318(ra) # 6654 <fork>
  if(pid < 0){
    451e:	04054a63          	bltz	a0,4572 <openiputtest+0x7c>
  if(pid == 0){
    4522:	e93d                	bnez	a0,4598 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4524:	4589                	li	a1,2
    4526:	00004517          	auipc	a0,0x4
    452a:	1c250513          	addi	a0,a0,450 # 86e8 <malloc+0x1c52>
    452e:	00002097          	auipc	ra,0x2
    4532:	16e080e7          	jalr	366(ra) # 669c <open>
    if(fd >= 0){
    4536:	04054c63          	bltz	a0,458e <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    453a:	85a6                	mv	a1,s1
    453c:	00004517          	auipc	a0,0x4
    4540:	1cc50513          	addi	a0,a0,460 # 8708 <malloc+0x1c72>
    4544:	00002097          	auipc	ra,0x2
    4548:	496080e7          	jalr	1174(ra) # 69da <printf>
      exit(1);
    454c:	4505                	li	a0,1
    454e:	00002097          	auipc	ra,0x2
    4552:	10e080e7          	jalr	270(ra) # 665c <exit>
    printf("%s: mkdir oidir failed\n", s);
    4556:	85a6                	mv	a1,s1
    4558:	00004517          	auipc	a0,0x4
    455c:	19850513          	addi	a0,a0,408 # 86f0 <malloc+0x1c5a>
    4560:	00002097          	auipc	ra,0x2
    4564:	47a080e7          	jalr	1146(ra) # 69da <printf>
    exit(1);
    4568:	4505                	li	a0,1
    456a:	00002097          	auipc	ra,0x2
    456e:	0f2080e7          	jalr	242(ra) # 665c <exit>
    printf("%s: fork failed\n", s);
    4572:	85a6                	mv	a1,s1
    4574:	00003517          	auipc	a0,0x3
    4578:	edc50513          	addi	a0,a0,-292 # 7450 <malloc+0x9ba>
    457c:	00002097          	auipc	ra,0x2
    4580:	45e080e7          	jalr	1118(ra) # 69da <printf>
    exit(1);
    4584:	4505                	li	a0,1
    4586:	00002097          	auipc	ra,0x2
    458a:	0d6080e7          	jalr	214(ra) # 665c <exit>
    exit(0);
    458e:	4501                	li	a0,0
    4590:	00002097          	auipc	ra,0x2
    4594:	0cc080e7          	jalr	204(ra) # 665c <exit>
  sleep(1);
    4598:	4505                	li	a0,1
    459a:	00002097          	auipc	ra,0x2
    459e:	152080e7          	jalr	338(ra) # 66ec <sleep>
  if(unlink("oidir") != 0){
    45a2:	00004517          	auipc	a0,0x4
    45a6:	14650513          	addi	a0,a0,326 # 86e8 <malloc+0x1c52>
    45aa:	00002097          	auipc	ra,0x2
    45ae:	102080e7          	jalr	258(ra) # 66ac <unlink>
    45b2:	cd19                	beqz	a0,45d0 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    45b4:	85a6                	mv	a1,s1
    45b6:	00003517          	auipc	a0,0x3
    45ba:	08a50513          	addi	a0,a0,138 # 7640 <malloc+0xbaa>
    45be:	00002097          	auipc	ra,0x2
    45c2:	41c080e7          	jalr	1052(ra) # 69da <printf>
    exit(1);
    45c6:	4505                	li	a0,1
    45c8:	00002097          	auipc	ra,0x2
    45cc:	094080e7          	jalr	148(ra) # 665c <exit>
  wait(&xstatus);
    45d0:	fdc40513          	addi	a0,s0,-36
    45d4:	00002097          	auipc	ra,0x2
    45d8:	090080e7          	jalr	144(ra) # 6664 <wait>
  exit(xstatus);
    45dc:	fdc42503          	lw	a0,-36(s0)
    45e0:	00002097          	auipc	ra,0x2
    45e4:	07c080e7          	jalr	124(ra) # 665c <exit>

00000000000045e8 <forkforkfork>:
{
    45e8:	1101                	addi	sp,sp,-32
    45ea:	ec06                	sd	ra,24(sp)
    45ec:	e822                	sd	s0,16(sp)
    45ee:	e426                	sd	s1,8(sp)
    45f0:	1000                	addi	s0,sp,32
    45f2:	84aa                	mv	s1,a0
  unlink("stopforking");
    45f4:	00004517          	auipc	a0,0x4
    45f8:	13c50513          	addi	a0,a0,316 # 8730 <malloc+0x1c9a>
    45fc:	00002097          	auipc	ra,0x2
    4600:	0b0080e7          	jalr	176(ra) # 66ac <unlink>
  int pid = fork();
    4604:	00002097          	auipc	ra,0x2
    4608:	050080e7          	jalr	80(ra) # 6654 <fork>
  if(pid < 0){
    460c:	04054563          	bltz	a0,4656 <forkforkfork+0x6e>
  if(pid == 0){
    4610:	c12d                	beqz	a0,4672 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4612:	4551                	li	a0,20
    4614:	00002097          	auipc	ra,0x2
    4618:	0d8080e7          	jalr	216(ra) # 66ec <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    461c:	20200593          	li	a1,514
    4620:	00004517          	auipc	a0,0x4
    4624:	11050513          	addi	a0,a0,272 # 8730 <malloc+0x1c9a>
    4628:	00002097          	auipc	ra,0x2
    462c:	074080e7          	jalr	116(ra) # 669c <open>
    4630:	00002097          	auipc	ra,0x2
    4634:	054080e7          	jalr	84(ra) # 6684 <close>
  wait(0);
    4638:	4501                	li	a0,0
    463a:	00002097          	auipc	ra,0x2
    463e:	02a080e7          	jalr	42(ra) # 6664 <wait>
  sleep(10); // one second
    4642:	4529                	li	a0,10
    4644:	00002097          	auipc	ra,0x2
    4648:	0a8080e7          	jalr	168(ra) # 66ec <sleep>
}
    464c:	60e2                	ld	ra,24(sp)
    464e:	6442                	ld	s0,16(sp)
    4650:	64a2                	ld	s1,8(sp)
    4652:	6105                	addi	sp,sp,32
    4654:	8082                	ret
    printf("%s: fork failed", s);
    4656:	85a6                	mv	a1,s1
    4658:	00003517          	auipc	a0,0x3
    465c:	fb850513          	addi	a0,a0,-72 # 7610 <malloc+0xb7a>
    4660:	00002097          	auipc	ra,0x2
    4664:	37a080e7          	jalr	890(ra) # 69da <printf>
    exit(1);
    4668:	4505                	li	a0,1
    466a:	00002097          	auipc	ra,0x2
    466e:	ff2080e7          	jalr	-14(ra) # 665c <exit>
      int fd = open("stopforking", 0);
    4672:	4581                	li	a1,0
    4674:	00004517          	auipc	a0,0x4
    4678:	0bc50513          	addi	a0,a0,188 # 8730 <malloc+0x1c9a>
    467c:	00002097          	auipc	ra,0x2
    4680:	020080e7          	jalr	32(ra) # 669c <open>
      if(fd >= 0){
    4684:	02055763          	bgez	a0,46b2 <forkforkfork+0xca>
      if(fork() < 0){
    4688:	00002097          	auipc	ra,0x2
    468c:	fcc080e7          	jalr	-52(ra) # 6654 <fork>
    4690:	fe0551e3          	bgez	a0,4672 <forkforkfork+0x8a>
        close(open("stopforking", O_CREATE|O_RDWR));
    4694:	20200593          	li	a1,514
    4698:	00004517          	auipc	a0,0x4
    469c:	09850513          	addi	a0,a0,152 # 8730 <malloc+0x1c9a>
    46a0:	00002097          	auipc	ra,0x2
    46a4:	ffc080e7          	jalr	-4(ra) # 669c <open>
    46a8:	00002097          	auipc	ra,0x2
    46ac:	fdc080e7          	jalr	-36(ra) # 6684 <close>
    46b0:	b7c9                	j	4672 <forkforkfork+0x8a>
        exit(0);
    46b2:	4501                	li	a0,0
    46b4:	00002097          	auipc	ra,0x2
    46b8:	fa8080e7          	jalr	-88(ra) # 665c <exit>

00000000000046bc <killstatus>:
{
    46bc:	715d                	addi	sp,sp,-80
    46be:	e486                	sd	ra,72(sp)
    46c0:	e0a2                	sd	s0,64(sp)
    46c2:	fc26                	sd	s1,56(sp)
    46c4:	f84a                	sd	s2,48(sp)
    46c6:	f44e                	sd	s3,40(sp)
    46c8:	f052                	sd	s4,32(sp)
    46ca:	ec56                	sd	s5,24(sp)
    46cc:	e85a                	sd	s6,16(sp)
    46ce:	0880                	addi	s0,sp,80
    46d0:	8b2a                	mv	s6,a0
    46d2:	06400913          	li	s2,100
    sleep(1);
    46d6:	4a85                	li	s5,1
    wait(&xst);
    46d8:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    46dc:	59fd                	li	s3,-1
    int pid1 = fork();
    46de:	00002097          	auipc	ra,0x2
    46e2:	f76080e7          	jalr	-138(ra) # 6654 <fork>
    46e6:	84aa                	mv	s1,a0
    if(pid1 < 0){
    46e8:	02054e63          	bltz	a0,4724 <killstatus+0x68>
    if(pid1 == 0){
    46ec:	c931                	beqz	a0,4740 <killstatus+0x84>
    sleep(1);
    46ee:	8556                	mv	a0,s5
    46f0:	00002097          	auipc	ra,0x2
    46f4:	ffc080e7          	jalr	-4(ra) # 66ec <sleep>
    kill(pid1);
    46f8:	8526                	mv	a0,s1
    46fa:	00002097          	auipc	ra,0x2
    46fe:	f92080e7          	jalr	-110(ra) # 668c <kill>
    wait(&xst);
    4702:	8552                	mv	a0,s4
    4704:	00002097          	auipc	ra,0x2
    4708:	f60080e7          	jalr	-160(ra) # 6664 <wait>
    if(xst != -1) {
    470c:	fbc42783          	lw	a5,-68(s0)
    4710:	03379d63          	bne	a5,s3,474a <killstatus+0x8e>
  for(int i = 0; i < 100; i++){
    4714:	397d                	addiw	s2,s2,-1
    4716:	fc0914e3          	bnez	s2,46de <killstatus+0x22>
  exit(0);
    471a:	4501                	li	a0,0
    471c:	00002097          	auipc	ra,0x2
    4720:	f40080e7          	jalr	-192(ra) # 665c <exit>
      printf("%s: fork failed\n", s);
    4724:	85da                	mv	a1,s6
    4726:	00003517          	auipc	a0,0x3
    472a:	d2a50513          	addi	a0,a0,-726 # 7450 <malloc+0x9ba>
    472e:	00002097          	auipc	ra,0x2
    4732:	2ac080e7          	jalr	684(ra) # 69da <printf>
      exit(1);
    4736:	4505                	li	a0,1
    4738:	00002097          	auipc	ra,0x2
    473c:	f24080e7          	jalr	-220(ra) # 665c <exit>
        getpid();
    4740:	00002097          	auipc	ra,0x2
    4744:	f9c080e7          	jalr	-100(ra) # 66dc <getpid>
      while(1) {
    4748:	bfe5                	j	4740 <killstatus+0x84>
       printf("%s: status should be -1\n", s);
    474a:	85da                	mv	a1,s6
    474c:	00004517          	auipc	a0,0x4
    4750:	ff450513          	addi	a0,a0,-12 # 8740 <malloc+0x1caa>
    4754:	00002097          	auipc	ra,0x2
    4758:	286080e7          	jalr	646(ra) # 69da <printf>
       exit(1);
    475c:	4505                	li	a0,1
    475e:	00002097          	auipc	ra,0x2
    4762:	efe080e7          	jalr	-258(ra) # 665c <exit>

0000000000004766 <preempt>:
{
    4766:	7139                	addi	sp,sp,-64
    4768:	fc06                	sd	ra,56(sp)
    476a:	f822                	sd	s0,48(sp)
    476c:	f426                	sd	s1,40(sp)
    476e:	f04a                	sd	s2,32(sp)
    4770:	ec4e                	sd	s3,24(sp)
    4772:	e852                	sd	s4,16(sp)
    4774:	0080                	addi	s0,sp,64
    4776:	892a                	mv	s2,a0
  pid1 = fork();
    4778:	00002097          	auipc	ra,0x2
    477c:	edc080e7          	jalr	-292(ra) # 6654 <fork>
  if(pid1 < 0) {
    4780:	00054563          	bltz	a0,478a <preempt+0x24>
    4784:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4786:	e105                	bnez	a0,47a6 <preempt+0x40>
    for(;;)
    4788:	a001                	j	4788 <preempt+0x22>
    printf("%s: fork failed", s);
    478a:	85ca                	mv	a1,s2
    478c:	00003517          	auipc	a0,0x3
    4790:	e8450513          	addi	a0,a0,-380 # 7610 <malloc+0xb7a>
    4794:	00002097          	auipc	ra,0x2
    4798:	246080e7          	jalr	582(ra) # 69da <printf>
    exit(1);
    479c:	4505                	li	a0,1
    479e:	00002097          	auipc	ra,0x2
    47a2:	ebe080e7          	jalr	-322(ra) # 665c <exit>
  pid2 = fork();
    47a6:	00002097          	auipc	ra,0x2
    47aa:	eae080e7          	jalr	-338(ra) # 6654 <fork>
    47ae:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    47b0:	00054463          	bltz	a0,47b8 <preempt+0x52>
  if(pid2 == 0)
    47b4:	e105                	bnez	a0,47d4 <preempt+0x6e>
    for(;;)
    47b6:	a001                	j	47b6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    47b8:	85ca                	mv	a1,s2
    47ba:	00003517          	auipc	a0,0x3
    47be:	c9650513          	addi	a0,a0,-874 # 7450 <malloc+0x9ba>
    47c2:	00002097          	auipc	ra,0x2
    47c6:	218080e7          	jalr	536(ra) # 69da <printf>
    exit(1);
    47ca:	4505                	li	a0,1
    47cc:	00002097          	auipc	ra,0x2
    47d0:	e90080e7          	jalr	-368(ra) # 665c <exit>
  pipe(pfds);
    47d4:	fc840513          	addi	a0,s0,-56
    47d8:	00002097          	auipc	ra,0x2
    47dc:	e94080e7          	jalr	-364(ra) # 666c <pipe>
  pid3 = fork();
    47e0:	00002097          	auipc	ra,0x2
    47e4:	e74080e7          	jalr	-396(ra) # 6654 <fork>
    47e8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    47ea:	02054e63          	bltz	a0,4826 <preempt+0xc0>
  if(pid3 == 0){
    47ee:	e525                	bnez	a0,4856 <preempt+0xf0>
    close(pfds[0]);
    47f0:	fc842503          	lw	a0,-56(s0)
    47f4:	00002097          	auipc	ra,0x2
    47f8:	e90080e7          	jalr	-368(ra) # 6684 <close>
    if(write(pfds[1], "x", 1) != 1)
    47fc:	4605                	li	a2,1
    47fe:	00002597          	auipc	a1,0x2
    4802:	43a58593          	addi	a1,a1,1082 # 6c38 <malloc+0x1a2>
    4806:	fcc42503          	lw	a0,-52(s0)
    480a:	00002097          	auipc	ra,0x2
    480e:	e72080e7          	jalr	-398(ra) # 667c <write>
    4812:	4785                	li	a5,1
    4814:	02f51763          	bne	a0,a5,4842 <preempt+0xdc>
    close(pfds[1]);
    4818:	fcc42503          	lw	a0,-52(s0)
    481c:	00002097          	auipc	ra,0x2
    4820:	e68080e7          	jalr	-408(ra) # 6684 <close>
    for(;;)
    4824:	a001                	j	4824 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4826:	85ca                	mv	a1,s2
    4828:	00003517          	auipc	a0,0x3
    482c:	c2850513          	addi	a0,a0,-984 # 7450 <malloc+0x9ba>
    4830:	00002097          	auipc	ra,0x2
    4834:	1aa080e7          	jalr	426(ra) # 69da <printf>
     exit(1);
    4838:	4505                	li	a0,1
    483a:	00002097          	auipc	ra,0x2
    483e:	e22080e7          	jalr	-478(ra) # 665c <exit>
      printf("%s: preempt write error", s);
    4842:	85ca                	mv	a1,s2
    4844:	00004517          	auipc	a0,0x4
    4848:	f1c50513          	addi	a0,a0,-228 # 8760 <malloc+0x1cca>
    484c:	00002097          	auipc	ra,0x2
    4850:	18e080e7          	jalr	398(ra) # 69da <printf>
    4854:	b7d1                	j	4818 <preempt+0xb2>
  close(pfds[1]);
    4856:	fcc42503          	lw	a0,-52(s0)
    485a:	00002097          	auipc	ra,0x2
    485e:	e2a080e7          	jalr	-470(ra) # 6684 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4862:	660d                	lui	a2,0x3
    4864:	00009597          	auipc	a1,0x9
    4868:	42458593          	addi	a1,a1,1060 # dc88 <buf>
    486c:	fc842503          	lw	a0,-56(s0)
    4870:	00002097          	auipc	ra,0x2
    4874:	e04080e7          	jalr	-508(ra) # 6674 <read>
    4878:	4785                	li	a5,1
    487a:	02f50363          	beq	a0,a5,48a0 <preempt+0x13a>
    printf("%s: preempt read error", s);
    487e:	85ca                	mv	a1,s2
    4880:	00004517          	auipc	a0,0x4
    4884:	ef850513          	addi	a0,a0,-264 # 8778 <malloc+0x1ce2>
    4888:	00002097          	auipc	ra,0x2
    488c:	152080e7          	jalr	338(ra) # 69da <printf>
}
    4890:	70e2                	ld	ra,56(sp)
    4892:	7442                	ld	s0,48(sp)
    4894:	74a2                	ld	s1,40(sp)
    4896:	7902                	ld	s2,32(sp)
    4898:	69e2                	ld	s3,24(sp)
    489a:	6a42                	ld	s4,16(sp)
    489c:	6121                	addi	sp,sp,64
    489e:	8082                	ret
  close(pfds[0]);
    48a0:	fc842503          	lw	a0,-56(s0)
    48a4:	00002097          	auipc	ra,0x2
    48a8:	de0080e7          	jalr	-544(ra) # 6684 <close>
  printf("kill... ");
    48ac:	00004517          	auipc	a0,0x4
    48b0:	ee450513          	addi	a0,a0,-284 # 8790 <malloc+0x1cfa>
    48b4:	00002097          	auipc	ra,0x2
    48b8:	126080e7          	jalr	294(ra) # 69da <printf>
  kill(pid1);
    48bc:	8526                	mv	a0,s1
    48be:	00002097          	auipc	ra,0x2
    48c2:	dce080e7          	jalr	-562(ra) # 668c <kill>
  kill(pid2);
    48c6:	854e                	mv	a0,s3
    48c8:	00002097          	auipc	ra,0x2
    48cc:	dc4080e7          	jalr	-572(ra) # 668c <kill>
  kill(pid3);
    48d0:	8552                	mv	a0,s4
    48d2:	00002097          	auipc	ra,0x2
    48d6:	dba080e7          	jalr	-582(ra) # 668c <kill>
  printf("wait... ");
    48da:	00004517          	auipc	a0,0x4
    48de:	ec650513          	addi	a0,a0,-314 # 87a0 <malloc+0x1d0a>
    48e2:	00002097          	auipc	ra,0x2
    48e6:	0f8080e7          	jalr	248(ra) # 69da <printf>
  wait(0);
    48ea:	4501                	li	a0,0
    48ec:	00002097          	auipc	ra,0x2
    48f0:	d78080e7          	jalr	-648(ra) # 6664 <wait>
  wait(0);
    48f4:	4501                	li	a0,0
    48f6:	00002097          	auipc	ra,0x2
    48fa:	d6e080e7          	jalr	-658(ra) # 6664 <wait>
  wait(0);
    48fe:	4501                	li	a0,0
    4900:	00002097          	auipc	ra,0x2
    4904:	d64080e7          	jalr	-668(ra) # 6664 <wait>
    4908:	b761                	j	4890 <preempt+0x12a>

000000000000490a <reparent>:
{
    490a:	7179                	addi	sp,sp,-48
    490c:	f406                	sd	ra,40(sp)
    490e:	f022                	sd	s0,32(sp)
    4910:	ec26                	sd	s1,24(sp)
    4912:	e84a                	sd	s2,16(sp)
    4914:	e44e                	sd	s3,8(sp)
    4916:	e052                	sd	s4,0(sp)
    4918:	1800                	addi	s0,sp,48
    491a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    491c:	00002097          	auipc	ra,0x2
    4920:	dc0080e7          	jalr	-576(ra) # 66dc <getpid>
    4924:	8a2a                	mv	s4,a0
    4926:	0c800913          	li	s2,200
    int pid = fork();
    492a:	00002097          	auipc	ra,0x2
    492e:	d2a080e7          	jalr	-726(ra) # 6654 <fork>
    4932:	84aa                	mv	s1,a0
    if(pid < 0){
    4934:	02054263          	bltz	a0,4958 <reparent+0x4e>
    if(pid){
    4938:	cd21                	beqz	a0,4990 <reparent+0x86>
      if(wait(0) != pid){
    493a:	4501                	li	a0,0
    493c:	00002097          	auipc	ra,0x2
    4940:	d28080e7          	jalr	-728(ra) # 6664 <wait>
    4944:	02951863          	bne	a0,s1,4974 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4948:	397d                	addiw	s2,s2,-1
    494a:	fe0910e3          	bnez	s2,492a <reparent+0x20>
  exit(0);
    494e:	4501                	li	a0,0
    4950:	00002097          	auipc	ra,0x2
    4954:	d0c080e7          	jalr	-756(ra) # 665c <exit>
      printf("%s: fork failed\n", s);
    4958:	85ce                	mv	a1,s3
    495a:	00003517          	auipc	a0,0x3
    495e:	af650513          	addi	a0,a0,-1290 # 7450 <malloc+0x9ba>
    4962:	00002097          	auipc	ra,0x2
    4966:	078080e7          	jalr	120(ra) # 69da <printf>
      exit(1);
    496a:	4505                	li	a0,1
    496c:	00002097          	auipc	ra,0x2
    4970:	cf0080e7          	jalr	-784(ra) # 665c <exit>
        printf("%s: wait wrong pid\n", s);
    4974:	85ce                	mv	a1,s3
    4976:	00003517          	auipc	a0,0x3
    497a:	c6250513          	addi	a0,a0,-926 # 75d8 <malloc+0xb42>
    497e:	00002097          	auipc	ra,0x2
    4982:	05c080e7          	jalr	92(ra) # 69da <printf>
        exit(1);
    4986:	4505                	li	a0,1
    4988:	00002097          	auipc	ra,0x2
    498c:	cd4080e7          	jalr	-812(ra) # 665c <exit>
      int pid2 = fork();
    4990:	00002097          	auipc	ra,0x2
    4994:	cc4080e7          	jalr	-828(ra) # 6654 <fork>
      if(pid2 < 0){
    4998:	00054763          	bltz	a0,49a6 <reparent+0x9c>
      exit(0);
    499c:	4501                	li	a0,0
    499e:	00002097          	auipc	ra,0x2
    49a2:	cbe080e7          	jalr	-834(ra) # 665c <exit>
        kill(master_pid);
    49a6:	8552                	mv	a0,s4
    49a8:	00002097          	auipc	ra,0x2
    49ac:	ce4080e7          	jalr	-796(ra) # 668c <kill>
        exit(1);
    49b0:	4505                	li	a0,1
    49b2:	00002097          	auipc	ra,0x2
    49b6:	caa080e7          	jalr	-854(ra) # 665c <exit>

00000000000049ba <sbrkfail>:
{
    49ba:	7175                	addi	sp,sp,-144
    49bc:	e506                	sd	ra,136(sp)
    49be:	e122                	sd	s0,128(sp)
    49c0:	fca6                	sd	s1,120(sp)
    49c2:	f8ca                	sd	s2,112(sp)
    49c4:	f4ce                	sd	s3,104(sp)
    49c6:	f0d2                	sd	s4,96(sp)
    49c8:	ecd6                	sd	s5,88(sp)
    49ca:	e8da                	sd	s6,80(sp)
    49cc:	e4de                	sd	s7,72(sp)
    49ce:	0900                	addi	s0,sp,144
    49d0:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
    49d2:	fa040513          	addi	a0,s0,-96
    49d6:	00002097          	auipc	ra,0x2
    49da:	c96080e7          	jalr	-874(ra) # 666c <pipe>
    49de:	e919                	bnez	a0,49f4 <sbrkfail+0x3a>
    49e0:	f7040493          	addi	s1,s0,-144
    49e4:	f9840993          	addi	s3,s0,-104
    49e8:	8926                	mv	s2,s1
    if(pids[i] != -1)
    49ea:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    49ec:	f9f40b13          	addi	s6,s0,-97
    49f0:	4a85                	li	s5,1
    49f2:	a08d                	j	4a54 <sbrkfail+0x9a>
    printf("%s: pipe() failed\n", s);
    49f4:	85de                	mv	a1,s7
    49f6:	00003517          	auipc	a0,0x3
    49fa:	b6250513          	addi	a0,a0,-1182 # 7558 <malloc+0xac2>
    49fe:	00002097          	auipc	ra,0x2
    4a02:	fdc080e7          	jalr	-36(ra) # 69da <printf>
    exit(1);
    4a06:	4505                	li	a0,1
    4a08:	00002097          	auipc	ra,0x2
    4a0c:	c54080e7          	jalr	-940(ra) # 665c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4a10:	00002097          	auipc	ra,0x2
    4a14:	cd4080e7          	jalr	-812(ra) # 66e4 <sbrk>
    4a18:	064007b7          	lui	a5,0x6400
    4a1c:	40a7853b          	subw	a0,a5,a0
    4a20:	00002097          	auipc	ra,0x2
    4a24:	cc4080e7          	jalr	-828(ra) # 66e4 <sbrk>
      write(fds[1], "x", 1);
    4a28:	4605                	li	a2,1
    4a2a:	00002597          	auipc	a1,0x2
    4a2e:	20e58593          	addi	a1,a1,526 # 6c38 <malloc+0x1a2>
    4a32:	fa442503          	lw	a0,-92(s0)
    4a36:	00002097          	auipc	ra,0x2
    4a3a:	c46080e7          	jalr	-954(ra) # 667c <write>
      for(;;) sleep(1000);
    4a3e:	3e800493          	li	s1,1000
    4a42:	8526                	mv	a0,s1
    4a44:	00002097          	auipc	ra,0x2
    4a48:	ca8080e7          	jalr	-856(ra) # 66ec <sleep>
    4a4c:	bfdd                	j	4a42 <sbrkfail+0x88>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4a4e:	0911                	addi	s2,s2,4
    4a50:	03390463          	beq	s2,s3,4a78 <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    4a54:	00002097          	auipc	ra,0x2
    4a58:	c00080e7          	jalr	-1024(ra) # 6654 <fork>
    4a5c:	00a92023          	sw	a0,0(s2)
    4a60:	d945                	beqz	a0,4a10 <sbrkfail+0x56>
    if(pids[i] != -1)
    4a62:	ff4506e3          	beq	a0,s4,4a4e <sbrkfail+0x94>
      read(fds[0], &scratch, 1);
    4a66:	8656                	mv	a2,s5
    4a68:	85da                	mv	a1,s6
    4a6a:	fa042503          	lw	a0,-96(s0)
    4a6e:	00002097          	auipc	ra,0x2
    4a72:	c06080e7          	jalr	-1018(ra) # 6674 <read>
    4a76:	bfe1                	j	4a4e <sbrkfail+0x94>
  c = sbrk(PGSIZE);
    4a78:	6505                	lui	a0,0x1
    4a7a:	00002097          	auipc	ra,0x2
    4a7e:	c6a080e7          	jalr	-918(ra) # 66e4 <sbrk>
    4a82:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4a84:	597d                	li	s2,-1
    4a86:	a021                	j	4a8e <sbrkfail+0xd4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4a88:	0491                	addi	s1,s1,4
    4a8a:	01348f63          	beq	s1,s3,4aa8 <sbrkfail+0xee>
    if(pids[i] == -1)
    4a8e:	4088                	lw	a0,0(s1)
    4a90:	ff250ce3          	beq	a0,s2,4a88 <sbrkfail+0xce>
    kill(pids[i]);
    4a94:	00002097          	auipc	ra,0x2
    4a98:	bf8080e7          	jalr	-1032(ra) # 668c <kill>
    wait(0);
    4a9c:	4501                	li	a0,0
    4a9e:	00002097          	auipc	ra,0x2
    4aa2:	bc6080e7          	jalr	-1082(ra) # 6664 <wait>
    4aa6:	b7cd                	j	4a88 <sbrkfail+0xce>
  if(c == (char*)0xffffffffffffffffL){
    4aa8:	57fd                	li	a5,-1
    4aaa:	04fa0263          	beq	s4,a5,4aee <sbrkfail+0x134>
  pid = fork();
    4aae:	00002097          	auipc	ra,0x2
    4ab2:	ba6080e7          	jalr	-1114(ra) # 6654 <fork>
    4ab6:	84aa                	mv	s1,a0
  if(pid < 0){
    4ab8:	04054963          	bltz	a0,4b0a <sbrkfail+0x150>
  if(pid == 0){
    4abc:	c52d                	beqz	a0,4b26 <sbrkfail+0x16c>
  wait(&xstatus);
    4abe:	fac40513          	addi	a0,s0,-84
    4ac2:	00002097          	auipc	ra,0x2
    4ac6:	ba2080e7          	jalr	-1118(ra) # 6664 <wait>
  if(xstatus != -1 && xstatus != 2)
    4aca:	fac42783          	lw	a5,-84(s0)
    4ace:	00178713          	addi	a4,a5,1 # 6400001 <base+0x63ee879>
    4ad2:	c319                	beqz	a4,4ad8 <sbrkfail+0x11e>
    4ad4:	17f9                	addi	a5,a5,-2
    4ad6:	efd1                	bnez	a5,4b72 <sbrkfail+0x1b8>
}
    4ad8:	60aa                	ld	ra,136(sp)
    4ada:	640a                	ld	s0,128(sp)
    4adc:	74e6                	ld	s1,120(sp)
    4ade:	7946                	ld	s2,112(sp)
    4ae0:	79a6                	ld	s3,104(sp)
    4ae2:	7a06                	ld	s4,96(sp)
    4ae4:	6ae6                	ld	s5,88(sp)
    4ae6:	6b46                	ld	s6,80(sp)
    4ae8:	6ba6                	ld	s7,72(sp)
    4aea:	6149                	addi	sp,sp,144
    4aec:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4aee:	85de                	mv	a1,s7
    4af0:	00004517          	auipc	a0,0x4
    4af4:	cc050513          	addi	a0,a0,-832 # 87b0 <malloc+0x1d1a>
    4af8:	00002097          	auipc	ra,0x2
    4afc:	ee2080e7          	jalr	-286(ra) # 69da <printf>
    exit(1);
    4b00:	4505                	li	a0,1
    4b02:	00002097          	auipc	ra,0x2
    4b06:	b5a080e7          	jalr	-1190(ra) # 665c <exit>
    printf("%s: fork failed\n", s);
    4b0a:	85de                	mv	a1,s7
    4b0c:	00003517          	auipc	a0,0x3
    4b10:	94450513          	addi	a0,a0,-1724 # 7450 <malloc+0x9ba>
    4b14:	00002097          	auipc	ra,0x2
    4b18:	ec6080e7          	jalr	-314(ra) # 69da <printf>
    exit(1);
    4b1c:	4505                	li	a0,1
    4b1e:	00002097          	auipc	ra,0x2
    4b22:	b3e080e7          	jalr	-1218(ra) # 665c <exit>
    a = sbrk(0);
    4b26:	4501                	li	a0,0
    4b28:	00002097          	auipc	ra,0x2
    4b2c:	bbc080e7          	jalr	-1092(ra) # 66e4 <sbrk>
    4b30:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4b32:	3e800537          	lui	a0,0x3e800
    4b36:	00002097          	auipc	ra,0x2
    4b3a:	bae080e7          	jalr	-1106(ra) # 66e4 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4b3e:	87ca                	mv	a5,s2
    4b40:	3e800737          	lui	a4,0x3e800
    4b44:	993a                	add	s2,s2,a4
    4b46:	6705                	lui	a4,0x1
      n += *(a+i);
    4b48:	0007c603          	lbu	a2,0(a5)
    4b4c:	9e25                	addw	a2,a2,s1
    4b4e:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4b50:	97ba                	add	a5,a5,a4
    4b52:	fef91be3          	bne	s2,a5,4b48 <sbrkfail+0x18e>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4b56:	85de                	mv	a1,s7
    4b58:	00004517          	auipc	a0,0x4
    4b5c:	c7850513          	addi	a0,a0,-904 # 87d0 <malloc+0x1d3a>
    4b60:	00002097          	auipc	ra,0x2
    4b64:	e7a080e7          	jalr	-390(ra) # 69da <printf>
    exit(1);
    4b68:	4505                	li	a0,1
    4b6a:	00002097          	auipc	ra,0x2
    4b6e:	af2080e7          	jalr	-1294(ra) # 665c <exit>
    exit(1);
    4b72:	4505                	li	a0,1
    4b74:	00002097          	auipc	ra,0x2
    4b78:	ae8080e7          	jalr	-1304(ra) # 665c <exit>

0000000000004b7c <mem>:
{
    4b7c:	7139                	addi	sp,sp,-64
    4b7e:	fc06                	sd	ra,56(sp)
    4b80:	f822                	sd	s0,48(sp)
    4b82:	f426                	sd	s1,40(sp)
    4b84:	f04a                	sd	s2,32(sp)
    4b86:	ec4e                	sd	s3,24(sp)
    4b88:	0080                	addi	s0,sp,64
    4b8a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4b8c:	00002097          	auipc	ra,0x2
    4b90:	ac8080e7          	jalr	-1336(ra) # 6654 <fork>
    m1 = 0;
    4b94:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4b96:	6909                	lui	s2,0x2
    4b98:	71190913          	addi	s2,s2,1809 # 2711 <manywrites+0x147>
  if((pid = fork()) == 0){
    4b9c:	c115                	beqz	a0,4bc0 <mem+0x44>
    wait(&xstatus);
    4b9e:	fcc40513          	addi	a0,s0,-52
    4ba2:	00002097          	auipc	ra,0x2
    4ba6:	ac2080e7          	jalr	-1342(ra) # 6664 <wait>
    if(xstatus == -1){
    4baa:	fcc42503          	lw	a0,-52(s0)
    4bae:	57fd                	li	a5,-1
    4bb0:	06f50363          	beq	a0,a5,4c16 <mem+0x9a>
    exit(xstatus);
    4bb4:	00002097          	auipc	ra,0x2
    4bb8:	aa8080e7          	jalr	-1368(ra) # 665c <exit>
      *(char**)m2 = m1;
    4bbc:	e104                	sd	s1,0(a0)
      m1 = m2;
    4bbe:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4bc0:	854a                	mv	a0,s2
    4bc2:	00002097          	auipc	ra,0x2
    4bc6:	ed4080e7          	jalr	-300(ra) # 6a96 <malloc>
    4bca:	f96d                	bnez	a0,4bbc <mem+0x40>
    while(m1){
    4bcc:	c881                	beqz	s1,4bdc <mem+0x60>
      m2 = *(char**)m1;
    4bce:	8526                	mv	a0,s1
    4bd0:	6084                	ld	s1,0(s1)
      free(m1);
    4bd2:	00002097          	auipc	ra,0x2
    4bd6:	e3e080e7          	jalr	-450(ra) # 6a10 <free>
    while(m1){
    4bda:	f8f5                	bnez	s1,4bce <mem+0x52>
    m1 = malloc(1024*20);
    4bdc:	6515                	lui	a0,0x5
    4bde:	00002097          	auipc	ra,0x2
    4be2:	eb8080e7          	jalr	-328(ra) # 6a96 <malloc>
    if(m1 == 0){
    4be6:	c911                	beqz	a0,4bfa <mem+0x7e>
    free(m1);
    4be8:	00002097          	auipc	ra,0x2
    4bec:	e28080e7          	jalr	-472(ra) # 6a10 <free>
    exit(0);
    4bf0:	4501                	li	a0,0
    4bf2:	00002097          	auipc	ra,0x2
    4bf6:	a6a080e7          	jalr	-1430(ra) # 665c <exit>
      printf("couldn't allocate mem?!!\n", s);
    4bfa:	85ce                	mv	a1,s3
    4bfc:	00004517          	auipc	a0,0x4
    4c00:	c0450513          	addi	a0,a0,-1020 # 8800 <malloc+0x1d6a>
    4c04:	00002097          	auipc	ra,0x2
    4c08:	dd6080e7          	jalr	-554(ra) # 69da <printf>
      exit(1);
    4c0c:	4505                	li	a0,1
    4c0e:	00002097          	auipc	ra,0x2
    4c12:	a4e080e7          	jalr	-1458(ra) # 665c <exit>
      exit(0);
    4c16:	4501                	li	a0,0
    4c18:	00002097          	auipc	ra,0x2
    4c1c:	a44080e7          	jalr	-1468(ra) # 665c <exit>

0000000000004c20 <sharedfd>:
{
    4c20:	7159                	addi	sp,sp,-112
    4c22:	f486                	sd	ra,104(sp)
    4c24:	f0a2                	sd	s0,96(sp)
    4c26:	eca6                	sd	s1,88(sp)
    4c28:	f85a                	sd	s6,48(sp)
    4c2a:	1880                	addi	s0,sp,112
    4c2c:	84aa                	mv	s1,a0
    4c2e:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    4c30:	00004517          	auipc	a0,0x4
    4c34:	bf050513          	addi	a0,a0,-1040 # 8820 <malloc+0x1d8a>
    4c38:	00002097          	auipc	ra,0x2
    4c3c:	a74080e7          	jalr	-1420(ra) # 66ac <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4c40:	20200593          	li	a1,514
    4c44:	00004517          	auipc	a0,0x4
    4c48:	bdc50513          	addi	a0,a0,-1060 # 8820 <malloc+0x1d8a>
    4c4c:	00002097          	auipc	ra,0x2
    4c50:	a50080e7          	jalr	-1456(ra) # 669c <open>
  if(fd < 0){
    4c54:	06054063          	bltz	a0,4cb4 <sharedfd+0x94>
    4c58:	e8ca                	sd	s2,80(sp)
    4c5a:	e4ce                	sd	s3,72(sp)
    4c5c:	e0d2                	sd	s4,64(sp)
    4c5e:	fc56                	sd	s5,56(sp)
    4c60:	89aa                	mv	s3,a0
  pid = fork();
    4c62:	00002097          	auipc	ra,0x2
    4c66:	9f2080e7          	jalr	-1550(ra) # 6654 <fork>
    4c6a:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4c6c:	07000593          	li	a1,112
    4c70:	e119                	bnez	a0,4c76 <sharedfd+0x56>
    4c72:	06300593          	li	a1,99
    4c76:	4629                	li	a2,10
    4c78:	fa040513          	addi	a0,s0,-96
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	7ce080e7          	jalr	1998(ra) # 644a <memset>
    4c84:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4c88:	fa040a13          	addi	s4,s0,-96
    4c8c:	4929                	li	s2,10
    4c8e:	864a                	mv	a2,s2
    4c90:	85d2                	mv	a1,s4
    4c92:	854e                	mv	a0,s3
    4c94:	00002097          	auipc	ra,0x2
    4c98:	9e8080e7          	jalr	-1560(ra) # 667c <write>
    4c9c:	03251f63          	bne	a0,s2,4cda <sharedfd+0xba>
  for(i = 0; i < N; i++){
    4ca0:	34fd                	addiw	s1,s1,-1
    4ca2:	f4f5                	bnez	s1,4c8e <sharedfd+0x6e>
  if(pid == 0) {
    4ca4:	040a9a63          	bnez	s5,4cf8 <sharedfd+0xd8>
    4ca8:	f45e                	sd	s7,40(sp)
    exit(0);
    4caa:	4501                	li	a0,0
    4cac:	00002097          	auipc	ra,0x2
    4cb0:	9b0080e7          	jalr	-1616(ra) # 665c <exit>
    4cb4:	e8ca                	sd	s2,80(sp)
    4cb6:	e4ce                	sd	s3,72(sp)
    4cb8:	e0d2                	sd	s4,64(sp)
    4cba:	fc56                	sd	s5,56(sp)
    4cbc:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4cbe:	85a6                	mv	a1,s1
    4cc0:	00004517          	auipc	a0,0x4
    4cc4:	b7050513          	addi	a0,a0,-1168 # 8830 <malloc+0x1d9a>
    4cc8:	00002097          	auipc	ra,0x2
    4ccc:	d12080e7          	jalr	-750(ra) # 69da <printf>
    exit(1);
    4cd0:	4505                	li	a0,1
    4cd2:	00002097          	auipc	ra,0x2
    4cd6:	98a080e7          	jalr	-1654(ra) # 665c <exit>
    4cda:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    4cdc:	85da                	mv	a1,s6
    4cde:	00004517          	auipc	a0,0x4
    4ce2:	b7a50513          	addi	a0,a0,-1158 # 8858 <malloc+0x1dc2>
    4ce6:	00002097          	auipc	ra,0x2
    4cea:	cf4080e7          	jalr	-780(ra) # 69da <printf>
      exit(1);
    4cee:	4505                	li	a0,1
    4cf0:	00002097          	auipc	ra,0x2
    4cf4:	96c080e7          	jalr	-1684(ra) # 665c <exit>
    wait(&xstatus);
    4cf8:	f9c40513          	addi	a0,s0,-100
    4cfc:	00002097          	auipc	ra,0x2
    4d00:	968080e7          	jalr	-1688(ra) # 6664 <wait>
    if(xstatus != 0)
    4d04:	f9c42a03          	lw	s4,-100(s0)
    4d08:	000a0863          	beqz	s4,4d18 <sharedfd+0xf8>
    4d0c:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    4d0e:	8552                	mv	a0,s4
    4d10:	00002097          	auipc	ra,0x2
    4d14:	94c080e7          	jalr	-1716(ra) # 665c <exit>
    4d18:	f45e                	sd	s7,40(sp)
  close(fd);
    4d1a:	854e                	mv	a0,s3
    4d1c:	00002097          	auipc	ra,0x2
    4d20:	968080e7          	jalr	-1688(ra) # 6684 <close>
  fd = open("sharedfd", 0);
    4d24:	4581                	li	a1,0
    4d26:	00004517          	auipc	a0,0x4
    4d2a:	afa50513          	addi	a0,a0,-1286 # 8820 <malloc+0x1d8a>
    4d2e:	00002097          	auipc	ra,0x2
    4d32:	96e080e7          	jalr	-1682(ra) # 669c <open>
    4d36:	8baa                	mv	s7,a0
  nc = np = 0;
    4d38:	89d2                	mv	s3,s4
  if(fd < 0){
    4d3a:	02054563          	bltz	a0,4d64 <sharedfd+0x144>
    4d3e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4d42:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4d46:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4d4a:	4629                	li	a2,10
    4d4c:	fa040593          	addi	a1,s0,-96
    4d50:	855e                	mv	a0,s7
    4d52:	00002097          	auipc	ra,0x2
    4d56:	922080e7          	jalr	-1758(ra) # 6674 <read>
    4d5a:	02a05f63          	blez	a0,4d98 <sharedfd+0x178>
    4d5e:	fa040793          	addi	a5,s0,-96
    4d62:	a01d                	j	4d88 <sharedfd+0x168>
    printf("%s: cannot open sharedfd for reading\n", s);
    4d64:	85da                	mv	a1,s6
    4d66:	00004517          	auipc	a0,0x4
    4d6a:	b1250513          	addi	a0,a0,-1262 # 8878 <malloc+0x1de2>
    4d6e:	00002097          	auipc	ra,0x2
    4d72:	c6c080e7          	jalr	-916(ra) # 69da <printf>
    exit(1);
    4d76:	4505                	li	a0,1
    4d78:	00002097          	auipc	ra,0x2
    4d7c:	8e4080e7          	jalr	-1820(ra) # 665c <exit>
        nc++;
    4d80:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    4d82:	0785                	addi	a5,a5,1
    4d84:	fd2783e3          	beq	a5,s2,4d4a <sharedfd+0x12a>
      if(buf[i] == 'c')
    4d88:	0007c703          	lbu	a4,0(a5)
    4d8c:	fe970ae3          	beq	a4,s1,4d80 <sharedfd+0x160>
      if(buf[i] == 'p')
    4d90:	ff5719e3          	bne	a4,s5,4d82 <sharedfd+0x162>
        np++;
    4d94:	2985                	addiw	s3,s3,1
    4d96:	b7f5                	j	4d82 <sharedfd+0x162>
  close(fd);
    4d98:	855e                	mv	a0,s7
    4d9a:	00002097          	auipc	ra,0x2
    4d9e:	8ea080e7          	jalr	-1814(ra) # 6684 <close>
  unlink("sharedfd");
    4da2:	00004517          	auipc	a0,0x4
    4da6:	a7e50513          	addi	a0,a0,-1410 # 8820 <malloc+0x1d8a>
    4daa:	00002097          	auipc	ra,0x2
    4dae:	902080e7          	jalr	-1790(ra) # 66ac <unlink>
  if(nc == N*SZ && np == N*SZ){
    4db2:	6789                	lui	a5,0x2
    4db4:	71078793          	addi	a5,a5,1808 # 2710 <manywrites+0x146>
    4db8:	00fa1963          	bne	s4,a5,4dca <sharedfd+0x1aa>
    4dbc:	01499763          	bne	s3,s4,4dca <sharedfd+0x1aa>
    exit(0);
    4dc0:	4501                	li	a0,0
    4dc2:	00002097          	auipc	ra,0x2
    4dc6:	89a080e7          	jalr	-1894(ra) # 665c <exit>
    printf("%s: nc/np test fails\n", s);
    4dca:	85da                	mv	a1,s6
    4dcc:	00004517          	auipc	a0,0x4
    4dd0:	ad450513          	addi	a0,a0,-1324 # 88a0 <malloc+0x1e0a>
    4dd4:	00002097          	auipc	ra,0x2
    4dd8:	c06080e7          	jalr	-1018(ra) # 69da <printf>
    exit(1);
    4ddc:	4505                	li	a0,1
    4dde:	00002097          	auipc	ra,0x2
    4de2:	87e080e7          	jalr	-1922(ra) # 665c <exit>

0000000000004de6 <fourfiles>:
{
    4de6:	7135                	addi	sp,sp,-160
    4de8:	ed06                	sd	ra,152(sp)
    4dea:	e922                	sd	s0,144(sp)
    4dec:	e526                	sd	s1,136(sp)
    4dee:	e14a                	sd	s2,128(sp)
    4df0:	fcce                	sd	s3,120(sp)
    4df2:	f8d2                	sd	s4,112(sp)
    4df4:	f4d6                	sd	s5,104(sp)
    4df6:	f0da                	sd	s6,96(sp)
    4df8:	ecde                	sd	s7,88(sp)
    4dfa:	e8e2                	sd	s8,80(sp)
    4dfc:	e4e6                	sd	s9,72(sp)
    4dfe:	e0ea                	sd	s10,64(sp)
    4e00:	fc6e                	sd	s11,56(sp)
    4e02:	1100                	addi	s0,sp,160
    4e04:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4e06:	00004797          	auipc	a5,0x4
    4e0a:	ab278793          	addi	a5,a5,-1358 # 88b8 <malloc+0x1e22>
    4e0e:	f6f43823          	sd	a5,-144(s0)
    4e12:	00004797          	auipc	a5,0x4
    4e16:	aae78793          	addi	a5,a5,-1362 # 88c0 <malloc+0x1e2a>
    4e1a:	f6f43c23          	sd	a5,-136(s0)
    4e1e:	00004797          	auipc	a5,0x4
    4e22:	aaa78793          	addi	a5,a5,-1366 # 88c8 <malloc+0x1e32>
    4e26:	f8f43023          	sd	a5,-128(s0)
    4e2a:	00004797          	auipc	a5,0x4
    4e2e:	aa678793          	addi	a5,a5,-1370 # 88d0 <malloc+0x1e3a>
    4e32:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4e36:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4e3a:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4e3c:	4481                	li	s1,0
    4e3e:	4a11                	li	s4,4
    fname = names[pi];
    4e40:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4e44:	854e                	mv	a0,s3
    4e46:	00002097          	auipc	ra,0x2
    4e4a:	866080e7          	jalr	-1946(ra) # 66ac <unlink>
    pid = fork();
    4e4e:	00002097          	auipc	ra,0x2
    4e52:	806080e7          	jalr	-2042(ra) # 6654 <fork>
    if(pid < 0){
    4e56:	04054263          	bltz	a0,4e9a <fourfiles+0xb4>
    if(pid == 0){
    4e5a:	cd31                	beqz	a0,4eb6 <fourfiles+0xd0>
  for(pi = 0; pi < NCHILD; pi++){
    4e5c:	2485                	addiw	s1,s1,1
    4e5e:	0921                	addi	s2,s2,8
    4e60:	ff4490e3          	bne	s1,s4,4e40 <fourfiles+0x5a>
    4e64:	4491                	li	s1,4
    wait(&xstatus);
    4e66:	f6c40913          	addi	s2,s0,-148
    4e6a:	854a                	mv	a0,s2
    4e6c:	00001097          	auipc	ra,0x1
    4e70:	7f8080e7          	jalr	2040(ra) # 6664 <wait>
    if(xstatus != 0)
    4e74:	f6c42b03          	lw	s6,-148(s0)
    4e78:	0c0b1863          	bnez	s6,4f48 <fourfiles+0x162>
  for(pi = 0; pi < NCHILD; pi++){
    4e7c:	34fd                	addiw	s1,s1,-1
    4e7e:	f4f5                	bnez	s1,4e6a <fourfiles+0x84>
    4e80:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e84:	6a8d                	lui	s5,0x3
    4e86:	00009a17          	auipc	s4,0x9
    4e8a:	e02a0a13          	addi	s4,s4,-510 # dc88 <buf>
    if(total != N*SZ){
    4e8e:	6d05                	lui	s10,0x1
    4e90:	770d0d13          	addi	s10,s10,1904 # 1770 <truncate3+0x17e>
  for(i = 0; i < NCHILD; i++){
    4e94:	03400d93          	li	s11,52
    4e98:	a8dd                	j	4f8e <fourfiles+0x1a8>
      printf("fork failed\n", s);
    4e9a:	85e6                	mv	a1,s9
    4e9c:	00003517          	auipc	a0,0x3
    4ea0:	9bc50513          	addi	a0,a0,-1604 # 7858 <malloc+0xdc2>
    4ea4:	00002097          	auipc	ra,0x2
    4ea8:	b36080e7          	jalr	-1226(ra) # 69da <printf>
      exit(1);
    4eac:	4505                	li	a0,1
    4eae:	00001097          	auipc	ra,0x1
    4eb2:	7ae080e7          	jalr	1966(ra) # 665c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4eb6:	20200593          	li	a1,514
    4eba:	854e                	mv	a0,s3
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	7e0080e7          	jalr	2016(ra) # 669c <open>
    4ec4:	892a                	mv	s2,a0
      if(fd < 0){
    4ec6:	04054663          	bltz	a0,4f12 <fourfiles+0x12c>
      memset(buf, '0'+pi, SZ);
    4eca:	1f400613          	li	a2,500
    4ece:	0304859b          	addiw	a1,s1,48
    4ed2:	00009517          	auipc	a0,0x9
    4ed6:	db650513          	addi	a0,a0,-586 # dc88 <buf>
    4eda:	00001097          	auipc	ra,0x1
    4ede:	570080e7          	jalr	1392(ra) # 644a <memset>
    4ee2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4ee4:	1f400993          	li	s3,500
    4ee8:	00009a17          	auipc	s4,0x9
    4eec:	da0a0a13          	addi	s4,s4,-608 # dc88 <buf>
    4ef0:	864e                	mv	a2,s3
    4ef2:	85d2                	mv	a1,s4
    4ef4:	854a                	mv	a0,s2
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	786080e7          	jalr	1926(ra) # 667c <write>
    4efe:	85aa                	mv	a1,a0
    4f00:	03351763          	bne	a0,s3,4f2e <fourfiles+0x148>
      for(i = 0; i < N; i++){
    4f04:	34fd                	addiw	s1,s1,-1
    4f06:	f4ed                	bnez	s1,4ef0 <fourfiles+0x10a>
      exit(0);
    4f08:	4501                	li	a0,0
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	752080e7          	jalr	1874(ra) # 665c <exit>
        printf("create failed\n", s);
    4f12:	85e6                	mv	a1,s9
    4f14:	00004517          	auipc	a0,0x4
    4f18:	9c450513          	addi	a0,a0,-1596 # 88d8 <malloc+0x1e42>
    4f1c:	00002097          	auipc	ra,0x2
    4f20:	abe080e7          	jalr	-1346(ra) # 69da <printf>
        exit(1);
    4f24:	4505                	li	a0,1
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	736080e7          	jalr	1846(ra) # 665c <exit>
          printf("write failed %d\n", n);
    4f2e:	00004517          	auipc	a0,0x4
    4f32:	9ba50513          	addi	a0,a0,-1606 # 88e8 <malloc+0x1e52>
    4f36:	00002097          	auipc	ra,0x2
    4f3a:	aa4080e7          	jalr	-1372(ra) # 69da <printf>
          exit(1);
    4f3e:	4505                	li	a0,1
    4f40:	00001097          	auipc	ra,0x1
    4f44:	71c080e7          	jalr	1820(ra) # 665c <exit>
      exit(xstatus);
    4f48:	855a                	mv	a0,s6
    4f4a:	00001097          	auipc	ra,0x1
    4f4e:	712080e7          	jalr	1810(ra) # 665c <exit>
          printf("wrong char\n", s);
    4f52:	85e6                	mv	a1,s9
    4f54:	00004517          	auipc	a0,0x4
    4f58:	9ac50513          	addi	a0,a0,-1620 # 8900 <malloc+0x1e6a>
    4f5c:	00002097          	auipc	ra,0x2
    4f60:	a7e080e7          	jalr	-1410(ra) # 69da <printf>
          exit(1);
    4f64:	4505                	li	a0,1
    4f66:	00001097          	auipc	ra,0x1
    4f6a:	6f6080e7          	jalr	1782(ra) # 665c <exit>
    close(fd);
    4f6e:	854e                	mv	a0,s3
    4f70:	00001097          	auipc	ra,0x1
    4f74:	714080e7          	jalr	1812(ra) # 6684 <close>
    if(total != N*SZ){
    4f78:	05a91e63          	bne	s2,s10,4fd4 <fourfiles+0x1ee>
    unlink(fname);
    4f7c:	8562                	mv	a0,s8
    4f7e:	00001097          	auipc	ra,0x1
    4f82:	72e080e7          	jalr	1838(ra) # 66ac <unlink>
  for(i = 0; i < NCHILD; i++){
    4f86:	0ba1                	addi	s7,s7,8
    4f88:	2485                	addiw	s1,s1,1
    4f8a:	07b48363          	beq	s1,s11,4ff0 <fourfiles+0x20a>
    fname = names[i];
    4f8e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4f92:	4581                	li	a1,0
    4f94:	8562                	mv	a0,s8
    4f96:	00001097          	auipc	ra,0x1
    4f9a:	706080e7          	jalr	1798(ra) # 669c <open>
    4f9e:	89aa                	mv	s3,a0
    total = 0;
    4fa0:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4fa2:	8656                	mv	a2,s5
    4fa4:	85d2                	mv	a1,s4
    4fa6:	854e                	mv	a0,s3
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	6cc080e7          	jalr	1740(ra) # 6674 <read>
    4fb0:	faa05fe3          	blez	a0,4f6e <fourfiles+0x188>
    4fb4:	00009797          	auipc	a5,0x9
    4fb8:	cd478793          	addi	a5,a5,-812 # dc88 <buf>
    4fbc:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4fc0:	0007c703          	lbu	a4,0(a5)
    4fc4:	f89717e3          	bne	a4,s1,4f52 <fourfiles+0x16c>
      for(j = 0; j < n; j++){
    4fc8:	0785                	addi	a5,a5,1
    4fca:	fed79be3          	bne	a5,a3,4fc0 <fourfiles+0x1da>
      total += n;
    4fce:	00a9093b          	addw	s2,s2,a0
    4fd2:	bfc1                	j	4fa2 <fourfiles+0x1bc>
      printf("wrong length %d\n", total);
    4fd4:	85ca                	mv	a1,s2
    4fd6:	00004517          	auipc	a0,0x4
    4fda:	93a50513          	addi	a0,a0,-1734 # 8910 <malloc+0x1e7a>
    4fde:	00002097          	auipc	ra,0x2
    4fe2:	9fc080e7          	jalr	-1540(ra) # 69da <printf>
      exit(1);
    4fe6:	4505                	li	a0,1
    4fe8:	00001097          	auipc	ra,0x1
    4fec:	674080e7          	jalr	1652(ra) # 665c <exit>
}
    4ff0:	60ea                	ld	ra,152(sp)
    4ff2:	644a                	ld	s0,144(sp)
    4ff4:	64aa                	ld	s1,136(sp)
    4ff6:	690a                	ld	s2,128(sp)
    4ff8:	79e6                	ld	s3,120(sp)
    4ffa:	7a46                	ld	s4,112(sp)
    4ffc:	7aa6                	ld	s5,104(sp)
    4ffe:	7b06                	ld	s6,96(sp)
    5000:	6be6                	ld	s7,88(sp)
    5002:	6c46                	ld	s8,80(sp)
    5004:	6ca6                	ld	s9,72(sp)
    5006:	6d06                	ld	s10,64(sp)
    5008:	7de2                	ld	s11,56(sp)
    500a:	610d                	addi	sp,sp,160
    500c:	8082                	ret

000000000000500e <concreate>:
{
    500e:	7171                	addi	sp,sp,-176
    5010:	f506                	sd	ra,168(sp)
    5012:	f122                	sd	s0,160(sp)
    5014:	ed26                	sd	s1,152(sp)
    5016:	e94a                	sd	s2,144(sp)
    5018:	e54e                	sd	s3,136(sp)
    501a:	e152                	sd	s4,128(sp)
    501c:	fcd6                	sd	s5,120(sp)
    501e:	f8da                	sd	s6,112(sp)
    5020:	f4de                	sd	s7,104(sp)
    5022:	f0e2                	sd	s8,96(sp)
    5024:	ece6                	sd	s9,88(sp)
    5026:	e8ea                	sd	s10,80(sp)
    5028:	1900                	addi	s0,sp,176
    502a:	8d2a                	mv	s10,a0
  file[0] = 'C';
    502c:	04300793          	li	a5,67
    5030:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    5034:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    5038:	4901                	li	s2,0
    unlink(file);
    503a:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    503e:	55555b37          	lui	s6,0x55555
    5042:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x55543dce>
    5046:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    5048:	20200c13          	li	s8,514
      link("C0", file);
    504c:	00004c97          	auipc	s9,0x4
    5050:	8dcc8c93          	addi	s9,s9,-1828 # 8928 <malloc+0x1e92>
      wait(&xstatus);
    5054:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    5058:	02800a13          	li	s4,40
    505c:	a4d5                	j	5340 <concreate+0x332>
      link("C0", file);
    505e:	85ce                	mv	a1,s3
    5060:	8566                	mv	a0,s9
    5062:	00001097          	auipc	ra,0x1
    5066:	65a080e7          	jalr	1626(ra) # 66bc <link>
    if(pid == 0) {
    506a:	ac7d                	j	5328 <concreate+0x31a>
    } else if(pid == 0 && (i % 5) == 1){
    506c:	666667b7          	lui	a5,0x66666
    5070:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x66654edf>
    5074:	02f907b3          	mul	a5,s2,a5
    5078:	9785                	srai	a5,a5,0x21
    507a:	41f9571b          	sraiw	a4,s2,0x1f
    507e:	9f99                	subw	a5,a5,a4
    5080:	0027971b          	slliw	a4,a5,0x2
    5084:	9fb9                	addw	a5,a5,a4
    5086:	40f9093b          	subw	s2,s2,a5
    508a:	4785                	li	a5,1
    508c:	02f90b63          	beq	s2,a5,50c2 <concreate+0xb4>
      fd = open(file, O_CREATE | O_RDWR);
    5090:	20200593          	li	a1,514
    5094:	f9840513          	addi	a0,s0,-104
    5098:	00001097          	auipc	ra,0x1
    509c:	604080e7          	jalr	1540(ra) # 669c <open>
      if(fd < 0){
    50a0:	26055b63          	bgez	a0,5316 <concreate+0x308>
        printf("concreate create %s failed\n", file);
    50a4:	f9840593          	addi	a1,s0,-104
    50a8:	00004517          	auipc	a0,0x4
    50ac:	88850513          	addi	a0,a0,-1912 # 8930 <malloc+0x1e9a>
    50b0:	00002097          	auipc	ra,0x2
    50b4:	92a080e7          	jalr	-1750(ra) # 69da <printf>
        exit(1);
    50b8:	4505                	li	a0,1
    50ba:	00001097          	auipc	ra,0x1
    50be:	5a2080e7          	jalr	1442(ra) # 665c <exit>
      link("C0", file);
    50c2:	f9840593          	addi	a1,s0,-104
    50c6:	00004517          	auipc	a0,0x4
    50ca:	86250513          	addi	a0,a0,-1950 # 8928 <malloc+0x1e92>
    50ce:	00001097          	auipc	ra,0x1
    50d2:	5ee080e7          	jalr	1518(ra) # 66bc <link>
      exit(0);
    50d6:	4501                	li	a0,0
    50d8:	00001097          	auipc	ra,0x1
    50dc:	584080e7          	jalr	1412(ra) # 665c <exit>
        exit(1);
    50e0:	4505                	li	a0,1
    50e2:	00001097          	auipc	ra,0x1
    50e6:	57a080e7          	jalr	1402(ra) # 665c <exit>
  memset(fa, 0, sizeof(fa));
    50ea:	02800613          	li	a2,40
    50ee:	4581                	li	a1,0
    50f0:	f7040513          	addi	a0,s0,-144
    50f4:	00001097          	auipc	ra,0x1
    50f8:	356080e7          	jalr	854(ra) # 644a <memset>
  fd = open(".", 0);
    50fc:	4581                	li	a1,0
    50fe:	00002517          	auipc	a0,0x2
    5102:	1b250513          	addi	a0,a0,434 # 72b0 <malloc+0x81a>
    5106:	00001097          	auipc	ra,0x1
    510a:	596080e7          	jalr	1430(ra) # 669c <open>
    510e:	892a                	mv	s2,a0
  n = 0;
    5110:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    5112:	f6040a13          	addi	s4,s0,-160
    5116:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5118:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    511c:	02700b93          	li	s7,39
      fa[i] = 1;
    5120:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    5122:	864e                	mv	a2,s3
    5124:	85d2                	mv	a1,s4
    5126:	854a                	mv	a0,s2
    5128:	00001097          	auipc	ra,0x1
    512c:	54c080e7          	jalr	1356(ra) # 6674 <read>
    5130:	06a05f63          	blez	a0,51ae <concreate+0x1a0>
    if(de.inum == 0)
    5134:	f6045783          	lhu	a5,-160(s0)
    5138:	d7ed                	beqz	a5,5122 <concreate+0x114>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    513a:	f6244783          	lbu	a5,-158(s0)
    513e:	ff5792e3          	bne	a5,s5,5122 <concreate+0x114>
    5142:	f6444783          	lbu	a5,-156(s0)
    5146:	fff1                	bnez	a5,5122 <concreate+0x114>
      i = de.name[1] - '0';
    5148:	f6344783          	lbu	a5,-157(s0)
    514c:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    5150:	00fbef63          	bltu	s7,a5,516e <concreate+0x160>
      if(fa[i]){
    5154:	fa078713          	addi	a4,a5,-96
    5158:	9722                	add	a4,a4,s0
    515a:	fd074703          	lbu	a4,-48(a4) # fd0 <linktest+0x7c>
    515e:	eb05                	bnez	a4,518e <concreate+0x180>
      fa[i] = 1;
    5160:	fa078793          	addi	a5,a5,-96
    5164:	97a2                	add	a5,a5,s0
    5166:	fd878823          	sb	s8,-48(a5)
      n++;
    516a:	2b05                	addiw	s6,s6,1
    516c:	bf5d                	j	5122 <concreate+0x114>
        printf("%s: concreate weird file %s\n", s, de.name);
    516e:	f6240613          	addi	a2,s0,-158
    5172:	85ea                	mv	a1,s10
    5174:	00003517          	auipc	a0,0x3
    5178:	7dc50513          	addi	a0,a0,2012 # 8950 <malloc+0x1eba>
    517c:	00002097          	auipc	ra,0x2
    5180:	85e080e7          	jalr	-1954(ra) # 69da <printf>
        exit(1);
    5184:	4505                	li	a0,1
    5186:	00001097          	auipc	ra,0x1
    518a:	4d6080e7          	jalr	1238(ra) # 665c <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    518e:	f6240613          	addi	a2,s0,-158
    5192:	85ea                	mv	a1,s10
    5194:	00003517          	auipc	a0,0x3
    5198:	7dc50513          	addi	a0,a0,2012 # 8970 <malloc+0x1eda>
    519c:	00002097          	auipc	ra,0x2
    51a0:	83e080e7          	jalr	-1986(ra) # 69da <printf>
        exit(1);
    51a4:	4505                	li	a0,1
    51a6:	00001097          	auipc	ra,0x1
    51aa:	4b6080e7          	jalr	1206(ra) # 665c <exit>
  close(fd);
    51ae:	854a                	mv	a0,s2
    51b0:	00001097          	auipc	ra,0x1
    51b4:	4d4080e7          	jalr	1236(ra) # 6684 <close>
  if(n != N){
    51b8:	02800793          	li	a5,40
    51bc:	00fb1a63          	bne	s6,a5,51d0 <concreate+0x1c2>
    if(((i % 3) == 0 && pid == 0) ||
    51c0:	55555a37          	lui	s4,0x55555
    51c4:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x55543dce>
      close(open(file, 0));
    51c8:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    51cc:	8ada                	mv	s5,s6
    51ce:	a0d9                	j	5294 <concreate+0x286>
    printf("%s: concreate not enough files in directory listing\n", s);
    51d0:	85ea                	mv	a1,s10
    51d2:	00003517          	auipc	a0,0x3
    51d6:	7c650513          	addi	a0,a0,1990 # 8998 <malloc+0x1f02>
    51da:	00002097          	auipc	ra,0x2
    51de:	800080e7          	jalr	-2048(ra) # 69da <printf>
    exit(1);
    51e2:	4505                	li	a0,1
    51e4:	00001097          	auipc	ra,0x1
    51e8:	478080e7          	jalr	1144(ra) # 665c <exit>
      printf("%s: fork failed\n", s);
    51ec:	85ea                	mv	a1,s10
    51ee:	00002517          	auipc	a0,0x2
    51f2:	26250513          	addi	a0,a0,610 # 7450 <malloc+0x9ba>
    51f6:	00001097          	auipc	ra,0x1
    51fa:	7e4080e7          	jalr	2020(ra) # 69da <printf>
      exit(1);
    51fe:	4505                	li	a0,1
    5200:	00001097          	auipc	ra,0x1
    5204:	45c080e7          	jalr	1116(ra) # 665c <exit>
      close(open(file, 0));
    5208:	4581                	li	a1,0
    520a:	854e                	mv	a0,s3
    520c:	00001097          	auipc	ra,0x1
    5210:	490080e7          	jalr	1168(ra) # 669c <open>
    5214:	00001097          	auipc	ra,0x1
    5218:	470080e7          	jalr	1136(ra) # 6684 <close>
      close(open(file, 0));
    521c:	4581                	li	a1,0
    521e:	854e                	mv	a0,s3
    5220:	00001097          	auipc	ra,0x1
    5224:	47c080e7          	jalr	1148(ra) # 669c <open>
    5228:	00001097          	auipc	ra,0x1
    522c:	45c080e7          	jalr	1116(ra) # 6684 <close>
      close(open(file, 0));
    5230:	4581                	li	a1,0
    5232:	854e                	mv	a0,s3
    5234:	00001097          	auipc	ra,0x1
    5238:	468080e7          	jalr	1128(ra) # 669c <open>
    523c:	00001097          	auipc	ra,0x1
    5240:	448080e7          	jalr	1096(ra) # 6684 <close>
      close(open(file, 0));
    5244:	4581                	li	a1,0
    5246:	854e                	mv	a0,s3
    5248:	00001097          	auipc	ra,0x1
    524c:	454080e7          	jalr	1108(ra) # 669c <open>
    5250:	00001097          	auipc	ra,0x1
    5254:	434080e7          	jalr	1076(ra) # 6684 <close>
      close(open(file, 0));
    5258:	4581                	li	a1,0
    525a:	854e                	mv	a0,s3
    525c:	00001097          	auipc	ra,0x1
    5260:	440080e7          	jalr	1088(ra) # 669c <open>
    5264:	00001097          	auipc	ra,0x1
    5268:	420080e7          	jalr	1056(ra) # 6684 <close>
      close(open(file, 0));
    526c:	4581                	li	a1,0
    526e:	854e                	mv	a0,s3
    5270:	00001097          	auipc	ra,0x1
    5274:	42c080e7          	jalr	1068(ra) # 669c <open>
    5278:	00001097          	auipc	ra,0x1
    527c:	40c080e7          	jalr	1036(ra) # 6684 <close>
    if(pid == 0)
    5280:	08090663          	beqz	s2,530c <concreate+0x2fe>
      wait(0);
    5284:	4501                	li	a0,0
    5286:	00001097          	auipc	ra,0x1
    528a:	3de080e7          	jalr	990(ra) # 6664 <wait>
  for(i = 0; i < N; i++){
    528e:	2485                	addiw	s1,s1,1
    5290:	0f548d63          	beq	s1,s5,538a <concreate+0x37c>
    file[1] = '0' + i;
    5294:	0304879b          	addiw	a5,s1,48
    5298:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    529c:	00001097          	auipc	ra,0x1
    52a0:	3b8080e7          	jalr	952(ra) # 6654 <fork>
    52a4:	892a                	mv	s2,a0
    if(pid < 0){
    52a6:	f40543e3          	bltz	a0,51ec <concreate+0x1de>
    if(((i % 3) == 0 && pid == 0) ||
    52aa:	03448733          	mul	a4,s1,s4
    52ae:	9301                	srli	a4,a4,0x20
    52b0:	41f4d79b          	sraiw	a5,s1,0x1f
    52b4:	9f1d                	subw	a4,a4,a5
    52b6:	0017179b          	slliw	a5,a4,0x1
    52ba:	9fb9                	addw	a5,a5,a4
    52bc:	40f487bb          	subw	a5,s1,a5
    52c0:	00a7e733          	or	a4,a5,a0
    52c4:	2701                	sext.w	a4,a4
    52c6:	d329                	beqz	a4,5208 <concreate+0x1fa>
       ((i % 3) == 1 && pid != 0)){
    52c8:	c119                	beqz	a0,52ce <concreate+0x2c0>
    if(((i % 3) == 0 && pid == 0) ||
    52ca:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    52cc:	df95                	beqz	a5,5208 <concreate+0x1fa>
      unlink(file);
    52ce:	854e                	mv	a0,s3
    52d0:	00001097          	auipc	ra,0x1
    52d4:	3dc080e7          	jalr	988(ra) # 66ac <unlink>
      unlink(file);
    52d8:	854e                	mv	a0,s3
    52da:	00001097          	auipc	ra,0x1
    52de:	3d2080e7          	jalr	978(ra) # 66ac <unlink>
      unlink(file);
    52e2:	854e                	mv	a0,s3
    52e4:	00001097          	auipc	ra,0x1
    52e8:	3c8080e7          	jalr	968(ra) # 66ac <unlink>
      unlink(file);
    52ec:	854e                	mv	a0,s3
    52ee:	00001097          	auipc	ra,0x1
    52f2:	3be080e7          	jalr	958(ra) # 66ac <unlink>
      unlink(file);
    52f6:	854e                	mv	a0,s3
    52f8:	00001097          	auipc	ra,0x1
    52fc:	3b4080e7          	jalr	948(ra) # 66ac <unlink>
      unlink(file);
    5300:	854e                	mv	a0,s3
    5302:	00001097          	auipc	ra,0x1
    5306:	3aa080e7          	jalr	938(ra) # 66ac <unlink>
    530a:	bf9d                	j	5280 <concreate+0x272>
      exit(0);
    530c:	4501                	li	a0,0
    530e:	00001097          	auipc	ra,0x1
    5312:	34e080e7          	jalr	846(ra) # 665c <exit>
      close(fd);
    5316:	00001097          	auipc	ra,0x1
    531a:	36e080e7          	jalr	878(ra) # 6684 <close>
    if(pid == 0) {
    531e:	bb65                	j	50d6 <concreate+0xc8>
      close(fd);
    5320:	00001097          	auipc	ra,0x1
    5324:	364080e7          	jalr	868(ra) # 6684 <close>
      wait(&xstatus);
    5328:	8556                	mv	a0,s5
    532a:	00001097          	auipc	ra,0x1
    532e:	33a080e7          	jalr	826(ra) # 6664 <wait>
      if(xstatus != 0)
    5332:	f5c42483          	lw	s1,-164(s0)
    5336:	da0495e3          	bnez	s1,50e0 <concreate+0xd2>
  for(i = 0; i < N; i++){
    533a:	2905                	addiw	s2,s2,1
    533c:	db4907e3          	beq	s2,s4,50ea <concreate+0xdc>
    file[1] = '0' + i;
    5340:	0309079b          	addiw	a5,s2,48
    5344:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    5348:	854e                	mv	a0,s3
    534a:	00001097          	auipc	ra,0x1
    534e:	362080e7          	jalr	866(ra) # 66ac <unlink>
    pid = fork();
    5352:	00001097          	auipc	ra,0x1
    5356:	302080e7          	jalr	770(ra) # 6654 <fork>
    if(pid && (i % 3) == 1){
    535a:	d00509e3          	beqz	a0,506c <concreate+0x5e>
    535e:	036907b3          	mul	a5,s2,s6
    5362:	9381                	srli	a5,a5,0x20
    5364:	41f9571b          	sraiw	a4,s2,0x1f
    5368:	9f99                	subw	a5,a5,a4
    536a:	0017971b          	slliw	a4,a5,0x1
    536e:	9fb9                	addw	a5,a5,a4
    5370:	40f907bb          	subw	a5,s2,a5
    5374:	cf7785e3          	beq	a5,s7,505e <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    5378:	85e2                	mv	a1,s8
    537a:	854e                	mv	a0,s3
    537c:	00001097          	auipc	ra,0x1
    5380:	320080e7          	jalr	800(ra) # 669c <open>
      if(fd < 0){
    5384:	f8055ee3          	bgez	a0,5320 <concreate+0x312>
    5388:	bb31                	j	50a4 <concreate+0x96>
}
    538a:	70aa                	ld	ra,168(sp)
    538c:	740a                	ld	s0,160(sp)
    538e:	64ea                	ld	s1,152(sp)
    5390:	694a                	ld	s2,144(sp)
    5392:	69aa                	ld	s3,136(sp)
    5394:	6a0a                	ld	s4,128(sp)
    5396:	7ae6                	ld	s5,120(sp)
    5398:	7b46                	ld	s6,112(sp)
    539a:	7ba6                	ld	s7,104(sp)
    539c:	7c06                	ld	s8,96(sp)
    539e:	6ce6                	ld	s9,88(sp)
    53a0:	6d46                	ld	s10,80(sp)
    53a2:	614d                	addi	sp,sp,176
    53a4:	8082                	ret

00000000000053a6 <bigfile>:
{
    53a6:	7139                	addi	sp,sp,-64
    53a8:	fc06                	sd	ra,56(sp)
    53aa:	f822                	sd	s0,48(sp)
    53ac:	f426                	sd	s1,40(sp)
    53ae:	f04a                	sd	s2,32(sp)
    53b0:	ec4e                	sd	s3,24(sp)
    53b2:	e852                	sd	s4,16(sp)
    53b4:	e456                	sd	s5,8(sp)
    53b6:	e05a                	sd	s6,0(sp)
    53b8:	0080                	addi	s0,sp,64
    53ba:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	61450513          	addi	a0,a0,1556 # 89d0 <malloc+0x1f3a>
    53c4:	00001097          	auipc	ra,0x1
    53c8:	2e8080e7          	jalr	744(ra) # 66ac <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    53cc:	20200593          	li	a1,514
    53d0:	00003517          	auipc	a0,0x3
    53d4:	60050513          	addi	a0,a0,1536 # 89d0 <malloc+0x1f3a>
    53d8:	00001097          	auipc	ra,0x1
    53dc:	2c4080e7          	jalr	708(ra) # 669c <open>
  if(fd < 0){
    53e0:	0a054463          	bltz	a0,5488 <bigfile+0xe2>
    53e4:	8a2a                	mv	s4,a0
    53e6:	4481                	li	s1,0
    memset(buf, i, SZ);
    53e8:	25800913          	li	s2,600
    53ec:	00009997          	auipc	s3,0x9
    53f0:	89c98993          	addi	s3,s3,-1892 # dc88 <buf>
  for(i = 0; i < N; i++){
    53f4:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    53f6:	864a                	mv	a2,s2
    53f8:	85a6                	mv	a1,s1
    53fa:	854e                	mv	a0,s3
    53fc:	00001097          	auipc	ra,0x1
    5400:	04e080e7          	jalr	78(ra) # 644a <memset>
    if(write(fd, buf, SZ) != SZ){
    5404:	864a                	mv	a2,s2
    5406:	85ce                	mv	a1,s3
    5408:	8552                	mv	a0,s4
    540a:	00001097          	auipc	ra,0x1
    540e:	272080e7          	jalr	626(ra) # 667c <write>
    5412:	09251963          	bne	a0,s2,54a4 <bigfile+0xfe>
  for(i = 0; i < N; i++){
    5416:	2485                	addiw	s1,s1,1
    5418:	fd549fe3          	bne	s1,s5,53f6 <bigfile+0x50>
  close(fd);
    541c:	8552                	mv	a0,s4
    541e:	00001097          	auipc	ra,0x1
    5422:	266080e7          	jalr	614(ra) # 6684 <close>
  fd = open("bigfile.dat", 0);
    5426:	4581                	li	a1,0
    5428:	00003517          	auipc	a0,0x3
    542c:	5a850513          	addi	a0,a0,1448 # 89d0 <malloc+0x1f3a>
    5430:	00001097          	auipc	ra,0x1
    5434:	26c080e7          	jalr	620(ra) # 669c <open>
    5438:	8aaa                	mv	s5,a0
  total = 0;
    543a:	4a01                	li	s4,0
  for(i = 0; ; i++){
    543c:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    543e:	12c00993          	li	s3,300
    5442:	00009917          	auipc	s2,0x9
    5446:	84690913          	addi	s2,s2,-1978 # dc88 <buf>
  if(fd < 0){
    544a:	06054b63          	bltz	a0,54c0 <bigfile+0x11a>
    cc = read(fd, buf, SZ/2);
    544e:	864e                	mv	a2,s3
    5450:	85ca                	mv	a1,s2
    5452:	8556                	mv	a0,s5
    5454:	00001097          	auipc	ra,0x1
    5458:	220080e7          	jalr	544(ra) # 6674 <read>
    if(cc < 0){
    545c:	08054063          	bltz	a0,54dc <bigfile+0x136>
    if(cc == 0)
    5460:	c961                	beqz	a0,5530 <bigfile+0x18a>
    if(cc != SZ/2){
    5462:	09351b63          	bne	a0,s3,54f8 <bigfile+0x152>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5466:	01f4d79b          	srliw	a5,s1,0x1f
    546a:	9fa5                	addw	a5,a5,s1
    546c:	4017d79b          	sraiw	a5,a5,0x1
    5470:	00094703          	lbu	a4,0(s2)
    5474:	0af71063          	bne	a4,a5,5514 <bigfile+0x16e>
    5478:	12b94703          	lbu	a4,299(s2)
    547c:	08f71c63          	bne	a4,a5,5514 <bigfile+0x16e>
    total += cc;
    5480:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    5484:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5486:	b7e1                	j	544e <bigfile+0xa8>
    printf("%s: cannot create bigfile", s);
    5488:	85da                	mv	a1,s6
    548a:	00003517          	auipc	a0,0x3
    548e:	55650513          	addi	a0,a0,1366 # 89e0 <malloc+0x1f4a>
    5492:	00001097          	auipc	ra,0x1
    5496:	548080e7          	jalr	1352(ra) # 69da <printf>
    exit(1);
    549a:	4505                	li	a0,1
    549c:	00001097          	auipc	ra,0x1
    54a0:	1c0080e7          	jalr	448(ra) # 665c <exit>
      printf("%s: write bigfile failed\n", s);
    54a4:	85da                	mv	a1,s6
    54a6:	00003517          	auipc	a0,0x3
    54aa:	55a50513          	addi	a0,a0,1370 # 8a00 <malloc+0x1f6a>
    54ae:	00001097          	auipc	ra,0x1
    54b2:	52c080e7          	jalr	1324(ra) # 69da <printf>
      exit(1);
    54b6:	4505                	li	a0,1
    54b8:	00001097          	auipc	ra,0x1
    54bc:	1a4080e7          	jalr	420(ra) # 665c <exit>
    printf("%s: cannot open bigfile\n", s);
    54c0:	85da                	mv	a1,s6
    54c2:	00003517          	auipc	a0,0x3
    54c6:	55e50513          	addi	a0,a0,1374 # 8a20 <malloc+0x1f8a>
    54ca:	00001097          	auipc	ra,0x1
    54ce:	510080e7          	jalr	1296(ra) # 69da <printf>
    exit(1);
    54d2:	4505                	li	a0,1
    54d4:	00001097          	auipc	ra,0x1
    54d8:	188080e7          	jalr	392(ra) # 665c <exit>
      printf("%s: read bigfile failed\n", s);
    54dc:	85da                	mv	a1,s6
    54de:	00003517          	auipc	a0,0x3
    54e2:	56250513          	addi	a0,a0,1378 # 8a40 <malloc+0x1faa>
    54e6:	00001097          	auipc	ra,0x1
    54ea:	4f4080e7          	jalr	1268(ra) # 69da <printf>
      exit(1);
    54ee:	4505                	li	a0,1
    54f0:	00001097          	auipc	ra,0x1
    54f4:	16c080e7          	jalr	364(ra) # 665c <exit>
      printf("%s: short read bigfile\n", s);
    54f8:	85da                	mv	a1,s6
    54fa:	00003517          	auipc	a0,0x3
    54fe:	56650513          	addi	a0,a0,1382 # 8a60 <malloc+0x1fca>
    5502:	00001097          	auipc	ra,0x1
    5506:	4d8080e7          	jalr	1240(ra) # 69da <printf>
      exit(1);
    550a:	4505                	li	a0,1
    550c:	00001097          	auipc	ra,0x1
    5510:	150080e7          	jalr	336(ra) # 665c <exit>
      printf("%s: read bigfile wrong data\n", s);
    5514:	85da                	mv	a1,s6
    5516:	00003517          	auipc	a0,0x3
    551a:	56250513          	addi	a0,a0,1378 # 8a78 <malloc+0x1fe2>
    551e:	00001097          	auipc	ra,0x1
    5522:	4bc080e7          	jalr	1212(ra) # 69da <printf>
      exit(1);
    5526:	4505                	li	a0,1
    5528:	00001097          	auipc	ra,0x1
    552c:	134080e7          	jalr	308(ra) # 665c <exit>
  close(fd);
    5530:	8556                	mv	a0,s5
    5532:	00001097          	auipc	ra,0x1
    5536:	152080e7          	jalr	338(ra) # 6684 <close>
  if(total != N*SZ){
    553a:	678d                	lui	a5,0x3
    553c:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbugs+0x3c>
    5540:	02fa1463          	bne	s4,a5,5568 <bigfile+0x1c2>
  unlink("bigfile.dat");
    5544:	00003517          	auipc	a0,0x3
    5548:	48c50513          	addi	a0,a0,1164 # 89d0 <malloc+0x1f3a>
    554c:	00001097          	auipc	ra,0x1
    5550:	160080e7          	jalr	352(ra) # 66ac <unlink>
}
    5554:	70e2                	ld	ra,56(sp)
    5556:	7442                	ld	s0,48(sp)
    5558:	74a2                	ld	s1,40(sp)
    555a:	7902                	ld	s2,32(sp)
    555c:	69e2                	ld	s3,24(sp)
    555e:	6a42                	ld	s4,16(sp)
    5560:	6aa2                	ld	s5,8(sp)
    5562:	6b02                	ld	s6,0(sp)
    5564:	6121                	addi	sp,sp,64
    5566:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5568:	85da                	mv	a1,s6
    556a:	00003517          	auipc	a0,0x3
    556e:	52e50513          	addi	a0,a0,1326 # 8a98 <malloc+0x2002>
    5572:	00001097          	auipc	ra,0x1
    5576:	468080e7          	jalr	1128(ra) # 69da <printf>
    exit(1);
    557a:	4505                	li	a0,1
    557c:	00001097          	auipc	ra,0x1
    5580:	0e0080e7          	jalr	224(ra) # 665c <exit>

0000000000005584 <fsfull>:
{
    5584:	7171                	addi	sp,sp,-176
    5586:	f506                	sd	ra,168(sp)
    5588:	f122                	sd	s0,160(sp)
    558a:	ed26                	sd	s1,152(sp)
    558c:	e94a                	sd	s2,144(sp)
    558e:	e54e                	sd	s3,136(sp)
    5590:	e152                	sd	s4,128(sp)
    5592:	fcd6                	sd	s5,120(sp)
    5594:	f8da                	sd	s6,112(sp)
    5596:	f4de                	sd	s7,104(sp)
    5598:	f0e2                	sd	s8,96(sp)
    559a:	ece6                	sd	s9,88(sp)
    559c:	e8ea                	sd	s10,80(sp)
    559e:	e4ee                	sd	s11,72(sp)
    55a0:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    55a2:	00003517          	auipc	a0,0x3
    55a6:	51650513          	addi	a0,a0,1302 # 8ab8 <malloc+0x2022>
    55aa:	00001097          	auipc	ra,0x1
    55ae:	430080e7          	jalr	1072(ra) # 69da <printf>
  for(nfiles = 0; ; nfiles++){
    55b2:	4481                	li	s1,0
    name[0] = 'f';
    55b4:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    55b8:	10625cb7          	lui	s9,0x10625
    55bc:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061364b>
    name[2] = '0' + (nfiles % 1000) / 100;
    55c0:	51eb8ab7          	lui	s5,0x51eb8
    55c4:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea6d97>
    name[3] = '0' + (nfiles % 100) / 10;
    55c8:	66666a37          	lui	s4,0x66666
    55cc:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x66654edf>
    printf("writing %s\n", name);
    55d0:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    55d4:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    55d8:	039487b3          	mul	a5,s1,s9
    55dc:	9799                	srai	a5,a5,0x26
    55de:	41f4d69b          	sraiw	a3,s1,0x1f
    55e2:	9f95                	subw	a5,a5,a3
    55e4:	0307871b          	addiw	a4,a5,48
    55e8:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    55ec:	3e800713          	li	a4,1000
    55f0:	02f707bb          	mulw	a5,a4,a5
    55f4:	40f487bb          	subw	a5,s1,a5
    55f8:	03578733          	mul	a4,a5,s5
    55fc:	9715                	srai	a4,a4,0x25
    55fe:	41f7d79b          	sraiw	a5,a5,0x1f
    5602:	40f707bb          	subw	a5,a4,a5
    5606:	0307879b          	addiw	a5,a5,48
    560a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    560e:	035487b3          	mul	a5,s1,s5
    5612:	9795                	srai	a5,a5,0x25
    5614:	9f95                	subw	a5,a5,a3
    5616:	06400713          	li	a4,100
    561a:	02f707bb          	mulw	a5,a4,a5
    561e:	40f487bb          	subw	a5,s1,a5
    5622:	03478733          	mul	a4,a5,s4
    5626:	9709                	srai	a4,a4,0x22
    5628:	41f7d79b          	sraiw	a5,a5,0x1f
    562c:	40f707bb          	subw	a5,a4,a5
    5630:	0307879b          	addiw	a5,a5,48
    5634:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5638:	03448733          	mul	a4,s1,s4
    563c:	9709                	srai	a4,a4,0x22
    563e:	9f15                	subw	a4,a4,a3
    5640:	0027179b          	slliw	a5,a4,0x2
    5644:	9fb9                	addw	a5,a5,a4
    5646:	0017979b          	slliw	a5,a5,0x1
    564a:	40f487bb          	subw	a5,s1,a5
    564e:	0307879b          	addiw	a5,a5,48
    5652:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5656:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    565a:	85ea                	mv	a1,s10
    565c:	00003517          	auipc	a0,0x3
    5660:	46c50513          	addi	a0,a0,1132 # 8ac8 <malloc+0x2032>
    5664:	00001097          	auipc	ra,0x1
    5668:	376080e7          	jalr	886(ra) # 69da <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    566c:	20200593          	li	a1,514
    5670:	856a                	mv	a0,s10
    5672:	00001097          	auipc	ra,0x1
    5676:	02a080e7          	jalr	42(ra) # 669c <open>
    567a:	892a                	mv	s2,a0
    if(fd < 0){
    567c:	10055163          	bgez	a0,577e <fsfull+0x1fa>
      printf("open %s failed\n", name);
    5680:	f5040593          	addi	a1,s0,-176
    5684:	00003517          	auipc	a0,0x3
    5688:	45450513          	addi	a0,a0,1108 # 8ad8 <malloc+0x2042>
    568c:	00001097          	auipc	ra,0x1
    5690:	34e080e7          	jalr	846(ra) # 69da <printf>
  while(nfiles >= 0){
    5694:	0a04ce63          	bltz	s1,5750 <fsfull+0x1cc>
    name[0] = 'f';
    5698:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    569c:	10625a37          	lui	s4,0x10625
    56a0:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061364b>
    name[2] = '0' + (nfiles % 1000) / 100;
    56a4:	3e800b93          	li	s7,1000
    56a8:	51eb89b7          	lui	s3,0x51eb8
    56ac:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea6d97>
    name[3] = '0' + (nfiles % 100) / 10;
    56b0:	06400b13          	li	s6,100
    56b4:	66666937          	lui	s2,0x66666
    56b8:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x66654edf>
    unlink(name);
    56bc:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    56c0:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    56c4:	034487b3          	mul	a5,s1,s4
    56c8:	9799                	srai	a5,a5,0x26
    56ca:	41f4d69b          	sraiw	a3,s1,0x1f
    56ce:	9f95                	subw	a5,a5,a3
    56d0:	0307871b          	addiw	a4,a5,48
    56d4:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    56d8:	02fb87bb          	mulw	a5,s7,a5
    56dc:	40f487bb          	subw	a5,s1,a5
    56e0:	03378733          	mul	a4,a5,s3
    56e4:	9715                	srai	a4,a4,0x25
    56e6:	41f7d79b          	sraiw	a5,a5,0x1f
    56ea:	40f707bb          	subw	a5,a4,a5
    56ee:	0307879b          	addiw	a5,a5,48
    56f2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    56f6:	033487b3          	mul	a5,s1,s3
    56fa:	9795                	srai	a5,a5,0x25
    56fc:	9f95                	subw	a5,a5,a3
    56fe:	02fb07bb          	mulw	a5,s6,a5
    5702:	40f487bb          	subw	a5,s1,a5
    5706:	03278733          	mul	a4,a5,s2
    570a:	9709                	srai	a4,a4,0x22
    570c:	41f7d79b          	sraiw	a5,a5,0x1f
    5710:	40f707bb          	subw	a5,a4,a5
    5714:	0307879b          	addiw	a5,a5,48
    5718:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    571c:	03248733          	mul	a4,s1,s2
    5720:	9709                	srai	a4,a4,0x22
    5722:	9f15                	subw	a4,a4,a3
    5724:	0027179b          	slliw	a5,a4,0x2
    5728:	9fb9                	addw	a5,a5,a4
    572a:	0017979b          	slliw	a5,a5,0x1
    572e:	40f487bb          	subw	a5,s1,a5
    5732:	0307879b          	addiw	a5,a5,48
    5736:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    573a:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    573e:	8556                	mv	a0,s5
    5740:	00001097          	auipc	ra,0x1
    5744:	f6c080e7          	jalr	-148(ra) # 66ac <unlink>
    nfiles--;
    5748:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    574a:	57fd                	li	a5,-1
    574c:	f6f49ae3          	bne	s1,a5,56c0 <fsfull+0x13c>
  printf("fsfull test finished\n");
    5750:	00003517          	auipc	a0,0x3
    5754:	3a850513          	addi	a0,a0,936 # 8af8 <malloc+0x2062>
    5758:	00001097          	auipc	ra,0x1
    575c:	282080e7          	jalr	642(ra) # 69da <printf>
}
    5760:	70aa                	ld	ra,168(sp)
    5762:	740a                	ld	s0,160(sp)
    5764:	64ea                	ld	s1,152(sp)
    5766:	694a                	ld	s2,144(sp)
    5768:	69aa                	ld	s3,136(sp)
    576a:	6a0a                	ld	s4,128(sp)
    576c:	7ae6                	ld	s5,120(sp)
    576e:	7b46                	ld	s6,112(sp)
    5770:	7ba6                	ld	s7,104(sp)
    5772:	7c06                	ld	s8,96(sp)
    5774:	6ce6                	ld	s9,88(sp)
    5776:	6d46                	ld	s10,80(sp)
    5778:	6da6                	ld	s11,72(sp)
    577a:	614d                	addi	sp,sp,176
    577c:	8082                	ret
    int total = 0;
    577e:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    5780:	40000c13          	li	s8,1024
    5784:	00008b97          	auipc	s7,0x8
    5788:	504b8b93          	addi	s7,s7,1284 # dc88 <buf>
      if(cc < BSIZE)
    578c:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    5790:	8662                	mv	a2,s8
    5792:	85de                	mv	a1,s7
    5794:	854a                	mv	a0,s2
    5796:	00001097          	auipc	ra,0x1
    579a:	ee6080e7          	jalr	-282(ra) # 667c <write>
      if(cc < BSIZE)
    579e:	00ab5563          	bge	s6,a0,57a8 <fsfull+0x224>
      total += cc;
    57a2:	00a989bb          	addw	s3,s3,a0
    while(1){
    57a6:	b7ed                	j	5790 <fsfull+0x20c>
    printf("wrote %d bytes\n", total);
    57a8:	85ce                	mv	a1,s3
    57aa:	00003517          	auipc	a0,0x3
    57ae:	33e50513          	addi	a0,a0,830 # 8ae8 <malloc+0x2052>
    57b2:	00001097          	auipc	ra,0x1
    57b6:	228080e7          	jalr	552(ra) # 69da <printf>
    close(fd);
    57ba:	854a                	mv	a0,s2
    57bc:	00001097          	auipc	ra,0x1
    57c0:	ec8080e7          	jalr	-312(ra) # 6684 <close>
    if(total == 0)
    57c4:	ec0988e3          	beqz	s3,5694 <fsfull+0x110>
  for(nfiles = 0; ; nfiles++){
    57c8:	2485                	addiw	s1,s1,1
    57ca:	b529                	j	55d4 <fsfull+0x50>

00000000000057cc <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    57cc:	7179                	addi	sp,sp,-48
    57ce:	f406                	sd	ra,40(sp)
    57d0:	f022                	sd	s0,32(sp)
    57d2:	ec26                	sd	s1,24(sp)
    57d4:	e84a                	sd	s2,16(sp)
    57d6:	1800                	addi	s0,sp,48
    57d8:	84aa                	mv	s1,a0
    57da:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    57dc:	00003517          	auipc	a0,0x3
    57e0:	33450513          	addi	a0,a0,820 # 8b10 <malloc+0x207a>
    57e4:	00001097          	auipc	ra,0x1
    57e8:	1f6080e7          	jalr	502(ra) # 69da <printf>
  if((pid = fork()) < 0) {
    57ec:	00001097          	auipc	ra,0x1
    57f0:	e68080e7          	jalr	-408(ra) # 6654 <fork>
    57f4:	02054e63          	bltz	a0,5830 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    57f8:	c929                	beqz	a0,584a <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    57fa:	fdc40513          	addi	a0,s0,-36
    57fe:	00001097          	auipc	ra,0x1
    5802:	e66080e7          	jalr	-410(ra) # 6664 <wait>
    if(xstatus != 0) 
    5806:	fdc42783          	lw	a5,-36(s0)
    580a:	c7b9                	beqz	a5,5858 <run+0x8c>
      printf("FAILED\n");
    580c:	00003517          	auipc	a0,0x3
    5810:	32c50513          	addi	a0,a0,812 # 8b38 <malloc+0x20a2>
    5814:	00001097          	auipc	ra,0x1
    5818:	1c6080e7          	jalr	454(ra) # 69da <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    581c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5820:	00153513          	seqz	a0,a0
    5824:	70a2                	ld	ra,40(sp)
    5826:	7402                	ld	s0,32(sp)
    5828:	64e2                	ld	s1,24(sp)
    582a:	6942                	ld	s2,16(sp)
    582c:	6145                	addi	sp,sp,48
    582e:	8082                	ret
    printf("runtest: fork error\n");
    5830:	00003517          	auipc	a0,0x3
    5834:	2f050513          	addi	a0,a0,752 # 8b20 <malloc+0x208a>
    5838:	00001097          	auipc	ra,0x1
    583c:	1a2080e7          	jalr	418(ra) # 69da <printf>
    exit(1);
    5840:	4505                	li	a0,1
    5842:	00001097          	auipc	ra,0x1
    5846:	e1a080e7          	jalr	-486(ra) # 665c <exit>
    f(s);
    584a:	854a                	mv	a0,s2
    584c:	9482                	jalr	s1
    exit(0);
    584e:	4501                	li	a0,0
    5850:	00001097          	auipc	ra,0x1
    5854:	e0c080e7          	jalr	-500(ra) # 665c <exit>
      printf("OK\n");
    5858:	00003517          	auipc	a0,0x3
    585c:	2e850513          	addi	a0,a0,744 # 8b40 <malloc+0x20aa>
    5860:	00001097          	auipc	ra,0x1
    5864:	17a080e7          	jalr	378(ra) # 69da <printf>
    5868:	bf55                	j	581c <run+0x50>

000000000000586a <runtests>:

int
runtests(struct test *tests, char *justone) {
    586a:	1101                	addi	sp,sp,-32
    586c:	ec06                	sd	ra,24(sp)
    586e:	e822                	sd	s0,16(sp)
    5870:	e426                	sd	s1,8(sp)
    5872:	e04a                	sd	s2,0(sp)
    5874:	1000                	addi	s0,sp,32
    5876:	84aa                	mv	s1,a0
    5878:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    587a:	6508                	ld	a0,8(a0)
    587c:	ed01                	bnez	a0,5894 <runtests+0x2a>
    587e:	a82d                	j	58b8 <runtests+0x4e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
    5880:	648c                	ld	a1,8(s1)
    5882:	6088                	ld	a0,0(s1)
    5884:	00000097          	auipc	ra,0x0
    5888:	f48080e7          	jalr	-184(ra) # 57cc <run>
    588c:	cd09                	beqz	a0,58a6 <runtests+0x3c>
  for (struct test *t = tests; t->s != 0; t++) {
    588e:	04c1                	addi	s1,s1,16
    5890:	6488                	ld	a0,8(s1)
    5892:	c11d                	beqz	a0,58b8 <runtests+0x4e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5894:	fe0906e3          	beqz	s2,5880 <runtests+0x16>
    5898:	85ca                	mv	a1,s2
    589a:	00001097          	auipc	ra,0x1
    589e:	b54080e7          	jalr	-1196(ra) # 63ee <strcmp>
    58a2:	f575                	bnez	a0,588e <runtests+0x24>
    58a4:	bff1                	j	5880 <runtests+0x16>
        printf("SOME TESTS FAILED\n");
    58a6:	00003517          	auipc	a0,0x3
    58aa:	2a250513          	addi	a0,a0,674 # 8b48 <malloc+0x20b2>
    58ae:	00001097          	auipc	ra,0x1
    58b2:	12c080e7          	jalr	300(ra) # 69da <printf>
        return 1;
    58b6:	4505                	li	a0,1
      }
    }
  }
  return 0;
}
    58b8:	60e2                	ld	ra,24(sp)
    58ba:	6442                	ld	s0,16(sp)
    58bc:	64a2                	ld	s1,8(sp)
    58be:	6902                	ld	s2,0(sp)
    58c0:	6105                	addi	sp,sp,32
    58c2:	8082                	ret

00000000000058c4 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    58c4:	7139                	addi	sp,sp,-64
    58c6:	fc06                	sd	ra,56(sp)
    58c8:	f822                	sd	s0,48(sp)
    58ca:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    58cc:	fc840513          	addi	a0,s0,-56
    58d0:	00001097          	auipc	ra,0x1
    58d4:	d9c080e7          	jalr	-612(ra) # 666c <pipe>
    58d8:	06054b63          	bltz	a0,594e <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    58dc:	00001097          	auipc	ra,0x1
    58e0:	d78080e7          	jalr	-648(ra) # 6654 <fork>

  if(pid < 0){
    58e4:	08054663          	bltz	a0,5970 <countfree+0xac>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    58e8:	e955                	bnez	a0,599c <countfree+0xd8>
    58ea:	f426                	sd	s1,40(sp)
    58ec:	f04a                	sd	s2,32(sp)
    58ee:	ec4e                	sd	s3,24(sp)
    58f0:	e852                	sd	s4,16(sp)
    close(fds[0]);
    58f2:	fc842503          	lw	a0,-56(s0)
    58f6:	00001097          	auipc	ra,0x1
    58fa:	d8e080e7          	jalr	-626(ra) # 6684 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    58fe:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    5900:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5902:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5904:	00001a17          	auipc	s4,0x1
    5908:	334a0a13          	addi	s4,s4,820 # 6c38 <malloc+0x1a2>
      uint64 a = (uint64) sbrk(4096);
    590c:	854a                	mv	a0,s2
    590e:	00001097          	auipc	ra,0x1
    5912:	dd6080e7          	jalr	-554(ra) # 66e4 <sbrk>
      if(a == 0xffffffffffffffff){
    5916:	07350e63          	beq	a0,s3,5992 <countfree+0xce>
      *(char *)(a + 4096 - 1) = 1;
    591a:	954a                	add	a0,a0,s2
    591c:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    5920:	8626                	mv	a2,s1
    5922:	85d2                	mv	a1,s4
    5924:	fcc42503          	lw	a0,-52(s0)
    5928:	00001097          	auipc	ra,0x1
    592c:	d54080e7          	jalr	-684(ra) # 667c <write>
    5930:	fc950ee3          	beq	a0,s1,590c <countfree+0x48>
        printf("write() failed in countfree()\n");
    5934:	00003517          	auipc	a0,0x3
    5938:	26c50513          	addi	a0,a0,620 # 8ba0 <malloc+0x210a>
    593c:	00001097          	auipc	ra,0x1
    5940:	09e080e7          	jalr	158(ra) # 69da <printf>
        exit(1);
    5944:	4505                	li	a0,1
    5946:	00001097          	auipc	ra,0x1
    594a:	d16080e7          	jalr	-746(ra) # 665c <exit>
    594e:	f426                	sd	s1,40(sp)
    5950:	f04a                	sd	s2,32(sp)
    5952:	ec4e                	sd	s3,24(sp)
    5954:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    5956:	00003517          	auipc	a0,0x3
    595a:	20a50513          	addi	a0,a0,522 # 8b60 <malloc+0x20ca>
    595e:	00001097          	auipc	ra,0x1
    5962:	07c080e7          	jalr	124(ra) # 69da <printf>
    exit(1);
    5966:	4505                	li	a0,1
    5968:	00001097          	auipc	ra,0x1
    596c:	cf4080e7          	jalr	-780(ra) # 665c <exit>
    5970:	f426                	sd	s1,40(sp)
    5972:	f04a                	sd	s2,32(sp)
    5974:	ec4e                	sd	s3,24(sp)
    5976:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    5978:	00003517          	auipc	a0,0x3
    597c:	20850513          	addi	a0,a0,520 # 8b80 <malloc+0x20ea>
    5980:	00001097          	auipc	ra,0x1
    5984:	05a080e7          	jalr	90(ra) # 69da <printf>
    exit(1);
    5988:	4505                	li	a0,1
    598a:	00001097          	auipc	ra,0x1
    598e:	cd2080e7          	jalr	-814(ra) # 665c <exit>
      }
    }

    exit(0);
    5992:	4501                	li	a0,0
    5994:	00001097          	auipc	ra,0x1
    5998:	cc8080e7          	jalr	-824(ra) # 665c <exit>
    599c:	f426                	sd	s1,40(sp)
    599e:	f04a                	sd	s2,32(sp)
    59a0:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    59a2:	fcc42503          	lw	a0,-52(s0)
    59a6:	00001097          	auipc	ra,0x1
    59aa:	cde080e7          	jalr	-802(ra) # 6684 <close>

  int n = 0;
    59ae:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    59b0:	fc740993          	addi	s3,s0,-57
    59b4:	4905                	li	s2,1
    59b6:	864a                	mv	a2,s2
    59b8:	85ce                	mv	a1,s3
    59ba:	fc842503          	lw	a0,-56(s0)
    59be:	00001097          	auipc	ra,0x1
    59c2:	cb6080e7          	jalr	-842(ra) # 6674 <read>
    if(cc < 0){
    59c6:	00054563          	bltz	a0,59d0 <countfree+0x10c>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    59ca:	c10d                	beqz	a0,59ec <countfree+0x128>
      break;
    n += 1;
    59cc:	2485                	addiw	s1,s1,1
  while(1){
    59ce:	b7e5                	j	59b6 <countfree+0xf2>
    59d0:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    59d2:	00003517          	auipc	a0,0x3
    59d6:	1ee50513          	addi	a0,a0,494 # 8bc0 <malloc+0x212a>
    59da:	00001097          	auipc	ra,0x1
    59de:	000080e7          	jalr	ra # 69da <printf>
      exit(1);
    59e2:	4505                	li	a0,1
    59e4:	00001097          	auipc	ra,0x1
    59e8:	c78080e7          	jalr	-904(ra) # 665c <exit>
  }

  close(fds[0]);
    59ec:	fc842503          	lw	a0,-56(s0)
    59f0:	00001097          	auipc	ra,0x1
    59f4:	c94080e7          	jalr	-876(ra) # 6684 <close>
  wait((int*)0);
    59f8:	4501                	li	a0,0
    59fa:	00001097          	auipc	ra,0x1
    59fe:	c6a080e7          	jalr	-918(ra) # 6664 <wait>
  
  return n;
}
    5a02:	8526                	mv	a0,s1
    5a04:	74a2                	ld	s1,40(sp)
    5a06:	7902                	ld	s2,32(sp)
    5a08:	69e2                	ld	s3,24(sp)
    5a0a:	70e2                	ld	ra,56(sp)
    5a0c:	7442                	ld	s0,48(sp)
    5a0e:	6121                	addi	sp,sp,64
    5a10:	8082                	ret

0000000000005a12 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5a12:	7159                	addi	sp,sp,-112
    5a14:	f486                	sd	ra,104(sp)
    5a16:	f0a2                	sd	s0,96(sp)
    5a18:	eca6                	sd	s1,88(sp)
    5a1a:	e8ca                	sd	s2,80(sp)
    5a1c:	e4ce                	sd	s3,72(sp)
    5a1e:	e0d2                	sd	s4,64(sp)
    5a20:	fc56                	sd	s5,56(sp)
    5a22:	f85a                	sd	s6,48(sp)
    5a24:	f45e                	sd	s7,40(sp)
    5a26:	f062                	sd	s8,32(sp)
    5a28:	ec66                	sd	s9,24(sp)
    5a2a:	e86a                	sd	s10,16(sp)
    5a2c:	e46e                	sd	s11,8(sp)
    5a2e:	1880                	addi	s0,sp,112
    5a30:	8a2a                	mv	s4,a0
    5a32:	89ae                	mv	s3,a1
    5a34:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
      if(continuous != 2) {
    5a36:	ffe58b93          	addi	s7,a1,-2
    5a3a:	01703bb3          	snez	s7,s7
    printf("usertests starting\n");
    5a3e:	00003b17          	auipc	s6,0x3
    5a42:	1a2b0b13          	addi	s6,s6,418 # 8be0 <malloc+0x214a>
    if (runtests(quicktests, justone)) {
    5a46:	00004a97          	auipc	s5,0x4
    5a4a:	5caa8a93          	addi	s5,s5,1482 # a010 <quicktests>
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    5a4e:	00005c17          	auipc	s8,0x5
    5a52:	992c0c13          	addi	s8,s8,-1646 # a3e0 <slowtests>
        printf("usertests slow tests starting\n");
    5a56:	00003d97          	auipc	s11,0x3
    5a5a:	1a2d8d93          	addi	s11,s11,418 # 8bf8 <malloc+0x2162>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5a5e:	00003d17          	auipc	s10,0x3
    5a62:	1bad0d13          	addi	s10,s10,442 # 8c18 <malloc+0x2182>
      if(continuous != 2) {
    5a66:	4c89                	li	s9,2
    5a68:	a839                	j	5a86 <drivetests+0x74>
        printf("usertests slow tests starting\n");
    5a6a:	856e                	mv	a0,s11
    5a6c:	00001097          	auipc	ra,0x1
    5a70:	f6e080e7          	jalr	-146(ra) # 69da <printf>
    5a74:	a081                	j	5ab4 <drivetests+0xa2>
    if((free1 = countfree()) < free0) {
    5a76:	00000097          	auipc	ra,0x0
    5a7a:	e4e080e7          	jalr	-434(ra) # 58c4 <countfree>
    5a7e:	04954663          	blt	a0,s1,5aca <drivetests+0xb8>
        return 1;
      }
    }
  } while(continuous);
    5a82:	06098163          	beqz	s3,5ae4 <drivetests+0xd2>
    printf("usertests starting\n");
    5a86:	855a                	mv	a0,s6
    5a88:	00001097          	auipc	ra,0x1
    5a8c:	f52080e7          	jalr	-174(ra) # 69da <printf>
    int free0 = countfree();
    5a90:	00000097          	auipc	ra,0x0
    5a94:	e34080e7          	jalr	-460(ra) # 58c4 <countfree>
    5a98:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    5a9a:	85ca                	mv	a1,s2
    5a9c:	8556                	mv	a0,s5
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	dcc080e7          	jalr	-564(ra) # 586a <runtests>
      if(continuous != 2) {
    5aa6:	c119                	beqz	a0,5aac <drivetests+0x9a>
    5aa8:	020b9c63          	bnez	s7,5ae0 <drivetests+0xce>
    if(!quick) {
    5aac:	fc0a15e3          	bnez	s4,5a76 <drivetests+0x64>
      if (justone == 0)
    5ab0:	fa090de3          	beqz	s2,5a6a <drivetests+0x58>
      if (runtests(slowtests, justone)) {
    5ab4:	85ca                	mv	a1,s2
    5ab6:	8562                	mv	a0,s8
    5ab8:	00000097          	auipc	ra,0x0
    5abc:	db2080e7          	jalr	-590(ra) # 586a <runtests>
        if(continuous != 2) {
    5ac0:	d95d                	beqz	a0,5a76 <drivetests+0x64>
    5ac2:	fa0b8ae3          	beqz	s7,5a76 <drivetests+0x64>
          return 1;
    5ac6:	4505                	li	a0,1
    5ac8:	a839                	j	5ae6 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5aca:	8626                	mv	a2,s1
    5acc:	85aa                	mv	a1,a0
    5ace:	856a                	mv	a0,s10
    5ad0:	00001097          	auipc	ra,0x1
    5ad4:	f0a080e7          	jalr	-246(ra) # 69da <printf>
      if(continuous != 2) {
    5ad8:	fb9987e3          	beq	s3,s9,5a86 <drivetests+0x74>
        return 1;
    5adc:	4505                	li	a0,1
    5ade:	a021                	j	5ae6 <drivetests+0xd4>
        return 1;
    5ae0:	4505                	li	a0,1
    5ae2:	a011                	j	5ae6 <drivetests+0xd4>
  return 0;
    5ae4:	854e                	mv	a0,s3
}
    5ae6:	70a6                	ld	ra,104(sp)
    5ae8:	7406                	ld	s0,96(sp)
    5aea:	64e6                	ld	s1,88(sp)
    5aec:	6946                	ld	s2,80(sp)
    5aee:	69a6                	ld	s3,72(sp)
    5af0:	6a06                	ld	s4,64(sp)
    5af2:	7ae2                	ld	s5,56(sp)
    5af4:	7b42                	ld	s6,48(sp)
    5af6:	7ba2                	ld	s7,40(sp)
    5af8:	7c02                	ld	s8,32(sp)
    5afa:	6ce2                	ld	s9,24(sp)
    5afc:	6d42                	ld	s10,16(sp)
    5afe:	6da2                	ld	s11,8(sp)
    5b00:	6165                	addi	sp,sp,112
    5b02:	8082                	ret

0000000000005b04 <main>:

int
main(int argc, char *argv[])
{
    5b04:	1101                	addi	sp,sp,-32
    5b06:	ec06                	sd	ra,24(sp)
    5b08:	e822                	sd	s0,16(sp)
    5b0a:	e426                	sd	s1,8(sp)
    5b0c:	e04a                	sd	s2,0(sp)
    5b0e:	1000                	addi	s0,sp,32
    5b10:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5b12:	4789                	li	a5,2
    5b14:	02f50263          	beq	a0,a5,5b38 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5b18:	4785                	li	a5,1
    5b1a:	08a7c063          	blt	a5,a0,5b9a <main+0x96>
  char *justone = 0;
    5b1e:	4601                	li	a2,0
  int quick = 0;
    5b20:	4501                	li	a0,0
  int continuous = 0;
    5b22:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5b24:	00000097          	auipc	ra,0x0
    5b28:	eee080e7          	jalr	-274(ra) # 5a12 <drivetests>
    5b2c:	c951                	beqz	a0,5bc0 <main+0xbc>
    exit(1);
    5b2e:	4505                	li	a0,1
    5b30:	00001097          	auipc	ra,0x1
    5b34:	b2c080e7          	jalr	-1236(ra) # 665c <exit>
    5b38:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5b3a:	00003597          	auipc	a1,0x3
    5b3e:	10e58593          	addi	a1,a1,270 # 8c48 <malloc+0x21b2>
    5b42:	00893503          	ld	a0,8(s2) # 1008 <linktest+0xb4>
    5b46:	00001097          	auipc	ra,0x1
    5b4a:	8a8080e7          	jalr	-1880(ra) # 63ee <strcmp>
    5b4e:	85aa                	mv	a1,a0
    5b50:	e501                	bnez	a0,5b58 <main+0x54>
  char *justone = 0;
    5b52:	4601                	li	a2,0
    quick = 1;
    5b54:	4505                	li	a0,1
    5b56:	b7f9                	j	5b24 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5b58:	00003597          	auipc	a1,0x3
    5b5c:	0f858593          	addi	a1,a1,248 # 8c50 <malloc+0x21ba>
    5b60:	00893503          	ld	a0,8(s2)
    5b64:	00001097          	auipc	ra,0x1
    5b68:	88a080e7          	jalr	-1910(ra) # 63ee <strcmp>
    5b6c:	c521                	beqz	a0,5bb4 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5b6e:	00003597          	auipc	a1,0x3
    5b72:	13258593          	addi	a1,a1,306 # 8ca0 <malloc+0x220a>
    5b76:	00893503          	ld	a0,8(s2)
    5b7a:	00001097          	auipc	ra,0x1
    5b7e:	874080e7          	jalr	-1932(ra) # 63ee <strcmp>
    5b82:	cd05                	beqz	a0,5bba <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5b84:	00893603          	ld	a2,8(s2)
    5b88:	00064703          	lbu	a4,0(a2) # 3000 <sbrklast+0x44>
    5b8c:	02d00793          	li	a5,45
    5b90:	00f70563          	beq	a4,a5,5b9a <main+0x96>
  int quick = 0;
    5b94:	4501                	li	a0,0
  int continuous = 0;
    5b96:	4581                	li	a1,0
    5b98:	b771                	j	5b24 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5b9a:	00003517          	auipc	a0,0x3
    5b9e:	0be50513          	addi	a0,a0,190 # 8c58 <malloc+0x21c2>
    5ba2:	00001097          	auipc	ra,0x1
    5ba6:	e38080e7          	jalr	-456(ra) # 69da <printf>
    exit(1);
    5baa:	4505                	li	a0,1
    5bac:	00001097          	auipc	ra,0x1
    5bb0:	ab0080e7          	jalr	-1360(ra) # 665c <exit>
  char *justone = 0;
    5bb4:	4601                	li	a2,0
    continuous = 1;
    5bb6:	4585                	li	a1,1
    5bb8:	b7b5                	j	5b24 <main+0x20>
    continuous = 2;
    5bba:	85a6                	mv	a1,s1
  char *justone = 0;
    5bbc:	4601                	li	a2,0
    5bbe:	b79d                	j	5b24 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5bc0:	00003517          	auipc	a0,0x3
    5bc4:	0c850513          	addi	a0,a0,200 # 8c88 <malloc+0x21f2>
    5bc8:	00001097          	auipc	ra,0x1
    5bcc:	e12080e7          	jalr	-494(ra) # 69da <printf>
  exit(0);
    5bd0:	4501                	li	a0,0
    5bd2:	00001097          	auipc	ra,0x1
    5bd6:	a8a080e7          	jalr	-1398(ra) # 665c <exit>

0000000000005bda <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
    5bda:	1141                	addi	sp,sp,-16
    5bdc:	e406                	sd	ra,8(sp)
    5bde:	e022                	sd	s0,0(sp)
    5be0:	0800                	addi	s0,sp,16
    lk->name = name;
    5be2:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
    5be4:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
    5be8:	57fd                	li	a5,-1
    5bea:	00f50823          	sb	a5,16(a0)
}
    5bee:	60a2                	ld	ra,8(sp)
    5bf0:	6402                	ld	s0,0(sp)
    5bf2:	0141                	addi	sp,sp,16
    5bf4:	8082                	ret

0000000000005bf6 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
    5bf6:	00054783          	lbu	a5,0(a0)
    5bfa:	e399                	bnez	a5,5c00 <holding+0xa>
    5bfc:	4501                	li	a0,0
}
    5bfe:	8082                	ret
{
    5c00:	1101                	addi	sp,sp,-32
    5c02:	ec06                	sd	ra,24(sp)
    5c04:	e822                	sd	s0,16(sp)
    5c06:	e426                	sd	s1,8(sp)
    5c08:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
    5c0a:	01054483          	lbu	s1,16(a0)
    5c0e:	00000097          	auipc	ra,0x0
    5c12:	63e080e7          	jalr	1598(ra) # 624c <twhoami>
    5c16:	2501                	sext.w	a0,a0
    5c18:	40a48533          	sub	a0,s1,a0
    5c1c:	00153513          	seqz	a0,a0
}
    5c20:	60e2                	ld	ra,24(sp)
    5c22:	6442                	ld	s0,16(sp)
    5c24:	64a2                	ld	s1,8(sp)
    5c26:	6105                	addi	sp,sp,32
    5c28:	8082                	ret

0000000000005c2a <acquire>:

void acquire(struct lock *lk)
{
    5c2a:	7179                	addi	sp,sp,-48
    5c2c:	f406                	sd	ra,40(sp)
    5c2e:	f022                	sd	s0,32(sp)
    5c30:	ec26                	sd	s1,24(sp)
    5c32:	e84a                	sd	s2,16(sp)
    5c34:	e44e                	sd	s3,8(sp)
    5c36:	1800                	addi	s0,sp,48
    5c38:	892a                	mv	s2,a0
    if (holding(lk))
    5c3a:	00000097          	auipc	ra,0x0
    5c3e:	fbc080e7          	jalr	-68(ra) # 5bf6 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    5c42:	ffc97493          	andi	s1,s2,-4
    5c46:	4985                	li	s3,1
    if (holding(lk))
    5c48:	c115                	beqz	a0,5c6c <acquire+0x42>
        printf("re-acquiring lock we already hold");
    5c4a:	00003517          	auipc	a0,0x3
    5c4e:	39e50513          	addi	a0,a0,926 # 8fe8 <malloc+0x2552>
    5c52:	00001097          	auipc	ra,0x1
    5c56:	d88080e7          	jalr	-632(ra) # 69da <printf>
        exit(-1);
    5c5a:	557d                	li	a0,-1
    5c5c:	00001097          	auipc	ra,0x1
    5c60:	a00080e7          	jalr	-1536(ra) # 665c <exit>
    {
        // give up the cpu for other threads
        tyield();
    5c64:	00000097          	auipc	ra,0x0
    5c68:	5b2080e7          	jalr	1458(ra) # 6216 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    5c6c:	00397713          	andi	a4,s2,3
    5c70:	0037171b          	slliw	a4,a4,0x3
    5c74:	0ff00793          	li	a5,255
    5c78:	00e797bb          	sllw	a5,a5,a4
    5c7c:	fff7c613          	not	a2,a5
    5c80:	00e996bb          	sllw	a3,s3,a4
    5c84:	8efd                	and	a3,a3,a5
    5c86:	1404a7af          	lr.w.aq	a5,(s1)
    5c8a:	00c7f5b3          	and	a1,a5,a2
    5c8e:	8dd5                	or	a1,a1,a3
    5c90:	18b4a5af          	sc.w	a1,a1,(s1)
    5c94:	f9ed                	bnez	a1,5c86 <acquire+0x5c>
    5c96:	40e7d7bb          	sraw	a5,a5,a4
    5c9a:	0ff7f793          	zext.b	a5,a5
    5c9e:	f3f9                	bnez	a5,5c64 <acquire+0x3a>
    }

    __sync_synchronize();
    5ca0:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
    5ca4:	00000097          	auipc	ra,0x0
    5ca8:	5a8080e7          	jalr	1448(ra) # 624c <twhoami>
    5cac:	00a90823          	sb	a0,16(s2)
}
    5cb0:	70a2                	ld	ra,40(sp)
    5cb2:	7402                	ld	s0,32(sp)
    5cb4:	64e2                	ld	s1,24(sp)
    5cb6:	6942                	ld	s2,16(sp)
    5cb8:	69a2                	ld	s3,8(sp)
    5cba:	6145                	addi	sp,sp,48
    5cbc:	8082                	ret

0000000000005cbe <release>:

void release(struct lock *lk)
{
    5cbe:	1101                	addi	sp,sp,-32
    5cc0:	ec06                	sd	ra,24(sp)
    5cc2:	e822                	sd	s0,16(sp)
    5cc4:	e426                	sd	s1,8(sp)
    5cc6:	1000                	addi	s0,sp,32
    5cc8:	84aa                	mv	s1,a0
    if (!holding(lk))
    5cca:	00000097          	auipc	ra,0x0
    5cce:	f2c080e7          	jalr	-212(ra) # 5bf6 <holding>
    5cd2:	c11d                	beqz	a0,5cf8 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
    5cd4:	57fd                	li	a5,-1
    5cd6:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
    5cda:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
    5cde:	0310000f          	fence	rw,w
    5ce2:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
    5ce6:	00000097          	auipc	ra,0x0
    5cea:	530080e7          	jalr	1328(ra) # 6216 <tyield>
}
    5cee:	60e2                	ld	ra,24(sp)
    5cf0:	6442                	ld	s0,16(sp)
    5cf2:	64a2                	ld	s1,8(sp)
    5cf4:	6105                	addi	sp,sp,32
    5cf6:	8082                	ret
        printf("releasing lock we are not holding");
    5cf8:	00003517          	auipc	a0,0x3
    5cfc:	31850513          	addi	a0,a0,792 # 9010 <malloc+0x257a>
    5d00:	00001097          	auipc	ra,0x1
    5d04:	cda080e7          	jalr	-806(ra) # 69da <printf>
        exit(-1);
    5d08:	557d                	li	a0,-1
    5d0a:	00001097          	auipc	ra,0x1
    5d0e:	952080e7          	jalr	-1710(ra) # 665c <exit>

0000000000005d12 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
    5d12:	00004797          	auipc	a5,0x4
    5d16:	73e7c783          	lbu	a5,1854(a5) # a450 <threadlib_init_done>
    5d1a:	eba5                	bnez	a5,5d8a <threadlib_init+0x78>
{
    5d1c:	7179                	addi	sp,sp,-48
    5d1e:	f406                	sd	ra,40(sp)
    5d20:	f022                	sd	s0,32(sp)
    5d22:	ec26                	sd	s1,24(sp)
    5d24:	e84a                	sd	s2,16(sp)
    5d26:	e44e                	sd	s3,8(sp)
    5d28:	e052                	sd	s4,0(sp)
    5d2a:	1800                	addi	s0,sp,48
    5d2c:	0000b497          	auipc	s1,0xb
    5d30:	f5c48493          	addi	s1,s1,-164 # 10c88 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
    5d34:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
    5d36:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
    5d3a:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
    5d3c:	8652                	mv	a2,s4
    5d3e:	4581                	li	a1,0
    5d40:	8526                	mv	a0,s1
    5d42:	00000097          	auipc	ra,0x0
    5d46:	708080e7          	jalr	1800(ra) # 644a <memset>
        threads[i].tid = i;
    5d4a:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
    5d4e:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
    5d52:	2905                	addiw	s2,s2,1
    5d54:	0b048493          	addi	s1,s1,176
    5d58:	ff3912e3          	bne	s2,s3,5d3c <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
    5d5c:	0000b797          	auipc	a5,0xb
    5d60:	f2c78793          	addi	a5,a5,-212 # 10c88 <threads>
    5d64:	00004717          	auipc	a4,0x4
    5d68:	6ef73a23          	sd	a5,1780(a4) # a458 <current_thread>
    current_thread->state = RUNNING;
    5d6c:	4711                	li	a4,4
    5d6e:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
    5d70:	4785                	li	a5,1
    5d72:	00004717          	auipc	a4,0x4
    5d76:	6cf70f23          	sb	a5,1758(a4) # a450 <threadlib_init_done>
}
    5d7a:	70a2                	ld	ra,40(sp)
    5d7c:	7402                	ld	s0,32(sp)
    5d7e:	64e2                	ld	s1,24(sp)
    5d80:	6942                	ld	s2,16(sp)
    5d82:	69a2                	ld	s3,8(sp)
    5d84:	6a02                	ld	s4,0(sp)
    5d86:	6145                	addi	sp,sp,48
    5d88:	8082                	ret
    5d8a:	8082                	ret

0000000000005d8c <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
    5d8c:	1101                	addi	sp,sp,-32
    5d8e:	ec06                	sd	ra,24(sp)
    5d90:	e822                	sd	s0,16(sp)
    5d92:	e426                	sd	s1,8(sp)
    5d94:	e04a                	sd	s2,0(sp)
    5d96:	1000                	addi	s0,sp,32
    5d98:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
    5d9a:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
    5d9e:	6948                	ld	a0,144(a0)
    5da0:	c509                	beqz	a0,5daa <reclaim_thread+0x1e>
    {
        free(thread->stack);
    5da2:	00001097          	auipc	ra,0x1
    5da6:	c6e080e7          	jalr	-914(ra) # 6a10 <free>
    }
    if (thread->result)
    5daa:	70c8                	ld	a0,160(s1)
    5dac:	c509                	beqz	a0,5db6 <reclaim_thread+0x2a>
    {
        free(thread->result);
    5dae:	00001097          	auipc	ra,0x1
    5db2:	c62080e7          	jalr	-926(ra) # 6a10 <free>
    }

    memset(thread, 0, sizeof(*thread));
    5db6:	0b000613          	li	a2,176
    5dba:	4581                	li	a1,0
    5dbc:	8526                	mv	a0,s1
    5dbe:	00000097          	auipc	ra,0x0
    5dc2:	68c080e7          	jalr	1676(ra) # 644a <memset>
    thread->tid = tid;
    5dc6:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
    5dca:	0604ac23          	sw	zero,120(s1)
}
    5dce:	60e2                	ld	ra,24(sp)
    5dd0:	6442                	ld	s0,16(sp)
    5dd2:	64a2                	ld	s1,8(sp)
    5dd4:	6902                	ld	s2,0(sp)
    5dd6:	6105                	addi	sp,sp,32
    5dd8:	8082                	ret

0000000000005dda <tsched>:

void tsched()
{
    5dda:	1141                	addi	sp,sp,-16
    5ddc:	e406                	sd	ra,8(sp)
    5dde:	e022                	sd	s0,0(sp)
    5de0:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
    5de2:	00000097          	auipc	ra,0x0
    5de6:	f30080e7          	jalr	-208(ra) # 5d12 <threadlib_init>
    prev = current_thread;
    5dea:	00004517          	auipc	a0,0x4
    5dee:	66e53503          	ld	a0,1646(a0) # a458 <current_thread>
    if (prev->state == RUNNING)
    5df2:	5d38                	lw	a4,120(a0)
    5df4:	4791                	li	a5,4
    5df6:	06f70763          	beq	a4,a5,5e64 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
    5dfa:	00054603          	lbu	a2,0(a0)
    5dfe:	0016069b          	addiw	a3,a2,1
    5e02:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
    5e04:	0000b897          	auipc	a7,0xb
    5e08:	e8488893          	addi	a7,a7,-380 # 10c88 <threads>
    5e0c:	0b000813          	li	a6,176
    5e10:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
    5e12:	41f6d71b          	sraiw	a4,a3,0x1f
    5e16:	01c7571b          	srliw	a4,a4,0x1c
    5e1a:	00d707bb          	addw	a5,a4,a3
    5e1e:	8bbd                	andi	a5,a5,15
    5e20:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
    5e22:	03078733          	mul	a4,a5,a6
    5e26:	9746                	add	a4,a4,a7
    5e28:	5f38                	lw	a4,120(a4)
    5e2a:	04b70063          	beq	a4,a1,5e6a <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
    5e2e:	2685                	addiw	a3,a3,1
    5e30:	fec691e3          	bne	a3,a2,5e12 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
    5e34:	5d3c                	lw	a5,120(a0)
    5e36:	470d                	li	a4,3
    5e38:	06e78f63          	beq	a5,a4,5eb6 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
    5e3c:	4711                	li	a4,4
    5e3e:	06e78763          	beq	a5,a4,5eac <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
    5e42:	00003597          	auipc	a1,0x3
    5e46:	1f658593          	addi	a1,a1,502 # 9038 <malloc+0x25a2>
    5e4a:	00003517          	auipc	a0,0x3
    5e4e:	1fe50513          	addi	a0,a0,510 # 9048 <malloc+0x25b2>
    5e52:	00001097          	auipc	ra,0x1
    5e56:	b88080e7          	jalr	-1144(ra) # 69da <printf>
        exit(-1);
    5e5a:	557d                	li	a0,-1
    5e5c:	00001097          	auipc	ra,0x1
    5e60:	800080e7          	jalr	-2048(ra) # 665c <exit>
        prev->state = RUNNABLE;
    5e64:	478d                	li	a5,3
    5e66:	dd3c                	sw	a5,120(a0)
    5e68:	bf49                	j	5dfa <tsched+0x20>
            return &threads[idx];
    5e6a:	0b000713          	li	a4,176
    5e6e:	02e78733          	mul	a4,a5,a4
    5e72:	0000b697          	auipc	a3,0xb
    5e76:	e1668693          	addi	a3,a3,-490 # 10c88 <threads>
    5e7a:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
    5e7c:	02d50c63          	beq	a0,a3,5eb4 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
    5e80:	00004617          	auipc	a2,0x4
    5e84:	5cd63c23          	sd	a3,1496(a2) # a458 <current_thread>
    next->state = RUNNING;
    5e88:	0000b597          	auipc	a1,0xb
    5e8c:	e0058593          	addi	a1,a1,-512 # 10c88 <threads>
    5e90:	0b000693          	li	a3,176
    5e94:	02d787b3          	mul	a5,a5,a3
    5e98:	97ae                	add	a5,a5,a1
    5e9a:	4691                	li	a3,4
    5e9c:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
    5e9e:	0721                	addi	a4,a4,8
    5ea0:	95ba                	add	a1,a1,a4
    5ea2:	0521                	addi	a0,a0,8
    5ea4:	00000097          	auipc	ra,0x0
    5ea8:	488080e7          	jalr	1160(ra) # 632c <tswtch>
}
    5eac:	60a2                	ld	ra,8(sp)
    5eae:	6402                	ld	s0,0(sp)
    5eb0:	0141                	addi	sp,sp,16
    5eb2:	8082                	ret
    5eb4:	8536                	mv	a0,a3
        next->state = RUNNING;
    5eb6:	4791                	li	a5,4
    5eb8:	dd3c                	sw	a5,120(a0)
        return;
    5eba:	bfcd                	j	5eac <tsched+0xd2>

0000000000005ebc <thread_bootstrap>:
{
    5ebc:	1101                	addi	sp,sp,-32
    5ebe:	ec06                	sd	ra,24(sp)
    5ec0:	e822                	sd	s0,16(sp)
    5ec2:	e426                	sd	s1,8(sp)
    5ec4:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
    5ec6:	00004497          	auipc	s1,0x4
    5eca:	5924b483          	ld	s1,1426(s1) # a458 <current_thread>
    if (thread)
    5ece:	c09d                	beqz	s1,5ef4 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
    5ed0:	64dc                	ld	a5,136(s1)
    5ed2:	60c8                	ld	a0,128(s1)
    5ed4:	9782                	jalr	a5
    5ed6:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
    5ed8:	00004497          	auipc	s1,0x4
    5edc:	5804b483          	ld	s1,1408(s1) # a458 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
    5ee0:	09c4a603          	lw	a2,156(s1)
    5ee4:	ca01                	beqz	a2,5ef4 <thread_bootstrap+0x38>
    5ee6:	70c8                	ld	a0,160(s1)
    5ee8:	c591                	beqz	a1,5ef4 <thread_bootstrap+0x38>
    5eea:	c509                	beqz	a0,5ef4 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
    5eec:	00000097          	auipc	ra,0x0
    5ef0:	6ba080e7          	jalr	1722(ra) # 65a6 <memmove>
    thread->state = EXITED;
    5ef4:	4799                	li	a5,6
    5ef6:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
    5ef8:	74dc                	ld	a5,168(s1)
    5efa:	c789                	beqz	a5,5f04 <thread_bootstrap+0x48>
    5efc:	5fb4                	lw	a3,120(a5)
    5efe:	4709                	li	a4,2
    5f00:	00e68b63          	beq	a3,a4,5f16 <thread_bootstrap+0x5a>
    tsched();
    5f04:	00000097          	auipc	ra,0x0
    5f08:	ed6080e7          	jalr	-298(ra) # 5dda <tsched>
    exit(-1);
    5f0c:	557d                	li	a0,-1
    5f0e:	00000097          	auipc	ra,0x0
    5f12:	74e080e7          	jalr	1870(ra) # 665c <exit>
        thread->joiner->state = RUNNABLE;
    5f16:	470d                	li	a4,3
    5f18:	dfb8                	sw	a4,120(a5)
    5f1a:	b7ed                	j	5f04 <thread_bootstrap+0x48>

0000000000005f1c <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    5f1c:	715d                	addi	sp,sp,-80
    5f1e:	e486                	sd	ra,72(sp)
    5f20:	e0a2                	sd	s0,64(sp)
    5f22:	fc26                	sd	s1,56(sp)
    5f24:	f84a                	sd	s2,48(sp)
    5f26:	f44e                	sd	s3,40(sp)
    5f28:	f052                	sd	s4,32(sp)
    5f2a:	ec56                	sd	s5,24(sp)
    5f2c:	e85a                	sd	s6,16(sp)
    5f2e:	e45e                	sd	s7,8(sp)
    5f30:	e062                	sd	s8,0(sp)
    5f32:	0880                	addi	s0,sp,80
    5f34:	8b2a                	mv	s6,a0
    5f36:	84ae                	mv	s1,a1
    5f38:	8bb2                	mv	s7,a2
    5f3a:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
    5f3c:	00000097          	auipc	ra,0x0
    5f40:	dd6080e7          	jalr	-554(ra) # 5d12 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
    5f44:	c4b1                	beqz	s1,5f90 <tcreate+0x74>
    {
        if (attr->stacksize)
    5f46:	0004a983          	lw	s3,0(s1)
    5f4a:	00099363          	bnez	s3,5f50 <tcreate+0x34>
    stacksize = PGSIZE;
    5f4e:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
    5f50:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
    5f54:	0000b797          	auipc	a5,0xb
    5f58:	e5c78793          	addi	a5,a5,-420 # 10db0 <threads+0x128>
    5f5c:	4485                	li	s1,1
    5f5e:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
    5f60:	4398                	lw	a4,0(a5)
    5f62:	cb15                	beqz	a4,5f96 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
    5f64:	2485                	addiw	s1,s1,1
    5f66:	0b078793          	addi	a5,a5,176
    5f6a:	feb49be3          	bne	s1,a1,5f60 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
    5f6e:	00003597          	auipc	a1,0x3
    5f72:	0ca58593          	addi	a1,a1,202 # 9038 <malloc+0x25a2>
    5f76:	00003517          	auipc	a0,0x3
    5f7a:	0ea50513          	addi	a0,a0,234 # 9060 <malloc+0x25ca>
    5f7e:	00001097          	auipc	ra,0x1
    5f82:	a5c080e7          	jalr	-1444(ra) # 69da <printf>
        exit(-1);
    5f86:	557d                	li	a0,-1
    5f88:	00000097          	auipc	ra,0x0
    5f8c:	6d4080e7          	jalr	1748(ra) # 665c <exit>
    res_size = 0;
    5f90:	4a81                	li	s5,0
    stacksize = PGSIZE;
    5f92:	6985                	lui	s3,0x1
    5f94:	b7c1                	j	5f54 <tcreate+0x38>
            new_thread = &threads[i];
    5f96:	0b000a13          	li	s4,176
    5f9a:	03448a33          	mul	s4,s1,s4
    5f9e:	0000b917          	auipc	s2,0xb
    5fa2:	cea90913          	addi	s2,s2,-790 # 10c88 <threads>
    5fa6:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
    5fa8:	0b000613          	li	a2,176
    5fac:	4581                	li	a1,0
    5fae:	854a                	mv	a0,s2
    5fb0:	00000097          	auipc	ra,0x0
    5fb4:	49a080e7          	jalr	1178(ra) # 644a <memset>
    new_thread->tid = new_thread - threads;
    5fb8:	404a5693          	srai	a3,s4,0x4
    5fbc:	000ba737          	lui	a4,0xba
    5fc0:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xa8b61>
    5fc4:	0732                	slli	a4,a4,0xc
    5fc6:	ba370713          	addi	a4,a4,-1117
    5fca:	2e8ba7b7          	lui	a5,0x2e8ba
    5fce:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8a8b60>
    5fd2:	1782                	slli	a5,a5,0x20
    5fd4:	97ba                	add	a5,a5,a4
    5fd6:	02f687b3          	mul	a5,a3,a5
    5fda:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
    5fde:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
    5fe2:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
    5fe6:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
    5fea:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
    5fee:	478d                	li	a5,3
    5ff0:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
    5ff4:	0109851b          	addiw	a0,s3,16 # 1010 <linktest+0xbc>
    5ff8:	00001097          	auipc	ra,0x1
    5ffc:	a9e080e7          	jalr	-1378(ra) # 6a96 <malloc>
    6000:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
    6004:	c951                	beqz	a0,6098 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
    6006:	020a8863          	beqz	s5,6036 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
    600a:	8556                	mv	a0,s5
    600c:	00001097          	auipc	ra,0x1
    6010:	a8a080e7          	jalr	-1398(ra) # 6a96 <malloc>
    6014:	0b000713          	li	a4,176
    6018:	02e48733          	mul	a4,s1,a4
    601c:	0000b797          	auipc	a5,0xb
    6020:	c6c78793          	addi	a5,a5,-916 # 10c88 <threads>
    6024:	97ba                	add	a5,a5,a4
    6026:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
    6028:	c949                	beqz	a0,60ba <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
    602a:	8656                	mv	a2,s5
    602c:	4581                	li	a1,0
    602e:	00000097          	auipc	ra,0x0
    6032:	41c080e7          	jalr	1052(ra) # 644a <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
    6036:	0000b517          	auipc	a0,0xb
    603a:	c5250513          	addi	a0,a0,-942 # 10c88 <threads>
    603e:	0b000793          	li	a5,176
    6042:	02f484b3          	mul	s1,s1,a5
    6046:	94aa                	add	s1,s1,a0
    6048:	1982                	slli	s3,s3,0x20
    604a:	0209d993          	srli	s3,s3,0x20
    604e:	09c1                	addi	s3,s3,16
    6050:	68dc                	ld	a5,144(s1)
    6052:	99be                	add	s3,s3,a5
    6054:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
    6058:	0a21                	addi	s4,s4,8
    605a:	07000613          	li	a2,112
    605e:	4581                	li	a1,0
    6060:	9552                	add	a0,a0,s4
    6062:	00000097          	auipc	ra,0x0
    6066:	3e8080e7          	jalr	1000(ra) # 644a <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
    606a:	00000797          	auipc	a5,0x0
    606e:	e5278793          	addi	a5,a5,-430 # 5ebc <thread_bootstrap>
    6072:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
    6074:	0134b823          	sd	s3,16(s1)

    if (thread)
    6078:	000b0463          	beqz	s6,6080 <tcreate+0x164>
    {
        *thread = new_thread;
    607c:	012b3023          	sd	s2,0(s6)
    }
}
    6080:	60a6                	ld	ra,72(sp)
    6082:	6406                	ld	s0,64(sp)
    6084:	74e2                	ld	s1,56(sp)
    6086:	7942                	ld	s2,48(sp)
    6088:	79a2                	ld	s3,40(sp)
    608a:	7a02                	ld	s4,32(sp)
    608c:	6ae2                	ld	s5,24(sp)
    608e:	6b42                	ld	s6,16(sp)
    6090:	6ba2                	ld	s7,8(sp)
    6092:	6c02                	ld	s8,0(sp)
    6094:	6161                	addi	sp,sp,80
    6096:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
    6098:	00003597          	auipc	a1,0x3
    609c:	fa058593          	addi	a1,a1,-96 # 9038 <malloc+0x25a2>
    60a0:	00003517          	auipc	a0,0x3
    60a4:	fd850513          	addi	a0,a0,-40 # 9078 <malloc+0x25e2>
    60a8:	00001097          	auipc	ra,0x1
    60ac:	932080e7          	jalr	-1742(ra) # 69da <printf>
        exit(-1);
    60b0:	557d                	li	a0,-1
    60b2:	00000097          	auipc	ra,0x0
    60b6:	5aa080e7          	jalr	1450(ra) # 665c <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
    60ba:	00003597          	auipc	a1,0x3
    60be:	f7e58593          	addi	a1,a1,-130 # 9038 <malloc+0x25a2>
    60c2:	00003517          	auipc	a0,0x3
    60c6:	fde50513          	addi	a0,a0,-34 # 90a0 <malloc+0x260a>
    60ca:	00001097          	auipc	ra,0x1
    60ce:	910080e7          	jalr	-1776(ra) # 69da <printf>
            exit(-1);
    60d2:	557d                	li	a0,-1
    60d4:	00000097          	auipc	ra,0x0
    60d8:	588080e7          	jalr	1416(ra) # 665c <exit>

00000000000060dc <tjoin>:

int tjoin(int tid, void *status, uint size)
{
    60dc:	715d                	addi	sp,sp,-80
    60de:	e486                	sd	ra,72(sp)
    60e0:	e0a2                	sd	s0,64(sp)
    60e2:	f84a                	sd	s2,48(sp)
    60e4:	e45e                	sd	s7,8(sp)
    60e6:	e062                	sd	s8,0(sp)
    60e8:	0880                	addi	s0,sp,80
    60ea:	892a                	mv	s2,a0
    60ec:	8bae                	mv	s7,a1
    60ee:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
    60f0:	00000097          	auipc	ra,0x0
    60f4:	c22080e7          	jalr	-990(ra) # 5d12 <threadlib_init>
    if (current_thread->tid == tid)
    60f8:	00004697          	auipc	a3,0x4
    60fc:	3606b683          	ld	a3,864(a3) # a458 <current_thread>
    6100:	0006c783          	lbu	a5,0(a3)
    6104:	0f278763          	beq	a5,s2,61f2 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
    6108:	47bd                	li	a5,15
    610a:	0f27e663          	bltu	a5,s2,61f6 <tjoin+0x11a>
    610e:	fc26                	sd	s1,56(sp)
    6110:	f44e                	sd	s3,40(sp)
    6112:	f052                	sd	s4,32(sp)
    6114:	ec56                	sd	s5,24(sp)
    6116:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
    6118:	0b000713          	li	a4,176
    611c:	02e90733          	mul	a4,s2,a4
    6120:	0000b797          	auipc	a5,0xb
    6124:	b6878793          	addi	a5,a5,-1176 # 10c88 <threads>
    6128:	97ba                	add	a5,a5,a4
    612a:	5fbc                	lw	a5,120(a5)
    612c:	c7f9                	beqz	a5,61fa <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
    612e:	0b000713          	li	a4,176
    6132:	02e90733          	mul	a4,s2,a4
    6136:	0000b797          	auipc	a5,0xb
    613a:	b5278793          	addi	a5,a5,-1198 # 10c88 <threads>
    613e:	97ba                	add	a5,a5,a4
    6140:	77dc                	ld	a5,168(a5)
    6142:	c399                	beqz	a5,6148 <tjoin+0x6c>
    6144:	0cf69263          	bne	a3,a5,6208 <tjoin+0x12c>
    return &threads[tid];
    6148:	0b000b13          	li	s6,176
    614c:	03690b33          	mul	s6,s2,s6
    6150:	0000b797          	auipc	a5,0xb
    6154:	b3878793          	addi	a5,a5,-1224 # 10c88 <threads>
    6158:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
    615a:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
    615e:	078b2703          	lw	a4,120(s6)
    6162:	4799                	li	a5,6
    6164:	02f70463          	beq	a4,a5,618c <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
    6168:	00004a97          	auipc	s5,0x4
    616c:	2f0a8a93          	addi	s5,s5,752 # a458 <current_thread>
    6170:	4a09                	li	s4,2
    while (target->state != EXITED)
    6172:	84da                	mv	s1,s6
    6174:	4999                	li	s3,6
        current_thread->state = SLEEPING;
    6176:	000ab783          	ld	a5,0(s5)
    617a:	0747ac23          	sw	s4,120(a5)
        tsched();
    617e:	00000097          	auipc	ra,0x0
    6182:	c5c080e7          	jalr	-932(ra) # 5dda <tsched>
    while (target->state != EXITED)
    6186:	5cbc                	lw	a5,120(s1)
    6188:	ff3797e3          	bne	a5,s3,6176 <tjoin+0x9a>
    }

    if (status && size && target->result)
    618c:	040b8163          	beqz	s7,61ce <tjoin+0xf2>
    6190:	020c0f63          	beqz	s8,61ce <tjoin+0xf2>
    6194:	0b000713          	li	a4,176
    6198:	02e90733          	mul	a4,s2,a4
    619c:	0000b797          	auipc	a5,0xb
    61a0:	aec78793          	addi	a5,a5,-1300 # 10c88 <threads>
    61a4:	97ba                	add	a5,a5,a4
    61a6:	73cc                	ld	a1,160(a5)
    61a8:	c19d                	beqz	a1,61ce <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
    61aa:	0000b797          	auipc	a5,0xb
    61ae:	ade78793          	addi	a5,a5,-1314 # 10c88 <threads>
    61b2:	97ba                	add	a5,a5,a4
    61b4:	09c7a783          	lw	a5,156(a5)
    61b8:	863e                	mv	a2,a5
    61ba:	2781                	sext.w	a5,a5
    61bc:	00fc7363          	bgeu	s8,a5,61c2 <tjoin+0xe6>
    61c0:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
    61c2:	2601                	sext.w	a2,a2
    61c4:	855e                	mv	a0,s7
    61c6:	00000097          	auipc	ra,0x0
    61ca:	3e0080e7          	jalr	992(ra) # 65a6 <memmove>
    }

    reclaim_thread(target);
    61ce:	855a                	mv	a0,s6
    61d0:	00000097          	auipc	ra,0x0
    61d4:	bbc080e7          	jalr	-1092(ra) # 5d8c <reclaim_thread>
    return 0;
    61d8:	4501                	li	a0,0
    61da:	74e2                	ld	s1,56(sp)
    61dc:	79a2                	ld	s3,40(sp)
    61de:	7a02                	ld	s4,32(sp)
    61e0:	6ae2                	ld	s5,24(sp)
    61e2:	6b42                	ld	s6,16(sp)
}
    61e4:	60a6                	ld	ra,72(sp)
    61e6:	6406                	ld	s0,64(sp)
    61e8:	7942                	ld	s2,48(sp)
    61ea:	6ba2                	ld	s7,8(sp)
    61ec:	6c02                	ld	s8,0(sp)
    61ee:	6161                	addi	sp,sp,80
    61f0:	8082                	ret
        return -1;
    61f2:	557d                	li	a0,-1
    61f4:	bfc5                	j	61e4 <tjoin+0x108>
        return -1;
    61f6:	557d                	li	a0,-1
    61f8:	b7f5                	j	61e4 <tjoin+0x108>
    61fa:	557d                	li	a0,-1
    61fc:	74e2                	ld	s1,56(sp)
    61fe:	79a2                	ld	s3,40(sp)
    6200:	7a02                	ld	s4,32(sp)
    6202:	6ae2                	ld	s5,24(sp)
    6204:	6b42                	ld	s6,16(sp)
    6206:	bff9                	j	61e4 <tjoin+0x108>
        return -1;
    6208:	557d                	li	a0,-1
    620a:	74e2                	ld	s1,56(sp)
    620c:	79a2                	ld	s3,40(sp)
    620e:	7a02                	ld	s4,32(sp)
    6210:	6ae2                	ld	s5,24(sp)
    6212:	6b42                	ld	s6,16(sp)
    6214:	bfc1                	j	61e4 <tjoin+0x108>

0000000000006216 <tyield>:

void tyield()
{
    6216:	1141                	addi	sp,sp,-16
    6218:	e406                	sd	ra,8(sp)
    621a:	e022                	sd	s0,0(sp)
    621c:	0800                	addi	s0,sp,16
    threadlib_init();
    621e:	00000097          	auipc	ra,0x0
    6222:	af4080e7          	jalr	-1292(ra) # 5d12 <threadlib_init>
    if (current_thread->state == RUNNING)
    6226:	00004797          	auipc	a5,0x4
    622a:	2327b783          	ld	a5,562(a5) # a458 <current_thread>
    622e:	5fb4                	lw	a3,120(a5)
    6230:	4711                	li	a4,4
    6232:	00e68a63          	beq	a3,a4,6246 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
    6236:	00000097          	auipc	ra,0x0
    623a:	ba4080e7          	jalr	-1116(ra) # 5dda <tsched>
}
    623e:	60a2                	ld	ra,8(sp)
    6240:	6402                	ld	s0,0(sp)
    6242:	0141                	addi	sp,sp,16
    6244:	8082                	ret
        current_thread->state = RUNNABLE;
    6246:	470d                	li	a4,3
    6248:	dfb8                	sw	a4,120(a5)
    624a:	b7f5                	j	6236 <tyield+0x20>

000000000000624c <twhoami>:

uint8 twhoami()
{
    624c:	1141                	addi	sp,sp,-16
    624e:	e406                	sd	ra,8(sp)
    6250:	e022                	sd	s0,0(sp)
    6252:	0800                	addi	s0,sp,16
    threadlib_init();
    6254:	00000097          	auipc	ra,0x0
    6258:	abe080e7          	jalr	-1346(ra) # 5d12 <threadlib_init>
    return current_thread->tid;
}
    625c:	00004797          	auipc	a5,0x4
    6260:	1fc7b783          	ld	a5,508(a5) # a458 <current_thread>
    6264:	0007c503          	lbu	a0,0(a5)
    6268:	60a2                	ld	ra,8(sp)
    626a:	6402                	ld	s0,0(sp)
    626c:	0141                	addi	sp,sp,16
    626e:	8082                	ret

0000000000006270 <twaitall>:

void twaitall(void)
{
    6270:	7179                	addi	sp,sp,-48
    6272:	f406                	sd	ra,40(sp)
    6274:	f022                	sd	s0,32(sp)
    6276:	ec26                	sd	s1,24(sp)
    6278:	e84a                	sd	s2,16(sp)
    627a:	e44e                	sd	s3,8(sp)
    627c:	1800                	addi	s0,sp,48
    threadlib_init();
    627e:	00000097          	auipc	ra,0x0
    6282:	a94080e7          	jalr	-1388(ra) # 5d12 <threadlib_init>
    6286:	0000b497          	auipc	s1,0xb
    628a:	57a48493          	addi	s1,s1,1402 # 11800 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
    628e:	4905                	li	s2,1
    6290:	a035                	j	62bc <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
    6292:	17f5                	addi	a5,a5,-3
    6294:	0017b793          	seqz	a5,a5
    6298:	8e5d                	or	a2,a2,a5
                unfinished = 1;
    629a:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
    629c:	0b070713          	addi	a4,a4,176
    62a0:	00970863          	beq	a4,s1,62b0 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
    62a4:	431c                	lw	a5,0(a4)
    62a6:	dbfd                	beqz	a5,629c <twaitall+0x2c>
    62a8:	ffa78693          	addi	a3,a5,-6
    62ac:	f2fd                	bnez	a3,6292 <twaitall+0x22>
    62ae:	b7fd                	j	629c <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
    62b0:	cd95                	beqz	a1,62ec <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
    62b2:	ce01                	beqz	a2,62ca <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
    62b4:	00000097          	auipc	ra,0x0
    62b8:	f62080e7          	jalr	-158(ra) # 6216 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
    62bc:	0000b717          	auipc	a4,0xb
    62c0:	af470713          	addi	a4,a4,-1292 # 10db0 <threads+0x128>
        int runnable = 0;
    62c4:	4601                	li	a2,0
        int unfinished = 0;
    62c6:	4581                	li	a1,0
    62c8:	bff1                	j	62a4 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
    62ca:	00003597          	auipc	a1,0x3
    62ce:	d6e58593          	addi	a1,a1,-658 # 9038 <malloc+0x25a2>
    62d2:	00003517          	auipc	a0,0x3
    62d6:	d7650513          	addi	a0,a0,-650 # 9048 <malloc+0x25b2>
    62da:	00000097          	auipc	ra,0x0
    62de:	700080e7          	jalr	1792(ra) # 69da <printf>
            exit(-1);
    62e2:	557d                	li	a0,-1
    62e4:	00000097          	auipc	ra,0x0
    62e8:	378080e7          	jalr	888(ra) # 665c <exit>
    62ec:	0000b497          	auipc	s1,0xb
    62f0:	a4c48493          	addi	s1,s1,-1460 # 10d38 <threads+0xb0>
    62f4:	0000b917          	auipc	s2,0xb
    62f8:	19390913          	addi	s2,s2,403 # 11487 <threads+0x7ff>
    62fc:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
    6300:	4999                	li	s3,6
    6302:	a029                	j	630c <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
    6304:	0b048493          	addi	s1,s1,176
    6308:	01248b63          	beq	s1,s2,631e <twaitall+0xae>
        if (threads[i].state == EXITED)
    630c:	5cbc                	lw	a5,120(s1)
    630e:	ff379be3          	bne	a5,s3,6304 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
    6312:	8526                	mv	a0,s1
    6314:	00000097          	auipc	ra,0x0
    6318:	a78080e7          	jalr	-1416(ra) # 5d8c <reclaim_thread>
    631c:	b7e5                	j	6304 <twaitall+0x94>
        }
    }
}
    631e:	70a2                	ld	ra,40(sp)
    6320:	7402                	ld	s0,32(sp)
    6322:	64e2                	ld	s1,24(sp)
    6324:	6942                	ld	s2,16(sp)
    6326:	69a2                	ld	s3,8(sp)
    6328:	6145                	addi	sp,sp,48
    632a:	8082                	ret

000000000000632c <tswtch>:
    632c:	00153023          	sd	ra,0(a0)
    6330:	00253423          	sd	sp,8(a0)
    6334:	e900                	sd	s0,16(a0)
    6336:	ed04                	sd	s1,24(a0)
    6338:	03253023          	sd	s2,32(a0)
    633c:	03353423          	sd	s3,40(a0)
    6340:	03453823          	sd	s4,48(a0)
    6344:	03553c23          	sd	s5,56(a0)
    6348:	05653023          	sd	s6,64(a0)
    634c:	05753423          	sd	s7,72(a0)
    6350:	05853823          	sd	s8,80(a0)
    6354:	05953c23          	sd	s9,88(a0)
    6358:	07a53023          	sd	s10,96(a0)
    635c:	07b53423          	sd	s11,104(a0)
    6360:	0005b083          	ld	ra,0(a1)
    6364:	0085b103          	ld	sp,8(a1)
    6368:	6980                	ld	s0,16(a1)
    636a:	6d84                	ld	s1,24(a1)
    636c:	0205b903          	ld	s2,32(a1)
    6370:	0285b983          	ld	s3,40(a1)
    6374:	0305ba03          	ld	s4,48(a1)
    6378:	0385ba83          	ld	s5,56(a1)
    637c:	0405bb03          	ld	s6,64(a1)
    6380:	0485bb83          	ld	s7,72(a1)
    6384:	0505bc03          	ld	s8,80(a1)
    6388:	0585bc83          	ld	s9,88(a1)
    638c:	0605bd03          	ld	s10,96(a1)
    6390:	0685bd83          	ld	s11,104(a1)
    6394:	8082                	ret

0000000000006396 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
    6396:	1101                	addi	sp,sp,-32
    6398:	ec06                	sd	ra,24(sp)
    639a:	e822                	sd	s0,16(sp)
    639c:	e426                	sd	s1,8(sp)
    639e:	e04a                	sd	s2,0(sp)
    63a0:	1000                	addi	s0,sp,32
    63a2:	892a                	mv	s2,a0
    63a4:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
    63a6:	00000097          	auipc	ra,0x0
    63aa:	ea6080e7          	jalr	-346(ra) # 624c <twhoami>
    int res = main(argc, argv);
    63ae:	85a6                	mv	a1,s1
    63b0:	854a                	mv	a0,s2
    63b2:	fffff097          	auipc	ra,0xfffff
    63b6:	752080e7          	jalr	1874(ra) # 5b04 <main>
    63ba:	84aa                	mv	s1,a0
    twaitall();
    63bc:	00000097          	auipc	ra,0x0
    63c0:	eb4080e7          	jalr	-332(ra) # 6270 <twaitall>
    exit(res);
    63c4:	8526                	mv	a0,s1
    63c6:	00000097          	auipc	ra,0x0
    63ca:	296080e7          	jalr	662(ra) # 665c <exit>

00000000000063ce <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    63ce:	1141                	addi	sp,sp,-16
    63d0:	e406                	sd	ra,8(sp)
    63d2:	e022                	sd	s0,0(sp)
    63d4:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
    63d6:	87aa                	mv	a5,a0
    63d8:	0585                	addi	a1,a1,1
    63da:	0785                	addi	a5,a5,1
    63dc:	fff5c703          	lbu	a4,-1(a1)
    63e0:	fee78fa3          	sb	a4,-1(a5)
    63e4:	fb75                	bnez	a4,63d8 <strcpy+0xa>
        ;
    return os;
}
    63e6:	60a2                	ld	ra,8(sp)
    63e8:	6402                	ld	s0,0(sp)
    63ea:	0141                	addi	sp,sp,16
    63ec:	8082                	ret

00000000000063ee <strcmp>:

int strcmp(const char *p, const char *q)
{
    63ee:	1141                	addi	sp,sp,-16
    63f0:	e406                	sd	ra,8(sp)
    63f2:	e022                	sd	s0,0(sp)
    63f4:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    63f6:	00054783          	lbu	a5,0(a0)
    63fa:	cb91                	beqz	a5,640e <strcmp+0x20>
    63fc:	0005c703          	lbu	a4,0(a1)
    6400:	00f71763          	bne	a4,a5,640e <strcmp+0x20>
        p++, q++;
    6404:	0505                	addi	a0,a0,1
    6406:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    6408:	00054783          	lbu	a5,0(a0)
    640c:	fbe5                	bnez	a5,63fc <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
    640e:	0005c503          	lbu	a0,0(a1)
}
    6412:	40a7853b          	subw	a0,a5,a0
    6416:	60a2                	ld	ra,8(sp)
    6418:	6402                	ld	s0,0(sp)
    641a:	0141                	addi	sp,sp,16
    641c:	8082                	ret

000000000000641e <strlen>:

uint strlen(const char *s)
{
    641e:	1141                	addi	sp,sp,-16
    6420:	e406                	sd	ra,8(sp)
    6422:	e022                	sd	s0,0(sp)
    6424:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    6426:	00054783          	lbu	a5,0(a0)
    642a:	cf91                	beqz	a5,6446 <strlen+0x28>
    642c:	00150793          	addi	a5,a0,1
    6430:	86be                	mv	a3,a5
    6432:	0785                	addi	a5,a5,1
    6434:	fff7c703          	lbu	a4,-1(a5)
    6438:	ff65                	bnez	a4,6430 <strlen+0x12>
    643a:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
    643e:	60a2                	ld	ra,8(sp)
    6440:	6402                	ld	s0,0(sp)
    6442:	0141                	addi	sp,sp,16
    6444:	8082                	ret
    for (n = 0; s[n]; n++)
    6446:	4501                	li	a0,0
    6448:	bfdd                	j	643e <strlen+0x20>

000000000000644a <memset>:

void *
memset(void *dst, int c, uint n)
{
    644a:	1141                	addi	sp,sp,-16
    644c:	e406                	sd	ra,8(sp)
    644e:	e022                	sd	s0,0(sp)
    6450:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
    6452:	ca19                	beqz	a2,6468 <memset+0x1e>
    6454:	87aa                	mv	a5,a0
    6456:	1602                	slli	a2,a2,0x20
    6458:	9201                	srli	a2,a2,0x20
    645a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
    645e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
    6462:	0785                	addi	a5,a5,1
    6464:	fee79de3          	bne	a5,a4,645e <memset+0x14>
    }
    return dst;
}
    6468:	60a2                	ld	ra,8(sp)
    646a:	6402                	ld	s0,0(sp)
    646c:	0141                	addi	sp,sp,16
    646e:	8082                	ret

0000000000006470 <strchr>:

char *
strchr(const char *s, char c)
{
    6470:	1141                	addi	sp,sp,-16
    6472:	e406                	sd	ra,8(sp)
    6474:	e022                	sd	s0,0(sp)
    6476:	0800                	addi	s0,sp,16
    for (; *s; s++)
    6478:	00054783          	lbu	a5,0(a0)
    647c:	cf81                	beqz	a5,6494 <strchr+0x24>
        if (*s == c)
    647e:	00f58763          	beq	a1,a5,648c <strchr+0x1c>
    for (; *s; s++)
    6482:	0505                	addi	a0,a0,1
    6484:	00054783          	lbu	a5,0(a0)
    6488:	fbfd                	bnez	a5,647e <strchr+0xe>
            return (char *)s;
    return 0;
    648a:	4501                	li	a0,0
}
    648c:	60a2                	ld	ra,8(sp)
    648e:	6402                	ld	s0,0(sp)
    6490:	0141                	addi	sp,sp,16
    6492:	8082                	ret
    return 0;
    6494:	4501                	li	a0,0
    6496:	bfdd                	j	648c <strchr+0x1c>

0000000000006498 <gets>:

char *
gets(char *buf, int max)
{
    6498:	711d                	addi	sp,sp,-96
    649a:	ec86                	sd	ra,88(sp)
    649c:	e8a2                	sd	s0,80(sp)
    649e:	e4a6                	sd	s1,72(sp)
    64a0:	e0ca                	sd	s2,64(sp)
    64a2:	fc4e                	sd	s3,56(sp)
    64a4:	f852                	sd	s4,48(sp)
    64a6:	f456                	sd	s5,40(sp)
    64a8:	f05a                	sd	s6,32(sp)
    64aa:	ec5e                	sd	s7,24(sp)
    64ac:	e862                	sd	s8,16(sp)
    64ae:	1080                	addi	s0,sp,96
    64b0:	8baa                	mv	s7,a0
    64b2:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
    64b4:	892a                	mv	s2,a0
    64b6:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
    64b8:	faf40b13          	addi	s6,s0,-81
    64bc:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
    64be:	8c26                	mv	s8,s1
    64c0:	0014899b          	addiw	s3,s1,1
    64c4:	84ce                	mv	s1,s3
    64c6:	0349d663          	bge	s3,s4,64f2 <gets+0x5a>
        cc = read(0, &c, 1);
    64ca:	8656                	mv	a2,s5
    64cc:	85da                	mv	a1,s6
    64ce:	4501                	li	a0,0
    64d0:	00000097          	auipc	ra,0x0
    64d4:	1a4080e7          	jalr	420(ra) # 6674 <read>
        if (cc < 1)
    64d8:	00a05d63          	blez	a0,64f2 <gets+0x5a>
            break;
        buf[i++] = c;
    64dc:	faf44783          	lbu	a5,-81(s0)
    64e0:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
    64e4:	0905                	addi	s2,s2,1
    64e6:	ff678713          	addi	a4,a5,-10
    64ea:	c319                	beqz	a4,64f0 <gets+0x58>
    64ec:	17cd                	addi	a5,a5,-13
    64ee:	fbe1                	bnez	a5,64be <gets+0x26>
        buf[i++] = c;
    64f0:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
    64f2:	9c5e                	add	s8,s8,s7
    64f4:	000c0023          	sb	zero,0(s8)
    return buf;
}
    64f8:	855e                	mv	a0,s7
    64fa:	60e6                	ld	ra,88(sp)
    64fc:	6446                	ld	s0,80(sp)
    64fe:	64a6                	ld	s1,72(sp)
    6500:	6906                	ld	s2,64(sp)
    6502:	79e2                	ld	s3,56(sp)
    6504:	7a42                	ld	s4,48(sp)
    6506:	7aa2                	ld	s5,40(sp)
    6508:	7b02                	ld	s6,32(sp)
    650a:	6be2                	ld	s7,24(sp)
    650c:	6c42                	ld	s8,16(sp)
    650e:	6125                	addi	sp,sp,96
    6510:	8082                	ret

0000000000006512 <stat>:

int stat(const char *n, struct stat *st)
{
    6512:	1101                	addi	sp,sp,-32
    6514:	ec06                	sd	ra,24(sp)
    6516:	e822                	sd	s0,16(sp)
    6518:	e04a                	sd	s2,0(sp)
    651a:	1000                	addi	s0,sp,32
    651c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
    651e:	4581                	li	a1,0
    6520:	00000097          	auipc	ra,0x0
    6524:	17c080e7          	jalr	380(ra) # 669c <open>
    if (fd < 0)
    6528:	02054663          	bltz	a0,6554 <stat+0x42>
    652c:	e426                	sd	s1,8(sp)
    652e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
    6530:	85ca                	mv	a1,s2
    6532:	00000097          	auipc	ra,0x0
    6536:	182080e7          	jalr	386(ra) # 66b4 <fstat>
    653a:	892a                	mv	s2,a0
    close(fd);
    653c:	8526                	mv	a0,s1
    653e:	00000097          	auipc	ra,0x0
    6542:	146080e7          	jalr	326(ra) # 6684 <close>
    return r;
    6546:	64a2                	ld	s1,8(sp)
}
    6548:	854a                	mv	a0,s2
    654a:	60e2                	ld	ra,24(sp)
    654c:	6442                	ld	s0,16(sp)
    654e:	6902                	ld	s2,0(sp)
    6550:	6105                	addi	sp,sp,32
    6552:	8082                	ret
        return -1;
    6554:	57fd                	li	a5,-1
    6556:	893e                	mv	s2,a5
    6558:	bfc5                	j	6548 <stat+0x36>

000000000000655a <atoi>:

int atoi(const char *s)
{
    655a:	1141                	addi	sp,sp,-16
    655c:	e406                	sd	ra,8(sp)
    655e:	e022                	sd	s0,0(sp)
    6560:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    6562:	00054683          	lbu	a3,0(a0)
    6566:	fd06879b          	addiw	a5,a3,-48
    656a:	0ff7f793          	zext.b	a5,a5
    656e:	4625                	li	a2,9
    6570:	02f66963          	bltu	a2,a5,65a2 <atoi+0x48>
    6574:	872a                	mv	a4,a0
    n = 0;
    6576:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
    6578:	0705                	addi	a4,a4,1
    657a:	0025179b          	slliw	a5,a0,0x2
    657e:	9fa9                	addw	a5,a5,a0
    6580:	0017979b          	slliw	a5,a5,0x1
    6584:	9fb5                	addw	a5,a5,a3
    6586:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    658a:	00074683          	lbu	a3,0(a4)
    658e:	fd06879b          	addiw	a5,a3,-48
    6592:	0ff7f793          	zext.b	a5,a5
    6596:	fef671e3          	bgeu	a2,a5,6578 <atoi+0x1e>
    return n;
}
    659a:	60a2                	ld	ra,8(sp)
    659c:	6402                	ld	s0,0(sp)
    659e:	0141                	addi	sp,sp,16
    65a0:	8082                	ret
    n = 0;
    65a2:	4501                	li	a0,0
    65a4:	bfdd                	j	659a <atoi+0x40>

00000000000065a6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    65a6:	1141                	addi	sp,sp,-16
    65a8:	e406                	sd	ra,8(sp)
    65aa:	e022                	sd	s0,0(sp)
    65ac:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
    65ae:	02b57563          	bgeu	a0,a1,65d8 <memmove+0x32>
    {
        while (n-- > 0)
    65b2:	00c05f63          	blez	a2,65d0 <memmove+0x2a>
    65b6:	1602                	slli	a2,a2,0x20
    65b8:	9201                	srli	a2,a2,0x20
    65ba:	00c507b3          	add	a5,a0,a2
    dst = vdst;
    65be:	872a                	mv	a4,a0
            *dst++ = *src++;
    65c0:	0585                	addi	a1,a1,1
    65c2:	0705                	addi	a4,a4,1
    65c4:	fff5c683          	lbu	a3,-1(a1)
    65c8:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    65cc:	fee79ae3          	bne	a5,a4,65c0 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    65d0:	60a2                	ld	ra,8(sp)
    65d2:	6402                	ld	s0,0(sp)
    65d4:	0141                	addi	sp,sp,16
    65d6:	8082                	ret
        while (n-- > 0)
    65d8:	fec05ce3          	blez	a2,65d0 <memmove+0x2a>
        dst += n;
    65dc:	00c50733          	add	a4,a0,a2
        src += n;
    65e0:	95b2                	add	a1,a1,a2
    65e2:	fff6079b          	addiw	a5,a2,-1
    65e6:	1782                	slli	a5,a5,0x20
    65e8:	9381                	srli	a5,a5,0x20
    65ea:	fff7c793          	not	a5,a5
    65ee:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    65f0:	15fd                	addi	a1,a1,-1
    65f2:	177d                	addi	a4,a4,-1
    65f4:	0005c683          	lbu	a3,0(a1)
    65f8:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    65fc:	fef71ae3          	bne	a4,a5,65f0 <memmove+0x4a>
    6600:	bfc1                	j	65d0 <memmove+0x2a>

0000000000006602 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    6602:	1141                	addi	sp,sp,-16
    6604:	e406                	sd	ra,8(sp)
    6606:	e022                	sd	s0,0(sp)
    6608:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
    660a:	c61d                	beqz	a2,6638 <memcmp+0x36>
    660c:	1602                	slli	a2,a2,0x20
    660e:	9201                	srli	a2,a2,0x20
    6610:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
    6614:	00054783          	lbu	a5,0(a0)
    6618:	0005c703          	lbu	a4,0(a1)
    661c:	00e79863          	bne	a5,a4,662c <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
    6620:	0505                	addi	a0,a0,1
        p2++;
    6622:	0585                	addi	a1,a1,1
    while (n-- > 0)
    6624:	fed518e3          	bne	a0,a3,6614 <memcmp+0x12>
    }
    return 0;
    6628:	4501                	li	a0,0
    662a:	a019                	j	6630 <memcmp+0x2e>
            return *p1 - *p2;
    662c:	40e7853b          	subw	a0,a5,a4
}
    6630:	60a2                	ld	ra,8(sp)
    6632:	6402                	ld	s0,0(sp)
    6634:	0141                	addi	sp,sp,16
    6636:	8082                	ret
    return 0;
    6638:	4501                	li	a0,0
    663a:	bfdd                	j	6630 <memcmp+0x2e>

000000000000663c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    663c:	1141                	addi	sp,sp,-16
    663e:	e406                	sd	ra,8(sp)
    6640:	e022                	sd	s0,0(sp)
    6642:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    6644:	00000097          	auipc	ra,0x0
    6648:	f62080e7          	jalr	-158(ra) # 65a6 <memmove>
}
    664c:	60a2                	ld	ra,8(sp)
    664e:	6402                	ld	s0,0(sp)
    6650:	0141                	addi	sp,sp,16
    6652:	8082                	ret

0000000000006654 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    6654:	4885                	li	a7,1
 ecall
    6656:	00000073          	ecall
 ret
    665a:	8082                	ret

000000000000665c <exit>:
.global exit
exit:
 li a7, SYS_exit
    665c:	4889                	li	a7,2
 ecall
    665e:	00000073          	ecall
 ret
    6662:	8082                	ret

0000000000006664 <wait>:
.global wait
wait:
 li a7, SYS_wait
    6664:	488d                	li	a7,3
 ecall
    6666:	00000073          	ecall
 ret
    666a:	8082                	ret

000000000000666c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    666c:	4891                	li	a7,4
 ecall
    666e:	00000073          	ecall
 ret
    6672:	8082                	ret

0000000000006674 <read>:
.global read
read:
 li a7, SYS_read
    6674:	4895                	li	a7,5
 ecall
    6676:	00000073          	ecall
 ret
    667a:	8082                	ret

000000000000667c <write>:
.global write
write:
 li a7, SYS_write
    667c:	48c1                	li	a7,16
 ecall
    667e:	00000073          	ecall
 ret
    6682:	8082                	ret

0000000000006684 <close>:
.global close
close:
 li a7, SYS_close
    6684:	48d5                	li	a7,21
 ecall
    6686:	00000073          	ecall
 ret
    668a:	8082                	ret

000000000000668c <kill>:
.global kill
kill:
 li a7, SYS_kill
    668c:	4899                	li	a7,6
 ecall
    668e:	00000073          	ecall
 ret
    6692:	8082                	ret

0000000000006694 <exec>:
.global exec
exec:
 li a7, SYS_exec
    6694:	489d                	li	a7,7
 ecall
    6696:	00000073          	ecall
 ret
    669a:	8082                	ret

000000000000669c <open>:
.global open
open:
 li a7, SYS_open
    669c:	48bd                	li	a7,15
 ecall
    669e:	00000073          	ecall
 ret
    66a2:	8082                	ret

00000000000066a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    66a4:	48c5                	li	a7,17
 ecall
    66a6:	00000073          	ecall
 ret
    66aa:	8082                	ret

00000000000066ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    66ac:	48c9                	li	a7,18
 ecall
    66ae:	00000073          	ecall
 ret
    66b2:	8082                	ret

00000000000066b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    66b4:	48a1                	li	a7,8
 ecall
    66b6:	00000073          	ecall
 ret
    66ba:	8082                	ret

00000000000066bc <link>:
.global link
link:
 li a7, SYS_link
    66bc:	48cd                	li	a7,19
 ecall
    66be:	00000073          	ecall
 ret
    66c2:	8082                	ret

00000000000066c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    66c4:	48d1                	li	a7,20
 ecall
    66c6:	00000073          	ecall
 ret
    66ca:	8082                	ret

00000000000066cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    66cc:	48a5                	li	a7,9
 ecall
    66ce:	00000073          	ecall
 ret
    66d2:	8082                	ret

00000000000066d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    66d4:	48a9                	li	a7,10
 ecall
    66d6:	00000073          	ecall
 ret
    66da:	8082                	ret

00000000000066dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    66dc:	48ad                	li	a7,11
 ecall
    66de:	00000073          	ecall
 ret
    66e2:	8082                	ret

00000000000066e4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    66e4:	48b1                	li	a7,12
 ecall
    66e6:	00000073          	ecall
 ret
    66ea:	8082                	ret

00000000000066ec <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    66ec:	48b5                	li	a7,13
 ecall
    66ee:	00000073          	ecall
 ret
    66f2:	8082                	ret

00000000000066f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    66f4:	48b9                	li	a7,14
 ecall
    66f6:	00000073          	ecall
 ret
    66fa:	8082                	ret

00000000000066fc <ps>:
.global ps
ps:
 li a7, SYS_ps
    66fc:	48d9                	li	a7,22
 ecall
    66fe:	00000073          	ecall
 ret
    6702:	8082                	ret

0000000000006704 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    6704:	48dd                	li	a7,23
 ecall
    6706:	00000073          	ecall
 ret
    670a:	8082                	ret

000000000000670c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    670c:	48e1                	li	a7,24
 ecall
    670e:	00000073          	ecall
 ret
    6712:	8082                	ret

0000000000006714 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    6714:	1101                	addi	sp,sp,-32
    6716:	ec06                	sd	ra,24(sp)
    6718:	e822                	sd	s0,16(sp)
    671a:	1000                	addi	s0,sp,32
    671c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    6720:	4605                	li	a2,1
    6722:	fef40593          	addi	a1,s0,-17
    6726:	00000097          	auipc	ra,0x0
    672a:	f56080e7          	jalr	-170(ra) # 667c <write>
}
    672e:	60e2                	ld	ra,24(sp)
    6730:	6442                	ld	s0,16(sp)
    6732:	6105                	addi	sp,sp,32
    6734:	8082                	ret

0000000000006736 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    6736:	7139                	addi	sp,sp,-64
    6738:	fc06                	sd	ra,56(sp)
    673a:	f822                	sd	s0,48(sp)
    673c:	f04a                	sd	s2,32(sp)
    673e:	ec4e                	sd	s3,24(sp)
    6740:	0080                	addi	s0,sp,64
    6742:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    6744:	cad9                	beqz	a3,67da <printint+0xa4>
    6746:	01f5d79b          	srliw	a5,a1,0x1f
    674a:	cbc1                	beqz	a5,67da <printint+0xa4>
    neg = 1;
    x = -xx;
    674c:	40b005bb          	negw	a1,a1
    neg = 1;
    6750:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    6752:	fc040993          	addi	s3,s0,-64
  neg = 0;
    6756:	86ce                	mv	a3,s3
  i = 0;
    6758:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    675a:	00003817          	auipc	a6,0x3
    675e:	9ee80813          	addi	a6,a6,-1554 # 9148 <digits>
    6762:	88ba                	mv	a7,a4
    6764:	0017051b          	addiw	a0,a4,1
    6768:	872a                	mv	a4,a0
    676a:	02c5f7bb          	remuw	a5,a1,a2
    676e:	1782                	slli	a5,a5,0x20
    6770:	9381                	srli	a5,a5,0x20
    6772:	97c2                	add	a5,a5,a6
    6774:	0007c783          	lbu	a5,0(a5)
    6778:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    677c:	87ae                	mv	a5,a1
    677e:	02c5d5bb          	divuw	a1,a1,a2
    6782:	0685                	addi	a3,a3,1
    6784:	fcc7ffe3          	bgeu	a5,a2,6762 <printint+0x2c>
  if(neg)
    6788:	00030c63          	beqz	t1,67a0 <printint+0x6a>
    buf[i++] = '-';
    678c:	fd050793          	addi	a5,a0,-48
    6790:	00878533          	add	a0,a5,s0
    6794:	02d00793          	li	a5,45
    6798:	fef50823          	sb	a5,-16(a0)
    679c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    67a0:	02e05763          	blez	a4,67ce <printint+0x98>
    67a4:	f426                	sd	s1,40(sp)
    67a6:	377d                	addiw	a4,a4,-1
    67a8:	00e984b3          	add	s1,s3,a4
    67ac:	19fd                	addi	s3,s3,-1
    67ae:	99ba                	add	s3,s3,a4
    67b0:	1702                	slli	a4,a4,0x20
    67b2:	9301                	srli	a4,a4,0x20
    67b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    67b8:	0004c583          	lbu	a1,0(s1)
    67bc:	854a                	mv	a0,s2
    67be:	00000097          	auipc	ra,0x0
    67c2:	f56080e7          	jalr	-170(ra) # 6714 <putc>
  while(--i >= 0)
    67c6:	14fd                	addi	s1,s1,-1
    67c8:	ff3498e3          	bne	s1,s3,67b8 <printint+0x82>
    67cc:	74a2                	ld	s1,40(sp)
}
    67ce:	70e2                	ld	ra,56(sp)
    67d0:	7442                	ld	s0,48(sp)
    67d2:	7902                	ld	s2,32(sp)
    67d4:	69e2                	ld	s3,24(sp)
    67d6:	6121                	addi	sp,sp,64
    67d8:	8082                	ret
  neg = 0;
    67da:	4301                	li	t1,0
    67dc:	bf9d                	j	6752 <printint+0x1c>

00000000000067de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    67de:	715d                	addi	sp,sp,-80
    67e0:	e486                	sd	ra,72(sp)
    67e2:	e0a2                	sd	s0,64(sp)
    67e4:	f84a                	sd	s2,48(sp)
    67e6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    67e8:	0005c903          	lbu	s2,0(a1)
    67ec:	1a090b63          	beqz	s2,69a2 <vprintf+0x1c4>
    67f0:	fc26                	sd	s1,56(sp)
    67f2:	f44e                	sd	s3,40(sp)
    67f4:	f052                	sd	s4,32(sp)
    67f6:	ec56                	sd	s5,24(sp)
    67f8:	e85a                	sd	s6,16(sp)
    67fa:	e45e                	sd	s7,8(sp)
    67fc:	8aaa                	mv	s5,a0
    67fe:	8bb2                	mv	s7,a2
    6800:	00158493          	addi	s1,a1,1
  state = 0;
    6804:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    6806:	02500a13          	li	s4,37
    680a:	4b55                	li	s6,21
    680c:	a839                	j	682a <vprintf+0x4c>
        putc(fd, c);
    680e:	85ca                	mv	a1,s2
    6810:	8556                	mv	a0,s5
    6812:	00000097          	auipc	ra,0x0
    6816:	f02080e7          	jalr	-254(ra) # 6714 <putc>
    681a:	a019                	j	6820 <vprintf+0x42>
    } else if(state == '%'){
    681c:	01498d63          	beq	s3,s4,6836 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    6820:	0485                	addi	s1,s1,1
    6822:	fff4c903          	lbu	s2,-1(s1)
    6826:	16090863          	beqz	s2,6996 <vprintf+0x1b8>
    if(state == 0){
    682a:	fe0999e3          	bnez	s3,681c <vprintf+0x3e>
      if(c == '%'){
    682e:	ff4910e3          	bne	s2,s4,680e <vprintf+0x30>
        state = '%';
    6832:	89d2                	mv	s3,s4
    6834:	b7f5                	j	6820 <vprintf+0x42>
      if(c == 'd'){
    6836:	13490563          	beq	s2,s4,6960 <vprintf+0x182>
    683a:	f9d9079b          	addiw	a5,s2,-99
    683e:	0ff7f793          	zext.b	a5,a5
    6842:	12fb6863          	bltu	s6,a5,6972 <vprintf+0x194>
    6846:	f9d9079b          	addiw	a5,s2,-99
    684a:	0ff7f713          	zext.b	a4,a5
    684e:	12eb6263          	bltu	s6,a4,6972 <vprintf+0x194>
    6852:	00271793          	slli	a5,a4,0x2
    6856:	00003717          	auipc	a4,0x3
    685a:	89a70713          	addi	a4,a4,-1894 # 90f0 <malloc+0x265a>
    685e:	97ba                	add	a5,a5,a4
    6860:	439c                	lw	a5,0(a5)
    6862:	97ba                	add	a5,a5,a4
    6864:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    6866:	008b8913          	addi	s2,s7,8
    686a:	4685                	li	a3,1
    686c:	4629                	li	a2,10
    686e:	000ba583          	lw	a1,0(s7)
    6872:	8556                	mv	a0,s5
    6874:	00000097          	auipc	ra,0x0
    6878:	ec2080e7          	jalr	-318(ra) # 6736 <printint>
    687c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    687e:	4981                	li	s3,0
    6880:	b745                	j	6820 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    6882:	008b8913          	addi	s2,s7,8
    6886:	4681                	li	a3,0
    6888:	4629                	li	a2,10
    688a:	000ba583          	lw	a1,0(s7)
    688e:	8556                	mv	a0,s5
    6890:	00000097          	auipc	ra,0x0
    6894:	ea6080e7          	jalr	-346(ra) # 6736 <printint>
    6898:	8bca                	mv	s7,s2
      state = 0;
    689a:	4981                	li	s3,0
    689c:	b751                	j	6820 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    689e:	008b8913          	addi	s2,s7,8
    68a2:	4681                	li	a3,0
    68a4:	4641                	li	a2,16
    68a6:	000ba583          	lw	a1,0(s7)
    68aa:	8556                	mv	a0,s5
    68ac:	00000097          	auipc	ra,0x0
    68b0:	e8a080e7          	jalr	-374(ra) # 6736 <printint>
    68b4:	8bca                	mv	s7,s2
      state = 0;
    68b6:	4981                	li	s3,0
    68b8:	b7a5                	j	6820 <vprintf+0x42>
    68ba:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    68bc:	008b8793          	addi	a5,s7,8
    68c0:	8c3e                	mv	s8,a5
    68c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    68c6:	03000593          	li	a1,48
    68ca:	8556                	mv	a0,s5
    68cc:	00000097          	auipc	ra,0x0
    68d0:	e48080e7          	jalr	-440(ra) # 6714 <putc>
  putc(fd, 'x');
    68d4:	07800593          	li	a1,120
    68d8:	8556                	mv	a0,s5
    68da:	00000097          	auipc	ra,0x0
    68de:	e3a080e7          	jalr	-454(ra) # 6714 <putc>
    68e2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    68e4:	00003b97          	auipc	s7,0x3
    68e8:	864b8b93          	addi	s7,s7,-1948 # 9148 <digits>
    68ec:	03c9d793          	srli	a5,s3,0x3c
    68f0:	97de                	add	a5,a5,s7
    68f2:	0007c583          	lbu	a1,0(a5)
    68f6:	8556                	mv	a0,s5
    68f8:	00000097          	auipc	ra,0x0
    68fc:	e1c080e7          	jalr	-484(ra) # 6714 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    6900:	0992                	slli	s3,s3,0x4
    6902:	397d                	addiw	s2,s2,-1
    6904:	fe0914e3          	bnez	s2,68ec <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    6908:	8be2                	mv	s7,s8
      state = 0;
    690a:	4981                	li	s3,0
    690c:	6c02                	ld	s8,0(sp)
    690e:	bf09                	j	6820 <vprintf+0x42>
        s = va_arg(ap, char*);
    6910:	008b8993          	addi	s3,s7,8
    6914:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    6918:	02090163          	beqz	s2,693a <vprintf+0x15c>
        while(*s != 0){
    691c:	00094583          	lbu	a1,0(s2)
    6920:	c9a5                	beqz	a1,6990 <vprintf+0x1b2>
          putc(fd, *s);
    6922:	8556                	mv	a0,s5
    6924:	00000097          	auipc	ra,0x0
    6928:	df0080e7          	jalr	-528(ra) # 6714 <putc>
          s++;
    692c:	0905                	addi	s2,s2,1
        while(*s != 0){
    692e:	00094583          	lbu	a1,0(s2)
    6932:	f9e5                	bnez	a1,6922 <vprintf+0x144>
        s = va_arg(ap, char*);
    6934:	8bce                	mv	s7,s3
      state = 0;
    6936:	4981                	li	s3,0
    6938:	b5e5                	j	6820 <vprintf+0x42>
          s = "(null)";
    693a:	00002917          	auipc	s2,0x2
    693e:	78e90913          	addi	s2,s2,1934 # 90c8 <malloc+0x2632>
        while(*s != 0){
    6942:	02800593          	li	a1,40
    6946:	bff1                	j	6922 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    6948:	008b8913          	addi	s2,s7,8
    694c:	000bc583          	lbu	a1,0(s7)
    6950:	8556                	mv	a0,s5
    6952:	00000097          	auipc	ra,0x0
    6956:	dc2080e7          	jalr	-574(ra) # 6714 <putc>
    695a:	8bca                	mv	s7,s2
      state = 0;
    695c:	4981                	li	s3,0
    695e:	b5c9                	j	6820 <vprintf+0x42>
        putc(fd, c);
    6960:	02500593          	li	a1,37
    6964:	8556                	mv	a0,s5
    6966:	00000097          	auipc	ra,0x0
    696a:	dae080e7          	jalr	-594(ra) # 6714 <putc>
      state = 0;
    696e:	4981                	li	s3,0
    6970:	bd45                	j	6820 <vprintf+0x42>
        putc(fd, '%');
    6972:	02500593          	li	a1,37
    6976:	8556                	mv	a0,s5
    6978:	00000097          	auipc	ra,0x0
    697c:	d9c080e7          	jalr	-612(ra) # 6714 <putc>
        putc(fd, c);
    6980:	85ca                	mv	a1,s2
    6982:	8556                	mv	a0,s5
    6984:	00000097          	auipc	ra,0x0
    6988:	d90080e7          	jalr	-624(ra) # 6714 <putc>
      state = 0;
    698c:	4981                	li	s3,0
    698e:	bd49                	j	6820 <vprintf+0x42>
        s = va_arg(ap, char*);
    6990:	8bce                	mv	s7,s3
      state = 0;
    6992:	4981                	li	s3,0
    6994:	b571                	j	6820 <vprintf+0x42>
    6996:	74e2                	ld	s1,56(sp)
    6998:	79a2                	ld	s3,40(sp)
    699a:	7a02                	ld	s4,32(sp)
    699c:	6ae2                	ld	s5,24(sp)
    699e:	6b42                	ld	s6,16(sp)
    69a0:	6ba2                	ld	s7,8(sp)
    }
  }
}
    69a2:	60a6                	ld	ra,72(sp)
    69a4:	6406                	ld	s0,64(sp)
    69a6:	7942                	ld	s2,48(sp)
    69a8:	6161                	addi	sp,sp,80
    69aa:	8082                	ret

00000000000069ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    69ac:	715d                	addi	sp,sp,-80
    69ae:	ec06                	sd	ra,24(sp)
    69b0:	e822                	sd	s0,16(sp)
    69b2:	1000                	addi	s0,sp,32
    69b4:	e010                	sd	a2,0(s0)
    69b6:	e414                	sd	a3,8(s0)
    69b8:	e818                	sd	a4,16(s0)
    69ba:	ec1c                	sd	a5,24(s0)
    69bc:	03043023          	sd	a6,32(s0)
    69c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    69c4:	8622                	mv	a2,s0
    69c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    69ca:	00000097          	auipc	ra,0x0
    69ce:	e14080e7          	jalr	-492(ra) # 67de <vprintf>
}
    69d2:	60e2                	ld	ra,24(sp)
    69d4:	6442                	ld	s0,16(sp)
    69d6:	6161                	addi	sp,sp,80
    69d8:	8082                	ret

00000000000069da <printf>:

void
printf(const char *fmt, ...)
{
    69da:	711d                	addi	sp,sp,-96
    69dc:	ec06                	sd	ra,24(sp)
    69de:	e822                	sd	s0,16(sp)
    69e0:	1000                	addi	s0,sp,32
    69e2:	e40c                	sd	a1,8(s0)
    69e4:	e810                	sd	a2,16(s0)
    69e6:	ec14                	sd	a3,24(s0)
    69e8:	f018                	sd	a4,32(s0)
    69ea:	f41c                	sd	a5,40(s0)
    69ec:	03043823          	sd	a6,48(s0)
    69f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    69f4:	00840613          	addi	a2,s0,8
    69f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    69fc:	85aa                	mv	a1,a0
    69fe:	4505                	li	a0,1
    6a00:	00000097          	auipc	ra,0x0
    6a04:	dde080e7          	jalr	-546(ra) # 67de <vprintf>
}
    6a08:	60e2                	ld	ra,24(sp)
    6a0a:	6442                	ld	s0,16(sp)
    6a0c:	6125                	addi	sp,sp,96
    6a0e:	8082                	ret

0000000000006a10 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    6a10:	1141                	addi	sp,sp,-16
    6a12:	e406                	sd	ra,8(sp)
    6a14:	e022                	sd	s0,0(sp)
    6a16:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    6a18:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a1c:	00004797          	auipc	a5,0x4
    6a20:	a447b783          	ld	a5,-1468(a5) # a460 <freep>
    6a24:	a039                	j	6a32 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6a26:	6398                	ld	a4,0(a5)
    6a28:	00e7e463          	bltu	a5,a4,6a30 <free+0x20>
    6a2c:	00e6ea63          	bltu	a3,a4,6a40 <free+0x30>
{
    6a30:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a32:	fed7fae3          	bgeu	a5,a3,6a26 <free+0x16>
    6a36:	6398                	ld	a4,0(a5)
    6a38:	00e6e463          	bltu	a3,a4,6a40 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6a3c:	fee7eae3          	bltu	a5,a4,6a30 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    6a40:	ff852583          	lw	a1,-8(a0)
    6a44:	6390                	ld	a2,0(a5)
    6a46:	02059813          	slli	a6,a1,0x20
    6a4a:	01c85713          	srli	a4,a6,0x1c
    6a4e:	9736                	add	a4,a4,a3
    6a50:	02e60563          	beq	a2,a4,6a7a <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    6a54:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    6a58:	4790                	lw	a2,8(a5)
    6a5a:	02061593          	slli	a1,a2,0x20
    6a5e:	01c5d713          	srli	a4,a1,0x1c
    6a62:	973e                	add	a4,a4,a5
    6a64:	02e68263          	beq	a3,a4,6a88 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    6a68:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    6a6a:	00004717          	auipc	a4,0x4
    6a6e:	9ef73b23          	sd	a5,-1546(a4) # a460 <freep>
}
    6a72:	60a2                	ld	ra,8(sp)
    6a74:	6402                	ld	s0,0(sp)
    6a76:	0141                	addi	sp,sp,16
    6a78:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    6a7a:	4618                	lw	a4,8(a2)
    6a7c:	9f2d                	addw	a4,a4,a1
    6a7e:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    6a82:	6398                	ld	a4,0(a5)
    6a84:	6310                	ld	a2,0(a4)
    6a86:	b7f9                	j	6a54 <free+0x44>
        p->s.size += bp->s.size;
    6a88:	ff852703          	lw	a4,-8(a0)
    6a8c:	9f31                	addw	a4,a4,a2
    6a8e:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    6a90:	ff053683          	ld	a3,-16(a0)
    6a94:	bfd1                	j	6a68 <free+0x58>

0000000000006a96 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    6a96:	7139                	addi	sp,sp,-64
    6a98:	fc06                	sd	ra,56(sp)
    6a9a:	f822                	sd	s0,48(sp)
    6a9c:	f04a                	sd	s2,32(sp)
    6a9e:	ec4e                	sd	s3,24(sp)
    6aa0:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    6aa2:	02051993          	slli	s3,a0,0x20
    6aa6:	0209d993          	srli	s3,s3,0x20
    6aaa:	09bd                	addi	s3,s3,15
    6aac:	0049d993          	srli	s3,s3,0x4
    6ab0:	2985                	addiw	s3,s3,1
    6ab2:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    6ab4:	00004517          	auipc	a0,0x4
    6ab8:	9ac53503          	ld	a0,-1620(a0) # a460 <freep>
    6abc:	c905                	beqz	a0,6aec <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    6abe:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    6ac0:	4798                	lw	a4,8(a5)
    6ac2:	09377a63          	bgeu	a4,s3,6b56 <malloc+0xc0>
    6ac6:	f426                	sd	s1,40(sp)
    6ac8:	e852                	sd	s4,16(sp)
    6aca:	e456                	sd	s5,8(sp)
    6acc:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    6ace:	8a4e                	mv	s4,s3
    6ad0:	6705                	lui	a4,0x1
    6ad2:	00e9f363          	bgeu	s3,a4,6ad8 <malloc+0x42>
    6ad6:	6a05                	lui	s4,0x1
    6ad8:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    6adc:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    6ae0:	00004497          	auipc	s1,0x4
    6ae4:	98048493          	addi	s1,s1,-1664 # a460 <freep>
    if (p == (char *)-1)
    6ae8:	5afd                	li	s5,-1
    6aea:	a089                	j	6b2c <malloc+0x96>
    6aec:	f426                	sd	s1,40(sp)
    6aee:	e852                	sd	s4,16(sp)
    6af0:	e456                	sd	s5,8(sp)
    6af2:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    6af4:	0000b797          	auipc	a5,0xb
    6af8:	c9478793          	addi	a5,a5,-876 # 11788 <base>
    6afc:	00004717          	auipc	a4,0x4
    6b00:	96f73223          	sd	a5,-1692(a4) # a460 <freep>
    6b04:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    6b06:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    6b0a:	b7d1                	j	6ace <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    6b0c:	6398                	ld	a4,0(a5)
    6b0e:	e118                	sd	a4,0(a0)
    6b10:	a8b9                	j	6b6e <malloc+0xd8>
    hp->s.size = nu;
    6b12:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    6b16:	0541                	addi	a0,a0,16
    6b18:	00000097          	auipc	ra,0x0
    6b1c:	ef8080e7          	jalr	-264(ra) # 6a10 <free>
    return freep;
    6b20:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    6b22:	c135                	beqz	a0,6b86 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    6b24:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    6b26:	4798                	lw	a4,8(a5)
    6b28:	03277363          	bgeu	a4,s2,6b4e <malloc+0xb8>
        if (p == freep)
    6b2c:	6098                	ld	a4,0(s1)
    6b2e:	853e                	mv	a0,a5
    6b30:	fef71ae3          	bne	a4,a5,6b24 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    6b34:	8552                	mv	a0,s4
    6b36:	00000097          	auipc	ra,0x0
    6b3a:	bae080e7          	jalr	-1106(ra) # 66e4 <sbrk>
    if (p == (char *)-1)
    6b3e:	fd551ae3          	bne	a0,s5,6b12 <malloc+0x7c>
                return 0;
    6b42:	4501                	li	a0,0
    6b44:	74a2                	ld	s1,40(sp)
    6b46:	6a42                	ld	s4,16(sp)
    6b48:	6aa2                	ld	s5,8(sp)
    6b4a:	6b02                	ld	s6,0(sp)
    6b4c:	a03d                	j	6b7a <malloc+0xe4>
    6b4e:	74a2                	ld	s1,40(sp)
    6b50:	6a42                	ld	s4,16(sp)
    6b52:	6aa2                	ld	s5,8(sp)
    6b54:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    6b56:	fae90be3          	beq	s2,a4,6b0c <malloc+0x76>
                p->s.size -= nunits;
    6b5a:	4137073b          	subw	a4,a4,s3
    6b5e:	c798                	sw	a4,8(a5)
                p += p->s.size;
    6b60:	02071693          	slli	a3,a4,0x20
    6b64:	01c6d713          	srli	a4,a3,0x1c
    6b68:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    6b6a:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    6b6e:	00004717          	auipc	a4,0x4
    6b72:	8ea73923          	sd	a0,-1806(a4) # a460 <freep>
            return (void *)(p + 1);
    6b76:	01078513          	addi	a0,a5,16
    }
}
    6b7a:	70e2                	ld	ra,56(sp)
    6b7c:	7442                	ld	s0,48(sp)
    6b7e:	7902                	ld	s2,32(sp)
    6b80:	69e2                	ld	s3,24(sp)
    6b82:	6121                	addi	sp,sp,64
    6b84:	8082                	ret
    6b86:	74a2                	ld	s1,40(sp)
    6b88:	6a42                	ld	s4,16(sp)
    6b8a:	6aa2                	ld	s5,8(sp)
    6b8c:	6b02                	ld	s6,0(sp)
    6b8e:	b7f5                	j	6b7a <malloc+0xe4>
