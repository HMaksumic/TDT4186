
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
      16:	42e58593          	addi	a1,a1,1070 # 1440 <malloc+0x106>
      1a:	8532                	mv	a0,a2
      1c:	00001097          	auipc	ra,0x1
      20:	ef4080e7          	jalr	-268(ra) # f10 <write>
    memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	cb4080e7          	jalr	-844(ra) # cde <memset>
    gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	cf6080e7          	jalr	-778(ra) # d2c <gets>
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
      64:	3f058593          	addi	a1,a1,1008 # 1450 <malloc+0x116>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	1e6080e7          	jalr	486(ra) # 1250 <fprintf>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	e7c080e7          	jalr	-388(ra) # ef0 <exit>

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
      88:	e64080e7          	jalr	-412(ra) # ee8 <fork>
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
      9e:	3be50513          	addi	a0,a0,958 # 1458 <malloc+0x11e>
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
      ca:	4aa70713          	addi	a4,a4,1194 # 1570 <malloc+0x236>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
        exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	e16080e7          	jalr	-490(ra) # ef0 <exit>
        panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	37e50513          	addi	a0,a0,894 # 1460 <malloc+0x126>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
        if (ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
        exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	e2e080e7          	jalr	-466(ra) # f28 <exec>
        fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	36458593          	addi	a1,a1,868 # 1468 <malloc+0x12e>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	142080e7          	jalr	322(ra) # 1250 <fprintf>
    exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	dd8080e7          	jalr	-552(ra) # ef0 <exit>
            exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	dce080e7          	jalr	-562(ra) # ef0 <exit>
        close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	dec080e7          	jalr	-532(ra) # f18 <close>
        if (open(rcmd->file, rcmd->mode) < 0)
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	df8080e7          	jalr	-520(ra) # f30 <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
        runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
            fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	32858593          	addi	a1,a1,808 # 1478 <malloc+0x13e>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	0f6080e7          	jalr	246(ra) # 1250 <fprintf>
            exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	d8c080e7          	jalr	-628(ra) # ef0 <exit>
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
     186:	d76080e7          	jalr	-650(ra) # ef8 <wait>
        runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
        if (pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	d68080e7          	jalr	-664(ra) # f00 <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
        if (fork1() == 0)
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
            close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	d68080e7          	jalr	-664(ra) # f18 <close>
            dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	dac080e7          	jalr	-596(ra) # f68 <dup>
            close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	d50080e7          	jalr	-688(ra) # f18 <close>
            close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	d44080e7          	jalr	-700(ra) # f18 <close>
            runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
            panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	2a250513          	addi	a0,a0,674 # 1488 <malloc+0x14e>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
        if (fork1() == 0)
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
            close(0);
     200:	00001097          	auipc	ra,0x1
     204:	d18080e7          	jalr	-744(ra) # f18 <close>
            dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	d5c080e7          	jalr	-676(ra) # f68 <dup>
            close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	d00080e7          	jalr	-768(ra) # f18 <close>
            close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	cf4080e7          	jalr	-780(ra) # f18 <close>
            runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
        close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	cde080e7          	jalr	-802(ra) # f18 <close>
        close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	cd2080e7          	jalr	-814(ra) # f18 <close>
        wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	ca8080e7          	jalr	-856(ra) # ef8 <wait>
        wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	c9e080e7          	jalr	-866(ra) # ef8 <wait>
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
     28c:	0b2080e7          	jalr	178(ra) # 133a <malloc>
     290:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	a46080e7          	jalr	-1466(ra) # cde <memset>
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
     2d6:	068080e7          	jalr	104(ra) # 133a <malloc>
     2da:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	9fc080e7          	jalr	-1540(ra) # cde <memset>
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
     330:	00e080e7          	jalr	14(ra) # 133a <malloc>
     334:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	9a4080e7          	jalr	-1628(ra) # cde <memset>
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
     376:	fc8080e7          	jalr	-56(ra) # 133a <malloc>
     37a:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	95e080e7          	jalr	-1698(ra) # cde <memset>
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
     3b8:	f86080e7          	jalr	-122(ra) # 133a <malloc>
     3bc:	84aa                	mv	s1,a0
    memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	91c080e7          	jalr	-1764(ra) # cde <memset>
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
     414:	8f4080e7          	jalr	-1804(ra) # d04 <strchr>
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
     47a:	88e080e7          	jalr	-1906(ra) # d04 <strchr>
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
     4e2:	826080e7          	jalr	-2010(ra) # d04 <strchr>
     4e6:	e90d                	bnez	a0,518 <gettoken+0x138>
     4e8:	0004c583          	lbu	a1,0(s1)
     4ec:	8556                	mv	a0,s5
     4ee:	00001097          	auipc	ra,0x1
     4f2:	816080e7          	jalr	-2026(ra) # d04 <strchr>
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
     554:	00000097          	auipc	ra,0x0
     558:	7b0080e7          	jalr	1968(ra) # d04 <strchr>
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
     58a:	77e080e7          	jalr	1918(ra) # d04 <strchr>
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
     5b8:	efcb0b13          	addi	s6,s6,-260 # 14b0 <malloc+0x176>
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
     5ce:	ec650513          	addi	a0,a0,-314 # 1490 <malloc+0x156>
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
     6aa:	e1260613          	addi	a2,a2,-494 # 14b8 <malloc+0x17e>
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
     6ea:	df2b0b13          	addi	s6,s6,-526 # 14d8 <malloc+0x19e>
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
     720:	da450513          	addi	a0,a0,-604 # 14c0 <malloc+0x186>
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
     77e:	d4e50513          	addi	a0,a0,-690 # 14c8 <malloc+0x18e>
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
     7ce:	d1660613          	addi	a2,a2,-746 # 14e0 <malloc+0x1a6>
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
     840:	caca0a13          	addi	s4,s4,-852 # 14e8 <malloc+0x1ae>
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
     876:	c7e60613          	addi	a2,a2,-898 # 14f0 <malloc+0x1b6>
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
     8dc:	be060613          	addi	a2,a2,-1056 # 14b8 <malloc+0x17e>
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
     90c:	c0060613          	addi	a2,a2,-1024 # 1508 <malloc+0x1ce>
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
     94e:	bae50513          	addi	a0,a0,-1106 # 14f8 <malloc+0x1be>
     952:	fffff097          	auipc	ra,0xfffff
     956:	704080e7          	jalr	1796(ra) # 56 <panic>
        panic("syntax - missing )");
     95a:	00001517          	auipc	a0,0x1
     95e:	bb650513          	addi	a0,a0,-1098 # 1510 <malloc+0x1d6>
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
     98a:	c0270713          	addi	a4,a4,-1022 # 1588 <malloc+0x24e>
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
     a1a:	29c080e7          	jalr	668(ra) # cb2 <strlen>
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
     a3a:	a1260613          	addi	a2,a2,-1518 # 1448 <malloc+0x10e>
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
     a70:	abc58593          	addi	a1,a1,-1348 # 1528 <malloc+0x1ee>
     a74:	4509                	li	a0,2
     a76:	00000097          	auipc	ra,0x0
     a7a:	7da080e7          	jalr	2010(ra) # 1250 <fprintf>
        panic("syntax");
     a7e:	00001517          	auipc	a0,0x1
     a82:	a4250513          	addi	a0,a0,-1470 # 14c0 <malloc+0x186>
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
     aca:	432080e7          	jalr	1074(ra) # ef8 <wait>
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
     af4:	1c2080e7          	jalr	450(ra) # cb2 <strlen>
     af8:	fff5079b          	addiw	a5,a0,-1
     afc:	1782                	slli	a5,a5,0x20
     afe:	9381                	srli	a5,a5,0x20
     b00:	97a6                	add	a5,a5,s1
     b02:	00078023          	sb	zero,0(a5)
        if (chdir(buf + 3) < 0)
     b06:	048d                	addi	s1,s1,3
     b08:	8526                	mv	a0,s1
     b0a:	00000097          	auipc	ra,0x0
     b0e:	456080e7          	jalr	1110(ra) # f60 <chdir>
     b12:	fa055ee3          	bgez	a0,ace <parse_buffer+0x40>
            fprintf(2, "cannot cd %s\n", buf + 3);
     b16:	8626                	mv	a2,s1
     b18:	00001597          	auipc	a1,0x1
     b1c:	a2058593          	addi	a1,a1,-1504 # 1538 <malloc+0x1fe>
     b20:	4509                	li	a0,2
     b22:	00000097          	auipc	ra,0x0
     b26:	72e080e7          	jalr	1838(ra) # 1250 <fprintf>
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
     b4a:	3aa080e7          	jalr	938(ra) # ef0 <exit>
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
     b7a:	9d290913          	addi	s2,s2,-1582 # 1548 <malloc+0x20e>
     b7e:	85a6                	mv	a1,s1
     b80:	854a                	mv	a0,s2
     b82:	00000097          	auipc	ra,0x0
     b86:	3ae080e7          	jalr	942(ra) # f30 <open>
     b8a:	00054863          	bltz	a0,b9a <main+0x3a>
        if (fd >= 3)
     b8e:	fea4d8e3          	bge	s1,a0,b7e <main+0x1e>
            close(fd);
     b92:	00000097          	auipc	ra,0x0
     b96:	386080e7          	jalr	902(ra) # f18 <close>
    if (argc == 2)
     b9a:	4789                	li	a5,2
    while (getcmd(buf, sizeof(buf)) >= 0)
     b9c:	07800913          	li	s2,120
     ba0:	00001497          	auipc	s1,0x1
     ba4:	48048493          	addi	s1,s1,1152 # 2020 <buf.0>
    if (argc == 2)
     ba8:	08f99363          	bne	s3,a5,c2e <main+0xce>
        char *shell_script_file = argv[1];
     bac:	008a3483          	ld	s1,8(s4)
        int shfd = open(shell_script_file, O_RDWR);
     bb0:	85ce                	mv	a1,s3
     bb2:	8526                	mv	a0,s1
     bb4:	00000097          	auipc	ra,0x0
     bb8:	37c080e7          	jalr	892(ra) # f30 <open>
     bbc:	89aa                	mv	s3,a0
        if (shfd < 0)
     bbe:	04054563          	bltz	a0,c08 <main+0xa8>
        read(shfd, buf, sizeof(buf));
     bc2:	07800613          	li	a2,120
     bc6:	00001597          	auipc	a1,0x1
     bca:	45a58593          	addi	a1,a1,1114 # 2020 <buf.0>
     bce:	00000097          	auipc	ra,0x0
     bd2:	33a080e7          	jalr	826(ra) # f08 <read>
            parse_buffer(buf);
     bd6:	00001917          	auipc	s2,0x1
     bda:	44a90913          	addi	s2,s2,1098 # 2020 <buf.0>
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
     bf2:	00000097          	auipc	ra,0x0
     bf6:	316080e7          	jalr	790(ra) # f08 <read>
     bfa:	fe9504e3          	beq	a0,s1,be2 <main+0x82>
        exit(0);
     bfe:	4501                	li	a0,0
     c00:	00000097          	auipc	ra,0x0
     c04:	2f0080e7          	jalr	752(ra) # ef0 <exit>
            printf("Failed to open %s\n", shell_script_file);
     c08:	85a6                	mv	a1,s1
     c0a:	00001517          	auipc	a0,0x1
     c0e:	94650513          	addi	a0,a0,-1722 # 1550 <malloc+0x216>
     c12:	00000097          	auipc	ra,0x0
     c16:	66c080e7          	jalr	1644(ra) # 127e <printf>
            exit(1);
     c1a:	4505                	li	a0,1
     c1c:	00000097          	auipc	ra,0x0
     c20:	2d4080e7          	jalr	724(ra) # ef0 <exit>
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
     c40:	00000097          	auipc	ra,0x0
     c44:	2b0080e7          	jalr	688(ra) # ef0 <exit>

0000000000000c48 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     c48:	1141                	addi	sp,sp,-16
     c4a:	e406                	sd	ra,8(sp)
     c4c:	e022                	sd	s0,0(sp)
     c4e:	0800                	addi	s0,sp,16
  extern int main();
  main();
     c50:	00000097          	auipc	ra,0x0
     c54:	f10080e7          	jalr	-240(ra) # b60 <main>
  exit(0);
     c58:	4501                	li	a0,0
     c5a:	00000097          	auipc	ra,0x0
     c5e:	296080e7          	jalr	662(ra) # ef0 <exit>

0000000000000c62 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c62:	1141                	addi	sp,sp,-16
     c64:	e406                	sd	ra,8(sp)
     c66:	e022                	sd	s0,0(sp)
     c68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c6a:	87aa                	mv	a5,a0
     c6c:	0585                	addi	a1,a1,1
     c6e:	0785                	addi	a5,a5,1
     c70:	fff5c703          	lbu	a4,-1(a1)
     c74:	fee78fa3          	sb	a4,-1(a5)
     c78:	fb75                	bnez	a4,c6c <strcpy+0xa>
    ;
  return os;
}
     c7a:	60a2                	ld	ra,8(sp)
     c7c:	6402                	ld	s0,0(sp)
     c7e:	0141                	addi	sp,sp,16
     c80:	8082                	ret

0000000000000c82 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c82:	1141                	addi	sp,sp,-16
     c84:	e406                	sd	ra,8(sp)
     c86:	e022                	sd	s0,0(sp)
     c88:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c8a:	00054783          	lbu	a5,0(a0)
     c8e:	cb91                	beqz	a5,ca2 <strcmp+0x20>
     c90:	0005c703          	lbu	a4,0(a1)
     c94:	00f71763          	bne	a4,a5,ca2 <strcmp+0x20>
    p++, q++;
     c98:	0505                	addi	a0,a0,1
     c9a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c9c:	00054783          	lbu	a5,0(a0)
     ca0:	fbe5                	bnez	a5,c90 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     ca2:	0005c503          	lbu	a0,0(a1)
}
     ca6:	40a7853b          	subw	a0,a5,a0
     caa:	60a2                	ld	ra,8(sp)
     cac:	6402                	ld	s0,0(sp)
     cae:	0141                	addi	sp,sp,16
     cb0:	8082                	ret

