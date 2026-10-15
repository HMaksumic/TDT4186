
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
    uint16 proc_idx = 0;
  12:	4981                	li	s3,0
    while (1)
    {
        struct user_proc *procs = ps(proc_idx, 2);
  14:	4a89                	li	s5,2

        for (int i = 0; i < 2; i++)
        {
            if (procs[i].state == UNUSED)
                exit(0);
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  16:	00001a17          	auipc	s4,0x1
  1a:	86aa0a13          	addi	s4,s4,-1942 # 880 <malloc+0x114>
        struct user_proc *procs = ps(proc_idx, 2);
  1e:	85d6                	mv	a1,s5
  20:	0ff9f513          	zext.b	a0,s3
  24:	00000097          	auipc	ra,0x0
  28:	3a6080e7          	jalr	934(ra) # 3ca <ps>
        if (procs == 0)
  2c:	c90d                	beqz	a0,5e <main+0x5e>
  2e:	01450493          	addi	s1,a0,20
  32:	05c50913          	addi	s2,a0,92
            if (procs[i].state == UNUSED)
  36:	fec4a683          	lw	a3,-20(s1)
  3a:	ce9d                	beqz	a3,78 <main+0x78>
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
  3c:	ff84a603          	lw	a2,-8(s1)
  40:	85a6                	mv	a1,s1
  42:	8552                	mv	a0,s4
  44:	00000097          	auipc	ra,0x0
  48:	66c080e7          	jalr	1644(ra) # 6b0 <printf>
        for (int i = 0; i < 2; i++)
  4c:	02448493          	addi	s1,s1,36
  50:	ff2493e3          	bne	s1,s2,36 <main+0x36>
        }
        proc_idx += 2;
  54:	2989                	addiw	s3,s3,2
  56:	19c2                	slli	s3,s3,0x30
  58:	0309d993          	srli	s3,s3,0x30
    {
  5c:	b7c9                	j	1e <main+0x1e>
            printf("SYSCALL FAILED");
  5e:	00001517          	auipc	a0,0x1
  62:	81250513          	addi	a0,a0,-2030 # 870 <malloc+0x104>
  66:	00000097          	auipc	ra,0x0
  6a:	64a080e7          	jalr	1610(ra) # 6b0 <printf>
            exit(-1);
  6e:	557d                	li	a0,-1
  70:	00000097          	auipc	ra,0x0
  74:	2ba080e7          	jalr	698(ra) # 32a <exit>
                exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	2b0080e7          	jalr	688(ra) # 32a <exit>

0000000000000082 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  82:	1141                	addi	sp,sp,-16
  84:	e406                	sd	ra,8(sp)
  86:	e022                	sd	s0,0(sp)
  88:	0800                	addi	s0,sp,16
  extern int main();
  main();
  8a:	00000097          	auipc	ra,0x0
  8e:	f76080e7          	jalr	-138(ra) # 0 <main>
  exit(0);
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	296080e7          	jalr	662(ra) # 32a <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf91                	beqz	a5,114 <strlen+0x28>
  fa:	00150793          	addi	a5,a0,1
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 10c:	60a2                	ld	ra,8(sp)
 10e:	6402                	ld	s0,0(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  for(n = 0; s[n]; n++)
 114:	4501                	li	a0,0
 116:	bfdd                	j	10c <strlen+0x20>

0000000000000118 <memset>:

void*
memset(void *dst, int c, uint n)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1e>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x14>
  }
  return dst;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  for(; *s; s++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf81                	beqz	a5,162 <strchr+0x24>
    if(*s == c)
 14c:	00f58763          	beq	a1,a5,15a <strchr+0x1c>
  for(; *s; s++)
 150:	0505                	addi	a0,a0,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbfd                	bnez	a5,14c <strchr+0xe>
      return (char*)s;
  return 0;
 158:	4501                	li	a0,0
}
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfdd                	j	15a <strchr+0x1c>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	e862                	sd	s8,16(sp)
 17c:	1080                	addi	s0,sp,96
 17e:	8baa                	mv	s7,a0
 180:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	892a                	mv	s2,a0
 184:	4481                	li	s1,0
    cc = read(0, &c, 1);
 186:	faf40b13          	addi	s6,s0,-81
 18a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 18c:	8c26                	mv	s8,s1
 18e:	0014899b          	addiw	s3,s1,1
 192:	84ce                	mv	s1,s3
 194:	0349d663          	bge	s3,s4,1c0 <gets+0x5a>
    cc = read(0, &c, 1);
 198:	8656                	mv	a2,s5
 19a:	85da                	mv	a1,s6
 19c:	4501                	li	a0,0
 19e:	00000097          	auipc	ra,0x0
 1a2:	1a4080e7          	jalr	420(ra) # 342 <read>
    if(cc < 1)
 1a6:	00a05d63          	blez	a0,1c0 <gets+0x5a>
      break;
    buf[i++] = c;
 1aa:	faf44783          	lbu	a5,-81(s0)
 1ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b2:	0905                	addi	s2,s2,1
 1b4:	ff678713          	addi	a4,a5,-10
 1b8:	c319                	beqz	a4,1be <gets+0x58>
 1ba:	17cd                	addi	a5,a5,-13
 1bc:	fbe1                	bnez	a5,18c <gets+0x26>
    buf[i++] = c;
 1be:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1c0:	9c5e                	add	s8,s8,s7
 1c2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1c6:	855e                	mv	a0,s7
 1c8:	60e6                	ld	ra,88(sp)
 1ca:	6446                	ld	s0,80(sp)
 1cc:	64a6                	ld	s1,72(sp)
 1ce:	6906                	ld	s2,64(sp)
 1d0:	79e2                	ld	s3,56(sp)
 1d2:	7a42                	ld	s4,48(sp)
 1d4:	7aa2                	ld	s5,40(sp)
 1d6:	7b02                	ld	s6,32(sp)
 1d8:	6be2                	ld	s7,24(sp)
 1da:	6c42                	ld	s8,16(sp)
 1dc:	6125                	addi	sp,sp,96
 1de:	8082                	ret

00000000000001e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e0:	1101                	addi	sp,sp,-32
 1e2:	ec06                	sd	ra,24(sp)
 1e4:	e822                	sd	s0,16(sp)
 1e6:	e04a                	sd	s2,0(sp)
 1e8:	1000                	addi	s0,sp,32
 1ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ec:	4581                	li	a1,0
 1ee:	00000097          	auipc	ra,0x0
 1f2:	17c080e7          	jalr	380(ra) # 36a <open>
  if(fd < 0)
 1f6:	02054663          	bltz	a0,222 <stat+0x42>
 1fa:	e426                	sd	s1,8(sp)
 1fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1fe:	85ca                	mv	a1,s2
 200:	00000097          	auipc	ra,0x0
 204:	182080e7          	jalr	386(ra) # 382 <fstat>
 208:	892a                	mv	s2,a0
  close(fd);
 20a:	8526                	mv	a0,s1
 20c:	00000097          	auipc	ra,0x0
 210:	146080e7          	jalr	326(ra) # 352 <close>
  return r;
 214:	64a2                	ld	s1,8(sp)
}
 216:	854a                	mv	a0,s2
 218:	60e2                	ld	ra,24(sp)
 21a:	6442                	ld	s0,16(sp)
 21c:	6902                	ld	s2,0(sp)
 21e:	6105                	addi	sp,sp,32
 220:	8082                	ret
    return -1;
 222:	57fd                	li	a5,-1
 224:	893e                	mv	s2,a5
 226:	bfc5                	j	216 <stat+0x36>

0000000000000228 <atoi>:

int
atoi(const char *s)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 230:	00054683          	lbu	a3,0(a0)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	4625                	li	a2,9
 23e:	02f66963          	bltu	a2,a5,270 <atoi+0x48>
 242:	872a                	mv	a4,a0
  n = 0;
 244:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 246:	0705                	addi	a4,a4,1
 248:	0025179b          	slliw	a5,a0,0x2
 24c:	9fa9                	addw	a5,a5,a0
 24e:	0017979b          	slliw	a5,a5,0x1
 252:	9fb5                	addw	a5,a5,a3
 254:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 258:	00074683          	lbu	a3,0(a4)
 25c:	fd06879b          	addiw	a5,a3,-48
 260:	0ff7f793          	zext.b	a5,a5
 264:	fef671e3          	bgeu	a2,a5,246 <atoi+0x1e>
  return n;
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  n = 0;
 270:	4501                	li	a0,0
 272:	bfdd                	j	268 <atoi+0x40>

0000000000000274 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27c:	02b57563          	bgeu	a0,a1,2a6 <memmove+0x32>
    while(n-- > 0)
 280:	00c05f63          	blez	a2,29e <memmove+0x2a>
 284:	1602                	slli	a2,a2,0x20
 286:	9201                	srli	a2,a2,0x20
 288:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28c:	872a                	mv	a4,a0
      *dst++ = *src++;
 28e:	0585                	addi	a1,a1,1
 290:	0705                	addi	a4,a4,1
 292:	fff5c683          	lbu	a3,-1(a1)
 296:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29a:	fee79ae3          	bne	a5,a4,28e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
    while(n-- > 0)
 2a6:	fec05ce3          	blez	a2,29e <memmove+0x2a>
    dst += n;
 2aa:	00c50733          	add	a4,a0,a2
    src += n;
 2ae:	95b2                	add	a1,a1,a2
 2b0:	fff6079b          	addiw	a5,a2,-1
 2b4:	1782                	slli	a5,a5,0x20
 2b6:	9381                	srli	a5,a5,0x20
 2b8:	fff7c793          	not	a5,a5
 2bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2be:	15fd                	addi	a1,a1,-1
 2c0:	177d                	addi	a4,a4,-1
 2c2:	0005c683          	lbu	a3,0(a1)
 2c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ca:	fef71ae3          	bne	a4,a5,2be <memmove+0x4a>
 2ce:	bfc1                	j	29e <memmove+0x2a>

00000000000002d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d8:	c61d                	beqz	a2,306 <memcmp+0x36>
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	0005c703          	lbu	a4,0(a1)
 2ea:	00e79863          	bne	a5,a4,2fa <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ee:	0505                	addi	a0,a0,1
    p2++;
 2f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f2:	fed518e3          	bne	a0,a3,2e2 <memcmp+0x12>
  }
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	a019                	j	2fe <memcmp+0x2e>
      return *p1 - *p2;
 2fa:	40e7853b          	subw	a0,a5,a4
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  return 0;
 306:	4501                	li	a0,0
 308:	bfdd                	j	2fe <memcmp+0x2e>

