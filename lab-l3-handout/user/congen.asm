
user/_congen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define N 5

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
  10:	142080e7          	jalr	322(ra) # 14e <strlen>
  14:	862a                	mv	a2,a0
  16:	85a6                	mv	a1,s1
  18:	4505                	li	a0,1
  1a:	00000097          	auipc	ra,0x0
  1e:	392080e7          	jalr	914(ra) # 3ac <write>
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
  44:	89050513          	addi	a0,a0,-1904 # 8d0 <malloc+0xfa>
  48:	00000097          	auipc	ra,0x0
  4c:	fb8080e7          	jalr	-72(ra) # 0 <print>

    for (n = 0; n < N; n++)
  50:	4a01                	li	s4,0
  52:	4495                	li	s1,5
    {
        pid = fork();
  54:	00000097          	auipc	ra,0x0
  58:	330080e7          	jalr	816(ra) # 384 <fork>
  5c:	892a                	mv	s2,a0
        if (pid < 0)
            break;
        if (pid == 0)
  5e:	00a05563          	blez	a0,68 <forktest+0x3c>
    for (n = 0; n < N; n++)
  62:	2a05                	addiw	s4,s4,1
  64:	fe9a18e3          	bne	s4,s1,54 <forktest+0x28>
            break;
    }

    for (unsigned long long i = 0; i < 1000; i++)
  68:	4481                	li	s1,0
        {
            printf("CHILD %d: %d\n", n, i);
        }
        else
        {
            printf("PARENT: %d\n", i);
  6a:	00001b17          	auipc	s6,0x1
  6e:	886b0b13          	addi	s6,s6,-1914 # 8f0 <malloc+0x11a>
            printf("CHILD %d: %d\n", n, i);
  72:	00001a97          	auipc	s5,0x1
  76:	86ea8a93          	addi	s5,s5,-1938 # 8e0 <malloc+0x10a>
    for (unsigned long long i = 0; i < 1000; i++)
  7a:	3e800993          	li	s3,1000
  7e:	a811                	j	92 <forktest+0x66>
            printf("PARENT: %d\n", i);
  80:	85a6                	mv	a1,s1
  82:	855a                	mv	a0,s6
  84:	00000097          	auipc	ra,0x0
  88:	696080e7          	jalr	1686(ra) # 71a <printf>
    for (unsigned long long i = 0; i < 1000; i++)
  8c:	0485                	addi	s1,s1,1
  8e:	01348c63          	beq	s1,s3,a6 <forktest+0x7a>
        if (pid == 0)
  92:	fe0917e3          	bnez	s2,80 <forktest+0x54>
            printf("CHILD %d: %d\n", n, i);
  96:	8626                	mv	a2,s1
  98:	85d2                	mv	a1,s4
  9a:	8556                	mv	a0,s5
  9c:	00000097          	auipc	ra,0x0
  a0:	67e080e7          	jalr	1662(ra) # 71a <printf>
  a4:	b7e5                	j	8c <forktest+0x60>
        }
    }

    print("fork test OK\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	85a50513          	addi	a0,a0,-1958 # 900 <malloc+0x12a>
  ae:	00000097          	auipc	ra,0x0
  b2:	f52080e7          	jalr	-174(ra) # 0 <print>
}
  b6:	70e2                	ld	ra,56(sp)
  b8:	7442                	ld	s0,48(sp)
  ba:	74a2                	ld	s1,40(sp)
  bc:	7902                	ld	s2,32(sp)
  be:	69e2                	ld	s3,24(sp)
  c0:	6a42                	ld	s4,16(sp)
  c2:	6aa2                	ld	s5,8(sp)
  c4:	6b02                	ld	s6,0(sp)
  c6:	6121                	addi	sp,sp,64
  c8:	8082                	ret

00000000000000ca <main>:

int main(void)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
    forktest();
  d2:	00000097          	auipc	ra,0x0
  d6:	f5a080e7          	jalr	-166(ra) # 2c <forktest>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	2b0080e7          	jalr	688(ra) # 38c <exit>

00000000000000e4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ec:	00000097          	auipc	ra,0x0
  f0:	fde080e7          	jalr	-34(ra) # ca <main>
  exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	296080e7          	jalr	662(ra) # 38c <exit>

