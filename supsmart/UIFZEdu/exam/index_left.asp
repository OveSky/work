<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新视点在线考试系统</title>
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
			<strong>考生信息</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			考生姓名：<%=request.cookies("aoyi")("studentname")%><br>
			&nbsp;&nbsp;性&nbsp;&nbsp;别：<%=request.cookies("aoyi")("sex")%><br>
			出生日期：<% if IsDate(request.cookies("aoyi")("birthday")) then response.write FormatDatetime(request.cookies("aoyi")("birthday"),2)%><br>
			&nbsp;&nbsp;状&nbsp;&nbsp;态：
			<% 
			'通过cookies判断考生当前是在考试中还是已登录或是未登录
			if request.cookies("aoyi")("username") <> "" then
				response.write "<font color='blue'>已登录</font>"
			else
				response.write "<font color='#BB7700'>未登录</font>"
			end if
			%>
		</td>
	</tr>
</table>

<form name="markquery" action="student_markquery.asp" target="main" method="post">
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong>成绩查询</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="center">
			课程名称<br>
			<%
			call showCourseList(0)'显示课程名称的选择列表，列表的名称为：CourseID
			%>
			<br>
			时间范围<br>
			从 <input class="text" type="text" name="starttime" size="14" maxlength="16" value=""><br>
			到 <input class="text" type="text" name="endtime" size="14" maxlength="16" value=""><br>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="center">
			<input type="submit" value="&nbsp;查&nbsp;询&nbsp;">
		</td>
	</tr>
</table>
</form>
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong>版权信息</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			程序制作: <a href="http://www.qz368.cn" target="_blank"><font color="red">新视点网络</font></a>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			QQ: 199143668 &nbsp;<font color="red">风口浪尖</font></a>
		</td>
	</tr>
</table>
</body>
</html>
