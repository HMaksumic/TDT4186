
user/_schedls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    schedls();
   8:	00000097          	auipc	ra,0x0
   c:	362080e7          	jalr	866(ra) # 36a <schedls>
    exit(0);
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	2b0080e7          	jalr	688(ra) # 2c2 <exit>

000000000000001a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
  extern int main();
  main();
  22:	00000097          	auipc	ra,0x0
  26:	fde080e7          	jalr	-34(ra) # 0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	00000097          	auipc	ra,0x0
  30:	296080e7          	jalr	662(ra) # 2c2 <exit>

0000000000000034 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  34:	1141                	addi	sp,sp,-16
  36:	e406                	sd	ra,8(sp)
  38:	e022                	sd	s0,0(sp)
  3a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3c:	87aa                	mv	a5,a0
  3e:	0585                	addi	a1,a1,1
  40:	0785                	addi	a5,a5,1
  42:	fff5c703          	lbu	a4,-1(a1)
  46:	fee78fa3          	sb	a4,-1(a5)
  4a:	fb75                	bnez	a4,3e <strcpy+0xa>
    ;
  return os;
}
  4c:	60a2                	ld	ra,8(sp)
  4e:	6402                	ld	s0,0(sp)
  50:	0141                	addi	sp,sp,16
  52:	8082                	ret

0000000000000054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	cb91                	beqz	a5,74 <strcmp+0x20>
  62:	0005c703          	lbu	a4,0(a1)
  66:	00f71763          	bne	a4,a5,74 <strcmp+0x20>
    p++, q++;
  6a:	0505                	addi	a0,a0,1
  6c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6e:	00054783          	lbu	a5,0(a0)
  72:	fbe5                	bnez	a5,62 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  74:	0005c503          	lbu	a0,0(a1)
}
  78:	40a7853b          	subw	a0,a5,a0
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strlen>:

uint
strlen(const char *s)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cf91                	beqz	a5,ac <strlen+0x28>
  92:	00150793          	addi	a5,a0,1
  96:	86be                	mv	a3,a5
  98:	0785                	addi	a5,a5,1
  9a:	fff7c703          	lbu	a4,-1(a5)
  9e:	ff65                	bnez	a4,96 <strlen+0x12>
  a0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret
  for(n = 0; s[n]; n++)
  ac:	4501                	li	a0,0
  ae:	bfdd                	j	a4 <strlen+0x20>

00000000000000b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b8:	ca19                	beqz	a2,ce <memset+0x1e>
  ba:	87aa                	mv	a5,a0
  bc:	1602                	slli	a2,a2,0x20
  be:	9201                	srli	a2,a2,0x20
  c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c8:	0785                	addi	a5,a5,1
  ca:	fee79de3          	bne	a5,a4,c4 <memset+0x14>
  }
  return dst;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strchr>:

char*
strchr(const char *s, char c)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cf81                	beqz	a5,fa <strchr+0x24>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1c>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xe>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  return 0;
  fa:	4501                	li	a0,0
  fc:	bfdd                	j	f2 <strchr+0x1c>

