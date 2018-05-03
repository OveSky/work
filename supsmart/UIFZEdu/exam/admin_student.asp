<%@LANGUAGE="VBScript.Encode" CODEPAGE="65001"%>
<%#@~^DwAAAA==GaYrKx,+6aVb^kDGwYAAA==^#~@%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<%#@~^dgAAAA==@#@&InkwKx/RawbDn/{Oq@#@&I+k2W	/+c)[N_+mNnD~EaDCosCJBJUG ml^4J@#@&"nkwG	/Rb9N_nl9+.PrmC^4+O1GxDDW^ESJ	W /OW.nr@#@&iSQAAA==^#~@%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考生档案管理</title>
<link href="admin.css" rel="stylesheet" type="text/css">
<style>
body {
	font-size:12px;
}
</style>
</head>

<body>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			&nbsp;&nbsp;考&nbsp;&nbsp;生&nbsp;&nbsp;管&nbsp;&nbsp;理&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_student.asp">考生管理首页</a> | <a href="admin_student.asp?action=add">添加考生</a>
		</td>
	</tr>
</table>
<br>
<%#@~^dAMAAA==@#@&NrsPkYDzmDrW	@#@&@#@&kW~1t+1Vb9:k	JGobxv#~'~WmVd+,Otx7v进行管理员登录验证@#@&d.nkwGxkncDn9kM+mDPrCNskU{^WLr	Rlk2J@#@&+	[~k6@#@&kWP^4mVn!.\b+Ac;r1jP|niIj(AmUK`f2gK*~',0CVk+~O4+x@#@&dM+/aGU/RSDrYn~r@!^+	O+M@*@!WKxY~dbyn'W@*你没有进行此操作的权限，请与系统管理员联系！@!zWKxD@*@!JmUYD@*J@#@&7./wKU/RhMrO+,J@!z8W[z@*@!&tDhV@*J@#@&iD+d2Kxd+cn	N@#@&+	NPb0@#@&/DD)mDkGU,'PD.ks`D5;+kYc0GDhcrl^YbGxr#b@#@&k0~dDD)mDrKx~{PrJPDtU@#@&ddYMb^ObWx,xPDDksc.+$E/OR5;Dz/D.k	ocEmmYrG	Jb#@#@&x[,k6@#@&k+^nmDP^lk+~dDDb1OkKx@#@&7^lk+,J[+sE@#@&7d1CV^P[n^`#7v删除考生@#@&7mmdPEsW9k0HJ@#@&dimCV^PhG9k0Hc#iB修改考生界面@#@&7^lk+,Jdl-nsW[k6zJ@#@&771lVs~kl-+tG9kWH`*dB保存修改结果@#@&i^lk+~JmN[E@#@&di^l^VPm[[`*dE添加考生界面@#@&d^Ck+~JkC\l[[r@#@&771lsV,dm\nzN9`#iB保存添加结果@#@&d1ld+,J^4m3!2J@#@&di^CV^P1tnmV;a`bdE审批考生@#@&imCdPJ^4mVEa^mx^Vr@#@&id1CV^P^tmV;aZl	^+^`#iv取消审批@#@&imm/nPnsk+@#@&i7mmVs~slkUc*dv主界面@#@&n	N~k+^+mD@#@&^l^V~m^Wdn;Wx	c#@#@&x+EAAA==^#~@%>
</body>
</html>
<%#@~^iQEAAA==@#@&@#@&kE(P:mk	c#iB主界面@#@&iB定义：]n1WD9d+D对象，?pd字串，当前页面号，最大页面号，总学生数，每页显示学生数，当前在本页第几条记录@#@&d9ksP./jO!NnxDS/DDj5^?Y;[xO~bUDZ;Mnmo+Bk	OHm6KlT+Sr	YKKOl^?Y![nxD~bxO?O;9+UYhnDhlLnBkxO/!D]+1S&@#@&i@#@&dk	YUOE9+UYh+.Kmo+,xPycdE设定每页+*个考生@#@&db0~qdH!:nDb^`:DrhvD+5;/OR$;DzkYMkxT`r2lT+E#*#~x,YD!nPDt+	@#@&dik	Y/E.KmonP{~ZdxLcM+;;nkY ;!nMXdDDbxovJaCoJb#@#@&7n^/+@#@&dikxD/;DhlT+~'~q@#@&7+	[Pb0@#@&i@#@&jWQAAA==^#~@%>

