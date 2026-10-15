
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       c:	00001097          	auipc	ra,0x1
      10:	b04080e7          	jalr	-1276(ra) # b10 <strlen>
      14:	02051793          	slli	a5,a0,0x20
      18:	9381                	srli	a5,a5,0x20
      1a:	97a6                	add	a5,a5,s1
      1c:	02f00693          	li	a3,47
      20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
      24:	0007c703          	lbu	a4,0(a5)
      28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
      2c:	17fd                	addi	a5,a5,-1
      2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
      32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      36:	8526                	mv	a0,s1
      38:	00001097          	auipc	ra,0x1
      3c:	ad8080e7          	jalr	-1320(ra) # b10 <strlen>
      40:	47b5                	li	a5,13
      42:	00a7f863          	bgeu	a5,a0,52 <fmtname+0x52>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
      46:	8526                	mv	a0,s1
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6105                	addi	sp,sp,32
      50:	8082                	ret
      52:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
      54:	8526                	mv	a0,s1
      56:	00001097          	auipc	ra,0x1
      5a:	aba080e7          	jalr	-1350(ra) # b10 <strlen>
      5e:	862a                	mv	a2,a0
      60:	85a6                	mv	a1,s1
      62:	00002517          	auipc	a0,0x2
      66:	fbe50513          	addi	a0,a0,-66 # 2020 <buf.0>
      6a:	00001097          	auipc	ra,0x1
      6e:	c2e080e7          	jalr	-978(ra) # c98 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      72:	8526                	mv	a0,s1
      74:	00001097          	auipc	ra,0x1
      78:	a9c080e7          	jalr	-1380(ra) # b10 <strlen>
      7c:	892a                	mv	s2,a0
      7e:	8526                	mv	a0,s1
      80:	00001097          	auipc	ra,0x1
      84:	a90080e7          	jalr	-1392(ra) # b10 <strlen>
      88:	02091793          	slli	a5,s2,0x20
      8c:	9381                	srli	a5,a5,0x20
      8e:	4639                	li	a2,14
      90:	9e09                	subw	a2,a2,a0
      92:	02000593          	li	a1,32
      96:	00002517          	auipc	a0,0x2
      9a:	f8a50513          	addi	a0,a0,-118 # 2020 <buf.0>
      9e:	953e                	add	a0,a0,a5
      a0:	00001097          	auipc	ra,0x1
      a4:	a9c080e7          	jalr	-1380(ra) # b3c <memset>
  return buf;
      a8:	00002497          	auipc	s1,0x2
      ac:	f7848493          	addi	s1,s1,-136 # 2020 <buf.0>
      b0:	6902                	ld	s2,0(sp)
      b2:	bf51                	j	46 <fmtname+0x46>

00000000000000b4 <ls>:

void
ls(char *path)
{
      b4:	da010113          	addi	sp,sp,-608
      b8:	24113c23          	sd	ra,600(sp)
      bc:	24813823          	sd	s0,592(sp)
      c0:	25213023          	sd	s2,576(sp)
      c4:	1480                	addi	s0,sp,608
      c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
      c8:	4581                	li	a1,0
      ca:	00001097          	auipc	ra,0x1
      ce:	cc4080e7          	jalr	-828(ra) # d8e <open>
      d2:	06054b63          	bltz	a0,148 <ls+0x94>
      d6:	24913423          	sd	s1,584(sp)
      da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
      dc:	da840593          	addi	a1,s0,-600
      e0:	00001097          	auipc	ra,0x1
      e4:	cc6080e7          	jalr	-826(ra) # da6 <fstat>
      e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
      ec:	db041783          	lh	a5,-592(s0)
      f0:	4705                	li	a4,1
      f2:	08e78863          	beq	a5,a4,182 <ls+0xce>
      f6:	37f9                	addiw	a5,a5,-2
      f8:	17c2                	slli	a5,a5,0x30
      fa:	93c1                	srli	a5,a5,0x30
      fc:	02f76663          	bltu	a4,a5,128 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
     100:	854a                	mv	a0,s2
     102:	00000097          	auipc	ra,0x0
     106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
     10a:	85aa                	mv	a1,a0
     10c:	db843703          	ld	a4,-584(s0)
     110:	dac42683          	lw	a3,-596(s0)
     114:	db041603          	lh	a2,-592(s0)
     118:	00001517          	auipc	a0,0x1
     11c:	1a850513          	addi	a0,a0,424 # 12c0 <malloc+0x138>
     120:	00001097          	auipc	ra,0x1
     124:	fac080e7          	jalr	-84(ra) # 10cc <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
     128:	8526                	mv	a0,s1
     12a:	00001097          	auipc	ra,0x1
     12e:	c4c080e7          	jalr	-948(ra) # d76 <close>
     132:	24813483          	ld	s1,584(sp)
}
     136:	25813083          	ld	ra,600(sp)
     13a:	25013403          	ld	s0,592(sp)
     13e:	24013903          	ld	s2,576(sp)
     142:	26010113          	addi	sp,sp,608
     146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
     148:	864a                	mv	a2,s2
     14a:	00001597          	auipc	a1,0x1
     14e:	14658593          	addi	a1,a1,326 # 1290 <malloc+0x108>
     152:	4509                	li	a0,2
     154:	00001097          	auipc	ra,0x1
     158:	f4a080e7          	jalr	-182(ra) # 109e <fprintf>
    return;
     15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
     15e:	864a                	mv	a2,s2
     160:	00001597          	auipc	a1,0x1
     164:	14858593          	addi	a1,a1,328 # 12a8 <malloc+0x120>
     168:	4509                	li	a0,2
     16a:	00001097          	auipc	ra,0x1
     16e:	f34080e7          	jalr	-204(ra) # 109e <fprintf>
    close(fd);
     172:	8526                	mv	a0,s1
     174:	00001097          	auipc	ra,0x1
     178:	c02080e7          	jalr	-1022(ra) # d76 <close>
    return;
     17c:	24813483          	ld	s1,584(sp)
     180:	bf5d                	j	136 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     182:	854a                	mv	a0,s2
     184:	00001097          	auipc	ra,0x1
     188:	98c080e7          	jalr	-1652(ra) # b10 <strlen>
     18c:	2541                	addiw	a0,a0,16
     18e:	20000793          	li	a5,512
     192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
      printf("ls: path too long\n");
     196:	00001517          	auipc	a0,0x1
     19a:	13a50513          	addi	a0,a0,314 # 12d0 <malloc+0x148>
     19e:	00001097          	auipc	ra,0x1
     1a2:	f2e080e7          	jalr	-210(ra) # 10cc <printf>
      break;
     1a6:	b749                	j	128 <ls+0x74>
     1a8:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
     1ac:	85ca                	mv	a1,s2
     1ae:	dd040513          	addi	a0,s0,-560
     1b2:	00001097          	auipc	ra,0x1
     1b6:	90e080e7          	jalr	-1778(ra) # ac0 <strcpy>
    p = buf+strlen(buf);
     1ba:	dd040513          	addi	a0,s0,-560
     1be:	00001097          	auipc	ra,0x1
     1c2:	952080e7          	jalr	-1710(ra) # b10 <strlen>
     1c6:	1502                	slli	a0,a0,0x20
     1c8:	9101                	srli	a0,a0,0x20
     1ca:	dd040793          	addi	a5,s0,-560
     1ce:	00a78733          	add	a4,a5,a0
     1d2:	893a                	mv	s2,a4
    *p++ = '/';
     1d4:	00170793          	addi	a5,a4,1
     1d8:	89be                	mv	s3,a5
     1da:	02f00793          	li	a5,47
     1de:	00f70023          	sb	a5,0(a4)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     1e2:	a819                	j	1f8 <ls+0x144>
        printf("ls: cannot stat %s\n", buf);
     1e4:	dd040593          	addi	a1,s0,-560
     1e8:	00001517          	auipc	a0,0x1
     1ec:	0c050513          	addi	a0,a0,192 # 12a8 <malloc+0x120>
     1f0:	00001097          	auipc	ra,0x1
     1f4:	edc080e7          	jalr	-292(ra) # 10cc <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     1f8:	4641                	li	a2,16
     1fa:	dc040593          	addi	a1,s0,-576
     1fe:	8526                	mv	a0,s1
     200:	00001097          	auipc	ra,0x1
     204:	b66080e7          	jalr	-1178(ra) # d66 <read>
     208:	47c1                	li	a5,16
     20a:	04f51f63          	bne	a0,a5,268 <ls+0x1b4>
      if(de.inum == 0)
     20e:	dc045783          	lhu	a5,-576(s0)
     212:	d3fd                	beqz	a5,1f8 <ls+0x144>
      memmove(p, de.name, DIRSIZ);
     214:	4639                	li	a2,14
     216:	dc240593          	addi	a1,s0,-574
     21a:	854e                	mv	a0,s3
     21c:	00001097          	auipc	ra,0x1
     220:	a7c080e7          	jalr	-1412(ra) # c98 <memmove>
      p[DIRSIZ] = 0;
     224:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
     228:	da840593          	addi	a1,s0,-600
     22c:	dd040513          	addi	a0,s0,-560
     230:	00001097          	auipc	ra,0x1
     234:	9d4080e7          	jalr	-1580(ra) # c04 <stat>
     238:	fa0546e3          	bltz	a0,1e4 <ls+0x130>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
     23c:	dd040513          	addi	a0,s0,-560
     240:	00000097          	auipc	ra,0x0
     244:	dc0080e7          	jalr	-576(ra) # 0 <fmtname>
     248:	85aa                	mv	a1,a0
     24a:	db843703          	ld	a4,-584(s0)
     24e:	dac42683          	lw	a3,-596(s0)
     252:	db041603          	lh	a2,-592(s0)
     256:	00001517          	auipc	a0,0x1
     25a:	09250513          	addi	a0,a0,146 # 12e8 <malloc+0x160>
     25e:	00001097          	auipc	ra,0x1
     262:	e6e080e7          	jalr	-402(ra) # 10cc <printf>
     266:	bf49                	j	1f8 <ls+0x144>
     268:	23813983          	ld	s3,568(sp)
     26c:	bd75                	j	128 <ls+0x74>

000000000000026e <main>:

int
main(int argc, char *argv[])
{
     26e:	1101                	addi	sp,sp,-32
     270:	ec06                	sd	ra,24(sp)
     272:	e822                	sd	s0,16(sp)
     274:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
     276:	4785                	li	a5,1
     278:	02a7db63          	bge	a5,a0,2ae <main+0x40>
     27c:	e426                	sd	s1,8(sp)
     27e:	e04a                	sd	s2,0(sp)
     280:	00858493          	addi	s1,a1,8
     284:	ffe5091b          	addiw	s2,a0,-2
     288:	02091793          	slli	a5,s2,0x20
     28c:	01d7d913          	srli	s2,a5,0x1d
     290:	05c1                	addi	a1,a1,16
     292:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
     294:	6088                	ld	a0,0(s1)
     296:	00000097          	auipc	ra,0x0
     29a:	e1e080e7          	jalr	-482(ra) # b4 <ls>
  for(i=1; i<argc; i++)
     29e:	04a1                	addi	s1,s1,8
     2a0:	ff249ae3          	bne	s1,s2,294 <main+0x26>
  exit(0);
     2a4:	4501                	li	a0,0
     2a6:	00001097          	auipc	ra,0x1
     2aa:	aa8080e7          	jalr	-1368(ra) # d4e <exit>
     2ae:	e426                	sd	s1,8(sp)
     2b0:	e04a                	sd	s2,0(sp)
    ls(".");
     2b2:	00001517          	auipc	a0,0x1
     2b6:	04650513          	addi	a0,a0,70 # 12f8 <malloc+0x170>
     2ba:	00000097          	auipc	ra,0x0
     2be:	dfa080e7          	jalr	-518(ra) # b4 <ls>
    exit(0);
     2c2:	4501                	li	a0,0
     2c4:	00001097          	auipc	ra,0x1
     2c8:	a8a080e7          	jalr	-1398(ra) # d4e <exit>

00000000000002cc <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     2cc:	1141                	addi	sp,sp,-16
     2ce:	e406                	sd	ra,8(sp)
     2d0:	e022                	sd	s0,0(sp)
     2d2:	0800                	addi	s0,sp,16
    lk->name = name;
     2d4:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     2d6:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     2da:	57fd                	li	a5,-1
     2dc:	00f50823          	sb	a5,16(a0)
}
     2e0:	60a2                	ld	ra,8(sp)
     2e2:	6402                	ld	s0,0(sp)
     2e4:	0141                	addi	sp,sp,16
     2e6:	8082                	ret

