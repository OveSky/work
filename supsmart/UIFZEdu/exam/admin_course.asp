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

<title>课程管理</title>
<link href="admin.css" rel="stylesheet" type="text/css">
</head>
<body>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			&nbsp;&nbsp;课&nbsp;&nbsp;程&nbsp;&nbsp;管&nbsp;&nbsp;理&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_course.asp">课程管理首页</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction

if checkAdminLogin() = false then	'进行管理员登录验证
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_COURSE) = false then
	response.write "<center><font size=4>你没有进行此操作的权限，请与系统管理员联系！</font></center>"
	response.write "</body></html>"
	response.end
end if
strAction = trim(request.form("action"))
if strAction = "" then
	strAction = trim(request.querystring("action"))
end if
select case strAction
	case "saveupdate"
		call saveUpdate()
	case "del"
		call delCourse()
	case else
		call main()
end select
call closeConn()
%>
</body>
</html>
<%

sub main()	'主界面
	dim rsCourse,strSqlCourse
%>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			添 加 / 修 改 课 程 档 案
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			&nbsp;如果要添加课程档案，请把课程ID删除。<br>
			<a name="form">
			<form name="frmUpdate" action="admin_course.asp" method="post">
				<input name="action" type="hidden" value="saveupdate">
				课程ID：<input name="courseid" class="text" type="text" size="10" value="">&nbsp;&nbsp;
				课程名称：<input name="coursename" class="text" type="text" size="40" maxlength="128" value="">&nbsp;&nbsp;
				<input type="submit" value="&nbsp;更&nbsp;&nbsp;新&nbsp;">
			</form>
		</td>
	</tr>
</table>
<br>

<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="70" align="center"> 课 程 ID</td>		
		<td align="center"> 课 程 名 称 </td>
		<td width="150" align="center"> 操 作 </td>
	</tr>
	<%
	set rsCourse = server.createobject("ADODB.Recordset")
	strSqlCourse = "select * from course order by courseid desc"
	rsCourse.open strSqlCourse,G_CONN,1,1
	if rsCourse.bof and rsCourse.eof then
		response.write "<tr class='tdbg'><td colspan='3' align='center'>没有课程档案</td></tr>"
	end if
	while not rsCourse.eof
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'>" & rsCourse("courseid") & "</td>"
		response.write "<td>" & rsCourse("coursename") & "</td>"
		response.write "<td align='center'><a href='#' onClick=""if(confirm('即将删除此课程和此课程的所有考题，确认删除吗？') == true) window.open('admin_course.asp?action=del&courseid=" & rsCourse("courseid") & "','_self')"">删除</a> | "
		response.write "<a href='#form' onClick=""document.all.frmUpdate.courseid.value=" & rsCourse("courseid") & ";document.all.frmUpdate.coursename.value='" & rsCourse("coursename") & "';"">修改</a>"
		response.write "</td></tr>"
		rsCourse.movenext
	wend
	rsCourse.close
	set rsCourse = nothing
	%>
</table>
<%
end sub

'修改或添加课程档案
sub saveUpdate()
	dim rsCourse,strSqlCourse,intCourseID,strCourseName,strErr
	
	strCourseName = trim(request.form("coursename"))
	if strCourseName = "" then
		strErr = "<li>课程名为空！</li>"
	end if
	if trim(request.form("courseid")) <> "" then	'验证是否传递了ID号。
		intCourseID = Abs(CLng(trim(request.form("courseid"))))
	else
		intCourseID = -1
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		exit sub
	end if
	set rsCourse = server.createobject("ADODB.Recordset")
	strSqlCourse = "select * from course where courseid=" & intCourseID
	rsCourse.open strSqlCourse,G_CONN,1,3
	if rsCourse.bof and rsCourse.eof and intCourseID = -1 then	'当没有ID存在时添加课程
		rsCourse.addnew
		rsCourse("coursename") = strCourseName
		rsCourse.update
	elseif not rsCourse.bof and not rsCourse.eof then	'有ID存在并且ID存在于数据库时就修改课程
		rsCourse("coursename") = strCourseName
		rsCourse.update
	end if
	rsCourse.close
	set rsCourse = nothing
	call closeConn()
	response.redirect "admin_course.asp"
end sub

'删除课程档案  注意：只有没有被其他表使用的课程才可以删除
sub delCourse()
	dim intCourseID,strErr
	strErr = ""
	intCourseID = CLng(trim(request.querystring("courseid")))
	if G_CONN.execute("select count(*) as reccount from project where courseid=" & intCourseID)("reccount") > 0 then
		strErr = "<li>此课程已经被考试计划使用，不能删除！</li>"
	end if
	if strErr = "" then
		G_CONN.begintrans		'开始事务
		G_CONN.execute "delete from subject where courseid=" & intCourseID
		G_CONN.execute "delete from course where courseid=" & intCourseID
		G_CONN.committrans	'结束事务
		call closeConn()
		response.redirect "admin_course.asp"
	else
		showErrMsg(strErr)
	end if
end sub
%>
