<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考生登录</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
dim intStudentID,strUserName,strPwd,strErr	'考生ID，考生登录名，密码，错误信息字符串
dim rsCheckLogin,strSqlCheckLogin	'定义ADO对象，查询字符串
'初始化cookies
response.cookies("aoyi")("username") = ""
response.cookies("aoyi")("studentid") = ""
response.cookies("aoyi")("studentname") = ""
response.cookies("aoyi")("sex") = ""
response.cookies("aoyi")("birthday") = ""
response.cookies("aoyi")("state") = ""
response.cookies("aoyi")("prjid") = ""
response.cookies("aoyi")("course") = ""
response.cookies("aoyi")("prjname") = ""
response.cookies("aoyi")("prjstarttime") = ""
strErr = ""
set rsCheckLogin = server.createobject("ADODB.Recordset")
strUserName = trim(request.form("username"))
strPwd = trim(request.form("pwd"))
if strUserName = "" then
	strErr = "<li>1用户名或密码错误！</li>" & vbcrlf
else
	strSqlCheckLogin = "select * from student where username='" & strUserName & "' and studentpwd='" & strPwd & "'"
	rsCheckLogin.open strSqlCheckLogin,G_CONN,1,1
	if rsCheckLogin.bof and rsCheckLogin.eof then
		strErr = "<li>用户名或密码错误！</li>" & vbcrlf
	elseif rsCheckLogin("studenttype") <> 1 then
		strErr = "<li>你已经提交过注册申请了，但是管理员还没有审批，请等待管理员审批后再进行登录。</li>" & vbcrlf
	end if
end if

if strErr = "" then
	response.cookies("aoyi")("username") = rsCheckLogin("username")
	response.cookies("aoyi")("studentid") = rsCheckLogin("studentid")
	response.cookies("aoyi")("studentname") = rsCheckLogin("studentname")
	if rsCheckLogin("sex") = true then
		response.cookies("aoyi")("sex") = "男"
	else
		response.cookies("aoyi")("sex") = "女"
	end if
	response.cookies("aoyi")("birthday") = rsCheckLogin("birthday")
	intStudentID = rsCheckLogin("studentid")
	rsCheckLogin.close
	strSqlCheckLogin = "select P_S.prjid,P_S.starttime,P.limittime from project P,prj_student P_S where state=2 and P.prjid=P_S.prjid and P_S.studentid=" & intStudentID
	rsCheckLogin.open strSqlCheckLogin,G_CONN,1,1
	if rsCheckLogin.bof and rsCheckLogin.eof then
		response.write "<script>window.open('index.asp','_top');</script>"
	else
		if DateDiff("n",rsCheckLogin("starttime"),now()) <= rsCheckLogin("limittime") then
			response.write "<script>if(confirm('你有正在进行的考试，要继续考试吗？')==true) window.open('index.asp?continue=true&prjid=" & rsCheckLogin("prjid") & "','_top'); else window.open('index.asp','_top');</script>"
		else
			call score(rsCheckLogin("prjid"),intStudentID)	'结束应该完成的考试
			response.write "<script>window.open('index.asp','_top');</script>"
		end if
	end if
else	'显示错误信息
	showErrMsg(strErr)
end if
rsCheckLogin.close
set rsCheckLogin = nothing
call closeConn()
%>
</body>
</html>
