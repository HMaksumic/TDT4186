
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
    }
    exit(0);
}

int getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
    write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00002597          	auipc	a1,0x2
      16:	bee58593          	addi	a1,a1,-1042 # 1c00 <malloc+0xfc>
      1a:	8532                	mv	a0,a2
      1c:	00001097          	auipc	ra,0x1
      20:	6ce080e7          	jalr	1742(ra) # 16ea <write>
    memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	48e080e7          	jalr	1166(ra) # 14b8 <memset>
    gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	4d0080e7          	jalr	1232(ra) # 1506 <gets>
    if (buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
        return -1;
    return 0;
}
      46:	40a0053b          	negw	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
    }
    exit(0);
}

void panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
    fprintf(2, "%s\n", s);
      60:	00002597          	auipc	a1,0x2
      64:	bb058593          	addi	a1,a1,-1104 # 1c10 <malloc+0x10c>
      68:	4509                	li	a0,2
      6a:	00002097          	auipc	ra,0x2
      6e:	9b0080e7          	jalr	-1616(ra) # 1a1a <fprintf>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	656080e7          	jalr	1622(ra) # 16ca <exit>

000000000000007c <fork1>:
}

int fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
    int pid;

    pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	63e080e7          	jalr	1598(ra) # 16c2 <fork>
    if (pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
        panic("fork");
    return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
        panic("fork");
      9a:	00002517          	auipc	a0,0x2
      9e:	b7e50513          	addi	a0,a0,-1154 # 1c18 <malloc+0x114>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	addi	s0,sp,48
    if (cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
    switch (cmd->type)
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00002717          	auipc	a4,0x2
      ca:	d4a70713          	addi	a4,a4,-694 # 1e10 <malloc+0x30c>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
        exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	5f0080e7          	jalr	1520(ra) # 16ca <exit>
        panic("runcmd");
      e2:	00002517          	auipc	a0,0x2
      e6:	b3e50513          	addi	a0,a0,-1218 # 1c20 <malloc+0x11c>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
        if (ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
        exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	608080e7          	jalr	1544(ra) # 1702 <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00002597          	auipc	a1,0x2
     108:	b2458593          	addi	a1,a1,-1244 # 1c28 <malloc+0x124>
     10c:	4509                	li	a0,2
     10e:	00002097          	auipc	ra,0x2
     112:	90c080e7          	jalr	-1780(ra) # 1a1a <fprintf>
    exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	5b2080e7          	jalr	1458(ra) # 16ca <exit>
            exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	5a8080e7          	jalr	1448(ra) # 16ca <exit>
        close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	5c6080e7          	jalr	1478(ra) # 16f2 <close>
        if (open(rcmd->file, rcmd->mode) < 0)
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	5d2080e7          	jalr	1490(ra) # 170a <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
        runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
            fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00002597          	auipc	a1,0x2
     154:	ae858593          	addi	a1,a1,-1304 # 1c38 <malloc+0x134>
     158:	4509                	li	a0,2
     15a:	00002097          	auipc	ra,0x2
     15e:	8c0080e7          	jalr	-1856(ra) # 1a1a <fprintf>
            exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	566080e7          	jalr	1382(ra) # 16ca <exit>
        if (fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
            runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
        wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	550080e7          	jalr	1360(ra) # 16d2 <wait>
        runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
        if (pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	542080e7          	jalr	1346(ra) # 16da <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
        if (fork1() == 0)
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
            close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	542080e7          	jalr	1346(ra) # 16f2 <close>
            dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	586080e7          	jalr	1414(ra) # 1742 <dup>
            close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	52a080e7          	jalr	1322(ra) # 16f2 <close>
            close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	51e080e7          	jalr	1310(ra) # 16f2 <close>
            runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
            panic("pipe");
     1e6:	00002517          	auipc	a0,0x2
     1ea:	a6250513          	addi	a0,a0,-1438 # 1c48 <malloc+0x144>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
        if (fork1() == 0)
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
            close(0);
     200:	00001097          	auipc	ra,0x1
     204:	4f2080e7          	jalr	1266(ra) # 16f2 <close>
            dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	536080e7          	jalr	1334(ra) # 1742 <dup>
            close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	4da080e7          	jalr	1242(ra) # 16f2 <close>
            close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	4ce080e7          	jalr	1230(ra) # 16f2 <close>
            runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
        close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	4b8080e7          	jalr	1208(ra) # 16f2 <close>
        close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	4ac080e7          	jalr	1196(ra) # 16f2 <close>
        wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	482080e7          	jalr	1154(ra) # 16d2 <wait>
        wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	478080e7          	jalr	1144(ra) # 16d2 <wait>
        break;
     262:	bd55                	j	116 <runcmd+0x6c>
        if (fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
            runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
    struct execcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00002097          	auipc	ra,0x2
     28c:	87c080e7          	jalr	-1924(ra) # 1b04 <malloc>
     290:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	220080e7          	jalr	544(ra) # 14b8 <memset>
    cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
    return (struct cmd *)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	892a                	mv	s2,a0
     2c6:	89ae                	mv	s3,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	8ab6                	mv	s5,a3
     2cc:	8b3a                	mv	s6,a4
    struct redircmd *cmd;

    cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00002097          	auipc	ra,0x2
     2d6:	832080e7          	jalr	-1998(ra) # 1b04 <malloc>
     2da:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	1d6080e7          	jalr	470(ra) # 14b8 <memset>
    cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     2ee:	0124b423          	sd	s2,8(s1)
    cmd->file = file;
     2f2:	0134b823          	sd	s3,16(s1)
    cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
    cmd->mode = mode;
     2fa:	0354a023          	sw	s5,32(s1)
    cmd->fd = fd;
     2fe:	0364a223          	sw	s6,36(s1)
    return (struct cmd *)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	892a                	mv	s2,a0
     328:	89ae                	mv	s3,a1
    struct pipecmd *cmd;

    cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	7d8080e7          	jalr	2008(ra) # 1b04 <malloc>
     334:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	17e080e7          	jalr	382(ra) # 14b8 <memset>
    cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     346:	0124b423          	sd	s2,8(s1)
    cmd->right = right;
     34a:	0134b823          	sd	s3,16(s1)
    return (struct cmd *)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	892a                	mv	s2,a0
     36e:	89ae                	mv	s3,a1
    struct listcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	792080e7          	jalr	1938(ra) # 1b04 <malloc>
     37a:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	138080e7          	jalr	312(ra) # 14b8 <memset>
    cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
    cmd->left = left;
     38c:	0124b423          	sd	s2,8(s1)
    cmd->right = right;
     390:	0134b823          	sd	s3,16(s1)
    return (struct cmd *)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
    struct backcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	750080e7          	jalr	1872(ra) # 1b04 <malloc>
     3bc:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	0f6080e7          	jalr	246(ra) # 14b8 <memset>
    cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
    cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
    return (struct cmd *)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
    char *s;
    int ret;

    s = *ps;
     3fc:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     3fe:	00002997          	auipc	s3,0x2
     402:	c0a98993          	addi	s3,s3,-1014 # 2008 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	0ce080e7          	jalr	206(ra) # 14de <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
        s++;
     41a:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
    if (q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
        *q = s;
     426:	009ab023          	sd	s1,0(s5)
    ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
    switch (*s)
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addiw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76763          	bltu	a4,a5,4c4 <gettoken+0xe4>
    case '(':
    case ')':
    case ';':
    case '&':
    case '<':
        s++;
     45a:	0485                	addi	s1,s1,1
        ret = 'a';
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
            s++;
        break;
    }
    if (eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
        *eq = s;
     460:	009b3023          	sd	s1,0(s6)

    while (s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	ba498993          	addi	s3,s3,-1116 # 2008 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00001097          	auipc	ra,0x1
     47a:	068080e7          	jalr	104(ra) # 14de <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
        s++;
     480:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
    *ps = s;
     488:	009a3023          	sd	s1,0(s4)
    return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	addi	sp,sp,64
     4a0:	8082                	ret
    switch (*s)
     4a2:	03e00713          	li	a4,62
     4a6:	00e79b63          	bne	a5,a4,4bc <gettoken+0xdc>
        if (*s == '>')
     4aa:	0014c703          	lbu	a4,1(s1)
     4ae:	03e00793          	li	a5,62
     4b2:	04f70c63          	beq	a4,a5,50a <gettoken+0x12a>
        s++;
     4b6:	0485                	addi	s1,s1,1
    ret = *s;
     4b8:	8abe                	mv	s5,a5
     4ba:	b74d                	j	45c <gettoken+0x7c>
    switch (*s)
     4bc:	07c00713          	li	a4,124
     4c0:	f8e78de3          	beq	a5,a4,45a <gettoken+0x7a>
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4c4:	00002997          	auipc	s3,0x2
     4c8:	b4498993          	addi	s3,s3,-1212 # 2008 <whitespace>
     4cc:	00002a97          	auipc	s5,0x2
     4d0:	b34a8a93          	addi	s5,s5,-1228 # 2000 <symbols>
     4d4:	0524f563          	bgeu	s1,s2,51e <gettoken+0x13e>
     4d8:	0004c583          	lbu	a1,0(s1)
     4dc:	854e                	mv	a0,s3
     4de:	00001097          	auipc	ra,0x1
     4e2:	000080e7          	jalr	ra # 14de <strchr>
     4e6:	e90d                	bnez	a0,518 <gettoken+0x138>
     4e8:	0004c583          	lbu	a1,0(s1)
     4ec:	8556                	mv	a0,s5
     4ee:	00001097          	auipc	ra,0x1
     4f2:	ff0080e7          	jalr	-16(ra) # 14de <strchr>
     4f6:	ed11                	bnez	a0,512 <gettoken+0x132>
            s++;
     4f8:	0485                	addi	s1,s1,1
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4fa:	fc991fe3          	bne	s2,s1,4d8 <gettoken+0xf8>
    if (eq)
     4fe:	84ca                	mv	s1,s2
        ret = 'a';
     500:	06100a93          	li	s5,97
    if (eq)
     504:	f40b1ee3          	bnez	s6,460 <gettoken+0x80>
     508:	b741                	j	488 <gettoken+0xa8>
            s++;
     50a:	0489                	addi	s1,s1,2
            ret = '+';
     50c:	02b00a93          	li	s5,43
     510:	b7b1                	j	45c <gettoken+0x7c>
        ret = 'a';
     512:	06100a93          	li	s5,97
     516:	b799                	j	45c <gettoken+0x7c>
     518:	06100a93          	li	s5,97
     51c:	b781                	j	45c <gettoken+0x7c>
     51e:	06100a93          	li	s5,97
    if (eq)
     522:	f20b1fe3          	bnez	s6,460 <gettoken+0x80>
     526:	b78d                	j	488 <gettoken+0xa8>

0000000000000528 <peek>:

int peek(char **ps, char *es, char *toks)
{
     528:	7139                	addi	sp,sp,-64
     52a:	fc06                	sd	ra,56(sp)
     52c:	f822                	sd	s0,48(sp)
     52e:	f426                	sd	s1,40(sp)
     530:	f04a                	sd	s2,32(sp)
     532:	ec4e                	sd	s3,24(sp)
     534:	e852                	sd	s4,16(sp)
     536:	e456                	sd	s5,8(sp)
     538:	0080                	addi	s0,sp,64
     53a:	8a2a                	mv	s4,a0
     53c:	892e                	mv	s2,a1
     53e:	8ab2                	mv	s5,a2
    char *s;

    s = *ps;
     540:	6104                	ld	s1,0(a0)
    while (s < es && strchr(whitespace, *s))
     542:	00002997          	auipc	s3,0x2
     546:	ac698993          	addi	s3,s3,-1338 # 2008 <whitespace>
     54a:	00b4fe63          	bgeu	s1,a1,566 <peek+0x3e>
     54e:	0004c583          	lbu	a1,0(s1)
     552:	854e                	mv	a0,s3
     554:	00001097          	auipc	ra,0x1
     558:	f8a080e7          	jalr	-118(ra) # 14de <strchr>
     55c:	c509                	beqz	a0,566 <peek+0x3e>
        s++;
     55e:	0485                	addi	s1,s1,1
    while (s < es && strchr(whitespace, *s))
     560:	fe9917e3          	bne	s2,s1,54e <peek+0x26>
     564:	84ca                	mv	s1,s2
    *ps = s;
     566:	009a3023          	sd	s1,0(s4)
    return *s && strchr(toks, *s);
     56a:	0004c583          	lbu	a1,0(s1)
     56e:	4501                	li	a0,0
     570:	e991                	bnez	a1,584 <peek+0x5c>
}
     572:	70e2                	ld	ra,56(sp)
     574:	7442                	ld	s0,48(sp)
     576:	74a2                	ld	s1,40(sp)
     578:	7902                	ld	s2,32(sp)
     57a:	69e2                	ld	s3,24(sp)
     57c:	6a42                	ld	s4,16(sp)
     57e:	6aa2                	ld	s5,8(sp)
     580:	6121                	addi	sp,sp,64
     582:	8082                	ret
    return *s && strchr(toks, *s);
     584:	8556                	mv	a0,s5
     586:	00001097          	auipc	ra,0x1
     58a:	f58080e7          	jalr	-168(ra) # 14de <strchr>
     58e:	00a03533          	snez	a0,a0
     592:	b7c5                	j	572 <peek+0x4a>

0000000000000594 <parseredirs>:
    return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     594:	7159                	addi	sp,sp,-112
     596:	f486                	sd	ra,104(sp)
     598:	f0a2                	sd	s0,96(sp)
     59a:	eca6                	sd	s1,88(sp)
     59c:	e8ca                	sd	s2,80(sp)
     59e:	e4ce                	sd	s3,72(sp)
     5a0:	e0d2                	sd	s4,64(sp)
     5a2:	fc56                	sd	s5,56(sp)
     5a4:	f85a                	sd	s6,48(sp)
     5a6:	f45e                	sd	s7,40(sp)
     5a8:	f062                	sd	s8,32(sp)
     5aa:	ec66                	sd	s9,24(sp)
     5ac:	1880                	addi	s0,sp,112
     5ae:	8a2a                	mv	s4,a0
     5b0:	89ae                	mv	s3,a1
     5b2:	8932                	mv	s2,a2
    int tok;
    char *q, *eq;

    while (peek(ps, es, "<>"))
     5b4:	00001b17          	auipc	s6,0x1
     5b8:	6bcb0b13          	addi	s6,s6,1724 # 1c70 <malloc+0x16c>
    {
        tok = gettoken(ps, es, 0, 0);
        if (gettoken(ps, es, &q, &eq) != 'a')
     5bc:	f9040c93          	addi	s9,s0,-112
     5c0:	f9840c13          	addi	s8,s0,-104
     5c4:	06100b93          	li	s7,97
    while (peek(ps, es, "<>"))
     5c8:	a02d                	j	5f2 <parseredirs+0x5e>
            panic("missing file for redirection");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	68650513          	addi	a0,a0,1670 # 1c50 <malloc+0x14c>
     5d2:	00000097          	auipc	ra,0x0
     5d6:	a84080e7          	jalr	-1404(ra) # 56 <panic>
        switch (tok)
        {
        case '<':
            cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5da:	4701                	li	a4,0
     5dc:	4681                	li	a3,0
     5de:	f9043603          	ld	a2,-112(s0)
     5e2:	f9843583          	ld	a1,-104(s0)
     5e6:	8552                	mv	a0,s4
     5e8:	00000097          	auipc	ra,0x0
     5ec:	cc8080e7          	jalr	-824(ra) # 2b0 <redircmd>
     5f0:	8a2a                	mv	s4,a0
        switch (tok)
     5f2:	03c00a93          	li	s5,60
    while (peek(ps, es, "<>"))
     5f6:	865a                	mv	a2,s6
     5f8:	85ca                	mv	a1,s2
     5fa:	854e                	mv	a0,s3
     5fc:	00000097          	auipc	ra,0x0
     600:	f2c080e7          	jalr	-212(ra) # 528 <peek>
     604:	c935                	beqz	a0,678 <parseredirs+0xe4>
        tok = gettoken(ps, es, 0, 0);
     606:	4681                	li	a3,0
     608:	4601                	li	a2,0
     60a:	85ca                	mv	a1,s2
     60c:	854e                	mv	a0,s3
     60e:	00000097          	auipc	ra,0x0
     612:	dd2080e7          	jalr	-558(ra) # 3e0 <gettoken>
     616:	84aa                	mv	s1,a0
        if (gettoken(ps, es, &q, &eq) != 'a')
     618:	86e6                	mv	a3,s9
     61a:	8662                	mv	a2,s8
     61c:	85ca                	mv	a1,s2
     61e:	854e                	mv	a0,s3
     620:	00000097          	auipc	ra,0x0
     624:	dc0080e7          	jalr	-576(ra) # 3e0 <gettoken>
     628:	fb7511e3          	bne	a0,s7,5ca <parseredirs+0x36>
        switch (tok)
     62c:	fb5487e3          	beq	s1,s5,5da <parseredirs+0x46>
     630:	03e00793          	li	a5,62
     634:	02f48463          	beq	s1,a5,65c <parseredirs+0xc8>
     638:	02b00793          	li	a5,43
     63c:	faf49de3          	bne	s1,a5,5f6 <parseredirs+0x62>
            break;
        case '>':
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
            break;
        case '+': // >>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     640:	4705                	li	a4,1
     642:	20100693          	li	a3,513
     646:	f9043603          	ld	a2,-112(s0)
     64a:	f9843583          	ld	a1,-104(s0)
     64e:	8552                	mv	a0,s4
     650:	00000097          	auipc	ra,0x0
     654:	c60080e7          	jalr	-928(ra) # 2b0 <redircmd>
     658:	8a2a                	mv	s4,a0
            break;
     65a:	bf61                	j	5f2 <parseredirs+0x5e>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     65c:	4705                	li	a4,1
     65e:	60100693          	li	a3,1537
     662:	f9043603          	ld	a2,-112(s0)
     666:	f9843583          	ld	a1,-104(s0)
     66a:	8552                	mv	a0,s4
     66c:	00000097          	auipc	ra,0x0
     670:	c44080e7          	jalr	-956(ra) # 2b0 <redircmd>
     674:	8a2a                	mv	s4,a0
            break;
     676:	bfb5                	j	5f2 <parseredirs+0x5e>
        }
    }
    return cmd;
}
     678:	8552                	mv	a0,s4
     67a:	70a6                	ld	ra,104(sp)
     67c:	7406                	ld	s0,96(sp)
     67e:	64e6                	ld	s1,88(sp)
     680:	6946                	ld	s2,80(sp)
     682:	69a6                	ld	s3,72(sp)
     684:	6a06                	ld	s4,64(sp)
     686:	7ae2                	ld	s5,56(sp)
     688:	7b42                	ld	s6,48(sp)
     68a:	7ba2                	ld	s7,40(sp)
     68c:	7c02                	ld	s8,32(sp)
     68e:	6ce2                	ld	s9,24(sp)
     690:	6165                	addi	sp,sp,112
     692:	8082                	ret

0000000000000694 <parseexec>:
    return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     694:	7119                	addi	sp,sp,-128
     696:	fc86                	sd	ra,120(sp)
     698:	f8a2                	sd	s0,112(sp)
     69a:	f4a6                	sd	s1,104(sp)
     69c:	e8d2                	sd	s4,80(sp)
     69e:	e4d6                	sd	s5,72(sp)
     6a0:	0100                	addi	s0,sp,128
     6a2:	8a2a                	mv	s4,a0
     6a4:	8aae                	mv	s5,a1
    char *q, *eq;
    int tok, argc;
    struct execcmd *cmd;
    struct cmd *ret;

    if (peek(ps, es, "("))
     6a6:	00001617          	auipc	a2,0x1
     6aa:	5d260613          	addi	a2,a2,1490 # 1c78 <malloc+0x174>
     6ae:	00000097          	auipc	ra,0x0
     6b2:	e7a080e7          	jalr	-390(ra) # 528 <peek>
     6b6:	e521                	bnez	a0,6fe <parseexec+0x6a>
     6b8:	f0ca                	sd	s2,96(sp)
     6ba:	ecce                	sd	s3,88(sp)
     6bc:	e0da                	sd	s6,64(sp)
     6be:	fc5e                	sd	s7,56(sp)
     6c0:	f862                	sd	s8,48(sp)
     6c2:	f466                	sd	s9,40(sp)
     6c4:	f06a                	sd	s10,32(sp)
     6c6:	ec6e                	sd	s11,24(sp)
     6c8:	892a                	mv	s2,a0
        return parseblock(ps, es);

    ret = execcmd();
     6ca:	00000097          	auipc	ra,0x0
     6ce:	bb0080e7          	jalr	-1104(ra) # 27a <execcmd>
     6d2:	89aa                	mv	s3,a0
     6d4:	8daa                	mv	s11,a0
    cmd = (struct execcmd *)ret;

    argc = 0;
    ret = parseredirs(ret, ps, es);
     6d6:	8656                	mv	a2,s5
     6d8:	85d2                	mv	a1,s4
     6da:	00000097          	auipc	ra,0x0
     6de:	eba080e7          	jalr	-326(ra) # 594 <parseredirs>
     6e2:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     6e4:	09a1                	addi	s3,s3,8
     6e6:	00001b17          	auipc	s6,0x1
     6ea:	5b2b0b13          	addi	s6,s6,1458 # 1c98 <malloc+0x194>
    {
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     6ee:	f8040c13          	addi	s8,s0,-128
     6f2:	f8840b93          	addi	s7,s0,-120
            break;
        if (tok != 'a')
     6f6:	06100d13          	li	s10,97
            panic("syntax");
        cmd->argv[argc] = q;
        cmd->eargv[argc] = eq;
        argc++;
        if (argc >= MAXARGS)
     6fa:	4ca9                	li	s9,10
    while (!peek(ps, es, "|)&;"))
     6fc:	a089                	j	73e <parseexec+0xaa>
        return parseblock(ps, es);
     6fe:	85d6                	mv	a1,s5
     700:	8552                	mv	a0,s4
     702:	00000097          	auipc	ra,0x0
     706:	1c4080e7          	jalr	452(ra) # 8c6 <parseblock>
     70a:	84aa                	mv	s1,a0
        ret = parseredirs(ret, ps, es);
    }
    cmd->argv[argc] = 0;
    cmd->eargv[argc] = 0;
    return ret;
}
     70c:	8526                	mv	a0,s1
     70e:	70e6                	ld	ra,120(sp)
     710:	7446                	ld	s0,112(sp)
     712:	74a6                	ld	s1,104(sp)
     714:	6a46                	ld	s4,80(sp)
     716:	6aa6                	ld	s5,72(sp)
     718:	6109                	addi	sp,sp,128
     71a:	8082                	ret
            panic("syntax");
     71c:	00001517          	auipc	a0,0x1
     720:	56450513          	addi	a0,a0,1380 # 1c80 <malloc+0x17c>
     724:	00000097          	auipc	ra,0x0
     728:	932080e7          	jalr	-1742(ra) # 56 <panic>
        if (argc >= MAXARGS)
     72c:	09a1                	addi	s3,s3,8
        ret = parseredirs(ret, ps, es);
     72e:	8656                	mv	a2,s5
     730:	85d2                	mv	a1,s4
     732:	8526                	mv	a0,s1
     734:	00000097          	auipc	ra,0x0
     738:	e60080e7          	jalr	-416(ra) # 594 <parseredirs>
     73c:	84aa                	mv	s1,a0
    while (!peek(ps, es, "|)&;"))
     73e:	865a                	mv	a2,s6
     740:	85d6                	mv	a1,s5
     742:	8552                	mv	a0,s4
     744:	00000097          	auipc	ra,0x0
     748:	de4080e7          	jalr	-540(ra) # 528 <peek>
     74c:	ed1d                	bnez	a0,78a <parseexec+0xf6>
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     74e:	86e2                	mv	a3,s8
     750:	865e                	mv	a2,s7
     752:	85d6                	mv	a1,s5
     754:	8552                	mv	a0,s4
     756:	00000097          	auipc	ra,0x0
     75a:	c8a080e7          	jalr	-886(ra) # 3e0 <gettoken>
     75e:	c515                	beqz	a0,78a <parseexec+0xf6>
        if (tok != 'a')
     760:	fba51ee3          	bne	a0,s10,71c <parseexec+0x88>
        cmd->argv[argc] = q;
     764:	f8843783          	ld	a5,-120(s0)
     768:	00f9b023          	sd	a5,0(s3)
        cmd->eargv[argc] = eq;
     76c:	f8043783          	ld	a5,-128(s0)
     770:	04f9b823          	sd	a5,80(s3)
        argc++;
     774:	2905                	addiw	s2,s2,1
        if (argc >= MAXARGS)
     776:	fb991be3          	bne	s2,s9,72c <parseexec+0x98>
            panic("too many args");
     77a:	00001517          	auipc	a0,0x1
     77e:	50e50513          	addi	a0,a0,1294 # 1c88 <malloc+0x184>
     782:	00000097          	auipc	ra,0x0
     786:	8d4080e7          	jalr	-1836(ra) # 56 <panic>
    cmd->argv[argc] = 0;
     78a:	090e                	slli	s2,s2,0x3
     78c:	012d87b3          	add	a5,s11,s2
     790:	0007b423          	sd	zero,8(a5)
    cmd->eargv[argc] = 0;
     794:	0407bc23          	sd	zero,88(a5)
     798:	7906                	ld	s2,96(sp)
     79a:	69e6                	ld	s3,88(sp)
     79c:	6b06                	ld	s6,64(sp)
     79e:	7be2                	ld	s7,56(sp)
     7a0:	7c42                	ld	s8,48(sp)
     7a2:	7ca2                	ld	s9,40(sp)
     7a4:	7d02                	ld	s10,32(sp)
     7a6:	6de2                	ld	s11,24(sp)
    return ret;
     7a8:	b795                	j	70c <parseexec+0x78>

00000000000007aa <parsepipe>:
{
     7aa:	7179                	addi	sp,sp,-48
     7ac:	f406                	sd	ra,40(sp)
     7ae:	f022                	sd	s0,32(sp)
     7b0:	ec26                	sd	s1,24(sp)
     7b2:	e84a                	sd	s2,16(sp)
     7b4:	e44e                	sd	s3,8(sp)
     7b6:	e052                	sd	s4,0(sp)
     7b8:	1800                	addi	s0,sp,48
     7ba:	892a                	mv	s2,a0
     7bc:	8a2a                	mv	s4,a0
     7be:	84ae                	mv	s1,a1
    cmd = parseexec(ps, es);
     7c0:	00000097          	auipc	ra,0x0
     7c4:	ed4080e7          	jalr	-300(ra) # 694 <parseexec>
     7c8:	89aa                	mv	s3,a0
    if (peek(ps, es, "|"))
     7ca:	00001617          	auipc	a2,0x1
     7ce:	4d660613          	addi	a2,a2,1238 # 1ca0 <malloc+0x19c>
     7d2:	85a6                	mv	a1,s1
     7d4:	854a                	mv	a0,s2
     7d6:	00000097          	auipc	ra,0x0
     7da:	d52080e7          	jalr	-686(ra) # 528 <peek>
     7de:	e911                	bnez	a0,7f2 <parsepipe+0x48>
}
     7e0:	854e                	mv	a0,s3
     7e2:	70a2                	ld	ra,40(sp)
     7e4:	7402                	ld	s0,32(sp)
     7e6:	64e2                	ld	s1,24(sp)
     7e8:	6942                	ld	s2,16(sp)
     7ea:	69a2                	ld	s3,8(sp)
     7ec:	6a02                	ld	s4,0(sp)
     7ee:	6145                	addi	sp,sp,48
     7f0:	8082                	ret
        gettoken(ps, es, 0, 0);
     7f2:	4681                	li	a3,0
     7f4:	4601                	li	a2,0
     7f6:	85a6                	mv	a1,s1
     7f8:	8552                	mv	a0,s4
     7fa:	00000097          	auipc	ra,0x0
     7fe:	be6080e7          	jalr	-1050(ra) # 3e0 <gettoken>
        cmd = pipecmd(cmd, parsepipe(ps, es));
     802:	85a6                	mv	a1,s1
     804:	8552                	mv	a0,s4
     806:	00000097          	auipc	ra,0x0
     80a:	fa4080e7          	jalr	-92(ra) # 7aa <parsepipe>
     80e:	85aa                	mv	a1,a0
     810:	854e                	mv	a0,s3
     812:	00000097          	auipc	ra,0x0
     816:	b06080e7          	jalr	-1274(ra) # 318 <pipecmd>
     81a:	89aa                	mv	s3,a0
    return cmd;
     81c:	b7d1                	j	7e0 <parsepipe+0x36>

000000000000081e <parseline>:
{
     81e:	7179                	addi	sp,sp,-48
     820:	f406                	sd	ra,40(sp)
     822:	f022                	sd	s0,32(sp)
     824:	ec26                	sd	s1,24(sp)
     826:	e84a                	sd	s2,16(sp)
     828:	e44e                	sd	s3,8(sp)
     82a:	e052                	sd	s4,0(sp)
     82c:	1800                	addi	s0,sp,48
     82e:	892a                	mv	s2,a0
     830:	89ae                	mv	s3,a1
    cmd = parsepipe(ps, es);
     832:	00000097          	auipc	ra,0x0
     836:	f78080e7          	jalr	-136(ra) # 7aa <parsepipe>
     83a:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     83c:	00001a17          	auipc	s4,0x1
     840:	46ca0a13          	addi	s4,s4,1132 # 1ca8 <malloc+0x1a4>
     844:	a839                	j	862 <parseline+0x44>
        gettoken(ps, es, 0, 0);
     846:	4681                	li	a3,0
     848:	4601                	li	a2,0
     84a:	85ce                	mv	a1,s3
     84c:	854a                	mv	a0,s2
     84e:	00000097          	auipc	ra,0x0
     852:	b92080e7          	jalr	-1134(ra) # 3e0 <gettoken>
        cmd = backcmd(cmd);
     856:	8526                	mv	a0,s1
     858:	00000097          	auipc	ra,0x0
     85c:	b4c080e7          	jalr	-1204(ra) # 3a4 <backcmd>
     860:	84aa                	mv	s1,a0
    while (peek(ps, es, "&"))
     862:	8652                	mv	a2,s4
     864:	85ce                	mv	a1,s3
     866:	854a                	mv	a0,s2
     868:	00000097          	auipc	ra,0x0
     86c:	cc0080e7          	jalr	-832(ra) # 528 <peek>
     870:	f979                	bnez	a0,846 <parseline+0x28>
    if (peek(ps, es, ";"))
     872:	00001617          	auipc	a2,0x1
     876:	43e60613          	addi	a2,a2,1086 # 1cb0 <malloc+0x1ac>
     87a:	85ce                	mv	a1,s3
     87c:	854a                	mv	a0,s2
     87e:	00000097          	auipc	ra,0x0
     882:	caa080e7          	jalr	-854(ra) # 528 <peek>
     886:	e911                	bnez	a0,89a <parseline+0x7c>
}
     888:	8526                	mv	a0,s1
     88a:	70a2                	ld	ra,40(sp)
     88c:	7402                	ld	s0,32(sp)
     88e:	64e2                	ld	s1,24(sp)
     890:	6942                	ld	s2,16(sp)
     892:	69a2                	ld	s3,8(sp)
     894:	6a02                	ld	s4,0(sp)
     896:	6145                	addi	sp,sp,48
     898:	8082                	ret
        gettoken(ps, es, 0, 0);
     89a:	4681                	li	a3,0
     89c:	4601                	li	a2,0
     89e:	85ce                	mv	a1,s3
     8a0:	854a                	mv	a0,s2
     8a2:	00000097          	auipc	ra,0x0
     8a6:	b3e080e7          	jalr	-1218(ra) # 3e0 <gettoken>
        cmd = listcmd(cmd, parseline(ps, es));
     8aa:	85ce                	mv	a1,s3
     8ac:	854a                	mv	a0,s2
     8ae:	00000097          	auipc	ra,0x0
     8b2:	f70080e7          	jalr	-144(ra) # 81e <parseline>
     8b6:	85aa                	mv	a1,a0
     8b8:	8526                	mv	a0,s1
     8ba:	00000097          	auipc	ra,0x0
     8be:	aa4080e7          	jalr	-1372(ra) # 35e <listcmd>
     8c2:	84aa                	mv	s1,a0
    return cmd;
     8c4:	b7d1                	j	888 <parseline+0x6a>

00000000000008c6 <parseblock>:
{
     8c6:	7179                	addi	sp,sp,-48
     8c8:	f406                	sd	ra,40(sp)
     8ca:	f022                	sd	s0,32(sp)
     8cc:	ec26                	sd	s1,24(sp)
     8ce:	e84a                	sd	s2,16(sp)
     8d0:	e44e                	sd	s3,8(sp)
     8d2:	1800                	addi	s0,sp,48
     8d4:	84aa                	mv	s1,a0
     8d6:	892e                	mv	s2,a1
    if (!peek(ps, es, "("))
     8d8:	00001617          	auipc	a2,0x1
     8dc:	3a060613          	addi	a2,a2,928 # 1c78 <malloc+0x174>
     8e0:	00000097          	auipc	ra,0x0
     8e4:	c48080e7          	jalr	-952(ra) # 528 <peek>
     8e8:	c12d                	beqz	a0,94a <parseblock+0x84>
    gettoken(ps, es, 0, 0);
     8ea:	4681                	li	a3,0
     8ec:	4601                	li	a2,0
     8ee:	85ca                	mv	a1,s2
     8f0:	8526                	mv	a0,s1
     8f2:	00000097          	auipc	ra,0x0
     8f6:	aee080e7          	jalr	-1298(ra) # 3e0 <gettoken>
    cmd = parseline(ps, es);
     8fa:	85ca                	mv	a1,s2
     8fc:	8526                	mv	a0,s1
     8fe:	00000097          	auipc	ra,0x0
     902:	f20080e7          	jalr	-224(ra) # 81e <parseline>
     906:	89aa                	mv	s3,a0
    if (!peek(ps, es, ")"))
     908:	00001617          	auipc	a2,0x1
     90c:	3c060613          	addi	a2,a2,960 # 1cc8 <malloc+0x1c4>
     910:	85ca                	mv	a1,s2
     912:	8526                	mv	a0,s1
     914:	00000097          	auipc	ra,0x0
     918:	c14080e7          	jalr	-1004(ra) # 528 <peek>
     91c:	cd1d                	beqz	a0,95a <parseblock+0x94>
    gettoken(ps, es, 0, 0);
     91e:	4681                	li	a3,0
     920:	4601                	li	a2,0
     922:	85ca                	mv	a1,s2
     924:	8526                	mv	a0,s1
     926:	00000097          	auipc	ra,0x0
     92a:	aba080e7          	jalr	-1350(ra) # 3e0 <gettoken>
    cmd = parseredirs(cmd, ps, es);
     92e:	864a                	mv	a2,s2
     930:	85a6                	mv	a1,s1
     932:	854e                	mv	a0,s3
     934:	00000097          	auipc	ra,0x0
     938:	c60080e7          	jalr	-928(ra) # 594 <parseredirs>
}
     93c:	70a2                	ld	ra,40(sp)
     93e:	7402                	ld	s0,32(sp)
     940:	64e2                	ld	s1,24(sp)
     942:	6942                	ld	s2,16(sp)
     944:	69a2                	ld	s3,8(sp)
     946:	6145                	addi	sp,sp,48
     948:	8082                	ret
        panic("parseblock");
     94a:	00001517          	auipc	a0,0x1
     94e:	36e50513          	addi	a0,a0,878 # 1cb8 <malloc+0x1b4>
     952:	fffff097          	auipc	ra,0xfffff
     956:	704080e7          	jalr	1796(ra) # 56 <panic>
        panic("syntax - missing )");
     95a:	00001517          	auipc	a0,0x1
     95e:	37650513          	addi	a0,a0,886 # 1cd0 <malloc+0x1cc>
     962:	fffff097          	auipc	ra,0xfffff
     966:	6f4080e7          	jalr	1780(ra) # 56 <panic>

000000000000096a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     96a:	1101                	addi	sp,sp,-32
     96c:	ec06                	sd	ra,24(sp)
     96e:	e822                	sd	s0,16(sp)
     970:	e426                	sd	s1,8(sp)
     972:	1000                	addi	s0,sp,32
     974:	84aa                	mv	s1,a0
    struct execcmd *ecmd;
    struct listcmd *lcmd;
    struct pipecmd *pcmd;
    struct redircmd *rcmd;

    if (cmd == 0)
     976:	c521                	beqz	a0,9be <nulterminate+0x54>
        return 0;

    switch (cmd->type)
     978:	4118                	lw	a4,0(a0)
     97a:	4795                	li	a5,5
     97c:	04e7e163          	bltu	a5,a4,9be <nulterminate+0x54>
     980:	00056783          	lwu	a5,0(a0)
     984:	078a                	slli	a5,a5,0x2
     986:	00001717          	auipc	a4,0x1
     98a:	4a270713          	addi	a4,a4,1186 # 1e28 <malloc+0x324>
     98e:	97ba                	add	a5,a5,a4
     990:	439c                	lw	a5,0(a5)
     992:	97ba                	add	a5,a5,a4
     994:	8782                	jr	a5
    {
    case EXEC:
        ecmd = (struct execcmd *)cmd;
        for (i = 0; ecmd->argv[i]; i++)
     996:	651c                	ld	a5,8(a0)
     998:	c39d                	beqz	a5,9be <nulterminate+0x54>
     99a:	01050793          	addi	a5,a0,16
            *ecmd->eargv[i] = 0;
     99e:	67b8                	ld	a4,72(a5)
     9a0:	00070023          	sb	zero,0(a4)
        for (i = 0; ecmd->argv[i]; i++)
     9a4:	07a1                	addi	a5,a5,8
     9a6:	ff87b703          	ld	a4,-8(a5)
     9aa:	fb75                	bnez	a4,99e <nulterminate+0x34>
     9ac:	a809                	j	9be <nulterminate+0x54>
        break;

    case REDIR:
        rcmd = (struct redircmd *)cmd;
        nulterminate(rcmd->cmd);
     9ae:	6508                	ld	a0,8(a0)
     9b0:	00000097          	auipc	ra,0x0
     9b4:	fba080e7          	jalr	-70(ra) # 96a <nulterminate>
        *rcmd->efile = 0;
     9b8:	6c9c                	ld	a5,24(s1)
     9ba:	00078023          	sb	zero,0(a5)
        bcmd = (struct backcmd *)cmd;
        nulterminate(bcmd->cmd);
        break;
    }
    return cmd;
}
     9be:	8526                	mv	a0,s1
     9c0:	60e2                	ld	ra,24(sp)
     9c2:	6442                	ld	s0,16(sp)
     9c4:	64a2                	ld	s1,8(sp)
     9c6:	6105                	addi	sp,sp,32
     9c8:	8082                	ret
        nulterminate(pcmd->left);
     9ca:	6508                	ld	a0,8(a0)
     9cc:	00000097          	auipc	ra,0x0
     9d0:	f9e080e7          	jalr	-98(ra) # 96a <nulterminate>
        nulterminate(pcmd->right);
     9d4:	6888                	ld	a0,16(s1)
     9d6:	00000097          	auipc	ra,0x0
     9da:	f94080e7          	jalr	-108(ra) # 96a <nulterminate>
        break;
     9de:	b7c5                	j	9be <nulterminate+0x54>
        nulterminate(lcmd->left);
     9e0:	6508                	ld	a0,8(a0)
     9e2:	00000097          	auipc	ra,0x0
     9e6:	f88080e7          	jalr	-120(ra) # 96a <nulterminate>
        nulterminate(lcmd->right);
     9ea:	6888                	ld	a0,16(s1)
     9ec:	00000097          	auipc	ra,0x0
     9f0:	f7e080e7          	jalr	-130(ra) # 96a <nulterminate>
        break;
     9f4:	b7e9                	j	9be <nulterminate+0x54>
        nulterminate(bcmd->cmd);
     9f6:	6508                	ld	a0,8(a0)
     9f8:	00000097          	auipc	ra,0x0
     9fc:	f72080e7          	jalr	-142(ra) # 96a <nulterminate>
        break;
     a00:	bf7d                	j	9be <nulterminate+0x54>

0000000000000a02 <parsecmd>:
{
     a02:	7139                	addi	sp,sp,-64
     a04:	fc06                	sd	ra,56(sp)
     a06:	f822                	sd	s0,48(sp)
     a08:	f426                	sd	s1,40(sp)
     a0a:	f04a                	sd	s2,32(sp)
     a0c:	ec4e                	sd	s3,24(sp)
     a0e:	0080                	addi	s0,sp,64
     a10:	fca43423          	sd	a0,-56(s0)
    es = s + strlen(s);
     a14:	84aa                	mv	s1,a0
     a16:	00001097          	auipc	ra,0x1
     a1a:	a76080e7          	jalr	-1418(ra) # 148c <strlen>
     a1e:	1502                	slli	a0,a0,0x20
     a20:	9101                	srli	a0,a0,0x20
     a22:	94aa                	add	s1,s1,a0
    cmd = parseline(&s, es);
     a24:	fc840913          	addi	s2,s0,-56
     a28:	85a6                	mv	a1,s1
     a2a:	854a                	mv	a0,s2
     a2c:	00000097          	auipc	ra,0x0
     a30:	df2080e7          	jalr	-526(ra) # 81e <parseline>
     a34:	89aa                	mv	s3,a0
    peek(&s, es, "");
     a36:	00001617          	auipc	a2,0x1
     a3a:	1d260613          	addi	a2,a2,466 # 1c08 <malloc+0x104>
     a3e:	85a6                	mv	a1,s1
     a40:	854a                	mv	a0,s2
     a42:	00000097          	auipc	ra,0x0
     a46:	ae6080e7          	jalr	-1306(ra) # 528 <peek>
    if (s != es)
     a4a:	fc843603          	ld	a2,-56(s0)
     a4e:	00961f63          	bne	a2,s1,a6c <parsecmd+0x6a>
    nulterminate(cmd);
     a52:	854e                	mv	a0,s3
     a54:	00000097          	auipc	ra,0x0
     a58:	f16080e7          	jalr	-234(ra) # 96a <nulterminate>
}
     a5c:	854e                	mv	a0,s3
     a5e:	70e2                	ld	ra,56(sp)
     a60:	7442                	ld	s0,48(sp)
     a62:	74a2                	ld	s1,40(sp)
     a64:	7902                	ld	s2,32(sp)
     a66:	69e2                	ld	s3,24(sp)
     a68:	6121                	addi	sp,sp,64
     a6a:	8082                	ret
        fprintf(2, "leftovers: %s\n", s);
     a6c:	00001597          	auipc	a1,0x1
     a70:	27c58593          	addi	a1,a1,636 # 1ce8 <malloc+0x1e4>
     a74:	4509                	li	a0,2
     a76:	00001097          	auipc	ra,0x1
     a7a:	fa4080e7          	jalr	-92(ra) # 1a1a <fprintf>
        panic("syntax");
     a7e:	00001517          	auipc	a0,0x1
     a82:	20250513          	addi	a0,a0,514 # 1c80 <malloc+0x17c>
     a86:	fffff097          	auipc	ra,0xfffff
     a8a:	5d0080e7          	jalr	1488(ra) # 56 <panic>

0000000000000a8e <parse_buffer>:
{
     a8e:	1101                	addi	sp,sp,-32
     a90:	ec06                	sd	ra,24(sp)
     a92:	e822                	sd	s0,16(sp)
     a94:	e426                	sd	s1,8(sp)
     a96:	1000                	addi	s0,sp,32
     a98:	84aa                	mv	s1,a0
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     a9a:	00054783          	lbu	a5,0(a0)
     a9e:	06300713          	li	a4,99
     aa2:	02e78b63          	beq	a5,a4,ad8 <parse_buffer+0x4a>
    if (buf[0] == 'e' &&
     aa6:	06500713          	li	a4,101
     aaa:	00e79863          	bne	a5,a4,aba <parse_buffer+0x2c>
     aae:	00154703          	lbu	a4,1(a0)
     ab2:	07800793          	li	a5,120
     ab6:	06f70b63          	beq	a4,a5,b2c <parse_buffer+0x9e>
    if (fork1() == 0)
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5c2080e7          	jalr	1474(ra) # 7c <fork1>
     ac2:	c551                	beqz	a0,b4e <parse_buffer+0xc0>
    wait(0);
     ac4:	4501                	li	a0,0
     ac6:	00001097          	auipc	ra,0x1
     aca:	c0c080e7          	jalr	-1012(ra) # 16d2 <wait>
}
     ace:	60e2                	ld	ra,24(sp)
     ad0:	6442                	ld	s0,16(sp)
     ad2:	64a2                	ld	s1,8(sp)
     ad4:	6105                	addi	sp,sp,32
     ad6:	8082                	ret
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     ad8:	00154703          	lbu	a4,1(a0)
     adc:	06400793          	li	a5,100
     ae0:	fcf71de3          	bne	a4,a5,aba <parse_buffer+0x2c>
     ae4:	00254703          	lbu	a4,2(a0)
     ae8:	02000793          	li	a5,32
     aec:	fcf717e3          	bne	a4,a5,aba <parse_buffer+0x2c>
        buf[strlen(buf) - 1] = 0; // chop \n
     af0:	00001097          	auipc	ra,0x1
     af4:	99c080e7          	jalr	-1636(ra) # 148c <strlen>
     af8:	fff5079b          	addiw	a5,a0,-1
     afc:	1782                	slli	a5,a5,0x20
     afe:	9381                	srli	a5,a5,0x20
     b00:	97a6                	add	a5,a5,s1
     b02:	00078023          	sb	zero,0(a5)
        if (chdir(buf + 3) < 0)
     b06:	048d                	addi	s1,s1,3
     b08:	8526                	mv	a0,s1
     b0a:	00001097          	auipc	ra,0x1
     b0e:	c30080e7          	jalr	-976(ra) # 173a <chdir>
     b12:	fa055ee3          	bgez	a0,ace <parse_buffer+0x40>
            fprintf(2, "cannot cd %s\n", buf + 3);
     b16:	8626                	mv	a2,s1
     b18:	00001597          	auipc	a1,0x1
     b1c:	1e058593          	addi	a1,a1,480 # 1cf8 <malloc+0x1f4>
     b20:	4509                	li	a0,2
     b22:	00001097          	auipc	ra,0x1
     b26:	ef8080e7          	jalr	-264(ra) # 1a1a <fprintf>
     b2a:	b755                	j	ace <parse_buffer+0x40>
        buf[1] == 'x' &&
     b2c:	00254703          	lbu	a4,2(a0)
     b30:	06900793          	li	a5,105
     b34:	f8f713e3          	bne	a4,a5,aba <parse_buffer+0x2c>
        buf[2] == 'i' &&
     b38:	00354703          	lbu	a4,3(a0)
     b3c:	07400793          	li	a5,116
     b40:	f6f71de3          	bne	a4,a5,aba <parse_buffer+0x2c>
        exit(0);
     b44:	4501                	li	a0,0
     b46:	00001097          	auipc	ra,0x1
     b4a:	b84080e7          	jalr	-1148(ra) # 16ca <exit>
        runcmd(parsecmd(buf));
     b4e:	8526                	mv	a0,s1
     b50:	00000097          	auipc	ra,0x0
     b54:	eb2080e7          	jalr	-334(ra) # a02 <parsecmd>
     b58:	fffff097          	auipc	ra,0xfffff
     b5c:	552080e7          	jalr	1362(ra) # aa <runcmd>

0000000000000b60 <main>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	e052                	sd	s4,0(sp)
     b6e:	1800                	addi	s0,sp,48
     b70:	89aa                	mv	s3,a0
     b72:	8a2e                	mv	s4,a1
    while ((fd = open("console", O_RDWR)) >= 0)
     b74:	4489                	li	s1,2
     b76:	00001917          	auipc	s2,0x1
     b7a:	19290913          	addi	s2,s2,402 # 1d08 <malloc+0x204>
     b7e:	85a6                	mv	a1,s1
     b80:	854a                	mv	a0,s2
     b82:	00001097          	auipc	ra,0x1
     b86:	b88080e7          	jalr	-1144(ra) # 170a <open>
     b8a:	00054863          	bltz	a0,b9a <main+0x3a>
        if (fd >= 3)
     b8e:	fea4d8e3          	bge	s1,a0,b7e <main+0x1e>
            close(fd);
     b92:	00001097          	auipc	ra,0x1
     b96:	b60080e7          	jalr	-1184(ra) # 16f2 <close>
    if (argc == 2)
     b9a:	4789                	li	a5,2
    while (getcmd(buf, sizeof(buf)) >= 0)
     b9c:	07800913          	li	s2,120
     ba0:	00001497          	auipc	s1,0x1
     ba4:	49048493          	addi	s1,s1,1168 # 2030 <buf.0>
    if (argc == 2)
     ba8:	08f99363          	bne	s3,a5,c2e <main+0xce>
        char *shell_script_file = argv[1];
     bac:	008a3483          	ld	s1,8(s4)
        int shfd = open(shell_script_file, O_RDWR);
     bb0:	85ce                	mv	a1,s3
     bb2:	8526                	mv	a0,s1
     bb4:	00001097          	auipc	ra,0x1
     bb8:	b56080e7          	jalr	-1194(ra) # 170a <open>
     bbc:	89aa                	mv	s3,a0
        if (shfd < 0)
     bbe:	04054563          	bltz	a0,c08 <main+0xa8>
        read(shfd, buf, sizeof(buf));
     bc2:	07800613          	li	a2,120
     bc6:	00001597          	auipc	a1,0x1
     bca:	46a58593          	addi	a1,a1,1130 # 2030 <buf.0>
     bce:	00001097          	auipc	ra,0x1
     bd2:	b14080e7          	jalr	-1260(ra) # 16e2 <read>
            parse_buffer(buf);
     bd6:	00001917          	auipc	s2,0x1
     bda:	45a90913          	addi	s2,s2,1114 # 2030 <buf.0>
        } while (read(shfd, buf, sizeof(buf)) == sizeof(buf));
     bde:	07800493          	li	s1,120
            parse_buffer(buf);
     be2:	854a                	mv	a0,s2
     be4:	00000097          	auipc	ra,0x0
     be8:	eaa080e7          	jalr	-342(ra) # a8e <parse_buffer>
        } while (read(shfd, buf, sizeof(buf)) == sizeof(buf));
     bec:	8626                	mv	a2,s1
     bee:	85ca                	mv	a1,s2
     bf0:	854e                	mv	a0,s3
     bf2:	00001097          	auipc	ra,0x1
     bf6:	af0080e7          	jalr	-1296(ra) # 16e2 <read>
     bfa:	fe9504e3          	beq	a0,s1,be2 <main+0x82>
        exit(0);
     bfe:	4501                	li	a0,0
     c00:	00001097          	auipc	ra,0x1
     c04:	aca080e7          	jalr	-1334(ra) # 16ca <exit>
            printf("Failed to open %s\n", shell_script_file);
     c08:	85a6                	mv	a1,s1
     c0a:	00001517          	auipc	a0,0x1
     c0e:	10650513          	addi	a0,a0,262 # 1d10 <malloc+0x20c>
     c12:	00001097          	auipc	ra,0x1
     c16:	e36080e7          	jalr	-458(ra) # 1a48 <printf>
            exit(1);
     c1a:	4505                	li	a0,1
     c1c:	00001097          	auipc	ra,0x1
     c20:	aae080e7          	jalr	-1362(ra) # 16ca <exit>
        parse_buffer(buf);
     c24:	8526                	mv	a0,s1
     c26:	00000097          	auipc	ra,0x0
     c2a:	e68080e7          	jalr	-408(ra) # a8e <parse_buffer>
    while (getcmd(buf, sizeof(buf)) >= 0)
     c2e:	85ca                	mv	a1,s2
     c30:	8526                	mv	a0,s1
     c32:	fffff097          	auipc	ra,0xfffff
     c36:	3ce080e7          	jalr	974(ra) # 0 <getcmd>
     c3a:	fe0555e3          	bgez	a0,c24 <main+0xc4>
    exit(0);
     c3e:	4501                	li	a0,0
     c40:	00001097          	auipc	ra,0x1
     c44:	a8a080e7          	jalr	-1398(ra) # 16ca <exit>

0000000000000c48 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     c48:	1141                	addi	sp,sp,-16
     c4a:	e406                	sd	ra,8(sp)
     c4c:	e022                	sd	s0,0(sp)
     c4e:	0800                	addi	s0,sp,16
    lk->name = name;
     c50:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     c52:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     c56:	57fd                	li	a5,-1
     c58:	00f50823          	sb	a5,16(a0)
}
     c5c:	60a2                	ld	ra,8(sp)
     c5e:	6402                	ld	s0,0(sp)
     c60:	0141                	addi	sp,sp,16
     c62:	8082                	ret

0000000000000c64 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     c64:	00054783          	lbu	a5,0(a0)
     c68:	e399                	bnez	a5,c6e <holding+0xa>
     c6a:	4501                	li	a0,0
}
     c6c:	8082                	ret
{
     c6e:	1101                	addi	sp,sp,-32
     c70:	ec06                	sd	ra,24(sp)
     c72:	e822                	sd	s0,16(sp)
     c74:	e426                	sd	s1,8(sp)
     c76:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     c78:	01054483          	lbu	s1,16(a0)
     c7c:	00000097          	auipc	ra,0x0
     c80:	63e080e7          	jalr	1598(ra) # 12ba <twhoami>
     c84:	2501                	sext.w	a0,a0
     c86:	40a48533          	sub	a0,s1,a0
     c8a:	00153513          	seqz	a0,a0
}
     c8e:	60e2                	ld	ra,24(sp)
     c90:	6442                	ld	s0,16(sp)
     c92:	64a2                	ld	s1,8(sp)
     c94:	6105                	addi	sp,sp,32
     c96:	8082                	ret

0000000000000c98 <acquire>:

void acquire(struct lock *lk)
{
     c98:	7179                	addi	sp,sp,-48
     c9a:	f406                	sd	ra,40(sp)
     c9c:	f022                	sd	s0,32(sp)
     c9e:	ec26                	sd	s1,24(sp)
     ca0:	e84a                	sd	s2,16(sp)
     ca2:	e44e                	sd	s3,8(sp)
     ca4:	1800                	addi	s0,sp,48
     ca6:	892a                	mv	s2,a0
    if (holding(lk))
     ca8:	00000097          	auipc	ra,0x0
     cac:	fbc080e7          	jalr	-68(ra) # c64 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     cb0:	ffc97493          	andi	s1,s2,-4
     cb4:	4985                	li	s3,1
    if (holding(lk))
     cb6:	c115                	beqz	a0,cda <acquire+0x42>
        printf("re-acquiring lock we already hold");
     cb8:	00001517          	auipc	a0,0x1
     cbc:	07050513          	addi	a0,a0,112 # 1d28 <malloc+0x224>
     cc0:	00001097          	auipc	ra,0x1
     cc4:	d88080e7          	jalr	-632(ra) # 1a48 <printf>
        exit(-1);
     cc8:	557d                	li	a0,-1
     cca:	00001097          	auipc	ra,0x1
     cce:	a00080e7          	jalr	-1536(ra) # 16ca <exit>
    {
        // give up the cpu for other threads
        tyield();
     cd2:	00000097          	auipc	ra,0x0
     cd6:	5b2080e7          	jalr	1458(ra) # 1284 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     cda:	00397713          	andi	a4,s2,3
     cde:	0037171b          	slliw	a4,a4,0x3
     ce2:	0ff00793          	li	a5,255
     ce6:	00e797bb          	sllw	a5,a5,a4
     cea:	fff7c613          	not	a2,a5
     cee:	00e996bb          	sllw	a3,s3,a4
     cf2:	8efd                	and	a3,a3,a5
     cf4:	1404a7af          	lr.w.aq	a5,(s1)
     cf8:	00c7f5b3          	and	a1,a5,a2
     cfc:	8dd5                	or	a1,a1,a3
     cfe:	18b4a5af          	sc.w	a1,a1,(s1)
     d02:	f9ed                	bnez	a1,cf4 <acquire+0x5c>
     d04:	40e7d7bb          	sraw	a5,a5,a4
     d08:	0ff7f793          	zext.b	a5,a5
     d0c:	f3f9                	bnez	a5,cd2 <acquire+0x3a>
    }

    __sync_synchronize();
     d0e:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     d12:	00000097          	auipc	ra,0x0
     d16:	5a8080e7          	jalr	1448(ra) # 12ba <twhoami>
     d1a:	00a90823          	sb	a0,16(s2)
}
     d1e:	70a2                	ld	ra,40(sp)
     d20:	7402                	ld	s0,32(sp)
     d22:	64e2                	ld	s1,24(sp)
     d24:	6942                	ld	s2,16(sp)
     d26:	69a2                	ld	s3,8(sp)
     d28:	6145                	addi	sp,sp,48
     d2a:	8082                	ret

0000000000000d2c <release>:

void release(struct lock *lk)
{
     d2c:	1101                	addi	sp,sp,-32
     d2e:	ec06                	sd	ra,24(sp)
     d30:	e822                	sd	s0,16(sp)
     d32:	e426                	sd	s1,8(sp)
     d34:	1000                	addi	s0,sp,32
     d36:	84aa                	mv	s1,a0
    if (!holding(lk))
     d38:	00000097          	auipc	ra,0x0
     d3c:	f2c080e7          	jalr	-212(ra) # c64 <holding>
     d40:	c11d                	beqz	a0,d66 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     d42:	57fd                	li	a5,-1
     d44:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     d48:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     d4c:	0310000f          	fence	rw,w
     d50:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     d54:	00000097          	auipc	ra,0x0
     d58:	530080e7          	jalr	1328(ra) # 1284 <tyield>
}
     d5c:	60e2                	ld	ra,24(sp)
     d5e:	6442                	ld	s0,16(sp)
     d60:	64a2                	ld	s1,8(sp)
     d62:	6105                	addi	sp,sp,32
     d64:	8082                	ret
        printf("releasing lock we are not holding");
     d66:	00001517          	auipc	a0,0x1
     d6a:	fea50513          	addi	a0,a0,-22 # 1d50 <malloc+0x24c>
     d6e:	00001097          	auipc	ra,0x1
     d72:	cda080e7          	jalr	-806(ra) # 1a48 <printf>
        exit(-1);
     d76:	557d                	li	a0,-1
     d78:	00001097          	auipc	ra,0x1
     d7c:	952080e7          	jalr	-1710(ra) # 16ca <exit>

0000000000000d80 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     d80:	00001797          	auipc	a5,0x1
     d84:	2907c783          	lbu	a5,656(a5) # 2010 <threadlib_init_done>
     d88:	eba5                	bnez	a5,df8 <threadlib_init+0x78>
{
     d8a:	7179                	addi	sp,sp,-48
     d8c:	f406                	sd	ra,40(sp)
     d8e:	f022                	sd	s0,32(sp)
     d90:	ec26                	sd	s1,24(sp)
     d92:	e84a                	sd	s2,16(sp)
     d94:	e44e                	sd	s3,8(sp)
     d96:	e052                	sd	s4,0(sp)
     d98:	1800                	addi	s0,sp,48
     d9a:	00001497          	auipc	s1,0x1
     d9e:	30e48493          	addi	s1,s1,782 # 20a8 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     da2:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     da4:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     da8:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     daa:	8652                	mv	a2,s4
     dac:	4581                	li	a1,0
     dae:	8526                	mv	a0,s1
     db0:	00000097          	auipc	ra,0x0
     db4:	708080e7          	jalr	1800(ra) # 14b8 <memset>
        threads[i].tid = i;
     db8:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     dbc:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     dc0:	2905                	addiw	s2,s2,1
     dc2:	0b048493          	addi	s1,s1,176
     dc6:	ff3912e3          	bne	s2,s3,daa <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     dca:	00001797          	auipc	a5,0x1
     dce:	2de78793          	addi	a5,a5,734 # 20a8 <threads>
     dd2:	00001717          	auipc	a4,0x1
     dd6:	24f73323          	sd	a5,582(a4) # 2018 <current_thread>
    current_thread->state = RUNNING;
     dda:	4711                	li	a4,4
     ddc:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     dde:	4785                	li	a5,1
     de0:	00001717          	auipc	a4,0x1
     de4:	22f70823          	sb	a5,560(a4) # 2010 <threadlib_init_done>
}
     de8:	70a2                	ld	ra,40(sp)
     dea:	7402                	ld	s0,32(sp)
     dec:	64e2                	ld	s1,24(sp)
     dee:	6942                	ld	s2,16(sp)
     df0:	69a2                	ld	s3,8(sp)
     df2:	6a02                	ld	s4,0(sp)
     df4:	6145                	addi	sp,sp,48
     df6:	8082                	ret
     df8:	8082                	ret

0000000000000dfa <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     dfa:	1101                	addi	sp,sp,-32
     dfc:	ec06                	sd	ra,24(sp)
     dfe:	e822                	sd	s0,16(sp)
     e00:	e426                	sd	s1,8(sp)
     e02:	e04a                	sd	s2,0(sp)
     e04:	1000                	addi	s0,sp,32
     e06:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     e08:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     e0c:	6948                	ld	a0,144(a0)
     e0e:	c509                	beqz	a0,e18 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     e10:	00001097          	auipc	ra,0x1
     e14:	c6e080e7          	jalr	-914(ra) # 1a7e <free>
    }
    if (thread->result)
     e18:	70c8                	ld	a0,160(s1)
     e1a:	c509                	beqz	a0,e24 <reclaim_thread+0x2a>
    {
        free(thread->result);
     e1c:	00001097          	auipc	ra,0x1
     e20:	c62080e7          	jalr	-926(ra) # 1a7e <free>
    }

    memset(thread, 0, sizeof(*thread));
     e24:	0b000613          	li	a2,176
     e28:	4581                	li	a1,0
     e2a:	8526                	mv	a0,s1
     e2c:	00000097          	auipc	ra,0x0
     e30:	68c080e7          	jalr	1676(ra) # 14b8 <memset>
    thread->tid = tid;
     e34:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     e38:	0604ac23          	sw	zero,120(s1)
}
     e3c:	60e2                	ld	ra,24(sp)
     e3e:	6442                	ld	s0,16(sp)
     e40:	64a2                	ld	s1,8(sp)
     e42:	6902                	ld	s2,0(sp)
     e44:	6105                	addi	sp,sp,32
     e46:	8082                	ret

