
user/_vatopa:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <parse_uint64>:
    return -1;
}

static uint64
parse_uint64(const char *s)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	86aa                	mv	a3,a0
    uint64 value = 0;
    int base = 10;
    int digit;

    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
   a:	00054703          	lbu	a4,0(a0)
   e:	03000793          	li	a5,48
    int base = 10;
  12:	4629                	li	a2,10
    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
  14:	00f70663          	beq	a4,a5,20 <parse_uint64+0x20>
    int base = 10;
  18:	4501                	li	a0,0
    if (c >= '0' && c <= '9')
  1a:	4825                	li	a6,9
    if (c >= 'a' && c <= 'f')
  1c:	4595                	li	a1,5
  1e:	a805                	j	4e <parse_uint64+0x4e>
    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
  20:	00154783          	lbu	a5,1(a0)
  24:	0df7f793          	andi	a5,a5,223
  28:	05800713          	li	a4,88
  2c:	fee796e3          	bne	a5,a4,18 <parse_uint64+0x18>
    {
        base = 16;
        s += 2;
  30:	00250693          	addi	a3,a0,2
        base = 16;
  34:	4641                	li	a2,16
  36:	b7cd                	j	18 <parse_uint64+0x18>
        return c - '0';
  38:	fd07879b          	addiw	a5,a5,-48
  3c:	a029                	j	46 <parse_uint64+0x46>
        return c - 'a' + 10;
  3e:	fa97879b          	addiw	a5,a5,-87
    }

    while ((digit = digit_value(*s)) >= 0 && digit < base)
  42:	02c7fd63          	bgeu	a5,a2,7c <parse_uint64+0x7c>
    {
        value = value * base + digit;
  46:	02a60533          	mul	a0,a2,a0
  4a:	953e                	add	a0,a0,a5
        s++;
  4c:	0685                	addi	a3,a3,1
    while ((digit = digit_value(*s)) >= 0 && digit < base)
  4e:	0006c783          	lbu	a5,0(a3)
    if (c >= '0' && c <= '9')
  52:	fd07871b          	addiw	a4,a5,-48
  56:	0ff77713          	zext.b	a4,a4
  5a:	fce87fe3          	bgeu	a6,a4,38 <parse_uint64+0x38>
    if (c >= 'a' && c <= 'f')
  5e:	f9f7871b          	addiw	a4,a5,-97
  62:	0ff77713          	zext.b	a4,a4
  66:	fce5fce3          	bgeu	a1,a4,3e <parse_uint64+0x3e>
    if (c >= 'A' && c <= 'F')
  6a:	fbf7871b          	addiw	a4,a5,-65
  6e:	0ff77713          	zext.b	a4,a4
  72:	00e5e563          	bltu	a1,a4,7c <parse_uint64+0x7c>
        return c - 'A' + 10;
  76:	fc97879b          	addiw	a5,a5,-55
  7a:	b7e1                	j	42 <parse_uint64+0x42>
    }

    return value;
}
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <main>:

int
main(int argc, char *argv[])
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	1800                	addi	s0,sp,48
    uint64 va;
    int pid = 0;

    if (argc != 2 && argc != 3)
  8c:	ffe5071b          	addiw	a4,a0,-2
  90:	4785                	li	a5,1
  92:	02e7f263          	bgeu	a5,a4,b6 <main+0x32>
  96:	ec26                	sd	s1,24(sp)
  98:	e84a                	sd	s2,16(sp)
  9a:	e44e                	sd	s3,8(sp)
    {
        printf("Usage: vatopa virtual_address [pid]\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	86450513          	addi	a0,a0,-1948 # 900 <malloc+0x100>
  a4:	00000097          	auipc	ra,0x0
  a8:	6a0080e7          	jalr	1696(ra) # 744 <printf>
        exit(1);
  ac:	4505                	li	a0,1
  ae:	00000097          	auipc	ra,0x0
  b2:	308080e7          	jalr	776(ra) # 3b6 <exit>
  b6:	ec26                	sd	s1,24(sp)
  b8:	e84a                	sd	s2,16(sp)
  ba:	e44e                	sd	s3,8(sp)
  bc:	84aa                	mv	s1,a0
  be:	892e                	mv	s2,a1
    }

    va = parse_uint64(argv[1]);
  c0:	6588                	ld	a0,8(a1)
  c2:	00000097          	auipc	ra,0x0
  c6:	f3e080e7          	jalr	-194(ra) # 0 <parse_uint64>
  ca:	89aa                	mv	s3,a0
    if (argc == 3)
  cc:	478d                	li	a5,3
    int pid = 0;
  ce:	4581                	li	a1,0
    if (argc == 3)
  d0:	02f48663          	beq	s1,a5,fc <main+0x78>
        pid = (int)parse_uint64(argv[2]);

    printf("0x%x\n", (int)va2pa(va, pid));
  d4:	854e                	mv	a0,s3
  d6:	00000097          	auipc	ra,0x0
  da:	398080e7          	jalr	920(ra) # 46e <va2pa>
  de:	0005059b          	sext.w	a1,a0
  e2:	00001517          	auipc	a0,0x1
  e6:	84650513          	addi	a0,a0,-1978 # 928 <malloc+0x128>
  ea:	00000097          	auipc	ra,0x0
  ee:	65a080e7          	jalr	1626(ra) # 744 <printf>
    exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	2c2080e7          	jalr	706(ra) # 3b6 <exit>
        pid = (int)parse_uint64(argv[2]);
  fc:	01093503          	ld	a0,16(s2)
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <parse_uint64>
 108:	0005059b          	sext.w	a1,a0
 10c:	b7e1                	j	d4 <main+0x50>

000000000000010e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10e:	1141                	addi	sp,sp,-16
 110:	e406                	sd	ra,8(sp)
 112:	e022                	sd	s0,0(sp)
 114:	0800                	addi	s0,sp,16
  extern int main();
  main();
 116:	00000097          	auipc	ra,0x0
 11a:	f6e080e7          	jalr	-146(ra) # 84 <main>
  exit(0);
 11e:	4501                	li	a0,0
 120:	00000097          	auipc	ra,0x0
 124:	296080e7          	jalr	662(ra) # 3b6 <exit>

0000000000000128 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 130:	87aa                	mv	a5,a0
 132:	0585                	addi	a1,a1,1
 134:	0785                	addi	a5,a5,1
 136:	fff5c703          	lbu	a4,-1(a1)
 13a:	fee78fa3          	sb	a4,-1(a5)
 13e:	fb75                	bnez	a4,132 <strcpy+0xa>
    ;
  return os;
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 150:	00054783          	lbu	a5,0(a0)
 154:	cb91                	beqz	a5,168 <strcmp+0x20>
 156:	0005c703          	lbu	a4,0(a1)
 15a:	00f71763          	bne	a4,a5,168 <strcmp+0x20>
    p++, q++;
 15e:	0505                	addi	a0,a0,1
 160:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 162:	00054783          	lbu	a5,0(a0)
 166:	fbe5                	bnez	a5,156 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 168:	0005c503          	lbu	a0,0(a1)
}
 16c:	40a7853b          	subw	a0,a5,a0
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strlen>:

uint
strlen(const char *s)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 180:	00054783          	lbu	a5,0(a0)
 184:	cf91                	beqz	a5,1a0 <strlen+0x28>
 186:	00150793          	addi	a5,a0,1
 18a:	86be                	mv	a3,a5
 18c:	0785                	addi	a5,a5,1
 18e:	fff7c703          	lbu	a4,-1(a5)
 192:	ff65                	bnez	a4,18a <strlen+0x12>
 194:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 198:	60a2                	ld	ra,8(sp)
 19a:	6402                	ld	s0,0(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
  for(n = 0; s[n]; n++)
 1a0:	4501                	li	a0,0
 1a2:	bfdd                	j	198 <strlen+0x20>

00000000000001a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ac:	ca19                	beqz	a2,1c2 <memset+0x1e>
 1ae:	87aa                	mv	a5,a0
 1b0:	1602                	slli	a2,a2,0x20
 1b2:	9201                	srli	a2,a2,0x20
 1b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1bc:	0785                	addi	a5,a5,1
 1be:	fee79de3          	bne	a5,a4,1b8 <memset+0x14>
  }
  return dst;
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <strchr>:

char*
strchr(const char *s, char c)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cf81                	beqz	a5,1ee <strchr+0x24>
    if(*s == c)
 1d8:	00f58763          	beq	a1,a5,1e6 <strchr+0x1c>
  for(; *s; s++)
 1dc:	0505                	addi	a0,a0,1
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbfd                	bnez	a5,1d8 <strchr+0xe>
      return (char*)s;
  return 0;
 1e4:	4501                	li	a0,0
}
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  return 0;
 1ee:	4501                	li	a0,0
 1f0:	bfdd                	j	1e6 <strchr+0x1c>

00000000000001f2 <gets>:

char*
gets(char *buf, int max)
{
 1f2:	711d                	addi	sp,sp,-96
 1f4:	ec86                	sd	ra,88(sp)
 1f6:	e8a2                	sd	s0,80(sp)
 1f8:	e4a6                	sd	s1,72(sp)
 1fa:	e0ca                	sd	s2,64(sp)
 1fc:	fc4e                	sd	s3,56(sp)
 1fe:	f852                	sd	s4,48(sp)
 200:	f456                	sd	s5,40(sp)
 202:	f05a                	sd	s6,32(sp)
 204:	ec5e                	sd	s7,24(sp)
 206:	e862                	sd	s8,16(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
 212:	faf40b13          	addi	s6,s0,-81
 216:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 218:	8c26                	mv	s8,s1
 21a:	0014899b          	addiw	s3,s1,1
 21e:	84ce                	mv	s1,s3
 220:	0349d663          	bge	s3,s4,24c <gets+0x5a>
    cc = read(0, &c, 1);
 224:	8656                	mv	a2,s5
 226:	85da                	mv	a1,s6
 228:	4501                	li	a0,0
 22a:	00000097          	auipc	ra,0x0
 22e:	1a4080e7          	jalr	420(ra) # 3ce <read>
    if(cc < 1)
 232:	00a05d63          	blez	a0,24c <gets+0x5a>
      break;
    buf[i++] = c;
 236:	faf44783          	lbu	a5,-81(s0)
 23a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23e:	0905                	addi	s2,s2,1
 240:	ff678713          	addi	a4,a5,-10
 244:	c319                	beqz	a4,24a <gets+0x58>
 246:	17cd                	addi	a5,a5,-13
 248:	fbe1                	bnez	a5,218 <gets+0x26>
    buf[i++] = c;
 24a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 24c:	9c5e                	add	s8,s8,s7
 24e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 252:	855e                	mv	a0,s7
 254:	60e6                	ld	ra,88(sp)
 256:	6446                	ld	s0,80(sp)
 258:	64a6                	ld	s1,72(sp)
 25a:	6906                	ld	s2,64(sp)
 25c:	79e2                	ld	s3,56(sp)
 25e:	7a42                	ld	s4,48(sp)
 260:	7aa2                	ld	s5,40(sp)
 262:	7b02                	ld	s6,32(sp)
 264:	6be2                	ld	s7,24(sp)
 266:	6c42                	ld	s8,16(sp)
 268:	6125                	addi	sp,sp,96
 26a:	8082                	ret

000000000000026c <stat>:

int
stat(const char *n, struct stat *st)
{
 26c:	1101                	addi	sp,sp,-32
 26e:	ec06                	sd	ra,24(sp)
 270:	e822                	sd	s0,16(sp)
 272:	e04a                	sd	s2,0(sp)
 274:	1000                	addi	s0,sp,32
 276:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 278:	4581                	li	a1,0
 27a:	00000097          	auipc	ra,0x0
 27e:	17c080e7          	jalr	380(ra) # 3f6 <open>
  if(fd < 0)
 282:	02054663          	bltz	a0,2ae <stat+0x42>
 286:	e426                	sd	s1,8(sp)
 288:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28a:	85ca                	mv	a1,s2
 28c:	00000097          	auipc	ra,0x0
 290:	182080e7          	jalr	386(ra) # 40e <fstat>
 294:	892a                	mv	s2,a0
  close(fd);
 296:	8526                	mv	a0,s1
 298:	00000097          	auipc	ra,0x0
 29c:	146080e7          	jalr	326(ra) # 3de <close>
  return r;
 2a0:	64a2                	ld	s1,8(sp)
}
 2a2:	854a                	mv	a0,s2
 2a4:	60e2                	ld	ra,24(sp)
 2a6:	6442                	ld	s0,16(sp)
 2a8:	6902                	ld	s2,0(sp)
 2aa:	6105                	addi	sp,sp,32
 2ac:	8082                	ret
    return -1;
 2ae:	57fd                	li	a5,-1
 2b0:	893e                	mv	s2,a5
 2b2:	bfc5                	j	2a2 <stat+0x36>

00000000000002b4 <atoi>:

int
atoi(const char *s)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bc:	00054683          	lbu	a3,0(a0)
 2c0:	fd06879b          	addiw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	4625                	li	a2,9
 2ca:	02f66963          	bltu	a2,a5,2fc <atoi+0x48>
 2ce:	872a                	mv	a4,a0
  n = 0;
 2d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d2:	0705                	addi	a4,a4,1
 2d4:	0025179b          	slliw	a5,a0,0x2
 2d8:	9fa9                	addw	a5,a5,a0
 2da:	0017979b          	slliw	a5,a5,0x1
 2de:	9fb5                	addw	a5,a5,a3
 2e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e4:	00074683          	lbu	a3,0(a4)
 2e8:	fd06879b          	addiw	a5,a3,-48
 2ec:	0ff7f793          	zext.b	a5,a5
 2f0:	fef671e3          	bgeu	a2,a5,2d2 <atoi+0x1e>
  return n;
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  n = 0;
 2fc:	4501                	li	a0,0
 2fe:	bfdd                	j	2f4 <atoi+0x40>

0000000000000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 308:	02b57563          	bgeu	a0,a1,332 <memmove+0x32>
    while(n-- > 0)
 30c:	00c05f63          	blez	a2,32a <memmove+0x2a>
 310:	1602                	slli	a2,a2,0x20
 312:	9201                	srli	a2,a2,0x20
 314:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 318:	872a                	mv	a4,a0
      *dst++ = *src++;
 31a:	0585                	addi	a1,a1,1
 31c:	0705                	addi	a4,a4,1
 31e:	fff5c683          	lbu	a3,-1(a1)
 322:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 326:	fee79ae3          	bne	a5,a4,31a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
    while(n-- > 0)
 332:	fec05ce3          	blez	a2,32a <memmove+0x2a>
    dst += n;
 336:	00c50733          	add	a4,a0,a2
    src += n;
 33a:	95b2                	add	a1,a1,a2
 33c:	fff6079b          	addiw	a5,a2,-1
 340:	1782                	slli	a5,a5,0x20
 342:	9381                	srli	a5,a5,0x20
 344:	fff7c793          	not	a5,a5
 348:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 34a:	15fd                	addi	a1,a1,-1
 34c:	177d                	addi	a4,a4,-1
 34e:	0005c683          	lbu	a3,0(a1)
 352:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 356:	fef71ae3          	bne	a4,a5,34a <memmove+0x4a>
 35a:	bfc1                	j	32a <memmove+0x2a>

000000000000035c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 364:	c61d                	beqz	a2,392 <memcmp+0x36>
 366:	1602                	slli	a2,a2,0x20
 368:	9201                	srli	a2,a2,0x20
 36a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 36e:	00054783          	lbu	a5,0(a0)
 372:	0005c703          	lbu	a4,0(a1)
 376:	00e79863          	bne	a5,a4,386 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 37a:	0505                	addi	a0,a0,1
    p2++;
 37c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37e:	fed518e3          	bne	a0,a3,36e <memcmp+0x12>
  }
  return 0;
 382:	4501                	li	a0,0
 384:	a019                	j	38a <memcmp+0x2e>
      return *p1 - *p2;
 386:	40e7853b          	subw	a0,a5,a4
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  return 0;
 392:	4501                	li	a0,0
 394:	bfdd                	j	38a <memcmp+0x2e>

0000000000000396 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39e:	00000097          	auipc	ra,0x0
 3a2:	f62080e7          	jalr	-158(ra) # 300 <memmove>
}
 3a6:	60a2                	ld	ra,8(sp)
 3a8:	6402                	ld	s0,0(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ae:	4885                	li	a7,1
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b6:	4889                	li	a7,2
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <wait>:
.global wait
wait:
 li a7, SYS_wait
 3be:	488d                	li	a7,3
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c6:	4891                	li	a7,4
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <read>:
.global read
read:
 li a7, SYS_read
 3ce:	4895                	li	a7,5
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <write>:
.global write
write:
 li a7, SYS_write
 3d6:	48c1                	li	a7,16
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <close>:
.global close
close:
 li a7, SYS_close
 3de:	48d5                	li	a7,21
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e6:	4899                	li	a7,6
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ee:	489d                	li	a7,7
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <open>:
.global open
open:
 li a7, SYS_open
 3f6:	48bd                	li	a7,15
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fe:	48c5                	li	a7,17
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 406:	48c9                	li	a7,18
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40e:	48a1                	li	a7,8
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <link>:
.global link
link:
 li a7, SYS_link
 416:	48cd                	li	a7,19
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41e:	48d1                	li	a7,20
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 426:	48a5                	li	a7,9
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <dup>:
.global dup
dup:
 li a7, SYS_dup
 42e:	48a9                	li	a7,10
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 436:	48ad                	li	a7,11
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43e:	48b1                	li	a7,12
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 446:	48b5                	li	a7,13
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44e:	48b9                	li	a7,14
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <ps>:
.global ps
ps:
 li a7, SYS_ps
 456:	48d9                	li	a7,22
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 45e:	48dd                	li	a7,23
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 466:	48e1                	li	a7,24
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 46e:	48e9                	li	a7,26
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 476:	48e5                	li	a7,25
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 47e:	1101                	addi	sp,sp,-32
 480:	ec06                	sd	ra,24(sp)
 482:	e822                	sd	s0,16(sp)
 484:	1000                	addi	s0,sp,32
 486:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48a:	4605                	li	a2,1
 48c:	fef40593          	addi	a1,s0,-17
 490:	00000097          	auipc	ra,0x0
 494:	f46080e7          	jalr	-186(ra) # 3d6 <write>
}
 498:	60e2                	ld	ra,24(sp)
 49a:	6442                	ld	s0,16(sp)
 49c:	6105                	addi	sp,sp,32
 49e:	8082                	ret