0000000000000cb2 <strlen>:

uint
strlen(const char *s)
{
     cb2:	1141                	addi	sp,sp,-16
     cb4:	e406                	sd	ra,8(sp)
     cb6:	e022                	sd	s0,0(sp)
     cb8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     cba:	00054783          	lbu	a5,0(a0)
     cbe:	cf91                	beqz	a5,cda <strlen+0x28>
     cc0:	00150793          	addi	a5,a0,1
     cc4:	86be                	mv	a3,a5
     cc6:	0785                	addi	a5,a5,1
     cc8:	fff7c703          	lbu	a4,-1(a5)
     ccc:	ff65                	bnez	a4,cc4 <strlen+0x12>
     cce:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     cd2:	60a2                	ld	ra,8(sp)
     cd4:	6402                	ld	s0,0(sp)
     cd6:	0141                	addi	sp,sp,16
     cd8:	8082                	ret
  for(n = 0; s[n]; n++)
     cda:	4501                	li	a0,0
     cdc:	bfdd                	j	cd2 <strlen+0x20>

0000000000000cde <memset>:

void*
memset(void *dst, int c, uint n)
{
     cde:	1141                	addi	sp,sp,-16
     ce0:	e406                	sd	ra,8(sp)
     ce2:	e022                	sd	s0,0(sp)
     ce4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     ce6:	ca19                	beqz	a2,cfc <memset+0x1e>
     ce8:	87aa                	mv	a5,a0
     cea:	1602                	slli	a2,a2,0x20
     cec:	9201                	srli	a2,a2,0x20
     cee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     cf2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     cf6:	0785                	addi	a5,a5,1
     cf8:	fee79de3          	bne	a5,a4,cf2 <memset+0x14>
  }
  return dst;
}
     cfc:	60a2                	ld	ra,8(sp)
     cfe:	6402                	ld	s0,0(sp)
     d00:	0141                	addi	sp,sp,16
     d02:	8082                	ret

