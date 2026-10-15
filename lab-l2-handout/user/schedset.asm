
user/_schedset:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2)
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
    {
        printf("Usage: schedset [SCHED ID]\n");
   e:	00001517          	auipc	a0,0x1
  12:	82250513          	addi	a0,a0,-2014 # 830 <malloc+0x102>
  16:	00000097          	auipc	ra,0x0
  1a:	65c080e7          	jalr	1628(ra) # 672 <printf>
        exit(1);
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	2cc080e7          	jalr	716(ra) # 2ec <exit>
    }
    int schedid = (*argv[1]) - '0';
  28:	659c                	ld	a5,8(a1)
  2a:	0007c503          	lbu	a0,0(a5)
    schedset(schedid);
  2e:	fd05051b          	addiw	a0,a0,-48
  32:	00000097          	auipc	ra,0x0
  36:	36a080e7          	jalr	874(ra) # 39c <schedset>
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2b0080e7          	jalr	688(ra) # 2ec <exit>

0000000000000044 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  4c:	00000097          	auipc	ra,0x0
  50:	fb4080e7          	jalr	-76(ra) # 0 <main>
  exit(0);
  54:	4501                	li	a0,0
  56:	00000097          	auipc	ra,0x0
  5a:	296080e7          	jalr	662(ra) # 2ec <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf81                	beqz	a5,124 <strchr+0x24>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strchr+0x1c>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	e862                	sd	s8,16(sp)
 13e:	1080                	addi	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
 148:	faf40b13          	addi	s6,s0,-81
 14c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 14e:	8c26                	mv	s8,s1
 150:	0014899b          	addiw	s3,s1,1
 154:	84ce                	mv	s1,s3
 156:	0349d663          	bge	s3,s4,182 <gets+0x5a>
    cc = read(0, &c, 1);
 15a:	8656                	mv	a2,s5
 15c:	85da                	mv	a1,s6
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	1a4080e7          	jalr	420(ra) # 304 <read>
    if(cc < 1)
 168:	00a05d63          	blez	a0,182 <gets+0x5a>
      break;
    buf[i++] = c;
 16c:	faf44783          	lbu	a5,-81(s0)
 170:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 174:	0905                	addi	s2,s2,1
 176:	ff678713          	addi	a4,a5,-10
 17a:	c319                	beqz	a4,180 <gets+0x58>
 17c:	17cd                	addi	a5,a5,-13
 17e:	fbe1                	bnez	a5,14e <gets+0x26>
    buf[i++] = c;
 180:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 182:	9c5e                	add	s8,s8,s7
 184:	000c0023          	sb	zero,0(s8)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6c42                	ld	s8,16(sp)
 19e:	6125                	addi	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	17c080e7          	jalr	380(ra) # 32c <open>
  if(fd < 0)
 1b8:	02054663          	bltz	a0,1e4 <stat+0x42>
 1bc:	e426                	sd	s1,8(sp)
 1be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c0:	85ca                	mv	a1,s2
 1c2:	00000097          	auipc	ra,0x0
 1c6:	182080e7          	jalr	386(ra) # 344 <fstat>
 1ca:	892a                	mv	s2,a0
  close(fd);
 1cc:	8526                	mv	a0,s1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	146080e7          	jalr	326(ra) # 314 <close>
  return r;
 1d6:	64a2                	ld	s1,8(sp)
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	57fd                	li	a5,-1
 1e6:	893e                	mv	s2,a5
 1e8:	bfc5                	j	1d8 <stat+0x36>

00000000000001ea <atoi>:

int
atoi(const char *s)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66963          	bltu	a2,a5,232 <atoi+0x48>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1e>
  return n;
}
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfdd                	j	22a <atoi+0x40>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57563          	bgeu	a0,a1,268 <memmove+0x32>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x2a>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
    while(n-- > 0)
 268:	fec05ce3          	blez	a2,260 <memmove+0x2a>
    dst += n;
 26c:	00c50733          	add	a4,a0,a2
    src += n;
 270:	95b2                	add	a1,a1,a2
 272:	fff6079b          	addiw	a5,a2,-1
 276:	1782                	slli	a5,a5,0x20
 278:	9381                	srli	a5,a5,0x20
 27a:	fff7c793          	not	a5,a5
 27e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 280:	15fd                	addi	a1,a1,-1
 282:	177d                	addi	a4,a4,-1
 284:	0005c683          	lbu	a3,0(a1)
 288:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28c:	fef71ae3          	bne	a4,a5,280 <memmove+0x4a>
 290:	bfc1                	j	260 <memmove+0x2a>