00000000000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	711d                	addi	sp,sp,-96
 100:	ec86                	sd	ra,88(sp)
 102:	e8a2                	sd	s0,80(sp)
 104:	e4a6                	sd	s1,72(sp)
 106:	e0ca                	sd	s2,64(sp)
 108:	fc4e                	sd	s3,56(sp)
 10a:	f852                	sd	s4,48(sp)
 10c:	f456                	sd	s5,40(sp)
 10e:	f05a                	sd	s6,32(sp)
 110:	ec5e                	sd	s7,24(sp)
 112:	e862                	sd	s8,16(sp)
 114:	1080                	addi	s0,sp,96
 116:	8baa                	mv	s7,a0
 118:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11a:	892a                	mv	s2,a0
 11c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 11e:	faf40b13          	addi	s6,s0,-81
 122:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 124:	8c26                	mv	s8,s1
 126:	0014899b          	addiw	s3,s1,1
 12a:	84ce                	mv	s1,s3
 12c:	0349d663          	bge	s3,s4,158 <gets+0x5a>
    cc = read(0, &c, 1);
 130:	8656                	mv	a2,s5
 132:	85da                	mv	a1,s6
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	1a4080e7          	jalr	420(ra) # 2da <read>
    if(cc < 1)
 13e:	00a05d63          	blez	a0,158 <gets+0x5a>
      break;
    buf[i++] = c;
 142:	faf44783          	lbu	a5,-81(s0)
 146:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14a:	0905                	addi	s2,s2,1
 14c:	ff678713          	addi	a4,a5,-10
 150:	c319                	beqz	a4,156 <gets+0x58>
 152:	17cd                	addi	a5,a5,-13
 154:	fbe1                	bnez	a5,124 <gets+0x26>
    buf[i++] = c;
 156:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 158:	9c5e                	add	s8,s8,s7
 15a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 15e:	855e                	mv	a0,s7
 160:	60e6                	ld	ra,88(sp)
 162:	6446                	ld	s0,80(sp)
 164:	64a6                	ld	s1,72(sp)
 166:	6906                	ld	s2,64(sp)
 168:	79e2                	ld	s3,56(sp)
 16a:	7a42                	ld	s4,48(sp)
 16c:	7aa2                	ld	s5,40(sp)
 16e:	7b02                	ld	s6,32(sp)
 170:	6be2                	ld	s7,24(sp)
 172:	6c42                	ld	s8,16(sp)
 174:	6125                	addi	sp,sp,96
 176:	8082                	ret

0000000000000178 <stat>:

int
stat(const char *n, struct stat *st)
{
 178:	1101                	addi	sp,sp,-32
 17a:	ec06                	sd	ra,24(sp)
 17c:	e822                	sd	s0,16(sp)
 17e:	e04a                	sd	s2,0(sp)
 180:	1000                	addi	s0,sp,32
 182:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 184:	4581                	li	a1,0
 186:	00000097          	auipc	ra,0x0
 18a:	17c080e7          	jalr	380(ra) # 302 <open>
  if(fd < 0)
 18e:	02054663          	bltz	a0,1ba <stat+0x42>
 192:	e426                	sd	s1,8(sp)
 194:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 196:	85ca                	mv	a1,s2
 198:	00000097          	auipc	ra,0x0
 19c:	182080e7          	jalr	386(ra) # 31a <fstat>
 1a0:	892a                	mv	s2,a0
  close(fd);
 1a2:	8526                	mv	a0,s1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	146080e7          	jalr	326(ra) # 2ea <close>
  return r;
 1ac:	64a2                	ld	s1,8(sp)
}
 1ae:	854a                	mv	a0,s2
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	6902                	ld	s2,0(sp)
 1b6:	6105                	addi	sp,sp,32
 1b8:	8082                	ret
    return -1;
 1ba:	57fd                	li	a5,-1
 1bc:	893e                	mv	s2,a5
 1be:	bfc5                	j	1ae <stat+0x36>