0000000000000d04 <strchr>:

char*
strchr(const char *s, char c)
{
     d04:	1141                	addi	sp,sp,-16
     d06:	e406                	sd	ra,8(sp)
     d08:	e022                	sd	s0,0(sp)
     d0a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d0c:	00054783          	lbu	a5,0(a0)
     d10:	cf81                	beqz	a5,d28 <strchr+0x24>
    if(*s == c)
     d12:	00f58763          	beq	a1,a5,d20 <strchr+0x1c>
  for(; *s; s++)
     d16:	0505                	addi	a0,a0,1
     d18:	00054783          	lbu	a5,0(a0)
     d1c:	fbfd                	bnez	a5,d12 <strchr+0xe>
      return (char*)s;
  return 0;
     d1e:	4501                	li	a0,0
}
     d20:	60a2                	ld	ra,8(sp)
     d22:	6402                	ld	s0,0(sp)
     d24:	0141                	addi	sp,sp,16
     d26:	8082                	ret
  return 0;
     d28:	4501                	li	a0,0
     d2a:	bfdd                	j	d20 <strchr+0x1c>

0000000000000d2c <gets>:

char*
gets(char *buf, int max)
{
     d2c:	711d                	addi	sp,sp,-96
     d2e:	ec86                	sd	ra,88(sp)
     d30:	e8a2                	sd	s0,80(sp)
     d32:	e4a6                	sd	s1,72(sp)
     d34:	e0ca                	sd	s2,64(sp)
     d36:	fc4e                	sd	s3,56(sp)
     d38:	f852                	sd	s4,48(sp)
     d3a:	f456                	sd	s5,40(sp)
     d3c:	f05a                	sd	s6,32(sp)
     d3e:	ec5e                	sd	s7,24(sp)
     d40:	e862                	sd	s8,16(sp)
     d42:	1080                	addi	s0,sp,96
     d44:	8baa                	mv	s7,a0
     d46:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d48:	892a                	mv	s2,a0
     d4a:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d4c:	faf40b13          	addi	s6,s0,-81
     d50:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     d52:	8c26                	mv	s8,s1
     d54:	0014899b          	addiw	s3,s1,1
     d58:	84ce                	mv	s1,s3
     d5a:	0349d663          	bge	s3,s4,d86 <gets+0x5a>
    cc = read(0, &c, 1);
     d5e:	8656                	mv	a2,s5
     d60:	85da                	mv	a1,s6
     d62:	4501                	li	a0,0
     d64:	00000097          	auipc	ra,0x0
     d68:	1a4080e7          	jalr	420(ra) # f08 <read>
    if(cc < 1)
     d6c:	00a05d63          	blez	a0,d86 <gets+0x5a>
      break;
    buf[i++] = c;
     d70:	faf44783          	lbu	a5,-81(s0)
     d74:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d78:	0905                	addi	s2,s2,1
     d7a:	ff678713          	addi	a4,a5,-10
     d7e:	c319                	beqz	a4,d84 <gets+0x58>
     d80:	17cd                	addi	a5,a5,-13
     d82:	fbe1                	bnez	a5,d52 <gets+0x26>
    buf[i++] = c;
     d84:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     d86:	9c5e                	add	s8,s8,s7
     d88:	000c0023          	sb	zero,0(s8)
  return buf;
}
     d8c:	855e                	mv	a0,s7
     d8e:	60e6                	ld	ra,88(sp)
     d90:	6446                	ld	s0,80(sp)
     d92:	64a6                	ld	s1,72(sp)
     d94:	6906                	ld	s2,64(sp)
     d96:	79e2                	ld	s3,56(sp)
     d98:	7a42                	ld	s4,48(sp)
     d9a:	7aa2                	ld	s5,40(sp)
     d9c:	7b02                	ld	s6,32(sp)
     d9e:	6be2                	ld	s7,24(sp)
     da0:	6c42                	ld	s8,16(sp)
     da2:	6125                	addi	sp,sp,96
     da4:	8082                	ret

0000000000000da6 <stat>:

