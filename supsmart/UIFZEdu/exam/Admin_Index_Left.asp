<%option explicit%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新视点在线考试系统-后台管理</title>
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
			<strong>登录信息</strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg" align="left">
			登录名称：<%=request.cookies("aoyi")("adminname")%><br>
			权限级别：
			<%
			if request.cookies("aoyi")("adminname") = "" then
				response.write "<font color='#BB7700'>未登录</font>"
			elseif request.cookies("aoyi")("adminname") = "admin" then
				response.write "<font color='#0000FF'>超级管理员</font>"
			else
				response.write "<font color='#0000FF'>普通管理员</font>"
			end if
			%><br>
			&nbsp;&nbsp;&nbsp;<a href="admin_modifypwd.asp" target="main">修改密码</a>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="admin_logout.asp" target="_top">退出登录</a>
		</td>
	</tr>
</table>
<br>
<table width="170" align="center" bgcolor="#FFFFFF" cellspacing="1" cellpadding="4" border="0">
	<tr>
		<td class="tdbg" align="center">
			<strong> 操 作 面 板 </strong>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>操作员档案</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_admin.asp" target="main">操作员管理</a> | <a href="admin_admin.asp?action=add" target="main">添加</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>课程档案</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_course.asp" target="main">课程档案管理</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>试题档案</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_subject.asp" target="main">试题档案管理</a> | <a href="admin_subject.asp?action=add" target="main">添加</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>考试计划</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_project.asp" target="main">考试计划管理</a> | <a href="admin_project.asp?action=add" target="main">添加</a>
		</td>
	</tr>
	<tr>
		<td class="tdbg">
			<strong>考生档案</strong><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="admin_student.asp" target="main">考生管理</a> | <a href="admin_student.asp?action=add" target="main">添加</a>
		</td>
	</tr>
	<tr>
		<td class="tdtbg">
			<strong>版权信息</strong><br>&nbsp;&nbsp;&nbsp;
			程序制作: <a href="http://www.qz368.cn" target="_blank"><font color="red">新视点网络</font></a>
		</td>
	</tr>
</table>
</body>
</html>
