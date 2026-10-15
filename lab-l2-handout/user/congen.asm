
user/_congen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define N 32

void print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	144080e7          	jalr	324(ra) # 150 <strlen>
  14:	862a                	mv	a2,a0
  16:	85a6                	mv	a1,s1
  18:	4505                	li	a0,1
  1a:	00000097          	auipc	ra,0x0
  1e:	394080e7          	jalr	916(ra) # 3ae <write>
}
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	64a2                	ld	s1,8(sp)
  28:	6105                	addi	sp,sp,32
  2a:	8082                	ret

000000000000002c <forktest>:

void forktest(void)
{
  2c:	7139                	addi	sp,sp,-64
  2e:	fc06                	sd	ra,56(sp)
  30:	f822                	sd	s0,48(sp)
  32:	f426                	sd	s1,40(sp)
  34:	f04a                	sd	s2,32(sp)
  36:	ec4e                	sd	s3,24(sp)
  38:	e852                	sd	s4,16(sp)
  3a:	e456                	sd	s5,8(sp)
  3c:	e05a                	sd	s6,0(sp)
  3e:	0080                	addi	s0,sp,64
    int n, pid;

    print("fork test\n");
  40:	00001517          	auipc	a0,0x1
  44:	89050513          	addi	a0,a0,-1904 # 8d0 <malloc+0x100>
  48:	00000097          	auipc	ra,0x0
  4c:	fb8080e7          	jalr	-72(ra) # 0 <print>

    for (n = 0; n < N; n++)
  50:	4981                	li	s3,0
  52:	02000493          	li	s1,32
    {
        pid = fork();
  56:	00000097          	auipc	ra,0x0
  5a:	330080e7          	jalr	816(ra) # 386 <fork>
  5e:	892a                	mv	s2,a0
        if (pid < 0)
            break;
        if (pid == 0)
  60:	00a05563          	blez	a0,6a <forktest+0x3e>
    for (n = 0; n < N; n++)
  64:	2985                	addiw	s3,s3,1
  66:	fe9998e3          	bne	s3,s1,56 <forktest+0x2a>
            break;
    }

    for (unsigned long long i = 0; i < 50; i++)
  6a:	4481                	li	s1,0
        {
            printf("CHILD %d: %d\n", n, i);
        }
        else
        {
            printf("PARENT: %d\n", i);
  6c:	00001b17          	auipc	s6,0x1
  70:	884b0b13          	addi	s6,s6,-1916 # 8f0 <malloc+0x120>
            printf("CHILD %d: %d\n", n, i);
  74:	00001a97          	auipc	s5,0x1
  78:	86ca8a93          	addi	s5,s5,-1940 # 8e0 <malloc+0x110>
    for (unsigned long long i = 0; i < 50; i++)
  7c:	03200a13          	li	s4,50
  80:	a811                	j	94 <forktest+0x68>
            printf("PARENT: %d\n", i);
  82:	85a6                	mv	a1,s1
  84:	855a                	mv	a0,s6
  86:	00000097          	auipc	ra,0x0
  8a:	68e080e7          	jalr	1678(ra) # 714 <printf>
    for (unsigned long long i = 0; i < 50; i++)
  8e:	0485                	addi	s1,s1,1
  90:	01448c63          	beq	s1,s4,a8 <forktest+0x7c>
        if (pid == 0)
  94:	fe0917e3          	bnez	s2,82 <forktest+0x56>
            printf("CHILD %d: %d\n", n, i);
  98:	8626                	mv	a2,s1
  9a:	85ce                	mv	a1,s3
  9c:	8556                	mv	a0,s5
  9e:	00000097          	auipc	ra,0x0
  a2:	676080e7          	jalr	1654(ra) # 714 <printf>
  a6:	b7e5                	j	8e <forktest+0x62>
        }
    }

    print("fork test OK\n");
  a8:	00001517          	auipc	a0,0x1
  ac:	85850513          	addi	a0,a0,-1960 # 900 <malloc+0x130>
  b0:	00000097          	auipc	ra,0x0
  b4:	f50080e7          	jalr	-176(ra) # 0 <print>
}
  b8:	70e2                	ld	ra,56(sp)
  ba:	7442                	ld	s0,48(sp)
  bc:	74a2                	ld	s1,40(sp)
  be:	7902                	ld	s2,32(sp)
  c0:	69e2                	ld	s3,24(sp)
  c2:	6a42                	ld	s4,16(sp)
  c4:	6aa2                	ld	s5,8(sp)
  c6:	6b02                	ld	s6,0(sp)
  c8:	6121                	addi	sp,sp,64
  ca:	8082                	ret