int
stat(const char *n, struct stat *st)
{
     da6:	1101                	addi	sp,sp,-32
     da8:	ec06                	sd	ra,24(sp)
     daa:	e822                	sd	s0,16(sp)
     dac:	e04a                	sd	s2,0(sp)
     dae:	1000                	addi	s0,sp,32
     db0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     db2:	4581                	li	a1,0
     db4:	00000097          	auipc	ra,0x0
     db8:	17c080e7          	jalr	380(ra) # f30 <open>
  if(fd < 0)
     dbc:	02054663          	bltz	a0,de8 <stat+0x42>
     dc0:	e426                	sd	s1,8(sp)
     dc2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     dc4:	85ca                	mv	a1,s2
     dc6:	00000097          	auipc	ra,0x0
     dca:	182080e7          	jalr	386(ra) # f48 <fstat>
     dce:	892a                	mv	s2,a0
  close(fd);
     dd0:	8526                	mv	a0,s1
     dd2:	00000097          	auipc	ra,0x0
     dd6:	146080e7          	jalr	326(ra) # f18 <close>
  return r;
     dda:	64a2                	ld	s1,8(sp)
}
     ddc:	854a                	mv	a0,s2
     dde:	60e2                	ld	ra,24(sp)
     de0:	6442                	ld	s0,16(sp)
     de2:	6902                	ld	s2,0(sp)
     de4:	6105                	addi	sp,sp,32
     de6:	8082                	ret
    return -1;
     de8:	57fd                	li	a5,-1
     dea:	893e                	mv	s2,a5
     dec:	bfc5                	j	ddc <stat+0x36>

0000000000000dee <atoi>:

int
atoi(const char *s)
{
     dee:	1141                	addi	sp,sp,-16
     df0:	e406                	sd	ra,8(sp)
     df2:	e022                	sd	s0,0(sp)
     df4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     df6:	00054683          	lbu	a3,0(a0)
     dfa:	fd06879b          	addiw	a5,a3,-48
     dfe:	0ff7f793          	zext.b	a5,a5
     e02:	4625                	li	a2,9
     e04:	02f66963          	bltu	a2,a5,e36 <atoi+0x48>
     e08:	872a                	mv	a4,a0
  n = 0;
     e0a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e0c:	0705                	addi	a4,a4,1
     e0e:	0025179b          	slliw	a5,a0,0x2
     e12:	9fa9                	addw	a5,a5,a0
     e14:	0017979b          	slliw	a5,a5,0x1
     e18:	9fb5                	addw	a5,a5,a3
     e1a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e1e:	00074683          	lbu	a3,0(a4)
     e22:	fd06879b          	addiw	a5,a3,-48
     e26:	0ff7f793          	zext.b	a5,a5
     e2a:	fef671e3          	bgeu	a2,a5,e0c <atoi+0x1e>
  return n;
}
     e2e:	60a2                	ld	ra,8(sp)
     e30:	6402                	ld	s0,0(sp)
     e32:	0141                	addi	sp,sp,16
     e34:	8082                	ret
  n = 0;
     e36:	4501                	li	a0,0
     e38:	bfdd                	j	e2e <atoi+0x40>

0000000000000e3a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e3a:	1141                	addi	sp,sp,-16
     e3c:	e406                	sd	ra,8(sp)
     e3e:	e022                	sd	s0,0(sp)
     e40:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e42:	02b57563          	bgeu	a0,a1,e6c <memmove+0x32>
    while(n-- > 0)
     e46:	00c05f63          	blez	a2,e64 <memmove+0x2a>
     e4a:	1602                	slli	a2,a2,0x20
     e4c:	9201                	srli	a2,a2,0x20
     e4e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e52:	872a                	mv	a4,a0
      *dst++ = *src++;
     e54:	0585                	addi	a1,a1,1
     e56:	0705                	addi	a4,a4,1
     e58:	fff5c683          	lbu	a3,-1(a1)
     e5c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e60:	fee79ae3          	bne	a5,a4,e54 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e64:	60a2                	ld	ra,8(sp)
     e66:	6402                	ld	s0,0(sp)
     e68:	0141                	addi	sp,sp,16
     e6a:	8082                	ret
    while(n-- > 0)
     e6c:	fec05ce3          	blez	a2,e64 <memmove+0x2a>
    dst += n;
     e70:	00c50733          	add	a4,a0,a2
    src += n;
     e74:	95b2                	add	a1,a1,a2
     e76:	fff6079b          	addiw	a5,a2,-1
     e7a:	1782                	slli	a5,a5,0x20
     e7c:	9381                	srli	a5,a5,0x20
     e7e:	fff7c793          	not	a5,a5
     e82:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e84:	15fd                	addi	a1,a1,-1
     e86:	177d                	addi	a4,a4,-1
     e88:	0005c683          	lbu	a3,0(a1)
     e8c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e90:	fef71ae3          	bne	a4,a5,e84 <memmove+0x4a>
     e94:	bfc1                	j	e64 <memmove+0x2a>

0000000000000e96 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e96:	1141                	addi	sp,sp,-16
     e98:	e406                	sd	ra,8(sp)
     e9a:	e022                	sd	s0,0(sp)
     e9c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e9e:	c61d                	beqz	a2,ecc <memcmp+0x36>
     ea0:	1602                	slli	a2,a2,0x20
     ea2:	9201                	srli	a2,a2,0x20
     ea4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     ea8:	00054783          	lbu	a5,0(a0)
     eac:	0005c703          	lbu	a4,0(a1)
     eb0:	00e79863          	bne	a5,a4,ec0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     eb4:	0505                	addi	a0,a0,1
    p2++;
     eb6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     eb8:	fed518e3          	bne	a0,a3,ea8 <memcmp+0x12>
  }
  return 0;
     ebc:	4501                	li	a0,0
     ebe:	a019                	j	ec4 <memcmp+0x2e>
      return *p1 - *p2;
     ec0:	40e7853b          	subw	a0,a5,a4
}
     ec4:	60a2                	ld	ra,8(sp)
     ec6:	6402                	ld	s0,0(sp)
     ec8:	0141                	addi	sp,sp,16
     eca:	8082                	ret
  return 0;
     ecc:	4501                	li	a0,0
     ece:	bfdd                	j	ec4 <memcmp+0x2e>

0000000000000ed0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ed0:	1141                	addi	sp,sp,-16
     ed2:	e406                	sd	ra,8(sp)
     ed4:	e022                	sd	s0,0(sp)
     ed6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ed8:	00000097          	auipc	ra,0x0
     edc:	f62080e7          	jalr	-158(ra) # e3a <memmove>
}
     ee0:	60a2                	ld	ra,8(sp)
     ee2:	6402                	ld	s0,0(sp)
     ee4:	0141                	addi	sp,sp,16
     ee6:	8082                	ret

0000000000000ee8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ee8:	4885                	li	a7,1
 ecall
     eea:	00000073          	ecall
 ret
     eee:	8082                	ret

