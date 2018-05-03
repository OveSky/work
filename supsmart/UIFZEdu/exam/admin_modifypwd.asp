<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>修改密码</title>
<link href="admin.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
'根据不同的参数值决定是修改操作员提交的密码还是显示操作员密码修改页面
if checkAdminLogin() = true then
	if request.form("action") = "modify" then
		call modifyPwd()
	else
		call showModifyPwd()
	end if
else
	response.redirect "admin_index_main.asp"
end if
	
'显示密码修改页面
sub showModifyPwd()
	dim rsPwd,strSqlPwd
	
	set rsPwd = server.createobject("ADODB.Recordset")
	strSqlPwd = "select * from admin where adminname='" & request.cookies("aoyi")("adminname") & "'"
	rsPwd.open strSqlPwd,G_CONN,1,1
	if rsPwd.bof or rsPwd.eof then
		rsPwd.close
		set rsPwd = nothing
		response.redirect "admin_login.asp"
	end if
%>
	<form action="admin_modifypwd.asp" method="post">
		<input name="action" type="hidden" value="modify">
	<table align="center" width="90%" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td colspan="3" align="center">
				<font color="#FFFFFF"><storng>&nbsp;修&nbsp;改&nbsp;密&nbsp;码&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right" width="200">
				登录名称：
			</td>
			<td>
				<%=rsPwd("adminname")%>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				旧密码：
			</td>
			<td>
				<input name="pwd" class="text" type="password" size="18" maxlength="50">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				新密码：
			</td>
			<td>
				<input name="newpwd" class="text" type="password" size="18" maxlength="50">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				确认密码：
			</td>
			<td>
				<input name="confirmpwd" class="text" type="password" size="18" maxlength="50">
			</td>
		</tr>
		<tr class="tdbg">
			<td colspan="2" height="30" align="center">
				<input type="submit" value="&nbsp;修&nbsp;&nbsp;改&nbsp;">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" onClick="history.go(-1)" value="&nbsp;取&nbsp;&nbsp;消&nbsp;">
			</td>
		</tr>

	</table>
	</form>
<%
	rsPwd.close
	set rsPwd = nothing
end sub
	
'修改操作员密码
sub modifyPwd()
	dim rsModifyPwd,strSqlModifyPwd,strPwd,strNewPwd,strConfirmPwd,strErr
	
	strErr = ""
	'验证操作员提交的新密码与确认密码是否合法
	if trim(request.form("newpwd")) = "" then
		strErr = strErr & "<li>新密码为空！</li>" & vbcrlf
	else
		strNewPwd = trim(request.form("newpwd"))
	end if
	if trim(request.form("newpwd")) <> trim(request.form("confirmpwd"))  then
		strErr = strErr & "<li>新密码与确认密码不符！</li>" & vbcrlf
	else
		strConfirmPwd = trim(request.form("confirmpwd"))
	end if

	strPwd = trim(request.form("pwd"))	
	set rsModifyPwd = server.createobject("ADODB.Recordset")
	strSqlModifyPwd = "select adminpwd from admin where adminname='" & request.cookies("aoyi")("adminname") & "'"
	rsModifyPwd.open strSqlModifyPwd,G_CONN,1,3
		
	'验证操作员记录是否存在
	if rsModifyPwd.bof or rsModifyPwd.eof then
		rsModifyPwd.close
		set rsModifyPwd = nothing
		response.redirect "student_login.asp"
	end if
	'验证旧密码是否正确		
	if rsModifyPwd("adminpwd") <> strPwd then
		strErr = strErr & "<li>原密码错误！</li>" & vbcrlf
	end if
		
	if strErr = "" then
		'如果通过验证则进行操作员的密码修改
		rsModifyPwd("adminpwd") = strPwd
		rsModifyPwd.update
%>
	<table align="center" width="500" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF"><strong>&nbsp;修&nbsp;改&nbsp;密&nbsp;码&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				操作员<%=request.cookies("aoyi")("adminname")%> 的密码已经成功修改！<br>
				<a href="admin_index_main.asp" target="_top">返回首页</a>
			</td>
		</tr>
	</table>
<%
	else	'没有通过验证则显示错误信息
		showErrMsg(strErr)
	end if
	rsModifyPwd.close
	set rsModifyPwd = nothing
end sub
%>
</body>
</html>