<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="80" align="center"> 考 生 ID</td>		
		<td align="center"> 登录名称 </td>
		<td width="100" align="center"> 真实姓名 </td>
		<td width="50" align="center"> 性 别 </td>
		<td width="100" align="center"> 状 态 </td>
		<td width="150" align="center"> 操 作 </td>
	</tr>
	<%#@~^aggAAA==@#@&ddY,D/UY![+	Y~',/n.7+Dc^DlYG8LmD`Eb96GA I^WMNdnDJ#@#@&i/ODU5^?O!NxY,',E/VnmDPOGaPFl~e,0DKh~/DE9+UYE@#@&d./UOE9+UOcWwnU,/ODU5^?O!NxYBM|/rg1SFBF@#@&ik0,./UYE9nUYc4K0~lU[,Dd?D;NxO W0~O4+U@#@&7iDnkwKx/RS.kD+~J@!Y.~1Vlkd'EYN(Lv@*@!Y9P^WsdalU'EB,lsrTx'v^xO+Mv@*没有考生@!&DN@*@!zDD@*E@#@&dnx9PrW@#@&dMd?DENUORalT+dk"n,'~k	O?DE[n	Ynn.hlL+@#@&ikUDHm6nmo~',Dd?DE[n	YRaComW!UO@#@&db0~kUO;E.nmL+,@*~.k?Y;[xORaCT+^KE	YPDtU@#@&d7k	Y/;MnlTnP{PDkjOE9+	Y wCLmGE	O@#@&dnsk+kW~bxOZ!.hlLP@!PF,Y4nx@#@&7dbxO/!DnmL+,'P8@#@&dx9Pr0@#@&ikWPMd?DE[n	YR2CT+^W!UDP@*,!,Ytx@#@&diDd?DE[n	YRm8/KVEDn2lT+,'~kUO;E.nmL+@#@&7n	NPrW@#@&7k	O;E."+1P',F@#@&dStrVPUGDPDkjY!N+	O +K0,lUN~r	Y/EM]+1P@!x,kxOjDE[+	Oh+.hlT+@#@&di.+kwGxk+ AMkY~J@!YD,^slk/{BON8LE@*E@#@&7dM+d2Kx/n SDrY~r@!O9PmVkTx{vmxO+MB@*E,[PMd?DENUO`r/DE[+UObNE#,'Pr@!&O9@*J@#@&id.+k2KxdRSDkD+,E@!DN~l^kLU{BmUYDB@*E~[,Dk?OE[n	YcJ!d+MxChJ#~',J@!zD[@*J@#@&diD+kwKU/RADbYn~r@!Y9~l^ko	xvmxD+.B@*E,[~DkjY!NnUD`JdO!NnxDUm:nr#,[Pr@!JON@*J@#@&idrW,D/UOE9+xDcE/6r#~'~OMEnPD4+	@#@&7idDndaWU/ SDrD+,J@!DN,CVboU'EmnUD+DE@*男@!JYN@*E@#@&idVd+@#@&id7DdwKxdnchDrOPE@!D[,lsbo	'B1+	O+MB@*女@!JY[@*r@#@&i7+	NPbW@#@&idb0~DdjDE[+	O`r/O;9+xOOHwnJ*~{PT,Y4+x@#@&i7dM+dwKxdnchDbO+,J@!D[~l^kTxxB^n	YnDE@*@!6WUO,mWsGM'va6Wl*TZB@*未审批@!z6W	O@*@!zON@*J@#@&id+^d+id@#@&77dM+kwGxdnch.kDnPr@!O[,lVrL	'vmUD+.E@*@!0W	Y,^W^W.'Ea++O, yv@*已注册@!z0KUO@*@!zDN@*J@#@&idnx9~k6@#@&7iD+d2Kxd+cAMkOPr@!Y9PmskTxxB1+UODB@*E@#@&ddMndwKxk+ h.rD+~J@!CP4DnW{Bav~Kx/Vb^0'Erk6`mKx6rDs`v删除此考生将连同其考试记录一起删除~你确认吗QBb~{'PD.E#PSrUNKhcW2+UcEl[:bU{kY;[xY Ckw_l1ObWU{NV[kY![+	YrN{J~',D/UOE9+xDcE/DE9+UYr[r#~[,E[alLn{JP'~bxOZ!.hlLPLPJE~Em/VWB*JE@*删除@!zl@*~u,J@#@&77D/aWU/n SDrY~J@!l~4M+0xvmNhk	mkY;9+	YRm/a_l1YrW	'hG9k0H'/DENUOk9'rP'P.dUY;NUYvJdO!N+UObNE#,',J'alT+'rPL~k	Y/EMnCLP[,EB@*修改@!zm@*~J@#@&idr0~.k?OE9nxD`EdDENnUDYzwE*Px,!,Ytx@#@&did.+kwGUk+RS.kD+Prk~@!mP4Dn0xvmNhk	m/DE[n	YRCdagCmDrKxx1tm3!wLdY!NnxDk[xrP[,./UYE9nUYvJkY;NnUDk[J*~[,J'2mo+xE,[~k	O;E.hlT+PLPrv@*审批@!zC@*r@#@&7i+x9~k6@#@&i7.+kwKxd+ AMkO+,E@!JY[@*@!zY.@*r@#@&di.k?O!NxYc:K-+	+aY@#@&77bxY;;D"+m,x~k	Y;E.In^,_~F@#@&dS+U[@#@&d.dUY;NUDR^^Wk+@#@&dknY,Dd?DE[n	YP{~xKYtbUL@#@&dcHICAA==^#~@%>