00000000000000cc <main>:

int main(void)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
    forktest();
  d4:	00000097          	auipc	ra,0x0
  d8:	f58080e7          	jalr	-168(ra) # 2c <forktest>
    exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	2b0080e7          	jalr	688(ra) # 38e <exit>

00000000000000e6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ee:	00000097          	auipc	ra,0x0
  f2:	fde080e7          	jalr	-34(ra) # cc <main>
  exit(0);
  f6:	4501                	li	a0,0
  f8:	00000097          	auipc	ra,0x0
  fc:	296080e7          	jalr	662(ra) # 38e <exit>

0000000000000100 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 108:	87aa                	mv	a5,a0
 10a:	0585                	addi	a1,a1,1
 10c:	0785                	addi	a5,a5,1
 10e:	fff5c703          	lbu	a4,-1(a1)
 112:	fee78fa3          	sb	a4,-1(a5)
 116:	fb75                	bnez	a4,10a <strcpy+0xa>
    ;
  return os;
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	1141                	addi	sp,sp,-16
 122:	e406                	sd	ra,8(sp)
 124:	e022                	sd	s0,0(sp)
 126:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cb91                	beqz	a5,140 <strcmp+0x20>
 12e:	0005c703          	lbu	a4,0(a1)
 132:	00f71763          	bne	a4,a5,140 <strcmp+0x20>
    p++, q++;
 136:	0505                	addi	a0,a0,1
 138:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbe5                	bnez	a5,12e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 140:	0005c503          	lbu	a0,0(a1)
}
 144:	40a7853b          	subw	a0,a5,a0
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strlen>:

uint
strlen(const char *s)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 158:	00054783          	lbu	a5,0(a0)
 15c:	cf91                	beqz	a5,178 <strlen+0x28>
 15e:	00150793          	addi	a5,a0,1
 162:	86be                	mv	a3,a5
 164:	0785                	addi	a5,a5,1
 166:	fff7c703          	lbu	a4,-1(a5)
 16a:	ff65                	bnez	a4,162 <strlen+0x12>
 16c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret
  for(n = 0; s[n]; n++)
 178:	4501                	li	a0,0
 17a:	bfdd                	j	170 <strlen+0x20>

000000000000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ca19                	beqz	a2,19a <memset+0x1e>
 186:	87aa                	mv	a5,a0
 188:	1602                	slli	a2,a2,0x20
 18a:	9201                	srli	a2,a2,0x20
 18c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 190:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 194:	0785                	addi	a5,a5,1
 196:	fee79de3          	bne	a5,a4,190 <memset+0x14>
  }
  return dst;
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strchr>:

char*
strchr(const char *s, char c)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf81                	beqz	a5,1c6 <strchr+0x24>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1c>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xe>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	60a2                	ld	ra,8(sp)
 1c0:	6402                	ld	s0,0(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfdd                	j	1be <strchr+0x1c>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	e862                	sd	s8,16(sp)
 1e0:	1080                	addi	s0,sp,96
 1e2:	8baa                	mv	s7,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ea:	faf40b13          	addi	s6,s0,-81
 1ee:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1f0:	8c26                	mv	s8,s1
 1f2:	0014899b          	addiw	s3,s1,1
 1f6:	84ce                	mv	s1,s3
 1f8:	0349d663          	bge	s3,s4,224 <gets+0x5a>
    cc = read(0, &c, 1);
 1fc:	8656                	mv	a2,s5
 1fe:	85da                	mv	a1,s6
 200:	4501                	li	a0,0
 202:	00000097          	auipc	ra,0x0
 206:	1a4080e7          	jalr	420(ra) # 3a6 <read>
    if(cc < 1)
 20a:	00a05d63          	blez	a0,224 <gets+0x5a>
      break;
    buf[i++] = c;
 20e:	faf44783          	lbu	a5,-81(s0)
 212:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 216:	0905                	addi	s2,s2,1
 218:	ff678713          	addi	a4,a5,-10
 21c:	c319                	beqz	a4,222 <gets+0x58>
 21e:	17cd                	addi	a5,a5,-13
 220:	fbe1                	bnez	a5,1f0 <gets+0x26>
    buf[i++] = c;
 222:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 224:	9c5e                	add	s8,s8,s7
 226:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22a:	855e                	mv	a0,s7
 22c:	60e6                	ld	ra,88(sp)
 22e:	6446                	ld	s0,80(sp)
 230:	64a6                	ld	s1,72(sp)
 232:	6906                	ld	s2,64(sp)
 234:	79e2                	ld	s3,56(sp)
 236:	7a42                	ld	s4,48(sp)
 238:	7aa2                	ld	s5,40(sp)
 23a:	7b02                	ld	s6,32(sp)
 23c:	6be2                	ld	s7,24(sp)
 23e:	6c42                	ld	s8,16(sp)
 240:	6125                	addi	sp,sp,96
 242:	8082                	ret

0000000000000244 <stat>:

int
stat(const char *n, struct stat *st)
{
 244:	1101                	addi	sp,sp,-32
 246:	ec06                	sd	ra,24(sp)
 248:	e822                	sd	s0,16(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	1000                	addi	s0,sp,32
 24e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 250:	4581                	li	a1,0
 252:	00000097          	auipc	ra,0x0
 256:	17c080e7          	jalr	380(ra) # 3ce <open>
  if(fd < 0)
 25a:	02054663          	bltz	a0,286 <stat+0x42>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	00000097          	auipc	ra,0x0
 268:	182080e7          	jalr	386(ra) # 3e6 <fstat>
 26c:	892a                	mv	s2,a0
  close(fd);
 26e:	8526                	mv	a0,s1
 270:	00000097          	auipc	ra,0x0
 274:	146080e7          	jalr	326(ra) # 3b6 <close>
  return r;
 278:	64a2                	ld	s1,8(sp)
}
 27a:	854a                	mv	a0,s2
 27c:	60e2                	ld	ra,24(sp)
 27e:	6442                	ld	s0,16(sp)
 280:	6902                	ld	s2,0(sp)
 282:	6105                	addi	sp,sp,32
 284:	8082                	ret
    return -1;
 286:	57fd                	li	a5,-1
 288:	893e                	mv	s2,a5
 28a:	bfc5                	j	27a <stat+0x36>

000000000000028c <atoi>:

int
atoi(const char *s)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 294:	00054683          	lbu	a3,0(a0)
 298:	fd06879b          	addiw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	4625                	li	a2,9
 2a2:	02f66963          	bltu	a2,a5,2d4 <atoi+0x48>
 2a6:	872a                	mv	a4,a0
  n = 0;
 2a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2aa:	0705                	addi	a4,a4,1
 2ac:	0025179b          	slliw	a5,a0,0x2
 2b0:	9fa9                	addw	a5,a5,a0
 2b2:	0017979b          	slliw	a5,a5,0x1
 2b6:	9fb5                	addw	a5,a5,a3
 2b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2bc:	00074683          	lbu	a3,0(a4)
 2c0:	fd06879b          	addiw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	fef671e3          	bgeu	a2,a5,2aa <atoi+0x1e>
  return n;
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  n = 0;
 2d4:	4501                	li	a0,0
 2d6:	bfdd                	j	2cc <atoi+0x40>

00000000000002d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e0:	02b57563          	bgeu	a0,a1,30a <memmove+0x32>
    while(n-- > 0)
 2e4:	00c05f63          	blez	a2,302 <memmove+0x2a>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f2:	0585                	addi	a1,a1,1
 2f4:	0705                	addi	a4,a4,1
 2f6:	fff5c683          	lbu	a3,-1(a1)
 2fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fe:	fee79ae3          	bne	a5,a4,2f2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
    while(n-- > 0)
 30a:	fec05ce3          	blez	a2,302 <memmove+0x2a>
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
 314:	fff6079b          	addiw	a5,a2,-1
 318:	1782                	slli	a5,a5,0x20
 31a:	9381                	srli	a5,a5,0x20
 31c:	fff7c793          	not	a5,a5
 320:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 322:	15fd                	addi	a1,a1,-1
 324:	177d                	addi	a4,a4,-1
 326:	0005c683          	lbu	a3,0(a1)
 32a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32e:	fef71ae3          	bne	a4,a5,322 <memmove+0x4a>
 332:	bfc1                	j	302 <memmove+0x2a>

0000000000000334 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33c:	c61d                	beqz	a2,36a <memcmp+0x36>
 33e:	1602                	slli	a2,a2,0x20
 340:	9201                	srli	a2,a2,0x20
 342:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 346:	00054783          	lbu	a5,0(a0)
 34a:	0005c703          	lbu	a4,0(a1)
 34e:	00e79863          	bne	a5,a4,35e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 352:	0505                	addi	a0,a0,1
    p2++;
 354:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 356:	fed518e3          	bne	a0,a3,346 <memcmp+0x12>
  }
  return 0;
 35a:	4501                	li	a0,0
 35c:	a019                	j	362 <memcmp+0x2e>
      return *p1 - *p2;
 35e:	40e7853b          	subw	a0,a5,a4
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret
  return 0;
 36a:	4501                	li	a0,0
 36c:	bfdd                	j	362 <memcmp+0x2e>

000000000000036e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e406                	sd	ra,8(sp)
 372:	e022                	sd	s0,0(sp)
 374:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 376:	00000097          	auipc	ra,0x0
 37a:	f62080e7          	jalr	-158(ra) # 2d8 <memmove>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 386:	4885                	li	a7,1
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exit>:
.global exit
exit:
 li a7, SYS_exit
 38e:	4889                	li	a7,2
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <wait>:
.global wait
wait:
 li a7, SYS_wait
 396:	488d                	li	a7,3
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39e:	4891                	li	a7,4
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <read>:
.global read
read:
 li a7, SYS_read
 3a6:	4895                	li	a7,5
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <write>:
.global write
write:
 li a7, SYS_write
 3ae:	48c1                	li	a7,16
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <close>:
.global close
close:
 li a7, SYS_close
 3b6:	48d5                	li	a7,21
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kill>:
.global kill
kill:
 li a7, SYS_kill
 3be:	4899                	li	a7,6
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c6:	489d                	li	a7,7
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <open>:
.global open
open:
 li a7, SYS_open
 3ce:	48bd                	li	a7,15
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d6:	48c5                	li	a7,17
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3de:	48c9                	li	a7,18
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <link>:
.global link
link:
 li a7, SYS_link
 3ee:	48cd                	li	a7,19
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f6:	48d1                	li	a7,20
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fe:	48a5                	li	a7,9
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dup>:
.global dup
dup:
 li a7, SYS_dup
 406:	48a9                	li	a7,10
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40e:	48ad                	li	a7,11
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 416:	48b1                	li	a7,12
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41e:	48b5                	li	a7,13
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 426:	48b9                	li	a7,14
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <ps>:
.global ps
ps:
 li a7, SYS_ps
 42e:	48d9                	li	a7,22
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 436:	48dd                	li	a7,23
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 43e:	48e1                	li	a7,24
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <yield>:
.global yield
yield:
 li a7, SYS_yield
 446:	48e5                	li	a7,25
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44e:	1101                	addi	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	1000                	addi	s0,sp,32
 456:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45a:	4605                	li	a2,1
 45c:	fef40593          	addi	a1,s0,-17
 460:	00000097          	auipc	ra,0x0
 464:	f4e080e7          	jalr	-178(ra) # 3ae <write>
}
 468:	60e2                	ld	ra,24(sp)
 46a:	6442                	ld	s0,16(sp)
 46c:	6105                	addi	sp,sp,32
 46e:	8082                	ret