00000000000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e406                	sd	ra,8(sp)
 1c4:	e022                	sd	s0,0(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c8:	00054683          	lbu	a3,0(a0)
 1cc:	fd06879b          	addiw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	4625                	li	a2,9
 1d6:	02f66963          	bltu	a2,a5,208 <atoi+0x48>
 1da:	872a                	mv	a4,a0
  n = 0;
 1dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1de:	0705                	addi	a4,a4,1
 1e0:	0025179b          	slliw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	slliw	a5,a5,0x1
 1ea:	9fb5                	addw	a5,a5,a3
 1ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	00074683          	lbu	a3,0(a4)
 1f4:	fd06879b          	addiw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	fef671e3          	bgeu	a2,a5,1de <atoi+0x1e>
  return n;
}
 200:	60a2                	ld	ra,8(sp)
 202:	6402                	ld	s0,0(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
  n = 0;
 208:	4501                	li	a0,0
 20a:	bfdd                	j	200 <atoi+0x40>

000000000000020c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 214:	02b57563          	bgeu	a0,a1,23e <memmove+0x32>
    while(n-- > 0)
 218:	00c05f63          	blez	a2,236 <memmove+0x2a>
 21c:	1602                	slli	a2,a2,0x20
 21e:	9201                	srli	a2,a2,0x20
 220:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 224:	872a                	mv	a4,a0
      *dst++ = *src++;
 226:	0585                	addi	a1,a1,1
 228:	0705                	addi	a4,a4,1
 22a:	fff5c683          	lbu	a3,-1(a1)
 22e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 232:	fee79ae3          	bne	a5,a4,226 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 236:	60a2                	ld	ra,8(sp)
 238:	6402                	ld	s0,0(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    while(n-- > 0)
 23e:	fec05ce3          	blez	a2,236 <memmove+0x2a>
    dst += n;
 242:	00c50733          	add	a4,a0,a2
    src += n;
 246:	95b2                	add	a1,a1,a2
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fef71ae3          	bne	a4,a5,256 <memmove+0x4a>
 266:	bfc1                	j	236 <memmove+0x2a>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 270:	c61d                	beqz	a2,29e <memcmp+0x36>
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 27a:	00054783          	lbu	a5,0(a0)
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00e79863          	bne	a5,a4,292 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 286:	0505                	addi	a0,a0,1
    p2++;
 288:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28a:	fed518e3          	bne	a0,a3,27a <memcmp+0x12>
  }
  return 0;
 28e:	4501                	li	a0,0
 290:	a019                	j	296 <memcmp+0x2e>
      return *p1 - *p2;
 292:	40e7853b          	subw	a0,a5,a4
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <memcmp+0x2e>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	00000097          	auipc	ra,0x0
 2ae:	f62080e7          	jalr	-158(ra) # 20c <memmove>
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ba:	4885                	li	a7,1
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c2:	4889                	li	a7,2
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ca:	488d                	li	a7,3
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d2:	4891                	li	a7,4
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <read>:
.global read
read:
 li a7, SYS_read
 2da:	4895                	li	a7,5
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <write>:
.global write
write:
 li a7, SYS_write
 2e2:	48c1                	li	a7,16
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <close>:
.global close
close:
 li a7, SYS_close
 2ea:	48d5                	li	a7,21
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f2:	4899                	li	a7,6
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fa:	489d                	li	a7,7
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <open>:
.global open
open:
 li a7, SYS_open
 302:	48bd                	li	a7,15
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30a:	48c5                	li	a7,17
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 312:	48c9                	li	a7,18
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31a:	48a1                	li	a7,8
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <link>:
.global link
link:
 li a7, SYS_link
 322:	48cd                	li	a7,19
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32a:	48d1                	li	a7,20
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 332:	48a5                	li	a7,9
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <dup>:
.global dup
dup:
 li a7, SYS_dup
 33a:	48a9                	li	a7,10
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 342:	48ad                	li	a7,11
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 34a:	48b1                	li	a7,12
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 352:	48b5                	li	a7,13
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35a:	48b9                	li	a7,14
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <ps>:
.global ps
ps:
 li a7, SYS_ps
 362:	48d9                	li	a7,22
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 36a:	48dd                	li	a7,23
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 372:	48e1                	li	a7,24
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <yield>:
.global yield
yield:
 li a7, SYS_yield
 37a:	48e5                	li	a7,25
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 382:	1101                	addi	sp,sp,-32
 384:	ec06                	sd	ra,24(sp)
 386:	e822                	sd	s0,16(sp)
 388:	1000                	addi	s0,sp,32
 38a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38e:	4605                	li	a2,1
 390:	fef40593          	addi	a1,s0,-17
 394:	00000097          	auipc	ra,0x0
 398:	f4e080e7          	jalr	-178(ra) # 2e2 <write>
}
 39c:	60e2                	ld	ra,24(sp)
 39e:	6442                	ld	s0,16(sp)
 3a0:	6105                	addi	sp,sp,32
 3a2:	8082                	ret