0000000000000e48 <tsched>:

void tsched()
{
     e48:	1141                	addi	sp,sp,-16
     e4a:	e406                	sd	ra,8(sp)
     e4c:	e022                	sd	s0,0(sp)
     e4e:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     e50:	00000097          	auipc	ra,0x0
     e54:	f30080e7          	jalr	-208(ra) # d80 <threadlib_init>
    prev = current_thread;
     e58:	00001517          	auipc	a0,0x1
     e5c:	1c053503          	ld	a0,448(a0) # 2018 <current_thread>
    if (prev->state == RUNNING)
     e60:	5d38                	lw	a4,120(a0)
     e62:	4791                	li	a5,4
     e64:	06f70763          	beq	a4,a5,ed2 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     e68:	00054603          	lbu	a2,0(a0)
     e6c:	0016069b          	addiw	a3,a2,1
     e70:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     e72:	00001897          	auipc	a7,0x1
     e76:	23688893          	addi	a7,a7,566 # 20a8 <threads>
     e7a:	0b000813          	li	a6,176
     e7e:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     e80:	41f6d71b          	sraiw	a4,a3,0x1f
     e84:	01c7571b          	srliw	a4,a4,0x1c
     e88:	00d707bb          	addw	a5,a4,a3
     e8c:	8bbd                	andi	a5,a5,15
     e8e:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     e90:	03078733          	mul	a4,a5,a6
     e94:	9746                	add	a4,a4,a7
     e96:	5f38                	lw	a4,120(a4)
     e98:	04b70063          	beq	a4,a1,ed8 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     e9c:	2685                	addiw	a3,a3,1
     e9e:	fec691e3          	bne	a3,a2,e80 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     ea2:	5d3c                	lw	a5,120(a0)
     ea4:	470d                	li	a4,3
     ea6:	06e78f63          	beq	a5,a4,f24 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     eaa:	4711                	li	a4,4
     eac:	06e78763          	beq	a5,a4,f1a <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     eb0:	00001597          	auipc	a1,0x1
     eb4:	ec858593          	addi	a1,a1,-312 # 1d78 <malloc+0x274>
     eb8:	00001517          	auipc	a0,0x1
     ebc:	ed050513          	addi	a0,a0,-304 # 1d88 <malloc+0x284>
     ec0:	00001097          	auipc	ra,0x1
     ec4:	b88080e7          	jalr	-1144(ra) # 1a48 <printf>
        exit(-1);
     ec8:	557d                	li	a0,-1
     eca:	00001097          	auipc	ra,0x1
     ece:	800080e7          	jalr	-2048(ra) # 16ca <exit>
        prev->state = RUNNABLE;
     ed2:	478d                	li	a5,3
     ed4:	dd3c                	sw	a5,120(a0)
     ed6:	bf49                	j	e68 <tsched+0x20>
            return &threads[idx];
     ed8:	0b000713          	li	a4,176
     edc:	02e78733          	mul	a4,a5,a4
     ee0:	00001697          	auipc	a3,0x1
     ee4:	1c868693          	addi	a3,a3,456 # 20a8 <threads>
     ee8:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     eea:	02d50c63          	beq	a0,a3,f22 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     eee:	00001617          	auipc	a2,0x1
     ef2:	12d63523          	sd	a3,298(a2) # 2018 <current_thread>
    next->state = RUNNING;
     ef6:	00001597          	auipc	a1,0x1
     efa:	1b258593          	addi	a1,a1,434 # 20a8 <threads>
     efe:	0b000693          	li	a3,176
     f02:	02d787b3          	mul	a5,a5,a3
     f06:	97ae                	add	a5,a5,a1
     f08:	4691                	li	a3,4
     f0a:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     f0c:	0721                	addi	a4,a4,8
     f0e:	95ba                	add	a1,a1,a4
     f10:	0521                	addi	a0,a0,8
     f12:	00000097          	auipc	ra,0x0
     f16:	488080e7          	jalr	1160(ra) # 139a <tswtch>
}
     f1a:	60a2                	ld	ra,8(sp)
     f1c:	6402                	ld	s0,0(sp)
     f1e:	0141                	addi	sp,sp,16
     f20:	8082                	ret
     f22:	8536                	mv	a0,a3
        next->state = RUNNING;
     f24:	4791                	li	a5,4
     f26:	dd3c                	sw	a5,120(a0)
        return;
     f28:	bfcd                	j	f1a <tsched+0xd2>

