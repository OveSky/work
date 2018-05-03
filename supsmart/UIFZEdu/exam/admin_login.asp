<html>
<head>
	<title>新视点在线考试系统后台登录</title>
</head>
<body background="images/bac.gif" topmargin="40">
<script language="javascript">
//限制本页面窗口为顶层窗口
	if(window.parent.name!=window.name)
	{
		window.open('Admin_Login.asp','_top');
	}
</script>
	<form action="admin_checklogin.asp" method="post">	
	<p><FONT face="宋体"></FONT>&nbsp;</p>
			<p><FONT face="宋体"></FONT>&nbsp;</p>
			<table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td><a href="http://www.qz368.cn" target="_blank"><img src="images/manager_1.gif" width="400" height="108" border="0"></a></td>
				</tr>
				<tr>
					<td background="images/manager_2.gif"><table width="400" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60" height="18">&nbsp;</td>
								<td>
								</td>
								<td width="30">&nbsp;</td>
							</tr>
							<tr>
								<td width="60">&nbsp;</td>
								<td>
									<p class="tdbg"><font color="white">用户名：</font>
										<input name="adminname" type="text" size="15" maxlength="50" value="">
										<br>
										<font color="white">密 &nbsp;码：</font>
										<input name="adminpwd" type="password" size="15" maxlength="50" value="">
									</p>
								</td>
								<td width="30">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="400" height="31" valign="top" background="images/manager_3.gif">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="67%">&nbsp;</td>
								<td width="33%"><input type=image name="images" src="images/001.gif"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</form>
</body>
</html>