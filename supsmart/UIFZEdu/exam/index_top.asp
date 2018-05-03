<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新视点在线考试系统</title>
<style type="text/css">
<!--
body {
	background-color: #39867B;
}
.title {
	font-size: 16px;
	font-family: 黑体;
	color: #000;
}
td {
	font-size: 14px;
	color: #FFF;
}
A:link {
	color: #FFB;
	text-decoration: none;
}
A:visited {
	color: #FFB;
	text-decoration: none;
}
A:hover {
	color: #FFF;
	text-decoration: underline;
}
-->
</style>
</head>
<script language="javascript">
	if(window.name != 'top')
	{
		window.open('index_top.asp','top');
	}
</script>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table width="100%">
	<tr>
		<td width="200" align="left" valign="top"><br><strong><a href="http://www.qz368.cn" target="_blank">http://www.qz368.cn</a></strong>		</td>
	  <td>
			<table width="100%">
				<tr>
					<td height="50">
					</td>
				</tr>
				<tr>
					<td align="center" width="100">
						<a href="index_main.asp" target="main">【首页】</a>
					</td>
					<td align="center" width="100">
						<a href="student_modifypwd.asp" target="main">【修改密码】</a>
					</td>
					<td align="center" width="100">
						<a href="student_modifyinfo.asp" target="main">【个人信息】</a>
					</td>
					<td align="center" width="100">
						<a href="student_reg.asp" target="main">【新考生注册】</a>
					</td>
					<td align="right">
					<%
						if request.cookies("aoyi")("username") <> "" then
							response.write "<a href='#' onClick=""if(confirm('你确定要注销登录吗？')) window.open('student_logout.asp','_self')"">【注销登录】</a>&nbsp;&nbsp;"
						else
							response.write "<a href='student_login.asp' target='main'>【登录系统】</a>&nbsp;&nbsp;"
						end if
					%>
					</td>
				</tr>
			</table>
	  </td>
	</tr>
</table>
</body>
</html>