0000000000000f2a <thread_bootstrap>:
{
     f2a:	1101                	addi	sp,sp,-32
     f2c:	ec06                	sd	ra,24(sp)
     f2e:	e822                	sd	s0,16(sp)
     f30:	e426                	sd	s1,8(sp)
     f32:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     f34:	00001497          	auipc	s1,0x1
     f38:	0e44b483          	ld	s1,228(s1) # 2018 <current_thread>
    if (thread)
     f3c:	c09d                	beqz	s1,f62 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     f3e:	64dc                	ld	a5,136(s1)
     f40:	60c8                	ld	a0,128(s1)
     f42:	9782                	jalr	a5
     f44:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     f46:	00001497          	auipc	s1,0x1
     f4a:	0d24b483          	ld	s1,210(s1) # 2018 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     f4e:	09c4a603          	lw	a2,156(s1)
     f52:	ca01                	beqz	a2,f62 <thread_bootstrap+0x38>
     f54:	70c8                	ld	a0,160(s1)
     f56:	c591                	beqz	a1,f62 <thread_bootstrap+0x38>
     f58:	c509                	beqz	a0,f62 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     f5a:	00000097          	auipc	ra,0x0
     f5e:	6ba080e7          	jalr	1722(ra) # 1614 <memmove>
    thread->state = EXITED;
     f62:	4799                	li	a5,6
     f64:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     f66:	74dc                	ld	a5,168(s1)
     f68:	c789                	beqz	a5,f72 <thread_bootstrap+0x48>
     f6a:	5fb4                	lw	a3,120(a5)
     f6c:	4709                	li	a4,2
     f6e:	00e68b63          	beq	a3,a4,f84 <thread_bootstrap+0x5a>
    tsched();
     f72:	00000097          	auipc	ra,0x0
     f76:	ed6080e7          	jalr	-298(ra) # e48 <tsched>
    exit(-1);
     f7a:	557d                	li	a0,-1
     f7c:	00000097          	auipc	ra,0x0
     f80:	74e080e7          	jalr	1870(ra) # 16ca <exit>
        thread->joiner->state = RUNNABLE;
     f84:	470d                	li	a4,3
     f86:	dfb8                	sw	a4,120(a5)
     f88:	b7ed                	j	f72 <thread_bootstrap+0x48>

0000000000000f8a <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     f8a:	715d                	addi	sp,sp,-80
     f8c:	e486                	sd	ra,72(sp)
     f8e:	e0a2                	sd	s0,64(sp)
     f90:	fc26                	sd	s1,56(sp)
     f92:	f84a                	sd	s2,48(sp)
     f94:	f44e                	sd	s3,40(sp)
     f96:	f052                	sd	s4,32(sp)
     f98:	ec56                	sd	s5,24(sp)
     f9a:	e85a                	sd	s6,16(sp)
     f9c:	e45e                	sd	s7,8(sp)
     f9e:	e062                	sd	s8,0(sp)
     fa0:	0880                	addi	s0,sp,80
     fa2:	8b2a                	mv	s6,a0
     fa4:	84ae                	mv	s1,a1
     fa6:	8bb2                	mv	s7,a2
     fa8:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     faa:	00000097          	auipc	ra,0x0
     fae:	dd6080e7          	jalr	-554(ra) # d80 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     fb2:	c4b1                	beqz	s1,ffe <tcreate+0x74>
    {
        if (attr->stacksize)
     fb4:	0004a983          	lw	s3,0(s1)
     fb8:	00099363          	bnez	s3,fbe <tcreate+0x34>
    stacksize = PGSIZE;
     fbc:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     fbe:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     fc2:	00001797          	auipc	a5,0x1
     fc6:	20e78793          	addi	a5,a5,526 # 21d0 <threads+0x128>
     fca:	4485                	li	s1,1
     fcc:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     fce:	4398                	lw	a4,0(a5)
     fd0:	cb15                	beqz	a4,1004 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     fd2:	2485                	addiw	s1,s1,1
     fd4:	0b078793          	addi	a5,a5,176
     fd8:	feb49be3          	bne	s1,a1,fce <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     fdc:	00001597          	auipc	a1,0x1
     fe0:	d9c58593          	addi	a1,a1,-612 # 1d78 <malloc+0x274>
     fe4:	00001517          	auipc	a0,0x1
     fe8:	dbc50513          	addi	a0,a0,-580 # 1da0 <malloc+0x29c>
     fec:	00001097          	auipc	ra,0x1
     ff0:	a5c080e7          	jalr	-1444(ra) # 1a48 <printf>
        exit(-1);
     ff4:	557d                	li	a0,-1
     ff6:	00000097          	auipc	ra,0x0
     ffa:	6d4080e7          	jalr	1748(ra) # 16ca <exit>
    res_size = 0;
     ffe:	4a81                	li	s5,0
    stacksize = PGSIZE;
    1000:	6985                	lui	s3,0x1
    1002:	b7c1                	j	fc2 <tcreate+0x38>
            new_thread = &threads[i];
    1004:	0b000a13          	li	s4,176
    1008:	03448a33          	mul	s4,s1,s4
    100c:	00001917          	auipc	s2,0x1
    1010:	09c90913          	addi	s2,s2,156 # 20a8 <threads>
    1014:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
    1016:	0b000613          	li	a2,176
    101a:	4581                	li	a1,0
    101c:	854a                	mv	a0,s2
    101e:	00000097          	auipc	ra,0x0
    1022:	49a080e7          	jalr	1178(ra) # 14b8 <memset>
    new_thread->tid = new_thread - threads;
    1026:	404a5693          	srai	a3,s4,0x4
    102a:	000ba737          	lui	a4,0xba
    102e:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb7741>
    1032:	0732                	slli	a4,a4,0xc
    1034:	ba370713          	addi	a4,a4,-1117
    1038:	2e8ba7b7          	lui	a5,0x2e8ba
    103c:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b7740>
    1040:	1782                	slli	a5,a5,0x20
    1042:	97ba                	add	a5,a5,a4
    1044:	02f687b3          	mul	a5,a3,a5
    1048:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
    104c:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
    1050:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
    1054:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
    1058:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
    105c:	478d                	li	a5,3
    105e:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
    1062:	0109851b          	addiw	a0,s3,16 # 1010 <tcreate+0x86>
    1066:	00001097          	auipc	ra,0x1
    106a:	a9e080e7          	jalr	-1378(ra) # 1b04 <malloc>
    106e:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
    1072:	c951                	beqz	a0,1106 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
    1074:	020a8863          	beqz	s5,10a4 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
    1078:	8556                	mv	a0,s5
    107a:	00001097          	auipc	ra,0x1
    107e:	a8a080e7          	jalr	-1398(ra) # 1b04 <malloc>
    1082:	0b000713          	li	a4,176
    1086:	02e48733          	mul	a4,s1,a4
    108a:	00001797          	auipc	a5,0x1
    108e:	01e78793          	addi	a5,a5,30 # 20a8 <threads>
    1092:	97ba                	add	a5,a5,a4
    1094:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
    1096:	c949                	beqz	a0,1128 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
    1098:	8656                	mv	a2,s5
    109a:	4581                	li	a1,0
    109c:	00000097          	auipc	ra,0x0
    10a0:	41c080e7          	jalr	1052(ra) # 14b8 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
    10a4:	00001517          	auipc	a0,0x1
    10a8:	00450513          	addi	a0,a0,4 # 20a8 <threads>
    10ac:	0b000793          	li	a5,176
    10b0:	02f484b3          	mul	s1,s1,a5
    10b4:	94aa                	add	s1,s1,a0
    10b6:	1982                	slli	s3,s3,0x20
    10b8:	0209d993          	srli	s3,s3,0x20
    10bc:	09c1                	addi	s3,s3,16
    10be:	68dc                	ld	a5,144(s1)
    10c0:	99be                	add	s3,s3,a5
    10c2:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
    10c6:	0a21                	addi	s4,s4,8
    10c8:	07000613          	li	a2,112
    10cc:	4581                	li	a1,0
    10ce:	9552                	add	a0,a0,s4
    10d0:	00000097          	auipc	ra,0x0
    10d4:	3e8080e7          	jalr	1000(ra) # 14b8 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
    10d8:	00000797          	auipc	a5,0x0
    10dc:	e5278793          	addi	a5,a5,-430 # f2a <thread_bootstrap>
    10e0:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
    10e2:	0134b823          	sd	s3,16(s1)

    if (thread)
    10e6:	000b0463          	beqz	s6,10ee <tcreate+0x164>
    {
        *thread = new_thread;
    10ea:	012b3023          	sd	s2,0(s6)
    }
}
    10ee:	60a6                	ld	ra,72(sp)
    10f0:	6406                	ld	s0,64(sp)
    10f2:	74e2                	ld	s1,56(sp)
    10f4:	7942                	ld	s2,48(sp)
    10f6:	79a2                	ld	s3,40(sp)
    10f8:	7a02                	ld	s4,32(sp)
    10fa:	6ae2                	ld	s5,24(sp)
    10fc:	6b42                	ld	s6,16(sp)
    10fe:	6ba2                	ld	s7,8(sp)
    1100:	6c02                	ld	s8,0(sp)
    1102:	6161                	addi	sp,sp,80
    1104:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
    1106:	00001597          	auipc	a1,0x1
    110a:	c7258593          	addi	a1,a1,-910 # 1d78 <malloc+0x274>
    110e:	00001517          	auipc	a0,0x1
    1112:	caa50513          	addi	a0,a0,-854 # 1db8 <malloc+0x2b4>
    1116:	00001097          	auipc	ra,0x1
    111a:	932080e7          	jalr	-1742(ra) # 1a48 <printf>
        exit(-1);
    111e:	557d                	li	a0,-1
    1120:	00000097          	auipc	ra,0x0
    1124:	5aa080e7          	jalr	1450(ra) # 16ca <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
    1128:	00001597          	auipc	a1,0x1
    112c:	c5058593          	addi	a1,a1,-944 # 1d78 <malloc+0x274>
    1130:	00001517          	auipc	a0,0x1
    1134:	cb050513          	addi	a0,a0,-848 # 1de0 <malloc+0x2dc>
    1138:	00001097          	auipc	ra,0x1
    113c:	910080e7          	jalr	-1776(ra) # 1a48 <printf>
            exit(-1);
    1140:	557d                	li	a0,-1
    1142:	00000097          	auipc	ra,0x0
    1146:	588080e7          	jalr	1416(ra) # 16ca <exit>

000000000000114a <tjoin>:

int tjoin(int tid, void *status, uint size)
{
    114a:	715d                	addi	sp,sp,-80
    114c:	e486                	sd	ra,72(sp)
    114e:	e0a2                	sd	s0,64(sp)
    1150:	f84a                	sd	s2,48(sp)
    1152:	e45e                	sd	s7,8(sp)
    1154:	e062                	sd	s8,0(sp)
    1156:	0880                	addi	s0,sp,80
    1158:	892a                	mv	s2,a0
    115a:	8bae                	mv	s7,a1
    115c:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
    115e:	00000097          	auipc	ra,0x0
    1162:	c22080e7          	jalr	-990(ra) # d80 <threadlib_init>
    if (current_thread->tid == tid)
    1166:	00001697          	auipc	a3,0x1
    116a:	eb26b683          	ld	a3,-334(a3) # 2018 <current_thread>
    116e:	0006c783          	lbu	a5,0(a3)
    1172:	0f278763          	beq	a5,s2,1260 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
    1176:	47bd                	li	a5,15
    1178:	0f27e663          	bltu	a5,s2,1264 <tjoin+0x11a>
    117c:	fc26                	sd	s1,56(sp)
    117e:	f44e                	sd	s3,40(sp)
    1180:	f052                	sd	s4,32(sp)
    1182:	ec56                	sd	s5,24(sp)
    1184:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
    1186:	0b000713          	li	a4,176
    118a:	02e90733          	mul	a4,s2,a4
    118e:	00001797          	auipc	a5,0x1
    1192:	f1a78793          	addi	a5,a5,-230 # 20a8 <threads>
    1196:	97ba                	add	a5,a5,a4
    1198:	5fbc                	lw	a5,120(a5)
    119a:	c7f9                	beqz	a5,1268 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
    119c:	0b000713          	li	a4,176
    11a0:	02e90733          	mul	a4,s2,a4
    11a4:	00001797          	auipc	a5,0x1
    11a8:	f0478793          	addi	a5,a5,-252 # 20a8 <threads>
    11ac:	97ba                	add	a5,a5,a4
    11ae:	77dc                	ld	a5,168(a5)
    11b0:	c399                	beqz	a5,11b6 <tjoin+0x6c>
    11b2:	0cf69263          	bne	a3,a5,1276 <tjoin+0x12c>
    return &threads[tid];
    11b6:	0b000b13          	li	s6,176
    11ba:	03690b33          	mul	s6,s2,s6
    11be:	00001797          	auipc	a5,0x1
    11c2:	eea78793          	addi	a5,a5,-278 # 20a8 <threads>
    11c6:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
    11c8:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
    11cc:	078b2703          	lw	a4,120(s6)
    11d0:	4799                	li	a5,6
    11d2:	02f70463          	beq	a4,a5,11fa <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
    11d6:	00001a97          	auipc	s5,0x1
    11da:	e42a8a93          	addi	s5,s5,-446 # 2018 <current_thread>
    11de:	4a09                	li	s4,2
    while (target->state != EXITED)
    11e0:	84da                	mv	s1,s6
    11e2:	4999                	li	s3,6
        current_thread->state = SLEEPING;
    11e4:	000ab783          	ld	a5,0(s5)
    11e8:	0747ac23          	sw	s4,120(a5)
        tsched();
    11ec:	00000097          	auipc	ra,0x0
    11f0:	c5c080e7          	jalr	-932(ra) # e48 <tsched>
    while (target->state != EXITED)
    11f4:	5cbc                	lw	a5,120(s1)
    11f6:	ff3797e3          	bne	a5,s3,11e4 <tjoin+0x9a>
    }

    if (status && size && target->result)
    11fa:	040b8163          	beqz	s7,123c <tjoin+0xf2>
    11fe:	020c0f63          	beqz	s8,123c <tjoin+0xf2>
    1202:	0b000713          	li	a4,176
    1206:	02e90733          	mul	a4,s2,a4
    120a:	00001797          	auipc	a5,0x1
    120e:	e9e78793          	addi	a5,a5,-354 # 20a8 <threads>
    1212:	97ba                	add	a5,a5,a4
    1214:	73cc                	ld	a1,160(a5)
    1216:	c19d                	beqz	a1,123c <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
    1218:	00001797          	auipc	a5,0x1
    121c:	e9078793          	addi	a5,a5,-368 # 20a8 <threads>
    1220:	97ba                	add	a5,a5,a4
    1222:	09c7a783          	lw	a5,156(a5)
    1226:	863e                	mv	a2,a5
    1228:	2781                	sext.w	a5,a5
    122a:	00fc7363          	bgeu	s8,a5,1230 <tjoin+0xe6>
    122e:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
    1230:	2601                	sext.w	a2,a2
    1232:	855e                	mv	a0,s7
    1234:	00000097          	auipc	ra,0x0
    1238:	3e0080e7          	jalr	992(ra) # 1614 <memmove>
    }

    reclaim_thread(target);
    123c:	855a                	mv	a0,s6
    123e:	00000097          	auipc	ra,0x0
    1242:	bbc080e7          	jalr	-1092(ra) # dfa <reclaim_thread>
    return 0;
    1246:	4501                	li	a0,0
    1248:	74e2                	ld	s1,56(sp)
    124a:	79a2                	ld	s3,40(sp)
    124c:	7a02                	ld	s4,32(sp)
    124e:	6ae2                	ld	s5,24(sp)
    1250:	6b42                	ld	s6,16(sp)
}
    1252:	60a6                	ld	ra,72(sp)
    1254:	6406                	ld	s0,64(sp)
    1256:	7942                	ld	s2,48(sp)
    1258:	6ba2                	ld	s7,8(sp)
    125a:	6c02                	ld	s8,0(sp)
    125c:	6161                	addi	sp,sp,80
    125e:	8082                	ret
        return -1;
    1260:	557d                	li	a0,-1
    1262:	bfc5                	j	1252 <tjoin+0x108>
        return -1;
    1264:	557d                	li	a0,-1
    1266:	b7f5                	j	1252 <tjoin+0x108>
    1268:	557d                	li	a0,-1
    126a:	74e2                	ld	s1,56(sp)
    126c:	79a2                	ld	s3,40(sp)
    126e:	7a02                	ld	s4,32(sp)
    1270:	6ae2                	ld	s5,24(sp)
    1272:	6b42                	ld	s6,16(sp)
    1274:	bff9                	j	1252 <tjoin+0x108>
        return -1;
    1276:	557d                	li	a0,-1
    1278:	74e2                	ld	s1,56(sp)
    127a:	79a2                	ld	s3,40(sp)
    127c:	7a02                	ld	s4,32(sp)
    127e:	6ae2                	ld	s5,24(sp)
    1280:	6b42                	ld	s6,16(sp)
    1282:	bfc1                	j	1252 <tjoin+0x108>

