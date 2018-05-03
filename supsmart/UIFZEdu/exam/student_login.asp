<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考生登录</title>
<link href="student.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	background-color: #FFFFFF;
}
-->
</style>

</head>
<script language="javascript">
//限制本页面必需显示在框架中的main窗口里
	if(window.name != 'main')
	{
		window.open('student_login.asp','main');
	}
</script>
<body>
<br><br>
<form name="frmLogin" action="student_checklogin.asp" target="main" method="post">
<table width="90%" align="center" cellspacing="1" cellpadding="0" border="0" bgcolor="#FFFFFF" class="tborder">
	<tr>
		<td height="30" colspan="2" align="center" class="tdtbg">
			<font size=4 color="#FFFFFF"><strong>考 生 登 录</strong></font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" height="28" align="right">
			登录ID：
		</td>
		<td align="left">
			&nbsp;<input name="username" class="text" type="text" size="30" maxlength="100">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" height="28" align="right">
			登录密码：
		</td>
		<td align="left">
			&nbsp;<input name="pwd" class="text" type="password" size="30" maxlength="100">
		</td>
	</tr>
	<tr class="tdbg">
		<td height="50" colspan="2" align="center">
			<font color="green">如果你不是本系统考生请单击注册填写注册申请。</font><br>
			<input type="submit" value="&nbsp;登&nbsp;&nbsp;录&nbsp;">&nbsp;&nbsp;
			<input onClick="window.open('student_reg.asp','main')" type="button" value="&nbsp;注&nbsp;&nbsp;册&nbsp;">
		</td>
	</td>
</table>
</form>
</body>
</html>
