
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
      12:	00001597          	auipc	a1,0x1
      16:	48e58593          	addi	a1,a1,1166 # 14a0 <malloc+0x100>
      1a:	8532                	mv	a0,a2
      1c:	00001097          	auipc	ra,0x1
      20:	f62080e7          	jalr	-158(ra) # f7e <write>
    memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	d22080e7          	jalr	-734(ra) # d4c <memset>
    gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	d64080e7          	jalr	-668(ra) # d9a <gets>
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
      60:	00001597          	auipc	a1,0x1
      64:	45058593          	addi	a1,a1,1104 # 14b0 <malloc+0x110>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	24c080e7          	jalr	588(ra) # 12b6 <fprintf>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	eea080e7          	jalr	-278(ra) # f5e <exit>

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
      88:	ed2080e7          	jalr	-302(ra) # f56 <fork>
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
      9a:	00001517          	auipc	a0,0x1
      9e:	41e50513          	addi	a0,a0,1054 # 14b8 <malloc+0x118>
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
      c6:	00001717          	auipc	a4,0x1
      ca:	50a70713          	addi	a4,a4,1290 # 15d0 <malloc+0x230>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
        exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	e84080e7          	jalr	-380(ra) # f5e <exit>
        panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	3de50513          	addi	a0,a0,990 # 14c0 <malloc+0x120>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
        if (ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
        exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	e9c080e7          	jalr	-356(ra) # f96 <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	3c458593          	addi	a1,a1,964 # 14c8 <malloc+0x128>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	1a8080e7          	jalr	424(ra) # 12b6 <fprintf>
    exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	e46080e7          	jalr	-442(ra) # f5e <exit>
            exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	e3c080e7          	jalr	-452(ra) # f5e <exit>
        close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	e5a080e7          	jalr	-422(ra) # f86 <close>
        if (open(rcmd->file, rcmd->mode) < 0)
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	e66080e7          	jalr	-410(ra) # f9e <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
        runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
            fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	38858593          	addi	a1,a1,904 # 14d8 <malloc+0x138>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	15c080e7          	jalr	348(ra) # 12b6 <fprintf>
            exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	dfa080e7          	jalr	-518(ra) # f5e <exit>
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
     186:	de4080e7          	jalr	-540(ra) # f66 <wait>
        runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
        if (pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	dd6080e7          	jalr	-554(ra) # f6e <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
        if (fork1() == 0)
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
            close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	dd6080e7          	jalr	-554(ra) # f86 <close>
            dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	e1a080e7          	jalr	-486(ra) # fd6 <dup>
            close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	dbe080e7          	jalr	-578(ra) # f86 <close>
            close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	db2080e7          	jalr	-590(ra) # f86 <close>
            runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
            panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	30250513          	addi	a0,a0,770 # 14e8 <malloc+0x148>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
        if (fork1() == 0)
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
            close(0);
     200:	00001097          	auipc	ra,0x1
     204:	d86080e7          	jalr	-634(ra) # f86 <close>
            dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	dca080e7          	jalr	-566(ra) # fd6 <dup>
            close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	d6e080e7          	jalr	-658(ra) # f86 <close>
            close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	d62080e7          	jalr	-670(ra) # f86 <close>
            runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
        close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	d4c080e7          	jalr	-692(ra) # f86 <close>
        close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	d40080e7          	jalr	-704(ra) # f86 <close>
        wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	d16080e7          	jalr	-746(ra) # f66 <wait>
        wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	d0c080e7          	jalr	-756(ra) # f66 <wait>
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
     288:	00001097          	auipc	ra,0x1
     28c:	118080e7          	jalr	280(ra) # 13a0 <malloc>
     290:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	ab4080e7          	jalr	-1356(ra) # d4c <memset>
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
     2d2:	00001097          	auipc	ra,0x1
     2d6:	0ce080e7          	jalr	206(ra) # 13a0 <malloc>
     2da:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	a6a080e7          	jalr	-1430(ra) # d4c <memset>
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
     330:	074080e7          	jalr	116(ra) # 13a0 <malloc>
     334:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	a12080e7          	jalr	-1518(ra) # d4c <memset>
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
     376:	02e080e7          	jalr	46(ra) # 13a0 <malloc>
     37a:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	9cc080e7          	jalr	-1588(ra) # d4c <memset>
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
     3b8:	fec080e7          	jalr	-20(ra) # 13a0 <malloc>
     3bc:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	98a080e7          	jalr	-1654(ra) # d4c <memset>
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
     414:	962080e7          	jalr	-1694(ra) # d72 <strchr>
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
     47a:	8fc080e7          	jalr	-1796(ra) # d72 <strchr>
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
     4e2:	894080e7          	jalr	-1900(ra) # d72 <strchr>
     4e6:	e90d                	bnez	a0,518 <gettoken+0x138>
     4e8:	0004c583          	lbu	a1,0(s1)
     4ec:	8556                	mv	a0,s5
     4ee:	00001097          	auipc	ra,0x1
     4f2:	884080e7          	jalr	-1916(ra) # d72 <strchr>
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
     558:	81e080e7          	jalr	-2018(ra) # d72 <strchr>
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
     586:	00000097          	auipc	ra,0x0
     58a:	7ec080e7          	jalr	2028(ra) # d72 <strchr>
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
     5b8:	f5cb0b13          	addi	s6,s6,-164 # 1510 <malloc+0x170>
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
     5ce:	f2650513          	addi	a0,a0,-218 # 14f0 <malloc+0x150>
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
     6aa:	e7260613          	addi	a2,a2,-398 # 1518 <malloc+0x178>
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
     6ea:	e52b0b13          	addi	s6,s6,-430 # 1538 <malloc+0x198>
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
     720:	e0450513          	addi	a0,a0,-508 # 1520 <malloc+0x180>
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
     77e:	dae50513          	addi	a0,a0,-594 # 1528 <malloc+0x188>
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
     7ce:	d7660613          	addi	a2,a2,-650 # 1540 <malloc+0x1a0>
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
     840:	d0ca0a13          	addi	s4,s4,-756 # 1548 <malloc+0x1a8>
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
     876:	cde60613          	addi	a2,a2,-802 # 1550 <malloc+0x1b0>
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
     8dc:	c4060613          	addi	a2,a2,-960 # 1518 <malloc+0x178>
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
     90c:	c6060613          	addi	a2,a2,-928 # 1568 <malloc+0x1c8>
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
     94e:	c0e50513          	addi	a0,a0,-1010 # 1558 <malloc+0x1b8>
     952:	fffff097          	auipc	ra,0xfffff
     956:	704080e7          	jalr	1796(ra) # 56 <panic>
        panic("syntax - missing )");
     95a:	00001517          	auipc	a0,0x1
     95e:	c1650513          	addi	a0,a0,-1002 # 1570 <malloc+0x1d0>
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
     98a:	c6270713          	addi	a4,a4,-926 # 15e8 <malloc+0x248>
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
     a16:	00000097          	auipc	ra,0x0
     a1a:	30a080e7          	jalr	778(ra) # d20 <strlen>
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
     a3a:	a7260613          	addi	a2,a2,-1422 # 14a8 <malloc+0x108>
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
     a70:	b1c58593          	addi	a1,a1,-1252 # 1588 <malloc+0x1e8>
     a74:	4509                	li	a0,2
     a76:	00001097          	auipc	ra,0x1
     a7a:	840080e7          	jalr	-1984(ra) # 12b6 <fprintf>
        panic("syntax");
     a7e:	00001517          	auipc	a0,0x1
     a82:	aa250513          	addi	a0,a0,-1374 # 1520 <malloc+0x180>
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
     ac6:	00000097          	auipc	ra,0x0
     aca:	4a0080e7          	jalr	1184(ra) # f66 <wait>
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
     af0:	00000097          	auipc	ra,0x0
     af4:	230080e7          	jalr	560(ra) # d20 <strlen>
     af8:	fff5079b          	addiw	a5,a0,-1
     afc:	1782                	slli	a5,a5,0x20
     afe:	9381                	srli	a5,a5,0x20
     b00:	97a6                	add	a5,a5,s1
     b02:	00078023          	sb	zero,0(a5)
        if (chdir(buf + 3) < 0)
     b06:	048d                	addi	s1,s1,3
     b08:	8526                	mv	a0,s1
     b0a:	00000097          	auipc	ra,0x0
     b0e:	4c4080e7          	jalr	1220(ra) # fce <chdir>
     b12:	fa055ee3          	bgez	a0,ace <parse_buffer+0x40>
            fprintf(2, "cannot cd %s\n", buf + 3);
     b16:	8626                	mv	a2,s1
     b18:	00001597          	auipc	a1,0x1
     b1c:	a8058593          	addi	a1,a1,-1408 # 1598 <malloc+0x1f8>
     b20:	4509                	li	a0,2
     b22:	00000097          	auipc	ra,0x0
     b26:	794080e7          	jalr	1940(ra) # 12b6 <fprintf>
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
     b46:	00000097          	auipc	ra,0x0
     b4a:	418080e7          	jalr	1048(ra) # f5e <exit>
        runcmd(parsecmd(buf));
     b4e:	8526                	mv	a0,s1
     b50:	00000097          	auipc	ra,0x0
     b54:	eb2080e7          	jalr	-334(ra) # a02 <parsecmd>
     b58:	fffff097          	auipc	ra,0xfffff
     b5c:	552080e7          	jalr	1362(ra) # aa <runcmd>

0000000000000b60 <main>:
{
     b60:	711d                	addi	sp,sp,-96
     b62:	ec86                	sd	ra,88(sp)
     b64:	e8a2                	sd	s0,80(sp)
     b66:	e4a6                	sd	s1,72(sp)
     b68:	e0ca                	sd	s2,64(sp)
     b6a:	fc4e                	sd	s3,56(sp)
     b6c:	f852                	sd	s4,48(sp)
     b6e:	1080                	addi	s0,sp,96
     b70:	89aa                	mv	s3,a0
     b72:	8a2e                	mv	s4,a1
    while ((fd = open("console", O_RDWR)) >= 0)
     b74:	4489                	li	s1,2
     b76:	00001917          	auipc	s2,0x1
     b7a:	a3290913          	addi	s2,s2,-1486 # 15a8 <malloc+0x208>
     b7e:	85a6                	mv	a1,s1
     b80:	854a                	mv	a0,s2
     b82:	00000097          	auipc	ra,0x0
     b86:	41c080e7          	jalr	1052(ra) # f9e <open>
     b8a:	00054863          	bltz	a0,b9a <main+0x3a>
        if (fd >= 3)
     b8e:	fea4d8e3          	bge	s1,a0,b7e <main+0x1e>
            close(fd);
     b92:	00000097          	auipc	ra,0x0
     b96:	3f4080e7          	jalr	1012(ra) # f86 <close>
    if (argc == 2)
     b9a:	4789                	li	a5,2
    while (getcmd(buf, sizeof(buf)) >= 0)
     b9c:	07800913          	li	s2,120
     ba0:	00001497          	auipc	s1,0x1
     ba4:	48048493          	addi	s1,s1,1152 # 2020 <buf.0>
    if (argc == 2)
     ba8:	00f98763          	beq	s3,a5,bb6 <main+0x56>
     bac:	f456                	sd	s5,40(sp)
     bae:	f05a                	sd	s6,32(sp)
     bb0:	ec5e                	sd	s7,24(sp)
     bb2:	e862                	sd	s8,16(sp)
     bb4:	a0c1                	j	c74 <main+0x114>
        char *shell_script_file = argv[1];
     bb6:	008a3483          	ld	s1,8(s4)
        int shfd = open(shell_script_file, O_RDWR);
     bba:	85ce                	mv	a1,s3
     bbc:	8526                	mv	a0,s1
     bbe:	00000097          	auipc	ra,0x0
     bc2:	3e0080e7          	jalr	992(ra) # f9e <open>
     bc6:	89aa                	mv	s3,a0
        if (shfd < 0)
     bc8:	02054163          	bltz	a0,bea <main+0x8a>
     bcc:	f456                	sd	s5,40(sp)
     bce:	f05a                	sd	s6,32(sp)
     bd0:	ec5e                	sd	s7,24(sp)
     bd2:	e862                	sd	s8,16(sp)
            memset(buf, 0, 120);
     bd4:	8c4a                	mv	s8,s2
     bd6:	00001b97          	auipc	s7,0x1
     bda:	44ab8b93          	addi	s7,s7,1098 # 2020 <buf.0>
                cr = read(shfd, &c, 1);
     bde:	faf40a93          	addi	s5,s0,-81
     be2:	4a05                	li	s4,1
            for (i = 0; i + 1 < 120;)
     be4:	07700b13          	li	s6,119
     be8:	a81d                	j	c1e <main+0xbe>
     bea:	f456                	sd	s5,40(sp)
     bec:	f05a                	sd	s6,32(sp)
     bee:	ec5e                	sd	s7,24(sp)
     bf0:	e862                	sd	s8,16(sp)
            printf("Failed to open %s\n", shell_script_file);
     bf2:	85a6                	mv	a1,s1
     bf4:	00001517          	auipc	a0,0x1
     bf8:	9bc50513          	addi	a0,a0,-1604 # 15b0 <malloc+0x210>
     bfc:	00000097          	auipc	ra,0x0
     c00:	6e8080e7          	jalr	1768(ra) # 12e4 <printf>
            exit(1);
     c04:	4505                	li	a0,1
     c06:	00000097          	auipc	ra,0x0
     c0a:	358080e7          	jalr	856(ra) # f5e <exit>
            buf[i] = '\0';
     c0e:	94de                	add	s1,s1,s7
     c10:	00048023          	sb	zero,0(s1)
            parse_buffer(buf);
     c14:	855e                	mv	a0,s7
     c16:	00000097          	auipc	ra,0x0
     c1a:	e78080e7          	jalr	-392(ra) # a8e <parse_buffer>
            memset(buf, 0, 120);
     c1e:	8662                	mv	a2,s8
     c20:	4581                	li	a1,0
     c22:	855e                	mv	a0,s7
     c24:	00000097          	auipc	ra,0x0
     c28:	128080e7          	jalr	296(ra) # d4c <memset>
            for (i = 0; i + 1 < 120;)
     c2c:	00001917          	auipc	s2,0x1
     c30:	3f490913          	addi	s2,s2,1012 # 2020 <buf.0>
     c34:	4481                	li	s1,0
                cr = read(shfd, &c, 1);
     c36:	8652                	mv	a2,s4
     c38:	85d6                	mv	a1,s5
     c3a:	854e                	mv	a0,s3
     c3c:	00000097          	auipc	ra,0x0
     c40:	33a080e7          	jalr	826(ra) # f76 <read>
                if (cr < 1)
     c44:	04a05563          	blez	a0,c8e <main+0x12e>
                if (c == '\n' || c == '\r')
     c48:	faf44783          	lbu	a5,-81(s0)
     c4c:	ff678713          	addi	a4,a5,-10
     c50:	df5d                	beqz	a4,c0e <main+0xae>
     c52:	ff378713          	addi	a4,a5,-13
     c56:	df45                	beqz	a4,c0e <main+0xae>
                buf[i++] = c;
     c58:	2485                	addiw	s1,s1,1
     c5a:	0ff4f493          	zext.b	s1,s1
     c5e:	00f90023          	sb	a5,0(s2)
            for (i = 0; i + 1 < 120;)
     c62:	0905                	addi	s2,s2,1
     c64:	fd6499e3          	bne	s1,s6,c36 <main+0xd6>
     c68:	b75d                	j	c0e <main+0xae>
        parse_buffer(buf);
     c6a:	8526                	mv	a0,s1
     c6c:	00000097          	auipc	ra,0x0
     c70:	e22080e7          	jalr	-478(ra) # a8e <parse_buffer>
    while (getcmd(buf, sizeof(buf)) >= 0)
     c74:	85ca                	mv	a1,s2
     c76:	8526                	mv	a0,s1
     c78:	fffff097          	auipc	ra,0xfffff
     c7c:	388080e7          	jalr	904(ra) # 0 <getcmd>
     c80:	fe0555e3          	bgez	a0,c6a <main+0x10a>
    exit(0);
     c84:	4501                	li	a0,0
     c86:	00000097          	auipc	ra,0x0
     c8a:	2d8080e7          	jalr	728(ra) # f5e <exit>
            buf[i] = '\0';
     c8e:	00001797          	auipc	a5,0x1
     c92:	39278793          	addi	a5,a5,914 # 2020 <buf.0>
     c96:	97a6                	add	a5,a5,s1
     c98:	00078023          	sb	zero,0(a5)
            parse_buffer(buf);
     c9c:	00001517          	auipc	a0,0x1
     ca0:	38450513          	addi	a0,a0,900 # 2020 <buf.0>
     ca4:	00000097          	auipc	ra,0x0
     ca8:	dea080e7          	jalr	-534(ra) # a8e <parse_buffer>
        exit(0);
     cac:	4501                	li	a0,0
     cae:	00000097          	auipc	ra,0x0
     cb2:	2b0080e7          	jalr	688(ra) # f5e <exit>

0000000000000cb6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     cb6:	1141                	addi	sp,sp,-16
     cb8:	e406                	sd	ra,8(sp)
     cba:	e022                	sd	s0,0(sp)
     cbc:	0800                	addi	s0,sp,16
  extern int main();
  main();
     cbe:	00000097          	auipc	ra,0x0
     cc2:	ea2080e7          	jalr	-350(ra) # b60 <main>
  exit(0);
     cc6:	4501                	li	a0,0
     cc8:	00000097          	auipc	ra,0x0
     ccc:	296080e7          	jalr	662(ra) # f5e <exit>

0000000000000cd0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     cd0:	1141                	addi	sp,sp,-16
     cd2:	e406                	sd	ra,8(sp)
     cd4:	e022                	sd	s0,0(sp)
     cd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     cd8:	87aa                	mv	a5,a0
     cda:	0585                	addi	a1,a1,1
     cdc:	0785                	addi	a5,a5,1
     cde:	fff5c703          	lbu	a4,-1(a1)
     ce2:	fee78fa3          	sb	a4,-1(a5)
     ce6:	fb75                	bnez	a4,cda <strcpy+0xa>
    ;
  return os;
}
     ce8:	60a2                	ld	ra,8(sp)
     cea:	6402                	ld	s0,0(sp)
     cec:	0141                	addi	sp,sp,16
     cee:	8082                	ret

0000000000000cf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cf0:	1141                	addi	sp,sp,-16
     cf2:	e406                	sd	ra,8(sp)
     cf4:	e022                	sd	s0,0(sp)
     cf6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     cf8:	00054783          	lbu	a5,0(a0)
     cfc:	cb91                	beqz	a5,d10 <strcmp+0x20>
     cfe:	0005c703          	lbu	a4,0(a1)
     d02:	00f71763          	bne	a4,a5,d10 <strcmp+0x20>
    p++, q++;
     d06:	0505                	addi	a0,a0,1
     d08:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     d0a:	00054783          	lbu	a5,0(a0)
     d0e:	fbe5                	bnez	a5,cfe <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     d10:	0005c503          	lbu	a0,0(a1)
}
     d14:	40a7853b          	subw	a0,a5,a0
     d18:	60a2                	ld	ra,8(sp)
     d1a:	6402                	ld	s0,0(sp)
     d1c:	0141                	addi	sp,sp,16
     d1e:	8082                	ret

0000000000000d20 <strlen>:

uint
strlen(const char *s)
{
     d20:	1141                	addi	sp,sp,-16
     d22:	e406                	sd	ra,8(sp)
     d24:	e022                	sd	s0,0(sp)
     d26:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     d28:	00054783          	lbu	a5,0(a0)
     d2c:	cf91                	beqz	a5,d48 <strlen+0x28>
     d2e:	00150793          	addi	a5,a0,1
     d32:	86be                	mv	a3,a5
     d34:	0785                	addi	a5,a5,1
     d36:	fff7c703          	lbu	a4,-1(a5)
     d3a:	ff65                	bnez	a4,d32 <strlen+0x12>
     d3c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     d40:	60a2                	ld	ra,8(sp)
     d42:	6402                	ld	s0,0(sp)
     d44:	0141                	addi	sp,sp,16
     d46:	8082                	ret
  for(n = 0; s[n]; n++)
     d48:	4501                	li	a0,0
     d4a:	bfdd                	j	d40 <strlen+0x20>

0000000000000d4c <memset>:

void*
memset(void *dst, int c, uint n)
{
     d4c:	1141                	addi	sp,sp,-16
     d4e:	e406                	sd	ra,8(sp)
     d50:	e022                	sd	s0,0(sp)
     d52:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d54:	ca19                	beqz	a2,d6a <memset+0x1e>
     d56:	87aa                	mv	a5,a0
     d58:	1602                	slli	a2,a2,0x20
     d5a:	9201                	srli	a2,a2,0x20
     d5c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d60:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d64:	0785                	addi	a5,a5,1
     d66:	fee79de3          	bne	a5,a4,d60 <memset+0x14>
  }
  return dst;
}
     d6a:	60a2                	ld	ra,8(sp)
     d6c:	6402                	ld	s0,0(sp)
     d6e:	0141                	addi	sp,sp,16
     d70:	8082                	ret

0000000000000d72 <strchr>:

char*
strchr(const char *s, char c)
{
     d72:	1141                	addi	sp,sp,-16
     d74:	e406                	sd	ra,8(sp)
     d76:	e022                	sd	s0,0(sp)
     d78:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d7a:	00054783          	lbu	a5,0(a0)
     d7e:	cf81                	beqz	a5,d96 <strchr+0x24>
    if(*s == c)
     d80:	00f58763          	beq	a1,a5,d8e <strchr+0x1c>
  for(; *s; s++)
     d84:	0505                	addi	a0,a0,1
     d86:	00054783          	lbu	a5,0(a0)
     d8a:	fbfd                	bnez	a5,d80 <strchr+0xe>
      return (char*)s;
  return 0;
     d8c:	4501                	li	a0,0
}
     d8e:	60a2                	ld	ra,8(sp)
     d90:	6402                	ld	s0,0(sp)
     d92:	0141                	addi	sp,sp,16
     d94:	8082                	ret
  return 0;
     d96:	4501                	li	a0,0
     d98:	bfdd                	j	d8e <strchr+0x1c>

0000000000000d9a <gets>:

char*
gets(char *buf, int max)
{
     d9a:	711d                	addi	sp,sp,-96
     d9c:	ec86                	sd	ra,88(sp)
     d9e:	e8a2                	sd	s0,80(sp)
     da0:	e4a6                	sd	s1,72(sp)
     da2:	e0ca                	sd	s2,64(sp)
     da4:	fc4e                	sd	s3,56(sp)
     da6:	f852                	sd	s4,48(sp)
     da8:	f456                	sd	s5,40(sp)
     daa:	f05a                	sd	s6,32(sp)
     dac:	ec5e                	sd	s7,24(sp)
     dae:	e862                	sd	s8,16(sp)
     db0:	1080                	addi	s0,sp,96
     db2:	8baa                	mv	s7,a0
     db4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     db6:	892a                	mv	s2,a0
     db8:	4481                	li	s1,0
    cc = read(0, &c, 1);
     dba:	faf40b13          	addi	s6,s0,-81
     dbe:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     dc0:	8c26                	mv	s8,s1
     dc2:	0014899b          	addiw	s3,s1,1
     dc6:	84ce                	mv	s1,s3
     dc8:	0349d663          	bge	s3,s4,df4 <gets+0x5a>
    cc = read(0, &c, 1);
     dcc:	8656                	mv	a2,s5
     dce:	85da                	mv	a1,s6
     dd0:	4501                	li	a0,0
     dd2:	00000097          	auipc	ra,0x0
     dd6:	1a4080e7          	jalr	420(ra) # f76 <read>
    if(cc < 1)
     dda:	00a05d63          	blez	a0,df4 <gets+0x5a>
      break;
    buf[i++] = c;
     dde:	faf44783          	lbu	a5,-81(s0)
     de2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     de6:	0905                	addi	s2,s2,1
     de8:	ff678713          	addi	a4,a5,-10
     dec:	c319                	beqz	a4,df2 <gets+0x58>
     dee:	17cd                	addi	a5,a5,-13
     df0:	fbe1                	bnez	a5,dc0 <gets+0x26>
    buf[i++] = c;
     df2:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     df4:	9c5e                	add	s8,s8,s7
     df6:	000c0023          	sb	zero,0(s8)
  return buf;
}
     dfa:	855e                	mv	a0,s7
     dfc:	60e6                	ld	ra,88(sp)
     dfe:	6446                	ld	s0,80(sp)
     e00:	64a6                	ld	s1,72(sp)
     e02:	6906                	ld	s2,64(sp)
     e04:	79e2                	ld	s3,56(sp)
     e06:	7a42                	ld	s4,48(sp)
     e08:	7aa2                	ld	s5,40(sp)
     e0a:	7b02                	ld	s6,32(sp)
     e0c:	6be2                	ld	s7,24(sp)
     e0e:	6c42                	ld	s8,16(sp)
     e10:	6125                	addi	sp,sp,96
     e12:	8082                	ret

0000000000000e14 <stat>:

int
stat(const char *n, struct stat *st)
{
     e14:	1101                	addi	sp,sp,-32
     e16:	ec06                	sd	ra,24(sp)
     e18:	e822                	sd	s0,16(sp)
     e1a:	e04a                	sd	s2,0(sp)
     e1c:	1000                	addi	s0,sp,32
     e1e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e20:	4581                	li	a1,0
     e22:	00000097          	auipc	ra,0x0
     e26:	17c080e7          	jalr	380(ra) # f9e <open>
  if(fd < 0)
     e2a:	02054663          	bltz	a0,e56 <stat+0x42>
     e2e:	e426                	sd	s1,8(sp)
     e30:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e32:	85ca                	mv	a1,s2
     e34:	00000097          	auipc	ra,0x0
     e38:	182080e7          	jalr	386(ra) # fb6 <fstat>
     e3c:	892a                	mv	s2,a0
  close(fd);
     e3e:	8526                	mv	a0,s1
     e40:	00000097          	auipc	ra,0x0
     e44:	146080e7          	jalr	326(ra) # f86 <close>
  return r;
     e48:	64a2                	ld	s1,8(sp)
}
     e4a:	854a                	mv	a0,s2
     e4c:	60e2                	ld	ra,24(sp)
     e4e:	6442                	ld	s0,16(sp)
     e50:	6902                	ld	s2,0(sp)
     e52:	6105                	addi	sp,sp,32
     e54:	8082                	ret
    return -1;
     e56:	57fd                	li	a5,-1
     e58:	893e                	mv	s2,a5
     e5a:	bfc5                	j	e4a <stat+0x36>

0000000000000e5c <atoi>:

int
atoi(const char *s)
{
     e5c:	1141                	addi	sp,sp,-16
     e5e:	e406                	sd	ra,8(sp)
     e60:	e022                	sd	s0,0(sp)
     e62:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e64:	00054683          	lbu	a3,0(a0)
     e68:	fd06879b          	addiw	a5,a3,-48
     e6c:	0ff7f793          	zext.b	a5,a5
     e70:	4625                	li	a2,9
     e72:	02f66963          	bltu	a2,a5,ea4 <atoi+0x48>
     e76:	872a                	mv	a4,a0
  n = 0;
     e78:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e7a:	0705                	addi	a4,a4,1
     e7c:	0025179b          	slliw	a5,a0,0x2
     e80:	9fa9                	addw	a5,a5,a0
     e82:	0017979b          	slliw	a5,a5,0x1
     e86:	9fb5                	addw	a5,a5,a3
     e88:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e8c:	00074683          	lbu	a3,0(a4)
     e90:	fd06879b          	addiw	a5,a3,-48
     e94:	0ff7f793          	zext.b	a5,a5
     e98:	fef671e3          	bgeu	a2,a5,e7a <atoi+0x1e>
  return n;
}
     e9c:	60a2                	ld	ra,8(sp)
     e9e:	6402                	ld	s0,0(sp)
     ea0:	0141                	addi	sp,sp,16
     ea2:	8082                	ret
  n = 0;
     ea4:	4501                	li	a0,0
     ea6:	bfdd                	j	e9c <atoi+0x40>

0000000000000ea8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ea8:	1141                	addi	sp,sp,-16
     eaa:	e406                	sd	ra,8(sp)
     eac:	e022                	sd	s0,0(sp)
     eae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     eb0:	02b57563          	bgeu	a0,a1,eda <memmove+0x32>
    while(n-- > 0)
     eb4:	00c05f63          	blez	a2,ed2 <memmove+0x2a>
     eb8:	1602                	slli	a2,a2,0x20
     eba:	9201                	srli	a2,a2,0x20
     ebc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ec0:	872a                	mv	a4,a0
      *dst++ = *src++;
     ec2:	0585                	addi	a1,a1,1
     ec4:	0705                	addi	a4,a4,1
     ec6:	fff5c683          	lbu	a3,-1(a1)
     eca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ece:	fee79ae3          	bne	a5,a4,ec2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ed2:	60a2                	ld	ra,8(sp)
     ed4:	6402                	ld	s0,0(sp)
     ed6:	0141                	addi	sp,sp,16
     ed8:	8082                	ret
    while(n-- > 0)
     eda:	fec05ce3          	blez	a2,ed2 <memmove+0x2a>
    dst += n;
     ede:	00c50733          	add	a4,a0,a2
    src += n;
     ee2:	95b2                	add	a1,a1,a2
     ee4:	fff6079b          	addiw	a5,a2,-1
     ee8:	1782                	slli	a5,a5,0x20
     eea:	9381                	srli	a5,a5,0x20
     eec:	fff7c793          	not	a5,a5
     ef0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ef2:	15fd                	addi	a1,a1,-1
     ef4:	177d                	addi	a4,a4,-1
     ef6:	0005c683          	lbu	a3,0(a1)
     efa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     efe:	fef71ae3          	bne	a4,a5,ef2 <memmove+0x4a>
     f02:	bfc1                	j	ed2 <memmove+0x2a>

0000000000000f04 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     f04:	1141                	addi	sp,sp,-16
     f06:	e406                	sd	ra,8(sp)
     f08:	e022                	sd	s0,0(sp)
     f0a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     f0c:	c61d                	beqz	a2,f3a <memcmp+0x36>
     f0e:	1602                	slli	a2,a2,0x20
     f10:	9201                	srli	a2,a2,0x20
     f12:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     f16:	00054783          	lbu	a5,0(a0)
     f1a:	0005c703          	lbu	a4,0(a1)
     f1e:	00e79863          	bne	a5,a4,f2e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     f22:	0505                	addi	a0,a0,1
    p2++;
     f24:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     f26:	fed518e3          	bne	a0,a3,f16 <memcmp+0x12>
  }
  return 0;
     f2a:	4501                	li	a0,0
     f2c:	a019                	j	f32 <memcmp+0x2e>
      return *p1 - *p2;
     f2e:	40e7853b          	subw	a0,a5,a4
}
     f32:	60a2                	ld	ra,8(sp)
     f34:	6402                	ld	s0,0(sp)
     f36:	0141                	addi	sp,sp,16
     f38:	8082                	ret
  return 0;
     f3a:	4501                	li	a0,0
     f3c:	bfdd                	j	f32 <memcmp+0x2e>