0000000000001284 <tyield>:

void tyield()
{
    1284:	1141                	addi	sp,sp,-16
    1286:	e406                	sd	ra,8(sp)
    1288:	e022                	sd	s0,0(sp)
    128a:	0800                	addi	s0,sp,16
    threadlib_init();
    128c:	00000097          	auipc	ra,0x0
    1290:	af4080e7          	jalr	-1292(ra) # d80 <threadlib_init>
    if (current_thread->state == RUNNING)
    1294:	00001797          	auipc	a5,0x1
    1298:	d847b783          	ld	a5,-636(a5) # 2018 <current_thread>
    129c:	5fb4                	lw	a3,120(a5)
    129e:	4711                	li	a4,4
    12a0:	00e68a63          	beq	a3,a4,12b4 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
    12a4:	00000097          	auipc	ra,0x0
    12a8:	ba4080e7          	jalr	-1116(ra) # e48 <tsched>
}
    12ac:	60a2                	ld	ra,8(sp)
    12ae:	6402                	ld	s0,0(sp)
    12b0:	0141                	addi	sp,sp,16
    12b2:	8082                	ret
        current_thread->state = RUNNABLE;
    12b4:	470d                	li	a4,3
    12b6:	dfb8                	sw	a4,120(a5)
    12b8:	b7f5                	j	12a4 <tyield+0x20>

