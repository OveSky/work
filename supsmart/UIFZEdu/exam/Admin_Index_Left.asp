<%option explicit%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>���ӵ����߿���ϵͳ-��̨����</title>
<link href="admin.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	background-color: #39867B;
}
-->
</style>
</head>

<body topmargin="0" leftmargin="0" bottommargin="0" rightmargin="0">
<br>
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong>��¼��Ϣ</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			��¼���ƣ�<%=request.cookies("aoyi")("adminname")%><br>
			Ȩ�޼���
			<%
			if request.cookies("aoyi")("adminname") = "" then
				response.write "<font color='#BB7700'>δ��¼</font>"
			elseif request.cookies("aoyi")("adminname") = "admin" then
				response.write "<font color='#0000FF'>��������Ա</font>"
			else
				response.write "<font color='#0000FF'>��ͨ����Ա</font>"
			end if
			%><br>
			&nbsp;&nbsp;&nbsp;<a href="admin_modifypwd.asp" target="main">�޸�����</a>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="admin_logout.asp" target="_top">�˳���¼</a>
		</td>
	</tr>
</table>
<br>
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong> �� �� �� �� </strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>����Ա����</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_admin.asp" target="main">����Ա����</a> | <a href="admin_admin.asp?action=add" target="main">���</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>�γ̵���</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_course.asp" target="main">�γ̵�������</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>���⵵��</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_subject.asp" target="main">���⵵������</a> | <a href="admin_subject.asp?action=add" target="main">���</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>���Լƻ�</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_project.asp" target="main">���Լƻ�����</a> | <a href="admin_project.asp?action=add" target="main">���</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>��������</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_student.asp" target="main">��������</a> | <a href="admin_student.asp?action=add" target="main">���</a>
		</td>
	</tr>
	<tr>
		<td class="tdtbg">
			<strong>��Ȩ��Ϣ</strong><br>&nbsp;&nbsp;&nbsp;
			��������: <a href="http://www.qz368.cn" target="_blank"><font color="red">���ӵ�����</font></a>
		</td>
	</tr>
</table>
</body>
</html>