0000000000000f3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     f3e:	1141                	addi	sp,sp,-16
     f40:	e406                	sd	ra,8(sp)
     f42:	e022                	sd	s0,0(sp)
     f44:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     f46:	00000097          	auipc	ra,0x0
     f4a:	f62080e7          	jalr	-158(ra) # ea8 <memmove>
}
     f4e:	60a2                	ld	ra,8(sp)
     f50:	6402                	ld	s0,0(sp)
     f52:	0141                	addi	sp,sp,16
     f54:	8082                	ret

0000000000000f56 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f56:	4885                	li	a7,1
 ecall
     f58:	00000073          	ecall
 ret
     f5c:	8082                	ret

0000000000000f5e <exit>:
.global exit
exit:
 li a7, SYS_exit
     f5e:	4889                	li	a7,2
 ecall
     f60:	00000073          	ecall
 ret
     f64:	8082                	ret

0000000000000f66 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f66:	488d                	li	a7,3
 ecall
     f68:	00000073          	ecall
 ret
     f6c:	8082                	ret

0000000000000f6e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f6e:	4891                	li	a7,4
 ecall
     f70:	00000073          	ecall
 ret
     f74:	8082                	ret

0000000000000f76 <read>:
.global read
read:
 li a7, SYS_read
     f76:	4895                	li	a7,5
 ecall
     f78:	00000073          	ecall
 ret
     f7c:	8082                	ret