00000000000012ba <twhoami>:

uint8 twhoami()
{
    12ba:	1141                	addi	sp,sp,-16
    12bc:	e406                	sd	ra,8(sp)
    12be:	e022                	sd	s0,0(sp)
    12c0:	0800                	addi	s0,sp,16
    threadlib_init();
    12c2:	00000097          	auipc	ra,0x0
    12c6:	abe080e7          	jalr	-1346(ra) # d80 <threadlib_init>
    return current_thread->tid;
}
    12ca:	00001797          	auipc	a5,0x1
    12ce:	d4e7b783          	ld	a5,-690(a5) # 2018 <current_thread>
    12d2:	0007c503          	lbu	a0,0(a5)
    12d6:	60a2                	ld	ra,8(sp)
    12d8:	6402                	ld	s0,0(sp)
    12da:	0141                	addi	sp,sp,16
    12dc:	8082                	ret

00000000000012de <twaitall>:

void twaitall(void)
{
    12de:	7179                	addi	sp,sp,-48
    12e0:	f406                	sd	ra,40(sp)
    12e2:	f022                	sd	s0,32(sp)
    12e4:	ec26                	sd	s1,24(sp)
    12e6:	e84a                	sd	s2,16(sp)
    12e8:	e44e                	sd	s3,8(sp)
    12ea:	1800                	addi	s0,sp,48
    threadlib_init();
    12ec:	00000097          	auipc	ra,0x0
    12f0:	a94080e7          	jalr	-1388(ra) # d80 <threadlib_init>
    12f4:	00002497          	auipc	s1,0x2
    12f8:	92c48493          	addi	s1,s1,-1748 # 2c20 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
    12fc:	4905                	li	s2,1
    12fe:	a035                	j	132a <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
    1300:	17f5                	addi	a5,a5,-3
    1302:	0017b793          	seqz	a5,a5
    1306:	8e5d                	or	a2,a2,a5
                unfinished = 1;
    1308:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
    130a:	0b070713          	addi	a4,a4,176
    130e:	00970863          	beq	a4,s1,131e <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
    1312:	431c                	lw	a5,0(a4)
    1314:	dbfd                	beqz	a5,130a <twaitall+0x2c>
    1316:	ffa78693          	addi	a3,a5,-6
    131a:	f2fd                	bnez	a3,1300 <twaitall+0x22>
    131c:	b7fd                	j	130a <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
    131e:	cd95                	beqz	a1,135a <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
    1320:	ce01                	beqz	a2,1338 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
    1322:	00000097          	auipc	ra,0x0
    1326:	f62080e7          	jalr	-158(ra) # 1284 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
    132a:	00001717          	auipc	a4,0x1
    132e:	ea670713          	addi	a4,a4,-346 # 21d0 <threads+0x128>
        int runnable = 0;
    1332:	4601                	li	a2,0
        int unfinished = 0;
    1334:	4581                	li	a1,0
    1336:	bff1                	j	1312 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
    1338:	00001597          	auipc	a1,0x1
    133c:	a4058593          	addi	a1,a1,-1472 # 1d78 <malloc+0x274>
    1340:	00001517          	auipc	a0,0x1
    1344:	a4850513          	addi	a0,a0,-1464 # 1d88 <malloc+0x284>
    1348:	00000097          	auipc	ra,0x0
    134c:	700080e7          	jalr	1792(ra) # 1a48 <printf>
            exit(-1);
    1350:	557d                	li	a0,-1
    1352:	00000097          	auipc	ra,0x0
    1356:	378080e7          	jalr	888(ra) # 16ca <exit>
    135a:	00001497          	auipc	s1,0x1
    135e:	dfe48493          	addi	s1,s1,-514 # 2158 <threads+0xb0>
    1362:	00001917          	auipc	s2,0x1
    1366:	54590913          	addi	s2,s2,1349 # 28a7 <threads+0x7ff>
    136a:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
    136e:	4999                	li	s3,6
    1370:	a029                	j	137a <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
    1372:	0b048493          	addi	s1,s1,176
    1376:	01248b63          	beq	s1,s2,138c <twaitall+0xae>
        if (threads[i].state == EXITED)
    137a:	5cbc                	lw	a5,120(s1)
    137c:	ff379be3          	bne	a5,s3,1372 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
    1380:	8526                	mv	a0,s1
    1382:	00000097          	auipc	ra,0x0
    1386:	a78080e7          	jalr	-1416(ra) # dfa <reclaim_thread>
    138a:	b7e5                	j	1372 <twaitall+0x94>
        }
    }
}
    138c:	70a2                	ld	ra,40(sp)
    138e:	7402                	ld	s0,32(sp)
    1390:	64e2                	ld	s1,24(sp)
    1392:	6942                	ld	s2,16(sp)
    1394:	69a2                	ld	s3,8(sp)
    1396:	6145                	addi	sp,sp,48
    1398:	8082                	ret

