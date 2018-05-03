<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
option explicit
Response.expires=-1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","no-store"
%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新视点在线考试系统-后台管理</title>
<link href="admin.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			&nbsp;&nbsp;操&nbsp;&nbsp;作&nbsp;&nbsp;员&nbsp;&nbsp;管&nbsp;&nbsp;理&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_admin.asp">操作员管理首页</a> | <a href="admin_admin.asp?action=add">添加操作员</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction

if checkAdminLogin() = false then	'进行管理员登录验证
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_ADMIN) = false then
	response.write "<center><font size=4>你没有进行此操作的权限，请与系统管理员联系！</font></center>"
	response.write "</body></html>"
	response.end
end if
strAction = trim(request.form("action"))
if strAction = "" then
	strAction = trim(request.querystring("action"))
end if
select case strAction
	case "del"
		call del()	'删除操作员
	case "modify"
		call modify()	'修改操作员界面
	case "savemodify"
		call saveModify()	'保存修改结果
	case "add"
		call add()	'添加操作员界面
	case "saveadd"
		call saveAdd()	'保存添加结果
	case else
		call main()	'主界面
end select
call closeConn()

sub main()	'主界面
	dim rsAdmin,strSqlAdmin
%>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="130" align="center"> 操作员ID</td>		
		<td align="center"> 登 录 名 称 </td>
		<td width="150" align="center"> 操 作 </td>
	</tr>
	<%
	set rsAdmin = server.createobject("ADODB.Recordset")
	strSqlAdmin = "select * from admin"
	rsAdmin.open strSqlAdmin,G_CONN,1,1
	if rsAdmin.bof and rsAdmin.eof then
		response.write "<tr class='tdtbg'><td colspan='3' align='center'>没有操作员</td></tr>"
	end if
	while not rsAdmin.eof
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'>" & rsAdmin("adminid") & "</td>"
		response.write "<td>" & rsAdmin("adminname") & "</td>"
		response.write "<td align='center'>"
		if rsAdmin("adminname") <> "admin" then
			response.write "<a href='#' onClick=""if(confirm('即将删除此操作员，确认删除吗？') == true) window.open('admin_admin.asp?action=del&adminid=" & rsAdmin("adminid") & "','_self')"">删除</a> | "
			response.write "<a href='admin_admin.asp?action=modify&adminid=" & rsAdmin("adminid") & "'>修改</a>"
		end if
		response.write "</td></tr>"
		rsAdmin.movenext
	wend
	rsAdmin.close
	set rsAdmin = nothing
	%>
</table>
</body>
</html>
<%
end sub

sub add()	'添加操作员界面
%>
<form action="admin_admin.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 添 加 操 作 员 </td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">登录名称：</td>
		<td>
			<input name="adminname" type="text" class="text" size="20" maxlength="25" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">登录密码：</td>
		<td>
			<input name="adminpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">确认密码：</td>
		<td>
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">权限设置：</td>
		<td>
			<input name="adminpurview_subject" type="checkbox" value="1">维护试题&nbsp;&nbsp;
			<input name="adminpurview_student" type="checkbox" value="2">维护考生档案&nbsp;&nbsp;
			<input name="adminpurview_project" type="checkbox" value="4">维护考试计划&nbsp;&nbsp;
			<input name="adminpurview_course" type="checkbox" value="8">维护课程档案
		</td>
	</tr>
	<tr class="tdbg">
		<td colspan="2" align="center" height="30">
			<input type="submit" value="&nbsp;添&nbsp;&nbsp;加&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveAdd()	'保存添加结果
	dim strAdminName,strAdminPwd,intAdminPurview,strErr
	
	strErr = ""
	if IsNumeric(Trim(request.form("adminpurview_subject"))) = true then
		intAdminPurview = CLng(trim(request.form("adminpurview_subject")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_student"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_student")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_project"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_project")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_course"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_course")))
	end if
	strAdminName = trim(request.form("adminname"))
	strAdminPwd = trim(request.form("adminpwd"))
	if intAdminPurview < 1 or intAdminPurview > 15 then
		strErr = "<li>权限设置错误！</li>"
	end if
	if strAdminPwd <> trim(request.form("confirmpwd")) then
		strErr = strErr & "<li>密码与确认密码不符！</li>"
	end if
	if strAdminName = "" then
		strErr = strErr & "<li>用户名为空！</li>"
	end if
	if G_CONN.execute("select count(*) as reccount from admin where adminname='" & strAdminName & "'")("reccount") > 0 then
		strErr = strErr & "<li>系统中已存在此用户名！</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	G_CONN.execute "insert into admin (adminname,adminpwd,adminpurview) values ('" & Replace(strAdminName,"'","''") & "','" & Replace(strAdminPwd,"'","''") & "'," & intAdminPurview & ")"
	call closeConn()
	response.redirect "admin_admin.asp"