0000000000000f7e <write>:
.global write
write:
 li a7, SYS_write
     f7e:	48c1                	li	a7,16
 ecall
     f80:	00000073          	ecall
 ret
     f84:	8082                	ret

0000000000000f86 <close>:
.global close
close:
 li a7, SYS_close
     f86:	48d5                	li	a7,21
 ecall
     f88:	00000073          	ecall
 ret
     f8c:	8082                	ret

0000000000000f8e <kill>:
.global kill
kill:
 li a7, SYS_kill
     f8e:	4899                	li	a7,6
 ecall
     f90:	00000073          	ecall
 ret
     f94:	8082                	ret

0000000000000f96 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f96:	489d                	li	a7,7
 ecall
     f98:	00000073          	ecall
 ret
     f9c:	8082                	ret

0000000000000f9e <open>:
.global open
open:
 li a7, SYS_open
     f9e:	48bd                	li	a7,15
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     fa6:	48c5                	li	a7,17
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     fae:	48c9                	li	a7,18
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     fb6:	48a1                	li	a7,8
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <link>:
.global link
link:
 li a7, SYS_link
     fbe:	48cd                	li	a7,19
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     fc6:	48d1                	li	a7,20
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     fce:	48a5                	li	a7,9
 ecall
     fd0:	00000073          	ecall
 ret
     fd4:	8082                	ret