00000000000000fe <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e406                	sd	ra,8(sp)
 102:	e022                	sd	s0,0(sp)
 104:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 106:	87aa                	mv	a5,a0
 108:	0585                	addi	a1,a1,1
 10a:	0785                	addi	a5,a5,1
 10c:	fff5c703          	lbu	a4,-1(a1)
 110:	fee78fa3          	sb	a4,-1(a5)
 114:	fb75                	bnez	a4,108 <strcpy+0xa>
    ;
  return os;
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb91                	beqz	a5,13e <strcmp+0x20>
 12c:	0005c703          	lbu	a4,0(a1)
 130:	00f71763          	bne	a4,a5,13e <strcmp+0x20>
    p++, q++;
 134:	0505                	addi	a0,a0,1
 136:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbe5                	bnez	a5,12c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 13e:	0005c503          	lbu	a0,0(a1)
}
 142:	40a7853b          	subw	a0,a5,a0
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strlen>:

uint
strlen(const char *s)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf91                	beqz	a5,176 <strlen+0x28>
 15c:	00150793          	addi	a5,a0,1
 160:	86be                	mv	a3,a5
 162:	0785                	addi	a5,a5,1
 164:	fff7c703          	lbu	a4,-1(a5)
 168:	ff65                	bnez	a4,160 <strlen+0x12>
 16a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 16e:	60a2                	ld	ra,8(sp)
 170:	6402                	ld	s0,0(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
  for(n = 0; s[n]; n++)
 176:	4501                	li	a0,0
 178:	bfdd                	j	16e <strlen+0x20>

000000000000017a <memset>:

void*
memset(void *dst, int c, uint n)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 182:	ca19                	beqz	a2,198 <memset+0x1e>
 184:	87aa                	mv	a5,a0
 186:	1602                	slli	a2,a2,0x20
 188:	9201                	srli	a2,a2,0x20
 18a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 192:	0785                	addi	a5,a5,1
 194:	fee79de3          	bne	a5,a4,18e <memset+0x14>
  }
  return dst;
}
 198:	60a2                	ld	ra,8(sp)
 19a:	6402                	ld	s0,0(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e406                	sd	ra,8(sp)
 1a4:	e022                	sd	s0,0(sp)
 1a6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	cf81                	beqz	a5,1c4 <strchr+0x24>
    if(*s == c)
 1ae:	00f58763          	beq	a1,a5,1bc <strchr+0x1c>
  for(; *s; s++)
 1b2:	0505                	addi	a0,a0,1
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	fbfd                	bnez	a5,1ae <strchr+0xe>
      return (char*)s;
  return 0;
 1ba:	4501                	li	a0,0
}
 1bc:	60a2                	ld	ra,8(sp)
 1be:	6402                	ld	s0,0(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfdd                	j	1bc <strchr+0x1c>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	e862                	sd	s8,16(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e8:	faf40b13          	addi	s6,s0,-81
 1ec:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1ee:	8c26                	mv	s8,s1
 1f0:	0014899b          	addiw	s3,s1,1
 1f4:	84ce                	mv	s1,s3
 1f6:	0349d663          	bge	s3,s4,222 <gets+0x5a>
    cc = read(0, &c, 1);
 1fa:	8656                	mv	a2,s5
 1fc:	85da                	mv	a1,s6
 1fe:	4501                	li	a0,0
 200:	00000097          	auipc	ra,0x0
 204:	1a4080e7          	jalr	420(ra) # 3a4 <read>
    if(cc < 1)
 208:	00a05d63          	blez	a0,222 <gets+0x5a>
      break;
    buf[i++] = c;
 20c:	faf44783          	lbu	a5,-81(s0)
 210:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 214:	0905                	addi	s2,s2,1
 216:	ff678713          	addi	a4,a5,-10
 21a:	c319                	beqz	a4,220 <gets+0x58>
 21c:	17cd                	addi	a5,a5,-13
 21e:	fbe1                	bnez	a5,1ee <gets+0x26>
    buf[i++] = c;
 220:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 222:	9c5e                	add	s8,s8,s7
 224:	000c0023          	sb	zero,0(s8)
  return buf;
}
 228:	855e                	mv	a0,s7
 22a:	60e6                	ld	ra,88(sp)
 22c:	6446                	ld	s0,80(sp)
 22e:	64a6                	ld	s1,72(sp)
 230:	6906                	ld	s2,64(sp)
 232:	79e2                	ld	s3,56(sp)
 234:	7a42                	ld	s4,48(sp)
 236:	7aa2                	ld	s5,40(sp)
 238:	7b02                	ld	s6,32(sp)
 23a:	6be2                	ld	s7,24(sp)
 23c:	6c42                	ld	s8,16(sp)
 23e:	6125                	addi	sp,sp,96
 240:	8082                	ret

0000000000000242 <stat>:

int
stat(const char *n, struct stat *st)
{
 242:	1101                	addi	sp,sp,-32
 244:	ec06                	sd	ra,24(sp)
 246:	e822                	sd	s0,16(sp)
 248:	e04a                	sd	s2,0(sp)
 24a:	1000                	addi	s0,sp,32
 24c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24e:	4581                	li	a1,0
 250:	00000097          	auipc	ra,0x0
 254:	17c080e7          	jalr	380(ra) # 3cc <open>
  if(fd < 0)
 258:	02054663          	bltz	a0,284 <stat+0x42>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	00000097          	auipc	ra,0x0
 266:	182080e7          	jalr	386(ra) # 3e4 <fstat>
 26a:	892a                	mv	s2,a0
  close(fd);
 26c:	8526                	mv	a0,s1
 26e:	00000097          	auipc	ra,0x0
 272:	146080e7          	jalr	326(ra) # 3b4 <close>
  return r;
 276:	64a2                	ld	s1,8(sp)
}
 278:	854a                	mv	a0,s2
 27a:	60e2                	ld	ra,24(sp)
 27c:	6442                	ld	s0,16(sp)
 27e:	6902                	ld	s2,0(sp)
 280:	6105                	addi	sp,sp,32
 282:	8082                	ret
    return -1;
 284:	57fd                	li	a5,-1
 286:	893e                	mv	s2,a5
 288:	bfc5                	j	278 <stat+0x36>

000000000000028a <atoi>:

int
atoi(const char *s)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 292:	00054683          	lbu	a3,0(a0)
 296:	fd06879b          	addiw	a5,a3,-48
 29a:	0ff7f793          	zext.b	a5,a5
 29e:	4625                	li	a2,9
 2a0:	02f66963          	bltu	a2,a5,2d2 <atoi+0x48>
 2a4:	872a                	mv	a4,a0
  n = 0;
 2a6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a8:	0705                	addi	a4,a4,1
 2aa:	0025179b          	slliw	a5,a0,0x2
 2ae:	9fa9                	addw	a5,a5,a0
 2b0:	0017979b          	slliw	a5,a5,0x1
 2b4:	9fb5                	addw	a5,a5,a3
 2b6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ba:	00074683          	lbu	a3,0(a4)
 2be:	fd06879b          	addiw	a5,a3,-48
 2c2:	0ff7f793          	zext.b	a5,a5
 2c6:	fef671e3          	bgeu	a2,a5,2a8 <atoi+0x1e>
  return n;
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  n = 0;
 2d2:	4501                	li	a0,0
 2d4:	bfdd                	j	2ca <atoi+0x40>

00000000000002d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2de:	02b57563          	bgeu	a0,a1,308 <memmove+0x32>
    while(n-- > 0)
 2e2:	00c05f63          	blez	a2,300 <memmove+0x2a>
 2e6:	1602                	slli	a2,a2,0x20
 2e8:	9201                	srli	a2,a2,0x20
 2ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f0:	0585                	addi	a1,a1,1
 2f2:	0705                	addi	a4,a4,1
 2f4:	fff5c683          	lbu	a3,-1(a1)
 2f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
    while(n-- > 0)
 308:	fec05ce3          	blez	a2,300 <memmove+0x2a>
    dst += n;
 30c:	00c50733          	add	a4,a0,a2
    src += n;
 310:	95b2                	add	a1,a1,a2
 312:	fff6079b          	addiw	a5,a2,-1
 316:	1782                	slli	a5,a5,0x20
 318:	9381                	srli	a5,a5,0x20
 31a:	fff7c793          	not	a5,a5
 31e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 320:	15fd                	addi	a1,a1,-1
 322:	177d                	addi	a4,a4,-1
 324:	0005c683          	lbu	a3,0(a1)
 328:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32c:	fef71ae3          	bne	a4,a5,320 <memmove+0x4a>
 330:	bfc1                	j	300 <memmove+0x2a>

0000000000000332 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33a:	c61d                	beqz	a2,368 <memcmp+0x36>
 33c:	1602                	slli	a2,a2,0x20
 33e:	9201                	srli	a2,a2,0x20
 340:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 344:	00054783          	lbu	a5,0(a0)
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00e79863          	bne	a5,a4,35c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 350:	0505                	addi	a0,a0,1
    p2++;
 352:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 354:	fed518e3          	bne	a0,a3,344 <memcmp+0x12>
  }
  return 0;
 358:	4501                	li	a0,0
 35a:	a019                	j	360 <memcmp+0x2e>
      return *p1 - *p2;
 35c:	40e7853b          	subw	a0,a5,a4
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
  return 0;
 368:	4501                	li	a0,0
 36a:	bfdd                	j	360 <memcmp+0x2e>