00000000000004a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	7139                	addi	sp,sp,-64
 4a2:	fc06                	sd	ra,56(sp)
 4a4:	f822                	sd	s0,48(sp)
 4a6:	f04a                	sd	s2,32(sp)
 4a8:	ec4e                	sd	s3,24(sp)
 4aa:	0080                	addi	s0,sp,64
 4ac:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ae:	cad9                	beqz	a3,544 <printint+0xa4>
 4b0:	01f5d79b          	srliw	a5,a1,0x1f
 4b4:	cbc1                	beqz	a5,544 <printint+0xa4>
    neg = 1;
    x = -xx;
 4b6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ba:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4bc:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4c0:	86ce                	mv	a3,s3
  i = 0;
 4c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c4:	00000817          	auipc	a6,0x0
 4c8:	4cc80813          	addi	a6,a6,1228 # 990 <digits>
 4cc:	88ba                	mv	a7,a4
 4ce:	0017051b          	addiw	a0,a4,1
 4d2:	872a                	mv	a4,a0
 4d4:	02c5f7bb          	remuw	a5,a1,a2
 4d8:	1782                	slli	a5,a5,0x20
 4da:	9381                	srli	a5,a5,0x20
 4dc:	97c2                	add	a5,a5,a6
 4de:	0007c783          	lbu	a5,0(a5)
 4e2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e6:	87ae                	mv	a5,a1
 4e8:	02c5d5bb          	divuw	a1,a1,a2
 4ec:	0685                	addi	a3,a3,1
 4ee:	fcc7ffe3          	bgeu	a5,a2,4cc <printint+0x2c>
  if(neg)
 4f2:	00030c63          	beqz	t1,50a <printint+0x6a>
    buf[i++] = '-';
 4f6:	fd050793          	addi	a5,a0,-48
 4fa:	00878533          	add	a0,a5,s0
 4fe:	02d00793          	li	a5,45
 502:	fef50823          	sb	a5,-16(a0)
 506:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 50a:	02e05763          	blez	a4,538 <printint+0x98>
 50e:	f426                	sd	s1,40(sp)
 510:	377d                	addiw	a4,a4,-1
 512:	00e984b3          	add	s1,s3,a4
 516:	19fd                	addi	s3,s3,-1
 518:	99ba                	add	s3,s3,a4
 51a:	1702                	slli	a4,a4,0x20
 51c:	9301                	srli	a4,a4,0x20
 51e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 522:	0004c583          	lbu	a1,0(s1)
 526:	854a                	mv	a0,s2
 528:	00000097          	auipc	ra,0x0
 52c:	f56080e7          	jalr	-170(ra) # 47e <putc>
  while(--i >= 0)
 530:	14fd                	addi	s1,s1,-1
 532:	ff3498e3          	bne	s1,s3,522 <printint+0x82>
 536:	74a2                	ld	s1,40(sp)
}
 538:	70e2                	ld	ra,56(sp)
 53a:	7442                	ld	s0,48(sp)
 53c:	7902                	ld	s2,32(sp)
 53e:	69e2                	ld	s3,24(sp)
 540:	6121                	addi	sp,sp,64
 542:	8082                	ret
  neg = 0;
 544:	4301                	li	t1,0
 546:	bf9d                	j	4bc <printint+0x1c>

