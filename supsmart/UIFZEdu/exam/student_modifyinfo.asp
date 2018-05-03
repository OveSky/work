<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>修改考生信息</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
'根据不同的参数值决定是修改考生提交的信息还是显示考生信息修改页面
if checkStudentLogin() = true then
	if request.form("action") = "modify" then
		call modifyInfo()
	else
		call showModifyInfo()
	end if
else
	response.redirect "student_login.asp"
end if

'显示修改考生信息页面
sub showModifyInfo()
	dim rsInfo,strSqlInfo
	
	set rsInfo = server.createobject("ADODB.Recordset")
	strSqlInfo = "select * from student where username='" & request.cookies("aoyi")("username") & "'"
	rsInfo.open strSqlInfo,G_CONN,1,1
	if rsInfo.bof or rsInfo.eof then
		rsInfo.close
		set rsInfo = nothing
		response.redirect "/student_login.asp"
	end if
%>
	<form action="/student_modifyinfo.asp" method="post">
		<input name="action" type="hidden" value="modify">
	<table align="center" width="90%" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td colspan="3" align="center">
				<font color="#FFFFFF"><strong>&nbsp;修&nbsp;改&nbsp;信&nbsp;息&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				登录名称：
			</td>
			<td>
				<%=rsInfo("username")%>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				真实姓名：
			</td>
			<td>
				<input name="studentname" class="text" type="text" size="18" maxlength="25" value="<%=rsInfo("studentname")%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				性别：
			</td>
			<td>
				<input name="sex" type="radio" value="1"
				<%
				if rsInfo("sex") = true then
					response.write "checked"
				end if
				%>
				> 男&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="sex" type="radio" value="0"
				<%
				if rsInfo("sex") = false then
					response.write "checked"
				end if
				%>
				> 女
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				出生日期：
			</td>
			<td>
				<input name="birthday" class="text" type="text" size="14" maxlength="20" value="<%=FormatDatetime(rsInfo("birthday"),2)%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				E-mail地址：
			</td>
			<td>
				<input name="email" class="text" type="text" size="20" maxlength="128" value="<%=rsInfo("email")%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				电话号码：
			</td>
			<td>
				<input name="tel" class="text" type="text" size="20" maxlength="50" value="<%=rsInfo("tel")%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td colspan="2" height="30" align="center">
				<input type="submit" value="&nbsp;修&nbsp;&nbsp;改&nbsp;">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="reset" value="&nbsp;复&nbsp;&nbsp;原&nbsp;">
			</td>
		</tr>

	</table>
	</form>
<%
	rsInfo.close
	set rsInfo = nothing
end sub

'修改考生信息
sub modifyInfo()
	dim rsModifyInfo,strSqlModifyInfo,strStudentName,blnSex,strTel,strEmail,dteBirthday,strErr
	
	strErr = ""
	'验证考生提交的信息是否合法
	if trim(request.form("studentname")) = "" then
		strErr = strErr & "<li>真实姓名为空。</li>" & vbcrlf
	else
		strStudentName = trim(request.form("studentname"))
	end if
	if IsDate(trim(request.form("birthday"))) = false then
		strErr = strErr & "<li>出生日期未填写或格式不正确。</li>" & vbcrlf
	else
		dteBirthday = CDate(trim(request.form("birthday")))
	end if
	if CInt(request.form("sex")) > 0 then
		blnSex = true
	else
		blnSex = false
	end if
	strEmail = trim(request.form("email"))
	strTel = trim(request.form("tel"))
		
	if strErr = "" then
		'如果通过验证则进行考生信息的修改并显示成功信息
		set rsModifyInfo = server.createobject("ADODB.Recordset")
		strSqlModifyInfo = "select * from student where username='" & request.cookies("aoyi")("username") & "'"
		rsModifyInfo.open strSqlModifyInfo,G_CONN,1,3
		'验证考生记录是否存在
		if rsModifyInfo.bof or rsModifyInfo.eof then
			rsModifyInfo.close
			set rsModifyInfo = nothing
			response.redirect "/student_login.asp"
		end if
		'修改考生信息
		rsModifyInfo("studentname") = strStudentName
		rsModifyInfo("sex") = blnSex
		rsModifyInfo("birthday") = dteBirthday
		rsModifyInfo("email") = strEmail
		rsModifyInfo("tel") = strTel
		rsModifyInfo.update
		rsModifyInfo.close
		set rsModifyInfo = nothing
%>
	<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF"><strong>&nbsp;修&nbsp;改&nbsp;信&nbsp;息&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				考生 <%=request.cookies("studentname")%> 的信息已经成功修改！<br>
				<a href="/index.asp" target="_top">返回首页</a>
			</td>
		</tr>
	</table>
<%
	else	'没有通过验证则显示错误信息
		showErrMsg(strErr)
	end if
end sub
%>
</body>
</html>