</table>
<center>
<%#@~^SgAAAA==@#@&mC^V,/tKhhCoZOD^`rUDHlXKlT+~bUOZ!DhlL+SEmNhk	m/DE[n	YRCdag2lTn{Jb@#@&hBgAAA==^#~@%>
</center>
<%#@~^KAAAAA==@#@&+U9PkE4@#@&@#@&/!4~l9NcbiB添加考生界面@#@&EQYAAA==^#~@%>
<form action="admin_student.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 添 加 考 生 </td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">登录名称：</td>
		<td>
			<input name="username" type="text" class="text" size="20" maxlength="25" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">登录密码：</td>
		<td>
			<input name="studentpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">确认密码：</td>
		<td>
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">真实姓名：</td>
		<td>
			<input name="studentname" type="text" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right"> 性  别：</td>
		<td>
			<input name="sex" type="radio" checked value="1">男&nbsp;&nbsp;&nbsp;&nbsp;
			<input name="sex" type="radio" value="0">女
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">出生日期：</td>
		<td>
			<input name="birthday" type="text" class="text" size="20" maxlength="25" value="">例：1988-12-11
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">电话号码：</td>
		<td>
			<input name="tel" type="text" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">电子邮件：</td>
		<td>
			<input name="email" type="text" class="text" size="30" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" colspan="2">
			<input type="submit" value="&nbsp;添&nbsp;&nbsp;加&nbsp;">
		</td>
	</tr>