00000000000002e8 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     2e8:	00054783          	lbu	a5,0(a0)
     2ec:	e399                	bnez	a5,2f2 <holding+0xa>
     2ee:	4501                	li	a0,0
}
     2f0:	8082                	ret
{
     2f2:	1101                	addi	sp,sp,-32
     2f4:	ec06                	sd	ra,24(sp)
     2f6:	e822                	sd	s0,16(sp)
     2f8:	e426                	sd	s1,8(sp)
     2fa:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     2fc:	01054483          	lbu	s1,16(a0)
     300:	00000097          	auipc	ra,0x0
     304:	63e080e7          	jalr	1598(ra) # 93e <twhoami>
     308:	2501                	sext.w	a0,a0
     30a:	40a48533          	sub	a0,s1,a0
     30e:	00153513          	seqz	a0,a0
}
     312:	60e2                	ld	ra,24(sp)
     314:	6442                	ld	s0,16(sp)
     316:	64a2                	ld	s1,8(sp)
     318:	6105                	addi	sp,sp,32
     31a:	8082                	ret

000000000000031c <acquire>:

void acquire(struct lock *lk)
{
     31c:	7179                	addi	sp,sp,-48
     31e:	f406                	sd	ra,40(sp)
     320:	f022                	sd	s0,32(sp)
     322:	ec26                	sd	s1,24(sp)
     324:	e84a                	sd	s2,16(sp)
     326:	e44e                	sd	s3,8(sp)
     328:	1800                	addi	s0,sp,48
     32a:	892a                	mv	s2,a0
    if (holding(lk))
     32c:	00000097          	auipc	ra,0x0
     330:	fbc080e7          	jalr	-68(ra) # 2e8 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     334:	ffc97493          	andi	s1,s2,-4
     338:	4985                	li	s3,1
    if (holding(lk))
     33a:	c115                	beqz	a0,35e <acquire+0x42>
        printf("re-acquiring lock we already hold");
     33c:	00001517          	auipc	a0,0x1
     340:	fc450513          	addi	a0,a0,-60 # 1300 <malloc+0x178>
     344:	00001097          	auipc	ra,0x1
     348:	d88080e7          	jalr	-632(ra) # 10cc <printf>
        exit(-1);
     34c:	557d                	li	a0,-1
     34e:	00001097          	auipc	ra,0x1
     352:	a00080e7          	jalr	-1536(ra) # d4e <exit>
    {
        // give up the cpu for other threads
        tyield();
     356:	00000097          	auipc	ra,0x0
     35a:	5b2080e7          	jalr	1458(ra) # 908 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     35e:	00397713          	andi	a4,s2,3
     362:	0037171b          	slliw	a4,a4,0x3
     366:	0ff00793          	li	a5,255
     36a:	00e797bb          	sllw	a5,a5,a4
     36e:	fff7c613          	not	a2,a5
     372:	00e996bb          	sllw	a3,s3,a4
     376:	8efd                	and	a3,a3,a5
     378:	1404a7af          	lr.w.aq	a5,(s1)
     37c:	00c7f5b3          	and	a1,a5,a2
     380:	8dd5                	or	a1,a1,a3
     382:	18b4a5af          	sc.w	a1,a1,(s1)
     386:	f9ed                	bnez	a1,378 <acquire+0x5c>
     388:	40e7d7bb          	sraw	a5,a5,a4
     38c:	0ff7f793          	zext.b	a5,a5
     390:	f3f9                	bnez	a5,356 <acquire+0x3a>
    }

    __sync_synchronize();
     392:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     396:	00000097          	auipc	ra,0x0
     39a:	5a8080e7          	jalr	1448(ra) # 93e <twhoami>
     39e:	00a90823          	sb	a0,16(s2)
}
     3a2:	70a2                	ld	ra,40(sp)
     3a4:	7402                	ld	s0,32(sp)
     3a6:	64e2                	ld	s1,24(sp)
     3a8:	6942                	ld	s2,16(sp)
     3aa:	69a2                	ld	s3,8(sp)
     3ac:	6145                	addi	sp,sp,48
     3ae:	8082                	ret

00000000000003b0 <release>:

void release(struct lock *lk)
{
     3b0:	1101                	addi	sp,sp,-32
     3b2:	ec06                	sd	ra,24(sp)
     3b4:	e822                	sd	s0,16(sp)
     3b6:	e426                	sd	s1,8(sp)
     3b8:	1000                	addi	s0,sp,32
     3ba:	84aa                	mv	s1,a0
    if (!holding(lk))
     3bc:	00000097          	auipc	ra,0x0
     3c0:	f2c080e7          	jalr	-212(ra) # 2e8 <holding>
     3c4:	c11d                	beqz	a0,3ea <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     3c6:	57fd                	li	a5,-1
     3c8:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     3cc:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     3d0:	0310000f          	fence	rw,w
     3d4:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     3d8:	00000097          	auipc	ra,0x0
     3dc:	530080e7          	jalr	1328(ra) # 908 <tyield>
}
     3e0:	60e2                	ld	ra,24(sp)
     3e2:	6442                	ld	s0,16(sp)
     3e4:	64a2                	ld	s1,8(sp)
     3e6:	6105                	addi	sp,sp,32
     3e8:	8082                	ret
        printf("releasing lock we are not holding");
     3ea:	00001517          	auipc	a0,0x1
     3ee:	f3e50513          	addi	a0,a0,-194 # 1328 <malloc+0x1a0>
     3f2:	00001097          	auipc	ra,0x1
     3f6:	cda080e7          	jalr	-806(ra) # 10cc <printf>
        exit(-1);
     3fa:	557d                	li	a0,-1
     3fc:	00001097          	auipc	ra,0x1
     400:	952080e7          	jalr	-1710(ra) # d4e <exit>

0000000000000404 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     404:	00002797          	auipc	a5,0x2
     408:	bfc7c783          	lbu	a5,-1028(a5) # 2000 <threadlib_init_done>
     40c:	eba5                	bnez	a5,47c <threadlib_init+0x78>
{
     40e:	7179                	addi	sp,sp,-48
     410:	f406                	sd	ra,40(sp)
     412:	f022                	sd	s0,32(sp)
     414:	ec26                	sd	s1,24(sp)
     416:	e84a                	sd	s2,16(sp)
     418:	e44e                	sd	s3,8(sp)
     41a:	e052                	sd	s4,0(sp)
     41c:	1800                	addi	s0,sp,48
     41e:	00002497          	auipc	s1,0x2
     422:	c1248493          	addi	s1,s1,-1006 # 2030 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     426:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     428:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     42c:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     42e:	8652                	mv	a2,s4
     430:	4581                	li	a1,0
     432:	8526                	mv	a0,s1
     434:	00000097          	auipc	ra,0x0
     438:	708080e7          	jalr	1800(ra) # b3c <memset>
        threads[i].tid = i;
     43c:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     440:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     444:	2905                	addiw	s2,s2,1
     446:	0b048493          	addi	s1,s1,176
     44a:	ff3912e3          	bne	s2,s3,42e <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     44e:	00002797          	auipc	a5,0x2
     452:	be278793          	addi	a5,a5,-1054 # 2030 <threads>
     456:	00002717          	auipc	a4,0x2
     45a:	baf73923          	sd	a5,-1102(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     45e:	4711                	li	a4,4
     460:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     462:	4785                	li	a5,1
     464:	00002717          	auipc	a4,0x2
     468:	b8f70e23          	sb	a5,-1124(a4) # 2000 <threadlib_init_done>
}
     46c:	70a2                	ld	ra,40(sp)
     46e:	7402                	ld	s0,32(sp)
     470:	64e2                	ld	s1,24(sp)
     472:	6942                	ld	s2,16(sp)
     474:	69a2                	ld	s3,8(sp)
     476:	6a02                	ld	s4,0(sp)
     478:	6145                	addi	sp,sp,48
     47a:	8082                	ret
     47c:	8082                	ret

000000000000047e <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     47e:	1101                	addi	sp,sp,-32
     480:	ec06                	sd	ra,24(sp)
     482:	e822                	sd	s0,16(sp)
     484:	e426                	sd	s1,8(sp)
     486:	e04a                	sd	s2,0(sp)
     488:	1000                	addi	s0,sp,32
     48a:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     48c:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     490:	6948                	ld	a0,144(a0)
     492:	c509                	beqz	a0,49c <reclaim_thread+0x1e>
    {
        free(thread->stack);
     494:	00001097          	auipc	ra,0x1
     498:	c6e080e7          	jalr	-914(ra) # 1102 <free>
    }
    if (thread->result)
     49c:	70c8                	ld	a0,160(s1)
     49e:	c509                	beqz	a0,4a8 <reclaim_thread+0x2a>
    {
        free(thread->result);
     4a0:	00001097          	auipc	ra,0x1
     4a4:	c62080e7          	jalr	-926(ra) # 1102 <free>
    }

    memset(thread, 0, sizeof(*thread));
     4a8:	0b000613          	li	a2,176
     4ac:	4581                	li	a1,0
     4ae:	8526                	mv	a0,s1
     4b0:	00000097          	auipc	ra,0x0
     4b4:	68c080e7          	jalr	1676(ra) # b3c <memset>
    thread->tid = tid;
     4b8:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     4bc:	0604ac23          	sw	zero,120(s1)
}
     4c0:	60e2                	ld	ra,24(sp)
     4c2:	6442                	ld	s0,16(sp)
     4c4:	64a2                	ld	s1,8(sp)
     4c6:	6902                	ld	s2,0(sp)
     4c8:	6105                	addi	sp,sp,32
     4ca:	8082                	ret

00000000000004cc <tsched>:

void tsched()
{
     4cc:	1141                	addi	sp,sp,-16
     4ce:	e406                	sd	ra,8(sp)
     4d0:	e022                	sd	s0,0(sp)
     4d2:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     4d4:	00000097          	auipc	ra,0x0
     4d8:	f30080e7          	jalr	-208(ra) # 404 <threadlib_init>
    prev = current_thread;
     4dc:	00002517          	auipc	a0,0x2
     4e0:	b2c53503          	ld	a0,-1236(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     4e4:	5d38                	lw	a4,120(a0)
     4e6:	4791                	li	a5,4
     4e8:	06f70763          	beq	a4,a5,556 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     4ec:	00054603          	lbu	a2,0(a0)
     4f0:	0016069b          	addiw	a3,a2,1
     4f4:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     4f6:	00002897          	auipc	a7,0x2
     4fa:	b3a88893          	addi	a7,a7,-1222 # 2030 <threads>
     4fe:	0b000813          	li	a6,176
     502:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     504:	41f6d71b          	sraiw	a4,a3,0x1f
     508:	01c7571b          	srliw	a4,a4,0x1c
     50c:	00d707bb          	addw	a5,a4,a3
     510:	8bbd                	andi	a5,a5,15
     512:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     514:	03078733          	mul	a4,a5,a6
     518:	9746                	add	a4,a4,a7
     51a:	5f38                	lw	a4,120(a4)
     51c:	04b70063          	beq	a4,a1,55c <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     520:	2685                	addiw	a3,a3,1
     522:	fec691e3          	bne	a3,a2,504 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     526:	5d3c                	lw	a5,120(a0)
     528:	470d                	li	a4,3
     52a:	06e78f63          	beq	a5,a4,5a8 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     52e:	4711                	li	a4,4
     530:	06e78763          	beq	a5,a4,59e <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     534:	00001597          	auipc	a1,0x1
     538:	e1c58593          	addi	a1,a1,-484 # 1350 <malloc+0x1c8>
     53c:	00001517          	auipc	a0,0x1
     540:	e2450513          	addi	a0,a0,-476 # 1360 <malloc+0x1d8>
     544:	00001097          	auipc	ra,0x1
     548:	b88080e7          	jalr	-1144(ra) # 10cc <printf>
        exit(-1);
     54c:	557d                	li	a0,-1
     54e:	00001097          	auipc	ra,0x1
     552:	800080e7          	jalr	-2048(ra) # d4e <exit>
        prev->state = RUNNABLE;
     556:	478d                	li	a5,3
     558:	dd3c                	sw	a5,120(a0)
     55a:	bf49                	j	4ec <tsched+0x20>
            return &threads[idx];
     55c:	0b000713          	li	a4,176
     560:	02e78733          	mul	a4,a5,a4
     564:	00002697          	auipc	a3,0x2
     568:	acc68693          	addi	a3,a3,-1332 # 2030 <threads>
     56c:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     56e:	02d50c63          	beq	a0,a3,5a6 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     572:	00002617          	auipc	a2,0x2
     576:	a8d63b23          	sd	a3,-1386(a2) # 2008 <current_thread>
    next->state = RUNNING;
     57a:	00002597          	auipc	a1,0x2
     57e:	ab658593          	addi	a1,a1,-1354 # 2030 <threads>
     582:	0b000693          	li	a3,176
     586:	02d787b3          	mul	a5,a5,a3
     58a:	97ae                	add	a5,a5,a1
     58c:	4691                	li	a3,4
     58e:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     590:	0721                	addi	a4,a4,8
     592:	95ba                	add	a1,a1,a4
     594:	0521                	addi	a0,a0,8
     596:	00000097          	auipc	ra,0x0
     59a:	488080e7          	jalr	1160(ra) # a1e <tswtch>
}
     59e:	60a2                	ld	ra,8(sp)
     5a0:	6402                	ld	s0,0(sp)
     5a2:	0141                	addi	sp,sp,16
     5a4:	8082                	ret
     5a6:	8536                	mv	a0,a3
        next->state = RUNNING;
     5a8:	4791                	li	a5,4
     5aa:	dd3c                	sw	a5,120(a0)
        return;
     5ac:	bfcd                	j	59e <tsched+0xd2>

00000000000005ae <thread_bootstrap>:
{
     5ae:	1101                	addi	sp,sp,-32
     5b0:	ec06                	sd	ra,24(sp)
     5b2:	e822                	sd	s0,16(sp)
     5b4:	e426                	sd	s1,8(sp)
     5b6:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     5b8:	00002497          	auipc	s1,0x2
     5bc:	a504b483          	ld	s1,-1456(s1) # 2008 <current_thread>
    if (thread)
     5c0:	c09d                	beqz	s1,5e6 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     5c2:	64dc                	ld	a5,136(s1)
     5c4:	60c8                	ld	a0,128(s1)
     5c6:	9782                	jalr	a5
     5c8:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     5ca:	00002497          	auipc	s1,0x2
     5ce:	a3e4b483          	ld	s1,-1474(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     5d2:	09c4a603          	lw	a2,156(s1)
     5d6:	ca01                	beqz	a2,5e6 <thread_bootstrap+0x38>
     5d8:	70c8                	ld	a0,160(s1)
     5da:	c591                	beqz	a1,5e6 <thread_bootstrap+0x38>
     5dc:	c509                	beqz	a0,5e6 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     5de:	00000097          	auipc	ra,0x0
     5e2:	6ba080e7          	jalr	1722(ra) # c98 <memmove>
    thread->state = EXITED;
     5e6:	4799                	li	a5,6
     5e8:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     5ea:	74dc                	ld	a5,168(s1)
     5ec:	c789                	beqz	a5,5f6 <thread_bootstrap+0x48>
     5ee:	5fb4                	lw	a3,120(a5)
     5f0:	4709                	li	a4,2
     5f2:	00e68b63          	beq	a3,a4,608 <thread_bootstrap+0x5a>
    tsched();
     5f6:	00000097          	auipc	ra,0x0
     5fa:	ed6080e7          	jalr	-298(ra) # 4cc <tsched>
    exit(-1);
     5fe:	557d                	li	a0,-1
     600:	00000097          	auipc	ra,0x0
     604:	74e080e7          	jalr	1870(ra) # d4e <exit>
        thread->joiner->state = RUNNABLE;
     608:	470d                	li	a4,3
     60a:	dfb8                	sw	a4,120(a5)
     60c:	b7ed                	j	5f6 <thread_bootstrap+0x48>

000000000000060e <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     60e:	715d                	addi	sp,sp,-80
     610:	e486                	sd	ra,72(sp)
     612:	e0a2                	sd	s0,64(sp)
     614:	fc26                	sd	s1,56(sp)
     616:	f84a                	sd	s2,48(sp)
     618:	f44e                	sd	s3,40(sp)
     61a:	f052                	sd	s4,32(sp)
     61c:	ec56                	sd	s5,24(sp)
     61e:	e85a                	sd	s6,16(sp)
     620:	e45e                	sd	s7,8(sp)
     622:	e062                	sd	s8,0(sp)
     624:	0880                	addi	s0,sp,80
     626:	8b2a                	mv	s6,a0
     628:	84ae                	mv	s1,a1
     62a:	8bb2                	mv	s7,a2
     62c:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     62e:	00000097          	auipc	ra,0x0
     632:	dd6080e7          	jalr	-554(ra) # 404 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     636:	c4b1                	beqz	s1,682 <tcreate+0x74>
    {
        if (attr->stacksize)
     638:	0004a983          	lw	s3,0(s1)
     63c:	00099363          	bnez	s3,642 <tcreate+0x34>
    stacksize = PGSIZE;
     640:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     642:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     646:	00002797          	auipc	a5,0x2
     64a:	b1278793          	addi	a5,a5,-1262 # 2158 <threads+0x128>
     64e:	4485                	li	s1,1
     650:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     652:	4398                	lw	a4,0(a5)
     654:	cb15                	beqz	a4,688 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     656:	2485                	addiw	s1,s1,1
     658:	0b078793          	addi	a5,a5,176
     65c:	feb49be3          	bne	s1,a1,652 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     660:	00001597          	auipc	a1,0x1
     664:	cf058593          	addi	a1,a1,-784 # 1350 <malloc+0x1c8>
     668:	00001517          	auipc	a0,0x1
     66c:	d1050513          	addi	a0,a0,-752 # 1378 <malloc+0x1f0>
     670:	00001097          	auipc	ra,0x1
     674:	a5c080e7          	jalr	-1444(ra) # 10cc <printf>
        exit(-1);
     678:	557d                	li	a0,-1
     67a:	00000097          	auipc	ra,0x0
     67e:	6d4080e7          	jalr	1748(ra) # d4e <exit>
    res_size = 0;
     682:	4a81                	li	s5,0
    stacksize = PGSIZE;
     684:	6985                	lui	s3,0x1
     686:	b7c1                	j	646 <tcreate+0x38>
            new_thread = &threads[i];
     688:	0b000a13          	li	s4,176
     68c:	03448a33          	mul	s4,s1,s4
     690:	00002917          	auipc	s2,0x2
     694:	9a090913          	addi	s2,s2,-1632 # 2030 <threads>
     698:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     69a:	0b000613          	li	a2,176
     69e:	4581                	li	a1,0
     6a0:	854a                	mv	a0,s2
     6a2:	00000097          	auipc	ra,0x0
     6a6:	49a080e7          	jalr	1178(ra) # b3c <memset>
    new_thread->tid = new_thread - threads;
     6aa:	404a5693          	srai	a3,s4,0x4
     6ae:	000ba737          	lui	a4,0xba
     6b2:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77b9>
     6b6:	0732                	slli	a4,a4,0xc
     6b8:	ba370713          	addi	a4,a4,-1117
     6bc:	2e8ba7b7          	lui	a5,0x2e8ba
     6c0:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77b8>
     6c4:	1782                	slli	a5,a5,0x20
     6c6:	97ba                	add	a5,a5,a4
     6c8:	02f687b3          	mul	a5,a3,a5
     6cc:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     6d0:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     6d4:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     6d8:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     6dc:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     6e0:	478d                	li	a5,3
     6e2:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     6e6:	0109851b          	addiw	a0,s3,16 # 1010 <vprintf+0x140>
     6ea:	00001097          	auipc	ra,0x1
     6ee:	a9e080e7          	jalr	-1378(ra) # 1188 <malloc>
     6f2:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     6f6:	c951                	beqz	a0,78a <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     6f8:	020a8863          	beqz	s5,728 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     6fc:	8556                	mv	a0,s5
     6fe:	00001097          	auipc	ra,0x1
     702:	a8a080e7          	jalr	-1398(ra) # 1188 <malloc>
     706:	0b000713          	li	a4,176
     70a:	02e48733          	mul	a4,s1,a4
     70e:	00002797          	auipc	a5,0x2
     712:	92278793          	addi	a5,a5,-1758 # 2030 <threads>
     716:	97ba                	add	a5,a5,a4
     718:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     71a:	c949                	beqz	a0,7ac <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     71c:	8656                	mv	a2,s5
     71e:	4581                	li	a1,0
     720:	00000097          	auipc	ra,0x0
     724:	41c080e7          	jalr	1052(ra) # b3c <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     728:	00002517          	auipc	a0,0x2
     72c:	90850513          	addi	a0,a0,-1784 # 2030 <threads>
     730:	0b000793          	li	a5,176
     734:	02f484b3          	mul	s1,s1,a5
     738:	94aa                	add	s1,s1,a0
     73a:	1982                	slli	s3,s3,0x20
     73c:	0209d993          	srli	s3,s3,0x20
     740:	09c1                	addi	s3,s3,16
     742:	68dc                	ld	a5,144(s1)
     744:	99be                	add	s3,s3,a5
     746:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     74a:	0a21                	addi	s4,s4,8
     74c:	07000613          	li	a2,112
     750:	4581                	li	a1,0
     752:	9552                	add	a0,a0,s4
     754:	00000097          	auipc	ra,0x0
     758:	3e8080e7          	jalr	1000(ra) # b3c <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     75c:	00000797          	auipc	a5,0x0
     760:	e5278793          	addi	a5,a5,-430 # 5ae <thread_bootstrap>
     764:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     766:	0134b823          	sd	s3,16(s1)

    if (thread)
     76a:	000b0463          	beqz	s6,772 <tcreate+0x164>
    {
        *thread = new_thread;
     76e:	012b3023          	sd	s2,0(s6)
    }
}
     772:	60a6                	ld	ra,72(sp)
     774:	6406                	ld	s0,64(sp)
     776:	74e2                	ld	s1,56(sp)
     778:	7942                	ld	s2,48(sp)
     77a:	79a2                	ld	s3,40(sp)
     77c:	7a02                	ld	s4,32(sp)
     77e:	6ae2                	ld	s5,24(sp)
     780:	6b42                	ld	s6,16(sp)
     782:	6ba2                	ld	s7,8(sp)
     784:	6c02                	ld	s8,0(sp)
     786:	6161                	addi	sp,sp,80
     788:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     78a:	00001597          	auipc	a1,0x1
     78e:	bc658593          	addi	a1,a1,-1082 # 1350 <malloc+0x1c8>
     792:	00001517          	auipc	a0,0x1
     796:	bfe50513          	addi	a0,a0,-1026 # 1390 <malloc+0x208>
     79a:	00001097          	auipc	ra,0x1
     79e:	932080e7          	jalr	-1742(ra) # 10cc <printf>
        exit(-1);
     7a2:	557d                	li	a0,-1
     7a4:	00000097          	auipc	ra,0x0
     7a8:	5aa080e7          	jalr	1450(ra) # d4e <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     7ac:	00001597          	auipc	a1,0x1
     7b0:	ba458593          	addi	a1,a1,-1116 # 1350 <malloc+0x1c8>
     7b4:	00001517          	auipc	a0,0x1
     7b8:	c0450513          	addi	a0,a0,-1020 # 13b8 <malloc+0x230>
     7bc:	00001097          	auipc	ra,0x1
     7c0:	910080e7          	jalr	-1776(ra) # 10cc <printf>
            exit(-1);
     7c4:	557d                	li	a0,-1
     7c6:	00000097          	auipc	ra,0x0
     7ca:	588080e7          	jalr	1416(ra) # d4e <exit>

00000000000007ce <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     7ce:	715d                	addi	sp,sp,-80
     7d0:	e486                	sd	ra,72(sp)
     7d2:	e0a2                	sd	s0,64(sp)
     7d4:	f84a                	sd	s2,48(sp)
     7d6:	e45e                	sd	s7,8(sp)
     7d8:	e062                	sd	s8,0(sp)
     7da:	0880                	addi	s0,sp,80
     7dc:	892a                	mv	s2,a0
     7de:	8bae                	mv	s7,a1
     7e0:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     7e2:	00000097          	auipc	ra,0x0
     7e6:	c22080e7          	jalr	-990(ra) # 404 <threadlib_init>
    if (current_thread->tid == tid)
     7ea:	00002697          	auipc	a3,0x2
     7ee:	81e6b683          	ld	a3,-2018(a3) # 2008 <current_thread>
     7f2:	0006c783          	lbu	a5,0(a3)
     7f6:	0f278763          	beq	a5,s2,8e4 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     7fa:	47bd                	li	a5,15
     7fc:	0f27e663          	bltu	a5,s2,8e8 <tjoin+0x11a>
     800:	fc26                	sd	s1,56(sp)
     802:	f44e                	sd	s3,40(sp)
     804:	f052                	sd	s4,32(sp)
     806:	ec56                	sd	s5,24(sp)
     808:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     80a:	0b000713          	li	a4,176
     80e:	02e90733          	mul	a4,s2,a4
     812:	00002797          	auipc	a5,0x2
     816:	81e78793          	addi	a5,a5,-2018 # 2030 <threads>
     81a:	97ba                	add	a5,a5,a4
     81c:	5fbc                	lw	a5,120(a5)
     81e:	c7f9                	beqz	a5,8ec <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     820:	0b000713          	li	a4,176
     824:	02e90733          	mul	a4,s2,a4
     828:	00002797          	auipc	a5,0x2
     82c:	80878793          	addi	a5,a5,-2040 # 2030 <threads>
     830:	97ba                	add	a5,a5,a4
     832:	77dc                	ld	a5,168(a5)
     834:	c399                	beqz	a5,83a <tjoin+0x6c>
     836:	0cf69263          	bne	a3,a5,8fa <tjoin+0x12c>
    return &threads[tid];
     83a:	0b000b13          	li	s6,176
     83e:	03690b33          	mul	s6,s2,s6
     842:	00001797          	auipc	a5,0x1
     846:	7ee78793          	addi	a5,a5,2030 # 2030 <threads>
     84a:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     84c:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     850:	078b2703          	lw	a4,120(s6)
     854:	4799                	li	a5,6
     856:	02f70463          	beq	a4,a5,87e <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     85a:	00001a97          	auipc	s5,0x1
     85e:	7aea8a93          	addi	s5,s5,1966 # 2008 <current_thread>
     862:	4a09                	li	s4,2
    while (target->state != EXITED)
     864:	84da                	mv	s1,s6
     866:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     868:	000ab783          	ld	a5,0(s5)
     86c:	0747ac23          	sw	s4,120(a5)
        tsched();
     870:	00000097          	auipc	ra,0x0
     874:	c5c080e7          	jalr	-932(ra) # 4cc <tsched>
    while (target->state != EXITED)
     878:	5cbc                	lw	a5,120(s1)
     87a:	ff3797e3          	bne	a5,s3,868 <tjoin+0x9a>
    }

    if (status && size && target->result)
     87e:	040b8163          	beqz	s7,8c0 <tjoin+0xf2>
     882:	020c0f63          	beqz	s8,8c0 <tjoin+0xf2>
     886:	0b000713          	li	a4,176
     88a:	02e90733          	mul	a4,s2,a4
     88e:	00001797          	auipc	a5,0x1
     892:	7a278793          	addi	a5,a5,1954 # 2030 <threads>
     896:	97ba                	add	a5,a5,a4
     898:	73cc                	ld	a1,160(a5)
     89a:	c19d                	beqz	a1,8c0 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     89c:	00001797          	auipc	a5,0x1
     8a0:	79478793          	addi	a5,a5,1940 # 2030 <threads>
     8a4:	97ba                	add	a5,a5,a4
     8a6:	09c7a783          	lw	a5,156(a5)
     8aa:	863e                	mv	a2,a5
     8ac:	2781                	sext.w	a5,a5
     8ae:	00fc7363          	bgeu	s8,a5,8b4 <tjoin+0xe6>
     8b2:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     8b4:	2601                	sext.w	a2,a2
     8b6:	855e                	mv	a0,s7
     8b8:	00000097          	auipc	ra,0x0
     8bc:	3e0080e7          	jalr	992(ra) # c98 <memmove>
    }

    reclaim_thread(target);
     8c0:	855a                	mv	a0,s6
     8c2:	00000097          	auipc	ra,0x0
     8c6:	bbc080e7          	jalr	-1092(ra) # 47e <reclaim_thread>
    return 0;
     8ca:	4501                	li	a0,0
     8cc:	74e2                	ld	s1,56(sp)
     8ce:	79a2                	ld	s3,40(sp)
     8d0:	7a02                	ld	s4,32(sp)
     8d2:	6ae2                	ld	s5,24(sp)
     8d4:	6b42                	ld	s6,16(sp)
}
     8d6:	60a6                	ld	ra,72(sp)
     8d8:	6406                	ld	s0,64(sp)
     8da:	7942                	ld	s2,48(sp)
     8dc:	6ba2                	ld	s7,8(sp)
     8de:	6c02                	ld	s8,0(sp)
     8e0:	6161                	addi	sp,sp,80
     8e2:	8082                	ret
        return -1;
     8e4:	557d                	li	a0,-1
     8e6:	bfc5                	j	8d6 <tjoin+0x108>
        return -1;
     8e8:	557d                	li	a0,-1
     8ea:	b7f5                	j	8d6 <tjoin+0x108>
     8ec:	557d                	li	a0,-1
     8ee:	74e2                	ld	s1,56(sp)
     8f0:	79a2                	ld	s3,40(sp)
     8f2:	7a02                	ld	s4,32(sp)
     8f4:	6ae2                	ld	s5,24(sp)
     8f6:	6b42                	ld	s6,16(sp)
     8f8:	bff9                	j	8d6 <tjoin+0x108>
        return -1;
     8fa:	557d                	li	a0,-1
     8fc:	74e2                	ld	s1,56(sp)
     8fe:	79a2                	ld	s3,40(sp)
     900:	7a02                	ld	s4,32(sp)
     902:	6ae2                	ld	s5,24(sp)
     904:	6b42                	ld	s6,16(sp)
     906:	bfc1                	j	8d6 <tjoin+0x108>

