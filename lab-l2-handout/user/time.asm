
user/_time:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    if (argc < 2)
   8:	4785                	li	a5,1
   a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	84ae                	mv	s1,a1
        printf("Time took 0 ticks\n");
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
        exit(1);
    }

    int startticks = uptime();
  14:	00000097          	auipc	ra,0x0
  18:	3e4080e7          	jalr	996(ra) # 3f8 <uptime>
  1c:	892a                	mv	s2,a0

    // we now start the program in a separate process:
    int uutPid = fork();
  1e:	00000097          	auipc	ra,0x0
  22:	33a080e7          	jalr	826(ra) # 358 <fork>

    // check if fork worked:
    if (uutPid < 0)
  26:	04054663          	bltz	a0,72 <main+0x72>
    {
        printf("fork failed... couldn't start %s", argv[1]);
        exit(1);
    }

    if (uutPid == 0)
  2a:	e135                	bnez	a0,8e <main+0x8e>
    {
        // we are the unit under test part of the program - execute the program immediately
        exec(argv[1], argv + 1); // pass rest of the command line to the executable as args
  2c:	00848593          	addi	a1,s1,8
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	366080e7          	jalr	870(ra) # 398 <exec>
        // wait for the uut to finish
        wait(0);
        int endticks = uptime();
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
    }
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	324080e7          	jalr	804(ra) # 360 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
        printf("Time took 0 ticks\n");
  48:	00001517          	auipc	a0,0x1
  4c:	85850513          	addi	a0,a0,-1960 # 8a0 <malloc+0xfe>
  50:	00000097          	auipc	ra,0x0
  54:	696080e7          	jalr	1686(ra) # 6e6 <printf>
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
  58:	00001517          	auipc	a0,0x1
  5c:	86050513          	addi	a0,a0,-1952 # 8b8 <malloc+0x116>
  60:	00000097          	auipc	ra,0x0
  64:	686080e7          	jalr	1670(ra) # 6e6 <printf>
        exit(1);
  68:	4505                	li	a0,1
  6a:	00000097          	auipc	ra,0x0
  6e:	2f6080e7          	jalr	758(ra) # 360 <exit>
        printf("fork failed... couldn't start %s", argv[1]);
  72:	648c                	ld	a1,8(s1)
  74:	00001517          	auipc	a0,0x1
  78:	86c50513          	addi	a0,a0,-1940 # 8e0 <malloc+0x13e>
  7c:	00000097          	auipc	ra,0x0
  80:	66a080e7          	jalr	1642(ra) # 6e6 <printf>
        exit(1);
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	2da080e7          	jalr	730(ra) # 360 <exit>
        wait(0);
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	2d8080e7          	jalr	728(ra) # 368 <wait>
        int endticks = uptime();
  98:	00000097          	auipc	ra,0x0
  9c:	360080e7          	jalr	864(ra) # 3f8 <uptime>
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
  a0:	4125063b          	subw	a2,a0,s2
  a4:	648c                	ld	a1,8(s1)
  a6:	00001517          	auipc	a0,0x1
  aa:	86250513          	addi	a0,a0,-1950 # 908 <malloc+0x166>
  ae:	00000097          	auipc	ra,0x0
  b2:	638080e7          	jalr	1592(ra) # 6e6 <printf>
  b6:	b751                	j	3a <main+0x3a>

00000000000000b8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c0:	00000097          	auipc	ra,0x0
  c4:	f40080e7          	jalr	-192(ra) # 0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	00000097          	auipc	ra,0x0
  ce:	296080e7          	jalr	662(ra) # 360 <exit>

