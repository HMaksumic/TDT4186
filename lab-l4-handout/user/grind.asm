
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffc0e9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3bc61>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6c697>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1b405>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x28f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffb5d4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00003517          	auipc	a0,0x3
      9a:	f6a50513          	addi	a0,a0,-150 # 3000 <rand_next>
      9e:	00000097          	auipc	ra,0x0
      a2:	f62080e7          	jalr	-158(ra) # 0 <do_rand>
}
      a6:	60a2                	ld	ra,8(sp)
      a8:	6402                	ld	s0,0(sp)
      aa:	0141                	addi	sp,sp,16
      ac:	8082                	ret

00000000000000ae <go>:

void
go(int which_child)
{
      ae:	7171                	addi	sp,sp,-176
      b0:	f506                	sd	ra,168(sp)
      b2:	f122                	sd	s0,160(sp)
      b4:	ed26                	sd	s1,152(sp)
      b6:	1900                	addi	s0,sp,176
      b8:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      ba:	4501                	li	a0,0
      bc:	00001097          	auipc	ra,0x1
      c0:	6a6080e7          	jalr	1702(ra) # 1762 <sbrk>
      c4:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c8:	00002517          	auipc	a0,0x2
      cc:	b4850513          	addi	a0,a0,-1208 # 1c10 <malloc+0xfc>
      d0:	00001097          	auipc	ra,0x1
      d4:	672080e7          	jalr	1650(ra) # 1742 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00002517          	auipc	a0,0x2
      dc:	b3850513          	addi	a0,a0,-1224 # 1c10 <malloc+0xfc>
      e0:	00001097          	auipc	ra,0x1
      e4:	66a080e7          	jalr	1642(ra) # 174a <chdir>
      e8:	c905                	beqz	a0,118 <go+0x6a>
      ea:	e94a                	sd	s2,144(sp)
      ec:	e54e                	sd	s3,136(sp)
      ee:	e152                	sd	s4,128(sp)
      f0:	fcd6                	sd	s5,120(sp)
      f2:	f8da                	sd	s6,112(sp)
      f4:	f4de                	sd	s7,104(sp)
      f6:	f0e2                	sd	s8,96(sp)
      f8:	ece6                	sd	s9,88(sp)
      fa:	e8ea                	sd	s10,80(sp)
      fc:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      fe:	00002517          	auipc	a0,0x2
     102:	b1a50513          	addi	a0,a0,-1254 # 1c18 <malloc+0x104>
     106:	00002097          	auipc	ra,0x2
     10a:	952080e7          	jalr	-1710(ra) # 1a58 <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00001097          	auipc	ra,0x1
     114:	5ca080e7          	jalr	1482(ra) # 16da <exit>
     118:	e94a                	sd	s2,144(sp)
     11a:	e54e                	sd	s3,136(sp)
     11c:	e152                	sd	s4,128(sp)
     11e:	fcd6                	sd	s5,120(sp)
     120:	f8da                	sd	s6,112(sp)
     122:	f4de                	sd	s7,104(sp)
     124:	f0e2                	sd	s8,96(sp)
     126:	ece6                	sd	s9,88(sp)
     128:	e8ea                	sd	s10,80(sp)
     12a:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     12c:	00002517          	auipc	a0,0x2
     130:	b1450513          	addi	a0,a0,-1260 # 1c40 <malloc+0x12c>
     134:	00001097          	auipc	ra,0x1
     138:	616080e7          	jalr	1558(ra) # 174a <chdir>
     13c:	00002c17          	auipc	s8,0x2
     140:	b14c0c13          	addi	s8,s8,-1260 # 1c50 <malloc+0x13c>
     144:	c489                	beqz	s1,14e <go+0xa0>
     146:	00002c17          	auipc	s8,0x2
     14a:	b02c0c13          	addi	s8,s8,-1278 # 1c48 <malloc+0x134>
  uint64 iters = 0;
     14e:	4481                	li	s1,0
  int fd = -1;
     150:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     152:	106259b7          	lui	s3,0x10625
     156:	dd398993          	addi	s3,s3,-557 # 10624dd3 <base+0x10620ebb>
     15a:	09be                	slli	s3,s3,0xf
     15c:	8d598993          	addi	s3,s3,-1835
     160:	09ca                	slli	s3,s3,0x12
     162:	80098993          	addi	s3,s3,-2048
     166:	fcf98993          	addi	s3,s3,-49
     16a:	1f400b93          	li	s7,500
      write(1, which_child?"B":"A", 1);
     16e:	4a05                	li	s4,1
    int what = rand() % 23;
     170:	b2164ab7          	lui	s5,0xb2164
     174:	2c9a8a93          	addi	s5,s5,713 # ffffffffb21642c9 <base+0xffffffffb21603b1>
     178:	4b59                	li	s6,22
     17a:	00002917          	auipc	s2,0x2
     17e:	e8690913          	addi	s2,s2,-378 # 2000 <malloc+0x4ec>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     182:	f6840d93          	addi	s11,s0,-152
     186:	a839                	j	1a4 <go+0xf6>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     188:	20200593          	li	a1,514
     18c:	00002517          	auipc	a0,0x2
     190:	acc50513          	addi	a0,a0,-1332 # 1c58 <malloc+0x144>
     194:	00001097          	auipc	ra,0x1
     198:	586080e7          	jalr	1414(ra) # 171a <open>
     19c:	00001097          	auipc	ra,0x1
     1a0:	566080e7          	jalr	1382(ra) # 1702 <close>
    iters++;
     1a4:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     1a6:	0024d793          	srli	a5,s1,0x2
     1aa:	0337b7b3          	mulhu	a5,a5,s3
     1ae:	8391                	srli	a5,a5,0x4
     1b0:	037787b3          	mul	a5,a5,s7
     1b4:	00f49963          	bne	s1,a5,1c6 <go+0x118>
      write(1, which_child?"B":"A", 1);
     1b8:	8652                	mv	a2,s4
     1ba:	85e2                	mv	a1,s8
     1bc:	8552                	mv	a0,s4
     1be:	00001097          	auipc	ra,0x1
     1c2:	53c080e7          	jalr	1340(ra) # 16fa <write>
    int what = rand() % 23;
     1c6:	00000097          	auipc	ra,0x0
     1ca:	ec8080e7          	jalr	-312(ra) # 8e <rand>
     1ce:	035507b3          	mul	a5,a0,s5
     1d2:	9381                	srli	a5,a5,0x20
     1d4:	9fa9                	addw	a5,a5,a0
     1d6:	4047d79b          	sraiw	a5,a5,0x4
     1da:	41f5571b          	sraiw	a4,a0,0x1f
     1de:	9f99                	subw	a5,a5,a4
     1e0:	0017971b          	slliw	a4,a5,0x1
     1e4:	9f3d                	addw	a4,a4,a5
     1e6:	0037171b          	slliw	a4,a4,0x3
     1ea:	40f707bb          	subw	a5,a4,a5
     1ee:	9d1d                	subw	a0,a0,a5
     1f0:	faab6ae3          	bltu	s6,a0,1a4 <go+0xf6>
     1f4:	02051793          	slli	a5,a0,0x20
     1f8:	01e7d513          	srli	a0,a5,0x1e
     1fc:	954a                	add	a0,a0,s2
     1fe:	411c                	lw	a5,0(a0)
     200:	97ca                	add	a5,a5,s2
     202:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     204:	20200593          	li	a1,514
     208:	00002517          	auipc	a0,0x2
     20c:	a6050513          	addi	a0,a0,-1440 # 1c68 <malloc+0x154>
     210:	00001097          	auipc	ra,0x1
     214:	50a080e7          	jalr	1290(ra) # 171a <open>
     218:	00001097          	auipc	ra,0x1
     21c:	4ea080e7          	jalr	1258(ra) # 1702 <close>
     220:	b751                	j	1a4 <go+0xf6>
      unlink("grindir/../a");
     222:	00002517          	auipc	a0,0x2
     226:	a3650513          	addi	a0,a0,-1482 # 1c58 <malloc+0x144>
     22a:	00001097          	auipc	ra,0x1
     22e:	500080e7          	jalr	1280(ra) # 172a <unlink>
     232:	bf8d                	j	1a4 <go+0xf6>
      if(chdir("grindir") != 0){
     234:	00002517          	auipc	a0,0x2
     238:	9dc50513          	addi	a0,a0,-1572 # 1c10 <malloc+0xfc>
     23c:	00001097          	auipc	ra,0x1
     240:	50e080e7          	jalr	1294(ra) # 174a <chdir>
     244:	e115                	bnez	a0,268 <go+0x1ba>
      unlink("../b");
     246:	00002517          	auipc	a0,0x2
     24a:	a3a50513          	addi	a0,a0,-1478 # 1c80 <malloc+0x16c>
     24e:	00001097          	auipc	ra,0x1
     252:	4dc080e7          	jalr	1244(ra) # 172a <unlink>
      chdir("/");
     256:	00002517          	auipc	a0,0x2
     25a:	9ea50513          	addi	a0,a0,-1558 # 1c40 <malloc+0x12c>
     25e:	00001097          	auipc	ra,0x1
     262:	4ec080e7          	jalr	1260(ra) # 174a <chdir>
     266:	bf3d                	j	1a4 <go+0xf6>
        printf("grind: chdir grindir failed\n");
     268:	00002517          	auipc	a0,0x2
     26c:	9b050513          	addi	a0,a0,-1616 # 1c18 <malloc+0x104>
     270:	00001097          	auipc	ra,0x1
     274:	7e8080e7          	jalr	2024(ra) # 1a58 <printf>
        exit(1);
     278:	4505                	li	a0,1
     27a:	00001097          	auipc	ra,0x1
     27e:	460080e7          	jalr	1120(ra) # 16da <exit>
      close(fd);
     282:	8566                	mv	a0,s9
     284:	00001097          	auipc	ra,0x1
     288:	47e080e7          	jalr	1150(ra) # 1702 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     28c:	20200593          	li	a1,514
     290:	00002517          	auipc	a0,0x2
     294:	9f850513          	addi	a0,a0,-1544 # 1c88 <malloc+0x174>
     298:	00001097          	auipc	ra,0x1
     29c:	482080e7          	jalr	1154(ra) # 171a <open>
     2a0:	8caa                	mv	s9,a0
     2a2:	b709                	j	1a4 <go+0xf6>
      close(fd);
     2a4:	8566                	mv	a0,s9
     2a6:	00001097          	auipc	ra,0x1
     2aa:	45c080e7          	jalr	1116(ra) # 1702 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2ae:	20200593          	li	a1,514
     2b2:	00002517          	auipc	a0,0x2
     2b6:	9e650513          	addi	a0,a0,-1562 # 1c98 <malloc+0x184>
     2ba:	00001097          	auipc	ra,0x1
     2be:	460080e7          	jalr	1120(ra) # 171a <open>
     2c2:	8caa                	mv	s9,a0
     2c4:	b5c5                	j	1a4 <go+0xf6>
      write(fd, buf, sizeof(buf));
     2c6:	3e700613          	li	a2,999
     2ca:	00003597          	auipc	a1,0x3
     2ce:	d6658593          	addi	a1,a1,-666 # 3030 <buf.0>
     2d2:	8566                	mv	a0,s9
     2d4:	00001097          	auipc	ra,0x1
     2d8:	426080e7          	jalr	1062(ra) # 16fa <write>
     2dc:	b5e1                	j	1a4 <go+0xf6>
      read(fd, buf, sizeof(buf));
     2de:	3e700613          	li	a2,999
     2e2:	00003597          	auipc	a1,0x3
     2e6:	d4e58593          	addi	a1,a1,-690 # 3030 <buf.0>
     2ea:	8566                	mv	a0,s9
     2ec:	00001097          	auipc	ra,0x1
     2f0:	406080e7          	jalr	1030(ra) # 16f2 <read>
     2f4:	bd45                	j	1a4 <go+0xf6>
      mkdir("grindir/../a");
     2f6:	00002517          	auipc	a0,0x2
     2fa:	96250513          	addi	a0,a0,-1694 # 1c58 <malloc+0x144>
     2fe:	00001097          	auipc	ra,0x1
     302:	444080e7          	jalr	1092(ra) # 1742 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     306:	20200593          	li	a1,514
     30a:	00002517          	auipc	a0,0x2
     30e:	9a650513          	addi	a0,a0,-1626 # 1cb0 <malloc+0x19c>
     312:	00001097          	auipc	ra,0x1
     316:	408080e7          	jalr	1032(ra) # 171a <open>
     31a:	00001097          	auipc	ra,0x1
     31e:	3e8080e7          	jalr	1000(ra) # 1702 <close>
      unlink("a/a");
     322:	00002517          	auipc	a0,0x2
     326:	99e50513          	addi	a0,a0,-1634 # 1cc0 <malloc+0x1ac>
     32a:	00001097          	auipc	ra,0x1
     32e:	400080e7          	jalr	1024(ra) # 172a <unlink>
     332:	bd8d                	j	1a4 <go+0xf6>
      mkdir("/../b");
     334:	00002517          	auipc	a0,0x2
     338:	99450513          	addi	a0,a0,-1644 # 1cc8 <malloc+0x1b4>
     33c:	00001097          	auipc	ra,0x1
     340:	406080e7          	jalr	1030(ra) # 1742 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     344:	20200593          	li	a1,514
     348:	00002517          	auipc	a0,0x2
     34c:	98850513          	addi	a0,a0,-1656 # 1cd0 <malloc+0x1bc>
     350:	00001097          	auipc	ra,0x1
     354:	3ca080e7          	jalr	970(ra) # 171a <open>
     358:	00001097          	auipc	ra,0x1
     35c:	3aa080e7          	jalr	938(ra) # 1702 <close>
      unlink("b/b");
     360:	00002517          	auipc	a0,0x2
     364:	98050513          	addi	a0,a0,-1664 # 1ce0 <malloc+0x1cc>
     368:	00001097          	auipc	ra,0x1
     36c:	3c2080e7          	jalr	962(ra) # 172a <unlink>
     370:	bd15                	j	1a4 <go+0xf6>
      unlink("b");
     372:	00002517          	auipc	a0,0x2
     376:	97650513          	addi	a0,a0,-1674 # 1ce8 <malloc+0x1d4>
     37a:	00001097          	auipc	ra,0x1
     37e:	3b0080e7          	jalr	944(ra) # 172a <unlink>
      link("../grindir/./../a", "../b");
     382:	00002597          	auipc	a1,0x2
     386:	8fe58593          	addi	a1,a1,-1794 # 1c80 <malloc+0x16c>
     38a:	00002517          	auipc	a0,0x2
     38e:	96650513          	addi	a0,a0,-1690 # 1cf0 <malloc+0x1dc>
     392:	00001097          	auipc	ra,0x1
     396:	3a8080e7          	jalr	936(ra) # 173a <link>
     39a:	b529                	j	1a4 <go+0xf6>
      unlink("../grindir/../a");
     39c:	00002517          	auipc	a0,0x2
     3a0:	96c50513          	addi	a0,a0,-1684 # 1d08 <malloc+0x1f4>
     3a4:	00001097          	auipc	ra,0x1
     3a8:	386080e7          	jalr	902(ra) # 172a <unlink>
      link(".././b", "/grindir/../a");
     3ac:	00002597          	auipc	a1,0x2
     3b0:	8dc58593          	addi	a1,a1,-1828 # 1c88 <malloc+0x174>
     3b4:	00002517          	auipc	a0,0x2
     3b8:	96450513          	addi	a0,a0,-1692 # 1d18 <malloc+0x204>
     3bc:	00001097          	auipc	ra,0x1
     3c0:	37e080e7          	jalr	894(ra) # 173a <link>
     3c4:	b3c5                	j	1a4 <go+0xf6>
      int pid = fork();
     3c6:	00001097          	auipc	ra,0x1
     3ca:	30c080e7          	jalr	780(ra) # 16d2 <fork>
      if(pid == 0){
     3ce:	c909                	beqz	a0,3e0 <go+0x332>
      } else if(pid < 0){
     3d0:	00054c63          	bltz	a0,3e8 <go+0x33a>
      wait(0);
     3d4:	4501                	li	a0,0
     3d6:	00001097          	auipc	ra,0x1
     3da:	30c080e7          	jalr	780(ra) # 16e2 <wait>
     3de:	b3d9                	j	1a4 <go+0xf6>
        exit(0);
     3e0:	00001097          	auipc	ra,0x1
     3e4:	2fa080e7          	jalr	762(ra) # 16da <exit>
        printf("grind: fork failed\n");
     3e8:	00002517          	auipc	a0,0x2
     3ec:	93850513          	addi	a0,a0,-1736 # 1d20 <malloc+0x20c>
     3f0:	00001097          	auipc	ra,0x1
     3f4:	668080e7          	jalr	1640(ra) # 1a58 <printf>
        exit(1);
     3f8:	4505                	li	a0,1
     3fa:	00001097          	auipc	ra,0x1
     3fe:	2e0080e7          	jalr	736(ra) # 16da <exit>
      int pid = fork();
     402:	00001097          	auipc	ra,0x1
     406:	2d0080e7          	jalr	720(ra) # 16d2 <fork>
      if(pid == 0){
     40a:	c909                	beqz	a0,41c <go+0x36e>
      } else if(pid < 0){
     40c:	02054563          	bltz	a0,436 <go+0x388>
      wait(0);
     410:	4501                	li	a0,0
     412:	00001097          	auipc	ra,0x1
     416:	2d0080e7          	jalr	720(ra) # 16e2 <wait>
     41a:	b369                	j	1a4 <go+0xf6>
        fork();
     41c:	00001097          	auipc	ra,0x1
     420:	2b6080e7          	jalr	694(ra) # 16d2 <fork>
        fork();
     424:	00001097          	auipc	ra,0x1
     428:	2ae080e7          	jalr	686(ra) # 16d2 <fork>
        exit(0);
     42c:	4501                	li	a0,0
     42e:	00001097          	auipc	ra,0x1
     432:	2ac080e7          	jalr	684(ra) # 16da <exit>
        printf("grind: fork failed\n");
     436:	00002517          	auipc	a0,0x2
     43a:	8ea50513          	addi	a0,a0,-1814 # 1d20 <malloc+0x20c>
     43e:	00001097          	auipc	ra,0x1
     442:	61a080e7          	jalr	1562(ra) # 1a58 <printf>
        exit(1);
     446:	4505                	li	a0,1
     448:	00001097          	auipc	ra,0x1
     44c:	292080e7          	jalr	658(ra) # 16da <exit>
      sbrk(6011);
     450:	6505                	lui	a0,0x1
     452:	77b50513          	addi	a0,a0,1915 # 177b <ps+0x1>
     456:	00001097          	auipc	ra,0x1
     45a:	30c080e7          	jalr	780(ra) # 1762 <sbrk>
     45e:	b399                	j	1a4 <go+0xf6>
      if(sbrk(0) > break0)
     460:	4501                	li	a0,0
     462:	00001097          	auipc	ra,0x1
     466:	300080e7          	jalr	768(ra) # 1762 <sbrk>
     46a:	f5843783          	ld	a5,-168(s0)
     46e:	d2a7fbe3          	bgeu	a5,a0,1a4 <go+0xf6>
        sbrk(-(sbrk(0) - break0));
     472:	4501                	li	a0,0
     474:	00001097          	auipc	ra,0x1
     478:	2ee080e7          	jalr	750(ra) # 1762 <sbrk>
     47c:	f5843783          	ld	a5,-168(s0)
     480:	40a7853b          	subw	a0,a5,a0
     484:	00001097          	auipc	ra,0x1
     488:	2de080e7          	jalr	734(ra) # 1762 <sbrk>
     48c:	bb21                	j	1a4 <go+0xf6>
      int pid = fork();
     48e:	00001097          	auipc	ra,0x1
     492:	244080e7          	jalr	580(ra) # 16d2 <fork>
     496:	8d2a                	mv	s10,a0
      if(pid == 0){
     498:	c51d                	beqz	a0,4c6 <go+0x418>
      } else if(pid < 0){
     49a:	04054963          	bltz	a0,4ec <go+0x43e>
      if(chdir("../grindir/..") != 0){
     49e:	00002517          	auipc	a0,0x2
     4a2:	8a250513          	addi	a0,a0,-1886 # 1d40 <malloc+0x22c>
     4a6:	00001097          	auipc	ra,0x1
     4aa:	2a4080e7          	jalr	676(ra) # 174a <chdir>
     4ae:	ed21                	bnez	a0,506 <go+0x458>
      kill(pid);
     4b0:	856a                	mv	a0,s10
     4b2:	00001097          	auipc	ra,0x1
     4b6:	258080e7          	jalr	600(ra) # 170a <kill>
      wait(0);
     4ba:	4501                	li	a0,0
     4bc:	00001097          	auipc	ra,0x1
     4c0:	226080e7          	jalr	550(ra) # 16e2 <wait>
     4c4:	b1c5                	j	1a4 <go+0xf6>
        close(open("a", O_CREATE|O_RDWR));
     4c6:	20200593          	li	a1,514
     4ca:	00002517          	auipc	a0,0x2
     4ce:	86e50513          	addi	a0,a0,-1938 # 1d38 <malloc+0x224>
     4d2:	00001097          	auipc	ra,0x1
     4d6:	248080e7          	jalr	584(ra) # 171a <open>
     4da:	00001097          	auipc	ra,0x1
     4de:	228080e7          	jalr	552(ra) # 1702 <close>
        exit(0);
     4e2:	4501                	li	a0,0
     4e4:	00001097          	auipc	ra,0x1
     4e8:	1f6080e7          	jalr	502(ra) # 16da <exit>
        printf("grind: fork failed\n");
     4ec:	00002517          	auipc	a0,0x2
     4f0:	83450513          	addi	a0,a0,-1996 # 1d20 <malloc+0x20c>
     4f4:	00001097          	auipc	ra,0x1
     4f8:	564080e7          	jalr	1380(ra) # 1a58 <printf>
        exit(1);
     4fc:	4505                	li	a0,1
     4fe:	00001097          	auipc	ra,0x1
     502:	1dc080e7          	jalr	476(ra) # 16da <exit>
        printf("grind: chdir failed\n");
     506:	00002517          	auipc	a0,0x2
     50a:	84a50513          	addi	a0,a0,-1974 # 1d50 <malloc+0x23c>
     50e:	00001097          	auipc	ra,0x1
     512:	54a080e7          	jalr	1354(ra) # 1a58 <printf>
        exit(1);
     516:	4505                	li	a0,1
     518:	00001097          	auipc	ra,0x1
     51c:	1c2080e7          	jalr	450(ra) # 16da <exit>
      int pid = fork();
     520:	00001097          	auipc	ra,0x1
     524:	1b2080e7          	jalr	434(ra) # 16d2 <fork>
      if(pid == 0){
     528:	c909                	beqz	a0,53a <go+0x48c>
      } else if(pid < 0){
     52a:	02054563          	bltz	a0,554 <go+0x4a6>
      wait(0);
     52e:	4501                	li	a0,0
     530:	00001097          	auipc	ra,0x1
     534:	1b2080e7          	jalr	434(ra) # 16e2 <wait>
     538:	b1b5                	j	1a4 <go+0xf6>
        kill(getpid());
     53a:	00001097          	auipc	ra,0x1
     53e:	220080e7          	jalr	544(ra) # 175a <getpid>
     542:	00001097          	auipc	ra,0x1
     546:	1c8080e7          	jalr	456(ra) # 170a <kill>
        exit(0);
     54a:	4501                	li	a0,0
     54c:	00001097          	auipc	ra,0x1
     550:	18e080e7          	jalr	398(ra) # 16da <exit>
        printf("grind: fork failed\n");
     554:	00001517          	auipc	a0,0x1
     558:	7cc50513          	addi	a0,a0,1996 # 1d20 <malloc+0x20c>
     55c:	00001097          	auipc	ra,0x1
     560:	4fc080e7          	jalr	1276(ra) # 1a58 <printf>
        exit(1);
     564:	4505                	li	a0,1
     566:	00001097          	auipc	ra,0x1
     56a:	174080e7          	jalr	372(ra) # 16da <exit>
      if(pipe(fds) < 0){
     56e:	f7840513          	addi	a0,s0,-136
     572:	00001097          	auipc	ra,0x1
     576:	178080e7          	jalr	376(ra) # 16ea <pipe>
     57a:	02054b63          	bltz	a0,5b0 <go+0x502>
      int pid = fork();
     57e:	00001097          	auipc	ra,0x1
     582:	154080e7          	jalr	340(ra) # 16d2 <fork>
      if(pid == 0){
     586:	c131                	beqz	a0,5ca <go+0x51c>
      } else if(pid < 0){
     588:	0a054a63          	bltz	a0,63c <go+0x58e>
      close(fds[0]);
     58c:	f7842503          	lw	a0,-136(s0)
     590:	00001097          	auipc	ra,0x1
     594:	172080e7          	jalr	370(ra) # 1702 <close>
      close(fds[1]);
     598:	f7c42503          	lw	a0,-132(s0)
     59c:	00001097          	auipc	ra,0x1
     5a0:	166080e7          	jalr	358(ra) # 1702 <close>
      wait(0);
     5a4:	4501                	li	a0,0
     5a6:	00001097          	auipc	ra,0x1
     5aa:	13c080e7          	jalr	316(ra) # 16e2 <wait>
     5ae:	bedd                	j	1a4 <go+0xf6>
        printf("grind: pipe failed\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	7b850513          	addi	a0,a0,1976 # 1d68 <malloc+0x254>
     5b8:	00001097          	auipc	ra,0x1
     5bc:	4a0080e7          	jalr	1184(ra) # 1a58 <printf>
        exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00001097          	auipc	ra,0x1
     5c6:	118080e7          	jalr	280(ra) # 16da <exit>
        fork();
     5ca:	00001097          	auipc	ra,0x1
     5ce:	108080e7          	jalr	264(ra) # 16d2 <fork>
        fork();
     5d2:	00001097          	auipc	ra,0x1
     5d6:	100080e7          	jalr	256(ra) # 16d2 <fork>
        if(write(fds[1], "x", 1) != 1)
     5da:	4605                	li	a2,1
     5dc:	00001597          	auipc	a1,0x1
     5e0:	7a458593          	addi	a1,a1,1956 # 1d80 <malloc+0x26c>
     5e4:	f7c42503          	lw	a0,-132(s0)
     5e8:	00001097          	auipc	ra,0x1
     5ec:	112080e7          	jalr	274(ra) # 16fa <write>
     5f0:	4785                	li	a5,1
     5f2:	02f51363          	bne	a0,a5,618 <go+0x56a>
        if(read(fds[0], &c, 1) != 1)
     5f6:	4605                	li	a2,1
     5f8:	f7040593          	addi	a1,s0,-144
     5fc:	f7842503          	lw	a0,-136(s0)
     600:	00001097          	auipc	ra,0x1
     604:	0f2080e7          	jalr	242(ra) # 16f2 <read>
     608:	4785                	li	a5,1
     60a:	02f51063          	bne	a0,a5,62a <go+0x57c>
        exit(0);
     60e:	4501                	li	a0,0
     610:	00001097          	auipc	ra,0x1
     614:	0ca080e7          	jalr	202(ra) # 16da <exit>
          printf("grind: pipe write failed\n");
     618:	00001517          	auipc	a0,0x1
     61c:	77050513          	addi	a0,a0,1904 # 1d88 <malloc+0x274>
     620:	00001097          	auipc	ra,0x1
     624:	438080e7          	jalr	1080(ra) # 1a58 <printf>
     628:	b7f9                	j	5f6 <go+0x548>
          printf("grind: pipe read failed\n");
     62a:	00001517          	auipc	a0,0x1
     62e:	77e50513          	addi	a0,a0,1918 # 1da8 <malloc+0x294>
     632:	00001097          	auipc	ra,0x1
     636:	426080e7          	jalr	1062(ra) # 1a58 <printf>
     63a:	bfd1                	j	60e <go+0x560>
        printf("grind: fork failed\n");
     63c:	00001517          	auipc	a0,0x1
     640:	6e450513          	addi	a0,a0,1764 # 1d20 <malloc+0x20c>
     644:	00001097          	auipc	ra,0x1
     648:	414080e7          	jalr	1044(ra) # 1a58 <printf>
        exit(1);
     64c:	4505                	li	a0,1
     64e:	00001097          	auipc	ra,0x1
     652:	08c080e7          	jalr	140(ra) # 16da <exit>
      int pid = fork();
     656:	00001097          	auipc	ra,0x1
     65a:	07c080e7          	jalr	124(ra) # 16d2 <fork>
      if(pid == 0){
     65e:	c909                	beqz	a0,670 <go+0x5c2>
      } else if(pid < 0){
     660:	06054f63          	bltz	a0,6de <go+0x630>
      wait(0);
     664:	4501                	li	a0,0
     666:	00001097          	auipc	ra,0x1
     66a:	07c080e7          	jalr	124(ra) # 16e2 <wait>
     66e:	be1d                	j	1a4 <go+0xf6>
        unlink("a");
     670:	00001517          	auipc	a0,0x1
     674:	6c850513          	addi	a0,a0,1736 # 1d38 <malloc+0x224>
     678:	00001097          	auipc	ra,0x1
     67c:	0b2080e7          	jalr	178(ra) # 172a <unlink>
        mkdir("a");
     680:	00001517          	auipc	a0,0x1
     684:	6b850513          	addi	a0,a0,1720 # 1d38 <malloc+0x224>
     688:	00001097          	auipc	ra,0x1
     68c:	0ba080e7          	jalr	186(ra) # 1742 <mkdir>
        chdir("a");
     690:	00001517          	auipc	a0,0x1
     694:	6a850513          	addi	a0,a0,1704 # 1d38 <malloc+0x224>
     698:	00001097          	auipc	ra,0x1
     69c:	0b2080e7          	jalr	178(ra) # 174a <chdir>
        unlink("../a");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	72850513          	addi	a0,a0,1832 # 1dc8 <malloc+0x2b4>
     6a8:	00001097          	auipc	ra,0x1
     6ac:	082080e7          	jalr	130(ra) # 172a <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6b0:	20200593          	li	a1,514
     6b4:	00001517          	auipc	a0,0x1
     6b8:	6cc50513          	addi	a0,a0,1740 # 1d80 <malloc+0x26c>
     6bc:	00001097          	auipc	ra,0x1
     6c0:	05e080e7          	jalr	94(ra) # 171a <open>
        unlink("x");
     6c4:	00001517          	auipc	a0,0x1
     6c8:	6bc50513          	addi	a0,a0,1724 # 1d80 <malloc+0x26c>
     6cc:	00001097          	auipc	ra,0x1
     6d0:	05e080e7          	jalr	94(ra) # 172a <unlink>
        exit(0);
     6d4:	4501                	li	a0,0
     6d6:	00001097          	auipc	ra,0x1
     6da:	004080e7          	jalr	4(ra) # 16da <exit>
        printf("grind: fork failed\n");
     6de:	00001517          	auipc	a0,0x1
     6e2:	64250513          	addi	a0,a0,1602 # 1d20 <malloc+0x20c>
     6e6:	00001097          	auipc	ra,0x1
     6ea:	372080e7          	jalr	882(ra) # 1a58 <printf>
        exit(1);
     6ee:	4505                	li	a0,1
     6f0:	00001097          	auipc	ra,0x1
     6f4:	fea080e7          	jalr	-22(ra) # 16da <exit>
      unlink("c");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	6d850513          	addi	a0,a0,1752 # 1dd0 <malloc+0x2bc>
     700:	00001097          	auipc	ra,0x1
     704:	02a080e7          	jalr	42(ra) # 172a <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     708:	20200593          	li	a1,514
     70c:	00001517          	auipc	a0,0x1
     710:	6c450513          	addi	a0,a0,1732 # 1dd0 <malloc+0x2bc>
     714:	00001097          	auipc	ra,0x1
     718:	006080e7          	jalr	6(ra) # 171a <open>
     71c:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     71e:	04054d63          	bltz	a0,778 <go+0x6ca>
      if(write(fd1, "x", 1) != 1){
     722:	8652                	mv	a2,s4
     724:	00001597          	auipc	a1,0x1
     728:	65c58593          	addi	a1,a1,1628 # 1d80 <malloc+0x26c>
     72c:	00001097          	auipc	ra,0x1
     730:	fce080e7          	jalr	-50(ra) # 16fa <write>
     734:	05451f63          	bne	a0,s4,792 <go+0x6e4>
      if(fstat(fd1, &st) != 0){
     738:	f7840593          	addi	a1,s0,-136
     73c:	856a                	mv	a0,s10
     73e:	00001097          	auipc	ra,0x1
     742:	ff4080e7          	jalr	-12(ra) # 1732 <fstat>
     746:	e13d                	bnez	a0,7ac <go+0x6fe>
      if(st.size != 1){
     748:	f8843583          	ld	a1,-120(s0)
     74c:	07459d63          	bne	a1,s4,7c6 <go+0x718>
      if(st.ino > 200){
     750:	f7c42583          	lw	a1,-132(s0)
     754:	0c800793          	li	a5,200
     758:	08b7e563          	bltu	a5,a1,7e2 <go+0x734>
      close(fd1);
     75c:	856a                	mv	a0,s10
     75e:	00001097          	auipc	ra,0x1
     762:	fa4080e7          	jalr	-92(ra) # 1702 <close>
      unlink("c");
     766:	00001517          	auipc	a0,0x1
     76a:	66a50513          	addi	a0,a0,1642 # 1dd0 <malloc+0x2bc>
     76e:	00001097          	auipc	ra,0x1
     772:	fbc080e7          	jalr	-68(ra) # 172a <unlink>
     776:	b43d                	j	1a4 <go+0xf6>
        printf("grind: create c failed\n");
     778:	00001517          	auipc	a0,0x1
     77c:	66050513          	addi	a0,a0,1632 # 1dd8 <malloc+0x2c4>
     780:	00001097          	auipc	ra,0x1
     784:	2d8080e7          	jalr	728(ra) # 1a58 <printf>
        exit(1);
     788:	4505                	li	a0,1
     78a:	00001097          	auipc	ra,0x1
     78e:	f50080e7          	jalr	-176(ra) # 16da <exit>
        printf("grind: write c failed\n");
     792:	00001517          	auipc	a0,0x1
     796:	65e50513          	addi	a0,a0,1630 # 1df0 <malloc+0x2dc>
     79a:	00001097          	auipc	ra,0x1
     79e:	2be080e7          	jalr	702(ra) # 1a58 <printf>
        exit(1);
     7a2:	4505                	li	a0,1
     7a4:	00001097          	auipc	ra,0x1
     7a8:	f36080e7          	jalr	-202(ra) # 16da <exit>
        printf("grind: fstat failed\n");
     7ac:	00001517          	auipc	a0,0x1
     7b0:	65c50513          	addi	a0,a0,1628 # 1e08 <malloc+0x2f4>
     7b4:	00001097          	auipc	ra,0x1
     7b8:	2a4080e7          	jalr	676(ra) # 1a58 <printf>
        exit(1);
     7bc:	4505                	li	a0,1
     7be:	00001097          	auipc	ra,0x1
     7c2:	f1c080e7          	jalr	-228(ra) # 16da <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     7c6:	2581                	sext.w	a1,a1
     7c8:	00001517          	auipc	a0,0x1
     7cc:	65850513          	addi	a0,a0,1624 # 1e20 <malloc+0x30c>
     7d0:	00001097          	auipc	ra,0x1
     7d4:	288080e7          	jalr	648(ra) # 1a58 <printf>
        exit(1);
     7d8:	4505                	li	a0,1
     7da:	00001097          	auipc	ra,0x1
     7de:	f00080e7          	jalr	-256(ra) # 16da <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     7e2:	00001517          	auipc	a0,0x1
     7e6:	66650513          	addi	a0,a0,1638 # 1e48 <malloc+0x334>
     7ea:	00001097          	auipc	ra,0x1
     7ee:	26e080e7          	jalr	622(ra) # 1a58 <printf>
        exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00001097          	auipc	ra,0x1
     7f8:	ee6080e7          	jalr	-282(ra) # 16da <exit>
      if(pipe(aa) < 0){
     7fc:	856e                	mv	a0,s11
     7fe:	00001097          	auipc	ra,0x1
     802:	eec080e7          	jalr	-276(ra) # 16ea <pipe>
     806:	10054063          	bltz	a0,906 <go+0x858>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     80a:	f7040513          	addi	a0,s0,-144
     80e:	00001097          	auipc	ra,0x1
     812:	edc080e7          	jalr	-292(ra) # 16ea <pipe>
     816:	10054663          	bltz	a0,922 <go+0x874>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     81a:	00001097          	auipc	ra,0x1
     81e:	eb8080e7          	jalr	-328(ra) # 16d2 <fork>
      if(pid1 == 0){
     822:	10050e63          	beqz	a0,93e <go+0x890>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     826:	1c054663          	bltz	a0,9f2 <go+0x944>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     82a:	00001097          	auipc	ra,0x1
     82e:	ea8080e7          	jalr	-344(ra) # 16d2 <fork>
      if(pid2 == 0){
     832:	1c050e63          	beqz	a0,a0e <go+0x960>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     836:	2a054a63          	bltz	a0,aea <go+0xa3c>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     83a:	f6842503          	lw	a0,-152(s0)
     83e:	00001097          	auipc	ra,0x1
     842:	ec4080e7          	jalr	-316(ra) # 1702 <close>
      close(aa[1]);
     846:	f6c42503          	lw	a0,-148(s0)
     84a:	00001097          	auipc	ra,0x1
     84e:	eb8080e7          	jalr	-328(ra) # 1702 <close>
      close(bb[1]);
     852:	f7442503          	lw	a0,-140(s0)
     856:	00001097          	auipc	ra,0x1
     85a:	eac080e7          	jalr	-340(ra) # 1702 <close>
      char buf[4] = { 0, 0, 0, 0 };
     85e:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     862:	8652                	mv	a2,s4
     864:	f6040593          	addi	a1,s0,-160
     868:	f7042503          	lw	a0,-144(s0)
     86c:	00001097          	auipc	ra,0x1
     870:	e86080e7          	jalr	-378(ra) # 16f2 <read>
      read(bb[0], buf+1, 1);
     874:	8652                	mv	a2,s4
     876:	f6140593          	addi	a1,s0,-159
     87a:	f7042503          	lw	a0,-144(s0)
     87e:	00001097          	auipc	ra,0x1
     882:	e74080e7          	jalr	-396(ra) # 16f2 <read>
      read(bb[0], buf+2, 1);
     886:	8652                	mv	a2,s4
     888:	f6240593          	addi	a1,s0,-158
     88c:	f7042503          	lw	a0,-144(s0)
     890:	00001097          	auipc	ra,0x1
     894:	e62080e7          	jalr	-414(ra) # 16f2 <read>
      close(bb[0]);
     898:	f7042503          	lw	a0,-144(s0)
     89c:	00001097          	auipc	ra,0x1
     8a0:	e66080e7          	jalr	-410(ra) # 1702 <close>
      int st1, st2;
      wait(&st1);
     8a4:	f6440513          	addi	a0,s0,-156
     8a8:	00001097          	auipc	ra,0x1
     8ac:	e3a080e7          	jalr	-454(ra) # 16e2 <wait>
      wait(&st2);
     8b0:	f7840513          	addi	a0,s0,-136
     8b4:	00001097          	auipc	ra,0x1
     8b8:	e2e080e7          	jalr	-466(ra) # 16e2 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     8bc:	f6442783          	lw	a5,-156(s0)
     8c0:	f7842703          	lw	a4,-136(s0)
     8c4:	8fd9                	or	a5,a5,a4
     8c6:	ef89                	bnez	a5,8e0 <go+0x832>
     8c8:	00001597          	auipc	a1,0x1
     8cc:	62058593          	addi	a1,a1,1568 # 1ee8 <malloc+0x3d4>
     8d0:	f6040513          	addi	a0,s0,-160
     8d4:	00001097          	auipc	ra,0x1
     8d8:	b98080e7          	jalr	-1128(ra) # 146c <strcmp>
     8dc:	8c0504e3          	beqz	a0,1a4 <go+0xf6>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     8e0:	f6040693          	addi	a3,s0,-160
     8e4:	f7842603          	lw	a2,-136(s0)
     8e8:	f6442583          	lw	a1,-156(s0)
     8ec:	00001517          	auipc	a0,0x1
     8f0:	60450513          	addi	a0,a0,1540 # 1ef0 <malloc+0x3dc>
     8f4:	00001097          	auipc	ra,0x1
     8f8:	164080e7          	jalr	356(ra) # 1a58 <printf>
        exit(1);
     8fc:	4505                	li	a0,1
     8fe:	00001097          	auipc	ra,0x1
     902:	ddc080e7          	jalr	-548(ra) # 16da <exit>
        fprintf(2, "grind: pipe failed\n");
     906:	00001597          	auipc	a1,0x1
     90a:	46258593          	addi	a1,a1,1122 # 1d68 <malloc+0x254>
     90e:	4509                	li	a0,2
     910:	00001097          	auipc	ra,0x1
     914:	11a080e7          	jalr	282(ra) # 1a2a <fprintf>
        exit(1);
     918:	4505                	li	a0,1
     91a:	00001097          	auipc	ra,0x1
     91e:	dc0080e7          	jalr	-576(ra) # 16da <exit>
        fprintf(2, "grind: pipe failed\n");
     922:	00001597          	auipc	a1,0x1
     926:	44658593          	addi	a1,a1,1094 # 1d68 <malloc+0x254>
     92a:	4509                	li	a0,2
     92c:	00001097          	auipc	ra,0x1
     930:	0fe080e7          	jalr	254(ra) # 1a2a <fprintf>
        exit(1);
     934:	4505                	li	a0,1
     936:	00001097          	auipc	ra,0x1
     93a:	da4080e7          	jalr	-604(ra) # 16da <exit>
        close(bb[0]);
     93e:	f7042503          	lw	a0,-144(s0)
     942:	00001097          	auipc	ra,0x1
     946:	dc0080e7          	jalr	-576(ra) # 1702 <close>
        close(bb[1]);
     94a:	f7442503          	lw	a0,-140(s0)
     94e:	00001097          	auipc	ra,0x1
     952:	db4080e7          	jalr	-588(ra) # 1702 <close>
        close(aa[0]);
     956:	f6842503          	lw	a0,-152(s0)
     95a:	00001097          	auipc	ra,0x1
     95e:	da8080e7          	jalr	-600(ra) # 1702 <close>
        close(1);
     962:	4505                	li	a0,1
     964:	00001097          	auipc	ra,0x1
     968:	d9e080e7          	jalr	-610(ra) # 1702 <close>
        if(dup(aa[1]) != 1){
     96c:	f6c42503          	lw	a0,-148(s0)
     970:	00001097          	auipc	ra,0x1
     974:	de2080e7          	jalr	-542(ra) # 1752 <dup>
     978:	4785                	li	a5,1
     97a:	02f50063          	beq	a0,a5,99a <go+0x8ec>
          fprintf(2, "grind: dup failed\n");
     97e:	00001597          	auipc	a1,0x1
     982:	4f258593          	addi	a1,a1,1266 # 1e70 <malloc+0x35c>
     986:	4509                	li	a0,2
     988:	00001097          	auipc	ra,0x1
     98c:	0a2080e7          	jalr	162(ra) # 1a2a <fprintf>
          exit(1);
     990:	4505                	li	a0,1
     992:	00001097          	auipc	ra,0x1
     996:	d48080e7          	jalr	-696(ra) # 16da <exit>
        close(aa[1]);
     99a:	f6c42503          	lw	a0,-148(s0)
     99e:	00001097          	auipc	ra,0x1
     9a2:	d64080e7          	jalr	-668(ra) # 1702 <close>
        char *args[3] = { "echo", "hi", 0 };
     9a6:	00001797          	auipc	a5,0x1
     9aa:	4e278793          	addi	a5,a5,1250 # 1e88 <malloc+0x374>
     9ae:	f6f43c23          	sd	a5,-136(s0)
     9b2:	00001797          	auipc	a5,0x1
     9b6:	4de78793          	addi	a5,a5,1246 # 1e90 <malloc+0x37c>
     9ba:	f8f43023          	sd	a5,-128(s0)
     9be:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     9c2:	f7840593          	addi	a1,s0,-136
     9c6:	00001517          	auipc	a0,0x1
     9ca:	4d250513          	addi	a0,a0,1234 # 1e98 <malloc+0x384>
     9ce:	00001097          	auipc	ra,0x1
     9d2:	d44080e7          	jalr	-700(ra) # 1712 <exec>
        fprintf(2, "grind: echo: not found\n");
     9d6:	00001597          	auipc	a1,0x1
     9da:	4d258593          	addi	a1,a1,1234 # 1ea8 <malloc+0x394>
     9de:	4509                	li	a0,2
     9e0:	00001097          	auipc	ra,0x1
     9e4:	04a080e7          	jalr	74(ra) # 1a2a <fprintf>
        exit(2);
     9e8:	4509                	li	a0,2
     9ea:	00001097          	auipc	ra,0x1
     9ee:	cf0080e7          	jalr	-784(ra) # 16da <exit>
        fprintf(2, "grind: fork failed\n");
     9f2:	00001597          	auipc	a1,0x1
     9f6:	32e58593          	addi	a1,a1,814 # 1d20 <malloc+0x20c>
     9fa:	4509                	li	a0,2
     9fc:	00001097          	auipc	ra,0x1
     a00:	02e080e7          	jalr	46(ra) # 1a2a <fprintf>
        exit(3);
     a04:	450d                	li	a0,3
     a06:	00001097          	auipc	ra,0x1
     a0a:	cd4080e7          	jalr	-812(ra) # 16da <exit>
        close(aa[1]);
     a0e:	f6c42503          	lw	a0,-148(s0)
     a12:	00001097          	auipc	ra,0x1
     a16:	cf0080e7          	jalr	-784(ra) # 1702 <close>
        close(bb[0]);
     a1a:	f7042503          	lw	a0,-144(s0)
     a1e:	00001097          	auipc	ra,0x1
     a22:	ce4080e7          	jalr	-796(ra) # 1702 <close>
        close(0);
     a26:	4501                	li	a0,0
     a28:	00001097          	auipc	ra,0x1
     a2c:	cda080e7          	jalr	-806(ra) # 1702 <close>
        if(dup(aa[0]) != 0){
     a30:	f6842503          	lw	a0,-152(s0)
     a34:	00001097          	auipc	ra,0x1
     a38:	d1e080e7          	jalr	-738(ra) # 1752 <dup>
     a3c:	cd19                	beqz	a0,a5a <go+0x9ac>
          fprintf(2, "grind: dup failed\n");
     a3e:	00001597          	auipc	a1,0x1
     a42:	43258593          	addi	a1,a1,1074 # 1e70 <malloc+0x35c>
     a46:	4509                	li	a0,2
     a48:	00001097          	auipc	ra,0x1
     a4c:	fe2080e7          	jalr	-30(ra) # 1a2a <fprintf>
          exit(4);
     a50:	4511                	li	a0,4
     a52:	00001097          	auipc	ra,0x1
     a56:	c88080e7          	jalr	-888(ra) # 16da <exit>
        close(aa[0]);
     a5a:	f6842503          	lw	a0,-152(s0)
     a5e:	00001097          	auipc	ra,0x1
     a62:	ca4080e7          	jalr	-860(ra) # 1702 <close>
        close(1);
     a66:	4505                	li	a0,1
     a68:	00001097          	auipc	ra,0x1
     a6c:	c9a080e7          	jalr	-870(ra) # 1702 <close>
        if(dup(bb[1]) != 1){
     a70:	f7442503          	lw	a0,-140(s0)
     a74:	00001097          	auipc	ra,0x1
     a78:	cde080e7          	jalr	-802(ra) # 1752 <dup>
     a7c:	4785                	li	a5,1
     a7e:	02f50063          	beq	a0,a5,a9e <go+0x9f0>
          fprintf(2, "grind: dup failed\n");
     a82:	00001597          	auipc	a1,0x1
     a86:	3ee58593          	addi	a1,a1,1006 # 1e70 <malloc+0x35c>
     a8a:	4509                	li	a0,2
     a8c:	00001097          	auipc	ra,0x1
     a90:	f9e080e7          	jalr	-98(ra) # 1a2a <fprintf>
          exit(5);
     a94:	4515                	li	a0,5
     a96:	00001097          	auipc	ra,0x1
     a9a:	c44080e7          	jalr	-956(ra) # 16da <exit>
        close(bb[1]);
     a9e:	f7442503          	lw	a0,-140(s0)
     aa2:	00001097          	auipc	ra,0x1
     aa6:	c60080e7          	jalr	-928(ra) # 1702 <close>
        char *args[2] = { "cat", 0 };
     aaa:	00001797          	auipc	a5,0x1
     aae:	41678793          	addi	a5,a5,1046 # 1ec0 <malloc+0x3ac>
     ab2:	f6f43c23          	sd	a5,-136(s0)
     ab6:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     aba:	f7840593          	addi	a1,s0,-136
     abe:	00001517          	auipc	a0,0x1
     ac2:	40a50513          	addi	a0,a0,1034 # 1ec8 <malloc+0x3b4>
     ac6:	00001097          	auipc	ra,0x1
     aca:	c4c080e7          	jalr	-948(ra) # 1712 <exec>
        fprintf(2, "grind: cat: not found\n");
     ace:	00001597          	auipc	a1,0x1
     ad2:	40258593          	addi	a1,a1,1026 # 1ed0 <malloc+0x3bc>
     ad6:	4509                	li	a0,2
     ad8:	00001097          	auipc	ra,0x1
     adc:	f52080e7          	jalr	-174(ra) # 1a2a <fprintf>
        exit(6);
     ae0:	4519                	li	a0,6
     ae2:	00001097          	auipc	ra,0x1
     ae6:	bf8080e7          	jalr	-1032(ra) # 16da <exit>
        fprintf(2, "grind: fork failed\n");
     aea:	00001597          	auipc	a1,0x1
     aee:	23658593          	addi	a1,a1,566 # 1d20 <malloc+0x20c>
     af2:	4509                	li	a0,2
     af4:	00001097          	auipc	ra,0x1
     af8:	f36080e7          	jalr	-202(ra) # 1a2a <fprintf>
        exit(7);
     afc:	451d                	li	a0,7
     afe:	00001097          	auipc	ra,0x1
     b02:	bdc080e7          	jalr	-1060(ra) # 16da <exit>

0000000000000b06 <iter>:
  }
}

void
iter()
{
     b06:	7179                	addi	sp,sp,-48
     b08:	f406                	sd	ra,40(sp)
     b0a:	f022                	sd	s0,32(sp)
     b0c:	1800                	addi	s0,sp,48
  unlink("a");
     b0e:	00001517          	auipc	a0,0x1
     b12:	22a50513          	addi	a0,a0,554 # 1d38 <malloc+0x224>
     b16:	00001097          	auipc	ra,0x1
     b1a:	c14080e7          	jalr	-1004(ra) # 172a <unlink>
  unlink("b");
     b1e:	00001517          	auipc	a0,0x1
     b22:	1ca50513          	addi	a0,a0,458 # 1ce8 <malloc+0x1d4>
     b26:	00001097          	auipc	ra,0x1
     b2a:	c04080e7          	jalr	-1020(ra) # 172a <unlink>
  
  int pid1 = fork();
     b2e:	00001097          	auipc	ra,0x1
     b32:	ba4080e7          	jalr	-1116(ra) # 16d2 <fork>
  if(pid1 < 0){
     b36:	02054363          	bltz	a0,b5c <iter+0x56>
     b3a:	ec26                	sd	s1,24(sp)
     b3c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b3e:	ed15                	bnez	a0,b7a <iter+0x74>
     b40:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     b42:	00002717          	auipc	a4,0x2
     b46:	4be70713          	addi	a4,a4,1214 # 3000 <rand_next>
     b4a:	631c                	ld	a5,0(a4)
     b4c:	01f7c793          	xori	a5,a5,31
     b50:	e31c                	sd	a5,0(a4)
    go(0);
     b52:	4501                	li	a0,0
     b54:	fffff097          	auipc	ra,0xfffff
     b58:	55a080e7          	jalr	1370(ra) # ae <go>
     b5c:	ec26                	sd	s1,24(sp)
     b5e:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     b60:	00001517          	auipc	a0,0x1
     b64:	1c050513          	addi	a0,a0,448 # 1d20 <malloc+0x20c>
     b68:	00001097          	auipc	ra,0x1
     b6c:	ef0080e7          	jalr	-272(ra) # 1a58 <printf>
    exit(1);
     b70:	4505                	li	a0,1
     b72:	00001097          	auipc	ra,0x1
     b76:	b68080e7          	jalr	-1176(ra) # 16da <exit>
     b7a:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     b7c:	00001097          	auipc	ra,0x1
     b80:	b56080e7          	jalr	-1194(ra) # 16d2 <fork>
     b84:	892a                	mv	s2,a0
  if(pid2 < 0){
     b86:	02054263          	bltz	a0,baa <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b8a:	ed0d                	bnez	a0,bc4 <iter+0xbe>
    rand_next ^= 7177;
     b8c:	00002697          	auipc	a3,0x2
     b90:	47468693          	addi	a3,a3,1140 # 3000 <rand_next>
     b94:	629c                	ld	a5,0(a3)
     b96:	6709                	lui	a4,0x2
     b98:	c0970713          	addi	a4,a4,-1015 # 1c09 <malloc+0xf5>
     b9c:	8fb9                	xor	a5,a5,a4
     b9e:	e29c                	sd	a5,0(a3)
    go(1);
     ba0:	4505                	li	a0,1
     ba2:	fffff097          	auipc	ra,0xfffff
     ba6:	50c080e7          	jalr	1292(ra) # ae <go>
    printf("grind: fork failed\n");
     baa:	00001517          	auipc	a0,0x1
     bae:	17650513          	addi	a0,a0,374 # 1d20 <malloc+0x20c>
     bb2:	00001097          	auipc	ra,0x1
     bb6:	ea6080e7          	jalr	-346(ra) # 1a58 <printf>
    exit(1);
     bba:	4505                	li	a0,1
     bbc:	00001097          	auipc	ra,0x1
     bc0:	b1e080e7          	jalr	-1250(ra) # 16da <exit>
    exit(0);
  }

  int st1 = -1;
     bc4:	57fd                	li	a5,-1
     bc6:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     bca:	fdc40513          	addi	a0,s0,-36
     bce:	00001097          	auipc	ra,0x1
     bd2:	b14080e7          	jalr	-1260(ra) # 16e2 <wait>
  if(st1 != 0){
     bd6:	fdc42783          	lw	a5,-36(s0)
     bda:	ef99                	bnez	a5,bf8 <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     bdc:	57fd                	li	a5,-1
     bde:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     be2:	fd840513          	addi	a0,s0,-40
     be6:	00001097          	auipc	ra,0x1
     bea:	afc080e7          	jalr	-1284(ra) # 16e2 <wait>

  exit(0);
     bee:	4501                	li	a0,0
     bf0:	00001097          	auipc	ra,0x1
     bf4:	aea080e7          	jalr	-1302(ra) # 16da <exit>
    kill(pid1);
     bf8:	8526                	mv	a0,s1
     bfa:	00001097          	auipc	ra,0x1
     bfe:	b10080e7          	jalr	-1264(ra) # 170a <kill>
    kill(pid2);
     c02:	854a                	mv	a0,s2
     c04:	00001097          	auipc	ra,0x1
     c08:	b06080e7          	jalr	-1274(ra) # 170a <kill>
     c0c:	bfc1                	j	bdc <iter+0xd6>

0000000000000c0e <main>:
}

int
main()
{
     c0e:	1101                	addi	sp,sp,-32
     c10:	ec06                	sd	ra,24(sp)
     c12:	e822                	sd	s0,16(sp)
     c14:	e426                	sd	s1,8(sp)
     c16:	e04a                	sd	s2,0(sp)
     c18:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     c1a:	4951                	li	s2,20
    rand_next += 1;
     c1c:	00002497          	auipc	s1,0x2
     c20:	3e448493          	addi	s1,s1,996 # 3000 <rand_next>
     c24:	a829                	j	c3e <main+0x30>
      iter();
     c26:	00000097          	auipc	ra,0x0
     c2a:	ee0080e7          	jalr	-288(ra) # b06 <iter>
    sleep(20);
     c2e:	854a                	mv	a0,s2
     c30:	00001097          	auipc	ra,0x1
     c34:	b3a080e7          	jalr	-1222(ra) # 176a <sleep>
    rand_next += 1;
     c38:	609c                	ld	a5,0(s1)
     c3a:	0785                	addi	a5,a5,1
     c3c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     c3e:	00001097          	auipc	ra,0x1
     c42:	a94080e7          	jalr	-1388(ra) # 16d2 <fork>
    if(pid == 0){
     c46:	d165                	beqz	a0,c26 <main+0x18>
    if(pid > 0){
     c48:	fea053e3          	blez	a0,c2e <main+0x20>
      wait(0);
     c4c:	4501                	li	a0,0
     c4e:	00001097          	auipc	ra,0x1
     c52:	a94080e7          	jalr	-1388(ra) # 16e2 <wait>
     c56:	bfe1                	j	c2e <main+0x20>

0000000000000c58 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     c58:	1141                	addi	sp,sp,-16
     c5a:	e406                	sd	ra,8(sp)
     c5c:	e022                	sd	s0,0(sp)
     c5e:	0800                	addi	s0,sp,16
    lk->name = name;
     c60:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     c62:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     c66:	57fd                	li	a5,-1
     c68:	00f50823          	sb	a5,16(a0)
}
     c6c:	60a2                	ld	ra,8(sp)
     c6e:	6402                	ld	s0,0(sp)
     c70:	0141                	addi	sp,sp,16
     c72:	8082                	ret

0000000000000c74 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     c74:	00054783          	lbu	a5,0(a0)
     c78:	e399                	bnez	a5,c7e <holding+0xa>
     c7a:	4501                	li	a0,0
}
     c7c:	8082                	ret
{
     c7e:	1101                	addi	sp,sp,-32
     c80:	ec06                	sd	ra,24(sp)
     c82:	e822                	sd	s0,16(sp)
     c84:	e426                	sd	s1,8(sp)
     c86:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     c88:	01054483          	lbu	s1,16(a0)
     c8c:	00000097          	auipc	ra,0x0
     c90:	63e080e7          	jalr	1598(ra) # 12ca <twhoami>
     c94:	2501                	sext.w	a0,a0
     c96:	40a48533          	sub	a0,s1,a0
     c9a:	00153513          	seqz	a0,a0
}
     c9e:	60e2                	ld	ra,24(sp)
     ca0:	6442                	ld	s0,16(sp)
     ca2:	64a2                	ld	s1,8(sp)
     ca4:	6105                	addi	sp,sp,32
     ca6:	8082                	ret

0000000000000ca8 <acquire>:

void acquire(struct lock *lk)
{
     ca8:	7179                	addi	sp,sp,-48
     caa:	f406                	sd	ra,40(sp)
     cac:	f022                	sd	s0,32(sp)
     cae:	ec26                	sd	s1,24(sp)
     cb0:	e84a                	sd	s2,16(sp)
     cb2:	e44e                	sd	s3,8(sp)
     cb4:	1800                	addi	s0,sp,48
     cb6:	892a                	mv	s2,a0
    if (holding(lk))
     cb8:	00000097          	auipc	ra,0x0
     cbc:	fbc080e7          	jalr	-68(ra) # c74 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     cc0:	ffc97493          	andi	s1,s2,-4
     cc4:	4985                	li	s3,1
    if (holding(lk))
     cc6:	c115                	beqz	a0,cea <acquire+0x42>
        printf("re-acquiring lock we already hold");
     cc8:	00001517          	auipc	a0,0x1
     ccc:	25050513          	addi	a0,a0,592 # 1f18 <malloc+0x404>
     cd0:	00001097          	auipc	ra,0x1
     cd4:	d88080e7          	jalr	-632(ra) # 1a58 <printf>
        exit(-1);
     cd8:	557d                	li	a0,-1
     cda:	00001097          	auipc	ra,0x1
     cde:	a00080e7          	jalr	-1536(ra) # 16da <exit>
    {
        // give up the cpu for other threads
        tyield();
     ce2:	00000097          	auipc	ra,0x0
     ce6:	5b2080e7          	jalr	1458(ra) # 1294 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     cea:	00397713          	andi	a4,s2,3
     cee:	0037171b          	slliw	a4,a4,0x3
     cf2:	0ff00793          	li	a5,255
     cf6:	00e797bb          	sllw	a5,a5,a4
     cfa:	fff7c613          	not	a2,a5
     cfe:	00e996bb          	sllw	a3,s3,a4
     d02:	8efd                	and	a3,a3,a5
     d04:	1404a7af          	lr.w.aq	a5,(s1)
     d08:	00c7f5b3          	and	a1,a5,a2
     d0c:	8dd5                	or	a1,a1,a3
     d0e:	18b4a5af          	sc.w	a1,a1,(s1)
     d12:	f9ed                	bnez	a1,d04 <acquire+0x5c>
     d14:	40e7d7bb          	sraw	a5,a5,a4
     d18:	0ff7f793          	zext.b	a5,a5
     d1c:	f3f9                	bnez	a5,ce2 <acquire+0x3a>
    }

    __sync_synchronize();
     d1e:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     d22:	00000097          	auipc	ra,0x0
     d26:	5a8080e7          	jalr	1448(ra) # 12ca <twhoami>
     d2a:	00a90823          	sb	a0,16(s2)
}
     d2e:	70a2                	ld	ra,40(sp)
     d30:	7402                	ld	s0,32(sp)
     d32:	64e2                	ld	s1,24(sp)
     d34:	6942                	ld	s2,16(sp)
     d36:	69a2                	ld	s3,8(sp)
     d38:	6145                	addi	sp,sp,48
     d3a:	8082                	ret

0000000000000d3c <release>:

void release(struct lock *lk)
{
     d3c:	1101                	addi	sp,sp,-32
     d3e:	ec06                	sd	ra,24(sp)
     d40:	e822                	sd	s0,16(sp)
     d42:	e426                	sd	s1,8(sp)
     d44:	1000                	addi	s0,sp,32
     d46:	84aa                	mv	s1,a0
    if (!holding(lk))
     d48:	00000097          	auipc	ra,0x0
     d4c:	f2c080e7          	jalr	-212(ra) # c74 <holding>
     d50:	c11d                	beqz	a0,d76 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     d52:	57fd                	li	a5,-1
     d54:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     d58:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     d5c:	0310000f          	fence	rw,w
     d60:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     d64:	00000097          	auipc	ra,0x0
     d68:	530080e7          	jalr	1328(ra) # 1294 <tyield>
}
     d6c:	60e2                	ld	ra,24(sp)
     d6e:	6442                	ld	s0,16(sp)
     d70:	64a2                	ld	s1,8(sp)
     d72:	6105                	addi	sp,sp,32
     d74:	8082                	ret
        printf("releasing lock we are not holding");
     d76:	00001517          	auipc	a0,0x1
     d7a:	1ca50513          	addi	a0,a0,458 # 1f40 <malloc+0x42c>
     d7e:	00001097          	auipc	ra,0x1
     d82:	cda080e7          	jalr	-806(ra) # 1a58 <printf>
        exit(-1);
     d86:	557d                	li	a0,-1
     d88:	00001097          	auipc	ra,0x1
     d8c:	952080e7          	jalr	-1710(ra) # 16da <exit>

0000000000000d90 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     d90:	00002797          	auipc	a5,0x2
     d94:	2807c783          	lbu	a5,640(a5) # 3010 <threadlib_init_done>
     d98:	eba5                	bnez	a5,e08 <threadlib_init+0x78>
{
     d9a:	7179                	addi	sp,sp,-48
     d9c:	f406                	sd	ra,40(sp)
     d9e:	f022                	sd	s0,32(sp)
     da0:	ec26                	sd	s1,24(sp)
     da2:	e84a                	sd	s2,16(sp)
     da4:	e44e                	sd	s3,8(sp)
     da6:	e052                	sd	s4,0(sp)
     da8:	1800                	addi	s0,sp,48
     daa:	00002497          	auipc	s1,0x2
     dae:	66e48493          	addi	s1,s1,1646 # 3418 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     db2:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     db4:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     db8:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     dba:	8652                	mv	a2,s4
     dbc:	4581                	li	a1,0
     dbe:	8526                	mv	a0,s1
     dc0:	00000097          	auipc	ra,0x0
     dc4:	708080e7          	jalr	1800(ra) # 14c8 <memset>
        threads[i].tid = i;
     dc8:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     dcc:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     dd0:	2905                	addiw	s2,s2,1
     dd2:	0b048493          	addi	s1,s1,176
     dd6:	ff3912e3          	bne	s2,s3,dba <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     dda:	00002797          	auipc	a5,0x2
     dde:	63e78793          	addi	a5,a5,1598 # 3418 <threads>
     de2:	00002717          	auipc	a4,0x2
     de6:	22f73b23          	sd	a5,566(a4) # 3018 <current_thread>
    current_thread->state = RUNNING;
     dea:	4711                	li	a4,4
     dec:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     dee:	4785                	li	a5,1
     df0:	00002717          	auipc	a4,0x2
     df4:	22f70023          	sb	a5,544(a4) # 3010 <threadlib_init_done>
}
     df8:	70a2                	ld	ra,40(sp)
     dfa:	7402                	ld	s0,32(sp)
     dfc:	64e2                	ld	s1,24(sp)
     dfe:	6942                	ld	s2,16(sp)
     e00:	69a2                	ld	s3,8(sp)
     e02:	6a02                	ld	s4,0(sp)
     e04:	6145                	addi	sp,sp,48
     e06:	8082                	ret
     e08:	8082                	ret

0000000000000e0a <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     e0a:	1101                	addi	sp,sp,-32
     e0c:	ec06                	sd	ra,24(sp)
     e0e:	e822                	sd	s0,16(sp)
     e10:	e426                	sd	s1,8(sp)
     e12:	e04a                	sd	s2,0(sp)
     e14:	1000                	addi	s0,sp,32
     e16:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     e18:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     e1c:	6948                	ld	a0,144(a0)
     e1e:	c509                	beqz	a0,e28 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     e20:	00001097          	auipc	ra,0x1
     e24:	c6e080e7          	jalr	-914(ra) # 1a8e <free>
    }
    if (thread->result)
     e28:	70c8                	ld	a0,160(s1)
     e2a:	c509                	beqz	a0,e34 <reclaim_thread+0x2a>
    {
        free(thread->result);
     e2c:	00001097          	auipc	ra,0x1
     e30:	c62080e7          	jalr	-926(ra) # 1a8e <free>
    }

    memset(thread, 0, sizeof(*thread));
     e34:	0b000613          	li	a2,176
     e38:	4581                	li	a1,0
     e3a:	8526                	mv	a0,s1
     e3c:	00000097          	auipc	ra,0x0
     e40:	68c080e7          	jalr	1676(ra) # 14c8 <memset>
    thread->tid = tid;
     e44:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     e48:	0604ac23          	sw	zero,120(s1)
}
     e4c:	60e2                	ld	ra,24(sp)
     e4e:	6442                	ld	s0,16(sp)
     e50:	64a2                	ld	s1,8(sp)
     e52:	6902                	ld	s2,0(sp)
     e54:	6105                	addi	sp,sp,32
     e56:	8082                	ret

0000000000000e58 <tsched>:

void tsched()
{
     e58:	1141                	addi	sp,sp,-16
     e5a:	e406                	sd	ra,8(sp)
     e5c:	e022                	sd	s0,0(sp)
     e5e:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     e60:	00000097          	auipc	ra,0x0
     e64:	f30080e7          	jalr	-208(ra) # d90 <threadlib_init>
    prev = current_thread;
     e68:	00002517          	auipc	a0,0x2
     e6c:	1b053503          	ld	a0,432(a0) # 3018 <current_thread>
    if (prev->state == RUNNING)
     e70:	5d38                	lw	a4,120(a0)
     e72:	4791                	li	a5,4
     e74:	06f70763          	beq	a4,a5,ee2 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     e78:	00054603          	lbu	a2,0(a0)
     e7c:	0016069b          	addiw	a3,a2,1
     e80:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     e82:	00002897          	auipc	a7,0x2
     e86:	59688893          	addi	a7,a7,1430 # 3418 <threads>
     e8a:	0b000813          	li	a6,176
     e8e:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     e90:	41f6d71b          	sraiw	a4,a3,0x1f
     e94:	01c7571b          	srliw	a4,a4,0x1c
     e98:	00d707bb          	addw	a5,a4,a3
     e9c:	8bbd                	andi	a5,a5,15
     e9e:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     ea0:	03078733          	mul	a4,a5,a6
     ea4:	9746                	add	a4,a4,a7
     ea6:	5f38                	lw	a4,120(a4)
     ea8:	04b70063          	beq	a4,a1,ee8 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     eac:	2685                	addiw	a3,a3,1
     eae:	fec691e3          	bne	a3,a2,e90 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     eb2:	5d3c                	lw	a5,120(a0)
     eb4:	470d                	li	a4,3
     eb6:	06e78f63          	beq	a5,a4,f34 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     eba:	4711                	li	a4,4
     ebc:	06e78763          	beq	a5,a4,f2a <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     ec0:	00001597          	auipc	a1,0x1
     ec4:	0a858593          	addi	a1,a1,168 # 1f68 <malloc+0x454>
     ec8:	00001517          	auipc	a0,0x1
     ecc:	0b050513          	addi	a0,a0,176 # 1f78 <malloc+0x464>
     ed0:	00001097          	auipc	ra,0x1
     ed4:	b88080e7          	jalr	-1144(ra) # 1a58 <printf>
        exit(-1);
     ed8:	557d                	li	a0,-1
     eda:	00001097          	auipc	ra,0x1
     ede:	800080e7          	jalr	-2048(ra) # 16da <exit>
        prev->state = RUNNABLE;
     ee2:	478d                	li	a5,3
     ee4:	dd3c                	sw	a5,120(a0)
     ee6:	bf49                	j	e78 <tsched+0x20>
            return &threads[idx];
     ee8:	0b000713          	li	a4,176
     eec:	02e78733          	mul	a4,a5,a4
     ef0:	00002697          	auipc	a3,0x2
     ef4:	52868693          	addi	a3,a3,1320 # 3418 <threads>
     ef8:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     efa:	02d50c63          	beq	a0,a3,f32 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     efe:	00002617          	auipc	a2,0x2
     f02:	10d63d23          	sd	a3,282(a2) # 3018 <current_thread>
    next->state = RUNNING;
     f06:	00002597          	auipc	a1,0x2
     f0a:	51258593          	addi	a1,a1,1298 # 3418 <threads>
     f0e:	0b000693          	li	a3,176
     f12:	02d787b3          	mul	a5,a5,a3
     f16:	97ae                	add	a5,a5,a1
     f18:	4691                	li	a3,4
     f1a:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     f1c:	0721                	addi	a4,a4,8
     f1e:	95ba                	add	a1,a1,a4
     f20:	0521                	addi	a0,a0,8
     f22:	00000097          	auipc	ra,0x0
     f26:	488080e7          	jalr	1160(ra) # 13aa <tswtch>
}
     f2a:	60a2                	ld	ra,8(sp)
     f2c:	6402                	ld	s0,0(sp)
     f2e:	0141                	addi	sp,sp,16
     f30:	8082                	ret
     f32:	8536                	mv	a0,a3
        next->state = RUNNING;
     f34:	4791                	li	a5,4
     f36:	dd3c                	sw	a5,120(a0)
        return;
     f38:	bfcd                	j	f2a <tsched+0xd2>

0000000000000f3a <thread_bootstrap>:
{
     f3a:	1101                	addi	sp,sp,-32
     f3c:	ec06                	sd	ra,24(sp)
     f3e:	e822                	sd	s0,16(sp)
     f40:	e426                	sd	s1,8(sp)
     f42:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     f44:	00002497          	auipc	s1,0x2
     f48:	0d44b483          	ld	s1,212(s1) # 3018 <current_thread>
    if (thread)
     f4c:	c09d                	beqz	s1,f72 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     f4e:	64dc                	ld	a5,136(s1)
     f50:	60c8                	ld	a0,128(s1)
     f52:	9782                	jalr	a5
     f54:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     f56:	00002497          	auipc	s1,0x2
     f5a:	0c24b483          	ld	s1,194(s1) # 3018 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     f5e:	09c4a603          	lw	a2,156(s1)
     f62:	ca01                	beqz	a2,f72 <thread_bootstrap+0x38>
     f64:	70c8                	ld	a0,160(s1)
     f66:	c591                	beqz	a1,f72 <thread_bootstrap+0x38>
     f68:	c509                	beqz	a0,f72 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     f6a:	00000097          	auipc	ra,0x0
     f6e:	6ba080e7          	jalr	1722(ra) # 1624 <memmove>
    thread->state = EXITED;
     f72:	4799                	li	a5,6
     f74:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     f76:	74dc                	ld	a5,168(s1)
     f78:	c789                	beqz	a5,f82 <thread_bootstrap+0x48>
     f7a:	5fb4                	lw	a3,120(a5)
     f7c:	4709                	li	a4,2
     f7e:	00e68b63          	beq	a3,a4,f94 <thread_bootstrap+0x5a>
    tsched();
     f82:	00000097          	auipc	ra,0x0
     f86:	ed6080e7          	jalr	-298(ra) # e58 <tsched>
    exit(-1);
     f8a:	557d                	li	a0,-1
     f8c:	00000097          	auipc	ra,0x0
     f90:	74e080e7          	jalr	1870(ra) # 16da <exit>
        thread->joiner->state = RUNNABLE;
     f94:	470d                	li	a4,3
     f96:	dfb8                	sw	a4,120(a5)
     f98:	b7ed                	j	f82 <thread_bootstrap+0x48>

0000000000000f9a <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     f9a:	715d                	addi	sp,sp,-80
     f9c:	e486                	sd	ra,72(sp)
     f9e:	e0a2                	sd	s0,64(sp)
     fa0:	fc26                	sd	s1,56(sp)
     fa2:	f84a                	sd	s2,48(sp)
     fa4:	f44e                	sd	s3,40(sp)
     fa6:	f052                	sd	s4,32(sp)
     fa8:	ec56                	sd	s5,24(sp)
     faa:	e85a                	sd	s6,16(sp)
     fac:	e45e                	sd	s7,8(sp)
     fae:	e062                	sd	s8,0(sp)
     fb0:	0880                	addi	s0,sp,80
     fb2:	8b2a                	mv	s6,a0
     fb4:	84ae                	mv	s1,a1
     fb6:	8bb2                	mv	s7,a2
     fb8:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     fba:	00000097          	auipc	ra,0x0
     fbe:	dd6080e7          	jalr	-554(ra) # d90 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     fc2:	c4b1                	beqz	s1,100e <tcreate+0x74>
    {
        if (attr->stacksize)
     fc4:	0004a983          	lw	s3,0(s1)
     fc8:	00099363          	bnez	s3,fce <tcreate+0x34>
    stacksize = PGSIZE;
     fcc:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     fce:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     fd2:	00002797          	auipc	a5,0x2
     fd6:	56e78793          	addi	a5,a5,1390 # 3540 <threads+0x128>
     fda:	4485                	li	s1,1
     fdc:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     fde:	4398                	lw	a4,0(a5)
     fe0:	cb15                	beqz	a4,1014 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     fe2:	2485                	addiw	s1,s1,1
     fe4:	0b078793          	addi	a5,a5,176
     fe8:	feb49be3          	bne	s1,a1,fde <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     fec:	00001597          	auipc	a1,0x1
     ff0:	f7c58593          	addi	a1,a1,-132 # 1f68 <malloc+0x454>
     ff4:	00001517          	auipc	a0,0x1
     ff8:	f9c50513          	addi	a0,a0,-100 # 1f90 <malloc+0x47c>
     ffc:	00001097          	auipc	ra,0x1
    1000:	a5c080e7          	jalr	-1444(ra) # 1a58 <printf>
        exit(-1);
    1004:	557d                	li	a0,-1
    1006:	00000097          	auipc	ra,0x0
    100a:	6d4080e7          	jalr	1748(ra) # 16da <exit>
    res_size = 0;
    100e:	4a81                	li	s5,0
    stacksize = PGSIZE;
    1010:	6985                	lui	s3,0x1
    1012:	b7c1                	j	fd2 <tcreate+0x38>
            new_thread = &threads[i];
    1014:	0b000a13          	li	s4,176
    1018:	03448a33          	mul	s4,s1,s4
    101c:	00002917          	auipc	s2,0x2
    1020:	3fc90913          	addi	s2,s2,1020 # 3418 <threads>
    1024:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
    1026:	0b000613          	li	a2,176
    102a:	4581                	li	a1,0
    102c:	854a                	mv	a0,s2
    102e:	00000097          	auipc	ra,0x0
    1032:	49a080e7          	jalr	1178(ra) # 14c8 <memset>
    new_thread->tid = new_thread - threads;
    1036:	404a5693          	srai	a3,s4,0x4
    103a:	000ba737          	lui	a4,0xba
    103e:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb63d1>
    1042:	0732                	slli	a4,a4,0xc
    1044:	ba370713          	addi	a4,a4,-1117
    1048:	2e8ba7b7          	lui	a5,0x2e8ba
    104c:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b63d0>
    1050:	1782                	slli	a5,a5,0x20
    1052:	97ba                	add	a5,a5,a4
    1054:	02f687b3          	mul	a5,a3,a5
    1058:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
    105c:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
    1060:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
    1064:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
    1068:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
    106c:	478d                	li	a5,3
    106e:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
    1072:	0109851b          	addiw	a0,s3,16 # 1010 <tcreate+0x76>
    1076:	00001097          	auipc	ra,0x1
    107a:	a9e080e7          	jalr	-1378(ra) # 1b14 <malloc>
    107e:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
    1082:	c951                	beqz	a0,1116 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
    1084:	020a8863          	beqz	s5,10b4 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
    1088:	8556                	mv	a0,s5
    108a:	00001097          	auipc	ra,0x1
    108e:	a8a080e7          	jalr	-1398(ra) # 1b14 <malloc>
    1092:	0b000713          	li	a4,176
    1096:	02e48733          	mul	a4,s1,a4
    109a:	00002797          	auipc	a5,0x2
    109e:	37e78793          	addi	a5,a5,894 # 3418 <threads>
    10a2:	97ba                	add	a5,a5,a4
    10a4:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
    10a6:	c949                	beqz	a0,1138 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
    10a8:	8656                	mv	a2,s5
    10aa:	4581                	li	a1,0
    10ac:	00000097          	auipc	ra,0x0
    10b0:	41c080e7          	jalr	1052(ra) # 14c8 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
    10b4:	00002517          	auipc	a0,0x2
    10b8:	36450513          	addi	a0,a0,868 # 3418 <threads>
    10bc:	0b000793          	li	a5,176
    10c0:	02f484b3          	mul	s1,s1,a5
    10c4:	94aa                	add	s1,s1,a0
    10c6:	1982                	slli	s3,s3,0x20
    10c8:	0209d993          	srli	s3,s3,0x20
    10cc:	09c1                	addi	s3,s3,16
    10ce:	68dc                	ld	a5,144(s1)
    10d0:	99be                	add	s3,s3,a5
    10d2:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
    10d6:	0a21                	addi	s4,s4,8
    10d8:	07000613          	li	a2,112
    10dc:	4581                	li	a1,0
    10de:	9552                	add	a0,a0,s4
    10e0:	00000097          	auipc	ra,0x0
    10e4:	3e8080e7          	jalr	1000(ra) # 14c8 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
    10e8:	00000797          	auipc	a5,0x0
    10ec:	e5278793          	addi	a5,a5,-430 # f3a <thread_bootstrap>
    10f0:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
    10f2:	0134b823          	sd	s3,16(s1)

    if (thread)
    10f6:	000b0463          	beqz	s6,10fe <tcreate+0x164>
    {
        *thread = new_thread;
    10fa:	012b3023          	sd	s2,0(s6)
    }
}
    10fe:	60a6                	ld	ra,72(sp)
    1100:	6406                	ld	s0,64(sp)
    1102:	74e2                	ld	s1,56(sp)
    1104:	7942                	ld	s2,48(sp)
    1106:	79a2                	ld	s3,40(sp)
    1108:	7a02                	ld	s4,32(sp)
    110a:	6ae2                	ld	s5,24(sp)
    110c:	6b42                	ld	s6,16(sp)
    110e:	6ba2                	ld	s7,8(sp)
    1110:	6c02                	ld	s8,0(sp)
    1112:	6161                	addi	sp,sp,80
    1114:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
    1116:	00001597          	auipc	a1,0x1
    111a:	e5258593          	addi	a1,a1,-430 # 1f68 <malloc+0x454>
    111e:	00001517          	auipc	a0,0x1
    1122:	e8a50513          	addi	a0,a0,-374 # 1fa8 <malloc+0x494>
    1126:	00001097          	auipc	ra,0x1
    112a:	932080e7          	jalr	-1742(ra) # 1a58 <printf>
        exit(-1);
    112e:	557d                	li	a0,-1
    1130:	00000097          	auipc	ra,0x0
    1134:	5aa080e7          	jalr	1450(ra) # 16da <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
    1138:	00001597          	auipc	a1,0x1
    113c:	e3058593          	addi	a1,a1,-464 # 1f68 <malloc+0x454>
    1140:	00001517          	auipc	a0,0x1
    1144:	e9050513          	addi	a0,a0,-368 # 1fd0 <malloc+0x4bc>
    1148:	00001097          	auipc	ra,0x1
    114c:	910080e7          	jalr	-1776(ra) # 1a58 <printf>
            exit(-1);
    1150:	557d                	li	a0,-1
    1152:	00000097          	auipc	ra,0x0
    1156:	588080e7          	jalr	1416(ra) # 16da <exit>

000000000000115a <tjoin>:

int tjoin(int tid, void *status, uint size)
{
    115a:	715d                	addi	sp,sp,-80
    115c:	e486                	sd	ra,72(sp)
    115e:	e0a2                	sd	s0,64(sp)
    1160:	f84a                	sd	s2,48(sp)
    1162:	e45e                	sd	s7,8(sp)
    1164:	e062                	sd	s8,0(sp)
    1166:	0880                	addi	s0,sp,80
    1168:	892a                	mv	s2,a0
    116a:	8bae                	mv	s7,a1
    116c:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
    116e:	00000097          	auipc	ra,0x0
    1172:	c22080e7          	jalr	-990(ra) # d90 <threadlib_init>
    if (current_thread->tid == tid)
    1176:	00002697          	auipc	a3,0x2
    117a:	ea26b683          	ld	a3,-350(a3) # 3018 <current_thread>
    117e:	0006c783          	lbu	a5,0(a3)
    1182:	0f278763          	beq	a5,s2,1270 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
    1186:	47bd                	li	a5,15
    1188:	0f27e663          	bltu	a5,s2,1274 <tjoin+0x11a>
    118c:	fc26                	sd	s1,56(sp)
    118e:	f44e                	sd	s3,40(sp)
    1190:	f052                	sd	s4,32(sp)
    1192:	ec56                	sd	s5,24(sp)
    1194:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
    1196:	0b000713          	li	a4,176
    119a:	02e90733          	mul	a4,s2,a4
    119e:	00002797          	auipc	a5,0x2
    11a2:	27a78793          	addi	a5,a5,634 # 3418 <threads>
    11a6:	97ba                	add	a5,a5,a4
    11a8:	5fbc                	lw	a5,120(a5)
    11aa:	c7f9                	beqz	a5,1278 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
    11ac:	0b000713          	li	a4,176
    11b0:	02e90733          	mul	a4,s2,a4
    11b4:	00002797          	auipc	a5,0x2
    11b8:	26478793          	addi	a5,a5,612 # 3418 <threads>
    11bc:	97ba                	add	a5,a5,a4
    11be:	77dc                	ld	a5,168(a5)
    11c0:	c399                	beqz	a5,11c6 <tjoin+0x6c>
    11c2:	0cf69263          	bne	a3,a5,1286 <tjoin+0x12c>
    return &threads[tid];
    11c6:	0b000b13          	li	s6,176
    11ca:	03690b33          	mul	s6,s2,s6
    11ce:	00002797          	auipc	a5,0x2
    11d2:	24a78793          	addi	a5,a5,586 # 3418 <threads>
    11d6:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
    11d8:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
    11dc:	078b2703          	lw	a4,120(s6)
    11e0:	4799                	li	a5,6
    11e2:	02f70463          	beq	a4,a5,120a <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
    11e6:	00002a97          	auipc	s5,0x2
    11ea:	e32a8a93          	addi	s5,s5,-462 # 3018 <current_thread>
    11ee:	4a09                	li	s4,2
    while (target->state != EXITED)
    11f0:	84da                	mv	s1,s6
    11f2:	4999                	li	s3,6
        current_thread->state = SLEEPING;
    11f4:	000ab783          	ld	a5,0(s5)
    11f8:	0747ac23          	sw	s4,120(a5)
        tsched();
    11fc:	00000097          	auipc	ra,0x0
    1200:	c5c080e7          	jalr	-932(ra) # e58 <tsched>
    while (target->state != EXITED)
    1204:	5cbc                	lw	a5,120(s1)
    1206:	ff3797e3          	bne	a5,s3,11f4 <tjoin+0x9a>
    }

    if (status && size && target->result)
    120a:	040b8163          	beqz	s7,124c <tjoin+0xf2>
    120e:	020c0f63          	beqz	s8,124c <tjoin+0xf2>
    1212:	0b000713          	li	a4,176
    1216:	02e90733          	mul	a4,s2,a4
    121a:	00002797          	auipc	a5,0x2
    121e:	1fe78793          	addi	a5,a5,510 # 3418 <threads>
    1222:	97ba                	add	a5,a5,a4
    1224:	73cc                	ld	a1,160(a5)
    1226:	c19d                	beqz	a1,124c <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
    1228:	00002797          	auipc	a5,0x2
    122c:	1f078793          	addi	a5,a5,496 # 3418 <threads>
    1230:	97ba                	add	a5,a5,a4
    1232:	09c7a783          	lw	a5,156(a5)
    1236:	863e                	mv	a2,a5
    1238:	2781                	sext.w	a5,a5
    123a:	00fc7363          	bgeu	s8,a5,1240 <tjoin+0xe6>
    123e:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
    1240:	2601                	sext.w	a2,a2
    1242:	855e                	mv	a0,s7
    1244:	00000097          	auipc	ra,0x0
    1248:	3e0080e7          	jalr	992(ra) # 1624 <memmove>
    }

    reclaim_thread(target);
    124c:	855a                	mv	a0,s6
    124e:	00000097          	auipc	ra,0x0
    1252:	bbc080e7          	jalr	-1092(ra) # e0a <reclaim_thread>
    return 0;
    1256:	4501                	li	a0,0
    1258:	74e2                	ld	s1,56(sp)
    125a:	79a2                	ld	s3,40(sp)
    125c:	7a02                	ld	s4,32(sp)
    125e:	6ae2                	ld	s5,24(sp)
    1260:	6b42                	ld	s6,16(sp)
}
    1262:	60a6                	ld	ra,72(sp)
    1264:	6406                	ld	s0,64(sp)
    1266:	7942                	ld	s2,48(sp)
    1268:	6ba2                	ld	s7,8(sp)
    126a:	6c02                	ld	s8,0(sp)
    126c:	6161                	addi	sp,sp,80
    126e:	8082                	ret
        return -1;
    1270:	557d                	li	a0,-1
    1272:	bfc5                	j	1262 <tjoin+0x108>
        return -1;
    1274:	557d                	li	a0,-1
    1276:	b7f5                	j	1262 <tjoin+0x108>
    1278:	557d                	li	a0,-1
    127a:	74e2                	ld	s1,56(sp)
    127c:	79a2                	ld	s3,40(sp)
    127e:	7a02                	ld	s4,32(sp)
    1280:	6ae2                	ld	s5,24(sp)
    1282:	6b42                	ld	s6,16(sp)
    1284:	bff9                	j	1262 <tjoin+0x108>
        return -1;
    1286:	557d                	li	a0,-1
    1288:	74e2                	ld	s1,56(sp)
    128a:	79a2                	ld	s3,40(sp)
    128c:	7a02                	ld	s4,32(sp)
    128e:	6ae2                	ld	s5,24(sp)
    1290:	6b42                	ld	s6,16(sp)
    1292:	bfc1                	j	1262 <tjoin+0x108>

0000000000001294 <tyield>:

void tyield()
{
    1294:	1141                	addi	sp,sp,-16
    1296:	e406                	sd	ra,8(sp)
    1298:	e022                	sd	s0,0(sp)
    129a:	0800                	addi	s0,sp,16
    threadlib_init();
    129c:	00000097          	auipc	ra,0x0
    12a0:	af4080e7          	jalr	-1292(ra) # d90 <threadlib_init>
    if (current_thread->state == RUNNING)
    12a4:	00002797          	auipc	a5,0x2
    12a8:	d747b783          	ld	a5,-652(a5) # 3018 <current_thread>
    12ac:	5fb4                	lw	a3,120(a5)
    12ae:	4711                	li	a4,4
    12b0:	00e68a63          	beq	a3,a4,12c4 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
    12b4:	00000097          	auipc	ra,0x0
    12b8:	ba4080e7          	jalr	-1116(ra) # e58 <tsched>
}
    12bc:	60a2                	ld	ra,8(sp)
    12be:	6402                	ld	s0,0(sp)
    12c0:	0141                	addi	sp,sp,16
    12c2:	8082                	ret
        current_thread->state = RUNNABLE;
    12c4:	470d                	li	a4,3
    12c6:	dfb8                	sw	a4,120(a5)
    12c8:	b7f5                	j	12b4 <tyield+0x20>

00000000000012ca <twhoami>:

uint8 twhoami()
{
    12ca:	1141                	addi	sp,sp,-16
    12cc:	e406                	sd	ra,8(sp)
    12ce:	e022                	sd	s0,0(sp)
    12d0:	0800                	addi	s0,sp,16
    threadlib_init();
    12d2:	00000097          	auipc	ra,0x0
    12d6:	abe080e7          	jalr	-1346(ra) # d90 <threadlib_init>
    return current_thread->tid;
}
    12da:	00002797          	auipc	a5,0x2
    12de:	d3e7b783          	ld	a5,-706(a5) # 3018 <current_thread>
    12e2:	0007c503          	lbu	a0,0(a5)
    12e6:	60a2                	ld	ra,8(sp)
    12e8:	6402                	ld	s0,0(sp)
    12ea:	0141                	addi	sp,sp,16
    12ec:	8082                	ret

00000000000012ee <twaitall>:

void twaitall(void)
{
    12ee:	7179                	addi	sp,sp,-48
    12f0:	f406                	sd	ra,40(sp)
    12f2:	f022                	sd	s0,32(sp)
    12f4:	ec26                	sd	s1,24(sp)
    12f6:	e84a                	sd	s2,16(sp)
    12f8:	e44e                	sd	s3,8(sp)
    12fa:	1800                	addi	s0,sp,48
    threadlib_init();
    12fc:	00000097          	auipc	ra,0x0
    1300:	a94080e7          	jalr	-1388(ra) # d90 <threadlib_init>
    1304:	00003497          	auipc	s1,0x3
    1308:	c8c48493          	addi	s1,s1,-884 # 3f90 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
    130c:	4905                	li	s2,1
    130e:	a035                	j	133a <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
    1310:	17f5                	addi	a5,a5,-3
    1312:	0017b793          	seqz	a5,a5
    1316:	8e5d                	or	a2,a2,a5
                unfinished = 1;
    1318:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
    131a:	0b070713          	addi	a4,a4,176
    131e:	00970863          	beq	a4,s1,132e <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
    1322:	431c                	lw	a5,0(a4)
    1324:	dbfd                	beqz	a5,131a <twaitall+0x2c>
    1326:	ffa78693          	addi	a3,a5,-6
    132a:	f2fd                	bnez	a3,1310 <twaitall+0x22>
    132c:	b7fd                	j	131a <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
    132e:	cd95                	beqz	a1,136a <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
    1330:	ce01                	beqz	a2,1348 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
    1332:	00000097          	auipc	ra,0x0
    1336:	f62080e7          	jalr	-158(ra) # 1294 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
    133a:	00002717          	auipc	a4,0x2
    133e:	20670713          	addi	a4,a4,518 # 3540 <threads+0x128>
        int runnable = 0;
    1342:	4601                	li	a2,0
        int unfinished = 0;
    1344:	4581                	li	a1,0
    1346:	bff1                	j	1322 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
    1348:	00001597          	auipc	a1,0x1
    134c:	c2058593          	addi	a1,a1,-992 # 1f68 <malloc+0x454>
    1350:	00001517          	auipc	a0,0x1
    1354:	c2850513          	addi	a0,a0,-984 # 1f78 <malloc+0x464>
    1358:	00000097          	auipc	ra,0x0
    135c:	700080e7          	jalr	1792(ra) # 1a58 <printf>
            exit(-1);
    1360:	557d                	li	a0,-1
    1362:	00000097          	auipc	ra,0x0
    1366:	378080e7          	jalr	888(ra) # 16da <exit>
    136a:	00002497          	auipc	s1,0x2
    136e:	15e48493          	addi	s1,s1,350 # 34c8 <threads+0xb0>
    1372:	00003917          	auipc	s2,0x3
    1376:	8a590913          	addi	s2,s2,-1883 # 3c17 <threads+0x7ff>
    137a:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
    137e:	4999                	li	s3,6
    1380:	a029                	j	138a <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
    1382:	0b048493          	addi	s1,s1,176
    1386:	01248b63          	beq	s1,s2,139c <twaitall+0xae>
        if (threads[i].state == EXITED)
    138a:	5cbc                	lw	a5,120(s1)
    138c:	ff379be3          	bne	a5,s3,1382 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
    1390:	8526                	mv	a0,s1
    1392:	00000097          	auipc	ra,0x0
    1396:	a78080e7          	jalr	-1416(ra) # e0a <reclaim_thread>
    139a:	b7e5                	j	1382 <twaitall+0x94>
        }
    }
}
    139c:	70a2                	ld	ra,40(sp)
    139e:	7402                	ld	s0,32(sp)
    13a0:	64e2                	ld	s1,24(sp)
    13a2:	6942                	ld	s2,16(sp)
    13a4:	69a2                	ld	s3,8(sp)
    13a6:	6145                	addi	sp,sp,48
    13a8:	8082                	ret

00000000000013aa <tswtch>:
    13aa:	00153023          	sd	ra,0(a0)
    13ae:	00253423          	sd	sp,8(a0)
    13b2:	e900                	sd	s0,16(a0)
    13b4:	ed04                	sd	s1,24(a0)
    13b6:	03253023          	sd	s2,32(a0)
    13ba:	03353423          	sd	s3,40(a0)
    13be:	03453823          	sd	s4,48(a0)
    13c2:	03553c23          	sd	s5,56(a0)
    13c6:	05653023          	sd	s6,64(a0)
    13ca:	05753423          	sd	s7,72(a0)
    13ce:	05853823          	sd	s8,80(a0)
    13d2:	05953c23          	sd	s9,88(a0)
    13d6:	07a53023          	sd	s10,96(a0)
    13da:	07b53423          	sd	s11,104(a0)
    13de:	0005b083          	ld	ra,0(a1)
    13e2:	0085b103          	ld	sp,8(a1)
    13e6:	6980                	ld	s0,16(a1)
    13e8:	6d84                	ld	s1,24(a1)
    13ea:	0205b903          	ld	s2,32(a1)
    13ee:	0285b983          	ld	s3,40(a1)
    13f2:	0305ba03          	ld	s4,48(a1)
    13f6:	0385ba83          	ld	s5,56(a1)
    13fa:	0405bb03          	ld	s6,64(a1)
    13fe:	0485bb83          	ld	s7,72(a1)
    1402:	0505bc03          	ld	s8,80(a1)
    1406:	0585bc83          	ld	s9,88(a1)
    140a:	0605bd03          	ld	s10,96(a1)
    140e:	0685bd83          	ld	s11,104(a1)
    1412:	8082                	ret

0000000000001414 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
    1414:	1101                	addi	sp,sp,-32
    1416:	ec06                	sd	ra,24(sp)
    1418:	e822                	sd	s0,16(sp)
    141a:	e426                	sd	s1,8(sp)
    141c:	e04a                	sd	s2,0(sp)
    141e:	1000                	addi	s0,sp,32
    1420:	892a                	mv	s2,a0
    1422:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
    1424:	00000097          	auipc	ra,0x0
    1428:	ea6080e7          	jalr	-346(ra) # 12ca <twhoami>
    int res = main(argc, argv);
    142c:	85a6                	mv	a1,s1
    142e:	854a                	mv	a0,s2
    1430:	fffff097          	auipc	ra,0xfffff
    1434:	7de080e7          	jalr	2014(ra) # c0e <main>
    1438:	84aa                	mv	s1,a0
    twaitall();
    143a:	00000097          	auipc	ra,0x0
    143e:	eb4080e7          	jalr	-332(ra) # 12ee <twaitall>
    exit(res);
    1442:	8526                	mv	a0,s1
    1444:	00000097          	auipc	ra,0x0
    1448:	296080e7          	jalr	662(ra) # 16da <exit>

000000000000144c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    144c:	1141                	addi	sp,sp,-16
    144e:	e406                	sd	ra,8(sp)
    1450:	e022                	sd	s0,0(sp)
    1452:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
    1454:	87aa                	mv	a5,a0
    1456:	0585                	addi	a1,a1,1
    1458:	0785                	addi	a5,a5,1
    145a:	fff5c703          	lbu	a4,-1(a1)
    145e:	fee78fa3          	sb	a4,-1(a5)
    1462:	fb75                	bnez	a4,1456 <strcpy+0xa>
        ;
    return os;
}
    1464:	60a2                	ld	ra,8(sp)
    1466:	6402                	ld	s0,0(sp)
    1468:	0141                	addi	sp,sp,16
    146a:	8082                	ret

000000000000146c <strcmp>:

int strcmp(const char *p, const char *q)
{
    146c:	1141                	addi	sp,sp,-16
    146e:	e406                	sd	ra,8(sp)
    1470:	e022                	sd	s0,0(sp)
    1472:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    1474:	00054783          	lbu	a5,0(a0)
    1478:	cb91                	beqz	a5,148c <strcmp+0x20>
    147a:	0005c703          	lbu	a4,0(a1)
    147e:	00f71763          	bne	a4,a5,148c <strcmp+0x20>
        p++, q++;
    1482:	0505                	addi	a0,a0,1
    1484:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    1486:	00054783          	lbu	a5,0(a0)
    148a:	fbe5                	bnez	a5,147a <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
    148c:	0005c503          	lbu	a0,0(a1)
}
    1490:	40a7853b          	subw	a0,a5,a0
    1494:	60a2                	ld	ra,8(sp)
    1496:	6402                	ld	s0,0(sp)
    1498:	0141                	addi	sp,sp,16
    149a:	8082                	ret

000000000000149c <strlen>:

uint strlen(const char *s)
{
    149c:	1141                	addi	sp,sp,-16
    149e:	e406                	sd	ra,8(sp)
    14a0:	e022                	sd	s0,0(sp)
    14a2:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    14a4:	00054783          	lbu	a5,0(a0)
    14a8:	cf91                	beqz	a5,14c4 <strlen+0x28>
    14aa:	00150793          	addi	a5,a0,1
    14ae:	86be                	mv	a3,a5
    14b0:	0785                	addi	a5,a5,1
    14b2:	fff7c703          	lbu	a4,-1(a5)
    14b6:	ff65                	bnez	a4,14ae <strlen+0x12>
    14b8:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
    14bc:	60a2                	ld	ra,8(sp)
    14be:	6402                	ld	s0,0(sp)
    14c0:	0141                	addi	sp,sp,16
    14c2:	8082                	ret
    for (n = 0; s[n]; n++)
    14c4:	4501                	li	a0,0
    14c6:	bfdd                	j	14bc <strlen+0x20>

00000000000014c8 <memset>:

void *
memset(void *dst, int c, uint n)
{
    14c8:	1141                	addi	sp,sp,-16
    14ca:	e406                	sd	ra,8(sp)
    14cc:	e022                	sd	s0,0(sp)
    14ce:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
    14d0:	ca19                	beqz	a2,14e6 <memset+0x1e>
    14d2:	87aa                	mv	a5,a0
    14d4:	1602                	slli	a2,a2,0x20
    14d6:	9201                	srli	a2,a2,0x20
    14d8:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
    14dc:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
    14e0:	0785                	addi	a5,a5,1
    14e2:	fee79de3          	bne	a5,a4,14dc <memset+0x14>
    }
    return dst;
}
    14e6:	60a2                	ld	ra,8(sp)
    14e8:	6402                	ld	s0,0(sp)
    14ea:	0141                	addi	sp,sp,16
    14ec:	8082                	ret

00000000000014ee <strchr>:

char *
strchr(const char *s, char c)
{
    14ee:	1141                	addi	sp,sp,-16
    14f0:	e406                	sd	ra,8(sp)
    14f2:	e022                	sd	s0,0(sp)
    14f4:	0800                	addi	s0,sp,16
    for (; *s; s++)
    14f6:	00054783          	lbu	a5,0(a0)
    14fa:	cf81                	beqz	a5,1512 <strchr+0x24>
        if (*s == c)
    14fc:	00f58763          	beq	a1,a5,150a <strchr+0x1c>
    for (; *s; s++)
    1500:	0505                	addi	a0,a0,1
    1502:	00054783          	lbu	a5,0(a0)
    1506:	fbfd                	bnez	a5,14fc <strchr+0xe>
            return (char *)s;
    return 0;
    1508:	4501                	li	a0,0
}
    150a:	60a2                	ld	ra,8(sp)
    150c:	6402                	ld	s0,0(sp)
    150e:	0141                	addi	sp,sp,16
    1510:	8082                	ret
    return 0;
    1512:	4501                	li	a0,0
    1514:	bfdd                	j	150a <strchr+0x1c>

0000000000001516 <gets>:

char *
gets(char *buf, int max)
{
    1516:	711d                	addi	sp,sp,-96
    1518:	ec86                	sd	ra,88(sp)
    151a:	e8a2                	sd	s0,80(sp)
    151c:	e4a6                	sd	s1,72(sp)
    151e:	e0ca                	sd	s2,64(sp)
    1520:	fc4e                	sd	s3,56(sp)
    1522:	f852                	sd	s4,48(sp)
    1524:	f456                	sd	s5,40(sp)
    1526:	f05a                	sd	s6,32(sp)
    1528:	ec5e                	sd	s7,24(sp)
    152a:	e862                	sd	s8,16(sp)
    152c:	1080                	addi	s0,sp,96
    152e:	8baa                	mv	s7,a0
    1530:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
    1532:	892a                	mv	s2,a0
    1534:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
    1536:	faf40b13          	addi	s6,s0,-81
    153a:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
    153c:	8c26                	mv	s8,s1
    153e:	0014899b          	addiw	s3,s1,1
    1542:	84ce                	mv	s1,s3
    1544:	0349d663          	bge	s3,s4,1570 <gets+0x5a>
        cc = read(0, &c, 1);
    1548:	8656                	mv	a2,s5
    154a:	85da                	mv	a1,s6
    154c:	4501                	li	a0,0
    154e:	00000097          	auipc	ra,0x0
    1552:	1a4080e7          	jalr	420(ra) # 16f2 <read>
        if (cc < 1)
    1556:	00a05d63          	blez	a0,1570 <gets+0x5a>
            break;
        buf[i++] = c;
    155a:	faf44783          	lbu	a5,-81(s0)
    155e:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
    1562:	0905                	addi	s2,s2,1
    1564:	ff678713          	addi	a4,a5,-10
    1568:	c319                	beqz	a4,156e <gets+0x58>
    156a:	17cd                	addi	a5,a5,-13
    156c:	fbe1                	bnez	a5,153c <gets+0x26>
        buf[i++] = c;
    156e:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
    1570:	9c5e                	add	s8,s8,s7
    1572:	000c0023          	sb	zero,0(s8)
    return buf;
}
    1576:	855e                	mv	a0,s7
    1578:	60e6                	ld	ra,88(sp)
    157a:	6446                	ld	s0,80(sp)
    157c:	64a6                	ld	s1,72(sp)
    157e:	6906                	ld	s2,64(sp)
    1580:	79e2                	ld	s3,56(sp)
    1582:	7a42                	ld	s4,48(sp)
    1584:	7aa2                	ld	s5,40(sp)
    1586:	7b02                	ld	s6,32(sp)
    1588:	6be2                	ld	s7,24(sp)
    158a:	6c42                	ld	s8,16(sp)
    158c:	6125                	addi	sp,sp,96
    158e:	8082                	ret

0000000000001590 <stat>:

int stat(const char *n, struct stat *st)
{
    1590:	1101                	addi	sp,sp,-32
    1592:	ec06                	sd	ra,24(sp)
    1594:	e822                	sd	s0,16(sp)
    1596:	e04a                	sd	s2,0(sp)
    1598:	1000                	addi	s0,sp,32
    159a:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
    159c:	4581                	li	a1,0
    159e:	00000097          	auipc	ra,0x0
    15a2:	17c080e7          	jalr	380(ra) # 171a <open>
    if (fd < 0)
    15a6:	02054663          	bltz	a0,15d2 <stat+0x42>
    15aa:	e426                	sd	s1,8(sp)
    15ac:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
    15ae:	85ca                	mv	a1,s2
    15b0:	00000097          	auipc	ra,0x0
    15b4:	182080e7          	jalr	386(ra) # 1732 <fstat>
    15b8:	892a                	mv	s2,a0
    close(fd);
    15ba:	8526                	mv	a0,s1
    15bc:	00000097          	auipc	ra,0x0
    15c0:	146080e7          	jalr	326(ra) # 1702 <close>
    return r;
    15c4:	64a2                	ld	s1,8(sp)
}
    15c6:	854a                	mv	a0,s2
    15c8:	60e2                	ld	ra,24(sp)
    15ca:	6442                	ld	s0,16(sp)
    15cc:	6902                	ld	s2,0(sp)
    15ce:	6105                	addi	sp,sp,32
    15d0:	8082                	ret
        return -1;
    15d2:	57fd                	li	a5,-1
    15d4:	893e                	mv	s2,a5
    15d6:	bfc5                	j	15c6 <stat+0x36>

00000000000015d8 <atoi>:

int atoi(const char *s)
{
    15d8:	1141                	addi	sp,sp,-16
    15da:	e406                	sd	ra,8(sp)
    15dc:	e022                	sd	s0,0(sp)
    15de:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    15e0:	00054683          	lbu	a3,0(a0)
    15e4:	fd06879b          	addiw	a5,a3,-48
    15e8:	0ff7f793          	zext.b	a5,a5
    15ec:	4625                	li	a2,9
    15ee:	02f66963          	bltu	a2,a5,1620 <atoi+0x48>
    15f2:	872a                	mv	a4,a0
    n = 0;
    15f4:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
    15f6:	0705                	addi	a4,a4,1
    15f8:	0025179b          	slliw	a5,a0,0x2
    15fc:	9fa9                	addw	a5,a5,a0
    15fe:	0017979b          	slliw	a5,a5,0x1
    1602:	9fb5                	addw	a5,a5,a3
    1604:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    1608:	00074683          	lbu	a3,0(a4)
    160c:	fd06879b          	addiw	a5,a3,-48
    1610:	0ff7f793          	zext.b	a5,a5
    1614:	fef671e3          	bgeu	a2,a5,15f6 <atoi+0x1e>
    return n;
}
    1618:	60a2                	ld	ra,8(sp)
    161a:	6402                	ld	s0,0(sp)
    161c:	0141                	addi	sp,sp,16
    161e:	8082                	ret
    n = 0;
    1620:	4501                	li	a0,0
    1622:	bfdd                	j	1618 <atoi+0x40>

0000000000001624 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    1624:	1141                	addi	sp,sp,-16
    1626:	e406                	sd	ra,8(sp)
    1628:	e022                	sd	s0,0(sp)
    162a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
    162c:	02b57563          	bgeu	a0,a1,1656 <memmove+0x32>
    {
        while (n-- > 0)
    1630:	00c05f63          	blez	a2,164e <memmove+0x2a>
    1634:	1602                	slli	a2,a2,0x20
    1636:	9201                	srli	a2,a2,0x20
    1638:	00c507b3          	add	a5,a0,a2
    dst = vdst;
    163c:	872a                	mv	a4,a0
            *dst++ = *src++;
    163e:	0585                	addi	a1,a1,1
    1640:	0705                	addi	a4,a4,1
    1642:	fff5c683          	lbu	a3,-1(a1)
    1646:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    164a:	fee79ae3          	bne	a5,a4,163e <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    164e:	60a2                	ld	ra,8(sp)
    1650:	6402                	ld	s0,0(sp)
    1652:	0141                	addi	sp,sp,16
    1654:	8082                	ret
        while (n-- > 0)
    1656:	fec05ce3          	blez	a2,164e <memmove+0x2a>
        dst += n;
    165a:	00c50733          	add	a4,a0,a2
        src += n;
    165e:	95b2                	add	a1,a1,a2
    1660:	fff6079b          	addiw	a5,a2,-1
    1664:	1782                	slli	a5,a5,0x20
    1666:	9381                	srli	a5,a5,0x20
    1668:	fff7c793          	not	a5,a5
    166c:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    166e:	15fd                	addi	a1,a1,-1
    1670:	177d                	addi	a4,a4,-1
    1672:	0005c683          	lbu	a3,0(a1)
    1676:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    167a:	fef71ae3          	bne	a4,a5,166e <memmove+0x4a>
    167e:	bfc1                	j	164e <memmove+0x2a>

0000000000001680 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    1680:	1141                	addi	sp,sp,-16
    1682:	e406                	sd	ra,8(sp)
    1684:	e022                	sd	s0,0(sp)
    1686:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
    1688:	c61d                	beqz	a2,16b6 <memcmp+0x36>
    168a:	1602                	slli	a2,a2,0x20
    168c:	9201                	srli	a2,a2,0x20
    168e:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
    1692:	00054783          	lbu	a5,0(a0)
    1696:	0005c703          	lbu	a4,0(a1)
    169a:	00e79863          	bne	a5,a4,16aa <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
    169e:	0505                	addi	a0,a0,1
        p2++;
    16a0:	0585                	addi	a1,a1,1
    while (n-- > 0)
    16a2:	fed518e3          	bne	a0,a3,1692 <memcmp+0x12>
    }
    return 0;
    16a6:	4501                	li	a0,0
    16a8:	a019                	j	16ae <memcmp+0x2e>
            return *p1 - *p2;
    16aa:	40e7853b          	subw	a0,a5,a4
}
    16ae:	60a2                	ld	ra,8(sp)
    16b0:	6402                	ld	s0,0(sp)
    16b2:	0141                	addi	sp,sp,16
    16b4:	8082                	ret
    return 0;
    16b6:	4501                	li	a0,0
    16b8:	bfdd                	j	16ae <memcmp+0x2e>

00000000000016ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    16ba:	1141                	addi	sp,sp,-16
    16bc:	e406                	sd	ra,8(sp)
    16be:	e022                	sd	s0,0(sp)
    16c0:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    16c2:	00000097          	auipc	ra,0x0
    16c6:	f62080e7          	jalr	-158(ra) # 1624 <memmove>
}
    16ca:	60a2                	ld	ra,8(sp)
    16cc:	6402                	ld	s0,0(sp)
    16ce:	0141                	addi	sp,sp,16
    16d0:	8082                	ret

00000000000016d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    16d2:	4885                	li	a7,1
 ecall
    16d4:	00000073          	ecall
 ret
    16d8:	8082                	ret

00000000000016da <exit>:
.global exit
exit:
 li a7, SYS_exit
    16da:	4889                	li	a7,2
 ecall
    16dc:	00000073          	ecall
 ret
    16e0:	8082                	ret

00000000000016e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    16e2:	488d                	li	a7,3
 ecall
    16e4:	00000073          	ecall
 ret
    16e8:	8082                	ret

00000000000016ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    16ea:	4891                	li	a7,4
 ecall
    16ec:	00000073          	ecall
 ret
    16f0:	8082                	ret

00000000000016f2 <read>:
.global read
read:
 li a7, SYS_read
    16f2:	4895                	li	a7,5
 ecall
    16f4:	00000073          	ecall
 ret
    16f8:	8082                	ret

00000000000016fa <write>:
.global write
write:
 li a7, SYS_write
    16fa:	48c1                	li	a7,16
 ecall
    16fc:	00000073          	ecall
 ret
    1700:	8082                	ret

0000000000001702 <close>:
.global close
close:
 li a7, SYS_close
    1702:	48d5                	li	a7,21
 ecall
    1704:	00000073          	ecall
 ret
    1708:	8082                	ret

000000000000170a <kill>:
.global kill
kill:
 li a7, SYS_kill
    170a:	4899                	li	a7,6
 ecall
    170c:	00000073          	ecall
 ret
    1710:	8082                	ret

0000000000001712 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1712:	489d                	li	a7,7
 ecall
    1714:	00000073          	ecall
 ret
    1718:	8082                	ret

000000000000171a <open>:
.global open
open:
 li a7, SYS_open
    171a:	48bd                	li	a7,15
 ecall
    171c:	00000073          	ecall
 ret
    1720:	8082                	ret

0000000000001722 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1722:	48c5                	li	a7,17
 ecall
    1724:	00000073          	ecall
 ret
    1728:	8082                	ret

000000000000172a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    172a:	48c9                	li	a7,18
 ecall
    172c:	00000073          	ecall
 ret
    1730:	8082                	ret

0000000000001732 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1732:	48a1                	li	a7,8
 ecall
    1734:	00000073          	ecall
 ret
    1738:	8082                	ret

000000000000173a <link>:
.global link
link:
 li a7, SYS_link
    173a:	48cd                	li	a7,19
 ecall
    173c:	00000073          	ecall
 ret
    1740:	8082                	ret

0000000000001742 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1742:	48d1                	li	a7,20
 ecall
    1744:	00000073          	ecall
 ret
    1748:	8082                	ret

000000000000174a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    174a:	48a5                	li	a7,9
 ecall
    174c:	00000073          	ecall
 ret
    1750:	8082                	ret

0000000000001752 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1752:	48a9                	li	a7,10
 ecall
    1754:	00000073          	ecall
 ret
    1758:	8082                	ret

000000000000175a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    175a:	48ad                	li	a7,11
 ecall
    175c:	00000073          	ecall
 ret
    1760:	8082                	ret

0000000000001762 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1762:	48b1                	li	a7,12
 ecall
    1764:	00000073          	ecall
 ret
    1768:	8082                	ret

000000000000176a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    176a:	48b5                	li	a7,13
 ecall
    176c:	00000073          	ecall
 ret
    1770:	8082                	ret

0000000000001772 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1772:	48b9                	li	a7,14
 ecall
    1774:	00000073          	ecall
 ret
    1778:	8082                	ret

000000000000177a <ps>:
.global ps
ps:
 li a7, SYS_ps
    177a:	48d9                	li	a7,22
 ecall
    177c:	00000073          	ecall
 ret
    1780:	8082                	ret

0000000000001782 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    1782:	48dd                	li	a7,23
 ecall
    1784:	00000073          	ecall
 ret
    1788:	8082                	ret

000000000000178a <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    178a:	48e1                	li	a7,24
 ecall
    178c:	00000073          	ecall
 ret
    1790:	8082                	ret

0000000000001792 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1792:	1101                	addi	sp,sp,-32
    1794:	ec06                	sd	ra,24(sp)
    1796:	e822                	sd	s0,16(sp)
    1798:	1000                	addi	s0,sp,32
    179a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    179e:	4605                	li	a2,1
    17a0:	fef40593          	addi	a1,s0,-17
    17a4:	00000097          	auipc	ra,0x0
    17a8:	f56080e7          	jalr	-170(ra) # 16fa <write>
}
    17ac:	60e2                	ld	ra,24(sp)
    17ae:	6442                	ld	s0,16(sp)
    17b0:	6105                	addi	sp,sp,32
    17b2:	8082                	ret

00000000000017b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    17b4:	7139                	addi	sp,sp,-64
    17b6:	fc06                	sd	ra,56(sp)
    17b8:	f822                	sd	s0,48(sp)
    17ba:	f04a                	sd	s2,32(sp)
    17bc:	ec4e                	sd	s3,24(sp)
    17be:	0080                	addi	s0,sp,64
    17c0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    17c2:	cad9                	beqz	a3,1858 <printint+0xa4>
    17c4:	01f5d79b          	srliw	a5,a1,0x1f
    17c8:	cbc1                	beqz	a5,1858 <printint+0xa4>
    neg = 1;
    x = -xx;
    17ca:	40b005bb          	negw	a1,a1
    neg = 1;
    17ce:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    17d0:	fc040993          	addi	s3,s0,-64
  neg = 0;
    17d4:	86ce                	mv	a3,s3
  i = 0;
    17d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    17d8:	00001817          	auipc	a6,0x1
    17dc:	8e080813          	addi	a6,a6,-1824 # 20b8 <digits>
    17e0:	88ba                	mv	a7,a4
    17e2:	0017051b          	addiw	a0,a4,1
    17e6:	872a                	mv	a4,a0
    17e8:	02c5f7bb          	remuw	a5,a1,a2
    17ec:	1782                	slli	a5,a5,0x20
    17ee:	9381                	srli	a5,a5,0x20
    17f0:	97c2                	add	a5,a5,a6
    17f2:	0007c783          	lbu	a5,0(a5)
    17f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    17fa:	87ae                	mv	a5,a1
    17fc:	02c5d5bb          	divuw	a1,a1,a2
    1800:	0685                	addi	a3,a3,1
    1802:	fcc7ffe3          	bgeu	a5,a2,17e0 <printint+0x2c>
  if(neg)
    1806:	00030c63          	beqz	t1,181e <printint+0x6a>
    buf[i++] = '-';
    180a:	fd050793          	addi	a5,a0,-48
    180e:	00878533          	add	a0,a5,s0
    1812:	02d00793          	li	a5,45
    1816:	fef50823          	sb	a5,-16(a0)
    181a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    181e:	02e05763          	blez	a4,184c <printint+0x98>
    1822:	f426                	sd	s1,40(sp)
    1824:	377d                	addiw	a4,a4,-1
    1826:	00e984b3          	add	s1,s3,a4
    182a:	19fd                	addi	s3,s3,-1
    182c:	99ba                	add	s3,s3,a4
    182e:	1702                	slli	a4,a4,0x20
    1830:	9301                	srli	a4,a4,0x20
    1832:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1836:	0004c583          	lbu	a1,0(s1)
    183a:	854a                	mv	a0,s2
    183c:	00000097          	auipc	ra,0x0
    1840:	f56080e7          	jalr	-170(ra) # 1792 <putc>
  while(--i >= 0)
    1844:	14fd                	addi	s1,s1,-1
    1846:	ff3498e3          	bne	s1,s3,1836 <printint+0x82>
    184a:	74a2                	ld	s1,40(sp)
}
    184c:	70e2                	ld	ra,56(sp)
    184e:	7442                	ld	s0,48(sp)
    1850:	7902                	ld	s2,32(sp)
    1852:	69e2                	ld	s3,24(sp)
    1854:	6121                	addi	sp,sp,64
    1856:	8082                	ret
  neg = 0;
    1858:	4301                	li	t1,0
    185a:	bf9d                	j	17d0 <printint+0x1c>

000000000000185c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    185c:	715d                	addi	sp,sp,-80
    185e:	e486                	sd	ra,72(sp)
    1860:	e0a2                	sd	s0,64(sp)
    1862:	f84a                	sd	s2,48(sp)
    1864:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1866:	0005c903          	lbu	s2,0(a1)
    186a:	1a090b63          	beqz	s2,1a20 <vprintf+0x1c4>
    186e:	fc26                	sd	s1,56(sp)
    1870:	f44e                	sd	s3,40(sp)
    1872:	f052                	sd	s4,32(sp)
    1874:	ec56                	sd	s5,24(sp)
    1876:	e85a                	sd	s6,16(sp)
    1878:	e45e                	sd	s7,8(sp)
    187a:	8aaa                	mv	s5,a0
    187c:	8bb2                	mv	s7,a2
    187e:	00158493          	addi	s1,a1,1
  state = 0;
    1882:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1884:	02500a13          	li	s4,37
    1888:	4b55                	li	s6,21
    188a:	a839                	j	18a8 <vprintf+0x4c>
        putc(fd, c);
    188c:	85ca                	mv	a1,s2
    188e:	8556                	mv	a0,s5
    1890:	00000097          	auipc	ra,0x0
    1894:	f02080e7          	jalr	-254(ra) # 1792 <putc>
    1898:	a019                	j	189e <vprintf+0x42>
    } else if(state == '%'){
    189a:	01498d63          	beq	s3,s4,18b4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    189e:	0485                	addi	s1,s1,1
    18a0:	fff4c903          	lbu	s2,-1(s1)
    18a4:	16090863          	beqz	s2,1a14 <vprintf+0x1b8>
    if(state == 0){
    18a8:	fe0999e3          	bnez	s3,189a <vprintf+0x3e>
      if(c == '%'){
    18ac:	ff4910e3          	bne	s2,s4,188c <vprintf+0x30>
        state = '%';
    18b0:	89d2                	mv	s3,s4
    18b2:	b7f5                	j	189e <vprintf+0x42>
      if(c == 'd'){
    18b4:	13490563          	beq	s2,s4,19de <vprintf+0x182>
    18b8:	f9d9079b          	addiw	a5,s2,-99
    18bc:	0ff7f793          	zext.b	a5,a5
    18c0:	12fb6863          	bltu	s6,a5,19f0 <vprintf+0x194>
    18c4:	f9d9079b          	addiw	a5,s2,-99
    18c8:	0ff7f713          	zext.b	a4,a5
    18cc:	12eb6263          	bltu	s6,a4,19f0 <vprintf+0x194>
    18d0:	00271793          	slli	a5,a4,0x2
    18d4:	00000717          	auipc	a4,0x0
    18d8:	78c70713          	addi	a4,a4,1932 # 2060 <malloc+0x54c>
    18dc:	97ba                	add	a5,a5,a4
    18de:	439c                	lw	a5,0(a5)
    18e0:	97ba                	add	a5,a5,a4
    18e2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    18e4:	008b8913          	addi	s2,s7,8
    18e8:	4685                	li	a3,1
    18ea:	4629                	li	a2,10
    18ec:	000ba583          	lw	a1,0(s7)
    18f0:	8556                	mv	a0,s5
    18f2:	00000097          	auipc	ra,0x0
    18f6:	ec2080e7          	jalr	-318(ra) # 17b4 <printint>
    18fa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    18fc:	4981                	li	s3,0
    18fe:	b745                	j	189e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1900:	008b8913          	addi	s2,s7,8
    1904:	4681                	li	a3,0
    1906:	4629                	li	a2,10
    1908:	000ba583          	lw	a1,0(s7)
    190c:	8556                	mv	a0,s5
    190e:	00000097          	auipc	ra,0x0
    1912:	ea6080e7          	jalr	-346(ra) # 17b4 <printint>
    1916:	8bca                	mv	s7,s2
      state = 0;
    1918:	4981                	li	s3,0
    191a:	b751                	j	189e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    191c:	008b8913          	addi	s2,s7,8
    1920:	4681                	li	a3,0
    1922:	4641                	li	a2,16
    1924:	000ba583          	lw	a1,0(s7)
    1928:	8556                	mv	a0,s5
    192a:	00000097          	auipc	ra,0x0
    192e:	e8a080e7          	jalr	-374(ra) # 17b4 <printint>
    1932:	8bca                	mv	s7,s2
      state = 0;
    1934:	4981                	li	s3,0
    1936:	b7a5                	j	189e <vprintf+0x42>
    1938:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    193a:	008b8793          	addi	a5,s7,8
    193e:	8c3e                	mv	s8,a5
    1940:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1944:	03000593          	li	a1,48
    1948:	8556                	mv	a0,s5
    194a:	00000097          	auipc	ra,0x0
    194e:	e48080e7          	jalr	-440(ra) # 1792 <putc>
  putc(fd, 'x');
    1952:	07800593          	li	a1,120
    1956:	8556                	mv	a0,s5
    1958:	00000097          	auipc	ra,0x0
    195c:	e3a080e7          	jalr	-454(ra) # 1792 <putc>
    1960:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1962:	00000b97          	auipc	s7,0x0
    1966:	756b8b93          	addi	s7,s7,1878 # 20b8 <digits>
    196a:	03c9d793          	srli	a5,s3,0x3c
    196e:	97de                	add	a5,a5,s7
    1970:	0007c583          	lbu	a1,0(a5)
    1974:	8556                	mv	a0,s5
    1976:	00000097          	auipc	ra,0x0
    197a:	e1c080e7          	jalr	-484(ra) # 1792 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    197e:	0992                	slli	s3,s3,0x4
    1980:	397d                	addiw	s2,s2,-1
    1982:	fe0914e3          	bnez	s2,196a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    1986:	8be2                	mv	s7,s8
      state = 0;
    1988:	4981                	li	s3,0
    198a:	6c02                	ld	s8,0(sp)
    198c:	bf09                	j	189e <vprintf+0x42>
        s = va_arg(ap, char*);
    198e:	008b8993          	addi	s3,s7,8
    1992:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1996:	02090163          	beqz	s2,19b8 <vprintf+0x15c>
        while(*s != 0){
    199a:	00094583          	lbu	a1,0(s2)
    199e:	c9a5                	beqz	a1,1a0e <vprintf+0x1b2>
          putc(fd, *s);
    19a0:	8556                	mv	a0,s5
    19a2:	00000097          	auipc	ra,0x0
    19a6:	df0080e7          	jalr	-528(ra) # 1792 <putc>
          s++;
    19aa:	0905                	addi	s2,s2,1
        while(*s != 0){
    19ac:	00094583          	lbu	a1,0(s2)
    19b0:	f9e5                	bnez	a1,19a0 <vprintf+0x144>
        s = va_arg(ap, char*);
    19b2:	8bce                	mv	s7,s3
      state = 0;
    19b4:	4981                	li	s3,0
    19b6:	b5e5                	j	189e <vprintf+0x42>
          s = "(null)";
    19b8:	00000917          	auipc	s2,0x0
    19bc:	64090913          	addi	s2,s2,1600 # 1ff8 <malloc+0x4e4>
        while(*s != 0){
    19c0:	02800593          	li	a1,40
    19c4:	bff1                	j	19a0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    19c6:	008b8913          	addi	s2,s7,8
    19ca:	000bc583          	lbu	a1,0(s7)
    19ce:	8556                	mv	a0,s5
    19d0:	00000097          	auipc	ra,0x0
    19d4:	dc2080e7          	jalr	-574(ra) # 1792 <putc>
    19d8:	8bca                	mv	s7,s2
      state = 0;
    19da:	4981                	li	s3,0
    19dc:	b5c9                	j	189e <vprintf+0x42>
        putc(fd, c);
    19de:	02500593          	li	a1,37
    19e2:	8556                	mv	a0,s5
    19e4:	00000097          	auipc	ra,0x0
    19e8:	dae080e7          	jalr	-594(ra) # 1792 <putc>
      state = 0;
    19ec:	4981                	li	s3,0
    19ee:	bd45                	j	189e <vprintf+0x42>
        putc(fd, '%');
    19f0:	02500593          	li	a1,37
    19f4:	8556                	mv	a0,s5
    19f6:	00000097          	auipc	ra,0x0
    19fa:	d9c080e7          	jalr	-612(ra) # 1792 <putc>
        putc(fd, c);
    19fe:	85ca                	mv	a1,s2
    1a00:	8556                	mv	a0,s5
    1a02:	00000097          	auipc	ra,0x0
    1a06:	d90080e7          	jalr	-624(ra) # 1792 <putc>
      state = 0;
    1a0a:	4981                	li	s3,0
    1a0c:	bd49                	j	189e <vprintf+0x42>
        s = va_arg(ap, char*);
    1a0e:	8bce                	mv	s7,s3
      state = 0;
    1a10:	4981                	li	s3,0
    1a12:	b571                	j	189e <vprintf+0x42>
    1a14:	74e2                	ld	s1,56(sp)
    1a16:	79a2                	ld	s3,40(sp)
    1a18:	7a02                	ld	s4,32(sp)
    1a1a:	6ae2                	ld	s5,24(sp)
    1a1c:	6b42                	ld	s6,16(sp)
    1a1e:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1a20:	60a6                	ld	ra,72(sp)
    1a22:	6406                	ld	s0,64(sp)
    1a24:	7942                	ld	s2,48(sp)
    1a26:	6161                	addi	sp,sp,80
    1a28:	8082                	ret

0000000000001a2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1a2a:	715d                	addi	sp,sp,-80
    1a2c:	ec06                	sd	ra,24(sp)
    1a2e:	e822                	sd	s0,16(sp)
    1a30:	1000                	addi	s0,sp,32
    1a32:	e010                	sd	a2,0(s0)
    1a34:	e414                	sd	a3,8(s0)
    1a36:	e818                	sd	a4,16(s0)
    1a38:	ec1c                	sd	a5,24(s0)
    1a3a:	03043023          	sd	a6,32(s0)
    1a3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1a42:	8622                	mv	a2,s0
    1a44:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1a48:	00000097          	auipc	ra,0x0
    1a4c:	e14080e7          	jalr	-492(ra) # 185c <vprintf>
}
    1a50:	60e2                	ld	ra,24(sp)
    1a52:	6442                	ld	s0,16(sp)
    1a54:	6161                	addi	sp,sp,80
    1a56:	8082                	ret

0000000000001a58 <printf>:

void
printf(const char *fmt, ...)
{
    1a58:	711d                	addi	sp,sp,-96
    1a5a:	ec06                	sd	ra,24(sp)
    1a5c:	e822                	sd	s0,16(sp)
    1a5e:	1000                	addi	s0,sp,32
    1a60:	e40c                	sd	a1,8(s0)
    1a62:	e810                	sd	a2,16(s0)
    1a64:	ec14                	sd	a3,24(s0)
    1a66:	f018                	sd	a4,32(s0)
    1a68:	f41c                	sd	a5,40(s0)
    1a6a:	03043823          	sd	a6,48(s0)
    1a6e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1a72:	00840613          	addi	a2,s0,8
    1a76:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1a7a:	85aa                	mv	a1,a0
    1a7c:	4505                	li	a0,1
    1a7e:	00000097          	auipc	ra,0x0
    1a82:	dde080e7          	jalr	-546(ra) # 185c <vprintf>
}
    1a86:	60e2                	ld	ra,24(sp)
    1a88:	6442                	ld	s0,16(sp)
    1a8a:	6125                	addi	sp,sp,96
    1a8c:	8082                	ret

0000000000001a8e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    1a8e:	1141                	addi	sp,sp,-16
    1a90:	e406                	sd	ra,8(sp)
    1a92:	e022                	sd	s0,0(sp)
    1a94:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    1a96:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a9a:	00001797          	auipc	a5,0x1
    1a9e:	5867b783          	ld	a5,1414(a5) # 3020 <freep>
    1aa2:	a039                	j	1ab0 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1aa4:	6398                	ld	a4,0(a5)
    1aa6:	00e7e463          	bltu	a5,a4,1aae <free+0x20>
    1aaa:	00e6ea63          	bltu	a3,a4,1abe <free+0x30>
{
    1aae:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ab0:	fed7fae3          	bgeu	a5,a3,1aa4 <free+0x16>
    1ab4:	6398                	ld	a4,0(a5)
    1ab6:	00e6e463          	bltu	a3,a4,1abe <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1aba:	fee7eae3          	bltu	a5,a4,1aae <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    1abe:	ff852583          	lw	a1,-8(a0)
    1ac2:	6390                	ld	a2,0(a5)
    1ac4:	02059813          	slli	a6,a1,0x20
    1ac8:	01c85713          	srli	a4,a6,0x1c
    1acc:	9736                	add	a4,a4,a3
    1ace:	02e60563          	beq	a2,a4,1af8 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    1ad2:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    1ad6:	4790                	lw	a2,8(a5)
    1ad8:	02061593          	slli	a1,a2,0x20
    1adc:	01c5d713          	srli	a4,a1,0x1c
    1ae0:	973e                	add	a4,a4,a5
    1ae2:	02e68263          	beq	a3,a4,1b06 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    1ae6:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    1ae8:	00001717          	auipc	a4,0x1
    1aec:	52f73c23          	sd	a5,1336(a4) # 3020 <freep>
}
    1af0:	60a2                	ld	ra,8(sp)
    1af2:	6402                	ld	s0,0(sp)
    1af4:	0141                	addi	sp,sp,16
    1af6:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    1af8:	4618                	lw	a4,8(a2)
    1afa:	9f2d                	addw	a4,a4,a1
    1afc:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    1b00:	6398                	ld	a4,0(a5)
    1b02:	6310                	ld	a2,0(a4)
    1b04:	b7f9                	j	1ad2 <free+0x44>
        p->s.size += bp->s.size;
    1b06:	ff852703          	lw	a4,-8(a0)
    1b0a:	9f31                	addw	a4,a4,a2
    1b0c:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    1b0e:	ff053683          	ld	a3,-16(a0)
    1b12:	bfd1                	j	1ae6 <free+0x58>

0000000000001b14 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    1b14:	7139                	addi	sp,sp,-64
    1b16:	fc06                	sd	ra,56(sp)
    1b18:	f822                	sd	s0,48(sp)
    1b1a:	f04a                	sd	s2,32(sp)
    1b1c:	ec4e                	sd	s3,24(sp)
    1b1e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1b20:	02051993          	slli	s3,a0,0x20
    1b24:	0209d993          	srli	s3,s3,0x20
    1b28:	09bd                	addi	s3,s3,15
    1b2a:	0049d993          	srli	s3,s3,0x4
    1b2e:	2985                	addiw	s3,s3,1
    1b30:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    1b32:	00001517          	auipc	a0,0x1
    1b36:	4ee53503          	ld	a0,1262(a0) # 3020 <freep>
    1b3a:	c905                	beqz	a0,1b6a <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1b3c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1b3e:	4798                	lw	a4,8(a5)
    1b40:	09377a63          	bgeu	a4,s3,1bd4 <malloc+0xc0>
    1b44:	f426                	sd	s1,40(sp)
    1b46:	e852                	sd	s4,16(sp)
    1b48:	e456                	sd	s5,8(sp)
    1b4a:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1b4c:	8a4e                	mv	s4,s3
    1b4e:	6705                	lui	a4,0x1
    1b50:	00e9f363          	bgeu	s3,a4,1b56 <malloc+0x42>
    1b54:	6a05                	lui	s4,0x1
    1b56:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1b5a:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1b5e:	00001497          	auipc	s1,0x1
    1b62:	4c248493          	addi	s1,s1,1218 # 3020 <freep>
    if (p == (char *)-1)
    1b66:	5afd                	li	s5,-1
    1b68:	a089                	j	1baa <malloc+0x96>
    1b6a:	f426                	sd	s1,40(sp)
    1b6c:	e852                	sd	s4,16(sp)
    1b6e:	e456                	sd	s5,8(sp)
    1b70:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    1b72:	00002797          	auipc	a5,0x2
    1b76:	3a678793          	addi	a5,a5,934 # 3f18 <base>
    1b7a:	00001717          	auipc	a4,0x1
    1b7e:	4af73323          	sd	a5,1190(a4) # 3020 <freep>
    1b82:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1b84:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1b88:	b7d1                	j	1b4c <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    1b8a:	6398                	ld	a4,0(a5)
    1b8c:	e118                	sd	a4,0(a0)
    1b8e:	a8b9                	j	1bec <malloc+0xd8>
    hp->s.size = nu;
    1b90:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1b94:	0541                	addi	a0,a0,16
    1b96:	00000097          	auipc	ra,0x0
    1b9a:	ef8080e7          	jalr	-264(ra) # 1a8e <free>
    return freep;
    1b9e:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1ba0:	c135                	beqz	a0,1c04 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1ba2:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1ba4:	4798                	lw	a4,8(a5)
    1ba6:	03277363          	bgeu	a4,s2,1bcc <malloc+0xb8>
        if (p == freep)
    1baa:	6098                	ld	a4,0(s1)
    1bac:	853e                	mv	a0,a5
    1bae:	fef71ae3          	bne	a4,a5,1ba2 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1bb2:	8552                	mv	a0,s4
    1bb4:	00000097          	auipc	ra,0x0
    1bb8:	bae080e7          	jalr	-1106(ra) # 1762 <sbrk>
    if (p == (char *)-1)
    1bbc:	fd551ae3          	bne	a0,s5,1b90 <malloc+0x7c>
                return 0;
    1bc0:	4501                	li	a0,0
    1bc2:	74a2                	ld	s1,40(sp)
    1bc4:	6a42                	ld	s4,16(sp)
    1bc6:	6aa2                	ld	s5,8(sp)
    1bc8:	6b02                	ld	s6,0(sp)
    1bca:	a03d                	j	1bf8 <malloc+0xe4>
    1bcc:	74a2                	ld	s1,40(sp)
    1bce:	6a42                	ld	s4,16(sp)
    1bd0:	6aa2                	ld	s5,8(sp)
    1bd2:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1bd4:	fae90be3          	beq	s2,a4,1b8a <malloc+0x76>
                p->s.size -= nunits;
    1bd8:	4137073b          	subw	a4,a4,s3
    1bdc:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1bde:	02071693          	slli	a3,a4,0x20
    1be2:	01c6d713          	srli	a4,a3,0x1c
    1be6:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1be8:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1bec:	00001717          	auipc	a4,0x1
    1bf0:	42a73a23          	sd	a0,1076(a4) # 3020 <freep>
            return (void *)(p + 1);
    1bf4:	01078513          	addi	a0,a5,16
    }
}
    1bf8:	70e2                	ld	ra,56(sp)
    1bfa:	7442                	ld	s0,48(sp)
    1bfc:	7902                	ld	s2,32(sp)
    1bfe:	69e2                	ld	s3,24(sp)
    1c00:	6121                	addi	sp,sp,64
    1c02:	8082                	ret
    1c04:	74a2                	ld	s1,40(sp)
    1c06:	6a42                	ld	s4,16(sp)
    1c08:	6aa2                	ld	s5,8(sp)
    1c0a:	6b02                	ld	s6,0(sp)
    1c0c:	b7f5                	j	1bf8 <malloc+0xe4>