</table>
</form>
<%#@~^IQoAAA==@#@&+U9PkE4@#@&@#@&/!4~/m\n)9N`*7B保存添加结果@#@&d9rhPM/UY;NnUD~dYMj;^?O;9+xOSkY.jknM1Cs+B/YM?D;NxO1m:nSkYDUOE9+xDKANB/DDP+sS(VU?a~kY.3slksS9YhAb.Dt[mXB/YM2M.@#@&d@#@&i/O.ADD,xPrJ@#@&7dYMjk+.1ChPxPD.ks`.n$E+dOc0GDscrEdD	l:J*b@#@&ddYM?O;9+xDHls+P{~ODb:vDn;;nkY 0K.:vJdO!N+UO	lh+rb*@#@&i/DD?DE9nxDnAN,'~OMk:v.+$E+kO 0KDs`E/O;9+UYaANr#b@#@&d/O.:+sP{~DDrs`M+;!+kOR6W.:vJOn^J#*@#@&i/YM3hlbV,'~Y.rs`.+$;+kY WKD:cE:Ck^E*#@#@&db0P;S	L`DDr:vDn5!+/D 0KD:vEd+XJ*#bP@*~ZPOtU@#@&d78^x?na,'~YM;@#@&i+^/+@#@&i74^xj+XPx~6lVkn@#@&d+	[~k6@#@&dr0~dDDi/.1m:n~{PJE~Dtnx@#@&iddDDADD,',E@!^k@*登录名为空！@!JVr@*r@#@&inx9Pk6@#@&db0,/ODjO!NnxDKh9Px~rJPO4x@#@&i7kY.ADMP',/D.2MD~[,J@!sb@*密码为空！@!Jsk@*JP@#@&7+	N,kWP@#@&ikWPkODUY;[xYKA9P@!@*,OMkhvD;E/D 0KDh`rmGU6kDs2h9J#*~Otx@#@&7ddOM2.D,xPkY.3MDP'~r@!sk@*密码与确认密码不符！@!JVr@*J@#@&dx9~k6@#@&db0~dDD?D;NxYgCh+,',JEPO4x@#@&i7/DD3.MP'~dDD3DM~LPE@!Vb@*真实姓名为空！@!JVb@*J@#@&7+	N~r6@#@&ir0,q/GCO+vYMkh`.n$En/D 0KDhcr4k.O4NCXrb*#~{P6lVk+,Otx@#@&iddOM2DM~',/YM3.D,[,J@!Vr@*日期格式不正确！@!zsk@*E@#@&dnsk+@#@&7iNO:~rMY49lHP',ZGCY`ODb:c.;EdYc0WMhcJ(kMY4NCzr#b#@#@&dx[~b0@#@&7b0~M|/}1Hc+X+m!YcJk+s+1Y~^KExDce*Plk~.+1mKEUY~WMWhPkOE9+UO,htn.PdY![xO	ls+'EJ,'PkY.?DE[n	Y1mh+,[PrvE#vJM+^mG;	YE#,@*PZPO4x@#@&7i/ODA.MPx,/DD2MD,'Pr@!sk@*系统中已存在此登录名！@!&sb@*J@#@&dxN,rW@#@&db0~/O.AD.P@!@*PrJ~O4+x@#@&iddtKAAD.t/T`/DDA.D*@#@&di+arDP/!8@#@&d+	[~k6@#@&dd+O~M/jY![+	Y~x,/+.-D mMnmYnK4N+mD`r)f}f$R"+^GMN/OJ*@#@&idODU;^?OE[n	Y~',E/Vn^DPe~WMWhPkO!Nn	Y,htD~/DE[+	Yr[{!J@#@&dM/?D;[+	YcW2+U~kY.?$s?DE[n	Y~!m;rH1BqB&@#@&dM/?DE9nxDRCN9xnA@#@&dMd?DENUO`rEk+.xChJbP{~/DDidD1Ch@#@&dMdUY;9+	Y`r/D;NxOwSNEb,'PkODUYE9nUYhh9@#@&d.dUY;NUYvJdO!N+UO	lh+rb,'~kYM?Y!NUYglh+@#@&7.k?Y![+	Y`r8rDDt9lzJb~{P[Ys$kMY4[mX@#@&7M/jY![xOvJD+Vr#,xPkY.KV@#@&iD/UOE9+xDcE+slbVE#~x,/ODAhlbV@#@&iD/jO!NnxDcr/nXJ*P',4^U?6@#@&iDdjDENUYvJ/D;[+	YDX2+Eb,'~F@#@&dM/jO!N+UOcE2NmO@#@&iDk?Y!NUYcmsWk+@#@&i/+D~Dk?Y![nxDP{PUWO4bxL@#@&7mmVs~1VWdn;WUxvb@#@&7M+kwW	/ DNrDmO~rlNsrx|/Y![nxDRm/2J@#@&x[Pk;4@#@&@#@&kE4~hKNr0Hc*dv修改考生界面@#@&iNksPMd?DE[+	YSdDD?$s?DENUO~bxD?OE[n	Y(fBdYM?O;9+xOHm:n~kOMKn^~kYDA:mrVB4sxU+aS9Y:~rDDtNmzS/DDAD.@#@&7@#@&7/D.2MD~x,JJ@#@&ikUYUO!Nn	Y&fP{P;JxT`ODb:c.;EdYc;E.z/DDbxL`EdDE[+	Ok9Jbb*@#@&7dDDj;^jDE[xDP',JknVmOPCPW.K:PkOE9+xD~AtDPdY;[xOk9xJ,[~r	Y?O;9+UY&9@#@&7k+DPDk?D;NxOP{PdnM\+M mM+lDnG4N+1YcJ)9}f$R"nmKD[dYJb@#@&d./UO!Nn	YcWwx,dYM?5VUY;[xYB!{;r1gSq~8@#@&dr0~.k?OE9nxDR8G6PlU[,Dd?D;9+UDRW0,Y4nx@#@&7dkY.3MDP{~J@!Vk@*此考生不存在！@!&Vb@*r@#@&dnU9Pr0@#@&db0~dDD2..,@!@*PrE,Y4x@#@&diDkjY!NnxDR^sK/+@#@&di/+D~./UY!NnxO~{PUWD4k	o@#@&id/4GS2.DtdT`dDDADD*@#@&7d6rY,/;8@#@&dUN,k0@#@&Z/MCAA==^#~@%>
<form action="admin_student.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="studentid" type="hidden" value="<%=#@~^FgAAAA==.k?O!NxYvJkOE9+UYbNEbNQgAAA==^#~@%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 修 改 考 生 </td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right">登录名称：</td>
		<td>
			<font color="#0000FF"><%=#@~^FQAAAA==.k?O!NxYvJ!d+MxC:JbwQcAAA==^#~@%></font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right">(留空不修改)登录密码：</td>
		<td>
			<input name="studentpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right">(留空不修改)确认密码：</td>
		<td>
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right">真实姓名：</td>
		<td>
			<input name="studentname" type="text" class="text" size="20" maxlength="50" value="<%=#@~^GAAAAA==.k?O!NxYvJkOE9+UY	lhnr#CQkAAA==^#~@%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right"> 性 别：</td>
		<td>
			<input name="sex" 
			<%#@~^WgAAAA==@#@&d7ik6PDk?D;NxO`r/nar#P{~YME+,O4+	@#@&d7d7./2W	d+ch.rD+PE^4+^3[r@#@&idi+x9PbW@#@&d7dlhYAAA==^#~@%>
			 type="radio" value="1">男&nbsp;&nbsp;&nbsp;
			<input name="sex" 
			<%#@~^WwAAAA==@#@&d7ik6PDk?D;NxO`r/nar#P{~0mV/~Otx@#@&7d77M+dwKU/RA.bY+~E1tnm0n9J@#@&did+	N,r0@#@&7di4RYAAA==^#~@%>
			 type="radio" value="0">女
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="200" align="right">出生日期</td>
		<td>
			<input name="birthday" type="text" class="text" size="20" maxlength="25" value="<%=#@~^JwAAAA==oKDhmYGlYYbh+vDd?DE[n	Y`r8kMYt9CzJ*~y#/Q0AAA==^#~@%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right">电话号码：</td>
		<td>
			<input name="tel" type="text" class="text" size="20" maxlength="50" value="<%=#@~^EAAAAA==.k?O!NxYvJDnVr#pgUAAA==^#~@%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="200" align="right">电子邮件：</td>
		<td>
			<input name="email" type="text" class="text" size="30" maxlength="128" value="<%=#@~^EgAAAA==.k?O!NxYvJhlbVE#aQYAAA==^#~@%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td colspan="2" align="center">
			<input type="submit" value="&nbsp;修&nbsp;&nbsp;改&nbsp;">&nbsp;&nbsp;
			<input type="reset" value="&nbsp;重&nbsp;&nbsp;写&nbsp;">
		</td>
	</tr>