0000000000000fd6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     fd6:	48a9                	li	a7,10
 ecall
     fd8:	00000073          	ecall
 ret
     fdc:	8082                	ret

0000000000000fde <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     fde:	48ad                	li	a7,11
 ecall
     fe0:	00000073          	ecall
 ret
     fe4:	8082                	ret

0000000000000fe6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     fe6:	48b1                	li	a7,12
 ecall
     fe8:	00000073          	ecall
 ret
     fec:	8082                	ret

0000000000000fee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     fee:	48b5                	li	a7,13
 ecall
     ff0:	00000073          	ecall
 ret
     ff4:	8082                	ret

0000000000000ff6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ff6:	48b9                	li	a7,14
 ecall
     ff8:	00000073          	ecall
 ret
     ffc:	8082                	ret

0000000000000ffe <ps>:
.global ps
ps:
 li a7, SYS_ps
     ffe:	48d9                	li	a7,22
 ecall
    1000:	00000073          	ecall
 ret
    1004:	8082                	ret

0000000000001006 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    1006:	48dd                	li	a7,23
 ecall
    1008:	00000073          	ecall
 ret
    100c:	8082                	ret

000000000000100e <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    100e:	48e1                	li	a7,24
 ecall
    1010:	00000073          	ecall
 ret
    1014:	8082                	ret