000000000000139a <tswtch>:
    139a:	00153023          	sd	ra,0(a0)
    139e:	00253423          	sd	sp,8(a0)
    13a2:	e900                	sd	s0,16(a0)
    13a4:	ed04                	sd	s1,24(a0)
    13a6:	03253023          	sd	s2,32(a0)
    13aa:	03353423          	sd	s3,40(a0)
    13ae:	03453823          	sd	s4,48(a0)
    13b2:	03553c23          	sd	s5,56(a0)
    13b6:	05653023          	sd	s6,64(a0)
    13ba:	05753423          	sd	s7,72(a0)
    13be:	05853823          	sd	s8,80(a0)
    13c2:	05953c23          	sd	s9,88(a0)
    13c6:	07a53023          	sd	s10,96(a0)
    13ca:	07b53423          	sd	s11,104(a0)
    13ce:	0005b083          	ld	ra,0(a1)
    13d2:	0085b103          	ld	sp,8(a1)
    13d6:	6980                	ld	s0,16(a1)
    13d8:	6d84                	ld	s1,24(a1)
    13da:	0205b903          	ld	s2,32(a1)
    13de:	0285b983          	ld	s3,40(a1)
    13e2:	0305ba03          	ld	s4,48(a1)
    13e6:	0385ba83          	ld	s5,56(a1)
    13ea:	0405bb03          	ld	s6,64(a1)
    13ee:	0485bb83          	ld	s7,72(a1)
    13f2:	0505bc03          	ld	s8,80(a1)
    13f6:	0585bc83          	ld	s9,88(a1)
    13fa:	0605bd03          	ld	s10,96(a1)
    13fe:	0685bd83          	ld	s11,104(a1)
    1402:	8082                	ret

0000000000001404 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
    1404:	1101                	addi	sp,sp,-32
    1406:	ec06                	sd	ra,24(sp)
    1408:	e822                	sd	s0,16(sp)
    140a:	e426                	sd	s1,8(sp)
    140c:	e04a                	sd	s2,0(sp)
    140e:	1000                	addi	s0,sp,32
    1410:	892a                	mv	s2,a0
    1412:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
    1414:	00000097          	auipc	ra,0x0
    1418:	ea6080e7          	jalr	-346(ra) # 12ba <twhoami>
    int res = main(argc, argv);
    141c:	85a6                	mv	a1,s1
    141e:	854a                	mv	a0,s2
    1420:	fffff097          	auipc	ra,0xfffff
    1424:	740080e7          	jalr	1856(ra) # b60 <main>
    1428:	84aa                	mv	s1,a0
    twaitall();
    142a:	00000097          	auipc	ra,0x0
    142e:	eb4080e7          	jalr	-332(ra) # 12de <twaitall>
    exit(res);
    1432:	8526                	mv	a0,s1
    1434:	00000097          	auipc	ra,0x0
    1438:	296080e7          	jalr	662(ra) # 16ca <exit>

000000000000143c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    143c:	1141                	addi	sp,sp,-16
    143e:	e406                	sd	ra,8(sp)
    1440:	e022                	sd	s0,0(sp)
    1442:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
    1444:	87aa                	mv	a5,a0
    1446:	0585                	addi	a1,a1,1
    1448:	0785                	addi	a5,a5,1
    144a:	fff5c703          	lbu	a4,-1(a1)
    144e:	fee78fa3          	sb	a4,-1(a5)
    1452:	fb75                	bnez	a4,1446 <strcpy+0xa>
        ;
    return os;
}
    1454:	60a2                	ld	ra,8(sp)
    1456:	6402                	ld	s0,0(sp)
    1458:	0141                	addi	sp,sp,16
    145a:	8082                	ret

000000000000145c <strcmp>:

int strcmp(const char *p, const char *q)
{
    145c:	1141                	addi	sp,sp,-16
    145e:	e406                	sd	ra,8(sp)
    1460:	e022                	sd	s0,0(sp)
    1462:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    1464:	00054783          	lbu	a5,0(a0)
    1468:	cb91                	beqz	a5,147c <strcmp+0x20>
    146a:	0005c703          	lbu	a4,0(a1)
    146e:	00f71763          	bne	a4,a5,147c <strcmp+0x20>
        p++, q++;
    1472:	0505                	addi	a0,a0,1
    1474:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    1476:	00054783          	lbu	a5,0(a0)
    147a:	fbe5                	bnez	a5,146a <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
    147c:	0005c503          	lbu	a0,0(a1)
}
    1480:	40a7853b          	subw	a0,a5,a0
    1484:	60a2                	ld	ra,8(sp)
    1486:	6402                	ld	s0,0(sp)
    1488:	0141                	addi	sp,sp,16
    148a:	8082                	ret

000000000000148c <strlen>:

uint strlen(const char *s)
{
    148c:	1141                	addi	sp,sp,-16
    148e:	e406                	sd	ra,8(sp)
    1490:	e022                	sd	s0,0(sp)
    1492:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    1494:	00054783          	lbu	a5,0(a0)
    1498:	cf91                	beqz	a5,14b4 <strlen+0x28>
    149a:	00150793          	addi	a5,a0,1
    149e:	86be                	mv	a3,a5
    14a0:	0785                	addi	a5,a5,1
    14a2:	fff7c703          	lbu	a4,-1(a5)
    14a6:	ff65                	bnez	a4,149e <strlen+0x12>
    14a8:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
    14ac:	60a2                	ld	ra,8(sp)
    14ae:	6402                	ld	s0,0(sp)
    14b0:	0141                	addi	sp,sp,16
    14b2:	8082                	ret
    for (n = 0; s[n]; n++)
    14b4:	4501                	li	a0,0
    14b6:	bfdd                	j	14ac <strlen+0x20>

00000000000014b8 <memset>:

void *
memset(void *dst, int c, uint n)
{
    14b8:	1141                	addi	sp,sp,-16
    14ba:	e406                	sd	ra,8(sp)
    14bc:	e022                	sd	s0,0(sp)
    14be:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
    14c0:	ca19                	beqz	a2,14d6 <memset+0x1e>
    14c2:	87aa                	mv	a5,a0
    14c4:	1602                	slli	a2,a2,0x20
    14c6:	9201                	srli	a2,a2,0x20
    14c8:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
    14cc:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
    14d0:	0785                	addi	a5,a5,1
    14d2:	fee79de3          	bne	a5,a4,14cc <memset+0x14>
    }
    return dst;
}
    14d6:	60a2                	ld	ra,8(sp)
    14d8:	6402                	ld	s0,0(sp)
    14da:	0141                	addi	sp,sp,16
    14dc:	8082                	ret

00000000000014de <strchr>:

char *
strchr(const char *s, char c)
{
    14de:	1141                	addi	sp,sp,-16
    14e0:	e406                	sd	ra,8(sp)
    14e2:	e022                	sd	s0,0(sp)
    14e4:	0800                	addi	s0,sp,16
    for (; *s; s++)
    14e6:	00054783          	lbu	a5,0(a0)
    14ea:	cf81                	beqz	a5,1502 <strchr+0x24>
        if (*s == c)
    14ec:	00f58763          	beq	a1,a5,14fa <strchr+0x1c>
    for (; *s; s++)
    14f0:	0505                	addi	a0,a0,1
    14f2:	00054783          	lbu	a5,0(a0)
    14f6:	fbfd                	bnez	a5,14ec <strchr+0xe>
            return (char *)s;
    return 0;
    14f8:	4501                	li	a0,0
}
    14fa:	60a2                	ld	ra,8(sp)
    14fc:	6402                	ld	s0,0(sp)
    14fe:	0141                	addi	sp,sp,16
    1500:	8082                	ret
    return 0;
    1502:	4501                	li	a0,0
    1504:	bfdd                	j	14fa <strchr+0x1c>

0000000000001506 <gets>:

char *
gets(char *buf, int max)
{
    1506:	711d                	addi	sp,sp,-96
    1508:	ec86                	sd	ra,88(sp)
    150a:	e8a2                	sd	s0,80(sp)
    150c:	e4a6                	sd	s1,72(sp)
    150e:	e0ca                	sd	s2,64(sp)
    1510:	fc4e                	sd	s3,56(sp)
    1512:	f852                	sd	s4,48(sp)
    1514:	f456                	sd	s5,40(sp)
    1516:	f05a                	sd	s6,32(sp)
    1518:	ec5e                	sd	s7,24(sp)
    151a:	e862                	sd	s8,16(sp)
    151c:	1080                	addi	s0,sp,96
    151e:	8baa                	mv	s7,a0
    1520:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
    1522:	892a                	mv	s2,a0
    1524:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
    1526:	faf40b13          	addi	s6,s0,-81
    152a:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
    152c:	8c26                	mv	s8,s1
    152e:	0014899b          	addiw	s3,s1,1
    1532:	84ce                	mv	s1,s3
    1534:	0349d663          	bge	s3,s4,1560 <gets+0x5a>
        cc = read(0, &c, 1);
    1538:	8656                	mv	a2,s5
    153a:	85da                	mv	a1,s6
    153c:	4501                	li	a0,0
    153e:	00000097          	auipc	ra,0x0
    1542:	1a4080e7          	jalr	420(ra) # 16e2 <read>
        if (cc < 1)
    1546:	00a05d63          	blez	a0,1560 <gets+0x5a>
            break;
        buf[i++] = c;
    154a:	faf44783          	lbu	a5,-81(s0)
    154e:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
    1552:	0905                	addi	s2,s2,1
    1554:	ff678713          	addi	a4,a5,-10
    1558:	c319                	beqz	a4,155e <gets+0x58>
    155a:	17cd                	addi	a5,a5,-13
    155c:	fbe1                	bnez	a5,152c <gets+0x26>
        buf[i++] = c;
    155e:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
    1560:	9c5e                	add	s8,s8,s7
    1562:	000c0023          	sb	zero,0(s8)
    return buf;
}
    1566:	855e                	mv	a0,s7
    1568:	60e6                	ld	ra,88(sp)
    156a:	6446                	ld	s0,80(sp)
    156c:	64a6                	ld	s1,72(sp)
    156e:	6906                	ld	s2,64(sp)
    1570:	79e2                	ld	s3,56(sp)
    1572:	7a42                	ld	s4,48(sp)
    1574:	7aa2                	ld	s5,40(sp)
    1576:	7b02                	ld	s6,32(sp)
    1578:	6be2                	ld	s7,24(sp)
    157a:	6c42                	ld	s8,16(sp)
    157c:	6125                	addi	sp,sp,96
    157e:	8082                	ret

0000000000001580 <stat>:

int stat(const char *n, struct stat *st)
{
    1580:	1101                	addi	sp,sp,-32
    1582:	ec06                	sd	ra,24(sp)
    1584:	e822                	sd	s0,16(sp)
    1586:	e04a                	sd	s2,0(sp)
    1588:	1000                	addi	s0,sp,32
    158a:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
    158c:	4581                	li	a1,0
    158e:	00000097          	auipc	ra,0x0
    1592:	17c080e7          	jalr	380(ra) # 170a <open>
    if (fd < 0)
    1596:	02054663          	bltz	a0,15c2 <stat+0x42>
    159a:	e426                	sd	s1,8(sp)
    159c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
    159e:	85ca                	mv	a1,s2
    15a0:	00000097          	auipc	ra,0x0
    15a4:	182080e7          	jalr	386(ra) # 1722 <fstat>
    15a8:	892a                	mv	s2,a0
    close(fd);
    15aa:	8526                	mv	a0,s1
    15ac:	00000097          	auipc	ra,0x0
    15b0:	146080e7          	jalr	326(ra) # 16f2 <close>
    return r;
    15b4:	64a2                	ld	s1,8(sp)
}
    15b6:	854a                	mv	a0,s2
    15b8:	60e2                	ld	ra,24(sp)
    15ba:	6442                	ld	s0,16(sp)
    15bc:	6902                	ld	s2,0(sp)
    15be:	6105                	addi	sp,sp,32
    15c0:	8082                	ret
        return -1;
    15c2:	57fd                	li	a5,-1
    15c4:	893e                	mv	s2,a5
    15c6:	bfc5                	j	15b6 <stat+0x36>

00000000000015c8 <atoi>:

int atoi(const char *s)
{
    15c8:	1141                	addi	sp,sp,-16
    15ca:	e406                	sd	ra,8(sp)
    15cc:	e022                	sd	s0,0(sp)
    15ce:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    15d0:	00054683          	lbu	a3,0(a0)
    15d4:	fd06879b          	addiw	a5,a3,-48
    15d8:	0ff7f793          	zext.b	a5,a5
    15dc:	4625                	li	a2,9
    15de:	02f66963          	bltu	a2,a5,1610 <atoi+0x48>
    15e2:	872a                	mv	a4,a0
    n = 0;
    15e4:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
    15e6:	0705                	addi	a4,a4,1
    15e8:	0025179b          	slliw	a5,a0,0x2
    15ec:	9fa9                	addw	a5,a5,a0
    15ee:	0017979b          	slliw	a5,a5,0x1
    15f2:	9fb5                	addw	a5,a5,a3
    15f4:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    15f8:	00074683          	lbu	a3,0(a4)
    15fc:	fd06879b          	addiw	a5,a3,-48
    1600:	0ff7f793          	zext.b	a5,a5
    1604:	fef671e3          	bgeu	a2,a5,15e6 <atoi+0x1e>
    return n;
}
    1608:	60a2                	ld	ra,8(sp)
    160a:	6402                	ld	s0,0(sp)
    160c:	0141                	addi	sp,sp,16
    160e:	8082                	ret
    n = 0;
    1610:	4501                	li	a0,0
    1612:	bfdd                	j	1608 <atoi+0x40>

0000000000001614 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    1614:	1141                	addi	sp,sp,-16
    1616:	e406                	sd	ra,8(sp)
    1618:	e022                	sd	s0,0(sp)
    161a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
    161c:	02b57563          	bgeu	a0,a1,1646 <memmove+0x32>
    {
        while (n-- > 0)
    1620:	00c05f63          	blez	a2,163e <memmove+0x2a>
    1624:	1602                	slli	a2,a2,0x20
    1626:	9201                	srli	a2,a2,0x20
    1628:	00c507b3          	add	a5,a0,a2
    dst = vdst;
    162c:	872a                	mv	a4,a0
            *dst++ = *src++;
    162e:	0585                	addi	a1,a1,1
    1630:	0705                	addi	a4,a4,1
    1632:	fff5c683          	lbu	a3,-1(a1)
    1636:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    163a:	fee79ae3          	bne	a5,a4,162e <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    163e:	60a2                	ld	ra,8(sp)
    1640:	6402                	ld	s0,0(sp)
    1642:	0141                	addi	sp,sp,16
    1644:	8082                	ret
        while (n-- > 0)
    1646:	fec05ce3          	blez	a2,163e <memmove+0x2a>
        dst += n;
    164a:	00c50733          	add	a4,a0,a2
        src += n;
    164e:	95b2                	add	a1,a1,a2
    1650:	fff6079b          	addiw	a5,a2,-1
    1654:	1782                	slli	a5,a5,0x20
    1656:	9381                	srli	a5,a5,0x20
    1658:	fff7c793          	not	a5,a5
    165c:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    165e:	15fd                	addi	a1,a1,-1
    1660:	177d                	addi	a4,a4,-1
    1662:	0005c683          	lbu	a3,0(a1)
    1666:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    166a:	fef71ae3          	bne	a4,a5,165e <memmove+0x4a>
    166e:	bfc1                	j	163e <memmove+0x2a>

0000000000001670 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    1670:	1141                	addi	sp,sp,-16
    1672:	e406                	sd	ra,8(sp)
    1674:	e022                	sd	s0,0(sp)
    1676:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
    1678:	c61d                	beqz	a2,16a6 <memcmp+0x36>
    167a:	1602                	slli	a2,a2,0x20
    167c:	9201                	srli	a2,a2,0x20
    167e:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
    1682:	00054783          	lbu	a5,0(a0)
    1686:	0005c703          	lbu	a4,0(a1)
    168a:	00e79863          	bne	a5,a4,169a <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
    168e:	0505                	addi	a0,a0,1
        p2++;
    1690:	0585                	addi	a1,a1,1
    while (n-- > 0)
    1692:	fed518e3          	bne	a0,a3,1682 <memcmp+0x12>
    }
    return 0;
    1696:	4501                	li	a0,0
    1698:	a019                	j	169e <memcmp+0x2e>
            return *p1 - *p2;
    169a:	40e7853b          	subw	a0,a5,a4
}
    169e:	60a2                	ld	ra,8(sp)
    16a0:	6402                	ld	s0,0(sp)
    16a2:	0141                	addi	sp,sp,16
    16a4:	8082                	ret
    return 0;
    16a6:	4501                	li	a0,0
    16a8:	bfdd                	j	169e <memcmp+0x2e>

00000000000016aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    16aa:	1141                	addi	sp,sp,-16
    16ac:	e406                	sd	ra,8(sp)
    16ae:	e022                	sd	s0,0(sp)
    16b0:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    16b2:	00000097          	auipc	ra,0x0
    16b6:	f62080e7          	jalr	-158(ra) # 1614 <memmove>
}
    16ba:	60a2                	ld	ra,8(sp)
    16bc:	6402                	ld	s0,0(sp)
    16be:	0141                	addi	sp,sp,16
    16c0:	8082                	ret

00000000000016c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    16c2:	4885                	li	a7,1
 ecall
    16c4:	00000073          	ecall
 ret
    16c8:	8082                	ret

00000000000016ca <exit>:
.global exit
exit:
 li a7, SYS_exit
    16ca:	4889                	li	a7,2
 ecall
    16cc:	00000073          	ecall
 ret
    16d0:	8082                	ret

00000000000016d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    16d2:	488d                	li	a7,3
 ecall
    16d4:	00000073          	ecall
 ret
    16d8:	8082                	ret

00000000000016da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    16da:	4891                	li	a7,4
 ecall
    16dc:	00000073          	ecall
 ret
    16e0:	8082                	ret

00000000000016e2 <read>:
.global read
read:
 li a7, SYS_read
    16e2:	4895                	li	a7,5
 ecall
    16e4:	00000073          	ecall
 ret
    16e8:	8082                	ret

00000000000016ea <write>:
.global write
write:
 li a7, SYS_write
    16ea:	48c1                	li	a7,16
 ecall
    16ec:	00000073          	ecall
 ret
    16f0:	8082                	ret

00000000000016f2 <close>:
.global close
close:
 li a7, SYS_close
    16f2:	48d5                	li	a7,21
 ecall
    16f4:	00000073          	ecall
 ret
    16f8:	8082                	ret

00000000000016fa <kill>:
.global kill
kill:
 li a7, SYS_kill
    16fa:	4899                	li	a7,6
 ecall
    16fc:	00000073          	ecall
 ret
    1700:	8082                	ret

0000000000001702 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1702:	489d                	li	a7,7
 ecall
    1704:	00000073          	ecall
 ret
    1708:	8082                	ret

000000000000170a <open>:
.global open
open:
 li a7, SYS_open
    170a:	48bd                	li	a7,15
 ecall
    170c:	00000073          	ecall
 ret
    1710:	8082                	ret

0000000000001712 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1712:	48c5                	li	a7,17
 ecall
    1714:	00000073          	ecall
 ret
    1718:	8082                	ret

000000000000171a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    171a:	48c9                	li	a7,18
 ecall
    171c:	00000073          	ecall
 ret
    1720:	8082                	ret

0000000000001722 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1722:	48a1                	li	a7,8
 ecall
    1724:	00000073          	ecall
 ret
    1728:	8082                	ret

000000000000172a <link>:
.global link
link:
 li a7, SYS_link
    172a:	48cd                	li	a7,19
 ecall
    172c:	00000073          	ecall
 ret
    1730:	8082                	ret

0000000000001732 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1732:	48d1                	li	a7,20
 ecall
    1734:	00000073          	ecall
 ret
    1738:	8082                	ret

000000000000173a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    173a:	48a5                	li	a7,9
 ecall
    173c:	00000073          	ecall
 ret
    1740:	8082                	ret

0000000000001742 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1742:	48a9                	li	a7,10
 ecall
    1744:	00000073          	ecall
 ret
    1748:	8082                	ret

000000000000174a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    174a:	48ad                	li	a7,11
 ecall
    174c:	00000073          	ecall
 ret
    1750:	8082                	ret

0000000000001752 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1752:	48b1                	li	a7,12
 ecall
    1754:	00000073          	ecall
 ret
    1758:	8082                	ret

000000000000175a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    175a:	48b5                	li	a7,13
 ecall
    175c:	00000073          	ecall
 ret
    1760:	8082                	ret

0000000000001762 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1762:	48b9                	li	a7,14
 ecall
    1764:	00000073          	ecall
 ret
    1768:	8082                	ret

000000000000176a <ps>:
.global ps
ps:
 li a7, SYS_ps
    176a:	48d9                	li	a7,22
 ecall
    176c:	00000073          	ecall
 ret
    1770:	8082                	ret

0000000000001772 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    1772:	48dd                	li	a7,23
 ecall
    1774:	00000073          	ecall
 ret
    1778:	8082                	ret

000000000000177a <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    177a:	48e1                	li	a7,24
 ecall
    177c:	00000073          	ecall
 ret
    1780:	8082                	ret

0000000000001782 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1782:	1101                	addi	sp,sp,-32
    1784:	ec06                	sd	ra,24(sp)
    1786:	e822                	sd	s0,16(sp)
    1788:	1000                	addi	s0,sp,32
    178a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    178e:	4605                	li	a2,1
    1790:	fef40593          	addi	a1,s0,-17
    1794:	00000097          	auipc	ra,0x0
    1798:	f56080e7          	jalr	-170(ra) # 16ea <write>
}
    179c:	60e2                	ld	ra,24(sp)
    179e:	6442                	ld	s0,16(sp)
    17a0:	6105                	addi	sp,sp,32
    17a2:	8082                	ret

00000000000017a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    17a4:	7139                	addi	sp,sp,-64
    17a6:	fc06                	sd	ra,56(sp)
    17a8:	f822                	sd	s0,48(sp)
    17aa:	f04a                	sd	s2,32(sp)
    17ac:	ec4e                	sd	s3,24(sp)
    17ae:	0080                	addi	s0,sp,64
    17b0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    17b2:	cad9                	beqz	a3,1848 <printint+0xa4>
    17b4:	01f5d79b          	srliw	a5,a1,0x1f
    17b8:	cbc1                	beqz	a5,1848 <printint+0xa4>
    neg = 1;
    x = -xx;
    17ba:	40b005bb          	negw	a1,a1
    neg = 1;
    17be:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    17c0:	fc040993          	addi	s3,s0,-64
  neg = 0;
    17c4:	86ce                	mv	a3,s3
  i = 0;
    17c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    17c8:	00000817          	auipc	a6,0x0
    17cc:	6d080813          	addi	a6,a6,1744 # 1e98 <digits>
    17d0:	88ba                	mv	a7,a4
    17d2:	0017051b          	addiw	a0,a4,1
    17d6:	872a                	mv	a4,a0
    17d8:	02c5f7bb          	remuw	a5,a1,a2
    17dc:	1782                	slli	a5,a5,0x20
    17de:	9381                	srli	a5,a5,0x20
    17e0:	97c2                	add	a5,a5,a6
    17e2:	0007c783          	lbu	a5,0(a5)
    17e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    17ea:	87ae                	mv	a5,a1
    17ec:	02c5d5bb          	divuw	a1,a1,a2
    17f0:	0685                	addi	a3,a3,1
    17f2:	fcc7ffe3          	bgeu	a5,a2,17d0 <printint+0x2c>
  if(neg)
    17f6:	00030c63          	beqz	t1,180e <printint+0x6a>
    buf[i++] = '-';
    17fa:	fd050793          	addi	a5,a0,-48
    17fe:	00878533          	add	a0,a5,s0
    1802:	02d00793          	li	a5,45
    1806:	fef50823          	sb	a5,-16(a0)
    180a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    180e:	02e05763          	blez	a4,183c <printint+0x98>
    1812:	f426                	sd	s1,40(sp)
    1814:	377d                	addiw	a4,a4,-1
    1816:	00e984b3          	add	s1,s3,a4
    181a:	19fd                	addi	s3,s3,-1
    181c:	99ba                	add	s3,s3,a4
    181e:	1702                	slli	a4,a4,0x20
    1820:	9301                	srli	a4,a4,0x20
    1822:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1826:	0004c583          	lbu	a1,0(s1)
    182a:	854a                	mv	a0,s2
    182c:	00000097          	auipc	ra,0x0
    1830:	f56080e7          	jalr	-170(ra) # 1782 <putc>
  while(--i >= 0)
    1834:	14fd                	addi	s1,s1,-1
    1836:	ff3498e3          	bne	s1,s3,1826 <printint+0x82>
    183a:	74a2                	ld	s1,40(sp)
}
    183c:	70e2                	ld	ra,56(sp)
    183e:	7442                	ld	s0,48(sp)
    1840:	7902                	ld	s2,32(sp)
    1842:	69e2                	ld	s3,24(sp)
    1844:	6121                	addi	sp,sp,64
    1846:	8082                	ret
  neg = 0;
    1848:	4301                	li	t1,0
    184a:	bf9d                	j	17c0 <printint+0x1c>