</table>
</form>
<%#@~^OQwAAA==@#@&d.k?DENxD m^Wd+@#@&7dYPMd?DENUOP{P	WOtrUT@#@&+	[PkE8@#@&@#@&d;(Pdl7ntW[b0H`#iB保存修改结果@#@&d9khPM/jO!N+	O~kYDU5s?DE9+UYSr	YjY![+	Y(9B/Y.ik+.1mh~dDDUYE9+	O1m:n~kY.jDENUYhhNB8sxU+X~[Yh$bDOt9CXB/O.A:lrsB/OD:n^~dDDADD@#@&idYM2.D,'~Er@#@&irxD?Y![nxDqGPxP/J	ocKMr:vDn5!+/O 6W.:vEkY;9+	Yk9J*b#@#@&7/DDjO!N+	O1m:+,x~KMks`.+5;/OR6GDs`EdDENnUDxC:E*#@#@&dkYDUY![+	YKh9Px~:DkscD;EdOR6WM:cJdO!NnxD2h9Jbb@#@&ddOM2hlbs,'~:Db:`M+$;+kY 0KDhcr+:mrVr##@#@&7/DD:+sPx~:Dr:v.+$EndDR0G.s`EYsr#b@#@&ik0,ZdUovY.ks`.n$E+kOR6WDscE/6r#b#~@*,!~Y4nx@#@&77(VxjnXPxPD.!+@#@&dV/@#@&7d(VU?6~x,0l^d+@#@&dU[Pb0@#@&7kW~kY.?D;NxOHm:+~x,JEPD4x@#@&di/YM2M.P{PdYM2..,[Pr@!Vb@*真实姓名为为空！@!Jsr@*r@#@&dnx[~b0@#@&ir0,/O.UYE[n	YKh9~@!@*~:Db:`M+$;+kY 0KDhcrmW	WkM:wS[E#*PDtnx@#@&iddYM3DMPx~kYD3.MP'Pr@!^k@*密码与确认密码不符！@!z^k@*r@#@&7+	N~k6@#@&7b0P&dfmY+vO.ks`M+5EndDRWWMh`r4r.DtNCzr#b#,x,0C^/PY4+	@#@&iddYM2..,'PkODADD,'~J@!Vb@*出生日期格式错误！@!zsr@*J@#@&inVk+@#@&idNOh~k.Y4[mX~{P;flD+vODb:cD;;nkYR6GDs`J(r.Y4NmXE#bb@#@&7+	[Pb0@#@&ik0~dDD3DM~@!@*~rJ,Ytx@#@&di/4WS2..t/ovdYM2DMb@#@&id6rY~d!4@#@&inx9PrW@#@&ddnDP./UO!Nn	Y,'Pk+M-+MR^DlOnK4L^YvJbG69AcImGD[dYE#@#@&dkY.j$V?O;9+UY,x,JdVmY,e,WDK:~/DE[n	YPS4+M+PkO;NxDk['E~LPrxDjY!NnUDqf@#@&iDd?D;9+UDRKw+	PkODU;s?DE[n	Y~VmZ}11BqS&@#@&ikWP.dUY;NUYc4GW,lx[~M/jY![xOc+K0PDtU@#@&d7/DD3.MP',E@!^k@*要修改的考生不存在！@!&sk@*J@#@&7+U[,kW@#@&7k6PdOM2D.~@!@*~Jr~Dtn	@#@&ddM/UOE9+UYcmsGk+@#@&7dk+Y,.d?DE9+UY~x,xGY4rxT@#@&7i/tGAAD.HkLv/OM2MD#@#@&i7+XkOPkE8@#@&d+	[Pb0@#@&7./UY!NnxOcr/OE9nxDxChJ#~x,/ODUO!Nn	Ygl:@#@&7k6PdYM?O;9+xDKh9P@!@*~EJ,Y4+U@#@&7iDd?D;NxOcr/Y;[xOwS[r#~{PkYDUY![+	YKh9@#@&7xN,r0@#@&dMdjY!NxO`Ed6E#,xP(VUj6@#@&7M/jY![xOvJ:lbVrbP{PdYM2hCbV@#@&7Dk?Y![nxD`rYnVEb,'~/D.KV@#@&iD/jO!NnxDcr4rMY4NlHJ*~',NO:~k.O4NlH@#@&iD/UO;NxDR;w[CD+@#@&i./UY;[xY ^^Wd+@#@&i/nDPM/?DE9nxDPxP	WO4bxo@#@&d1lV^~^VK/ZGxUc*@#@&dMn/aWUdRDn[bDnmD~rl[sk	{/DE9nxDRC/aJ@#@&xN,dE(@#@&@#@&dE(P1tnmV;a`bdE审批考生@#@&iNrh,kxOjDE[+	O&fSkYM2DM@#@&7@#@&drxD?O;9+xD(f,'P;JUovKMkh`.n$En/D ;!+.zkYDrUT`E/D;9+UDk9J#*#@#@&db0~M|Z6HgR+Xnm!Y+vEd+^+1Y~mG;	Yce*~lkP.n1mW;UDPWDKh,/O!NxY,h4nDPdY!NnUDkN{EPLPk	OjY!NxOq9bvJ.+1^W!xOE*P'~T,Y4+	7i@#@&idkYDADM~',J@!Vb@*此考生不存在！@!&^k@*r@#@&i+x9~r0@#@&ikWPdOM2.D,@!@*,JE~Dt+U@#@&d7/D4Kh3MDt/ov/D.2MDb@#@&d7nXkY,dE(@#@&inUN,k6@#@&d!m;rH1cn6m;O`J;29lO+,dDE[xDP/Y,dY!NnxDYz2'Frb@#@&dmmssP1VK/nZGU	`b@#@&7D/2G	/+ .NrD^DPEmNskx|/D;NxORm/2E@#@&+	[PkE4@#@&@#@&kE(P[+sc*dv删除考生@#@&7Nb:~r	Y?O;9+UY&9B/OM2MD@#@&d@#@&dkY.2MD~x,JJ@#@&dbxYUO;NxDq9Px~;SUovPDb:c.;EndDR5E.H/OMk	o`r/D;NxOk9Jbb*@#@&ir0,M{;6H1c+X+^EOnvJd+^nmDP^G!xYcM*PC/,.m^KE	YP6DKhPaD%{kY;[xY,AtD+,dOlD+{ ~lU[,/OE9nxDk[xrP[~r	YjY![xO&f*`JM+1^W!xOJ*P@*~ZPY4nx@#@&didODADMPxPE@!^k@*此考生正在考试，不能被删除！@!Jsk@*J@#@&i+x[~b0@#@&ir6PdDDADD,@!@*~JrPOtx@#@&id/4GhADDtdL`kYM2.Db@#@&d7+XrY,/;8@#@&dnU9Pr0@#@&iMm;rg1R(+TrxDDCxk@#@&7V{Z}H1c+6^;YPrNnVnOPWDKhPaD%maDW^nk/~h4nM+~kY!N+	Yb['rP'PbxOjDENUY&f@#@&7!{;rg1 +an1EO+,ENVnOP0.GsP2DNmkY;9+	YPSt.+,/OE9+UObN'r~[,kxDjOE9+	Y(f@#@&iMmZ}H1c+an1EYn~rNnVOPWMWsP/DE9nxDPAtDn~kYE9nxDkN{E~[,k	YjY;[xOqG@#@&iMm/}11 ^K:hkDOMlUk@#@&dmmV^~m^Wd+;WUUv#@#@&7D/wKUd+cDNrDn^DPEl9hk	{dO!N+UOcldwr@#@&+U9PkE4@#@&MpIDAA==^#~@%>