00000000000003a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	7139                	addi	sp,sp,-64
 3a6:	fc06                	sd	ra,56(sp)
 3a8:	f822                	sd	s0,48(sp)
 3aa:	f04a                	sd	s2,32(sp)
 3ac:	ec4e                	sd	s3,24(sp)
 3ae:	0080                	addi	s0,sp,64
 3b0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b2:	cad9                	beqz	a3,448 <printint+0xa4>
 3b4:	01f5d79b          	srliw	a5,a1,0x1f
 3b8:	cbc1                	beqz	a5,448 <printint+0xa4>
    neg = 1;
    x = -xx;
 3ba:	40b005bb          	negw	a1,a1
    neg = 1;
 3be:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c0:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3c4:	86ce                	mv	a3,s3
  i = 0;
 3c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c8:	00000817          	auipc	a6,0x0
 3cc:	49880813          	addi	a6,a6,1176 # 860 <digits>
 3d0:	88ba                	mv	a7,a4
 3d2:	0017051b          	addiw	a0,a4,1
 3d6:	872a                	mv	a4,a0
 3d8:	02c5f7bb          	remuw	a5,a1,a2
 3dc:	1782                	slli	a5,a5,0x20
 3de:	9381                	srli	a5,a5,0x20
 3e0:	97c2                	add	a5,a5,a6
 3e2:	0007c783          	lbu	a5,0(a5)
 3e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ea:	87ae                	mv	a5,a1
 3ec:	02c5d5bb          	divuw	a1,a1,a2
 3f0:	0685                	addi	a3,a3,1
 3f2:	fcc7ffe3          	bgeu	a5,a2,3d0 <printint+0x2c>
  if(neg)
 3f6:	00030c63          	beqz	t1,40e <printint+0x6a>
    buf[i++] = '-';
 3fa:	fd050793          	addi	a5,a0,-48
 3fe:	00878533          	add	a0,a5,s0
 402:	02d00793          	li	a5,45
 406:	fef50823          	sb	a5,-16(a0)
 40a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 40e:	02e05763          	blez	a4,43c <printint+0x98>
 412:	f426                	sd	s1,40(sp)
 414:	377d                	addiw	a4,a4,-1
 416:	00e984b3          	add	s1,s3,a4
 41a:	19fd                	addi	s3,s3,-1
 41c:	99ba                	add	s3,s3,a4
 41e:	1702                	slli	a4,a4,0x20
 420:	9301                	srli	a4,a4,0x20
 422:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 426:	0004c583          	lbu	a1,0(s1)
 42a:	854a                	mv	a0,s2
 42c:	00000097          	auipc	ra,0x0
 430:	f56080e7          	jalr	-170(ra) # 382 <putc>
  while(--i >= 0)
 434:	14fd                	addi	s1,s1,-1
 436:	ff3498e3          	bne	s1,s3,426 <printint+0x82>
 43a:	74a2                	ld	s1,40(sp)
}
 43c:	70e2                	ld	ra,56(sp)
 43e:	7442                	ld	s0,48(sp)
 440:	7902                	ld	s2,32(sp)
 442:	69e2                	ld	s3,24(sp)
 444:	6121                	addi	sp,sp,64
 446:	8082                	ret
  neg = 0;
 448:	4301                	li	t1,0
 44a:	bf9d                	j	3c0 <printint+0x1c>

