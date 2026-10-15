
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

000000000000037a <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 37a:	48e9                	li	a7,26
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 382:	48e5                	li	a7,25
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38a:	1101                	addi	sp,sp,-32
 38c:	ec06                	sd	ra,24(sp)
 38e:	e822                	sd	s0,16(sp)
 390:	1000                	addi	s0,sp,32
 392:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 396:	4605                	li	a2,1
 398:	fef40593          	addi	a1,s0,-17
 39c:	00000097          	auipc	ra,0x0
 3a0:	f46080e7          	jalr	-186(ra) # 2e2 <write>
}
 3a4:	60e2                	ld	ra,24(sp)
 3a6:	6442                	ld	s0,16(sp)
 3a8:	6105                	addi	sp,sp,32
 3aa:	8082                	ret

00000000000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	7139                	addi	sp,sp,-64
 3ae:	fc06                	sd	ra,56(sp)
 3b0:	f822                	sd	s0,48(sp)
 3b2:	f04a                	sd	s2,32(sp)
 3b4:	ec4e                	sd	s3,24(sp)
 3b6:	0080                	addi	s0,sp,64
 3b8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ba:	cad9                	beqz	a3,450 <printint+0xa4>
 3bc:	01f5d79b          	srliw	a5,a1,0x1f
 3c0:	cbc1                	beqz	a5,450 <printint+0xa4>
    neg = 1;
    x = -xx;
 3c2:	40b005bb          	negw	a1,a1
    neg = 1;
 3c6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c8:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3cc:	86ce                	mv	a3,s3
  i = 0;
 3ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d0:	00000817          	auipc	a6,0x0
 3d4:	4a080813          	addi	a6,a6,1184 # 870 <digits>
 3d8:	88ba                	mv	a7,a4
 3da:	0017051b          	addiw	a0,a4,1
 3de:	872a                	mv	a4,a0
 3e0:	02c5f7bb          	remuw	a5,a1,a2
 3e4:	1782                	slli	a5,a5,0x20
 3e6:	9381                	srli	a5,a5,0x20
 3e8:	97c2                	add	a5,a5,a6
 3ea:	0007c783          	lbu	a5,0(a5)
 3ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f2:	87ae                	mv	a5,a1
 3f4:	02c5d5bb          	divuw	a1,a1,a2
 3f8:	0685                	addi	a3,a3,1
 3fa:	fcc7ffe3          	bgeu	a5,a2,3d8 <printint+0x2c>
  if(neg)
 3fe:	00030c63          	beqz	t1,416 <printint+0x6a>
    buf[i++] = '-';
 402:	fd050793          	addi	a5,a0,-48
 406:	00878533          	add	a0,a5,s0
 40a:	02d00793          	li	a5,45
 40e:	fef50823          	sb	a5,-16(a0)
 412:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 416:	02e05763          	blez	a4,444 <printint+0x98>
 41a:	f426                	sd	s1,40(sp)
 41c:	377d                	addiw	a4,a4,-1
 41e:	00e984b3          	add	s1,s3,a4
 422:	19fd                	addi	s3,s3,-1
 424:	99ba                	add	s3,s3,a4
 426:	1702                	slli	a4,a4,0x20
 428:	9301                	srli	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42e:	0004c583          	lbu	a1,0(s1)
 432:	854a                	mv	a0,s2
 434:	00000097          	auipc	ra,0x0
 438:	f56080e7          	jalr	-170(ra) # 38a <putc>
  while(--i >= 0)
 43c:	14fd                	addi	s1,s1,-1
 43e:	ff3498e3          	bne	s1,s3,42e <printint+0x82>
 442:	74a2                	ld	s1,40(sp)
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	7902                	ld	s2,32(sp)
 44a:	69e2                	ld	s3,24(sp)
 44c:	6121                	addi	sp,sp,64
 44e:	8082                	ret
  neg = 0;
 450:	4301                	li	t1,0
 452:	bf9d                	j	3c8 <printint+0x1c>