0000000000000908 <tyield>:

void tyield()
{
     908:	1141                	addi	sp,sp,-16
     90a:	e406                	sd	ra,8(sp)
     90c:	e022                	sd	s0,0(sp)
     90e:	0800                	addi	s0,sp,16
    threadlib_init();
     910:	00000097          	auipc	ra,0x0
     914:	af4080e7          	jalr	-1292(ra) # 404 <threadlib_init>
    if (current_thread->state == RUNNING)
     918:	00001797          	auipc	a5,0x1
     91c:	6f07b783          	ld	a5,1776(a5) # 2008 <current_thread>
     920:	5fb4                	lw	a3,120(a5)
     922:	4711                	li	a4,4
     924:	00e68a63          	beq	a3,a4,938 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     928:	00000097          	auipc	ra,0x0
     92c:	ba4080e7          	jalr	-1116(ra) # 4cc <tsched>
}
     930:	60a2                	ld	ra,8(sp)
     932:	6402                	ld	s0,0(sp)
     934:	0141                	addi	sp,sp,16
     936:	8082                	ret
        current_thread->state = RUNNABLE;
     938:	470d                	li	a4,3
     93a:	dfb8                	sw	a4,120(a5)
     93c:	b7f5                	j	928 <tyield+0x20>

000000000000093e <twhoami>:

uint8 twhoami()
{
     93e:	1141                	addi	sp,sp,-16
     940:	e406                	sd	ra,8(sp)
     942:	e022                	sd	s0,0(sp)
     944:	0800                	addi	s0,sp,16
    threadlib_init();
     946:	00000097          	auipc	ra,0x0
     94a:	abe080e7          	jalr	-1346(ra) # 404 <threadlib_init>
    return current_thread->tid;
}
     94e:	00001797          	auipc	a5,0x1
     952:	6ba7b783          	ld	a5,1722(a5) # 2008 <current_thread>
     956:	0007c503          	lbu	a0,0(a5)
     95a:	60a2                	ld	ra,8(sp)
     95c:	6402                	ld	s0,0(sp)
     95e:	0141                	addi	sp,sp,16
     960:	8082                	ret

0000000000000962 <twaitall>:

void twaitall(void)
{
     962:	7179                	addi	sp,sp,-48
     964:	f406                	sd	ra,40(sp)
     966:	f022                	sd	s0,32(sp)
     968:	ec26                	sd	s1,24(sp)
     96a:	e84a                	sd	s2,16(sp)
     96c:	e44e                	sd	s3,8(sp)
     96e:	1800                	addi	s0,sp,48
    threadlib_init();
     970:	00000097          	auipc	ra,0x0
     974:	a94080e7          	jalr	-1388(ra) # 404 <threadlib_init>
     978:	00002497          	auipc	s1,0x2
     97c:	23048493          	addi	s1,s1,560 # 2ba8 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     980:	4905                	li	s2,1
     982:	a035                	j	9ae <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     984:	17f5                	addi	a5,a5,-3
     986:	0017b793          	seqz	a5,a5
     98a:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     98c:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     98e:	0b070713          	addi	a4,a4,176
     992:	00970863          	beq	a4,s1,9a2 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     996:	431c                	lw	a5,0(a4)
     998:	dbfd                	beqz	a5,98e <twaitall+0x2c>
     99a:	ffa78693          	addi	a3,a5,-6
     99e:	f2fd                	bnez	a3,984 <twaitall+0x22>
     9a0:	b7fd                	j	98e <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     9a2:	cd95                	beqz	a1,9de <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     9a4:	ce01                	beqz	a2,9bc <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     9a6:	00000097          	auipc	ra,0x0
     9aa:	f62080e7          	jalr	-158(ra) # 908 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     9ae:	00001717          	auipc	a4,0x1
     9b2:	7aa70713          	addi	a4,a4,1962 # 2158 <threads+0x128>
        int runnable = 0;
     9b6:	4601                	li	a2,0
        int unfinished = 0;
     9b8:	4581                	li	a1,0
     9ba:	bff1                	j	996 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     9bc:	00001597          	auipc	a1,0x1
     9c0:	99458593          	addi	a1,a1,-1644 # 1350 <malloc+0x1c8>
     9c4:	00001517          	auipc	a0,0x1
     9c8:	99c50513          	addi	a0,a0,-1636 # 1360 <malloc+0x1d8>
     9cc:	00000097          	auipc	ra,0x0
     9d0:	700080e7          	jalr	1792(ra) # 10cc <printf>
            exit(-1);
     9d4:	557d                	li	a0,-1
     9d6:	00000097          	auipc	ra,0x0
     9da:	378080e7          	jalr	888(ra) # d4e <exit>
     9de:	00001497          	auipc	s1,0x1
     9e2:	70248493          	addi	s1,s1,1794 # 20e0 <threads+0xb0>
     9e6:	00002917          	auipc	s2,0x2
     9ea:	e4990913          	addi	s2,s2,-439 # 282f <threads+0x7ff>
     9ee:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     9f2:	4999                	li	s3,6
     9f4:	a029                	j	9fe <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     9f6:	0b048493          	addi	s1,s1,176
     9fa:	01248b63          	beq	s1,s2,a10 <twaitall+0xae>
        if (threads[i].state == EXITED)
     9fe:	5cbc                	lw	a5,120(s1)
     a00:	ff379be3          	bne	a5,s3,9f6 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     a04:	8526                	mv	a0,s1
     a06:	00000097          	auipc	ra,0x0
     a0a:	a78080e7          	jalr	-1416(ra) # 47e <reclaim_thread>
     a0e:	b7e5                	j	9f6 <twaitall+0x94>
        }
    }
}
     a10:	70a2                	ld	ra,40(sp)
     a12:	7402                	ld	s0,32(sp)
     a14:	64e2                	ld	s1,24(sp)
     a16:	6942                	ld	s2,16(sp)
     a18:	69a2                	ld	s3,8(sp)
     a1a:	6145                	addi	sp,sp,48
     a1c:	8082                	ret

0000000000000a1e <tswtch>:
     a1e:	00153023          	sd	ra,0(a0)
     a22:	00253423          	sd	sp,8(a0)
     a26:	e900                	sd	s0,16(a0)
     a28:	ed04                	sd	s1,24(a0)
     a2a:	03253023          	sd	s2,32(a0)
     a2e:	03353423          	sd	s3,40(a0)
     a32:	03453823          	sd	s4,48(a0)
     a36:	03553c23          	sd	s5,56(a0)
     a3a:	05653023          	sd	s6,64(a0)
     a3e:	05753423          	sd	s7,72(a0)
     a42:	05853823          	sd	s8,80(a0)
     a46:	05953c23          	sd	s9,88(a0)
     a4a:	07a53023          	sd	s10,96(a0)
     a4e:	07b53423          	sd	s11,104(a0)
     a52:	0005b083          	ld	ra,0(a1)
     a56:	0085b103          	ld	sp,8(a1)
     a5a:	6980                	ld	s0,16(a1)
     a5c:	6d84                	ld	s1,24(a1)
     a5e:	0205b903          	ld	s2,32(a1)
     a62:	0285b983          	ld	s3,40(a1)
     a66:	0305ba03          	ld	s4,48(a1)
     a6a:	0385ba83          	ld	s5,56(a1)
     a6e:	0405bb03          	ld	s6,64(a1)
     a72:	0485bb83          	ld	s7,72(a1)
     a76:	0505bc03          	ld	s8,80(a1)
     a7a:	0585bc83          	ld	s9,88(a1)
     a7e:	0605bd03          	ld	s10,96(a1)
     a82:	0685bd83          	ld	s11,104(a1)
     a86:	8082                	ret

0000000000000a88 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     a88:	1101                	addi	sp,sp,-32
     a8a:	ec06                	sd	ra,24(sp)
     a8c:	e822                	sd	s0,16(sp)
     a8e:	e426                	sd	s1,8(sp)
     a90:	e04a                	sd	s2,0(sp)
     a92:	1000                	addi	s0,sp,32
     a94:	892a                	mv	s2,a0
     a96:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     a98:	00000097          	auipc	ra,0x0
     a9c:	ea6080e7          	jalr	-346(ra) # 93e <twhoami>
    int res = main(argc, argv);
     aa0:	85a6                	mv	a1,s1
     aa2:	854a                	mv	a0,s2
     aa4:	fffff097          	auipc	ra,0xfffff
     aa8:	7ca080e7          	jalr	1994(ra) # 26e <main>
     aac:	84aa                	mv	s1,a0
    twaitall();
     aae:	00000097          	auipc	ra,0x0
     ab2:	eb4080e7          	jalr	-332(ra) # 962 <twaitall>
    exit(res);
     ab6:	8526                	mv	a0,s1
     ab8:	00000097          	auipc	ra,0x0
     abc:	296080e7          	jalr	662(ra) # d4e <exit>

0000000000000ac0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     ac0:	1141                	addi	sp,sp,-16
     ac2:	e406                	sd	ra,8(sp)
     ac4:	e022                	sd	s0,0(sp)
     ac6:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     ac8:	87aa                	mv	a5,a0
     aca:	0585                	addi	a1,a1,1
     acc:	0785                	addi	a5,a5,1
     ace:	fff5c703          	lbu	a4,-1(a1)
     ad2:	fee78fa3          	sb	a4,-1(a5)
     ad6:	fb75                	bnez	a4,aca <strcpy+0xa>
        ;
    return os;
}
     ad8:	60a2                	ld	ra,8(sp)
     ada:	6402                	ld	s0,0(sp)
     adc:	0141                	addi	sp,sp,16
     ade:	8082                	ret

0000000000000ae0 <strcmp>:

int strcmp(const char *p, const char *q)
{
     ae0:	1141                	addi	sp,sp,-16
     ae2:	e406                	sd	ra,8(sp)
     ae4:	e022                	sd	s0,0(sp)
     ae6:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     ae8:	00054783          	lbu	a5,0(a0)
     aec:	cb91                	beqz	a5,b00 <strcmp+0x20>
     aee:	0005c703          	lbu	a4,0(a1)
     af2:	00f71763          	bne	a4,a5,b00 <strcmp+0x20>
        p++, q++;
     af6:	0505                	addi	a0,a0,1
     af8:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     afa:	00054783          	lbu	a5,0(a0)
     afe:	fbe5                	bnez	a5,aee <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     b00:	0005c503          	lbu	a0,0(a1)
}
     b04:	40a7853b          	subw	a0,a5,a0
     b08:	60a2                	ld	ra,8(sp)
     b0a:	6402                	ld	s0,0(sp)
     b0c:	0141                	addi	sp,sp,16
     b0e:	8082                	ret

0000000000000b10 <strlen>:

uint strlen(const char *s)
{
     b10:	1141                	addi	sp,sp,-16
     b12:	e406                	sd	ra,8(sp)
     b14:	e022                	sd	s0,0(sp)
     b16:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     b18:	00054783          	lbu	a5,0(a0)
     b1c:	cf91                	beqz	a5,b38 <strlen+0x28>
     b1e:	00150793          	addi	a5,a0,1
     b22:	86be                	mv	a3,a5
     b24:	0785                	addi	a5,a5,1
     b26:	fff7c703          	lbu	a4,-1(a5)
     b2a:	ff65                	bnez	a4,b22 <strlen+0x12>
     b2c:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     b30:	60a2                	ld	ra,8(sp)
     b32:	6402                	ld	s0,0(sp)
     b34:	0141                	addi	sp,sp,16
     b36:	8082                	ret
    for (n = 0; s[n]; n++)
     b38:	4501                	li	a0,0
     b3a:	bfdd                	j	b30 <strlen+0x20>

0000000000000b3c <memset>:

void *
memset(void *dst, int c, uint n)
{
     b3c:	1141                	addi	sp,sp,-16
     b3e:	e406                	sd	ra,8(sp)
     b40:	e022                	sd	s0,0(sp)
     b42:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     b44:	ca19                	beqz	a2,b5a <memset+0x1e>
     b46:	87aa                	mv	a5,a0
     b48:	1602                	slli	a2,a2,0x20
     b4a:	9201                	srli	a2,a2,0x20
     b4c:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     b50:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     b54:	0785                	addi	a5,a5,1
     b56:	fee79de3          	bne	a5,a4,b50 <memset+0x14>
    }
    return dst;
}
     b5a:	60a2                	ld	ra,8(sp)
     b5c:	6402                	ld	s0,0(sp)
     b5e:	0141                	addi	sp,sp,16
     b60:	8082                	ret

0000000000000b62 <strchr>:

char *
strchr(const char *s, char c)
{
     b62:	1141                	addi	sp,sp,-16
     b64:	e406                	sd	ra,8(sp)
     b66:	e022                	sd	s0,0(sp)
     b68:	0800                	addi	s0,sp,16
    for (; *s; s++)
     b6a:	00054783          	lbu	a5,0(a0)
     b6e:	cf81                	beqz	a5,b86 <strchr+0x24>
        if (*s == c)
     b70:	00f58763          	beq	a1,a5,b7e <strchr+0x1c>
    for (; *s; s++)
     b74:	0505                	addi	a0,a0,1
     b76:	00054783          	lbu	a5,0(a0)
     b7a:	fbfd                	bnez	a5,b70 <strchr+0xe>
            return (char *)s;
    return 0;
     b7c:	4501                	li	a0,0
}
     b7e:	60a2                	ld	ra,8(sp)
     b80:	6402                	ld	s0,0(sp)
     b82:	0141                	addi	sp,sp,16
     b84:	8082                	ret
    return 0;
     b86:	4501                	li	a0,0
     b88:	bfdd                	j	b7e <strchr+0x1c>

0000000000000b8a <gets>:

char *
gets(char *buf, int max)
{
     b8a:	711d                	addi	sp,sp,-96
     b8c:	ec86                	sd	ra,88(sp)
     b8e:	e8a2                	sd	s0,80(sp)
     b90:	e4a6                	sd	s1,72(sp)
     b92:	e0ca                	sd	s2,64(sp)
     b94:	fc4e                	sd	s3,56(sp)
     b96:	f852                	sd	s4,48(sp)
     b98:	f456                	sd	s5,40(sp)
     b9a:	f05a                	sd	s6,32(sp)
     b9c:	ec5e                	sd	s7,24(sp)
     b9e:	e862                	sd	s8,16(sp)
     ba0:	1080                	addi	s0,sp,96
     ba2:	8baa                	mv	s7,a0
     ba4:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     ba6:	892a                	mv	s2,a0
     ba8:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     baa:	faf40b13          	addi	s6,s0,-81
     bae:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     bb0:	8c26                	mv	s8,s1
     bb2:	0014899b          	addiw	s3,s1,1
     bb6:	84ce                	mv	s1,s3
     bb8:	0349d663          	bge	s3,s4,be4 <gets+0x5a>
        cc = read(0, &c, 1);
     bbc:	8656                	mv	a2,s5
     bbe:	85da                	mv	a1,s6
     bc0:	4501                	li	a0,0
     bc2:	00000097          	auipc	ra,0x0
     bc6:	1a4080e7          	jalr	420(ra) # d66 <read>
        if (cc < 1)
     bca:	00a05d63          	blez	a0,be4 <gets+0x5a>
            break;
        buf[i++] = c;
     bce:	faf44783          	lbu	a5,-81(s0)
     bd2:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     bd6:	0905                	addi	s2,s2,1
     bd8:	ff678713          	addi	a4,a5,-10
     bdc:	c319                	beqz	a4,be2 <gets+0x58>
     bde:	17cd                	addi	a5,a5,-13
     be0:	fbe1                	bnez	a5,bb0 <gets+0x26>
        buf[i++] = c;
     be2:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     be4:	9c5e                	add	s8,s8,s7
     be6:	000c0023          	sb	zero,0(s8)
    return buf;
}
     bea:	855e                	mv	a0,s7
     bec:	60e6                	ld	ra,88(sp)
     bee:	6446                	ld	s0,80(sp)
     bf0:	64a6                	ld	s1,72(sp)
     bf2:	6906                	ld	s2,64(sp)
     bf4:	79e2                	ld	s3,56(sp)
     bf6:	7a42                	ld	s4,48(sp)
     bf8:	7aa2                	ld	s5,40(sp)
     bfa:	7b02                	ld	s6,32(sp)
     bfc:	6be2                	ld	s7,24(sp)
     bfe:	6c42                	ld	s8,16(sp)
     c00:	6125                	addi	sp,sp,96
     c02:	8082                	ret

