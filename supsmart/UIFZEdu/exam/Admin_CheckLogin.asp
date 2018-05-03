<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<%
dim strAdminName,strAdminPwd,strErr
strErr = ""
strAdminName = Trim(request.form("adminname"))
strAdminPwd = Trim(request.form("adminpwd"))
if G_CONN.execute("select count(*) as reccount from admin where adminname='" & strAdminName & "' and adminpwd='" & strAdminPwd & "'")("reccount") = 0 then
	strErr = "<li>用户名或密码错误!</li>"
	showErrMsg(strErr)
else
	response.cookies("aoyi")("adminname") = strAdminName
end if
call closeConn()
if strErr = "" then
	response.redirect "admin_index.asp"
end if
%>