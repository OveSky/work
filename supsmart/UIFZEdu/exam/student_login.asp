<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>������¼</title>
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
//���Ʊ�ҳ�������ʾ�ڿ���е�main������
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
			<font size=4 color="#FFFFFF"><strong>�� �� �� ¼</strong></font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" height="28" align="right">
			��¼ID��
		</td>
		<td align="left">
			&nbsp;<input name="username" class="text" type="text" size="30" maxlength="100">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" height="28" align="right">
			��¼���룺
		</td>
		<td align="left">
			&nbsp;<input name="pwd" class="text" type="password" size="30" maxlength="100">
		</td>
	</tr>
	<tr class="tdbg">
		<td height="50" colspan="2" align="center">
			<font color="green">����㲻�Ǳ�ϵͳ�����뵥��ע����дע�����롣</font><br>
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;¼&nbsp;">&nbsp;&nbsp;
			<input onClick="window.open('student_reg.asp','main')" type="button" value="&nbsp;ע&nbsp;&nbsp;��&nbsp;">
		</td>
	</td>
</table>
</form>
</body>
</html>