0000000000000548 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 548:	715d                	addi	sp,sp,-80
 54a:	e486                	sd	ra,72(sp)
 54c:	e0a2                	sd	s0,64(sp)
 54e:	f84a                	sd	s2,48(sp)
 550:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 552:	0005c903          	lbu	s2,0(a1)
 556:	1a090b63          	beqz	s2,70c <vprintf+0x1c4>
 55a:	fc26                	sd	s1,56(sp)
 55c:	f44e                	sd	s3,40(sp)
 55e:	f052                	sd	s4,32(sp)
 560:	ec56                	sd	s5,24(sp)
 562:	e85a                	sd	s6,16(sp)
 564:	e45e                	sd	s7,8(sp)
 566:	8aaa                	mv	s5,a0
 568:	8bb2                	mv	s7,a2
 56a:	00158493          	addi	s1,a1,1
  state = 0;
 56e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 570:	02500a13          	li	s4,37
 574:	4b55                	li	s6,21
 576:	a839                	j	594 <vprintf+0x4c>
        putc(fd, c);
 578:	85ca                	mv	a1,s2
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	f02080e7          	jalr	-254(ra) # 47e <putc>
 584:	a019                	j	58a <vprintf+0x42>
    } else if(state == '%'){
 586:	01498d63          	beq	s3,s4,5a0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 58a:	0485                	addi	s1,s1,1
 58c:	fff4c903          	lbu	s2,-1(s1)
 590:	16090863          	beqz	s2,700 <vprintf+0x1b8>
    if(state == 0){
 594:	fe0999e3          	bnez	s3,586 <vprintf+0x3e>
      if(c == '%'){
 598:	ff4910e3          	bne	s2,s4,578 <vprintf+0x30>
        state = '%';
 59c:	89d2                	mv	s3,s4
 59e:	b7f5                	j	58a <vprintf+0x42>
      if(c == 'd'){
 5a0:	13490563          	beq	s2,s4,6ca <vprintf+0x182>
 5a4:	f9d9079b          	addiw	a5,s2,-99
 5a8:	0ff7f793          	zext.b	a5,a5
 5ac:	12fb6863          	bltu	s6,a5,6dc <vprintf+0x194>
 5b0:	f9d9079b          	addiw	a5,s2,-99
 5b4:	0ff7f713          	zext.b	a4,a5
 5b8:	12eb6263          	bltu	s6,a4,6dc <vprintf+0x194>
 5bc:	00271793          	slli	a5,a4,0x2
 5c0:	00000717          	auipc	a4,0x0
 5c4:	37870713          	addi	a4,a4,888 # 938 <malloc+0x138>
 5c8:	97ba                	add	a5,a5,a4
 5ca:	439c                	lw	a5,0(a5)
 5cc:	97ba                	add	a5,a5,a4
 5ce:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4685                	li	a3,1
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	ec2080e7          	jalr	-318(ra) # 4a0 <printint>
 5e6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b745                	j	58a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	ea6080e7          	jalr	-346(ra) # 4a0 <printint>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	b751                	j	58a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e8a080e7          	jalr	-374(ra) # 4a0 <printint>
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	b7a5                	j	58a <vprintf+0x42>
 624:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 626:	008b8793          	addi	a5,s7,8
 62a:	8c3e                	mv	s8,a5
 62c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 630:	03000593          	li	a1,48
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e48080e7          	jalr	-440(ra) # 47e <putc>
  putc(fd, 'x');
 63e:	07800593          	li	a1,120
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e3a080e7          	jalr	-454(ra) # 47e <putc>
 64c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64e:	00000b97          	auipc	s7,0x0
 652:	342b8b93          	addi	s7,s7,834 # 990 <digits>
 656:	03c9d793          	srli	a5,s3,0x3c
 65a:	97de                	add	a5,a5,s7
 65c:	0007c583          	lbu	a1,0(a5)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e1c080e7          	jalr	-484(ra) # 47e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 66a:	0992                	slli	s3,s3,0x4
 66c:	397d                	addiw	s2,s2,-1
 66e:	fe0914e3          	bnez	s2,656 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 672:	8be2                	mv	s7,s8
      state = 0;
 674:	4981                	li	s3,0
 676:	6c02                	ld	s8,0(sp)
 678:	bf09                	j	58a <vprintf+0x42>
        s = va_arg(ap, char*);
 67a:	008b8993          	addi	s3,s7,8
 67e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 682:	02090163          	beqz	s2,6a4 <vprintf+0x15c>
        while(*s != 0){
 686:	00094583          	lbu	a1,0(s2)
 68a:	c9a5                	beqz	a1,6fa <vprintf+0x1b2>
          putc(fd, *s);
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	df0080e7          	jalr	-528(ra) # 47e <putc>
          s++;
 696:	0905                	addi	s2,s2,1
        while(*s != 0){
 698:	00094583          	lbu	a1,0(s2)
 69c:	f9e5                	bnez	a1,68c <vprintf+0x144>
        s = va_arg(ap, char*);
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b5e5                	j	58a <vprintf+0x42>
          s = "(null)";
 6a4:	00000917          	auipc	s2,0x0
 6a8:	28c90913          	addi	s2,s2,652 # 930 <malloc+0x130>
        while(*s != 0){
 6ac:	02800593          	li	a1,40
 6b0:	bff1                	j	68c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	000bc583          	lbu	a1,0(s7)
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	dc2080e7          	jalr	-574(ra) # 47e <putc>
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b5c9                	j	58a <vprintf+0x42>
        putc(fd, c);
 6ca:	02500593          	li	a1,37
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	dae080e7          	jalr	-594(ra) # 47e <putc>
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd45                	j	58a <vprintf+0x42>
        putc(fd, '%');
 6dc:	02500593          	li	a1,37
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	d9c080e7          	jalr	-612(ra) # 47e <putc>
        putc(fd, c);
 6ea:	85ca                	mv	a1,s2
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	d90080e7          	jalr	-624(ra) # 47e <putc>
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	bd49                	j	58a <vprintf+0x42>
        s = va_arg(ap, char*);
 6fa:	8bce                	mv	s7,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b571                	j	58a <vprintf+0x42>
 700:	74e2                	ld	s1,56(sp)
 702:	79a2                	ld	s3,40(sp)
 704:	7a02                	ld	s4,32(sp)
 706:	6ae2                	ld	s5,24(sp)
 708:	6b42                	ld	s6,16(sp)
 70a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 70c:	60a6                	ld	ra,72(sp)
 70e:	6406                	ld	s0,64(sp)
 710:	7942                	ld	s2,48(sp)
 712:	6161                	addi	sp,sp,80
 714:	8082                	ret

0000000000000716 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 716:	715d                	addi	sp,sp,-80
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e010                	sd	a2,0(s0)
 720:	e414                	sd	a3,8(s0)
 722:	e818                	sd	a4,16(s0)
 724:	ec1c                	sd	a5,24(s0)
 726:	03043023          	sd	a6,32(s0)
 72a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	8622                	mv	a2,s0
 730:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 734:	00000097          	auipc	ra,0x0
 738:	e14080e7          	jalr	-492(ra) # 548 <vprintf>
}
 73c:	60e2                	ld	ra,24(sp)
 73e:	6442                	ld	s0,16(sp)
 740:	6161                	addi	sp,sp,80
 742:	8082                	ret

0000000000000744 <printf>:

void
printf(const char *fmt, ...)
{
 744:	711d                	addi	sp,sp,-96
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e40c                	sd	a1,8(s0)
 74e:	e810                	sd	a2,16(s0)
 750:	ec14                	sd	a3,24(s0)
 752:	f018                	sd	a4,32(s0)
 754:	f41c                	sd	a5,40(s0)
 756:	03043823          	sd	a6,48(s0)
 75a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	00840613          	addi	a2,s0,8
 762:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 766:	85aa                	mv	a1,a0
 768:	4505                	li	a0,1
 76a:	00000097          	auipc	ra,0x0
 76e:	dde080e7          	jalr	-546(ra) # 548 <vprintf>
}
 772:	60e2                	ld	ra,24(sp)
 774:	6442                	ld	s0,16(sp)
 776:	6125                	addi	sp,sp,96
 778:	8082                	ret

000000000000077a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77a:	1141                	addi	sp,sp,-16
 77c:	e406                	sd	ra,8(sp)
 77e:	e022                	sd	s0,0(sp)
 780:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 782:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	00001797          	auipc	a5,0x1
 78a:	87a7b783          	ld	a5,-1926(a5) # 1000 <freep>
 78e:	a039                	j	79c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	6398                	ld	a4,0(a5)
 792:	00e7e463          	bltu	a5,a4,79a <free+0x20>
 796:	00e6ea63          	bltu	a3,a4,7aa <free+0x30>
{
 79a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	fed7fae3          	bgeu	a5,a3,790 <free+0x16>
 7a0:	6398                	ld	a4,0(a5)
 7a2:	00e6e463          	bltu	a3,a4,7aa <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	fee7eae3          	bltu	a5,a4,79a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7aa:	ff852583          	lw	a1,-8(a0)
 7ae:	6390                	ld	a2,0(a5)
 7b0:	02059813          	slli	a6,a1,0x20
 7b4:	01c85713          	srli	a4,a6,0x1c
 7b8:	9736                	add	a4,a4,a3
 7ba:	02e60563          	beq	a2,a4,7e4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7c2:	4790                	lw	a2,8(a5)
 7c4:	02061593          	slli	a1,a2,0x20
 7c8:	01c5d713          	srli	a4,a1,0x1c
 7cc:	973e                	add	a4,a4,a5
 7ce:	02e68263          	beq	a3,a4,7f2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
}
 7dc:	60a2                	ld	ra,8(sp)
 7de:	6402                	ld	s0,0(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7e4:	4618                	lw	a4,8(a2)
 7e6:	9f2d                	addw	a4,a4,a1
 7e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	6398                	ld	a4,0(a5)
 7ee:	6310                	ld	a2,0(a4)
 7f0:	b7f9                	j	7be <free+0x44>
    p->s.size += bp->s.size;
 7f2:	ff852703          	lw	a4,-8(a0)
 7f6:	9f31                	addw	a4,a4,a2
 7f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fa:	ff053683          	ld	a3,-16(a0)
 7fe:	bfd1                	j	7d2 <free+0x58>

0000000000000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	7139                	addi	sp,sp,-64
 802:	fc06                	sd	ra,56(sp)
 804:	f822                	sd	s0,48(sp)
 806:	f04a                	sd	s2,32(sp)
 808:	ec4e                	sd	s3,24(sp)
 80a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80c:	02051993          	slli	s3,a0,0x20
 810:	0209d993          	srli	s3,s3,0x20
 814:	09bd                	addi	s3,s3,15
 816:	0049d993          	srli	s3,s3,0x4
 81a:	2985                	addiw	s3,s3,1
 81c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 81e:	00000517          	auipc	a0,0x0
 822:	7e253503          	ld	a0,2018(a0) # 1000 <freep>
 826:	c905                	beqz	a0,856 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	09377a63          	bgeu	a4,s3,8c0 <malloc+0xc0>
 830:	f426                	sd	s1,40(sp)
 832:	e852                	sd	s4,16(sp)
 834:	e456                	sd	s5,8(sp)
 836:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 838:	8a4e                	mv	s4,s3
 83a:	6705                	lui	a4,0x1
 83c:	00e9f363          	bgeu	s3,a4,842 <malloc+0x42>
 840:	6a05                	lui	s4,0x1
 842:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 846:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 84a:	00000497          	auipc	s1,0x0
 84e:	7b648493          	addi	s1,s1,1974 # 1000 <freep>
  if(p == (char*)-1)
 852:	5afd                	li	s5,-1
 854:	a089                	j	896 <malloc+0x96>
 856:	f426                	sd	s1,40(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85e:	00000797          	auipc	a5,0x0
 862:	7b278793          	addi	a5,a5,1970 # 1010 <base>
 866:	00000717          	auipc	a4,0x0
 86a:	78f73d23          	sd	a5,1946(a4) # 1000 <freep>
 86e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 870:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 874:	b7d1                	j	838 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	e118                	sd	a4,0(a0)
 87a:	a8b9                	j	8d8 <malloc+0xd8>
  hp->s.size = nu;
 87c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 880:	0541                	addi	a0,a0,16
 882:	00000097          	auipc	ra,0x0
 886:	ef8080e7          	jalr	-264(ra) # 77a <free>
  return freep;
 88a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 88c:	c135                	beqz	a0,8f0 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	03277363          	bgeu	a4,s2,8b8 <malloc+0xb8>
    if(p == freep)
 896:	6098                	ld	a4,0(s1)
 898:	853e                	mv	a0,a5
 89a:	fef71ae3          	bne	a4,a5,88e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 89e:	8552                	mv	a0,s4
 8a0:	00000097          	auipc	ra,0x0
 8a4:	b9e080e7          	jalr	-1122(ra) # 43e <sbrk>
  if(p == (char*)-1)
 8a8:	fd551ae3          	bne	a0,s5,87c <malloc+0x7c>
        return 0;
 8ac:	4501                	li	a0,0
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	6a42                	ld	s4,16(sp)
 8b2:	6aa2                	ld	s5,8(sp)
 8b4:	6b02                	ld	s6,0(sp)
 8b6:	a03d                	j	8e4 <malloc+0xe4>
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c0:	fae90be3          	beq	s2,a4,876 <malloc+0x76>
        p->s.size -= nunits;
 8c4:	4137073b          	subw	a4,a4,s3
 8c8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ca:	02071693          	slli	a3,a4,0x20
 8ce:	01c6d713          	srli	a4,a3,0x1c
 8d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d8:	00000717          	auipc	a4,0x0
 8dc:	72a73423          	sd	a0,1832(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e0:	01078513          	addi	a0,a5,16
  }
}
 8e4:	70e2                	ld	ra,56(sp)
 8e6:	7442                	ld	s0,48(sp)
 8e8:	7902                	ld	s2,32(sp)
 8ea:	69e2                	ld	s3,24(sp)
 8ec:	6121                	addi	sp,sp,64
 8ee:	8082                	ret
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
 8f8:	b7f5                	j	8e4 <malloc+0xe4>