000000000000030a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 312:	00000097          	auipc	ra,0x0
 316:	f62080e7          	jalr	-158(ra) # 274 <memmove>
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 322:	4885                	li	a7,1
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <ps>:
.global ps
ps:
 li a7, SYS_ps
 3ca:	48d9                	li	a7,22
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 3d2:	48dd                	li	a7,23
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 3da:	48e1                	li	a7,24
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <yield>:
.global yield
yield:
 li a7, SYS_yield
 3e2:	48e5                	li	a7,25
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	00000097          	auipc	ra,0x0
 400:	f4e080e7          	jalr	-178(ra) # 34a <write>
}
 404:	60e2                	ld	ra,24(sp)
 406:	6442                	ld	s0,16(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret

000000000000040c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40c:	7139                	addi	sp,sp,-64
 40e:	fc06                	sd	ra,56(sp)
 410:	f822                	sd	s0,48(sp)
 412:	f04a                	sd	s2,32(sp)
 414:	ec4e                	sd	s3,24(sp)
 416:	0080                	addi	s0,sp,64
 418:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41a:	cad9                	beqz	a3,4b0 <printint+0xa4>
 41c:	01f5d79b          	srliw	a5,a1,0x1f
 420:	cbc1                	beqz	a5,4b0 <printint+0xa4>
    neg = 1;
    x = -xx;
 422:	40b005bb          	negw	a1,a1
    neg = 1;
 426:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 428:	fc040993          	addi	s3,s0,-64
  neg = 0;
 42c:	86ce                	mv	a3,s3
  i = 0;
 42e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 430:	00000817          	auipc	a6,0x0
 434:	4c080813          	addi	a6,a6,1216 # 8f0 <digits>
 438:	88ba                	mv	a7,a4
 43a:	0017051b          	addiw	a0,a4,1
 43e:	872a                	mv	a4,a0
 440:	02c5f7bb          	remuw	a5,a1,a2
 444:	1782                	slli	a5,a5,0x20
 446:	9381                	srli	a5,a5,0x20
 448:	97c2                	add	a5,a5,a6
 44a:	0007c783          	lbu	a5,0(a5)
 44e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 452:	87ae                	mv	a5,a1
 454:	02c5d5bb          	divuw	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fcc7ffe3          	bgeu	a5,a2,438 <printint+0x2c>
  if(neg)
 45e:	00030c63          	beqz	t1,476 <printint+0x6a>
    buf[i++] = '-';
 462:	fd050793          	addi	a5,a0,-48
 466:	00878533          	add	a0,a5,s0
 46a:	02d00793          	li	a5,45
 46e:	fef50823          	sb	a5,-16(a0)
 472:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 476:	02e05763          	blez	a4,4a4 <printint+0x98>
 47a:	f426                	sd	s1,40(sp)
 47c:	377d                	addiw	a4,a4,-1
 47e:	00e984b3          	add	s1,s3,a4
 482:	19fd                	addi	s3,s3,-1
 484:	99ba                	add	s3,s3,a4
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	0004c583          	lbu	a1,0(s1)
 492:	854a                	mv	a0,s2
 494:	00000097          	auipc	ra,0x0
 498:	f56080e7          	jalr	-170(ra) # 3ea <putc>
  while(--i >= 0)
 49c:	14fd                	addi	s1,s1,-1
 49e:	ff3498e3          	bne	s1,s3,48e <printint+0x82>
 4a2:	74a2                	ld	s1,40(sp)
}
 4a4:	70e2                	ld	ra,56(sp)
 4a6:	7442                	ld	s0,48(sp)
 4a8:	7902                	ld	s2,32(sp)
 4aa:	69e2                	ld	s3,24(sp)
 4ac:	6121                	addi	sp,sp,64
 4ae:	8082                	ret
  neg = 0;
 4b0:	4301                	li	t1,0
 4b2:	bf9d                	j	428 <printint+0x1c>