000000000000036c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 374:	00000097          	auipc	ra,0x0
 378:	f62080e7          	jalr	-158(ra) # 2d6 <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 384:	4885                	li	a7,1
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit>:
.global exit
exit:
 li a7, SYS_exit
 38c:	4889                	li	a7,2
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <wait>:
.global wait
wait:
 li a7, SYS_wait
 394:	488d                	li	a7,3
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39c:	4891                	li	a7,4
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <read>:
.global read
read:
 li a7, SYS_read
 3a4:	4895                	li	a7,5
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <close>:
.global close
close:
 li a7, SYS_close
 3b4:	48d5                	li	a7,21
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3bc:	4899                	li	a7,6
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c4:	489d                	li	a7,7
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <open>:
.global open
open:
 li a7, SYS_open
 3cc:	48bd                	li	a7,15
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d4:	48c5                	li	a7,17
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3dc:	48c9                	li	a7,18
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e4:	48a1                	li	a7,8
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <link>:
.global link
link:
 li a7, SYS_link
 3ec:	48cd                	li	a7,19
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f4:	48d1                	li	a7,20
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fc:	48a5                	li	a7,9
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dup>:
.global dup
dup:
 li a7, SYS_dup
 404:	48a9                	li	a7,10
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40c:	48ad                	li	a7,11
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 414:	48b1                	li	a7,12
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41c:	48b5                	li	a7,13
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 424:	48b9                	li	a7,14
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <ps>:
.global ps
ps:
 li a7, SYS_ps
 42c:	48d9                	li	a7,22
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 434:	48dd                	li	a7,23
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 43c:	48e1                	li	a7,24
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 444:	48e9                	li	a7,26
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 44c:	48e5                	li	a7,25
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	00000097          	auipc	ra,0x0
 46a:	f46080e7          	jalr	-186(ra) # 3ac <write>
}
 46e:	60e2                	ld	ra,24(sp)
 470:	6442                	ld	s0,16(sp)
 472:	6105                	addi	sp,sp,32
 474:	8082                	ret