0000000000000c04 <stat>:

int stat(const char *n, struct stat *st)
{
     c04:	1101                	addi	sp,sp,-32
     c06:	ec06                	sd	ra,24(sp)
     c08:	e822                	sd	s0,16(sp)
     c0a:	e04a                	sd	s2,0(sp)
     c0c:	1000                	addi	s0,sp,32
     c0e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     c10:	4581                	li	a1,0
     c12:	00000097          	auipc	ra,0x0
     c16:	17c080e7          	jalr	380(ra) # d8e <open>
    if (fd < 0)
     c1a:	02054663          	bltz	a0,c46 <stat+0x42>
     c1e:	e426                	sd	s1,8(sp)
     c20:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     c22:	85ca                	mv	a1,s2
     c24:	00000097          	auipc	ra,0x0
     c28:	182080e7          	jalr	386(ra) # da6 <fstat>
     c2c:	892a                	mv	s2,a0
    close(fd);
     c2e:	8526                	mv	a0,s1
     c30:	00000097          	auipc	ra,0x0
     c34:	146080e7          	jalr	326(ra) # d76 <close>
    return r;
     c38:	64a2                	ld	s1,8(sp)
}
     c3a:	854a                	mv	a0,s2
     c3c:	60e2                	ld	ra,24(sp)
     c3e:	6442                	ld	s0,16(sp)
     c40:	6902                	ld	s2,0(sp)
     c42:	6105                	addi	sp,sp,32
     c44:	8082                	ret
        return -1;
     c46:	57fd                	li	a5,-1
     c48:	893e                	mv	s2,a5
     c4a:	bfc5                	j	c3a <stat+0x36>

0000000000000c4c <atoi>:

int atoi(const char *s)
{
     c4c:	1141                	addi	sp,sp,-16
     c4e:	e406                	sd	ra,8(sp)
     c50:	e022                	sd	s0,0(sp)
     c52:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     c54:	00054683          	lbu	a3,0(a0)
     c58:	fd06879b          	addiw	a5,a3,-48
     c5c:	0ff7f793          	zext.b	a5,a5
     c60:	4625                	li	a2,9
     c62:	02f66963          	bltu	a2,a5,c94 <atoi+0x48>
     c66:	872a                	mv	a4,a0
    n = 0;
     c68:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     c6a:	0705                	addi	a4,a4,1
     c6c:	0025179b          	slliw	a5,a0,0x2
     c70:	9fa9                	addw	a5,a5,a0
     c72:	0017979b          	slliw	a5,a5,0x1
     c76:	9fb5                	addw	a5,a5,a3
     c78:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     c7c:	00074683          	lbu	a3,0(a4)
     c80:	fd06879b          	addiw	a5,a3,-48
     c84:	0ff7f793          	zext.b	a5,a5
     c88:	fef671e3          	bgeu	a2,a5,c6a <atoi+0x1e>
    return n;
}
     c8c:	60a2                	ld	ra,8(sp)
     c8e:	6402                	ld	s0,0(sp)
     c90:	0141                	addi	sp,sp,16
     c92:	8082                	ret
    n = 0;
     c94:	4501                	li	a0,0
     c96:	bfdd                	j	c8c <atoi+0x40>

0000000000000c98 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     c98:	1141                	addi	sp,sp,-16
     c9a:	e406                	sd	ra,8(sp)
     c9c:	e022                	sd	s0,0(sp)
     c9e:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     ca0:	02b57563          	bgeu	a0,a1,cca <memmove+0x32>
    {
        while (n-- > 0)
     ca4:	00c05f63          	blez	a2,cc2 <memmove+0x2a>
     ca8:	1602                	slli	a2,a2,0x20
     caa:	9201                	srli	a2,a2,0x20
     cac:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     cb0:	872a                	mv	a4,a0
            *dst++ = *src++;
     cb2:	0585                	addi	a1,a1,1
     cb4:	0705                	addi	a4,a4,1
     cb6:	fff5c683          	lbu	a3,-1(a1)
     cba:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     cbe:	fee79ae3          	bne	a5,a4,cb2 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     cc2:	60a2                	ld	ra,8(sp)
     cc4:	6402                	ld	s0,0(sp)
     cc6:	0141                	addi	sp,sp,16
     cc8:	8082                	ret
        while (n-- > 0)
     cca:	fec05ce3          	blez	a2,cc2 <memmove+0x2a>
        dst += n;
     cce:	00c50733          	add	a4,a0,a2
        src += n;
     cd2:	95b2                	add	a1,a1,a2
     cd4:	fff6079b          	addiw	a5,a2,-1
     cd8:	1782                	slli	a5,a5,0x20
     cda:	9381                	srli	a5,a5,0x20
     cdc:	fff7c793          	not	a5,a5
     ce0:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     ce2:	15fd                	addi	a1,a1,-1
     ce4:	177d                	addi	a4,a4,-1
     ce6:	0005c683          	lbu	a3,0(a1)
     cea:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     cee:	fef71ae3          	bne	a4,a5,ce2 <memmove+0x4a>
     cf2:	bfc1                	j	cc2 <memmove+0x2a>

0000000000000cf4 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     cf4:	1141                	addi	sp,sp,-16
     cf6:	e406                	sd	ra,8(sp)
     cf8:	e022                	sd	s0,0(sp)
     cfa:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     cfc:	c61d                	beqz	a2,d2a <memcmp+0x36>
     cfe:	1602                	slli	a2,a2,0x20
     d00:	9201                	srli	a2,a2,0x20
     d02:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     d06:	00054783          	lbu	a5,0(a0)
     d0a:	0005c703          	lbu	a4,0(a1)
     d0e:	00e79863          	bne	a5,a4,d1e <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     d12:	0505                	addi	a0,a0,1
        p2++;
     d14:	0585                	addi	a1,a1,1
    while (n-- > 0)
     d16:	fed518e3          	bne	a0,a3,d06 <memcmp+0x12>
    }
    return 0;
     d1a:	4501                	li	a0,0
     d1c:	a019                	j	d22 <memcmp+0x2e>
            return *p1 - *p2;
     d1e:	40e7853b          	subw	a0,a5,a4
}
     d22:	60a2                	ld	ra,8(sp)
     d24:	6402                	ld	s0,0(sp)
     d26:	0141                	addi	sp,sp,16
     d28:	8082                	ret
    return 0;
     d2a:	4501                	li	a0,0
     d2c:	bfdd                	j	d22 <memcmp+0x2e>

0000000000000d2e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d2e:	1141                	addi	sp,sp,-16
     d30:	e406                	sd	ra,8(sp)
     d32:	e022                	sd	s0,0(sp)
     d34:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     d36:	00000097          	auipc	ra,0x0
     d3a:	f62080e7          	jalr	-158(ra) # c98 <memmove>
}
     d3e:	60a2                	ld	ra,8(sp)
     d40:	6402                	ld	s0,0(sp)
     d42:	0141                	addi	sp,sp,16
     d44:	8082                	ret

0000000000000d46 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d46:	4885                	li	a7,1
 ecall
     d48:	00000073          	ecall
 ret
     d4c:	8082                	ret

0000000000000d4e <exit>:
.global exit
exit:
 li a7, SYS_exit
     d4e:	4889                	li	a7,2
 ecall
     d50:	00000073          	ecall
 ret
     d54:	8082                	ret

0000000000000d56 <wait>:
.global wait
wait:
 li a7, SYS_wait
     d56:	488d                	li	a7,3
 ecall
     d58:	00000073          	ecall
 ret
     d5c:	8082                	ret

0000000000000d5e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d5e:	4891                	li	a7,4
 ecall
     d60:	00000073          	ecall
 ret
     d64:	8082                	ret

0000000000000d66 <read>:
.global read
read:
 li a7, SYS_read
     d66:	4895                	li	a7,5
 ecall
     d68:	00000073          	ecall
 ret
     d6c:	8082                	ret

0000000000000d6e <write>:
.global write
write:
 li a7, SYS_write
     d6e:	48c1                	li	a7,16
 ecall
     d70:	00000073          	ecall
 ret
     d74:	8082                	ret

0000000000000d76 <close>:
.global close
close:
 li a7, SYS_close
     d76:	48d5                	li	a7,21
 ecall
     d78:	00000073          	ecall
 ret
     d7c:	8082                	ret

0000000000000d7e <kill>:
.global kill
kill:
 li a7, SYS_kill
     d7e:	4899                	li	a7,6
 ecall
     d80:	00000073          	ecall
 ret
     d84:	8082                	ret

0000000000000d86 <exec>:
.global exec
exec:
 li a7, SYS_exec
     d86:	489d                	li	a7,7
 ecall
     d88:	00000073          	ecall
 ret
     d8c:	8082                	ret

0000000000000d8e <open>:
.global open
open:
 li a7, SYS_open
     d8e:	48bd                	li	a7,15
 ecall
     d90:	00000073          	ecall
 ret
     d94:	8082                	ret

0000000000000d96 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d96:	48c5                	li	a7,17
 ecall
     d98:	00000073          	ecall
 ret
     d9c:	8082                	ret

0000000000000d9e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d9e:	48c9                	li	a7,18
 ecall
     da0:	00000073          	ecall
 ret
     da4:	8082                	ret

0000000000000da6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     da6:	48a1                	li	a7,8
 ecall
     da8:	00000073          	ecall
 ret
     dac:	8082                	ret

0000000000000dae <link>:
.global link
link:
 li a7, SYS_link
     dae:	48cd                	li	a7,19
 ecall
     db0:	00000073          	ecall
 ret
     db4:	8082                	ret

0000000000000db6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     db6:	48d1                	li	a7,20
 ecall
     db8:	00000073          	ecall
 ret
     dbc:	8082                	ret

0000000000000dbe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     dbe:	48a5                	li	a7,9
 ecall
     dc0:	00000073          	ecall
 ret
     dc4:	8082                	ret

0000000000000dc6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     dc6:	48a9                	li	a7,10
 ecall
     dc8:	00000073          	ecall
 ret
     dcc:	8082                	ret

0000000000000dce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     dce:	48ad                	li	a7,11
 ecall
     dd0:	00000073          	ecall
 ret
     dd4:	8082                	ret

0000000000000dd6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     dd6:	48b1                	li	a7,12
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     dde:	48b5                	li	a7,13
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     de6:	48b9                	li	a7,14
 ecall
     de8:	00000073          	ecall
 ret
     dec:	8082                	ret