0000000000000454 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 454:	715d                	addi	sp,sp,-80
 456:	e486                	sd	ra,72(sp)
 458:	e0a2                	sd	s0,64(sp)
 45a:	f84a                	sd	s2,48(sp)
 45c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45e:	0005c903          	lbu	s2,0(a1)
 462:	1a090b63          	beqz	s2,618 <vprintf+0x1c4>
 466:	fc26                	sd	s1,56(sp)
 468:	f44e                	sd	s3,40(sp)
 46a:	f052                	sd	s4,32(sp)
 46c:	ec56                	sd	s5,24(sp)
 46e:	e85a                	sd	s6,16(sp)
 470:	e45e                	sd	s7,8(sp)
 472:	8aaa                	mv	s5,a0
 474:	8bb2                	mv	s7,a2
 476:	00158493          	addi	s1,a1,1
  state = 0;
 47a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47c:	02500a13          	li	s4,37
 480:	4b55                	li	s6,21
 482:	a839                	j	4a0 <vprintf+0x4c>
        putc(fd, c);
 484:	85ca                	mv	a1,s2
 486:	8556                	mv	a0,s5
 488:	00000097          	auipc	ra,0x0
 48c:	f02080e7          	jalr	-254(ra) # 38a <putc>
 490:	a019                	j	496 <vprintf+0x42>
    } else if(state == '%'){
 492:	01498d63          	beq	s3,s4,4ac <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 496:	0485                	addi	s1,s1,1
 498:	fff4c903          	lbu	s2,-1(s1)
 49c:	16090863          	beqz	s2,60c <vprintf+0x1b8>
    if(state == 0){
 4a0:	fe0999e3          	bnez	s3,492 <vprintf+0x3e>
      if(c == '%'){
 4a4:	ff4910e3          	bne	s2,s4,484 <vprintf+0x30>
        state = '%';
 4a8:	89d2                	mv	s3,s4
 4aa:	b7f5                	j	496 <vprintf+0x42>
      if(c == 'd'){
 4ac:	13490563          	beq	s2,s4,5d6 <vprintf+0x182>
 4b0:	f9d9079b          	addiw	a5,s2,-99
 4b4:	0ff7f793          	zext.b	a5,a5
 4b8:	12fb6863          	bltu	s6,a5,5e8 <vprintf+0x194>
 4bc:	f9d9079b          	addiw	a5,s2,-99
 4c0:	0ff7f713          	zext.b	a4,a5
 4c4:	12eb6263          	bltu	s6,a4,5e8 <vprintf+0x194>
 4c8:	00271793          	slli	a5,a4,0x2
 4cc:	00000717          	auipc	a4,0x0
 4d0:	34c70713          	addi	a4,a4,844 # 818 <malloc+0x10c>
 4d4:	97ba                	add	a5,a5,a4
 4d6:	439c                	lw	a5,0(a5)
 4d8:	97ba                	add	a5,a5,a4
 4da:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4dc:	008b8913          	addi	s2,s7,8
 4e0:	4685                	li	a3,1
 4e2:	4629                	li	a2,10
 4e4:	000ba583          	lw	a1,0(s7)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	ec2080e7          	jalr	-318(ra) # 3ac <printint>
 4f2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	b745                	j	496 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f8:	008b8913          	addi	s2,s7,8
 4fc:	4681                	li	a3,0
 4fe:	4629                	li	a2,10
 500:	000ba583          	lw	a1,0(s7)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	ea6080e7          	jalr	-346(ra) # 3ac <printint>
 50e:	8bca                	mv	s7,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	b751                	j	496 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 514:	008b8913          	addi	s2,s7,8
 518:	4681                	li	a3,0
 51a:	4641                	li	a2,16
 51c:	000ba583          	lw	a1,0(s7)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e8a080e7          	jalr	-374(ra) # 3ac <printint>
 52a:	8bca                	mv	s7,s2
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b7a5                	j	496 <vprintf+0x42>
 530:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 532:	008b8793          	addi	a5,s7,8
 536:	8c3e                	mv	s8,a5
 538:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 53c:	03000593          	li	a1,48
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e48080e7          	jalr	-440(ra) # 38a <putc>
  putc(fd, 'x');
 54a:	07800593          	li	a1,120
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e3a080e7          	jalr	-454(ra) # 38a <putc>
 558:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55a:	00000b97          	auipc	s7,0x0
 55e:	316b8b93          	addi	s7,s7,790 # 870 <digits>
 562:	03c9d793          	srli	a5,s3,0x3c
 566:	97de                	add	a5,a5,s7
 568:	0007c583          	lbu	a1,0(a5)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e1c080e7          	jalr	-484(ra) # 38a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 576:	0992                	slli	s3,s3,0x4
 578:	397d                	addiw	s2,s2,-1
 57a:	fe0914e3          	bnez	s2,562 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 57e:	8be2                	mv	s7,s8
      state = 0;
 580:	4981                	li	s3,0
 582:	6c02                	ld	s8,0(sp)
 584:	bf09                	j	496 <vprintf+0x42>
        s = va_arg(ap, char*);
 586:	008b8993          	addi	s3,s7,8
 58a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 58e:	02090163          	beqz	s2,5b0 <vprintf+0x15c>
        while(*s != 0){
 592:	00094583          	lbu	a1,0(s2)
 596:	c9a5                	beqz	a1,606 <vprintf+0x1b2>
          putc(fd, *s);
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	df0080e7          	jalr	-528(ra) # 38a <putc>
          s++;
 5a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	f9e5                	bnez	a1,598 <vprintf+0x144>
        s = va_arg(ap, char*);
 5aa:	8bce                	mv	s7,s3
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b5e5                	j	496 <vprintf+0x42>
          s = "(null)";
 5b0:	00000917          	auipc	s2,0x0
 5b4:	26090913          	addi	s2,s2,608 # 810 <malloc+0x104>
        while(*s != 0){
 5b8:	02800593          	li	a1,40
 5bc:	bff1                	j	598 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5be:	008b8913          	addi	s2,s7,8
 5c2:	000bc583          	lbu	a1,0(s7)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dc2080e7          	jalr	-574(ra) # 38a <putc>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b5c9                	j	496 <vprintf+0x42>
        putc(fd, c);
 5d6:	02500593          	li	a1,37
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dae080e7          	jalr	-594(ra) # 38a <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd45                	j	496 <vprintf+0x42>
        putc(fd, '%');
 5e8:	02500593          	li	a1,37
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	d9c080e7          	jalr	-612(ra) # 38a <putc>
        putc(fd, c);
 5f6:	85ca                	mv	a1,s2
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	d90080e7          	jalr	-624(ra) # 38a <putc>
      state = 0;
 602:	4981                	li	s3,0
 604:	bd49                	j	496 <vprintf+0x42>
        s = va_arg(ap, char*);
 606:	8bce                	mv	s7,s3
      state = 0;
 608:	4981                	li	s3,0
 60a:	b571                	j	496 <vprintf+0x42>
 60c:	74e2                	ld	s1,56(sp)
 60e:	79a2                	ld	s3,40(sp)
 610:	7a02                	ld	s4,32(sp)
 612:	6ae2                	ld	s5,24(sp)
 614:	6b42                	ld	s6,16(sp)
 616:	6ba2                	ld	s7,8(sp)
    }
  }
}
 618:	60a6                	ld	ra,72(sp)
 61a:	6406                	ld	s0,64(sp)
 61c:	7942                	ld	s2,48(sp)
 61e:	6161                	addi	sp,sp,80
 620:	8082                	ret

0000000000000622 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 622:	715d                	addi	sp,sp,-80
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	1000                	addi	s0,sp,32
 62a:	e010                	sd	a2,0(s0)
 62c:	e414                	sd	a3,8(s0)
 62e:	e818                	sd	a4,16(s0)
 630:	ec1c                	sd	a5,24(s0)
 632:	03043023          	sd	a6,32(s0)
 636:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63a:	8622                	mv	a2,s0
 63c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 640:	00000097          	auipc	ra,0x0
 644:	e14080e7          	jalr	-492(ra) # 454 <vprintf>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6161                	addi	sp,sp,80
 64e:	8082                	ret

0000000000000650 <printf>:

void
printf(const char *fmt, ...)
{
 650:	711d                	addi	sp,sp,-96
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	e40c                	sd	a1,8(s0)
 65a:	e810                	sd	a2,16(s0)
 65c:	ec14                	sd	a3,24(s0)
 65e:	f018                	sd	a4,32(s0)
 660:	f41c                	sd	a5,40(s0)
 662:	03043823          	sd	a6,48(s0)
 666:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	00840613          	addi	a2,s0,8
 66e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 672:	85aa                	mv	a1,a0
 674:	4505                	li	a0,1
 676:	00000097          	auipc	ra,0x0
 67a:	dde080e7          	jalr	-546(ra) # 454 <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6125                	addi	sp,sp,96
 684:	8082                	ret

0000000000000686 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 686:	1141                	addi	sp,sp,-16
 688:	e406                	sd	ra,8(sp)
 68a:	e022                	sd	s0,0(sp)
 68c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	00001797          	auipc	a5,0x1
 696:	96e7b783          	ld	a5,-1682(a5) # 1000 <freep>
 69a:	a039                	j	6a8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	6398                	ld	a4,0(a5)
 69e:	00e7e463          	bltu	a5,a4,6a6 <free+0x20>
 6a2:	00e6ea63          	bltu	a3,a4,6b6 <free+0x30>
{
 6a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a8:	fed7fae3          	bgeu	a5,a3,69c <free+0x16>
 6ac:	6398                	ld	a4,0(a5)
 6ae:	00e6e463          	bltu	a3,a4,6b6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	fee7eae3          	bltu	a5,a4,6a6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b6:	ff852583          	lw	a1,-8(a0)
 6ba:	6390                	ld	a2,0(a5)
 6bc:	02059813          	slli	a6,a1,0x20
 6c0:	01c85713          	srli	a4,a6,0x1c
 6c4:	9736                	add	a4,a4,a3
 6c6:	02e60563          	beq	a2,a4,6f0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6ca:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6ce:	4790                	lw	a2,8(a5)
 6d0:	02061593          	slli	a1,a2,0x20
 6d4:	01c5d713          	srli	a4,a1,0x1c
 6d8:	973e                	add	a4,a4,a5
 6da:	02e68263          	beq	a3,a4,6fe <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e0:	00001717          	auipc	a4,0x1
 6e4:	92f73023          	sd	a5,-1760(a4) # 1000 <freep>
}
 6e8:	60a2                	ld	ra,8(sp)
 6ea:	6402                	ld	s0,0(sp)
 6ec:	0141                	addi	sp,sp,16
 6ee:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 6f0:	4618                	lw	a4,8(a2)
 6f2:	9f2d                	addw	a4,a4,a1
 6f4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	6398                	ld	a4,0(a5)
 6fa:	6310                	ld	a2,0(a4)
 6fc:	b7f9                	j	6ca <free+0x44>
    p->s.size += bp->s.size;
 6fe:	ff852703          	lw	a4,-8(a0)
 702:	9f31                	addw	a4,a4,a2
 704:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 706:	ff053683          	ld	a3,-16(a0)
 70a:	bfd1                	j	6de <free+0x58>

000000000000070c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70c:	7139                	addi	sp,sp,-64
 70e:	fc06                	sd	ra,56(sp)
 710:	f822                	sd	s0,48(sp)
 712:	f04a                	sd	s2,32(sp)
 714:	ec4e                	sd	s3,24(sp)
 716:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 718:	02051993          	slli	s3,a0,0x20
 71c:	0209d993          	srli	s3,s3,0x20
 720:	09bd                	addi	s3,s3,15
 722:	0049d993          	srli	s3,s3,0x4
 726:	2985                	addiw	s3,s3,1
 728:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 72a:	00001517          	auipc	a0,0x1
 72e:	8d653503          	ld	a0,-1834(a0) # 1000 <freep>
 732:	c905                	beqz	a0,762 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 734:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 736:	4798                	lw	a4,8(a5)
 738:	09377a63          	bgeu	a4,s3,7cc <malloc+0xc0>
 73c:	f426                	sd	s1,40(sp)
 73e:	e852                	sd	s4,16(sp)
 740:	e456                	sd	s5,8(sp)
 742:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 744:	8a4e                	mv	s4,s3
 746:	6705                	lui	a4,0x1
 748:	00e9f363          	bgeu	s3,a4,74e <malloc+0x42>
 74c:	6a05                	lui	s4,0x1
 74e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 752:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 756:	00001497          	auipc	s1,0x1
 75a:	8aa48493          	addi	s1,s1,-1878 # 1000 <freep>
  if(p == (char*)-1)
 75e:	5afd                	li	s5,-1
 760:	a089                	j	7a2 <malloc+0x96>
 762:	f426                	sd	s1,40(sp)
 764:	e852                	sd	s4,16(sp)
 766:	e456                	sd	s5,8(sp)
 768:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 76a:	00001797          	auipc	a5,0x1
 76e:	8a678793          	addi	a5,a5,-1882 # 1010 <base>
 772:	00001717          	auipc	a4,0x1
 776:	88f73723          	sd	a5,-1906(a4) # 1000 <freep>
 77a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 77c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 780:	b7d1                	j	744 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 782:	6398                	ld	a4,0(a5)
 784:	e118                	sd	a4,0(a0)
 786:	a8b9                	j	7e4 <malloc+0xd8>
  hp->s.size = nu;
 788:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 78c:	0541                	addi	a0,a0,16
 78e:	00000097          	auipc	ra,0x0
 792:	ef8080e7          	jalr	-264(ra) # 686 <free>
  return freep;
 796:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 798:	c135                	beqz	a0,7fc <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79c:	4798                	lw	a4,8(a5)
 79e:	03277363          	bgeu	a4,s2,7c4 <malloc+0xb8>
    if(p == freep)
 7a2:	6098                	ld	a4,0(s1)
 7a4:	853e                	mv	a0,a5
 7a6:	fef71ae3          	bne	a4,a5,79a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7aa:	8552                	mv	a0,s4
 7ac:	00000097          	auipc	ra,0x0
 7b0:	b9e080e7          	jalr	-1122(ra) # 34a <sbrk>
  if(p == (char*)-1)
 7b4:	fd551ae3          	bne	a0,s5,788 <malloc+0x7c>
        return 0;
 7b8:	4501                	li	a0,0
 7ba:	74a2                	ld	s1,40(sp)
 7bc:	6a42                	ld	s4,16(sp)
 7be:	6aa2                	ld	s5,8(sp)
 7c0:	6b02                	ld	s6,0(sp)
 7c2:	a03d                	j	7f0 <malloc+0xe4>
 7c4:	74a2                	ld	s1,40(sp)
 7c6:	6a42                	ld	s4,16(sp)
 7c8:	6aa2                	ld	s5,8(sp)
 7ca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7cc:	fae90be3          	beq	s2,a4,782 <malloc+0x76>
        p->s.size -= nunits;
 7d0:	4137073b          	subw	a4,a4,s3
 7d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d6:	02071693          	slli	a3,a4,0x20
 7da:	01c6d713          	srli	a4,a3,0x1c
 7de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e4:	00001717          	auipc	a4,0x1
 7e8:	80a73e23          	sd	a0,-2020(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ec:	01078513          	addi	a0,a5,16
  }
}
 7f0:	70e2                	ld	ra,56(sp)
 7f2:	7442                	ld	s0,48(sp)
 7f4:	7902                	ld	s2,32(sp)
 7f6:	69e2                	ld	s3,24(sp)
 7f8:	6121                	addi	sp,sp,64
 7fa:	8082                	ret
 7fc:	74a2                	ld	s1,40(sp)
 7fe:	6a42                	ld	s4,16(sp)
 800:	6aa2                	ld	s5,8(sp)
 802:	6b02                	ld	s6,0(sp)
 804:	b7f5                	j	7f0 <malloc+0xe4>