0000000000001016 <yield>:
.global yield
yield:
 li a7, SYS_yield
    1016:	48e5                	li	a7,25
 ecall
    1018:	00000073          	ecall
 ret
    101c:	8082                	ret

000000000000101e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    101e:	1101                	addi	sp,sp,-32
    1020:	ec06                	sd	ra,24(sp)
    1022:	e822                	sd	s0,16(sp)
    1024:	1000                	addi	s0,sp,32
    1026:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    102a:	4605                	li	a2,1
    102c:	fef40593          	addi	a1,s0,-17
    1030:	00000097          	auipc	ra,0x0
    1034:	f4e080e7          	jalr	-178(ra) # f7e <write>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	6105                	addi	sp,sp,32
    103e:	8082                	ret

0000000000001040 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1040:	7139                	addi	sp,sp,-64
    1042:	fc06                	sd	ra,56(sp)
    1044:	f822                	sd	s0,48(sp)
    1046:	f04a                	sd	s2,32(sp)
    1048:	ec4e                	sd	s3,24(sp)
    104a:	0080                	addi	s0,sp,64
    104c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    104e:	cad9                	beqz	a3,10e4 <printint+0xa4>
    1050:	01f5d79b          	srliw	a5,a1,0x1f
    1054:	cbc1                	beqz	a5,10e4 <printint+0xa4>
    neg = 1;
    x = -xx;
    1056:	40b005bb          	negw	a1,a1
    neg = 1;
    105a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    105c:	fc040993          	addi	s3,s0,-64
  neg = 0;
    1060:	86ce                	mv	a3,s3
  i = 0;
    1062:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1064:	00000817          	auipc	a6,0x0
    1068:	5f480813          	addi	a6,a6,1524 # 1658 <digits>
    106c:	88ba                	mv	a7,a4
    106e:	0017051b          	addiw	a0,a4,1
    1072:	872a                	mv	a4,a0
    1074:	02c5f7bb          	remuw	a5,a1,a2
    1078:	1782                	slli	a5,a5,0x20
    107a:	9381                	srli	a5,a5,0x20
    107c:	97c2                	add	a5,a5,a6
    107e:	0007c783          	lbu	a5,0(a5)
    1082:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1086:	87ae                	mv	a5,a1
    1088:	02c5d5bb          	divuw	a1,a1,a2
    108c:	0685                	addi	a3,a3,1
    108e:	fcc7ffe3          	bgeu	a5,a2,106c <printint+0x2c>
  if(neg)
    1092:	00030c63          	beqz	t1,10aa <printint+0x6a>
    buf[i++] = '-';
    1096:	fd050793          	addi	a5,a0,-48
    109a:	00878533          	add	a0,a5,s0
    109e:	02d00793          	li	a5,45
    10a2:	fef50823          	sb	a5,-16(a0)
    10a6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    10aa:	02e05763          	blez	a4,10d8 <printint+0x98>
    10ae:	f426                	sd	s1,40(sp)
    10b0:	377d                	addiw	a4,a4,-1
    10b2:	00e984b3          	add	s1,s3,a4
    10b6:	19fd                	addi	s3,s3,-1
    10b8:	99ba                	add	s3,s3,a4
    10ba:	1702                	slli	a4,a4,0x20
    10bc:	9301                	srli	a4,a4,0x20
    10be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    10c2:	0004c583          	lbu	a1,0(s1)
    10c6:	854a                	mv	a0,s2
    10c8:	00000097          	auipc	ra,0x0
    10cc:	f56080e7          	jalr	-170(ra) # 101e <putc>
  while(--i >= 0)
    10d0:	14fd                	addi	s1,s1,-1
    10d2:	ff3498e3          	bne	s1,s3,10c2 <printint+0x82>
    10d6:	74a2                	ld	s1,40(sp)
}
    10d8:	70e2                	ld	ra,56(sp)
    10da:	7442                	ld	s0,48(sp)
    10dc:	7902                	ld	s2,32(sp)
    10de:	69e2                	ld	s3,24(sp)
    10e0:	6121                	addi	sp,sp,64
    10e2:	8082                	ret
  neg = 0;
    10e4:	4301                	li	t1,0
    10e6:	bf9d                	j	105c <printint+0x1c>