0000000000000ef0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ef0:	4889                	li	a7,2
 ecall
     ef2:	00000073          	ecall
 ret
     ef6:	8082                	ret

0000000000000ef8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ef8:	488d                	li	a7,3
 ecall
     efa:	00000073          	ecall
 ret
     efe:	8082                	ret

0000000000000f00 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f00:	4891                	li	a7,4
 ecall
     f02:	00000073          	ecall
 ret
     f06:	8082                	ret

0000000000000f08 <read>:
.global read
read:
 li a7, SYS_read
     f08:	4895                	li	a7,5
 ecall
     f0a:	00000073          	ecall
 ret
     f0e:	8082                	ret

0000000000000f10 <write>:
.global write
write:
 li a7, SYS_write
     f10:	48c1                	li	a7,16
 ecall
     f12:	00000073          	ecall
 ret
     f16:	8082                	ret

0000000000000f18 <close>:
.global close
close:
 li a7, SYS_close
     f18:	48d5                	li	a7,21
 ecall
     f1a:	00000073          	ecall
 ret
     f1e:	8082                	ret

0000000000000f20 <kill>:
.global kill
kill:
 li a7, SYS_kill
     f20:	4899                	li	a7,6
 ecall
     f22:	00000073          	ecall
 ret
     f26:	8082                	ret

0000000000000f28 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f28:	489d                	li	a7,7
 ecall
     f2a:	00000073          	ecall
 ret
     f2e:	8082                	ret

0000000000000f30 <open>:
.global open
open:
 li a7, SYS_open
     f30:	48bd                	li	a7,15
 ecall
     f32:	00000073          	ecall
 ret
     f36:	8082                	ret

0000000000000f38 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f38:	48c5                	li	a7,17
 ecall
     f3a:	00000073          	ecall
 ret
     f3e:	8082                	ret

0000000000000f40 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f40:	48c9                	li	a7,18
 ecall
     f42:	00000073          	ecall
 ret
     f46:	8082                	ret

0000000000000f48 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f48:	48a1                	li	a7,8
 ecall
     f4a:	00000073          	ecall
 ret
     f4e:	8082                	ret

0000000000000f50 <link>:
.global link
link:
 li a7, SYS_link
     f50:	48cd                	li	a7,19
 ecall
     f52:	00000073          	ecall
 ret
     f56:	8082                	ret

0000000000000f58 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f58:	48d1                	li	a7,20
 ecall
     f5a:	00000073          	ecall
 ret
     f5e:	8082                	ret

0000000000000f60 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f60:	48a5                	li	a7,9
 ecall
     f62:	00000073          	ecall
 ret
     f66:	8082                	ret

0000000000000f68 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f68:	48a9                	li	a7,10
 ecall
     f6a:	00000073          	ecall
 ret
     f6e:	8082                	ret

0000000000000f70 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f70:	48ad                	li	a7,11
 ecall
     f72:	00000073          	ecall
 ret
     f76:	8082                	ret

0000000000000f78 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f78:	48b1                	li	a7,12
 ecall
     f7a:	00000073          	ecall
 ret
     f7e:	8082                	ret

0000000000000f80 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f80:	48b5                	li	a7,13
 ecall
     f82:	00000073          	ecall
 ret
     f86:	8082                	ret

0000000000000f88 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f88:	48b9                	li	a7,14
 ecall
     f8a:	00000073          	ecall
 ret
     f8e:	8082                	ret

0000000000000f90 <ps>:
.global ps
ps:
 li a7, SYS_ps
     f90:	48d9                	li	a7,22
 ecall
     f92:	00000073          	ecall
 ret
     f96:	8082                	ret

0000000000000f98 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     f98:	48dd                	li	a7,23
 ecall
     f9a:	00000073          	ecall
 ret
     f9e:	8082                	ret

0000000000000fa0 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     fa0:	48e1                	li	a7,24
 ecall
     fa2:	00000073          	ecall
 ret
     fa6:	8082                	ret

0000000000000fa8 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
     fa8:	48e9                	li	a7,26
 ecall
     faa:	00000073          	ecall
 ret
     fae:	8082                	ret

0000000000000fb0 <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
     fb0:	48e5                	li	a7,25
 ecall
     fb2:	00000073          	ecall
 ret
     fb6:	8082                	ret

0000000000000fb8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     fb8:	1101                	addi	sp,sp,-32
     fba:	ec06                	sd	ra,24(sp)
     fbc:	e822                	sd	s0,16(sp)
     fbe:	1000                	addi	s0,sp,32
     fc0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     fc4:	4605                	li	a2,1
     fc6:	fef40593          	addi	a1,s0,-17
     fca:	00000097          	auipc	ra,0x0
     fce:	f46080e7          	jalr	-186(ra) # f10 <write>
}
     fd2:	60e2                	ld	ra,24(sp)
     fd4:	6442                	ld	s0,16(sp)
     fd6:	6105                	addi	sp,sp,32
     fd8:	8082                	ret

0000000000000fda <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     fda:	7139                	addi	sp,sp,-64
     fdc:	fc06                	sd	ra,56(sp)
     fde:	f822                	sd	s0,48(sp)
     fe0:	f04a                	sd	s2,32(sp)
     fe2:	ec4e                	sd	s3,24(sp)
     fe4:	0080                	addi	s0,sp,64
     fe6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     fe8:	cad9                	beqz	a3,107e <printint+0xa4>
     fea:	01f5d79b          	srliw	a5,a1,0x1f
     fee:	cbc1                	beqz	a5,107e <printint+0xa4>
    neg = 1;
    x = -xx;
     ff0:	40b005bb          	negw	a1,a1
    neg = 1;
     ff4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     ff6:	fc040993          	addi	s3,s0,-64
  neg = 0;
     ffa:	86ce                	mv	a3,s3
  i = 0;
     ffc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ffe:	00000817          	auipc	a6,0x0
    1002:	5fa80813          	addi	a6,a6,1530 # 15f8 <digits>
    1006:	88ba                	mv	a7,a4
    1008:	0017051b          	addiw	a0,a4,1
    100c:	872a                	mv	a4,a0
    100e:	02c5f7bb          	remuw	a5,a1,a2
    1012:	1782                	slli	a5,a5,0x20
    1014:	9381                	srli	a5,a5,0x20
    1016:	97c2                	add	a5,a5,a6
    1018:	0007c783          	lbu	a5,0(a5)
    101c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1020:	87ae                	mv	a5,a1
    1022:	02c5d5bb          	divuw	a1,a1,a2
    1026:	0685                	addi	a3,a3,1
    1028:	fcc7ffe3          	bgeu	a5,a2,1006 <printint+0x2c>
  if(neg)
    102c:	00030c63          	beqz	t1,1044 <printint+0x6a>
    buf[i++] = '-';
    1030:	fd050793          	addi	a5,a0,-48
    1034:	00878533          	add	a0,a5,s0
    1038:	02d00793          	li	a5,45
    103c:	fef50823          	sb	a5,-16(a0)
    1040:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    1044:	02e05763          	blez	a4,1072 <printint+0x98>
    1048:	f426                	sd	s1,40(sp)
    104a:	377d                	addiw	a4,a4,-1
    104c:	00e984b3          	add	s1,s3,a4
    1050:	19fd                	addi	s3,s3,-1
    1052:	99ba                	add	s3,s3,a4
    1054:	1702                	slli	a4,a4,0x20
    1056:	9301                	srli	a4,a4,0x20
    1058:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    105c:	0004c583          	lbu	a1,0(s1)
    1060:	854a                	mv	a0,s2
    1062:	00000097          	auipc	ra,0x0
    1066:	f56080e7          	jalr	-170(ra) # fb8 <putc>
  while(--i >= 0)
    106a:	14fd                	addi	s1,s1,-1
    106c:	ff3498e3          	bne	s1,s3,105c <printint+0x82>
    1070:	74a2                	ld	s1,40(sp)
}
    1072:	70e2                	ld	ra,56(sp)
    1074:	7442                	ld	s0,48(sp)
    1076:	7902                	ld	s2,32(sp)
    1078:	69e2                	ld	s3,24(sp)
    107a:	6121                	addi	sp,sp,64
    107c:	8082                	ret
  neg = 0;
    107e:	4301                	li	t1,0
    1080:	bf9d                	j	ff6 <printint+0x1c>