0000000000000470 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	7139                	addi	sp,sp,-64
 472:	fc06                	sd	ra,56(sp)
 474:	f822                	sd	s0,48(sp)
 476:	f04a                	sd	s2,32(sp)
 478:	ec4e                	sd	s3,24(sp)
 47a:	0080                	addi	s0,sp,64
 47c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47e:	cad9                	beqz	a3,514 <printint+0xa4>
 480:	01f5d79b          	srliw	a5,a1,0x1f
 484:	cbc1                	beqz	a5,514 <printint+0xa4>
    neg = 1;
    x = -xx;
 486:	40b005bb          	negw	a1,a1
    neg = 1;
 48a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 48c:	fc040993          	addi	s3,s0,-64
  neg = 0;
 490:	86ce                	mv	a3,s3
  i = 0;
 492:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 494:	00000817          	auipc	a6,0x0
 498:	4dc80813          	addi	a6,a6,1244 # 970 <digits>
 49c:	88ba                	mv	a7,a4
 49e:	0017051b          	addiw	a0,a4,1
 4a2:	872a                	mv	a4,a0
 4a4:	02c5f7bb          	remuw	a5,a1,a2
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	97c2                	add	a5,a5,a6
 4ae:	0007c783          	lbu	a5,0(a5)
 4b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b6:	87ae                	mv	a5,a1
 4b8:	02c5d5bb          	divuw	a1,a1,a2
 4bc:	0685                	addi	a3,a3,1
 4be:	fcc7ffe3          	bgeu	a5,a2,49c <printint+0x2c>
  if(neg)
 4c2:	00030c63          	beqz	t1,4da <printint+0x6a>
    buf[i++] = '-';
 4c6:	fd050793          	addi	a5,a0,-48
 4ca:	00878533          	add	a0,a5,s0
 4ce:	02d00793          	li	a5,45
 4d2:	fef50823          	sb	a5,-16(a0)
 4d6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4da:	02e05763          	blez	a4,508 <printint+0x98>
 4de:	f426                	sd	s1,40(sp)
 4e0:	377d                	addiw	a4,a4,-1
 4e2:	00e984b3          	add	s1,s3,a4
 4e6:	19fd                	addi	s3,s3,-1
 4e8:	99ba                	add	s3,s3,a4
 4ea:	1702                	slli	a4,a4,0x20
 4ec:	9301                	srli	a4,a4,0x20
 4ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f2:	0004c583          	lbu	a1,0(s1)
 4f6:	854a                	mv	a0,s2
 4f8:	00000097          	auipc	ra,0x0
 4fc:	f56080e7          	jalr	-170(ra) # 44e <putc>
  while(--i >= 0)
 500:	14fd                	addi	s1,s1,-1
 502:	ff3498e3          	bne	s1,s3,4f2 <printint+0x82>
 506:	74a2                	ld	s1,40(sp)
}
 508:	70e2                	ld	ra,56(sp)
 50a:	7442                	ld	s0,48(sp)
 50c:	7902                	ld	s2,32(sp)
 50e:	69e2                	ld	s3,24(sp)
 510:	6121                	addi	sp,sp,64
 512:	8082                	ret
  neg = 0;
 514:	4301                	li	t1,0
 516:	bf9d                	j	48c <printint+0x1c>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	715d                	addi	sp,sp,-80
 51a:	e486                	sd	ra,72(sp)
 51c:	e0a2                	sd	s0,64(sp)
 51e:	f84a                	sd	s2,48(sp)
 520:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 522:	0005c903          	lbu	s2,0(a1)
 526:	1a090b63          	beqz	s2,6dc <vprintf+0x1c4>
 52a:	fc26                	sd	s1,56(sp)
 52c:	f44e                	sd	s3,40(sp)
 52e:	f052                	sd	s4,32(sp)
 530:	ec56                	sd	s5,24(sp)
 532:	e85a                	sd	s6,16(sp)
 534:	e45e                	sd	s7,8(sp)
 536:	8aaa                	mv	s5,a0
 538:	8bb2                	mv	s7,a2
 53a:	00158493          	addi	s1,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 540:	02500a13          	li	s4,37
 544:	4b55                	li	s6,21
 546:	a839                	j	564 <vprintf+0x4c>
        putc(fd, c);
 548:	85ca                	mv	a1,s2
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	f02080e7          	jalr	-254(ra) # 44e <putc>
 554:	a019                	j	55a <vprintf+0x42>
    } else if(state == '%'){
 556:	01498d63          	beq	s3,s4,570 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 55a:	0485                	addi	s1,s1,1
 55c:	fff4c903          	lbu	s2,-1(s1)
 560:	16090863          	beqz	s2,6d0 <vprintf+0x1b8>
    if(state == 0){
 564:	fe0999e3          	bnez	s3,556 <vprintf+0x3e>
      if(c == '%'){
 568:	ff4910e3          	bne	s2,s4,548 <vprintf+0x30>
        state = '%';
 56c:	89d2                	mv	s3,s4
 56e:	b7f5                	j	55a <vprintf+0x42>
      if(c == 'd'){
 570:	13490563          	beq	s2,s4,69a <vprintf+0x182>
 574:	f9d9079b          	addiw	a5,s2,-99
 578:	0ff7f793          	zext.b	a5,a5
 57c:	12fb6863          	bltu	s6,a5,6ac <vprintf+0x194>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f713          	zext.b	a4,a5
 588:	12eb6263          	bltu	s6,a4,6ac <vprintf+0x194>
 58c:	00271793          	slli	a5,a4,0x2
 590:	00000717          	auipc	a4,0x0
 594:	38870713          	addi	a4,a4,904 # 918 <malloc+0x148>
 598:	97ba                	add	a5,a5,a4
 59a:	439c                	lw	a5,0(a5)
 59c:	97ba                	add	a5,a5,a4
 59e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	ec2080e7          	jalr	-318(ra) # 470 <printint>
 5b6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b745                	j	55a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	ea6080e7          	jalr	-346(ra) # 470 <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b751                	j	55a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e8a080e7          	jalr	-374(ra) # 470 <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b7a5                	j	55a <vprintf+0x42>
 5f4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f6:	008b8793          	addi	a5,s7,8
 5fa:	8c3e                	mv	s8,a5
 5fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 600:	03000593          	li	a1,48
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e48080e7          	jalr	-440(ra) # 44e <putc>
  putc(fd, 'x');
 60e:	07800593          	li	a1,120
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e3a080e7          	jalr	-454(ra) # 44e <putc>
 61c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61e:	00000b97          	auipc	s7,0x0
 622:	352b8b93          	addi	s7,s7,850 # 970 <digits>
 626:	03c9d793          	srli	a5,s3,0x3c
 62a:	97de                	add	a5,a5,s7
 62c:	0007c583          	lbu	a1,0(a5)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e1c080e7          	jalr	-484(ra) # 44e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63a:	0992                	slli	s3,s3,0x4
 63c:	397d                	addiw	s2,s2,-1
 63e:	fe0914e3          	bnez	s2,626 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 642:	8be2                	mv	s7,s8
      state = 0;
 644:	4981                	li	s3,0
 646:	6c02                	ld	s8,0(sp)
 648:	bf09                	j	55a <vprintf+0x42>
        s = va_arg(ap, char*);
 64a:	008b8993          	addi	s3,s7,8
 64e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 652:	02090163          	beqz	s2,674 <vprintf+0x15c>
        while(*s != 0){
 656:	00094583          	lbu	a1,0(s2)
 65a:	c9a5                	beqz	a1,6ca <vprintf+0x1b2>
          putc(fd, *s);
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	df0080e7          	jalr	-528(ra) # 44e <putc>
          s++;
 666:	0905                	addi	s2,s2,1
        while(*s != 0){
 668:	00094583          	lbu	a1,0(s2)
 66c:	f9e5                	bnez	a1,65c <vprintf+0x144>
        s = va_arg(ap, char*);
 66e:	8bce                	mv	s7,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	b5e5                	j	55a <vprintf+0x42>
          s = "(null)";
 674:	00000917          	auipc	s2,0x0
 678:	29c90913          	addi	s2,s2,668 # 910 <malloc+0x140>
        while(*s != 0){
 67c:	02800593          	li	a1,40
 680:	bff1                	j	65c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 682:	008b8913          	addi	s2,s7,8
 686:	000bc583          	lbu	a1,0(s7)
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	dc2080e7          	jalr	-574(ra) # 44e <putc>
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	b5c9                	j	55a <vprintf+0x42>
        putc(fd, c);
 69a:	02500593          	li	a1,37
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	dae080e7          	jalr	-594(ra) # 44e <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bd45                	j	55a <vprintf+0x42>
        putc(fd, '%');
 6ac:	02500593          	li	a1,37
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	d9c080e7          	jalr	-612(ra) # 44e <putc>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	d90080e7          	jalr	-624(ra) # 44e <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd49                	j	55a <vprintf+0x42>
        s = va_arg(ap, char*);
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b571                	j	55a <vprintf+0x42>
 6d0:	74e2                	ld	s1,56(sp)
 6d2:	79a2                	ld	s3,40(sp)
 6d4:	7a02                	ld	s4,32(sp)
 6d6:	6ae2                	ld	s5,24(sp)
 6d8:	6b42                	ld	s6,16(sp)
 6da:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6dc:	60a6                	ld	ra,72(sp)
 6de:	6406                	ld	s0,64(sp)
 6e0:	7942                	ld	s2,48(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e6:	715d                	addi	sp,sp,-80
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e010                	sd	a2,0(s0)
 6f0:	e414                	sd	a3,8(s0)
 6f2:	e818                	sd	a4,16(s0)
 6f4:	ec1c                	sd	a5,24(s0)
 6f6:	03043023          	sd	a6,32(s0)
 6fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fe:	8622                	mv	a2,s0
 700:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 704:	00000097          	auipc	ra,0x0
 708:	e14080e7          	jalr	-492(ra) # 518 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <printf>:

void
printf(const char *fmt, ...)
{
 714:	711d                	addi	sp,sp,-96
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e40c                	sd	a1,8(s0)
 71e:	e810                	sd	a2,16(s0)
 720:	ec14                	sd	a3,24(s0)
 722:	f018                	sd	a4,32(s0)
 724:	f41c                	sd	a5,40(s0)
 726:	03043823          	sd	a6,48(s0)
 72a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	00840613          	addi	a2,s0,8
 732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 736:	85aa                	mv	a1,a0
 738:	4505                	li	a0,1
 73a:	00000097          	auipc	ra,0x0
 73e:	dde080e7          	jalr	-546(ra) # 518 <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6125                	addi	sp,sp,96
 748:	8082                	ret

000000000000074a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74a:	1141                	addi	sp,sp,-16
 74c:	e406                	sd	ra,8(sp)
 74e:	e022                	sd	s0,0(sp)
 750:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 752:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	00001797          	auipc	a5,0x1
 75a:	8aa7b783          	ld	a5,-1878(a5) # 1000 <freep>
 75e:	a039                	j	76c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	6398                	ld	a4,0(a5)
 762:	00e7e463          	bltu	a5,a4,76a <free+0x20>
 766:	00e6ea63          	bltu	a3,a4,77a <free+0x30>
{
 76a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	fed7fae3          	bgeu	a5,a3,760 <free+0x16>
 770:	6398                	ld	a4,0(a5)
 772:	00e6e463          	bltu	a3,a4,77a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	fee7eae3          	bltu	a5,a4,76a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77a:	ff852583          	lw	a1,-8(a0)
 77e:	6390                	ld	a2,0(a5)
 780:	02059813          	slli	a6,a1,0x20
 784:	01c85713          	srli	a4,a6,0x1c
 788:	9736                	add	a4,a4,a3
 78a:	02e60563          	beq	a2,a4,7b4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 792:	4790                	lw	a2,8(a5)
 794:	02061593          	slli	a1,a2,0x20
 798:	01c5d713          	srli	a4,a1,0x1c
 79c:	973e                	add	a4,a4,a5
 79e:	02e68263          	beq	a3,a4,7c2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7a2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a4:	00001717          	auipc	a4,0x1
 7a8:	84f73e23          	sd	a5,-1956(a4) # 1000 <freep>
}
 7ac:	60a2                	ld	ra,8(sp)
 7ae:	6402                	ld	s0,0(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7b4:	4618                	lw	a4,8(a2)
 7b6:	9f2d                	addw	a4,a4,a1
 7b8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7bc:	6398                	ld	a4,0(a5)
 7be:	6310                	ld	a2,0(a4)
 7c0:	b7f9                	j	78e <free+0x44>
    p->s.size += bp->s.size;
 7c2:	ff852703          	lw	a4,-8(a0)
 7c6:	9f31                	addw	a4,a4,a2
 7c8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ca:	ff053683          	ld	a3,-16(a0)
 7ce:	bfd1                	j	7a2 <free+0x58>

00000000000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f04a                	sd	s2,32(sp)
 7d8:	ec4e                	sd	s3,24(sp)
 7da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dc:	02051993          	slli	s3,a0,0x20
 7e0:	0209d993          	srli	s3,s3,0x20
 7e4:	09bd                	addi	s3,s3,15
 7e6:	0049d993          	srli	s3,s3,0x4
 7ea:	2985                	addiw	s3,s3,1
 7ec:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ee:	00001517          	auipc	a0,0x1
 7f2:	81253503          	ld	a0,-2030(a0) # 1000 <freep>
 7f6:	c905                	beqz	a0,826 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fa:	4798                	lw	a4,8(a5)
 7fc:	09377a63          	bgeu	a4,s3,890 <malloc+0xc0>
 800:	f426                	sd	s1,40(sp)
 802:	e852                	sd	s4,16(sp)
 804:	e456                	sd	s5,8(sp)
 806:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 808:	8a4e                	mv	s4,s3
 80a:	6705                	lui	a4,0x1
 80c:	00e9f363          	bgeu	s3,a4,812 <malloc+0x42>
 810:	6a05                	lui	s4,0x1
 812:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 816:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81a:	00000497          	auipc	s1,0x0
 81e:	7e648493          	addi	s1,s1,2022 # 1000 <freep>
  if(p == (char*)-1)
 822:	5afd                	li	s5,-1
 824:	a089                	j	866 <malloc+0x96>
 826:	f426                	sd	s1,40(sp)
 828:	e852                	sd	s4,16(sp)
 82a:	e456                	sd	s5,8(sp)
 82c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 82e:	00000797          	auipc	a5,0x0
 832:	7e278793          	addi	a5,a5,2018 # 1010 <base>
 836:	00000717          	auipc	a4,0x0
 83a:	7cf73523          	sd	a5,1994(a4) # 1000 <freep>
 83e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 840:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 844:	b7d1                	j	808 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	e118                	sd	a4,0(a0)
 84a:	a8b9                	j	8a8 <malloc+0xd8>
  hp->s.size = nu;
 84c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 850:	0541                	addi	a0,a0,16
 852:	00000097          	auipc	ra,0x0
 856:	ef8080e7          	jalr	-264(ra) # 74a <free>
  return freep;
 85a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 85c:	c135                	beqz	a0,8c0 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	03277363          	bgeu	a4,s2,888 <malloc+0xb8>
    if(p == freep)
 866:	6098                	ld	a4,0(s1)
 868:	853e                	mv	a0,a5
 86a:	fef71ae3          	bne	a4,a5,85e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 86e:	8552                	mv	a0,s4
 870:	00000097          	auipc	ra,0x0
 874:	ba6080e7          	jalr	-1114(ra) # 416 <sbrk>
  if(p == (char*)-1)
 878:	fd551ae3          	bne	a0,s5,84c <malloc+0x7c>
        return 0;
 87c:	4501                	li	a0,0
 87e:	74a2                	ld	s1,40(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	a03d                	j	8b4 <malloc+0xe4>
 888:	74a2                	ld	s1,40(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 890:	fae90be3          	beq	s2,a4,846 <malloc+0x76>
        p->s.size -= nunits;
 894:	4137073b          	subw	a4,a4,s3
 898:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89a:	02071693          	slli	a3,a4,0x20
 89e:	01c6d713          	srli	a4,a3,0x1c
 8a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	74a73c23          	sd	a0,1880(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b0:	01078513          	addi	a0,a5,16
  }
}
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	7902                	ld	s2,32(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6121                	addi	sp,sp,64
 8be:	8082                	ret
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	b7f5                	j	8b4 <malloc+0xe4>