end sub

sub modify()	'修改操作员界面
	dim rsAdmin,strSqlAdmin,intAdminID,strErr
	
	strErr = ""
	intAdminID = CLng(trim(request.querystring("adminid")))
	strSqlAdmin = "select * from admin where adminid=" & intAdminID
	set rsAdmin = server.createobject("ADODB.Recordset")
	rsAdmin.open strSqlAdmin,G_CONN,1,1
	if rsAdmin.bof and rsAdmin.eof then
		strErr = "<li>此操作员不存在！</li>"
	elseif rsAdmin("adminname") = "admin" then
		strErr = "<li>超级管理员不能被修改！</li>"
	end if
	if strErr <> "" then
		rsAdmin.close
		set rsAdmin = nothing
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
%>
<form action="admin_admin.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="adminid" type="hidden" value="<%=rsAdmin("adminid")%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 修 改 操 作 员 </td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">登录名称：</td>
		<td>
			<input name="adminname" type="text" class="text" size="20" maxlength="25" value="<%=rsAdmin("adminname")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">登录密码：(留空不修改)</td>
		<td>
			<input name="adminpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">确认密码：(留空不修改)</td>
		<td>
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">权限设置：</td>
		<td>
			<input name="adminpurview_subject" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_SUBJECT) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="1">维护试题&nbsp;&nbsp;
			<input name="adminpurview_student" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_STUDENT) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="2">维护考生档案&nbsp;&nbsp;
			<input name="adminpurview_project" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_PROJECT) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="4">维护考试计划&nbsp;&nbsp;
			<input name="adminpurview_course" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_COURSE) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="8">维护课程档案
		</td>
	</tr>
	<tr class="tdbg">
		<td colspan="2" align="center">
			<input type="submit" value="&nbsp;修&nbsp;&nbsp;改&nbsp;">&nbsp;&nbsp;
			<input type="reset" value="&nbsp;重&nbsp;&nbsp;写&nbsp;">
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%
	rsAdmin.close
	set rsAdmin = nothing
end sub

sub saveModify()	'保存修改结果
	dim rsAdmin,strSqlAdmin,intAdminID,strAdminName,strAdminPwd,intAdminPurview,strErr
	strErr = ""
	intAdminID = CLng(Trim(request.form("adminid")))
	if IsNumeric(Trim(request.form("adminpurview_subject"))) = true then
		intAdminPurview = CLng(Trim(request.form("adminpurview_subject")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_student"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_student")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_project"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_project")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_course"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_course")))
	end if
	strAdminName = Trim(request.form("adminname"))
	strAdminPwd = Trim(request.form("adminpwd"))
	if intAdminPurview < 1 or intAdminPurview > 15 then
		strErr = "<li>权限设置错误！</li>"
	end if
	if strAdminPwd <> Trim(request.form("confirmpwd")) then
		strErr = strErr & "<li>密码与确认密码不符！</li>"
	end if
	if strAdminName = "" then
		strErr = strErr & "<li>用户名为空！</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	set rsAdmin = server.createobject("ADODB.Recordset")
	strSqlAdmin = "select * from admin where adminid=" & intAdminID
	rsAdmin.open strSqlAdmin,G_CONN,1,3
	if rsAdmin.bof and rsAdmin.eof then
		strErr = "<li>要修改的用户不存在！</li>"
	elseif strAdminName <> rsAdmin("adminname") and G_CONN.execute("select count(*) as reccount from admin where adminname='" & Replace(strAdminName,"'","''") & "'")("reccount") > 0 then
		strErr = "<li>此用户名已被其他人使用！</li>"
	end if
	if strErr <> "" then
		rsAdmin.close
		set rsAdmin = nothing
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	rsAdmin("adminname") = strAdminName
	if strAdminPwd <> "" then
		rsAdmin("adminpwd") = strAdminPwd
	end if
	rsAdmin("adminpurview") = intAdminPurview
	rsAdmin.update
	rsAdmin.close
	set rsAdmin = nothing
	call closeConn()
	response.redirect "admin_admin.asp"
end sub

sub del()	'删除操作员
	dim intAdminID,strErr
	
	intAdminID = CLng(Trim(request.querystring("adminid")))
	if G_CONN.execute("select * from admin where adminid=" & intAdminID)("adminname") = "admin" then
		strErr = "<li>超级管理不能被删除！</li>"
		call closeConn()
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	G_CONN.execute "delete from admin where adminid=" & intAdminID
	call closeConn()
	response.redirect "admin_admin.asp"
end sub
%>