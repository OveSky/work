<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>���ӵ����߿���ϵͳ</title>
<link href="student.css" rel="stylesheet" type="text/css">
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
			<strong>������Ϣ</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			����������<%=request.cookies("aoyi")("studentname")%><br>
			&nbsp;&nbsp;��&nbsp;&nbsp;��<%=request.cookies("aoyi")("sex")%><br>
			�������ڣ�<% if IsDate(request.cookies("aoyi")("birthday")) then response.write FormatDatetime(request.cookies("aoyi")("birthday"),2)%><br>
			&nbsp;&nbsp;״&nbsp;&nbsp;̬��
			<% 
			'ͨ��cookies�жϿ�����ǰ���ڿ����л����ѵ�¼����δ��¼
			if request.cookies("aoyi")("username") <> "" then
				response.write "<font color='blue'>�ѵ�¼</font>"
			else
				response.write "<font color='#BB7700'>δ��¼</font>"
			end if
			%>
		</td>
	</tr>
</table>

<form name="markquery" action="student_markquery.asp" target="main" method="post">
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong>�ɼ���ѯ</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="center">
			�γ�����<br>
			<%
			call showCourseList(0)'��ʾ�γ����Ƶ�ѡ���б��б������Ϊ��CourseID
			%>
			<br>
			ʱ�䷶Χ<br>
			�� <input class="text" type="text" name="starttime" size="14" maxlength="16" value=""><br>
			�� <input class="text" type="text" name="endtime" size="14" maxlength="16" value=""><br>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="center">
			<input type="submit" value="&nbsp;��&nbsp;ѯ&nbsp;">
		</td>
	</tr>
</table>
</form>
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong>��Ȩ��Ϣ</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			��������: <a href="http://www.qz368.cn" target="_blank"><font color="red">���ӵ�����</font></a>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			QQ: 199143668 &nbsp;<font color="red">����˼�</font></a>
		</td>
	</tr>
</table>
</body>
</html>