0000000000000476 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 476:	7139                	addi	sp,sp,-64
 478:	fc06                	sd	ra,56(sp)
 47a:	f822                	sd	s0,48(sp)
 47c:	f04a                	sd	s2,32(sp)
 47e:	ec4e                	sd	s3,24(sp)
 480:	0080                	addi	s0,sp,64
 482:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 484:	cad9                	beqz	a3,51a <printint+0xa4>
 486:	01f5d79b          	srliw	a5,a1,0x1f
 48a:	cbc1                	beqz	a5,51a <printint+0xa4>
    neg = 1;
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
    neg = 1;
 490:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 492:	fc040993          	addi	s3,s0,-64
  neg = 0;
 496:	86ce                	mv	a3,s3
  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	00000817          	auipc	a6,0x0
 49e:	4d680813          	addi	a6,a6,1238 # 970 <digits>
 4a2:	88ba                	mv	a7,a4
 4a4:	0017051b          	addiw	a0,a4,1
 4a8:	872a                	mv	a4,a0
 4aa:	02c5f7bb          	remuw	a5,a1,a2
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	97c2                	add	a5,a5,a6
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4bc:	87ae                	mv	a5,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	addi	a3,a3,1
 4c4:	fcc7ffe3          	bgeu	a5,a2,4a2 <printint+0x2c>
  if(neg)
 4c8:	00030c63          	beqz	t1,4e0 <printint+0x6a>
    buf[i++] = '-';
 4cc:	fd050793          	addi	a5,a0,-48
 4d0:	00878533          	add	a0,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef50823          	sb	a5,-16(a0)
 4dc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e0:	02e05763          	blez	a4,50e <printint+0x98>
 4e4:	f426                	sd	s1,40(sp)
 4e6:	377d                	addiw	a4,a4,-1
 4e8:	00e984b3          	add	s1,s3,a4
 4ec:	19fd                	addi	s3,s3,-1
 4ee:	99ba                	add	s3,s3,a4
 4f0:	1702                	slli	a4,a4,0x20
 4f2:	9301                	srli	a4,a4,0x20
 4f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f8:	0004c583          	lbu	a1,0(s1)
 4fc:	854a                	mv	a0,s2
 4fe:	00000097          	auipc	ra,0x0
 502:	f56080e7          	jalr	-170(ra) # 454 <putc>
  while(--i >= 0)
 506:	14fd                	addi	s1,s1,-1
 508:	ff3498e3          	bne	s1,s3,4f8 <printint+0x82>
 50c:	74a2                	ld	s1,40(sp)
}
 50e:	70e2                	ld	ra,56(sp)
 510:	7442                	ld	s0,48(sp)
 512:	7902                	ld	s2,32(sp)
 514:	69e2                	ld	s3,24(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret
  neg = 0;
 51a:	4301                	li	t1,0
 51c:	bf9d                	j	492 <printint+0x1c>

000000000000051e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51e:	715d                	addi	sp,sp,-80
 520:	e486                	sd	ra,72(sp)
 522:	e0a2                	sd	s0,64(sp)
 524:	f84a                	sd	s2,48(sp)
 526:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 528:	0005c903          	lbu	s2,0(a1)
 52c:	1a090b63          	beqz	s2,6e2 <vprintf+0x1c4>
 530:	fc26                	sd	s1,56(sp)
 532:	f44e                	sd	s3,40(sp)
 534:	f052                	sd	s4,32(sp)
 536:	ec56                	sd	s5,24(sp)
 538:	e85a                	sd	s6,16(sp)
 53a:	e45e                	sd	s7,8(sp)
 53c:	8aaa                	mv	s5,a0
 53e:	8bb2                	mv	s7,a2
 540:	00158493          	addi	s1,a1,1
  state = 0;
 544:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 546:	02500a13          	li	s4,37
 54a:	4b55                	li	s6,21
 54c:	a839                	j	56a <vprintf+0x4c>
        putc(fd, c);
 54e:	85ca                	mv	a1,s2
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	f02080e7          	jalr	-254(ra) # 454 <putc>
 55a:	a019                	j	560 <vprintf+0x42>
    } else if(state == '%'){
 55c:	01498d63          	beq	s3,s4,576 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 560:	0485                	addi	s1,s1,1
 562:	fff4c903          	lbu	s2,-1(s1)
 566:	16090863          	beqz	s2,6d6 <vprintf+0x1b8>
    if(state == 0){
 56a:	fe0999e3          	bnez	s3,55c <vprintf+0x3e>
      if(c == '%'){
 56e:	ff4910e3          	bne	s2,s4,54e <vprintf+0x30>
        state = '%';
 572:	89d2                	mv	s3,s4
 574:	b7f5                	j	560 <vprintf+0x42>
      if(c == 'd'){
 576:	13490563          	beq	s2,s4,6a0 <vprintf+0x182>
 57a:	f9d9079b          	addiw	a5,s2,-99
 57e:	0ff7f793          	zext.b	a5,a5
 582:	12fb6863          	bltu	s6,a5,6b2 <vprintf+0x194>
 586:	f9d9079b          	addiw	a5,s2,-99
 58a:	0ff7f713          	zext.b	a4,a5
 58e:	12eb6263          	bltu	s6,a4,6b2 <vprintf+0x194>
 592:	00271793          	slli	a5,a4,0x2
 596:	00000717          	auipc	a4,0x0
 59a:	38270713          	addi	a4,a4,898 # 918 <malloc+0x142>
 59e:	97ba                	add	a5,a5,a4
 5a0:	439c                	lw	a5,0(a5)
 5a2:	97ba                	add	a5,a5,a4
 5a4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4685                	li	a3,1
 5ac:	4629                	li	a2,10
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	ec2080e7          	jalr	-318(ra) # 476 <printint>
 5bc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b745                	j	560 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	ea6080e7          	jalr	-346(ra) # 476 <printint>
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b751                	j	560 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4641                	li	a2,16
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e8a080e7          	jalr	-374(ra) # 476 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b7a5                	j	560 <vprintf+0x42>
 5fa:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5fc:	008b8793          	addi	a5,s7,8
 600:	8c3e                	mv	s8,a5
 602:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 606:	03000593          	li	a1,48
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e48080e7          	jalr	-440(ra) # 454 <putc>
  putc(fd, 'x');
 614:	07800593          	li	a1,120
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e3a080e7          	jalr	-454(ra) # 454 <putc>
 622:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 624:	00000b97          	auipc	s7,0x0
 628:	34cb8b93          	addi	s7,s7,844 # 970 <digits>
 62c:	03c9d793          	srli	a5,s3,0x3c
 630:	97de                	add	a5,a5,s7
 632:	0007c583          	lbu	a1,0(a5)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e1c080e7          	jalr	-484(ra) # 454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 640:	0992                	slli	s3,s3,0x4
 642:	397d                	addiw	s2,s2,-1
 644:	fe0914e3          	bnez	s2,62c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 648:	8be2                	mv	s7,s8
      state = 0;
 64a:	4981                	li	s3,0
 64c:	6c02                	ld	s8,0(sp)
 64e:	bf09                	j	560 <vprintf+0x42>
        s = va_arg(ap, char*);
 650:	008b8993          	addi	s3,s7,8
 654:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 658:	02090163          	beqz	s2,67a <vprintf+0x15c>
        while(*s != 0){
 65c:	00094583          	lbu	a1,0(s2)
 660:	c9a5                	beqz	a1,6d0 <vprintf+0x1b2>
          putc(fd, *s);
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	df0080e7          	jalr	-528(ra) # 454 <putc>
          s++;
 66c:	0905                	addi	s2,s2,1
        while(*s != 0){
 66e:	00094583          	lbu	a1,0(s2)
 672:	f9e5                	bnez	a1,662 <vprintf+0x144>
        s = va_arg(ap, char*);
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b5e5                	j	560 <vprintf+0x42>
          s = "(null)";
 67a:	00000917          	auipc	s2,0x0
 67e:	29690913          	addi	s2,s2,662 # 910 <malloc+0x13a>
        while(*s != 0){
 682:	02800593          	li	a1,40
 686:	bff1                	j	662 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 688:	008b8913          	addi	s2,s7,8
 68c:	000bc583          	lbu	a1,0(s7)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	dc2080e7          	jalr	-574(ra) # 454 <putc>
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b5c9                	j	560 <vprintf+0x42>
        putc(fd, c);
 6a0:	02500593          	li	a1,37
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dae080e7          	jalr	-594(ra) # 454 <putc>
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bd45                	j	560 <vprintf+0x42>
        putc(fd, '%');
 6b2:	02500593          	li	a1,37
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	d9c080e7          	jalr	-612(ra) # 454 <putc>
        putc(fd, c);
 6c0:	85ca                	mv	a1,s2
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	d90080e7          	jalr	-624(ra) # 454 <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd49                	j	560 <vprintf+0x42>
        s = va_arg(ap, char*);
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b571                	j	560 <vprintf+0x42>
 6d6:	74e2                	ld	s1,56(sp)
 6d8:	79a2                	ld	s3,40(sp)
 6da:	7a02                	ld	s4,32(sp)
 6dc:	6ae2                	ld	s5,24(sp)
 6de:	6b42                	ld	s6,16(sp)
 6e0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6e2:	60a6                	ld	ra,72(sp)
 6e4:	6406                	ld	s0,64(sp)
 6e6:	7942                	ld	s2,48(sp)
 6e8:	6161                	addi	sp,sp,80
 6ea:	8082                	ret

00000000000006ec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ec:	715d                	addi	sp,sp,-80
 6ee:	ec06                	sd	ra,24(sp)
 6f0:	e822                	sd	s0,16(sp)
 6f2:	1000                	addi	s0,sp,32
 6f4:	e010                	sd	a2,0(s0)
 6f6:	e414                	sd	a3,8(s0)
 6f8:	e818                	sd	a4,16(s0)
 6fa:	ec1c                	sd	a5,24(s0)
 6fc:	03043023          	sd	a6,32(s0)
 700:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 704:	8622                	mv	a2,s0
 706:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70a:	00000097          	auipc	ra,0x0
 70e:	e14080e7          	jalr	-492(ra) # 51e <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6161                	addi	sp,sp,80
 718:	8082                	ret

000000000000071a <printf>:

void
printf(const char *fmt, ...)
{
 71a:	711d                	addi	sp,sp,-96
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	e40c                	sd	a1,8(s0)
 724:	e810                	sd	a2,16(s0)
 726:	ec14                	sd	a3,24(s0)
 728:	f018                	sd	a4,32(s0)
 72a:	f41c                	sd	a5,40(s0)
 72c:	03043823          	sd	a6,48(s0)
 730:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	00840613          	addi	a2,s0,8
 738:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73c:	85aa                	mv	a1,a0
 73e:	4505                	li	a0,1
 740:	00000097          	auipc	ra,0x0
 744:	dde080e7          	jalr	-546(ra) # 51e <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6125                	addi	sp,sp,96
 74e:	8082                	ret

0000000000000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	1141                	addi	sp,sp,-16
 752:	e406                	sd	ra,8(sp)
 754:	e022                	sd	s0,0(sp)
 756:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 758:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	00001797          	auipc	a5,0x1
 760:	8a47b783          	ld	a5,-1884(a5) # 1000 <freep>
 764:	a039                	j	772 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	6398                	ld	a4,0(a5)
 768:	00e7e463          	bltu	a5,a4,770 <free+0x20>
 76c:	00e6ea63          	bltu	a3,a4,780 <free+0x30>
{
 770:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	fed7fae3          	bgeu	a5,a3,766 <free+0x16>
 776:	6398                	ld	a4,0(a5)
 778:	00e6e463          	bltu	a3,a4,780 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	fee7eae3          	bltu	a5,a4,770 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 780:	ff852583          	lw	a1,-8(a0)
 784:	6390                	ld	a2,0(a5)
 786:	02059813          	slli	a6,a1,0x20
 78a:	01c85713          	srli	a4,a6,0x1c
 78e:	9736                	add	a4,a4,a3
 790:	02e60563          	beq	a2,a4,7ba <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 798:	4790                	lw	a2,8(a5)
 79a:	02061593          	slli	a1,a2,0x20
 79e:	01c5d713          	srli	a4,a1,0x1c
 7a2:	973e                	add	a4,a4,a5
 7a4:	02e68263          	beq	a3,a4,7c8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7aa:	00001717          	auipc	a4,0x1
 7ae:	84f73b23          	sd	a5,-1962(a4) # 1000 <freep>
}
 7b2:	60a2                	ld	ra,8(sp)
 7b4:	6402                	ld	s0,0(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ba:	4618                	lw	a4,8(a2)
 7bc:	9f2d                	addw	a4,a4,a1
 7be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	6310                	ld	a2,0(a4)
 7c6:	b7f9                	j	794 <free+0x44>
    p->s.size += bp->s.size;
 7c8:	ff852703          	lw	a4,-8(a0)
 7cc:	9f31                	addw	a4,a4,a2
 7ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d0:	ff053683          	ld	a3,-16(a0)
 7d4:	bfd1                	j	7a8 <free+0x58>

00000000000007d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d6:	7139                	addi	sp,sp,-64
 7d8:	fc06                	sd	ra,56(sp)
 7da:	f822                	sd	s0,48(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	02051993          	slli	s3,a0,0x20
 7e6:	0209d993          	srli	s3,s3,0x20
 7ea:	09bd                	addi	s3,s3,15
 7ec:	0049d993          	srli	s3,s3,0x4
 7f0:	2985                	addiw	s3,s3,1
 7f2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f4:	00001517          	auipc	a0,0x1
 7f8:	80c53503          	ld	a0,-2036(a0) # 1000 <freep>
 7fc:	c905                	beqz	a0,82c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 800:	4798                	lw	a4,8(a5)
 802:	09377a63          	bgeu	a4,s3,896 <malloc+0xc0>
 806:	f426                	sd	s1,40(sp)
 808:	e852                	sd	s4,16(sp)
 80a:	e456                	sd	s5,8(sp)
 80c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 80e:	8a4e                	mv	s4,s3
 810:	6705                	lui	a4,0x1
 812:	00e9f363          	bgeu	s3,a4,818 <malloc+0x42>
 816:	6a05                	lui	s4,0x1
 818:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 820:	00000497          	auipc	s1,0x0
 824:	7e048493          	addi	s1,s1,2016 # 1000 <freep>
  if(p == (char*)-1)
 828:	5afd                	li	s5,-1
 82a:	a089                	j	86c <malloc+0x96>
 82c:	f426                	sd	s1,40(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 834:	00000797          	auipc	a5,0x0
 838:	7dc78793          	addi	a5,a5,2012 # 1010 <base>
 83c:	00000717          	auipc	a4,0x0
 840:	7cf73223          	sd	a5,1988(a4) # 1000 <freep>
 844:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 846:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84a:	b7d1                	j	80e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 84c:	6398                	ld	a4,0(a5)
 84e:	e118                	sd	a4,0(a0)
 850:	a8b9                	j	8ae <malloc+0xd8>
  hp->s.size = nu;
 852:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 856:	0541                	addi	a0,a0,16
 858:	00000097          	auipc	ra,0x0
 85c:	ef8080e7          	jalr	-264(ra) # 750 <free>
  return freep;
 860:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 862:	c135                	beqz	a0,8c6 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	03277363          	bgeu	a4,s2,88e <malloc+0xb8>
    if(p == freep)
 86c:	6098                	ld	a4,0(s1)
 86e:	853e                	mv	a0,a5
 870:	fef71ae3          	bne	a4,a5,864 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 874:	8552                	mv	a0,s4
 876:	00000097          	auipc	ra,0x0
 87a:	b9e080e7          	jalr	-1122(ra) # 414 <sbrk>
  if(p == (char*)-1)
 87e:	fd551ae3          	bne	a0,s5,852 <malloc+0x7c>
        return 0;
 882:	4501                	li	a0,0
 884:	74a2                	ld	s1,40(sp)
 886:	6a42                	ld	s4,16(sp)
 888:	6aa2                	ld	s5,8(sp)
 88a:	6b02                	ld	s6,0(sp)
 88c:	a03d                	j	8ba <malloc+0xe4>
 88e:	74a2                	ld	s1,40(sp)
 890:	6a42                	ld	s4,16(sp)
 892:	6aa2                	ld	s5,8(sp)
 894:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 896:	fae90be3          	beq	s2,a4,84c <malloc+0x76>
        p->s.size -= nunits;
 89a:	4137073b          	subw	a4,a4,s3
 89e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a0:	02071693          	slli	a3,a4,0x20
 8a4:	01c6d713          	srli	a4,a3,0x1c
 8a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ae:	00000717          	auipc	a4,0x0
 8b2:	74a73923          	sd	a0,1874(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b6:	01078513          	addi	a0,a5,16
  }
}
 8ba:	70e2                	ld	ra,56(sp)
 8bc:	7442                	ld	s0,48(sp)
 8be:	7902                	ld	s2,32(sp)
 8c0:	69e2                	ld	s3,24(sp)
 8c2:	6121                	addi	sp,sp,64
 8c4:	8082                	ret
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
 8ce:	b7f5                	j	8ba <malloc+0xe4>