000000000000184c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    184c:	715d                	addi	sp,sp,-80
    184e:	e486                	sd	ra,72(sp)
    1850:	e0a2                	sd	s0,64(sp)
    1852:	f84a                	sd	s2,48(sp)
    1854:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1856:	0005c903          	lbu	s2,0(a1)
    185a:	1a090b63          	beqz	s2,1a10 <vprintf+0x1c4>
    185e:	fc26                	sd	s1,56(sp)
    1860:	f44e                	sd	s3,40(sp)
    1862:	f052                	sd	s4,32(sp)
    1864:	ec56                	sd	s5,24(sp)
    1866:	e85a                	sd	s6,16(sp)
    1868:	e45e                	sd	s7,8(sp)
    186a:	8aaa                	mv	s5,a0
    186c:	8bb2                	mv	s7,a2
    186e:	00158493          	addi	s1,a1,1
  state = 0;
    1872:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1874:	02500a13          	li	s4,37
    1878:	4b55                	li	s6,21
    187a:	a839                	j	1898 <vprintf+0x4c>
        putc(fd, c);
    187c:	85ca                	mv	a1,s2
    187e:	8556                	mv	a0,s5
    1880:	00000097          	auipc	ra,0x0
    1884:	f02080e7          	jalr	-254(ra) # 1782 <putc>
    1888:	a019                	j	188e <vprintf+0x42>
    } else if(state == '%'){
    188a:	01498d63          	beq	s3,s4,18a4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    188e:	0485                	addi	s1,s1,1
    1890:	fff4c903          	lbu	s2,-1(s1)
    1894:	16090863          	beqz	s2,1a04 <vprintf+0x1b8>
    if(state == 0){
    1898:	fe0999e3          	bnez	s3,188a <vprintf+0x3e>
      if(c == '%'){
    189c:	ff4910e3          	bne	s2,s4,187c <vprintf+0x30>
        state = '%';
    18a0:	89d2                	mv	s3,s4
    18a2:	b7f5                	j	188e <vprintf+0x42>
      if(c == 'd'){
    18a4:	13490563          	beq	s2,s4,19ce <vprintf+0x182>
    18a8:	f9d9079b          	addiw	a5,s2,-99
    18ac:	0ff7f793          	zext.b	a5,a5
    18b0:	12fb6863          	bltu	s6,a5,19e0 <vprintf+0x194>
    18b4:	f9d9079b          	addiw	a5,s2,-99
    18b8:	0ff7f713          	zext.b	a4,a5
    18bc:	12eb6263          	bltu	s6,a4,19e0 <vprintf+0x194>
    18c0:	00271793          	slli	a5,a4,0x2
    18c4:	00000717          	auipc	a4,0x0
    18c8:	57c70713          	addi	a4,a4,1404 # 1e40 <malloc+0x33c>
    18cc:	97ba                	add	a5,a5,a4
    18ce:	439c                	lw	a5,0(a5)
    18d0:	97ba                	add	a5,a5,a4
    18d2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    18d4:	008b8913          	addi	s2,s7,8
    18d8:	4685                	li	a3,1
    18da:	4629                	li	a2,10
    18dc:	000ba583          	lw	a1,0(s7)
    18e0:	8556                	mv	a0,s5
    18e2:	00000097          	auipc	ra,0x0
    18e6:	ec2080e7          	jalr	-318(ra) # 17a4 <printint>
    18ea:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    18ec:	4981                	li	s3,0
    18ee:	b745                	j	188e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    18f0:	008b8913          	addi	s2,s7,8
    18f4:	4681                	li	a3,0
    18f6:	4629                	li	a2,10
    18f8:	000ba583          	lw	a1,0(s7)
    18fc:	8556                	mv	a0,s5
    18fe:	00000097          	auipc	ra,0x0
    1902:	ea6080e7          	jalr	-346(ra) # 17a4 <printint>
    1906:	8bca                	mv	s7,s2
      state = 0;
    1908:	4981                	li	s3,0
    190a:	b751                	j	188e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    190c:	008b8913          	addi	s2,s7,8
    1910:	4681                	li	a3,0
    1912:	4641                	li	a2,16
    1914:	000ba583          	lw	a1,0(s7)
    1918:	8556                	mv	a0,s5
    191a:	00000097          	auipc	ra,0x0
    191e:	e8a080e7          	jalr	-374(ra) # 17a4 <printint>
    1922:	8bca                	mv	s7,s2
      state = 0;
    1924:	4981                	li	s3,0
    1926:	b7a5                	j	188e <vprintf+0x42>
    1928:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    192a:	008b8793          	addi	a5,s7,8
    192e:	8c3e                	mv	s8,a5
    1930:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1934:	03000593          	li	a1,48
    1938:	8556                	mv	a0,s5
    193a:	00000097          	auipc	ra,0x0
    193e:	e48080e7          	jalr	-440(ra) # 1782 <putc>
  putc(fd, 'x');
    1942:	07800593          	li	a1,120
    1946:	8556                	mv	a0,s5
    1948:	00000097          	auipc	ra,0x0
    194c:	e3a080e7          	jalr	-454(ra) # 1782 <putc>
    1950:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1952:	00000b97          	auipc	s7,0x0
    1956:	546b8b93          	addi	s7,s7,1350 # 1e98 <digits>
    195a:	03c9d793          	srli	a5,s3,0x3c
    195e:	97de                	add	a5,a5,s7
    1960:	0007c583          	lbu	a1,0(a5)
    1964:	8556                	mv	a0,s5
    1966:	00000097          	auipc	ra,0x0
    196a:	e1c080e7          	jalr	-484(ra) # 1782 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    196e:	0992                	slli	s3,s3,0x4
    1970:	397d                	addiw	s2,s2,-1
    1972:	fe0914e3          	bnez	s2,195a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    1976:	8be2                	mv	s7,s8
      state = 0;
    1978:	4981                	li	s3,0
    197a:	6c02                	ld	s8,0(sp)
    197c:	bf09                	j	188e <vprintf+0x42>
        s = va_arg(ap, char*);
    197e:	008b8993          	addi	s3,s7,8
    1982:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1986:	02090163          	beqz	s2,19a8 <vprintf+0x15c>
        while(*s != 0){
    198a:	00094583          	lbu	a1,0(s2)
    198e:	c9a5                	beqz	a1,19fe <vprintf+0x1b2>
          putc(fd, *s);
    1990:	8556                	mv	a0,s5
    1992:	00000097          	auipc	ra,0x0
    1996:	df0080e7          	jalr	-528(ra) # 1782 <putc>
          s++;
    199a:	0905                	addi	s2,s2,1
        while(*s != 0){
    199c:	00094583          	lbu	a1,0(s2)
    19a0:	f9e5                	bnez	a1,1990 <vprintf+0x144>
        s = va_arg(ap, char*);
    19a2:	8bce                	mv	s7,s3
      state = 0;
    19a4:	4981                	li	s3,0
    19a6:	b5e5                	j	188e <vprintf+0x42>
          s = "(null)";
    19a8:	00000917          	auipc	s2,0x0
    19ac:	46090913          	addi	s2,s2,1120 # 1e08 <malloc+0x304>
        while(*s != 0){
    19b0:	02800593          	li	a1,40
    19b4:	bff1                	j	1990 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    19b6:	008b8913          	addi	s2,s7,8
    19ba:	000bc583          	lbu	a1,0(s7)
    19be:	8556                	mv	a0,s5
    19c0:	00000097          	auipc	ra,0x0
    19c4:	dc2080e7          	jalr	-574(ra) # 1782 <putc>
    19c8:	8bca                	mv	s7,s2
      state = 0;
    19ca:	4981                	li	s3,0
    19cc:	b5c9                	j	188e <vprintf+0x42>
        putc(fd, c);
    19ce:	02500593          	li	a1,37
    19d2:	8556                	mv	a0,s5
    19d4:	00000097          	auipc	ra,0x0
    19d8:	dae080e7          	jalr	-594(ra) # 1782 <putc>
      state = 0;
    19dc:	4981                	li	s3,0
    19de:	bd45                	j	188e <vprintf+0x42>
        putc(fd, '%');
    19e0:	02500593          	li	a1,37
    19e4:	8556                	mv	a0,s5
    19e6:	00000097          	auipc	ra,0x0
    19ea:	d9c080e7          	jalr	-612(ra) # 1782 <putc>
        putc(fd, c);
    19ee:	85ca                	mv	a1,s2
    19f0:	8556                	mv	a0,s5
    19f2:	00000097          	auipc	ra,0x0
    19f6:	d90080e7          	jalr	-624(ra) # 1782 <putc>
      state = 0;
    19fa:	4981                	li	s3,0
    19fc:	bd49                	j	188e <vprintf+0x42>
        s = va_arg(ap, char*);
    19fe:	8bce                	mv	s7,s3
      state = 0;
    1a00:	4981                	li	s3,0
    1a02:	b571                	j	188e <vprintf+0x42>
    1a04:	74e2                	ld	s1,56(sp)
    1a06:	79a2                	ld	s3,40(sp)
    1a08:	7a02                	ld	s4,32(sp)
    1a0a:	6ae2                	ld	s5,24(sp)
    1a0c:	6b42                	ld	s6,16(sp)
    1a0e:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1a10:	60a6                	ld	ra,72(sp)
    1a12:	6406                	ld	s0,64(sp)
    1a14:	7942                	ld	s2,48(sp)
    1a16:	6161                	addi	sp,sp,80
    1a18:	8082                	ret

0000000000001a1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1a1a:	715d                	addi	sp,sp,-80
    1a1c:	ec06                	sd	ra,24(sp)
    1a1e:	e822                	sd	s0,16(sp)
    1a20:	1000                	addi	s0,sp,32
    1a22:	e010                	sd	a2,0(s0)
    1a24:	e414                	sd	a3,8(s0)
    1a26:	e818                	sd	a4,16(s0)
    1a28:	ec1c                	sd	a5,24(s0)
    1a2a:	03043023          	sd	a6,32(s0)
    1a2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1a32:	8622                	mv	a2,s0
    1a34:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1a38:	00000097          	auipc	ra,0x0
    1a3c:	e14080e7          	jalr	-492(ra) # 184c <vprintf>
}
    1a40:	60e2                	ld	ra,24(sp)
    1a42:	6442                	ld	s0,16(sp)
    1a44:	6161                	addi	sp,sp,80
    1a46:	8082                	ret

0000000000001a48 <printf>:

void
printf(const char *fmt, ...)
{
    1a48:	711d                	addi	sp,sp,-96
    1a4a:	ec06                	sd	ra,24(sp)
    1a4c:	e822                	sd	s0,16(sp)
    1a4e:	1000                	addi	s0,sp,32
    1a50:	e40c                	sd	a1,8(s0)
    1a52:	e810                	sd	a2,16(s0)
    1a54:	ec14                	sd	a3,24(s0)
    1a56:	f018                	sd	a4,32(s0)
    1a58:	f41c                	sd	a5,40(s0)
    1a5a:	03043823          	sd	a6,48(s0)
    1a5e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1a62:	00840613          	addi	a2,s0,8
    1a66:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1a6a:	85aa                	mv	a1,a0
    1a6c:	4505                	li	a0,1
    1a6e:	00000097          	auipc	ra,0x0
    1a72:	dde080e7          	jalr	-546(ra) # 184c <vprintf>
}
    1a76:	60e2                	ld	ra,24(sp)
    1a78:	6442                	ld	s0,16(sp)
    1a7a:	6125                	addi	sp,sp,96
    1a7c:	8082                	ret

0000000000001a7e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    1a7e:	1141                	addi	sp,sp,-16
    1a80:	e406                	sd	ra,8(sp)
    1a82:	e022                	sd	s0,0(sp)
    1a84:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    1a86:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a8a:	00000797          	auipc	a5,0x0
    1a8e:	5967b783          	ld	a5,1430(a5) # 2020 <freep>
    1a92:	a039                	j	1aa0 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a94:	6398                	ld	a4,0(a5)
    1a96:	00e7e463          	bltu	a5,a4,1a9e <free+0x20>
    1a9a:	00e6ea63          	bltu	a3,a4,1aae <free+0x30>
{
    1a9e:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1aa0:	fed7fae3          	bgeu	a5,a3,1a94 <free+0x16>
    1aa4:	6398                	ld	a4,0(a5)
    1aa6:	00e6e463          	bltu	a3,a4,1aae <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1aaa:	fee7eae3          	bltu	a5,a4,1a9e <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    1aae:	ff852583          	lw	a1,-8(a0)
    1ab2:	6390                	ld	a2,0(a5)
    1ab4:	02059813          	slli	a6,a1,0x20
    1ab8:	01c85713          	srli	a4,a6,0x1c
    1abc:	9736                	add	a4,a4,a3
    1abe:	02e60563          	beq	a2,a4,1ae8 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    1ac2:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    1ac6:	4790                	lw	a2,8(a5)
    1ac8:	02061593          	slli	a1,a2,0x20
    1acc:	01c5d713          	srli	a4,a1,0x1c
    1ad0:	973e                	add	a4,a4,a5
    1ad2:	02e68263          	beq	a3,a4,1af6 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    1ad6:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    1ad8:	00000717          	auipc	a4,0x0
    1adc:	54f73423          	sd	a5,1352(a4) # 2020 <freep>
}
    1ae0:	60a2                	ld	ra,8(sp)
    1ae2:	6402                	ld	s0,0(sp)
    1ae4:	0141                	addi	sp,sp,16
    1ae6:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    1ae8:	4618                	lw	a4,8(a2)
    1aea:	9f2d                	addw	a4,a4,a1
    1aec:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    1af0:	6398                	ld	a4,0(a5)
    1af2:	6310                	ld	a2,0(a4)
    1af4:	b7f9                	j	1ac2 <free+0x44>
        p->s.size += bp->s.size;
    1af6:	ff852703          	lw	a4,-8(a0)
    1afa:	9f31                	addw	a4,a4,a2
    1afc:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    1afe:	ff053683          	ld	a3,-16(a0)
    1b02:	bfd1                	j	1ad6 <free+0x58>

0000000000001b04 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    1b04:	7139                	addi	sp,sp,-64
    1b06:	fc06                	sd	ra,56(sp)
    1b08:	f822                	sd	s0,48(sp)
    1b0a:	f04a                	sd	s2,32(sp)
    1b0c:	ec4e                	sd	s3,24(sp)
    1b0e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1b10:	02051993          	slli	s3,a0,0x20
    1b14:	0209d993          	srli	s3,s3,0x20
    1b18:	09bd                	addi	s3,s3,15
    1b1a:	0049d993          	srli	s3,s3,0x4
    1b1e:	2985                	addiw	s3,s3,1
    1b20:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    1b22:	00000517          	auipc	a0,0x0
    1b26:	4fe53503          	ld	a0,1278(a0) # 2020 <freep>
    1b2a:	c905                	beqz	a0,1b5a <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1b2c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1b2e:	4798                	lw	a4,8(a5)
    1b30:	09377a63          	bgeu	a4,s3,1bc4 <malloc+0xc0>
    1b34:	f426                	sd	s1,40(sp)
    1b36:	e852                	sd	s4,16(sp)
    1b38:	e456                	sd	s5,8(sp)
    1b3a:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1b3c:	8a4e                	mv	s4,s3
    1b3e:	6705                	lui	a4,0x1
    1b40:	00e9f363          	bgeu	s3,a4,1b46 <malloc+0x42>
    1b44:	6a05                	lui	s4,0x1
    1b46:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1b4a:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1b4e:	00000497          	auipc	s1,0x0
    1b52:	4d248493          	addi	s1,s1,1234 # 2020 <freep>
    if (p == (char *)-1)
    1b56:	5afd                	li	s5,-1
    1b58:	a089                	j	1b9a <malloc+0x96>
    1b5a:	f426                	sd	s1,40(sp)
    1b5c:	e852                	sd	s4,16(sp)
    1b5e:	e456                	sd	s5,8(sp)
    1b60:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    1b62:	00001797          	auipc	a5,0x1
    1b66:	04678793          	addi	a5,a5,70 # 2ba8 <base>
    1b6a:	00000717          	auipc	a4,0x0
    1b6e:	4af73b23          	sd	a5,1206(a4) # 2020 <freep>
    1b72:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1b74:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1b78:	b7d1                	j	1b3c <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    1b7a:	6398                	ld	a4,0(a5)
    1b7c:	e118                	sd	a4,0(a0)
    1b7e:	a8b9                	j	1bdc <malloc+0xd8>
    hp->s.size = nu;
    1b80:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1b84:	0541                	addi	a0,a0,16
    1b86:	00000097          	auipc	ra,0x0
    1b8a:	ef8080e7          	jalr	-264(ra) # 1a7e <free>
    return freep;
    1b8e:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1b90:	c135                	beqz	a0,1bf4 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1b92:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1b94:	4798                	lw	a4,8(a5)
    1b96:	03277363          	bgeu	a4,s2,1bbc <malloc+0xb8>
        if (p == freep)
    1b9a:	6098                	ld	a4,0(s1)
    1b9c:	853e                	mv	a0,a5
    1b9e:	fef71ae3          	bne	a4,a5,1b92 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1ba2:	8552                	mv	a0,s4
    1ba4:	00000097          	auipc	ra,0x0
    1ba8:	bae080e7          	jalr	-1106(ra) # 1752 <sbrk>
    if (p == (char *)-1)
    1bac:	fd551ae3          	bne	a0,s5,1b80 <malloc+0x7c>
                return 0;
    1bb0:	4501                	li	a0,0
    1bb2:	74a2                	ld	s1,40(sp)
    1bb4:	6a42                	ld	s4,16(sp)
    1bb6:	6aa2                	ld	s5,8(sp)
    1bb8:	6b02                	ld	s6,0(sp)
    1bba:	a03d                	j	1be8 <malloc+0xe4>
    1bbc:	74a2                	ld	s1,40(sp)
    1bbe:	6a42                	ld	s4,16(sp)
    1bc0:	6aa2                	ld	s5,8(sp)
    1bc2:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1bc4:	fae90be3          	beq	s2,a4,1b7a <malloc+0x76>
                p->s.size -= nunits;
    1bc8:	4137073b          	subw	a4,a4,s3
    1bcc:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1bce:	02071693          	slli	a3,a4,0x20
    1bd2:	01c6d713          	srli	a4,a3,0x1c
    1bd6:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1bd8:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1bdc:	00000717          	auipc	a4,0x0
    1be0:	44a73223          	sd	a0,1092(a4) # 2020 <freep>
            return (void *)(p + 1);
    1be4:	01078513          	addi	a0,a5,16
    }
}
    1be8:	70e2                	ld	ra,56(sp)
    1bea:	7442                	ld	s0,48(sp)
    1bec:	7902                	ld	s2,32(sp)
    1bee:	69e2                	ld	s3,24(sp)
    1bf0:	6121                	addi	sp,sp,64
    1bf2:	8082                	ret
    1bf4:	74a2                	ld	s1,40(sp)
    1bf6:	6a42                	ld	s4,16(sp)
    1bf8:	6aa2                	ld	s5,8(sp)
    1bfa:	6b02                	ld	s6,0(sp)
    1bfc:	b7f5                	j	1be8 <malloc+0xe4>