0000000000001082 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1082:	715d                	addi	sp,sp,-80
    1084:	e486                	sd	ra,72(sp)
    1086:	e0a2                	sd	s0,64(sp)
    1088:	f84a                	sd	s2,48(sp)
    108a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    108c:	0005c903          	lbu	s2,0(a1)
    1090:	1a090b63          	beqz	s2,1246 <vprintf+0x1c4>
    1094:	fc26                	sd	s1,56(sp)
    1096:	f44e                	sd	s3,40(sp)
    1098:	f052                	sd	s4,32(sp)
    109a:	ec56                	sd	s5,24(sp)
    109c:	e85a                	sd	s6,16(sp)
    109e:	e45e                	sd	s7,8(sp)
    10a0:	8aaa                	mv	s5,a0
    10a2:	8bb2                	mv	s7,a2
    10a4:	00158493          	addi	s1,a1,1
  state = 0;
    10a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    10aa:	02500a13          	li	s4,37
    10ae:	4b55                	li	s6,21
    10b0:	a839                	j	10ce <vprintf+0x4c>
        putc(fd, c);
    10b2:	85ca                	mv	a1,s2
    10b4:	8556                	mv	a0,s5
    10b6:	00000097          	auipc	ra,0x0
    10ba:	f02080e7          	jalr	-254(ra) # fb8 <putc>
    10be:	a019                	j	10c4 <vprintf+0x42>
    } else if(state == '%'){
    10c0:	01498d63          	beq	s3,s4,10da <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    10c4:	0485                	addi	s1,s1,1
    10c6:	fff4c903          	lbu	s2,-1(s1)
    10ca:	16090863          	beqz	s2,123a <vprintf+0x1b8>
    if(state == 0){
    10ce:	fe0999e3          	bnez	s3,10c0 <vprintf+0x3e>
      if(c == '%'){
    10d2:	ff4910e3          	bne	s2,s4,10b2 <vprintf+0x30>
        state = '%';
    10d6:	89d2                	mv	s3,s4
    10d8:	b7f5                	j	10c4 <vprintf+0x42>
      if(c == 'd'){
    10da:	13490563          	beq	s2,s4,1204 <vprintf+0x182>
    10de:	f9d9079b          	addiw	a5,s2,-99
    10e2:	0ff7f793          	zext.b	a5,a5
    10e6:	12fb6863          	bltu	s6,a5,1216 <vprintf+0x194>
    10ea:	f9d9079b          	addiw	a5,s2,-99
    10ee:	0ff7f713          	zext.b	a4,a5
    10f2:	12eb6263          	bltu	s6,a4,1216 <vprintf+0x194>
    10f6:	00271793          	slli	a5,a4,0x2
    10fa:	00000717          	auipc	a4,0x0
    10fe:	4a670713          	addi	a4,a4,1190 # 15a0 <malloc+0x266>
    1102:	97ba                	add	a5,a5,a4
    1104:	439c                	lw	a5,0(a5)
    1106:	97ba                	add	a5,a5,a4
    1108:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    110a:	008b8913          	addi	s2,s7,8
    110e:	4685                	li	a3,1
    1110:	4629                	li	a2,10
    1112:	000ba583          	lw	a1,0(s7)
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	ec2080e7          	jalr	-318(ra) # fda <printint>
    1120:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1122:	4981                	li	s3,0
    1124:	b745                	j	10c4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1126:	008b8913          	addi	s2,s7,8
    112a:	4681                	li	a3,0
    112c:	4629                	li	a2,10
    112e:	000ba583          	lw	a1,0(s7)
    1132:	8556                	mv	a0,s5
    1134:	00000097          	auipc	ra,0x0
    1138:	ea6080e7          	jalr	-346(ra) # fda <printint>
    113c:	8bca                	mv	s7,s2
      state = 0;
    113e:	4981                	li	s3,0
    1140:	b751                	j	10c4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1142:	008b8913          	addi	s2,s7,8
    1146:	4681                	li	a3,0
    1148:	4641                	li	a2,16
    114a:	000ba583          	lw	a1,0(s7)
    114e:	8556                	mv	a0,s5
    1150:	00000097          	auipc	ra,0x0
    1154:	e8a080e7          	jalr	-374(ra) # fda <printint>
    1158:	8bca                	mv	s7,s2
      state = 0;
    115a:	4981                	li	s3,0
    115c:	b7a5                	j	10c4 <vprintf+0x42>
    115e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1160:	008b8793          	addi	a5,s7,8
    1164:	8c3e                	mv	s8,a5
    1166:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    116a:	03000593          	li	a1,48
    116e:	8556                	mv	a0,s5
    1170:	00000097          	auipc	ra,0x0
    1174:	e48080e7          	jalr	-440(ra) # fb8 <putc>
  putc(fd, 'x');
    1178:	07800593          	li	a1,120
    117c:	8556                	mv	a0,s5
    117e:	00000097          	auipc	ra,0x0
    1182:	e3a080e7          	jalr	-454(ra) # fb8 <putc>
    1186:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1188:	00000b97          	auipc	s7,0x0
    118c:	470b8b93          	addi	s7,s7,1136 # 15f8 <digits>
    1190:	03c9d793          	srli	a5,s3,0x3c
    1194:	97de                	add	a5,a5,s7
    1196:	0007c583          	lbu	a1,0(a5)
    119a:	8556                	mv	a0,s5
    119c:	00000097          	auipc	ra,0x0
    11a0:	e1c080e7          	jalr	-484(ra) # fb8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11a4:	0992                	slli	s3,s3,0x4
    11a6:	397d                	addiw	s2,s2,-1
    11a8:	fe0914e3          	bnez	s2,1190 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    11ac:	8be2                	mv	s7,s8
      state = 0;
    11ae:	4981                	li	s3,0
    11b0:	6c02                	ld	s8,0(sp)
    11b2:	bf09                	j	10c4 <vprintf+0x42>
        s = va_arg(ap, char*);
    11b4:	008b8993          	addi	s3,s7,8
    11b8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    11bc:	02090163          	beqz	s2,11de <vprintf+0x15c>
        while(*s != 0){
    11c0:	00094583          	lbu	a1,0(s2)
    11c4:	c9a5                	beqz	a1,1234 <vprintf+0x1b2>
          putc(fd, *s);
    11c6:	8556                	mv	a0,s5
    11c8:	00000097          	auipc	ra,0x0
    11cc:	df0080e7          	jalr	-528(ra) # fb8 <putc>
          s++;
    11d0:	0905                	addi	s2,s2,1
        while(*s != 0){
    11d2:	00094583          	lbu	a1,0(s2)
    11d6:	f9e5                	bnez	a1,11c6 <vprintf+0x144>
        s = va_arg(ap, char*);
    11d8:	8bce                	mv	s7,s3
      state = 0;
    11da:	4981                	li	s3,0
    11dc:	b5e5                	j	10c4 <vprintf+0x42>
          s = "(null)";
    11de:	00000917          	auipc	s2,0x0
    11e2:	38a90913          	addi	s2,s2,906 # 1568 <malloc+0x22e>
        while(*s != 0){
    11e6:	02800593          	li	a1,40
    11ea:	bff1                	j	11c6 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    11ec:	008b8913          	addi	s2,s7,8
    11f0:	000bc583          	lbu	a1,0(s7)
    11f4:	8556                	mv	a0,s5
    11f6:	00000097          	auipc	ra,0x0
    11fa:	dc2080e7          	jalr	-574(ra) # fb8 <putc>
    11fe:	8bca                	mv	s7,s2
      state = 0;
    1200:	4981                	li	s3,0
    1202:	b5c9                	j	10c4 <vprintf+0x42>
        putc(fd, c);
    1204:	02500593          	li	a1,37
    1208:	8556                	mv	a0,s5
    120a:	00000097          	auipc	ra,0x0
    120e:	dae080e7          	jalr	-594(ra) # fb8 <putc>
      state = 0;
    1212:	4981                	li	s3,0
    1214:	bd45                	j	10c4 <vprintf+0x42>
        putc(fd, '%');
    1216:	02500593          	li	a1,37
    121a:	8556                	mv	a0,s5
    121c:	00000097          	auipc	ra,0x0
    1220:	d9c080e7          	jalr	-612(ra) # fb8 <putc>
        putc(fd, c);
    1224:	85ca                	mv	a1,s2
    1226:	8556                	mv	a0,s5
    1228:	00000097          	auipc	ra,0x0
    122c:	d90080e7          	jalr	-624(ra) # fb8 <putc>
      state = 0;
    1230:	4981                	li	s3,0
    1232:	bd49                	j	10c4 <vprintf+0x42>
        s = va_arg(ap, char*);
    1234:	8bce                	mv	s7,s3
      state = 0;
    1236:	4981                	li	s3,0
    1238:	b571                	j	10c4 <vprintf+0x42>
    123a:	74e2                	ld	s1,56(sp)
    123c:	79a2                	ld	s3,40(sp)
    123e:	7a02                	ld	s4,32(sp)
    1240:	6ae2                	ld	s5,24(sp)
    1242:	6b42                	ld	s6,16(sp)
    1244:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1246:	60a6                	ld	ra,72(sp)
    1248:	6406                	ld	s0,64(sp)
    124a:	7942                	ld	s2,48(sp)
    124c:	6161                	addi	sp,sp,80
    124e:	8082                	ret

0000000000001250 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1250:	715d                	addi	sp,sp,-80
    1252:	ec06                	sd	ra,24(sp)
    1254:	e822                	sd	s0,16(sp)
    1256:	1000                	addi	s0,sp,32
    1258:	e010                	sd	a2,0(s0)
    125a:	e414                	sd	a3,8(s0)
    125c:	e818                	sd	a4,16(s0)
    125e:	ec1c                	sd	a5,24(s0)
    1260:	03043023          	sd	a6,32(s0)
    1264:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1268:	8622                	mv	a2,s0
    126a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    126e:	00000097          	auipc	ra,0x0
    1272:	e14080e7          	jalr	-492(ra) # 1082 <vprintf>
}
    1276:	60e2                	ld	ra,24(sp)
    1278:	6442                	ld	s0,16(sp)
    127a:	6161                	addi	sp,sp,80
    127c:	8082                	ret

000000000000127e <printf>:

void
printf(const char *fmt, ...)
{
    127e:	711d                	addi	sp,sp,-96
    1280:	ec06                	sd	ra,24(sp)
    1282:	e822                	sd	s0,16(sp)
    1284:	1000                	addi	s0,sp,32
    1286:	e40c                	sd	a1,8(s0)
    1288:	e810                	sd	a2,16(s0)
    128a:	ec14                	sd	a3,24(s0)
    128c:	f018                	sd	a4,32(s0)
    128e:	f41c                	sd	a5,40(s0)
    1290:	03043823          	sd	a6,48(s0)
    1294:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1298:	00840613          	addi	a2,s0,8
    129c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    12a0:	85aa                	mv	a1,a0
    12a2:	4505                	li	a0,1
    12a4:	00000097          	auipc	ra,0x0
    12a8:	dde080e7          	jalr	-546(ra) # 1082 <vprintf>
}
    12ac:	60e2                	ld	ra,24(sp)
    12ae:	6442                	ld	s0,16(sp)
    12b0:	6125                	addi	sp,sp,96
    12b2:	8082                	ret

00000000000012b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12b4:	1141                	addi	sp,sp,-16
    12b6:	e406                	sd	ra,8(sp)
    12b8:	e022                	sd	s0,0(sp)
    12ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12bc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12c0:	00001797          	auipc	a5,0x1
    12c4:	d507b783          	ld	a5,-688(a5) # 2010 <freep>
    12c8:	a039                	j	12d6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12ca:	6398                	ld	a4,0(a5)
    12cc:	00e7e463          	bltu	a5,a4,12d4 <free+0x20>
    12d0:	00e6ea63          	bltu	a3,a4,12e4 <free+0x30>
{
    12d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12d6:	fed7fae3          	bgeu	a5,a3,12ca <free+0x16>
    12da:	6398                	ld	a4,0(a5)
    12dc:	00e6e463          	bltu	a3,a4,12e4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12e0:	fee7eae3          	bltu	a5,a4,12d4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    12e4:	ff852583          	lw	a1,-8(a0)
    12e8:	6390                	ld	a2,0(a5)
    12ea:	02059813          	slli	a6,a1,0x20
    12ee:	01c85713          	srli	a4,a6,0x1c
    12f2:	9736                	add	a4,a4,a3
    12f4:	02e60563          	beq	a2,a4,131e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    12f8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    12fc:	4790                	lw	a2,8(a5)
    12fe:	02061593          	slli	a1,a2,0x20
    1302:	01c5d713          	srli	a4,a1,0x1c
    1306:	973e                	add	a4,a4,a5
    1308:	02e68263          	beq	a3,a4,132c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    130c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    130e:	00001717          	auipc	a4,0x1
    1312:	d0f73123          	sd	a5,-766(a4) # 2010 <freep>
}
    1316:	60a2                	ld	ra,8(sp)
    1318:	6402                	ld	s0,0(sp)
    131a:	0141                	addi	sp,sp,16
    131c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    131e:	4618                	lw	a4,8(a2)
    1320:	9f2d                	addw	a4,a4,a1
    1322:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1326:	6398                	ld	a4,0(a5)
    1328:	6310                	ld	a2,0(a4)
    132a:	b7f9                	j	12f8 <free+0x44>
    p->s.size += bp->s.size;
    132c:	ff852703          	lw	a4,-8(a0)
    1330:	9f31                	addw	a4,a4,a2
    1332:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1334:	ff053683          	ld	a3,-16(a0)
    1338:	bfd1                	j	130c <free+0x58>

000000000000133a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    133a:	7139                	addi	sp,sp,-64
    133c:	fc06                	sd	ra,56(sp)
    133e:	f822                	sd	s0,48(sp)
    1340:	f04a                	sd	s2,32(sp)
    1342:	ec4e                	sd	s3,24(sp)
    1344:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1346:	02051993          	slli	s3,a0,0x20
    134a:	0209d993          	srli	s3,s3,0x20
    134e:	09bd                	addi	s3,s3,15
    1350:	0049d993          	srli	s3,s3,0x4
    1354:	2985                	addiw	s3,s3,1
    1356:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1358:	00001517          	auipc	a0,0x1
    135c:	cb853503          	ld	a0,-840(a0) # 2010 <freep>
    1360:	c905                	beqz	a0,1390 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1362:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1364:	4798                	lw	a4,8(a5)
    1366:	09377a63          	bgeu	a4,s3,13fa <malloc+0xc0>
    136a:	f426                	sd	s1,40(sp)
    136c:	e852                	sd	s4,16(sp)
    136e:	e456                	sd	s5,8(sp)
    1370:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1372:	8a4e                	mv	s4,s3
    1374:	6705                	lui	a4,0x1
    1376:	00e9f363          	bgeu	s3,a4,137c <malloc+0x42>
    137a:	6a05                	lui	s4,0x1
    137c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1380:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1384:	00001497          	auipc	s1,0x1
    1388:	c8c48493          	addi	s1,s1,-884 # 2010 <freep>
  if(p == (char*)-1)
    138c:	5afd                	li	s5,-1
    138e:	a089                	j	13d0 <malloc+0x96>
    1390:	f426                	sd	s1,40(sp)
    1392:	e852                	sd	s4,16(sp)
    1394:	e456                	sd	s5,8(sp)
    1396:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1398:	00001797          	auipc	a5,0x1
    139c:	d0078793          	addi	a5,a5,-768 # 2098 <base>
    13a0:	00001717          	auipc	a4,0x1
    13a4:	c6f73823          	sd	a5,-912(a4) # 2010 <freep>
    13a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    13aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13ae:	b7d1                	j	1372 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    13b0:	6398                	ld	a4,0(a5)
    13b2:	e118                	sd	a4,0(a0)
    13b4:	a8b9                	j	1412 <malloc+0xd8>
  hp->s.size = nu;
    13b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13ba:	0541                	addi	a0,a0,16
    13bc:	00000097          	auipc	ra,0x0
    13c0:	ef8080e7          	jalr	-264(ra) # 12b4 <free>
  return freep;
    13c4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    13c6:	c135                	beqz	a0,142a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13ca:	4798                	lw	a4,8(a5)
    13cc:	03277363          	bgeu	a4,s2,13f2 <malloc+0xb8>
    if(p == freep)
    13d0:	6098                	ld	a4,0(s1)
    13d2:	853e                	mv	a0,a5
    13d4:	fef71ae3          	bne	a4,a5,13c8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    13d8:	8552                	mv	a0,s4
    13da:	00000097          	auipc	ra,0x0
    13de:	b9e080e7          	jalr	-1122(ra) # f78 <sbrk>
  if(p == (char*)-1)
    13e2:	fd551ae3          	bne	a0,s5,13b6 <malloc+0x7c>
        return 0;
    13e6:	4501                	li	a0,0
    13e8:	74a2                	ld	s1,40(sp)
    13ea:	6a42                	ld	s4,16(sp)
    13ec:	6aa2                	ld	s5,8(sp)
    13ee:	6b02                	ld	s6,0(sp)
    13f0:	a03d                	j	141e <malloc+0xe4>
    13f2:	74a2                	ld	s1,40(sp)
    13f4:	6a42                	ld	s4,16(sp)
    13f6:	6aa2                	ld	s5,8(sp)
    13f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13fa:	fae90be3          	beq	s2,a4,13b0 <malloc+0x76>
        p->s.size -= nunits;
    13fe:	4137073b          	subw	a4,a4,s3
    1402:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1404:	02071693          	slli	a3,a4,0x20
    1408:	01c6d713          	srli	a4,a3,0x1c
    140c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    140e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1412:	00001717          	auipc	a4,0x1
    1416:	bea73f23          	sd	a0,-1026(a4) # 2010 <freep>
      return (void*)(p + 1);
    141a:	01078513          	addi	a0,a5,16
  }
}
    141e:	70e2                	ld	ra,56(sp)
    1420:	7442                	ld	s0,48(sp)
    1422:	7902                	ld	s2,32(sp)
    1424:	69e2                	ld	s3,24(sp)
    1426:	6121                	addi	sp,sp,64
    1428:	8082                	ret
    142a:	74a2                	ld	s1,40(sp)
    142c:	6a42                	ld	s4,16(sp)
    142e:	6aa2                	ld	s5,8(sp)
    1430:	6b02                	ld	s6,0(sp)
    1432:	b7f5                	j	141e <malloc+0xe4>