00000000000004b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b4:	715d                	addi	sp,sp,-80
 4b6:	e486                	sd	ra,72(sp)
 4b8:	e0a2                	sd	s0,64(sp)
 4ba:	f84a                	sd	s2,48(sp)
 4bc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4be:	0005c903          	lbu	s2,0(a1)
 4c2:	1a090b63          	beqz	s2,678 <vprintf+0x1c4>
 4c6:	fc26                	sd	s1,56(sp)
 4c8:	f44e                	sd	s3,40(sp)
 4ca:	f052                	sd	s4,32(sp)
 4cc:	ec56                	sd	s5,24(sp)
 4ce:	e85a                	sd	s6,16(sp)
 4d0:	e45e                	sd	s7,8(sp)
 4d2:	8aaa                	mv	s5,a0
 4d4:	8bb2                	mv	s7,a2
 4d6:	00158493          	addi	s1,a1,1
  state = 0;
 4da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dc:	02500a13          	li	s4,37
 4e0:	4b55                	li	s6,21
 4e2:	a839                	j	500 <vprintf+0x4c>
        putc(fd, c);
 4e4:	85ca                	mv	a1,s2
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f02080e7          	jalr	-254(ra) # 3ea <putc>
 4f0:	a019                	j	4f6 <vprintf+0x42>
    } else if(state == '%'){
 4f2:	01498d63          	beq	s3,s4,50c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4f6:	0485                	addi	s1,s1,1
 4f8:	fff4c903          	lbu	s2,-1(s1)
 4fc:	16090863          	beqz	s2,66c <vprintf+0x1b8>
    if(state == 0){
 500:	fe0999e3          	bnez	s3,4f2 <vprintf+0x3e>
      if(c == '%'){
 504:	ff4910e3          	bne	s2,s4,4e4 <vprintf+0x30>
        state = '%';
 508:	89d2                	mv	s3,s4
 50a:	b7f5                	j	4f6 <vprintf+0x42>
      if(c == 'd'){
 50c:	13490563          	beq	s2,s4,636 <vprintf+0x182>
 510:	f9d9079b          	addiw	a5,s2,-99
 514:	0ff7f793          	zext.b	a5,a5
 518:	12fb6863          	bltu	s6,a5,648 <vprintf+0x194>
 51c:	f9d9079b          	addiw	a5,s2,-99
 520:	0ff7f713          	zext.b	a4,a5
 524:	12eb6263          	bltu	s6,a4,648 <vprintf+0x194>
 528:	00271793          	slli	a5,a4,0x2
 52c:	00000717          	auipc	a4,0x0
 530:	36c70713          	addi	a4,a4,876 # 898 <malloc+0x12c>
 534:	97ba                	add	a5,a5,a4
 536:	439c                	lw	a5,0(a5)
 538:	97ba                	add	a5,a5,a4
 53a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 53c:	008b8913          	addi	s2,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000ba583          	lw	a1,0(s7)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	ec2080e7          	jalr	-318(ra) # 40c <printint>
 552:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 554:	4981                	li	s3,0
 556:	b745                	j	4f6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b8913          	addi	s2,s7,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	ea6080e7          	jalr	-346(ra) # 40c <printint>
 56e:	8bca                	mv	s7,s2
      state = 0;
 570:	4981                	li	s3,0
 572:	b751                	j	4f6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 574:	008b8913          	addi	s2,s7,8
 578:	4681                	li	a3,0
 57a:	4641                	li	a2,16
 57c:	000ba583          	lw	a1,0(s7)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e8a080e7          	jalr	-374(ra) # 40c <printint>
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b7a5                	j	4f6 <vprintf+0x42>
 590:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 592:	008b8793          	addi	a5,s7,8
 596:	8c3e                	mv	s8,a5
 598:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 59c:	03000593          	li	a1,48
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e48080e7          	jalr	-440(ra) # 3ea <putc>
  putc(fd, 'x');
 5aa:	07800593          	li	a1,120
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e3a080e7          	jalr	-454(ra) # 3ea <putc>
 5b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ba:	00000b97          	auipc	s7,0x0
 5be:	336b8b93          	addi	s7,s7,822 # 8f0 <digits>
 5c2:	03c9d793          	srli	a5,s3,0x3c
 5c6:	97de                	add	a5,a5,s7
 5c8:	0007c583          	lbu	a1,0(a5)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e1c080e7          	jalr	-484(ra) # 3ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d6:	0992                	slli	s3,s3,0x4
 5d8:	397d                	addiw	s2,s2,-1
 5da:	fe0914e3          	bnez	s2,5c2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5de:	8be2                	mv	s7,s8
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	6c02                	ld	s8,0(sp)
 5e4:	bf09                	j	4f6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5e6:	008b8993          	addi	s3,s7,8
 5ea:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ee:	02090163          	beqz	s2,610 <vprintf+0x15c>
        while(*s != 0){
 5f2:	00094583          	lbu	a1,0(s2)
 5f6:	c9a5                	beqz	a1,666 <vprintf+0x1b2>
          putc(fd, *s);
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	df0080e7          	jalr	-528(ra) # 3ea <putc>
          s++;
 602:	0905                	addi	s2,s2,1
        while(*s != 0){
 604:	00094583          	lbu	a1,0(s2)
 608:	f9e5                	bnez	a1,5f8 <vprintf+0x144>
        s = va_arg(ap, char*);
 60a:	8bce                	mv	s7,s3
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b5e5                	j	4f6 <vprintf+0x42>
          s = "(null)";
 610:	00000917          	auipc	s2,0x0
 614:	28090913          	addi	s2,s2,640 # 890 <malloc+0x124>
        while(*s != 0){
 618:	02800593          	li	a1,40
 61c:	bff1                	j	5f8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 61e:	008b8913          	addi	s2,s7,8
 622:	000bc583          	lbu	a1,0(s7)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	dc2080e7          	jalr	-574(ra) # 3ea <putc>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b5c9                	j	4f6 <vprintf+0x42>
        putc(fd, c);
 636:	02500593          	li	a1,37
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	dae080e7          	jalr	-594(ra) # 3ea <putc>
      state = 0;
 644:	4981                	li	s3,0
 646:	bd45                	j	4f6 <vprintf+0x42>
        putc(fd, '%');
 648:	02500593          	li	a1,37
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	d9c080e7          	jalr	-612(ra) # 3ea <putc>
        putc(fd, c);
 656:	85ca                	mv	a1,s2
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d90080e7          	jalr	-624(ra) # 3ea <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	bd49                	j	4f6 <vprintf+0x42>
        s = va_arg(ap, char*);
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	b571                	j	4f6 <vprintf+0x42>
 66c:	74e2                	ld	s1,56(sp)
 66e:	79a2                	ld	s3,40(sp)
 670:	7a02                	ld	s4,32(sp)
 672:	6ae2                	ld	s5,24(sp)
 674:	6b42                	ld	s6,16(sp)
 676:	6ba2                	ld	s7,8(sp)
    }
  }
}
 678:	60a6                	ld	ra,72(sp)
 67a:	6406                	ld	s0,64(sp)
 67c:	7942                	ld	s2,48(sp)
 67e:	6161                	addi	sp,sp,80
 680:	8082                	ret

0000000000000682 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 682:	715d                	addi	sp,sp,-80
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	1000                	addi	s0,sp,32
 68a:	e010                	sd	a2,0(s0)
 68c:	e414                	sd	a3,8(s0)
 68e:	e818                	sd	a4,16(s0)
 690:	ec1c                	sd	a5,24(s0)
 692:	03043023          	sd	a6,32(s0)
 696:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69a:	8622                	mv	a2,s0
 69c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a0:	00000097          	auipc	ra,0x0
 6a4:	e14080e7          	jalr	-492(ra) # 4b4 <vprintf>
}
 6a8:	60e2                	ld	ra,24(sp)
 6aa:	6442                	ld	s0,16(sp)
 6ac:	6161                	addi	sp,sp,80
 6ae:	8082                	ret

00000000000006b0 <printf>:

void
printf(const char *fmt, ...)
{
 6b0:	711d                	addi	sp,sp,-96
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e40c                	sd	a1,8(s0)
 6ba:	e810                	sd	a2,16(s0)
 6bc:	ec14                	sd	a3,24(s0)
 6be:	f018                	sd	a4,32(s0)
 6c0:	f41c                	sd	a5,40(s0)
 6c2:	03043823          	sd	a6,48(s0)
 6c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	00840613          	addi	a2,s0,8
 6ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d2:	85aa                	mv	a1,a0
 6d4:	4505                	li	a0,1
 6d6:	00000097          	auipc	ra,0x0
 6da:	dde080e7          	jalr	-546(ra) # 4b4 <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6125                	addi	sp,sp,96
 6e4:	8082                	ret

00000000000006e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e406                	sd	ra,8(sp)
 6ea:	e022                	sd	s0,0(sp)
 6ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	00001797          	auipc	a5,0x1
 6f6:	90e7b783          	ld	a5,-1778(a5) # 1000 <freep>
 6fa:	a039                	j	708 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fc:	6398                	ld	a4,0(a5)
 6fe:	00e7e463          	bltu	a5,a4,706 <free+0x20>
 702:	00e6ea63          	bltu	a3,a4,716 <free+0x30>
{
 706:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 708:	fed7fae3          	bgeu	a5,a3,6fc <free+0x16>
 70c:	6398                	ld	a4,0(a5)
 70e:	00e6e463          	bltu	a3,a4,716 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	fee7eae3          	bltu	a5,a4,706 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 716:	ff852583          	lw	a1,-8(a0)
 71a:	6390                	ld	a2,0(a5)
 71c:	02059813          	slli	a6,a1,0x20
 720:	01c85713          	srli	a4,a6,0x1c
 724:	9736                	add	a4,a4,a3
 726:	02e60563          	beq	a2,a4,750 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 72a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 72e:	4790                	lw	a2,8(a5)
 730:	02061593          	slli	a1,a2,0x20
 734:	01c5d713          	srli	a4,a1,0x1c
 738:	973e                	add	a4,a4,a5
 73a:	02e68263          	beq	a3,a4,75e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 73e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 740:	00001717          	auipc	a4,0x1
 744:	8cf73023          	sd	a5,-1856(a4) # 1000 <freep>
}
 748:	60a2                	ld	ra,8(sp)
 74a:	6402                	ld	s0,0(sp)
 74c:	0141                	addi	sp,sp,16
 74e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 750:	4618                	lw	a4,8(a2)
 752:	9f2d                	addw	a4,a4,a1
 754:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	6398                	ld	a4,0(a5)
 75a:	6310                	ld	a2,0(a4)
 75c:	b7f9                	j	72a <free+0x44>
    p->s.size += bp->s.size;
 75e:	ff852703          	lw	a4,-8(a0)
 762:	9f31                	addw	a4,a4,a2
 764:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 766:	ff053683          	ld	a3,-16(a0)
 76a:	bfd1                	j	73e <free+0x58>

000000000000076c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76c:	7139                	addi	sp,sp,-64
 76e:	fc06                	sd	ra,56(sp)
 770:	f822                	sd	s0,48(sp)
 772:	f04a                	sd	s2,32(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051993          	slli	s3,a0,0x20
 77c:	0209d993          	srli	s3,s3,0x20
 780:	09bd                	addi	s3,s3,15
 782:	0049d993          	srli	s3,s3,0x4
 786:	2985                	addiw	s3,s3,1
 788:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 78a:	00001517          	auipc	a0,0x1
 78e:	87653503          	ld	a0,-1930(a0) # 1000 <freep>
 792:	c905                	beqz	a0,7c2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 794:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 796:	4798                	lw	a4,8(a5)
 798:	09377a63          	bgeu	a4,s3,82c <malloc+0xc0>
 79c:	f426                	sd	s1,40(sp)
 79e:	e852                	sd	s4,16(sp)
 7a0:	e456                	sd	s5,8(sp)
 7a2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7a4:	8a4e                	mv	s4,s3
 7a6:	6705                	lui	a4,0x1
 7a8:	00e9f363          	bgeu	s3,a4,7ae <malloc+0x42>
 7ac:	6a05                	lui	s4,0x1
 7ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b6:	00001497          	auipc	s1,0x1
 7ba:	84a48493          	addi	s1,s1,-1974 # 1000 <freep>
  if(p == (char*)-1)
 7be:	5afd                	li	s5,-1
 7c0:	a089                	j	802 <malloc+0x96>
 7c2:	f426                	sd	s1,40(sp)
 7c4:	e852                	sd	s4,16(sp)
 7c6:	e456                	sd	s5,8(sp)
 7c8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ca:	00001797          	auipc	a5,0x1
 7ce:	84678793          	addi	a5,a5,-1978 # 1010 <base>
 7d2:	00001717          	auipc	a4,0x1
 7d6:	82f73723          	sd	a5,-2002(a4) # 1000 <freep>
 7da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e0:	b7d1                	j	7a4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7e2:	6398                	ld	a4,0(a5)
 7e4:	e118                	sd	a4,0(a0)
 7e6:	a8b9                	j	844 <malloc+0xd8>
  hp->s.size = nu;
 7e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ec:	0541                	addi	a0,a0,16
 7ee:	00000097          	auipc	ra,0x0
 7f2:	ef8080e7          	jalr	-264(ra) # 6e6 <free>
  return freep;
 7f6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7f8:	c135                	beqz	a0,85c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fc:	4798                	lw	a4,8(a5)
 7fe:	03277363          	bgeu	a4,s2,824 <malloc+0xb8>
    if(p == freep)
 802:	6098                	ld	a4,0(s1)
 804:	853e                	mv	a0,a5
 806:	fef71ae3          	bne	a4,a5,7fa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 80a:	8552                	mv	a0,s4
 80c:	00000097          	auipc	ra,0x0
 810:	ba6080e7          	jalr	-1114(ra) # 3b2 <sbrk>
  if(p == (char*)-1)
 814:	fd551ae3          	bne	a0,s5,7e8 <malloc+0x7c>
        return 0;
 818:	4501                	li	a0,0
 81a:	74a2                	ld	s1,40(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
 822:	a03d                	j	850 <malloc+0xe4>
 824:	74a2                	ld	s1,40(sp)
 826:	6a42                	ld	s4,16(sp)
 828:	6aa2                	ld	s5,8(sp)
 82a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 82c:	fae90be3          	beq	s2,a4,7e2 <malloc+0x76>
        p->s.size -= nunits;
 830:	4137073b          	subw	a4,a4,s3
 834:	c798                	sw	a4,8(a5)
        p += p->s.size;
 836:	02071693          	slli	a3,a4,0x20
 83a:	01c6d713          	srli	a4,a3,0x1c
 83e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 840:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 844:	00000717          	auipc	a4,0x0
 848:	7aa73e23          	sd	a0,1980(a4) # 1000 <freep>
      return (void*)(p + 1);
 84c:	01078513          	addi	a0,a5,16
  }
}
 850:	70e2                	ld	ra,56(sp)
 852:	7442                	ld	s0,48(sp)
 854:	7902                	ld	s2,32(sp)
 856:	69e2                	ld	s3,24(sp)
 858:	6121                	addi	sp,sp,64
 85a:	8082                	ret
 85c:	74a2                	ld	s1,40(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
 864:	b7f5                	j	850 <malloc+0xe4>