0000000000000292 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29a:	c61d                	beqz	a2,2c8 <memcmp+0x36>
 29c:	1602                	slli	a2,a2,0x20
 29e:	9201                	srli	a2,a2,0x20
 2a0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2b0:	0505                	addi	a0,a0,1
    p2++;
 2b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x12>
  }
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x2e>
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  return 0;
 2c8:	4501                	li	a0,0
 2ca:	bfdd                	j	2c0 <memcmp+0x2e>

00000000000002cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d4:	00000097          	auipc	ra,0x0
 2d8:	f62080e7          	jalr	-158(ra) # 236 <memmove>
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e4:	4885                	li	a7,1
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ec:	4889                	li	a7,2
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f4:	488d                	li	a7,3
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fc:	4891                	li	a7,4
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <read>:
.global read
read:
 li a7, SYS_read
 304:	4895                	li	a7,5
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <write>:
.global write
write:
 li a7, SYS_write
 30c:	48c1                	li	a7,16
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <close>:
.global close
close:
 li a7, SYS_close
 314:	48d5                	li	a7,21
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <kill>:
.global kill
kill:
 li a7, SYS_kill
 31c:	4899                	li	a7,6
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <exec>:
.global exec
exec:
 li a7, SYS_exec
 324:	489d                	li	a7,7
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <open>:
.global open
open:
 li a7, SYS_open
 32c:	48bd                	li	a7,15
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 334:	48c5                	li	a7,17
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33c:	48c9                	li	a7,18
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 344:	48a1                	li	a7,8
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <link>:
.global link
link:
 li a7, SYS_link
 34c:	48cd                	li	a7,19
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 354:	48d1                	li	a7,20
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35c:	48a5                	li	a7,9
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <dup>:
.global dup
dup:
 li a7, SYS_dup
 364:	48a9                	li	a7,10
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36c:	48ad                	li	a7,11
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 374:	48b1                	li	a7,12
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37c:	48b5                	li	a7,13
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 384:	48b9                	li	a7,14
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <ps>:
.global ps
ps:
 li a7, SYS_ps
 38c:	48d9                	li	a7,22
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 394:	48dd                	li	a7,23
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 39c:	48e1                	li	a7,24
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <yield>:
.global yield
yield:
 li a7, SYS_yield
 3a4:	48e5                	li	a7,25
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	00000097          	auipc	ra,0x0
 3c2:	f4e080e7          	jalr	-178(ra) # 30c <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ce:	7139                	addi	sp,sp,-64
 3d0:	fc06                	sd	ra,56(sp)
 3d2:	f822                	sd	s0,48(sp)
 3d4:	f04a                	sd	s2,32(sp)
 3d6:	ec4e                	sd	s3,24(sp)
 3d8:	0080                	addi	s0,sp,64
 3da:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3dc:	cad9                	beqz	a3,472 <printint+0xa4>
 3de:	01f5d79b          	srliw	a5,a1,0x1f
 3e2:	cbc1                	beqz	a5,472 <printint+0xa4>
    neg = 1;
    x = -xx;
 3e4:	40b005bb          	negw	a1,a1
    neg = 1;
 3e8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ea:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3ee:	86ce                	mv	a3,s3
  i = 0;
 3f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f2:	00000817          	auipc	a6,0x0
 3f6:	4be80813          	addi	a6,a6,1214 # 8b0 <digits>
 3fa:	88ba                	mv	a7,a4
 3fc:	0017051b          	addiw	a0,a4,1
 400:	872a                	mv	a4,a0
 402:	02c5f7bb          	remuw	a5,a1,a2
 406:	1782                	slli	a5,a5,0x20
 408:	9381                	srli	a5,a5,0x20
 40a:	97c2                	add	a5,a5,a6
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 414:	87ae                	mv	a5,a1
 416:	02c5d5bb          	divuw	a1,a1,a2
 41a:	0685                	addi	a3,a3,1
 41c:	fcc7ffe3          	bgeu	a5,a2,3fa <printint+0x2c>
  if(neg)
 420:	00030c63          	beqz	t1,438 <printint+0x6a>
    buf[i++] = '-';
 424:	fd050793          	addi	a5,a0,-48
 428:	00878533          	add	a0,a5,s0
 42c:	02d00793          	li	a5,45
 430:	fef50823          	sb	a5,-16(a0)
 434:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 438:	02e05763          	blez	a4,466 <printint+0x98>
 43c:	f426                	sd	s1,40(sp)
 43e:	377d                	addiw	a4,a4,-1
 440:	00e984b3          	add	s1,s3,a4
 444:	19fd                	addi	s3,s3,-1
 446:	99ba                	add	s3,s3,a4
 448:	1702                	slli	a4,a4,0x20
 44a:	9301                	srli	a4,a4,0x20
 44c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 450:	0004c583          	lbu	a1,0(s1)
 454:	854a                	mv	a0,s2
 456:	00000097          	auipc	ra,0x0
 45a:	f56080e7          	jalr	-170(ra) # 3ac <putc>
  while(--i >= 0)
 45e:	14fd                	addi	s1,s1,-1
 460:	ff3498e3          	bne	s1,s3,450 <printint+0x82>
 464:	74a2                	ld	s1,40(sp)
}
 466:	70e2                	ld	ra,56(sp)
 468:	7442                	ld	s0,48(sp)
 46a:	7902                	ld	s2,32(sp)
 46c:	69e2                	ld	s3,24(sp)
 46e:	6121                	addi	sp,sp,64
 470:	8082                	ret
  neg = 0;
 472:	4301                	li	t1,0
 474:	bf9d                	j	3ea <printint+0x1c>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	715d                	addi	sp,sp,-80
 478:	e486                	sd	ra,72(sp)
 47a:	e0a2                	sd	s0,64(sp)
 47c:	f84a                	sd	s2,48(sp)
 47e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c903          	lbu	s2,0(a1)
 484:	1a090b63          	beqz	s2,63a <vprintf+0x1c4>
 488:	fc26                	sd	s1,56(sp)
 48a:	f44e                	sd	s3,40(sp)
 48c:	f052                	sd	s4,32(sp)
 48e:	ec56                	sd	s5,24(sp)
 490:	e85a                	sd	s6,16(sp)
 492:	e45e                	sd	s7,8(sp)
 494:	8aaa                	mv	s5,a0
 496:	8bb2                	mv	s7,a2
 498:	00158493          	addi	s1,a1,1
  state = 0;
 49c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49e:	02500a13          	li	s4,37
 4a2:	4b55                	li	s6,21
 4a4:	a839                	j	4c2 <vprintf+0x4c>
        putc(fd, c);
 4a6:	85ca                	mv	a1,s2
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	f02080e7          	jalr	-254(ra) # 3ac <putc>
 4b2:	a019                	j	4b8 <vprintf+0x42>
    } else if(state == '%'){
 4b4:	01498d63          	beq	s3,s4,4ce <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4b8:	0485                	addi	s1,s1,1
 4ba:	fff4c903          	lbu	s2,-1(s1)
 4be:	16090863          	beqz	s2,62e <vprintf+0x1b8>
    if(state == 0){
 4c2:	fe0999e3          	bnez	s3,4b4 <vprintf+0x3e>
      if(c == '%'){
 4c6:	ff4910e3          	bne	s2,s4,4a6 <vprintf+0x30>
        state = '%';
 4ca:	89d2                	mv	s3,s4
 4cc:	b7f5                	j	4b8 <vprintf+0x42>
      if(c == 'd'){
 4ce:	13490563          	beq	s2,s4,5f8 <vprintf+0x182>
 4d2:	f9d9079b          	addiw	a5,s2,-99
 4d6:	0ff7f793          	zext.b	a5,a5
 4da:	12fb6863          	bltu	s6,a5,60a <vprintf+0x194>
 4de:	f9d9079b          	addiw	a5,s2,-99
 4e2:	0ff7f713          	zext.b	a4,a5
 4e6:	12eb6263          	bltu	s6,a4,60a <vprintf+0x194>
 4ea:	00271793          	slli	a5,a4,0x2
 4ee:	00000717          	auipc	a4,0x0
 4f2:	36a70713          	addi	a4,a4,874 # 858 <malloc+0x12a>
 4f6:	97ba                	add	a5,a5,a4
 4f8:	439c                	lw	a5,0(a5)
 4fa:	97ba                	add	a5,a5,a4
 4fc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b8913          	addi	s2,s7,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	ec2080e7          	jalr	-318(ra) # 3ce <printint>
 514:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 516:	4981                	li	s3,0
 518:	b745                	j	4b8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51a:	008b8913          	addi	s2,s7,8
 51e:	4681                	li	a3,0
 520:	4629                	li	a2,10
 522:	000ba583          	lw	a1,0(s7)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	ea6080e7          	jalr	-346(ra) # 3ce <printint>
 530:	8bca                	mv	s7,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	b751                	j	4b8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 536:	008b8913          	addi	s2,s7,8
 53a:	4681                	li	a3,0
 53c:	4641                	li	a2,16
 53e:	000ba583          	lw	a1,0(s7)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e8a080e7          	jalr	-374(ra) # 3ce <printint>
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	b7a5                	j	4b8 <vprintf+0x42>
 552:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 554:	008b8793          	addi	a5,s7,8
 558:	8c3e                	mv	s8,a5
 55a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 55e:	03000593          	li	a1,48
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e48080e7          	jalr	-440(ra) # 3ac <putc>
  putc(fd, 'x');
 56c:	07800593          	li	a1,120
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	e3a080e7          	jalr	-454(ra) # 3ac <putc>
 57a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57c:	00000b97          	auipc	s7,0x0
 580:	334b8b93          	addi	s7,s7,820 # 8b0 <digits>
 584:	03c9d793          	srli	a5,s3,0x3c
 588:	97de                	add	a5,a5,s7
 58a:	0007c583          	lbu	a1,0(a5)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e1c080e7          	jalr	-484(ra) # 3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 598:	0992                	slli	s3,s3,0x4
 59a:	397d                	addiw	s2,s2,-1
 59c:	fe0914e3          	bnez	s2,584 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5a0:	8be2                	mv	s7,s8
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	6c02                	ld	s8,0(sp)
 5a6:	bf09                	j	4b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 5a8:	008b8993          	addi	s3,s7,8
 5ac:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5b0:	02090163          	beqz	s2,5d2 <vprintf+0x15c>
        while(*s != 0){
 5b4:	00094583          	lbu	a1,0(s2)
 5b8:	c9a5                	beqz	a1,628 <vprintf+0x1b2>
          putc(fd, *s);
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	df0080e7          	jalr	-528(ra) # 3ac <putc>
          s++;
 5c4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5c6:	00094583          	lbu	a1,0(s2)
 5ca:	f9e5                	bnez	a1,5ba <vprintf+0x144>
        s = va_arg(ap, char*);
 5cc:	8bce                	mv	s7,s3
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b5e5                	j	4b8 <vprintf+0x42>
          s = "(null)";
 5d2:	00000917          	auipc	s2,0x0
 5d6:	27e90913          	addi	s2,s2,638 # 850 <malloc+0x122>
        while(*s != 0){
 5da:	02800593          	li	a1,40
 5de:	bff1                	j	5ba <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	000bc583          	lbu	a1,0(s7)
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	dc2080e7          	jalr	-574(ra) # 3ac <putc>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b5c9                	j	4b8 <vprintf+0x42>
        putc(fd, c);
 5f8:	02500593          	li	a1,37
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	dae080e7          	jalr	-594(ra) # 3ac <putc>
      state = 0;
 606:	4981                	li	s3,0
 608:	bd45                	j	4b8 <vprintf+0x42>
        putc(fd, '%');
 60a:	02500593          	li	a1,37
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	d9c080e7          	jalr	-612(ra) # 3ac <putc>
        putc(fd, c);
 618:	85ca                	mv	a1,s2
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	d90080e7          	jalr	-624(ra) # 3ac <putc>
      state = 0;
 624:	4981                	li	s3,0
 626:	bd49                	j	4b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 628:	8bce                	mv	s7,s3
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b571                	j	4b8 <vprintf+0x42>
 62e:	74e2                	ld	s1,56(sp)
 630:	79a2                	ld	s3,40(sp)
 632:	7a02                	ld	s4,32(sp)
 634:	6ae2                	ld	s5,24(sp)
 636:	6b42                	ld	s6,16(sp)
 638:	6ba2                	ld	s7,8(sp)
    }
  }
}
 63a:	60a6                	ld	ra,72(sp)
 63c:	6406                	ld	s0,64(sp)
 63e:	7942                	ld	s2,48(sp)
 640:	6161                	addi	sp,sp,80
 642:	8082                	ret

0000000000000644 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 644:	715d                	addi	sp,sp,-80
 646:	ec06                	sd	ra,24(sp)
 648:	e822                	sd	s0,16(sp)
 64a:	1000                	addi	s0,sp,32
 64c:	e010                	sd	a2,0(s0)
 64e:	e414                	sd	a3,8(s0)
 650:	e818                	sd	a4,16(s0)
 652:	ec1c                	sd	a5,24(s0)
 654:	03043023          	sd	a6,32(s0)
 658:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65c:	8622                	mv	a2,s0
 65e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 662:	00000097          	auipc	ra,0x0
 666:	e14080e7          	jalr	-492(ra) # 476 <vprintf>
}
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6161                	addi	sp,sp,80
 670:	8082                	ret

0000000000000672 <printf>:

void
printf(const char *fmt, ...)
{
 672:	711d                	addi	sp,sp,-96
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	e40c                	sd	a1,8(s0)
 67c:	e810                	sd	a2,16(s0)
 67e:	ec14                	sd	a3,24(s0)
 680:	f018                	sd	a4,32(s0)
 682:	f41c                	sd	a5,40(s0)
 684:	03043823          	sd	a6,48(s0)
 688:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 68c:	00840613          	addi	a2,s0,8
 690:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 694:	85aa                	mv	a1,a0
 696:	4505                	li	a0,1
 698:	00000097          	auipc	ra,0x0
 69c:	dde080e7          	jalr	-546(ra) # 476 <vprintf>
}
 6a0:	60e2                	ld	ra,24(sp)
 6a2:	6442                	ld	s0,16(sp)
 6a4:	6125                	addi	sp,sp,96
 6a6:	8082                	ret

00000000000006a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a8:	1141                	addi	sp,sp,-16
 6aa:	e406                	sd	ra,8(sp)
 6ac:	e022                	sd	s0,0(sp)
 6ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b4:	00001797          	auipc	a5,0x1
 6b8:	94c7b783          	ld	a5,-1716(a5) # 1000 <freep>
 6bc:	a039                	j	6ca <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6be:	6398                	ld	a4,0(a5)
 6c0:	00e7e463          	bltu	a5,a4,6c8 <free+0x20>
 6c4:	00e6ea63          	bltu	a3,a4,6d8 <free+0x30>
{
 6c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ca:	fed7fae3          	bgeu	a5,a3,6be <free+0x16>
 6ce:	6398                	ld	a4,0(a5)
 6d0:	00e6e463          	bltu	a3,a4,6d8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d4:	fee7eae3          	bltu	a5,a4,6c8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d8:	ff852583          	lw	a1,-8(a0)
 6dc:	6390                	ld	a2,0(a5)
 6de:	02059813          	slli	a6,a1,0x20
 6e2:	01c85713          	srli	a4,a6,0x1c
 6e6:	9736                	add	a4,a4,a3
 6e8:	02e60563          	beq	a2,a4,712 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6ec:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6f0:	4790                	lw	a2,8(a5)
 6f2:	02061593          	slli	a1,a2,0x20
 6f6:	01c5d713          	srli	a4,a1,0x1c
 6fa:	973e                	add	a4,a4,a5
 6fc:	02e68263          	beq	a3,a4,720 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 700:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 702:	00001717          	auipc	a4,0x1
 706:	8ef73f23          	sd	a5,-1794(a4) # 1000 <freep>
}
 70a:	60a2                	ld	ra,8(sp)
 70c:	6402                	ld	s0,0(sp)
 70e:	0141                	addi	sp,sp,16
 710:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 712:	4618                	lw	a4,8(a2)
 714:	9f2d                	addw	a4,a4,a1
 716:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71a:	6398                	ld	a4,0(a5)
 71c:	6310                	ld	a2,0(a4)
 71e:	b7f9                	j	6ec <free+0x44>
    p->s.size += bp->s.size;
 720:	ff852703          	lw	a4,-8(a0)
 724:	9f31                	addw	a4,a4,a2
 726:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 728:	ff053683          	ld	a3,-16(a0)
 72c:	bfd1                	j	700 <free+0x58>

000000000000072e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 72e:	7139                	addi	sp,sp,-64
 730:	fc06                	sd	ra,56(sp)
 732:	f822                	sd	s0,48(sp)
 734:	f04a                	sd	s2,32(sp)
 736:	ec4e                	sd	s3,24(sp)
 738:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73a:	02051993          	slli	s3,a0,0x20
 73e:	0209d993          	srli	s3,s3,0x20
 742:	09bd                	addi	s3,s3,15
 744:	0049d993          	srli	s3,s3,0x4
 748:	2985                	addiw	s3,s3,1
 74a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 74c:	00001517          	auipc	a0,0x1
 750:	8b453503          	ld	a0,-1868(a0) # 1000 <freep>
 754:	c905                	beqz	a0,784 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 756:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 758:	4798                	lw	a4,8(a5)
 75a:	09377a63          	bgeu	a4,s3,7ee <malloc+0xc0>
 75e:	f426                	sd	s1,40(sp)
 760:	e852                	sd	s4,16(sp)
 762:	e456                	sd	s5,8(sp)
 764:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 766:	8a4e                	mv	s4,s3
 768:	6705                	lui	a4,0x1
 76a:	00e9f363          	bgeu	s3,a4,770 <malloc+0x42>
 76e:	6a05                	lui	s4,0x1
 770:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 774:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 778:	00001497          	auipc	s1,0x1
 77c:	88848493          	addi	s1,s1,-1912 # 1000 <freep>
  if(p == (char*)-1)
 780:	5afd                	li	s5,-1
 782:	a089                	j	7c4 <malloc+0x96>
 784:	f426                	sd	s1,40(sp)
 786:	e852                	sd	s4,16(sp)
 788:	e456                	sd	s5,8(sp)
 78a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 78c:	00001797          	auipc	a5,0x1
 790:	88478793          	addi	a5,a5,-1916 # 1010 <base>
 794:	00001717          	auipc	a4,0x1
 798:	86f73623          	sd	a5,-1940(a4) # 1000 <freep>
 79c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 79e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a2:	b7d1                	j	766 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7a4:	6398                	ld	a4,0(a5)
 7a6:	e118                	sd	a4,0(a0)
 7a8:	a8b9                	j	806 <malloc+0xd8>
  hp->s.size = nu;
 7aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ae:	0541                	addi	a0,a0,16
 7b0:	00000097          	auipc	ra,0x0
 7b4:	ef8080e7          	jalr	-264(ra) # 6a8 <free>
  return freep;
 7b8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7ba:	c135                	beqz	a0,81e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7be:	4798                	lw	a4,8(a5)
 7c0:	03277363          	bgeu	a4,s2,7e6 <malloc+0xb8>
    if(p == freep)
 7c4:	6098                	ld	a4,0(s1)
 7c6:	853e                	mv	a0,a5
 7c8:	fef71ae3          	bne	a4,a5,7bc <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7cc:	8552                	mv	a0,s4
 7ce:	00000097          	auipc	ra,0x0
 7d2:	ba6080e7          	jalr	-1114(ra) # 374 <sbrk>
  if(p == (char*)-1)
 7d6:	fd551ae3          	bne	a0,s5,7aa <malloc+0x7c>
        return 0;
 7da:	4501                	li	a0,0
 7dc:	74a2                	ld	s1,40(sp)
 7de:	6a42                	ld	s4,16(sp)
 7e0:	6aa2                	ld	s5,8(sp)
 7e2:	6b02                	ld	s6,0(sp)
 7e4:	a03d                	j	812 <malloc+0xe4>
 7e6:	74a2                	ld	s1,40(sp)
 7e8:	6a42                	ld	s4,16(sp)
 7ea:	6aa2                	ld	s5,8(sp)
 7ec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ee:	fae90be3          	beq	s2,a4,7a4 <malloc+0x76>
        p->s.size -= nunits;
 7f2:	4137073b          	subw	a4,a4,s3
 7f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f8:	02071693          	slli	a3,a4,0x20
 7fc:	01c6d713          	srli	a4,a3,0x1c
 800:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 802:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 806:	00000717          	auipc	a4,0x0
 80a:	7ea73d23          	sd	a0,2042(a4) # 1000 <freep>
      return (void*)(p + 1);
 80e:	01078513          	addi	a0,a5,16
  }
}
 812:	70e2                	ld	ra,56(sp)
 814:	7442                	ld	s0,48(sp)
 816:	7902                	ld	s2,32(sp)
 818:	69e2                	ld	s3,24(sp)
 81a:	6121                	addi	sp,sp,64
 81c:	8082                	ret
 81e:	74a2                	ld	s1,40(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
 826:	b7f5                	j	812 <malloc+0xe4>
