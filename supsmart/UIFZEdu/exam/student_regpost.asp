<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考生注册</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
	dim strErr	'错误信息
	dim strUserName,strPwd,strStudentName,strTel,strEmail,blnSex,dteBirthday,intStudentType
	dim strSqlReg,rsReg	'定义查询语言字符串，Recordset对象
	
	set rsReg =  Server.CreateObject("ADODB.Recordset")	'建立ADO对象

	'下面进行用户注册信息的有效性验证
	strErr = ""
	'用户名验证
	if trim(request.form("username")) = "" then
		strErr = strErr & "<li>用户名为空</li>" & vbcrlf
	else
		strUserName = trim(request.form("username"))
		'判断系统内是否已存在此用户名
		strSqlReg = "select studentid from student where username='" & strUserName & "'"
		rsReg.open strSqlReg,G_CONN,1,1
		if not rsReg.bof or not rsReg.eof then
			strErr = strErr & "<li>此用户名已存在</li>" & vbcrlf
		end if
		rsReg.close
	end if
	'密码验证
	if trim(request.form("pwd")) = "" then
		strErr = strErr & "<li>密码为空</li>" & vbcrlf
	elseif trim(request.form("pwd")) <> trim(request.form("confirmpwd")) then
		strErr = strErr & "<li>密码与确认密码不符</li>" & vbcrlf
	else
		strPwd = trim(request.form("pwd"))
	end if
	'出生日期验证
	if not IsDate(trim(request.form("birthday"))) then
		strErr = strErr & "<li>生日输入错误</li>" & vbcrlf
	else
		dteBirthday = CDate(trim(request.form("birthday")))
	end if
	'真实姓名验证
	if trim(request.form("studentname")) = "" then
		strErr = strErr & "<li>真实姓名为空</li>" & vbcrlf
	else
		strStudentName = trim(request.form("studentname"))
	end if
	'性别验证
	if CInt(trim(request.form("sex"))) > 0 then
		blnSex = true
	else
		blnSex = false
	end if
	strEmail = trim(request.form("email"))
	strTel = trim(request.form("tel"))
	
	if strErr = "" then	'通过验证则把注册信息添加到数据库并给予用户成功注册信息，返回首页
		'往数据库中添加注册信息
		strSqlReg = "select * from student where studentid=0"
		rsReg.open strSqlReg,G_CONN,1,3
		rsReg.addnew
		rsReg("username") = strUserName
		rsReg("studentpwd") = strPwd
		rsReg("studentname") = strStudentName
		rsReg("sex") = blnSex
		rsReg("email") = strEmail
		rsReg("tel") = strTel
		rsReg("birthday") = dteBirthday
		rsReg("studenttype") = 0	'考生类型，0为待审批的考生。
		rsReg.update
		'释放资源，关闭数据库连接
		rsReg.close
		set rsReg = nothing
		call closeConn()
		'显示成功信息
%>
	<table width="500" align="center" cellspacing="1" cellpadding="5" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF">注&nbsp;&nbsp;&nbsp;&nbsp;册&nbsp;&nbsp;&nbsp;&nbsp;成&nbsp;&nbsp;&nbsp;&nbsp;功</font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				恭喜你！<br>
				你已经成功完成注册过程，请等待管理员审批，只有管理员审批过后你才能登录本系统。<br>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center" height="30">
				<button onClick="window.open('index_main.asp','main');">&nbsp;返回首页&nbsp;</button>
			</td>
		</tr>
	</table>
<%
	else	'未通过验证则显示错误信息，并返回注册页面
%>
	<table width="500" align="center" cellspacing="1" cellpadding="5" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF">注&nbsp;&nbsp;&nbsp;&nbsp;册&nbsp;&nbsp;&nbsp;&nbsp;失&nbsp;&nbsp;&nbsp;&nbsp;败</font>
			</td>
		</tr>
		<tr class="tdbg">
			<td>
				注册失败可能由以下原因造成：<br>
				<%=strErr%>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				<button onClick="history.go(-1);">&nbsp;返回上一页&nbsp;</button>
			</td>
		</tr>
	</table>
<%
	end if	
%>
</body>
</html>