0000000000000dee <ps>:
.global ps
ps:
 li a7, SYS_ps
     dee:	48d9                	li	a7,22
 ecall
     df0:	00000073          	ecall
 ret
     df4:	8082                	ret

0000000000000df6 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     df6:	48dd                	li	a7,23
 ecall
     df8:	00000073          	ecall
 ret
     dfc:	8082                	ret

0000000000000dfe <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     dfe:	48e1                	li	a7,24
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e06:	1101                	addi	sp,sp,-32
     e08:	ec06                	sd	ra,24(sp)
     e0a:	e822                	sd	s0,16(sp)
     e0c:	1000                	addi	s0,sp,32
     e0e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e12:	4605                	li	a2,1
     e14:	fef40593          	addi	a1,s0,-17
     e18:	00000097          	auipc	ra,0x0
     e1c:	f56080e7          	jalr	-170(ra) # d6e <write>
}
     e20:	60e2                	ld	ra,24(sp)
     e22:	6442                	ld	s0,16(sp)
     e24:	6105                	addi	sp,sp,32
     e26:	8082                	ret

0000000000000e28 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e28:	7139                	addi	sp,sp,-64
     e2a:	fc06                	sd	ra,56(sp)
     e2c:	f822                	sd	s0,48(sp)
     e2e:	f04a                	sd	s2,32(sp)
     e30:	ec4e                	sd	s3,24(sp)
     e32:	0080                	addi	s0,sp,64
     e34:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e36:	cad9                	beqz	a3,ecc <printint+0xa4>
     e38:	01f5d79b          	srliw	a5,a1,0x1f
     e3c:	cbc1                	beqz	a5,ecc <printint+0xa4>
    neg = 1;
    x = -xx;
     e3e:	40b005bb          	negw	a1,a1
    neg = 1;
     e42:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     e44:	fc040993          	addi	s3,s0,-64
  neg = 0;
     e48:	86ce                	mv	a3,s3
  i = 0;
     e4a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e4c:	00000817          	auipc	a6,0x0
     e50:	5f480813          	addi	a6,a6,1524 # 1440 <digits>
     e54:	88ba                	mv	a7,a4
     e56:	0017051b          	addiw	a0,a4,1
     e5a:	872a                	mv	a4,a0
     e5c:	02c5f7bb          	remuw	a5,a1,a2
     e60:	1782                	slli	a5,a5,0x20
     e62:	9381                	srli	a5,a5,0x20
     e64:	97c2                	add	a5,a5,a6
     e66:	0007c783          	lbu	a5,0(a5)
     e6a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e6e:	87ae                	mv	a5,a1
     e70:	02c5d5bb          	divuw	a1,a1,a2
     e74:	0685                	addi	a3,a3,1
     e76:	fcc7ffe3          	bgeu	a5,a2,e54 <printint+0x2c>
  if(neg)
     e7a:	00030c63          	beqz	t1,e92 <printint+0x6a>
    buf[i++] = '-';
     e7e:	fd050793          	addi	a5,a0,-48
     e82:	00878533          	add	a0,a5,s0
     e86:	02d00793          	li	a5,45
     e8a:	fef50823          	sb	a5,-16(a0)
     e8e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     e92:	02e05763          	blez	a4,ec0 <printint+0x98>
     e96:	f426                	sd	s1,40(sp)
     e98:	377d                	addiw	a4,a4,-1
     e9a:	00e984b3          	add	s1,s3,a4
     e9e:	19fd                	addi	s3,s3,-1
     ea0:	99ba                	add	s3,s3,a4
     ea2:	1702                	slli	a4,a4,0x20
     ea4:	9301                	srli	a4,a4,0x20
     ea6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     eaa:	0004c583          	lbu	a1,0(s1)
     eae:	854a                	mv	a0,s2
     eb0:	00000097          	auipc	ra,0x0
     eb4:	f56080e7          	jalr	-170(ra) # e06 <putc>
  while(--i >= 0)
     eb8:	14fd                	addi	s1,s1,-1
     eba:	ff3498e3          	bne	s1,s3,eaa <printint+0x82>
     ebe:	74a2                	ld	s1,40(sp)
}
     ec0:	70e2                	ld	ra,56(sp)
     ec2:	7442                	ld	s0,48(sp)
     ec4:	7902                	ld	s2,32(sp)
     ec6:	69e2                	ld	s3,24(sp)
     ec8:	6121                	addi	sp,sp,64
     eca:	8082                	ret
  neg = 0;
     ecc:	4301                	li	t1,0
     ece:	bf9d                	j	e44 <printint+0x1c>