00000000000000d2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	addi	a1,a1,1
  de:	0785                	addi	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0xa>
    ;
  return os;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb91                	beqz	a5,112 <strcmp+0x20>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71763          	bne	a4,a5,112 <strcmp+0x20>
    p++, q++;
 108:	0505                	addi	a0,a0,1
 10a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbe5                	bnez	a5,100 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 112:	0005c503          	lbu	a0,0(a1)
}
 116:	40a7853b          	subw	a0,a5,a0
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf91                	beqz	a5,14a <strlen+0x28>
 130:	00150793          	addi	a5,a0,1
 134:	86be                	mv	a3,a5
 136:	0785                	addi	a5,a5,1
 138:	fff7c703          	lbu	a4,-1(a5)
 13c:	ff65                	bnez	a4,134 <strlen+0x12>
 13e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  for(n = 0; s[n]; n++)
 14a:	4501                	li	a0,0
 14c:	bfdd                	j	142 <strlen+0x20>

000000000000014e <memset>:

void*
memset(void *dst, int c, uint n)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 156:	ca19                	beqz	a2,16c <memset+0x1e>
 158:	87aa                	mv	a5,a0
 15a:	1602                	slli	a2,a2,0x20
 15c:	9201                	srli	a2,a2,0x20
 15e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 166:	0785                	addi	a5,a5,1
 168:	fee79de3          	bne	a5,a4,162 <memset+0x14>
  }
  return dst;
}
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret

0000000000000174 <strchr>:

char*
strchr(const char *s, char c)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17c:	00054783          	lbu	a5,0(a0)
 180:	cf81                	beqz	a5,198 <strchr+0x24>
    if(*s == c)
 182:	00f58763          	beq	a1,a5,190 <strchr+0x1c>
  for(; *s; s++)
 186:	0505                	addi	a0,a0,1
 188:	00054783          	lbu	a5,0(a0)
 18c:	fbfd                	bnez	a5,182 <strchr+0xe>
      return (char*)s;
  return 0;
 18e:	4501                	li	a0,0
}
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret
  return 0;
 198:	4501                	li	a0,0
 19a:	bfdd                	j	190 <strchr+0x1c>

000000000000019c <gets>:

char*
gets(char *buf, int max)
{
 19c:	711d                	addi	sp,sp,-96
 19e:	ec86                	sd	ra,88(sp)
 1a0:	e8a2                	sd	s0,80(sp)
 1a2:	e4a6                	sd	s1,72(sp)
 1a4:	e0ca                	sd	s2,64(sp)
 1a6:	fc4e                	sd	s3,56(sp)
 1a8:	f852                	sd	s4,48(sp)
 1aa:	f456                	sd	s5,40(sp)
 1ac:	f05a                	sd	s6,32(sp)
 1ae:	ec5e                	sd	s7,24(sp)
 1b0:	e862                	sd	s8,16(sp)
 1b2:	1080                	addi	s0,sp,96
 1b4:	8baa                	mv	s7,a0
 1b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b8:	892a                	mv	s2,a0
 1ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1bc:	faf40b13          	addi	s6,s0,-81
 1c0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1c2:	8c26                	mv	s8,s1
 1c4:	0014899b          	addiw	s3,s1,1
 1c8:	84ce                	mv	s1,s3
 1ca:	0349d663          	bge	s3,s4,1f6 <gets+0x5a>
    cc = read(0, &c, 1);
 1ce:	8656                	mv	a2,s5
 1d0:	85da                	mv	a1,s6
 1d2:	4501                	li	a0,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	1a4080e7          	jalr	420(ra) # 378 <read>
    if(cc < 1)
 1dc:	00a05d63          	blez	a0,1f6 <gets+0x5a>
      break;
    buf[i++] = c;
 1e0:	faf44783          	lbu	a5,-81(s0)
 1e4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e8:	0905                	addi	s2,s2,1
 1ea:	ff678713          	addi	a4,a5,-10
 1ee:	c319                	beqz	a4,1f4 <gets+0x58>
 1f0:	17cd                	addi	a5,a5,-13
 1f2:	fbe1                	bnez	a5,1c2 <gets+0x26>
    buf[i++] = c;
 1f4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f6:	9c5e                	add	s8,s8,s7
 1f8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1fc:	855e                	mv	a0,s7
 1fe:	60e6                	ld	ra,88(sp)
 200:	6446                	ld	s0,80(sp)
 202:	64a6                	ld	s1,72(sp)
 204:	6906                	ld	s2,64(sp)
 206:	79e2                	ld	s3,56(sp)
 208:	7a42                	ld	s4,48(sp)
 20a:	7aa2                	ld	s5,40(sp)
 20c:	7b02                	ld	s6,32(sp)
 20e:	6be2                	ld	s7,24(sp)
 210:	6c42                	ld	s8,16(sp)
 212:	6125                	addi	sp,sp,96
 214:	8082                	ret

0000000000000216 <stat>:

int
stat(const char *n, struct stat *st)
{
 216:	1101                	addi	sp,sp,-32
 218:	ec06                	sd	ra,24(sp)
 21a:	e822                	sd	s0,16(sp)
 21c:	e04a                	sd	s2,0(sp)
 21e:	1000                	addi	s0,sp,32
 220:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 222:	4581                	li	a1,0
 224:	00000097          	auipc	ra,0x0
 228:	17c080e7          	jalr	380(ra) # 3a0 <open>
  if(fd < 0)
 22c:	02054663          	bltz	a0,258 <stat+0x42>
 230:	e426                	sd	s1,8(sp)
 232:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 234:	85ca                	mv	a1,s2
 236:	00000097          	auipc	ra,0x0
 23a:	182080e7          	jalr	386(ra) # 3b8 <fstat>
 23e:	892a                	mv	s2,a0
  close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	146080e7          	jalr	326(ra) # 388 <close>
  return r;
 24a:	64a2                	ld	s1,8(sp)
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	6902                	ld	s2,0(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret
    return -1;
 258:	57fd                	li	a5,-1
 25a:	893e                	mv	s2,a5
 25c:	bfc5                	j	24c <stat+0x36>

000000000000025e <atoi>:

int
atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 266:	00054683          	lbu	a3,0(a0)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	4625                	li	a2,9
 274:	02f66963          	bltu	a2,a5,2a6 <atoi+0x48>
 278:	872a                	mv	a4,a0
  n = 0;
 27a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27c:	0705                	addi	a4,a4,1
 27e:	0025179b          	slliw	a5,a0,0x2
 282:	9fa9                	addw	a5,a5,a0
 284:	0017979b          	slliw	a5,a5,0x1
 288:	9fb5                	addw	a5,a5,a3
 28a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28e:	00074683          	lbu	a3,0(a4)
 292:	fd06879b          	addiw	a5,a3,-48
 296:	0ff7f793          	zext.b	a5,a5
 29a:	fef671e3          	bgeu	a2,a5,27c <atoi+0x1e>
  return n;
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  n = 0;
 2a6:	4501                	li	a0,0
 2a8:	bfdd                	j	29e <atoi+0x40>

00000000000002aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b2:	02b57563          	bgeu	a0,a1,2dc <memmove+0x32>
    while(n-- > 0)
 2b6:	00c05f63          	blez	a2,2d4 <memmove+0x2a>
 2ba:	1602                	slli	a2,a2,0x20
 2bc:	9201                	srli	a2,a2,0x20
 2be:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c4:	0585                	addi	a1,a1,1
 2c6:	0705                	addi	a4,a4,1
 2c8:	fff5c683          	lbu	a3,-1(a1)
 2cc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d0:	fee79ae3          	bne	a5,a4,2c4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
    while(n-- > 0)
 2dc:	fec05ce3          	blez	a2,2d4 <memmove+0x2a>
    dst += n;
 2e0:	00c50733          	add	a4,a0,a2
    src += n;
 2e4:	95b2                	add	a1,a1,a2
 2e6:	fff6079b          	addiw	a5,a2,-1
 2ea:	1782                	slli	a5,a5,0x20
 2ec:	9381                	srli	a5,a5,0x20
 2ee:	fff7c793          	not	a5,a5
 2f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f4:	15fd                	addi	a1,a1,-1
 2f6:	177d                	addi	a4,a4,-1
 2f8:	0005c683          	lbu	a3,0(a1)
 2fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 300:	fef71ae3          	bne	a4,a5,2f4 <memmove+0x4a>
 304:	bfc1                	j	2d4 <memmove+0x2a>

0000000000000306 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30e:	c61d                	beqz	a2,33c <memcmp+0x36>
 310:	1602                	slli	a2,a2,0x20
 312:	9201                	srli	a2,a2,0x20
 314:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 318:	00054783          	lbu	a5,0(a0)
 31c:	0005c703          	lbu	a4,0(a1)
 320:	00e79863          	bne	a5,a4,330 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 324:	0505                	addi	a0,a0,1
    p2++;
 326:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 328:	fed518e3          	bne	a0,a3,318 <memcmp+0x12>
  }
  return 0;
 32c:	4501                	li	a0,0
 32e:	a019                	j	334 <memcmp+0x2e>
      return *p1 - *p2;
 330:	40e7853b          	subw	a0,a5,a4
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfdd                	j	334 <memcmp+0x2e>

0000000000000340 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 348:	00000097          	auipc	ra,0x0
 34c:	f62080e7          	jalr	-158(ra) # 2aa <memmove>
}
 350:	60a2                	ld	ra,8(sp)
 352:	6402                	ld	s0,0(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 358:	4885                	li	a7,1
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <exit>:
.global exit
exit:
 li a7, SYS_exit
 360:	4889                	li	a7,2
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <wait>:
.global wait
wait:
 li a7, SYS_wait
 368:	488d                	li	a7,3
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 370:	4891                	li	a7,4
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <read>:
.global read
read:
 li a7, SYS_read
 378:	4895                	li	a7,5
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <write>:
.global write
write:
 li a7, SYS_write
 380:	48c1                	li	a7,16
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <close>:
.global close
close:
 li a7, SYS_close
 388:	48d5                	li	a7,21
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <kill>:
.global kill
kill:
 li a7, SYS_kill
 390:	4899                	li	a7,6
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exec>:
.global exec
exec:
 li a7, SYS_exec
 398:	489d                	li	a7,7
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <open>:
.global open
open:
 li a7, SYS_open
 3a0:	48bd                	li	a7,15
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a8:	48c5                	li	a7,17
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b0:	48c9                	li	a7,18
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b8:	48a1                	li	a7,8
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <link>:
.global link
link:
 li a7, SYS_link
 3c0:	48cd                	li	a7,19
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c8:	48d1                	li	a7,20
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d0:	48a5                	li	a7,9
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d8:	48a9                	li	a7,10
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e0:	48ad                	li	a7,11
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3e8:	48b1                	li	a7,12
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f0:	48b5                	li	a7,13
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f8:	48b9                	li	a7,14
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <ps>:
.global ps
ps:
 li a7, SYS_ps
 400:	48d9                	li	a7,22
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 408:	48dd                	li	a7,23
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 410:	48e1                	li	a7,24
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <yield>:
.global yield
yield:
 li a7, SYS_yield
 418:	48e5                	li	a7,25
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	1000                	addi	s0,sp,32
 428:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42c:	4605                	li	a2,1
 42e:	fef40593          	addi	a1,s0,-17
 432:	00000097          	auipc	ra,0x0
 436:	f4e080e7          	jalr	-178(ra) # 380 <write>
}
 43a:	60e2                	ld	ra,24(sp)
 43c:	6442                	ld	s0,16(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret

0000000000000442 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 442:	7139                	addi	sp,sp,-64
 444:	fc06                	sd	ra,56(sp)
 446:	f822                	sd	s0,48(sp)
 448:	f04a                	sd	s2,32(sp)
 44a:	ec4e                	sd	s3,24(sp)
 44c:	0080                	addi	s0,sp,64
 44e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 450:	cad9                	beqz	a3,4e6 <printint+0xa4>
 452:	01f5d79b          	srliw	a5,a1,0x1f
 456:	cbc1                	beqz	a5,4e6 <printint+0xa4>
    neg = 1;
    x = -xx;
 458:	40b005bb          	negw	a1,a1
    neg = 1;
 45c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 45e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 462:	86ce                	mv	a3,s3
  i = 0;
 464:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 466:	00000817          	auipc	a6,0x0
 46a:	52280813          	addi	a6,a6,1314 # 988 <digits>
 46e:	88ba                	mv	a7,a4
 470:	0017051b          	addiw	a0,a4,1
 474:	872a                	mv	a4,a0
 476:	02c5f7bb          	remuw	a5,a1,a2
 47a:	1782                	slli	a5,a5,0x20
 47c:	9381                	srli	a5,a5,0x20
 47e:	97c2                	add	a5,a5,a6
 480:	0007c783          	lbu	a5,0(a5)
 484:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 488:	87ae                	mv	a5,a1
 48a:	02c5d5bb          	divuw	a1,a1,a2
 48e:	0685                	addi	a3,a3,1
 490:	fcc7ffe3          	bgeu	a5,a2,46e <printint+0x2c>
  if(neg)
 494:	00030c63          	beqz	t1,4ac <printint+0x6a>
    buf[i++] = '-';
 498:	fd050793          	addi	a5,a0,-48
 49c:	00878533          	add	a0,a5,s0
 4a0:	02d00793          	li	a5,45
 4a4:	fef50823          	sb	a5,-16(a0)
 4a8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ac:	02e05763          	blez	a4,4da <printint+0x98>
 4b0:	f426                	sd	s1,40(sp)
 4b2:	377d                	addiw	a4,a4,-1
 4b4:	00e984b3          	add	s1,s3,a4
 4b8:	19fd                	addi	s3,s3,-1
 4ba:	99ba                	add	s3,s3,a4
 4bc:	1702                	slli	a4,a4,0x20
 4be:	9301                	srli	a4,a4,0x20
 4c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c4:	0004c583          	lbu	a1,0(s1)
 4c8:	854a                	mv	a0,s2
 4ca:	00000097          	auipc	ra,0x0
 4ce:	f56080e7          	jalr	-170(ra) # 420 <putc>
  while(--i >= 0)
 4d2:	14fd                	addi	s1,s1,-1
 4d4:	ff3498e3          	bne	s1,s3,4c4 <printint+0x82>
 4d8:	74a2                	ld	s1,40(sp)
}
 4da:	70e2                	ld	ra,56(sp)
 4dc:	7442                	ld	s0,48(sp)
 4de:	7902                	ld	s2,32(sp)
 4e0:	69e2                	ld	s3,24(sp)
 4e2:	6121                	addi	sp,sp,64
 4e4:	8082                	ret
  neg = 0;
 4e6:	4301                	li	t1,0
 4e8:	bf9d                	j	45e <printint+0x1c>

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	715d                	addi	sp,sp,-80
 4ec:	e486                	sd	ra,72(sp)
 4ee:	e0a2                	sd	s0,64(sp)
 4f0:	f84a                	sd	s2,48(sp)
 4f2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f4:	0005c903          	lbu	s2,0(a1)
 4f8:	1a090b63          	beqz	s2,6ae <vprintf+0x1c4>
 4fc:	fc26                	sd	s1,56(sp)
 4fe:	f44e                	sd	s3,40(sp)
 500:	f052                	sd	s4,32(sp)
 502:	ec56                	sd	s5,24(sp)
 504:	e85a                	sd	s6,16(sp)
 506:	e45e                	sd	s7,8(sp)
 508:	8aaa                	mv	s5,a0
 50a:	8bb2                	mv	s7,a2
 50c:	00158493          	addi	s1,a1,1
  state = 0;
 510:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 512:	02500a13          	li	s4,37
 516:	4b55                	li	s6,21
 518:	a839                	j	536 <vprintf+0x4c>
        putc(fd, c);
 51a:	85ca                	mv	a1,s2
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	f02080e7          	jalr	-254(ra) # 420 <putc>
 526:	a019                	j	52c <vprintf+0x42>
    } else if(state == '%'){
 528:	01498d63          	beq	s3,s4,542 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 52c:	0485                	addi	s1,s1,1
 52e:	fff4c903          	lbu	s2,-1(s1)
 532:	16090863          	beqz	s2,6a2 <vprintf+0x1b8>
    if(state == 0){
 536:	fe0999e3          	bnez	s3,528 <vprintf+0x3e>
      if(c == '%'){
 53a:	ff4910e3          	bne	s2,s4,51a <vprintf+0x30>
        state = '%';
 53e:	89d2                	mv	s3,s4
 540:	b7f5                	j	52c <vprintf+0x42>
      if(c == 'd'){
 542:	13490563          	beq	s2,s4,66c <vprintf+0x182>
 546:	f9d9079b          	addiw	a5,s2,-99
 54a:	0ff7f793          	zext.b	a5,a5
 54e:	12fb6863          	bltu	s6,a5,67e <vprintf+0x194>
 552:	f9d9079b          	addiw	a5,s2,-99
 556:	0ff7f713          	zext.b	a4,a5
 55a:	12eb6263          	bltu	s6,a4,67e <vprintf+0x194>
 55e:	00271793          	slli	a5,a4,0x2
 562:	00000717          	auipc	a4,0x0
 566:	3ce70713          	addi	a4,a4,974 # 930 <malloc+0x18e>
 56a:	97ba                	add	a5,a5,a4
 56c:	439c                	lw	a5,0(a5)
 56e:	97ba                	add	a5,a5,a4
 570:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b8913          	addi	s2,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	ec2080e7          	jalr	-318(ra) # 442 <printint>
 588:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b745                	j	52c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b8913          	addi	s2,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000ba583          	lw	a1,0(s7)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	ea6080e7          	jalr	-346(ra) # 442 <printint>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b751                	j	52c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e8a080e7          	jalr	-374(ra) # 442 <printint>
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b7a5                	j	52c <vprintf+0x42>
 5c6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5c8:	008b8793          	addi	a5,s7,8
 5cc:	8c3e                	mv	s8,a5
 5ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e48080e7          	jalr	-440(ra) # 420 <putc>
  putc(fd, 'x');
 5e0:	07800593          	li	a1,120
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e3a080e7          	jalr	-454(ra) # 420 <putc>
 5ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	00000b97          	auipc	s7,0x0
 5f4:	398b8b93          	addi	s7,s7,920 # 988 <digits>
 5f8:	03c9d793          	srli	a5,s3,0x3c
 5fc:	97de                	add	a5,a5,s7
 5fe:	0007c583          	lbu	a1,0(a5)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e1c080e7          	jalr	-484(ra) # 420 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60c:	0992                	slli	s3,s3,0x4
 60e:	397d                	addiw	s2,s2,-1
 610:	fe0914e3          	bnez	s2,5f8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 614:	8be2                	mv	s7,s8
      state = 0;
 616:	4981                	li	s3,0
 618:	6c02                	ld	s8,0(sp)
 61a:	bf09                	j	52c <vprintf+0x42>
        s = va_arg(ap, char*);
 61c:	008b8993          	addi	s3,s7,8
 620:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 624:	02090163          	beqz	s2,646 <vprintf+0x15c>
        while(*s != 0){
 628:	00094583          	lbu	a1,0(s2)
 62c:	c9a5                	beqz	a1,69c <vprintf+0x1b2>
          putc(fd, *s);
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	df0080e7          	jalr	-528(ra) # 420 <putc>
          s++;
 638:	0905                	addi	s2,s2,1
        while(*s != 0){
 63a:	00094583          	lbu	a1,0(s2)
 63e:	f9e5                	bnez	a1,62e <vprintf+0x144>
        s = va_arg(ap, char*);
 640:	8bce                	mv	s7,s3
      state = 0;
 642:	4981                	li	s3,0
 644:	b5e5                	j	52c <vprintf+0x42>
          s = "(null)";
 646:	00000917          	auipc	s2,0x0
 64a:	2e290913          	addi	s2,s2,738 # 928 <malloc+0x186>
        while(*s != 0){
 64e:	02800593          	li	a1,40
 652:	bff1                	j	62e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 654:	008b8913          	addi	s2,s7,8
 658:	000bc583          	lbu	a1,0(s7)
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	dc2080e7          	jalr	-574(ra) # 420 <putc>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b5c9                	j	52c <vprintf+0x42>
        putc(fd, c);
 66c:	02500593          	li	a1,37
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	dae080e7          	jalr	-594(ra) # 420 <putc>
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd45                	j	52c <vprintf+0x42>
        putc(fd, '%');
 67e:	02500593          	li	a1,37
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	d9c080e7          	jalr	-612(ra) # 420 <putc>
        putc(fd, c);
 68c:	85ca                	mv	a1,s2
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	d90080e7          	jalr	-624(ra) # 420 <putc>
      state = 0;
 698:	4981                	li	s3,0
 69a:	bd49                	j	52c <vprintf+0x42>
        s = va_arg(ap, char*);
 69c:	8bce                	mv	s7,s3
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b571                	j	52c <vprintf+0x42>
 6a2:	74e2                	ld	s1,56(sp)
 6a4:	79a2                	ld	s3,40(sp)
 6a6:	7a02                	ld	s4,32(sp)
 6a8:	6ae2                	ld	s5,24(sp)
 6aa:	6b42                	ld	s6,16(sp)
 6ac:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ae:	60a6                	ld	ra,72(sp)
 6b0:	6406                	ld	s0,64(sp)
 6b2:	7942                	ld	s2,48(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	8622                	mv	a2,s0
 6d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d6:	00000097          	auipc	ra,0x0
 6da:	e14080e7          	jalr	-492(ra) # 4ea <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <printf>:

void
printf(const char *fmt, ...)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e40c                	sd	a1,8(s0)
 6f0:	e810                	sd	a2,16(s0)
 6f2:	ec14                	sd	a3,24(s0)
 6f4:	f018                	sd	a4,32(s0)
 6f6:	f41c                	sd	a5,40(s0)
 6f8:	03043823          	sd	a6,48(s0)
 6fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	00840613          	addi	a2,s0,8
 704:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 708:	85aa                	mv	a1,a0
 70a:	4505                	li	a0,1
 70c:	00000097          	auipc	ra,0x0
 710:	dde080e7          	jalr	-546(ra) # 4ea <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e406                	sd	ra,8(sp)
 720:	e022                	sd	s0,0(sp)
 722:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 724:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	00001797          	auipc	a5,0x1
 72c:	8d87b783          	ld	a5,-1832(a5) # 1000 <freep>
 730:	a039                	j	73e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	6398                	ld	a4,0(a5)
 734:	00e7e463          	bltu	a5,a4,73c <free+0x20>
 738:	00e6ea63          	bltu	a3,a4,74c <free+0x30>
{
 73c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	fed7fae3          	bgeu	a5,a3,732 <free+0x16>
 742:	6398                	ld	a4,0(a5)
 744:	00e6e463          	bltu	a3,a4,74c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	fee7eae3          	bltu	a5,a4,73c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 74c:	ff852583          	lw	a1,-8(a0)
 750:	6390                	ld	a2,0(a5)
 752:	02059813          	slli	a6,a1,0x20
 756:	01c85713          	srli	a4,a6,0x1c
 75a:	9736                	add	a4,a4,a3
 75c:	02e60563          	beq	a2,a4,786 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 764:	4790                	lw	a2,8(a5)
 766:	02061593          	slli	a1,a2,0x20
 76a:	01c5d713          	srli	a4,a1,0x1c
 76e:	973e                	add	a4,a4,a5
 770:	02e68263          	beq	a3,a4,794 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 774:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 776:	00001717          	auipc	a4,0x1
 77a:	88f73523          	sd	a5,-1910(a4) # 1000 <freep>
}
 77e:	60a2                	ld	ra,8(sp)
 780:	6402                	ld	s0,0(sp)
 782:	0141                	addi	sp,sp,16
 784:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 786:	4618                	lw	a4,8(a2)
 788:	9f2d                	addw	a4,a4,a1
 78a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	6398                	ld	a4,0(a5)
 790:	6310                	ld	a2,0(a4)
 792:	b7f9                	j	760 <free+0x44>
    p->s.size += bp->s.size;
 794:	ff852703          	lw	a4,-8(a0)
 798:	9f31                	addw	a4,a4,a2
 79a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 79c:	ff053683          	ld	a3,-16(a0)
 7a0:	bfd1                	j	774 <free+0x58>

00000000000007a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f04a                	sd	s2,32(sp)
 7aa:	ec4e                	sd	s3,24(sp)
 7ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	02051993          	slli	s3,a0,0x20
 7b2:	0209d993          	srli	s3,s3,0x20
 7b6:	09bd                	addi	s3,s3,15
 7b8:	0049d993          	srli	s3,s3,0x4
 7bc:	2985                	addiw	s3,s3,1
 7be:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c0:	00001517          	auipc	a0,0x1
 7c4:	84053503          	ld	a0,-1984(a0) # 1000 <freep>
 7c8:	c905                	beqz	a0,7f8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	09377a63          	bgeu	a4,s3,862 <malloc+0xc0>
 7d2:	f426                	sd	s1,40(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7da:	8a4e                	mv	s4,s3
 7dc:	6705                	lui	a4,0x1
 7de:	00e9f363          	bgeu	s3,a4,7e4 <malloc+0x42>
 7e2:	6a05                	lui	s4,0x1
 7e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ec:	00001497          	auipc	s1,0x1
 7f0:	81448493          	addi	s1,s1,-2028 # 1000 <freep>
  if(p == (char*)-1)
 7f4:	5afd                	li	s5,-1
 7f6:	a089                	j	838 <malloc+0x96>
 7f8:	f426                	sd	s1,40(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 800:	00001797          	auipc	a5,0x1
 804:	81078793          	addi	a5,a5,-2032 # 1010 <base>
 808:	00000717          	auipc	a4,0x0
 80c:	7ef73c23          	sd	a5,2040(a4) # 1000 <freep>
 810:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 812:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 816:	b7d1                	j	7da <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 818:	6398                	ld	a4,0(a5)
 81a:	e118                	sd	a4,0(a0)
 81c:	a8b9                	j	87a <malloc+0xd8>
  hp->s.size = nu;
 81e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 822:	0541                	addi	a0,a0,16
 824:	00000097          	auipc	ra,0x0
 828:	ef8080e7          	jalr	-264(ra) # 71c <free>
  return freep;
 82c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 82e:	c135                	beqz	a0,892 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 832:	4798                	lw	a4,8(a5)
 834:	03277363          	bgeu	a4,s2,85a <malloc+0xb8>
    if(p == freep)
 838:	6098                	ld	a4,0(s1)
 83a:	853e                	mv	a0,a5
 83c:	fef71ae3          	bne	a4,a5,830 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 840:	8552                	mv	a0,s4
 842:	00000097          	auipc	ra,0x0
 846:	ba6080e7          	jalr	-1114(ra) # 3e8 <sbrk>
  if(p == (char*)-1)
 84a:	fd551ae3          	bne	a0,s5,81e <malloc+0x7c>
        return 0;
 84e:	4501                	li	a0,0
 850:	74a2                	ld	s1,40(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
 858:	a03d                	j	886 <malloc+0xe4>
 85a:	74a2                	ld	s1,40(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 862:	fae90be3          	beq	s2,a4,818 <malloc+0x76>
        p->s.size -= nunits;
 866:	4137073b          	subw	a4,a4,s3
 86a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86c:	02071693          	slli	a3,a4,0x20
 870:	01c6d713          	srli	a4,a3,0x1c
 874:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 876:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87a:	00000717          	auipc	a4,0x0
 87e:	78a73323          	sd	a0,1926(a4) # 1000 <freep>
      return (void*)(p + 1);
 882:	01078513          	addi	a0,a5,16
  }
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
 892:	74a2                	ld	s1,40(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	b7f5                	j	886 <malloc+0xe4>