000000000000044c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44c:	715d                	addi	sp,sp,-80
 44e:	e486                	sd	ra,72(sp)
 450:	e0a2                	sd	s0,64(sp)
 452:	f84a                	sd	s2,48(sp)
 454:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 456:	0005c903          	lbu	s2,0(a1)
 45a:	1a090b63          	beqz	s2,610 <vprintf+0x1c4>
 45e:	fc26                	sd	s1,56(sp)
 460:	f44e                	sd	s3,40(sp)
 462:	f052                	sd	s4,32(sp)
 464:	ec56                	sd	s5,24(sp)
 466:	e85a                	sd	s6,16(sp)
 468:	e45e                	sd	s7,8(sp)
 46a:	8aaa                	mv	s5,a0
 46c:	8bb2                	mv	s7,a2
 46e:	00158493          	addi	s1,a1,1
  state = 0;
 472:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 474:	02500a13          	li	s4,37
 478:	4b55                	li	s6,21
 47a:	a839                	j	498 <vprintf+0x4c>
        putc(fd, c);
 47c:	85ca                	mv	a1,s2
 47e:	8556                	mv	a0,s5
 480:	00000097          	auipc	ra,0x0
 484:	f02080e7          	jalr	-254(ra) # 382 <putc>
 488:	a019                	j	48e <vprintf+0x42>
    } else if(state == '%'){
 48a:	01498d63          	beq	s3,s4,4a4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 48e:	0485                	addi	s1,s1,1
 490:	fff4c903          	lbu	s2,-1(s1)
 494:	16090863          	beqz	s2,604 <vprintf+0x1b8>
    if(state == 0){
 498:	fe0999e3          	bnez	s3,48a <vprintf+0x3e>
      if(c == '%'){
 49c:	ff4910e3          	bne	s2,s4,47c <vprintf+0x30>
        state = '%';
 4a0:	89d2                	mv	s3,s4
 4a2:	b7f5                	j	48e <vprintf+0x42>
      if(c == 'd'){
 4a4:	13490563          	beq	s2,s4,5ce <vprintf+0x182>
 4a8:	f9d9079b          	addiw	a5,s2,-99
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	12fb6863          	bltu	s6,a5,5e0 <vprintf+0x194>
 4b4:	f9d9079b          	addiw	a5,s2,-99
 4b8:	0ff7f713          	zext.b	a4,a5
 4bc:	12eb6263          	bltu	s6,a4,5e0 <vprintf+0x194>
 4c0:	00271793          	slli	a5,a4,0x2
 4c4:	00000717          	auipc	a4,0x0
 4c8:	34470713          	addi	a4,a4,836 # 808 <malloc+0x104>
 4cc:	97ba                	add	a5,a5,a4
 4ce:	439c                	lw	a5,0(a5)
 4d0:	97ba                	add	a5,a5,a4
 4d2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4d4:	008b8913          	addi	s2,s7,8
 4d8:	4685                	li	a3,1
 4da:	4629                	li	a2,10
 4dc:	000ba583          	lw	a1,0(s7)
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	ec2080e7          	jalr	-318(ra) # 3a4 <printint>
 4ea:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b745                	j	48e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f0:	008b8913          	addi	s2,s7,8
 4f4:	4681                	li	a3,0
 4f6:	4629                	li	a2,10
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ea6080e7          	jalr	-346(ra) # 3a4 <printint>
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	b751                	j	48e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 50c:	008b8913          	addi	s2,s7,8
 510:	4681                	li	a3,0
 512:	4641                	li	a2,16
 514:	000ba583          	lw	a1,0(s7)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e8a080e7          	jalr	-374(ra) # 3a4 <printint>
 522:	8bca                	mv	s7,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	b7a5                	j	48e <vprintf+0x42>
 528:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 52a:	008b8793          	addi	a5,s7,8
 52e:	8c3e                	mv	s8,a5
 530:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 534:	03000593          	li	a1,48
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e48080e7          	jalr	-440(ra) # 382 <putc>
  putc(fd, 'x');
 542:	07800593          	li	a1,120
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e3a080e7          	jalr	-454(ra) # 382 <putc>
 550:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 552:	00000b97          	auipc	s7,0x0
 556:	30eb8b93          	addi	s7,s7,782 # 860 <digits>
 55a:	03c9d793          	srli	a5,s3,0x3c
 55e:	97de                	add	a5,a5,s7
 560:	0007c583          	lbu	a1,0(a5)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e1c080e7          	jalr	-484(ra) # 382 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56e:	0992                	slli	s3,s3,0x4
 570:	397d                	addiw	s2,s2,-1
 572:	fe0914e3          	bnez	s2,55a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 576:	8be2                	mv	s7,s8
      state = 0;
 578:	4981                	li	s3,0
 57a:	6c02                	ld	s8,0(sp)
 57c:	bf09                	j	48e <vprintf+0x42>
        s = va_arg(ap, char*);
 57e:	008b8993          	addi	s3,s7,8
 582:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 586:	02090163          	beqz	s2,5a8 <vprintf+0x15c>
        while(*s != 0){
 58a:	00094583          	lbu	a1,0(s2)
 58e:	c9a5                	beqz	a1,5fe <vprintf+0x1b2>
          putc(fd, *s);
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	df0080e7          	jalr	-528(ra) # 382 <putc>
          s++;
 59a:	0905                	addi	s2,s2,1
        while(*s != 0){
 59c:	00094583          	lbu	a1,0(s2)
 5a0:	f9e5                	bnez	a1,590 <vprintf+0x144>
        s = va_arg(ap, char*);
 5a2:	8bce                	mv	s7,s3
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b5e5                	j	48e <vprintf+0x42>
          s = "(null)";
 5a8:	00000917          	auipc	s2,0x0
 5ac:	25890913          	addi	s2,s2,600 # 800 <malloc+0xfc>
        while(*s != 0){
 5b0:	02800593          	li	a1,40
 5b4:	bff1                	j	590 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	000bc583          	lbu	a1,0(s7)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	dc2080e7          	jalr	-574(ra) # 382 <putc>
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b5c9                	j	48e <vprintf+0x42>
        putc(fd, c);
 5ce:	02500593          	li	a1,37
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	dae080e7          	jalr	-594(ra) # 382 <putc>
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bd45                	j	48e <vprintf+0x42>
        putc(fd, '%');
 5e0:	02500593          	li	a1,37
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	d9c080e7          	jalr	-612(ra) # 382 <putc>
        putc(fd, c);
 5ee:	85ca                	mv	a1,s2
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	d90080e7          	jalr	-624(ra) # 382 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bd49                	j	48e <vprintf+0x42>
        s = va_arg(ap, char*);
 5fe:	8bce                	mv	s7,s3
      state = 0;
 600:	4981                	li	s3,0
 602:	b571                	j	48e <vprintf+0x42>
 604:	74e2                	ld	s1,56(sp)
 606:	79a2                	ld	s3,40(sp)
 608:	7a02                	ld	s4,32(sp)
 60a:	6ae2                	ld	s5,24(sp)
 60c:	6b42                	ld	s6,16(sp)
 60e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 610:	60a6                	ld	ra,72(sp)
 612:	6406                	ld	s0,64(sp)
 614:	7942                	ld	s2,48(sp)
 616:	6161                	addi	sp,sp,80
 618:	8082                	ret

000000000000061a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61a:	715d                	addi	sp,sp,-80
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	addi	s0,sp,32
 622:	e010                	sd	a2,0(s0)
 624:	e414                	sd	a3,8(s0)
 626:	e818                	sd	a4,16(s0)
 628:	ec1c                	sd	a5,24(s0)
 62a:	03043023          	sd	a6,32(s0)
 62e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 632:	8622                	mv	a2,s0
 634:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 638:	00000097          	auipc	ra,0x0
 63c:	e14080e7          	jalr	-492(ra) # 44c <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6161                	addi	sp,sp,80
 646:	8082                	ret

0000000000000648 <printf>:

void
printf(const char *fmt, ...)
{
 648:	711d                	addi	sp,sp,-96
 64a:	ec06                	sd	ra,24(sp)
 64c:	e822                	sd	s0,16(sp)
 64e:	1000                	addi	s0,sp,32
 650:	e40c                	sd	a1,8(s0)
 652:	e810                	sd	a2,16(s0)
 654:	ec14                	sd	a3,24(s0)
 656:	f018                	sd	a4,32(s0)
 658:	f41c                	sd	a5,40(s0)
 65a:	03043823          	sd	a6,48(s0)
 65e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 662:	00840613          	addi	a2,s0,8
 666:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66a:	85aa                	mv	a1,a0
 66c:	4505                	li	a0,1
 66e:	00000097          	auipc	ra,0x0
 672:	dde080e7          	jalr	-546(ra) # 44c <vprintf>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6125                	addi	sp,sp,96
 67c:	8082                	ret

000000000000067e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67e:	1141                	addi	sp,sp,-16
 680:	e406                	sd	ra,8(sp)
 682:	e022                	sd	s0,0(sp)
 684:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 686:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	00001797          	auipc	a5,0x1
 68e:	9767b783          	ld	a5,-1674(a5) # 1000 <freep>
 692:	a039                	j	6a0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	6398                	ld	a4,0(a5)
 696:	00e7e463          	bltu	a5,a4,69e <free+0x20>
 69a:	00e6ea63          	bltu	a3,a4,6ae <free+0x30>
{
 69e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a0:	fed7fae3          	bgeu	a5,a3,694 <free+0x16>
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e6e463          	bltu	a3,a4,6ae <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	fee7eae3          	bltu	a5,a4,69e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ae:	ff852583          	lw	a1,-8(a0)
 6b2:	6390                	ld	a2,0(a5)
 6b4:	02059813          	slli	a6,a1,0x20
 6b8:	01c85713          	srli	a4,a6,0x1c
 6bc:	9736                	add	a4,a4,a3
 6be:	02e60563          	beq	a2,a4,6e8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c6:	4790                	lw	a2,8(a5)
 6c8:	02061593          	slli	a1,a2,0x20
 6cc:	01c5d713          	srli	a4,a1,0x1c
 6d0:	973e                	add	a4,a4,a5
 6d2:	02e68263          	beq	a3,a4,6f6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d8:	00001717          	auipc	a4,0x1
 6dc:	92f73423          	sd	a5,-1752(a4) # 1000 <freep>
}
 6e0:	60a2                	ld	ra,8(sp)
 6e2:	6402                	ld	s0,0(sp)
 6e4:	0141                	addi	sp,sp,16
 6e6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 6e8:	4618                	lw	a4,8(a2)
 6ea:	9f2d                	addw	a4,a4,a1
 6ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	6398                	ld	a4,0(a5)
 6f2:	6310                	ld	a2,0(a4)
 6f4:	b7f9                	j	6c2 <free+0x44>
    p->s.size += bp->s.size;
 6f6:	ff852703          	lw	a4,-8(a0)
 6fa:	9f31                	addw	a4,a4,a2
 6fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6fe:	ff053683          	ld	a3,-16(a0)
 702:	bfd1                	j	6d6 <free+0x58>

0000000000000704 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 704:	7139                	addi	sp,sp,-64
 706:	fc06                	sd	ra,56(sp)
 708:	f822                	sd	s0,48(sp)
 70a:	f04a                	sd	s2,32(sp)
 70c:	ec4e                	sd	s3,24(sp)
 70e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 710:	02051993          	slli	s3,a0,0x20
 714:	0209d993          	srli	s3,s3,0x20
 718:	09bd                	addi	s3,s3,15
 71a:	0049d993          	srli	s3,s3,0x4
 71e:	2985                	addiw	s3,s3,1
 720:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 722:	00001517          	auipc	a0,0x1
 726:	8de53503          	ld	a0,-1826(a0) # 1000 <freep>
 72a:	c905                	beqz	a0,75a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 72e:	4798                	lw	a4,8(a5)
 730:	09377a63          	bgeu	a4,s3,7c4 <malloc+0xc0>
 734:	f426                	sd	s1,40(sp)
 736:	e852                	sd	s4,16(sp)
 738:	e456                	sd	s5,8(sp)
 73a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 73c:	8a4e                	mv	s4,s3
 73e:	6705                	lui	a4,0x1
 740:	00e9f363          	bgeu	s3,a4,746 <malloc+0x42>
 744:	6a05                	lui	s4,0x1
 746:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 74a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74e:	00001497          	auipc	s1,0x1
 752:	8b248493          	addi	s1,s1,-1870 # 1000 <freep>
  if(p == (char*)-1)
 756:	5afd                	li	s5,-1
 758:	a089                	j	79a <malloc+0x96>
 75a:	f426                	sd	s1,40(sp)
 75c:	e852                	sd	s4,16(sp)
 75e:	e456                	sd	s5,8(sp)
 760:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 762:	00001797          	auipc	a5,0x1
 766:	8ae78793          	addi	a5,a5,-1874 # 1010 <base>
 76a:	00001717          	auipc	a4,0x1
 76e:	88f73b23          	sd	a5,-1898(a4) # 1000 <freep>
 772:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 774:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 778:	b7d1                	j	73c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 77a:	6398                	ld	a4,0(a5)
 77c:	e118                	sd	a4,0(a0)
 77e:	a8b9                	j	7dc <malloc+0xd8>
  hp->s.size = nu;
 780:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 784:	0541                	addi	a0,a0,16
 786:	00000097          	auipc	ra,0x0
 78a:	ef8080e7          	jalr	-264(ra) # 67e <free>
  return freep;
 78e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 790:	c135                	beqz	a0,7f4 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 794:	4798                	lw	a4,8(a5)
 796:	03277363          	bgeu	a4,s2,7bc <malloc+0xb8>
    if(p == freep)
 79a:	6098                	ld	a4,0(s1)
 79c:	853e                	mv	a0,a5
 79e:	fef71ae3          	bne	a4,a5,792 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7a2:	8552                	mv	a0,s4
 7a4:	00000097          	auipc	ra,0x0
 7a8:	ba6080e7          	jalr	-1114(ra) # 34a <sbrk>
  if(p == (char*)-1)
 7ac:	fd551ae3          	bne	a0,s5,780 <malloc+0x7c>
        return 0;
 7b0:	4501                	li	a0,0
 7b2:	74a2                	ld	s1,40(sp)
 7b4:	6a42                	ld	s4,16(sp)
 7b6:	6aa2                	ld	s5,8(sp)
 7b8:	6b02                	ld	s6,0(sp)
 7ba:	a03d                	j	7e8 <malloc+0xe4>
 7bc:	74a2                	ld	s1,40(sp)
 7be:	6a42                	ld	s4,16(sp)
 7c0:	6aa2                	ld	s5,8(sp)
 7c2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7c4:	fae90be3          	beq	s2,a4,77a <malloc+0x76>
        p->s.size -= nunits;
 7c8:	4137073b          	subw	a4,a4,s3
 7cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ce:	02071693          	slli	a3,a4,0x20
 7d2:	01c6d713          	srli	a4,a3,0x1c
 7d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7dc:	00001717          	auipc	a4,0x1
 7e0:	82a73223          	sd	a0,-2012(a4) # 1000 <freep>
      return (void*)(p + 1);
 7e4:	01078513          	addi	a0,a5,16
  }
}
 7e8:	70e2                	ld	ra,56(sp)
 7ea:	7442                	ld	s0,48(sp)
 7ec:	7902                	ld	s2,32(sp)
 7ee:	69e2                	ld	s3,24(sp)
 7f0:	6121                	addi	sp,sp,64
 7f2:	8082                	ret
 7f4:	74a2                	ld	s1,40(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	b7f5                	j	7e8 <malloc+0xe4>