0000000000000ed0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ed0:	715d                	addi	sp,sp,-80
     ed2:	e486                	sd	ra,72(sp)
     ed4:	e0a2                	sd	s0,64(sp)
     ed6:	f84a                	sd	s2,48(sp)
     ed8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     eda:	0005c903          	lbu	s2,0(a1)
     ede:	1a090b63          	beqz	s2,1094 <vprintf+0x1c4>
     ee2:	fc26                	sd	s1,56(sp)
     ee4:	f44e                	sd	s3,40(sp)
     ee6:	f052                	sd	s4,32(sp)
     ee8:	ec56                	sd	s5,24(sp)
     eea:	e85a                	sd	s6,16(sp)
     eec:	e45e                	sd	s7,8(sp)
     eee:	8aaa                	mv	s5,a0
     ef0:	8bb2                	mv	s7,a2
     ef2:	00158493          	addi	s1,a1,1
  state = 0;
     ef6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ef8:	02500a13          	li	s4,37
     efc:	4b55                	li	s6,21
     efe:	a839                	j	f1c <vprintf+0x4c>
        putc(fd, c);
     f00:	85ca                	mv	a1,s2
     f02:	8556                	mv	a0,s5
     f04:	00000097          	auipc	ra,0x0
     f08:	f02080e7          	jalr	-254(ra) # e06 <putc>
     f0c:	a019                	j	f12 <vprintf+0x42>
    } else if(state == '%'){
     f0e:	01498d63          	beq	s3,s4,f28 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     f12:	0485                	addi	s1,s1,1
     f14:	fff4c903          	lbu	s2,-1(s1)
     f18:	16090863          	beqz	s2,1088 <vprintf+0x1b8>
    if(state == 0){
     f1c:	fe0999e3          	bnez	s3,f0e <vprintf+0x3e>
      if(c == '%'){
     f20:	ff4910e3          	bne	s2,s4,f00 <vprintf+0x30>
        state = '%';
     f24:	89d2                	mv	s3,s4
     f26:	b7f5                	j	f12 <vprintf+0x42>
      if(c == 'd'){
     f28:	13490563          	beq	s2,s4,1052 <vprintf+0x182>
     f2c:	f9d9079b          	addiw	a5,s2,-99
     f30:	0ff7f793          	zext.b	a5,a5
     f34:	12fb6863          	bltu	s6,a5,1064 <vprintf+0x194>
     f38:	f9d9079b          	addiw	a5,s2,-99
     f3c:	0ff7f713          	zext.b	a4,a5
     f40:	12eb6263          	bltu	s6,a4,1064 <vprintf+0x194>
     f44:	00271793          	slli	a5,a4,0x2
     f48:	00000717          	auipc	a4,0x0
     f4c:	4a070713          	addi	a4,a4,1184 # 13e8 <malloc+0x260>
     f50:	97ba                	add	a5,a5,a4
     f52:	439c                	lw	a5,0(a5)
     f54:	97ba                	add	a5,a5,a4
     f56:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     f58:	008b8913          	addi	s2,s7,8
     f5c:	4685                	li	a3,1
     f5e:	4629                	li	a2,10
     f60:	000ba583          	lw	a1,0(s7)
     f64:	8556                	mv	a0,s5
     f66:	00000097          	auipc	ra,0x0
     f6a:	ec2080e7          	jalr	-318(ra) # e28 <printint>
     f6e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     f70:	4981                	li	s3,0
     f72:	b745                	j	f12 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f74:	008b8913          	addi	s2,s7,8
     f78:	4681                	li	a3,0
     f7a:	4629                	li	a2,10
     f7c:	000ba583          	lw	a1,0(s7)
     f80:	8556                	mv	a0,s5
     f82:	00000097          	auipc	ra,0x0
     f86:	ea6080e7          	jalr	-346(ra) # e28 <printint>
     f8a:	8bca                	mv	s7,s2
      state = 0;
     f8c:	4981                	li	s3,0
     f8e:	b751                	j	f12 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     f90:	008b8913          	addi	s2,s7,8
     f94:	4681                	li	a3,0
     f96:	4641                	li	a2,16
     f98:	000ba583          	lw	a1,0(s7)
     f9c:	8556                	mv	a0,s5
     f9e:	00000097          	auipc	ra,0x0
     fa2:	e8a080e7          	jalr	-374(ra) # e28 <printint>
     fa6:	8bca                	mv	s7,s2
      state = 0;
     fa8:	4981                	li	s3,0
     faa:	b7a5                	j	f12 <vprintf+0x42>
     fac:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fae:	008b8793          	addi	a5,s7,8
     fb2:	8c3e                	mv	s8,a5
     fb4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fb8:	03000593          	li	a1,48
     fbc:	8556                	mv	a0,s5
     fbe:	00000097          	auipc	ra,0x0
     fc2:	e48080e7          	jalr	-440(ra) # e06 <putc>
  putc(fd, 'x');
     fc6:	07800593          	li	a1,120
     fca:	8556                	mv	a0,s5
     fcc:	00000097          	auipc	ra,0x0
     fd0:	e3a080e7          	jalr	-454(ra) # e06 <putc>
     fd4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fd6:	00000b97          	auipc	s7,0x0
     fda:	46ab8b93          	addi	s7,s7,1130 # 1440 <digits>
     fde:	03c9d793          	srli	a5,s3,0x3c
     fe2:	97de                	add	a5,a5,s7
     fe4:	0007c583          	lbu	a1,0(a5)
     fe8:	8556                	mv	a0,s5
     fea:	00000097          	auipc	ra,0x0
     fee:	e1c080e7          	jalr	-484(ra) # e06 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ff2:	0992                	slli	s3,s3,0x4
     ff4:	397d                	addiw	s2,s2,-1
     ff6:	fe0914e3          	bnez	s2,fde <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     ffa:	8be2                	mv	s7,s8
      state = 0;
     ffc:	4981                	li	s3,0
     ffe:	6c02                	ld	s8,0(sp)
    1000:	bf09                	j	f12 <vprintf+0x42>
        s = va_arg(ap, char*);
    1002:	008b8993          	addi	s3,s7,8
    1006:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    100a:	02090163          	beqz	s2,102c <vprintf+0x15c>
        while(*s != 0){
    100e:	00094583          	lbu	a1,0(s2)
    1012:	c9a5                	beqz	a1,1082 <vprintf+0x1b2>
          putc(fd, *s);
    1014:	8556                	mv	a0,s5
    1016:	00000097          	auipc	ra,0x0
    101a:	df0080e7          	jalr	-528(ra) # e06 <putc>
          s++;
    101e:	0905                	addi	s2,s2,1
        while(*s != 0){
    1020:	00094583          	lbu	a1,0(s2)
    1024:	f9e5                	bnez	a1,1014 <vprintf+0x144>
        s = va_arg(ap, char*);
    1026:	8bce                	mv	s7,s3
      state = 0;
    1028:	4981                	li	s3,0
    102a:	b5e5                	j	f12 <vprintf+0x42>
          s = "(null)";
    102c:	00000917          	auipc	s2,0x0
    1030:	3b490913          	addi	s2,s2,948 # 13e0 <malloc+0x258>
        while(*s != 0){
    1034:	02800593          	li	a1,40
    1038:	bff1                	j	1014 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    103a:	008b8913          	addi	s2,s7,8
    103e:	000bc583          	lbu	a1,0(s7)
    1042:	8556                	mv	a0,s5
    1044:	00000097          	auipc	ra,0x0
    1048:	dc2080e7          	jalr	-574(ra) # e06 <putc>
    104c:	8bca                	mv	s7,s2
      state = 0;
    104e:	4981                	li	s3,0
    1050:	b5c9                	j	f12 <vprintf+0x42>
        putc(fd, c);
    1052:	02500593          	li	a1,37
    1056:	8556                	mv	a0,s5
    1058:	00000097          	auipc	ra,0x0
    105c:	dae080e7          	jalr	-594(ra) # e06 <putc>
      state = 0;
    1060:	4981                	li	s3,0
    1062:	bd45                	j	f12 <vprintf+0x42>
        putc(fd, '%');
    1064:	02500593          	li	a1,37
    1068:	8556                	mv	a0,s5
    106a:	00000097          	auipc	ra,0x0
    106e:	d9c080e7          	jalr	-612(ra) # e06 <putc>
        putc(fd, c);
    1072:	85ca                	mv	a1,s2
    1074:	8556                	mv	a0,s5
    1076:	00000097          	auipc	ra,0x0
    107a:	d90080e7          	jalr	-624(ra) # e06 <putc>
      state = 0;
    107e:	4981                	li	s3,0
    1080:	bd49                	j	f12 <vprintf+0x42>
        s = va_arg(ap, char*);
    1082:	8bce                	mv	s7,s3
      state = 0;
    1084:	4981                	li	s3,0
    1086:	b571                	j	f12 <vprintf+0x42>
    1088:	74e2                	ld	s1,56(sp)
    108a:	79a2                	ld	s3,40(sp)
    108c:	7a02                	ld	s4,32(sp)
    108e:	6ae2                	ld	s5,24(sp)
    1090:	6b42                	ld	s6,16(sp)
    1092:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1094:	60a6                	ld	ra,72(sp)
    1096:	6406                	ld	s0,64(sp)
    1098:	7942                	ld	s2,48(sp)
    109a:	6161                	addi	sp,sp,80
    109c:	8082                	ret

000000000000109e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    109e:	715d                	addi	sp,sp,-80
    10a0:	ec06                	sd	ra,24(sp)
    10a2:	e822                	sd	s0,16(sp)
    10a4:	1000                	addi	s0,sp,32
    10a6:	e010                	sd	a2,0(s0)
    10a8:	e414                	sd	a3,8(s0)
    10aa:	e818                	sd	a4,16(s0)
    10ac:	ec1c                	sd	a5,24(s0)
    10ae:	03043023          	sd	a6,32(s0)
    10b2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10b6:	8622                	mv	a2,s0
    10b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10bc:	00000097          	auipc	ra,0x0
    10c0:	e14080e7          	jalr	-492(ra) # ed0 <vprintf>
}
    10c4:	60e2                	ld	ra,24(sp)
    10c6:	6442                	ld	s0,16(sp)
    10c8:	6161                	addi	sp,sp,80
    10ca:	8082                	ret

00000000000010cc <printf>:

void
printf(const char *fmt, ...)
{
    10cc:	711d                	addi	sp,sp,-96
    10ce:	ec06                	sd	ra,24(sp)
    10d0:	e822                	sd	s0,16(sp)
    10d2:	1000                	addi	s0,sp,32
    10d4:	e40c                	sd	a1,8(s0)
    10d6:	e810                	sd	a2,16(s0)
    10d8:	ec14                	sd	a3,24(s0)
    10da:	f018                	sd	a4,32(s0)
    10dc:	f41c                	sd	a5,40(s0)
    10de:	03043823          	sd	a6,48(s0)
    10e2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10e6:	00840613          	addi	a2,s0,8
    10ea:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ee:	85aa                	mv	a1,a0
    10f0:	4505                	li	a0,1
    10f2:	00000097          	auipc	ra,0x0
    10f6:	dde080e7          	jalr	-546(ra) # ed0 <vprintf>
}
    10fa:	60e2                	ld	ra,24(sp)
    10fc:	6442                	ld	s0,16(sp)
    10fe:	6125                	addi	sp,sp,96
    1100:	8082                	ret

0000000000001102 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    1102:	1141                	addi	sp,sp,-16
    1104:	e406                	sd	ra,8(sp)
    1106:	e022                	sd	s0,0(sp)
    1108:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    110a:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    110e:	00001797          	auipc	a5,0x1
    1112:	f027b783          	ld	a5,-254(a5) # 2010 <freep>
    1116:	a039                	j	1124 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1118:	6398                	ld	a4,0(a5)
    111a:	00e7e463          	bltu	a5,a4,1122 <free+0x20>
    111e:	00e6ea63          	bltu	a3,a4,1132 <free+0x30>
{
    1122:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1124:	fed7fae3          	bgeu	a5,a3,1118 <free+0x16>
    1128:	6398                	ld	a4,0(a5)
    112a:	00e6e463          	bltu	a3,a4,1132 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    112e:	fee7eae3          	bltu	a5,a4,1122 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    1132:	ff852583          	lw	a1,-8(a0)
    1136:	6390                	ld	a2,0(a5)
    1138:	02059813          	slli	a6,a1,0x20
    113c:	01c85713          	srli	a4,a6,0x1c
    1140:	9736                	add	a4,a4,a3
    1142:	02e60563          	beq	a2,a4,116c <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    1146:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    114a:	4790                	lw	a2,8(a5)
    114c:	02061593          	slli	a1,a2,0x20
    1150:	01c5d713          	srli	a4,a1,0x1c
    1154:	973e                	add	a4,a4,a5
    1156:	02e68263          	beq	a3,a4,117a <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    115a:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    115c:	00001717          	auipc	a4,0x1
    1160:	eaf73a23          	sd	a5,-332(a4) # 2010 <freep>
}
    1164:	60a2                	ld	ra,8(sp)
    1166:	6402                	ld	s0,0(sp)
    1168:	0141                	addi	sp,sp,16
    116a:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    116c:	4618                	lw	a4,8(a2)
    116e:	9f2d                	addw	a4,a4,a1
    1170:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    1174:	6398                	ld	a4,0(a5)
    1176:	6310                	ld	a2,0(a4)
    1178:	b7f9                	j	1146 <free+0x44>
        p->s.size += bp->s.size;
    117a:	ff852703          	lw	a4,-8(a0)
    117e:	9f31                	addw	a4,a4,a2
    1180:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    1182:	ff053683          	ld	a3,-16(a0)
    1186:	bfd1                	j	115a <free+0x58>

0000000000001188 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    1188:	7139                	addi	sp,sp,-64
    118a:	fc06                	sd	ra,56(sp)
    118c:	f822                	sd	s0,48(sp)
    118e:	f04a                	sd	s2,32(sp)
    1190:	ec4e                	sd	s3,24(sp)
    1192:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1194:	02051993          	slli	s3,a0,0x20
    1198:	0209d993          	srli	s3,s3,0x20
    119c:	09bd                	addi	s3,s3,15
    119e:	0049d993          	srli	s3,s3,0x4
    11a2:	2985                	addiw	s3,s3,1
    11a4:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    11a6:	00001517          	auipc	a0,0x1
    11aa:	e6a53503          	ld	a0,-406(a0) # 2010 <freep>
    11ae:	c905                	beqz	a0,11de <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    11b0:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    11b2:	4798                	lw	a4,8(a5)
    11b4:	09377a63          	bgeu	a4,s3,1248 <malloc+0xc0>
    11b8:	f426                	sd	s1,40(sp)
    11ba:	e852                	sd	s4,16(sp)
    11bc:	e456                	sd	s5,8(sp)
    11be:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    11c0:	8a4e                	mv	s4,s3
    11c2:	6705                	lui	a4,0x1
    11c4:	00e9f363          	bgeu	s3,a4,11ca <malloc+0x42>
    11c8:	6a05                	lui	s4,0x1
    11ca:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    11ce:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    11d2:	00001497          	auipc	s1,0x1
    11d6:	e3e48493          	addi	s1,s1,-450 # 2010 <freep>
    if (p == (char *)-1)
    11da:	5afd                	li	s5,-1
    11dc:	a089                	j	121e <malloc+0x96>
    11de:	f426                	sd	s1,40(sp)
    11e0:	e852                	sd	s4,16(sp)
    11e2:	e456                	sd	s5,8(sp)
    11e4:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    11e6:	00002797          	auipc	a5,0x2
    11ea:	94a78793          	addi	a5,a5,-1718 # 2b30 <base>
    11ee:	00001717          	auipc	a4,0x1
    11f2:	e2f73123          	sd	a5,-478(a4) # 2010 <freep>
    11f6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    11f8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    11fc:	b7d1                	j	11c0 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    11fe:	6398                	ld	a4,0(a5)
    1200:	e118                	sd	a4,0(a0)
    1202:	a8b9                	j	1260 <malloc+0xd8>
    hp->s.size = nu;
    1204:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1208:	0541                	addi	a0,a0,16
    120a:	00000097          	auipc	ra,0x0
    120e:	ef8080e7          	jalr	-264(ra) # 1102 <free>
    return freep;
    1212:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1214:	c135                	beqz	a0,1278 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1216:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1218:	4798                	lw	a4,8(a5)
    121a:	03277363          	bgeu	a4,s2,1240 <malloc+0xb8>
        if (p == freep)
    121e:	6098                	ld	a4,0(s1)
    1220:	853e                	mv	a0,a5
    1222:	fef71ae3          	bne	a4,a5,1216 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1226:	8552                	mv	a0,s4
    1228:	00000097          	auipc	ra,0x0
    122c:	bae080e7          	jalr	-1106(ra) # dd6 <sbrk>
    if (p == (char *)-1)
    1230:	fd551ae3          	bne	a0,s5,1204 <malloc+0x7c>
                return 0;
    1234:	4501                	li	a0,0
    1236:	74a2                	ld	s1,40(sp)
    1238:	6a42                	ld	s4,16(sp)
    123a:	6aa2                	ld	s5,8(sp)
    123c:	6b02                	ld	s6,0(sp)
    123e:	a03d                	j	126c <malloc+0xe4>
    1240:	74a2                	ld	s1,40(sp)
    1242:	6a42                	ld	s4,16(sp)
    1244:	6aa2                	ld	s5,8(sp)
    1246:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1248:	fae90be3          	beq	s2,a4,11fe <malloc+0x76>
                p->s.size -= nunits;
    124c:	4137073b          	subw	a4,a4,s3
    1250:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1252:	02071693          	slli	a3,a4,0x20
    1256:	01c6d713          	srli	a4,a3,0x1c
    125a:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    125c:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1260:	00001717          	auipc	a4,0x1
    1264:	daa73823          	sd	a0,-592(a4) # 2010 <freep>
            return (void *)(p + 1);
    1268:	01078513          	addi	a0,a5,16
    }
}
    126c:	70e2                	ld	ra,56(sp)
    126e:	7442                	ld	s0,48(sp)
    1270:	7902                	ld	s2,32(sp)
    1272:	69e2                	ld	s3,24(sp)
    1274:	6121                	addi	sp,sp,64
    1276:	8082                	ret
    1278:	74a2                	ld	s1,40(sp)
    127a:	6a42                	ld	s4,16(sp)
    127c:	6aa2                	ld	s5,8(sp)
    127e:	6b02                	ld	s6,0(sp)
    1280:	b7f5                	j	126c <malloc+0xe4>