00000000000010e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10e8:	715d                	addi	sp,sp,-80
    10ea:	e486                	sd	ra,72(sp)
    10ec:	e0a2                	sd	s0,64(sp)
    10ee:	f84a                	sd	s2,48(sp)
    10f0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10f2:	0005c903          	lbu	s2,0(a1)
    10f6:	1a090b63          	beqz	s2,12ac <vprintf+0x1c4>
    10fa:	fc26                	sd	s1,56(sp)
    10fc:	f44e                	sd	s3,40(sp)
    10fe:	f052                	sd	s4,32(sp)
    1100:	ec56                	sd	s5,24(sp)
    1102:	e85a                	sd	s6,16(sp)
    1104:	e45e                	sd	s7,8(sp)
    1106:	8aaa                	mv	s5,a0
    1108:	8bb2                	mv	s7,a2
    110a:	00158493          	addi	s1,a1,1
  state = 0;
    110e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1110:	02500a13          	li	s4,37
    1114:	4b55                	li	s6,21
    1116:	a839                	j	1134 <vprintf+0x4c>
        putc(fd, c);
    1118:	85ca                	mv	a1,s2
    111a:	8556                	mv	a0,s5
    111c:	00000097          	auipc	ra,0x0
    1120:	f02080e7          	jalr	-254(ra) # 101e <putc>
    1124:	a019                	j	112a <vprintf+0x42>
    } else if(state == '%'){
    1126:	01498d63          	beq	s3,s4,1140 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    112a:	0485                	addi	s1,s1,1
    112c:	fff4c903          	lbu	s2,-1(s1)
    1130:	16090863          	beqz	s2,12a0 <vprintf+0x1b8>
    if(state == 0){
    1134:	fe0999e3          	bnez	s3,1126 <vprintf+0x3e>
      if(c == '%'){
    1138:	ff4910e3          	bne	s2,s4,1118 <vprintf+0x30>
        state = '%';
    113c:	89d2                	mv	s3,s4
    113e:	b7f5                	j	112a <vprintf+0x42>
      if(c == 'd'){
    1140:	13490563          	beq	s2,s4,126a <vprintf+0x182>
    1144:	f9d9079b          	addiw	a5,s2,-99
    1148:	0ff7f793          	zext.b	a5,a5
    114c:	12fb6863          	bltu	s6,a5,127c <vprintf+0x194>
    1150:	f9d9079b          	addiw	a5,s2,-99
    1154:	0ff7f713          	zext.b	a4,a5
    1158:	12eb6263          	bltu	s6,a4,127c <vprintf+0x194>
    115c:	00271793          	slli	a5,a4,0x2
    1160:	00000717          	auipc	a4,0x0
    1164:	4a070713          	addi	a4,a4,1184 # 1600 <malloc+0x260>
    1168:	97ba                	add	a5,a5,a4
    116a:	439c                	lw	a5,0(a5)
    116c:	97ba                	add	a5,a5,a4
    116e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1170:	008b8913          	addi	s2,s7,8
    1174:	4685                	li	a3,1
    1176:	4629                	li	a2,10
    1178:	000ba583          	lw	a1,0(s7)
    117c:	8556                	mv	a0,s5
    117e:	00000097          	auipc	ra,0x0
    1182:	ec2080e7          	jalr	-318(ra) # 1040 <printint>
    1186:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1188:	4981                	li	s3,0
    118a:	b745                	j	112a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    118c:	008b8913          	addi	s2,s7,8
    1190:	4681                	li	a3,0
    1192:	4629                	li	a2,10
    1194:	000ba583          	lw	a1,0(s7)
    1198:	8556                	mv	a0,s5
    119a:	00000097          	auipc	ra,0x0
    119e:	ea6080e7          	jalr	-346(ra) # 1040 <printint>
    11a2:	8bca                	mv	s7,s2
      state = 0;
    11a4:	4981                	li	s3,0
    11a6:	b751                	j	112a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    11a8:	008b8913          	addi	s2,s7,8
    11ac:	4681                	li	a3,0
    11ae:	4641                	li	a2,16
    11b0:	000ba583          	lw	a1,0(s7)
    11b4:	8556                	mv	a0,s5
    11b6:	00000097          	auipc	ra,0x0
    11ba:	e8a080e7          	jalr	-374(ra) # 1040 <printint>
    11be:	8bca                	mv	s7,s2
      state = 0;
    11c0:	4981                	li	s3,0
    11c2:	b7a5                	j	112a <vprintf+0x42>
    11c4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    11c6:	008b8793          	addi	a5,s7,8
    11ca:	8c3e                	mv	s8,a5
    11cc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    11d0:	03000593          	li	a1,48
    11d4:	8556                	mv	a0,s5
    11d6:	00000097          	auipc	ra,0x0
    11da:	e48080e7          	jalr	-440(ra) # 101e <putc>
  putc(fd, 'x');
    11de:	07800593          	li	a1,120
    11e2:	8556                	mv	a0,s5
    11e4:	00000097          	auipc	ra,0x0
    11e8:	e3a080e7          	jalr	-454(ra) # 101e <putc>
    11ec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11ee:	00000b97          	auipc	s7,0x0
    11f2:	46ab8b93          	addi	s7,s7,1130 # 1658 <digits>
    11f6:	03c9d793          	srli	a5,s3,0x3c
    11fa:	97de                	add	a5,a5,s7
    11fc:	0007c583          	lbu	a1,0(a5)
    1200:	8556                	mv	a0,s5
    1202:	00000097          	auipc	ra,0x0
    1206:	e1c080e7          	jalr	-484(ra) # 101e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    120a:	0992                	slli	s3,s3,0x4
    120c:	397d                	addiw	s2,s2,-1
    120e:	fe0914e3          	bnez	s2,11f6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    1212:	8be2                	mv	s7,s8
      state = 0;
    1214:	4981                	li	s3,0
    1216:	6c02                	ld	s8,0(sp)
    1218:	bf09                	j	112a <vprintf+0x42>
        s = va_arg(ap, char*);
    121a:	008b8993          	addi	s3,s7,8
    121e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1222:	02090163          	beqz	s2,1244 <vprintf+0x15c>
        while(*s != 0){
    1226:	00094583          	lbu	a1,0(s2)
    122a:	c9a5                	beqz	a1,129a <vprintf+0x1b2>
          putc(fd, *s);
    122c:	8556                	mv	a0,s5
    122e:	00000097          	auipc	ra,0x0
    1232:	df0080e7          	jalr	-528(ra) # 101e <putc>
          s++;
    1236:	0905                	addi	s2,s2,1
        while(*s != 0){
    1238:	00094583          	lbu	a1,0(s2)
    123c:	f9e5                	bnez	a1,122c <vprintf+0x144>
        s = va_arg(ap, char*);
    123e:	8bce                	mv	s7,s3
      state = 0;
    1240:	4981                	li	s3,0
    1242:	b5e5                	j	112a <vprintf+0x42>
          s = "(null)";
    1244:	00000917          	auipc	s2,0x0
    1248:	38490913          	addi	s2,s2,900 # 15c8 <malloc+0x228>
        while(*s != 0){
    124c:	02800593          	li	a1,40
    1250:	bff1                	j	122c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    1252:	008b8913          	addi	s2,s7,8
    1256:	000bc583          	lbu	a1,0(s7)
    125a:	8556                	mv	a0,s5
    125c:	00000097          	auipc	ra,0x0
    1260:	dc2080e7          	jalr	-574(ra) # 101e <putc>
    1264:	8bca                	mv	s7,s2
      state = 0;
    1266:	4981                	li	s3,0
    1268:	b5c9                	j	112a <vprintf+0x42>
        putc(fd, c);
    126a:	02500593          	li	a1,37
    126e:	8556                	mv	a0,s5
    1270:	00000097          	auipc	ra,0x0
    1274:	dae080e7          	jalr	-594(ra) # 101e <putc>
      state = 0;
    1278:	4981                	li	s3,0
    127a:	bd45                	j	112a <vprintf+0x42>
        putc(fd, '%');
    127c:	02500593          	li	a1,37
    1280:	8556                	mv	a0,s5
    1282:	00000097          	auipc	ra,0x0
    1286:	d9c080e7          	jalr	-612(ra) # 101e <putc>
        putc(fd, c);
    128a:	85ca                	mv	a1,s2
    128c:	8556                	mv	a0,s5
    128e:	00000097          	auipc	ra,0x0
    1292:	d90080e7          	jalr	-624(ra) # 101e <putc>
      state = 0;
    1296:	4981                	li	s3,0
    1298:	bd49                	j	112a <vprintf+0x42>
        s = va_arg(ap, char*);
    129a:	8bce                	mv	s7,s3
      state = 0;
    129c:	4981                	li	s3,0
    129e:	b571                	j	112a <vprintf+0x42>
    12a0:	74e2                	ld	s1,56(sp)
    12a2:	79a2                	ld	s3,40(sp)
    12a4:	7a02                	ld	s4,32(sp)
    12a6:	6ae2                	ld	s5,24(sp)
    12a8:	6b42                	ld	s6,16(sp)
    12aa:	6ba2                	ld	s7,8(sp)
    }
  }
}
    12ac:	60a6                	ld	ra,72(sp)
    12ae:	6406                	ld	s0,64(sp)
    12b0:	7942                	ld	s2,48(sp)
    12b2:	6161                	addi	sp,sp,80
    12b4:	8082                	ret

00000000000012b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    12b6:	715d                	addi	sp,sp,-80
    12b8:	ec06                	sd	ra,24(sp)
    12ba:	e822                	sd	s0,16(sp)
    12bc:	1000                	addi	s0,sp,32
    12be:	e010                	sd	a2,0(s0)
    12c0:	e414                	sd	a3,8(s0)
    12c2:	e818                	sd	a4,16(s0)
    12c4:	ec1c                	sd	a5,24(s0)
    12c6:	03043023          	sd	a6,32(s0)
    12ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    12ce:	8622                	mv	a2,s0
    12d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    12d4:	00000097          	auipc	ra,0x0
    12d8:	e14080e7          	jalr	-492(ra) # 10e8 <vprintf>
}
    12dc:	60e2                	ld	ra,24(sp)
    12de:	6442                	ld	s0,16(sp)
    12e0:	6161                	addi	sp,sp,80
    12e2:	8082                	ret

00000000000012e4 <printf>:

void
printf(const char *fmt, ...)
{
    12e4:	711d                	addi	sp,sp,-96
    12e6:	ec06                	sd	ra,24(sp)
    12e8:	e822                	sd	s0,16(sp)
    12ea:	1000                	addi	s0,sp,32
    12ec:	e40c                	sd	a1,8(s0)
    12ee:	e810                	sd	a2,16(s0)
    12f0:	ec14                	sd	a3,24(s0)
    12f2:	f018                	sd	a4,32(s0)
    12f4:	f41c                	sd	a5,40(s0)
    12f6:	03043823          	sd	a6,48(s0)
    12fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    12fe:	00840613          	addi	a2,s0,8
    1302:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1306:	85aa                	mv	a1,a0
    1308:	4505                	li	a0,1
    130a:	00000097          	auipc	ra,0x0
    130e:	dde080e7          	jalr	-546(ra) # 10e8 <vprintf>
}
    1312:	60e2                	ld	ra,24(sp)
    1314:	6442                	ld	s0,16(sp)
    1316:	6125                	addi	sp,sp,96
    1318:	8082                	ret

000000000000131a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    131a:	1141                	addi	sp,sp,-16
    131c:	e406                	sd	ra,8(sp)
    131e:	e022                	sd	s0,0(sp)
    1320:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1322:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1326:	00001797          	auipc	a5,0x1
    132a:	cea7b783          	ld	a5,-790(a5) # 2010 <freep>
    132e:	a039                	j	133c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1330:	6398                	ld	a4,0(a5)
    1332:	00e7e463          	bltu	a5,a4,133a <free+0x20>
    1336:	00e6ea63          	bltu	a3,a4,134a <free+0x30>
{
    133a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    133c:	fed7fae3          	bgeu	a5,a3,1330 <free+0x16>
    1340:	6398                	ld	a4,0(a5)
    1342:	00e6e463          	bltu	a3,a4,134a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1346:	fee7eae3          	bltu	a5,a4,133a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    134a:	ff852583          	lw	a1,-8(a0)
    134e:	6390                	ld	a2,0(a5)
    1350:	02059813          	slli	a6,a1,0x20
    1354:	01c85713          	srli	a4,a6,0x1c
    1358:	9736                	add	a4,a4,a3
    135a:	02e60563          	beq	a2,a4,1384 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    135e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1362:	4790                	lw	a2,8(a5)
    1364:	02061593          	slli	a1,a2,0x20
    1368:	01c5d713          	srli	a4,a1,0x1c
    136c:	973e                	add	a4,a4,a5
    136e:	02e68263          	beq	a3,a4,1392 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1372:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1374:	00001717          	auipc	a4,0x1
    1378:	c8f73e23          	sd	a5,-868(a4) # 2010 <freep>
}
    137c:	60a2                	ld	ra,8(sp)
    137e:	6402                	ld	s0,0(sp)
    1380:	0141                	addi	sp,sp,16
    1382:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1384:	4618                	lw	a4,8(a2)
    1386:	9f2d                	addw	a4,a4,a1
    1388:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    138c:	6398                	ld	a4,0(a5)
    138e:	6310                	ld	a2,0(a4)
    1390:	b7f9                	j	135e <free+0x44>
    p->s.size += bp->s.size;
    1392:	ff852703          	lw	a4,-8(a0)
    1396:	9f31                	addw	a4,a4,a2
    1398:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    139a:	ff053683          	ld	a3,-16(a0)
    139e:	bfd1                	j	1372 <free+0x58>

00000000000013a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    13a0:	7139                	addi	sp,sp,-64
    13a2:	fc06                	sd	ra,56(sp)
    13a4:	f822                	sd	s0,48(sp)
    13a6:	f04a                	sd	s2,32(sp)
    13a8:	ec4e                	sd	s3,24(sp)
    13aa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13ac:	02051993          	slli	s3,a0,0x20
    13b0:	0209d993          	srli	s3,s3,0x20
    13b4:	09bd                	addi	s3,s3,15
    13b6:	0049d993          	srli	s3,s3,0x4
    13ba:	2985                	addiw	s3,s3,1
    13bc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    13be:	00001517          	auipc	a0,0x1
    13c2:	c5253503          	ld	a0,-942(a0) # 2010 <freep>
    13c6:	c905                	beqz	a0,13f6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13ca:	4798                	lw	a4,8(a5)
    13cc:	09377a63          	bgeu	a4,s3,1460 <malloc+0xc0>
    13d0:	f426                	sd	s1,40(sp)
    13d2:	e852                	sd	s4,16(sp)
    13d4:	e456                	sd	s5,8(sp)
    13d6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    13d8:	8a4e                	mv	s4,s3
    13da:	6705                	lui	a4,0x1
    13dc:	00e9f363          	bgeu	s3,a4,13e2 <malloc+0x42>
    13e0:	6a05                	lui	s4,0x1
    13e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    13e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    13ea:	00001497          	auipc	s1,0x1
    13ee:	c2648493          	addi	s1,s1,-986 # 2010 <freep>
  if(p == (char*)-1)
    13f2:	5afd                	li	s5,-1
    13f4:	a089                	j	1436 <malloc+0x96>
    13f6:	f426                	sd	s1,40(sp)
    13f8:	e852                	sd	s4,16(sp)
    13fa:	e456                	sd	s5,8(sp)
    13fc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    13fe:	00001797          	auipc	a5,0x1
    1402:	c9a78793          	addi	a5,a5,-870 # 2098 <base>
    1406:	00001717          	auipc	a4,0x1
    140a:	c0f73523          	sd	a5,-1014(a4) # 2010 <freep>
    140e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1410:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1414:	b7d1                	j	13d8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1416:	6398                	ld	a4,0(a5)
    1418:	e118                	sd	a4,0(a0)
    141a:	a8b9                	j	1478 <malloc+0xd8>
  hp->s.size = nu;
    141c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1420:	0541                	addi	a0,a0,16
    1422:	00000097          	auipc	ra,0x0
    1426:	ef8080e7          	jalr	-264(ra) # 131a <free>
  return freep;
    142a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    142c:	c135                	beqz	a0,1490 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    142e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1430:	4798                	lw	a4,8(a5)
    1432:	03277363          	bgeu	a4,s2,1458 <malloc+0xb8>
    if(p == freep)
    1436:	6098                	ld	a4,0(s1)
    1438:	853e                	mv	a0,a5
    143a:	fef71ae3          	bne	a4,a5,142e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    143e:	8552                	mv	a0,s4
    1440:	00000097          	auipc	ra,0x0
    1444:	ba6080e7          	jalr	-1114(ra) # fe6 <sbrk>
  if(p == (char*)-1)
    1448:	fd551ae3          	bne	a0,s5,141c <malloc+0x7c>
        return 0;
    144c:	4501                	li	a0,0
    144e:	74a2                	ld	s1,40(sp)
    1450:	6a42                	ld	s4,16(sp)
    1452:	6aa2                	ld	s5,8(sp)
    1454:	6b02                	ld	s6,0(sp)
    1456:	a03d                	j	1484 <malloc+0xe4>
    1458:	74a2                	ld	s1,40(sp)
    145a:	6a42                	ld	s4,16(sp)
    145c:	6aa2                	ld	s5,8(sp)
    145e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1460:	fae90be3          	beq	s2,a4,1416 <malloc+0x76>
        p->s.size -= nunits;
    1464:	4137073b          	subw	a4,a4,s3
    1468:	c798                	sw	a4,8(a5)
        p += p->s.size;
    146a:	02071693          	slli	a3,a4,0x20
    146e:	01c6d713          	srli	a4,a3,0x1c
    1472:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1474:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1478:	00001717          	auipc	a4,0x1
    147c:	b8a73c23          	sd	a0,-1128(a4) # 2010 <freep>
      return (void*)(p + 1);
    1480:	01078513          	addi	a0,a5,16
  }
}
    1484:	70e2                	ld	ra,56(sp)
    1486:	7442                	ld	s0,48(sp)
    1488:	7902                	ld	s2,32(sp)
    148a:	69e2                	ld	s3,24(sp)
    148c:	6121                	addi	sp,sp,64
    148e:	8082                	ret
    1490:	74a2                	ld	s1,40(sp)
    1492:	6a42                	ld	s4,16(sp)
    1494:	6aa2                	ld	s5,8(sp)
    1496:	6b02                	ld	s6,0(sp)
    1498:	b7f5                	j	1484 <malloc+0xe4>
