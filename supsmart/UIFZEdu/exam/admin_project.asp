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
<title>考试计划管理</title>
<link href="admin.css" rel="stylesheet" type="text/css">
<style>
body {
	font-size:12px;
}
</style>
</head>

<body>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			&nbsp;&nbsp;考&nbsp;&nbsp;试&nbsp;&nbsp;计&nbsp;&nbsp;划&nbsp;&nbsp;管&nbsp;&nbsp;理&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_project.asp">考试计划首页</a> | <a href="admin_project.asp?action=add">添加考试计划</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction

if checkAdminLogin() = false then	'进行管理员登录验证
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_PROJECT) = false then
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
		call del()	'删除考试计划
	case "modify"
		call modify()	'修改考考试计划界面
	case "savemodify"
		call saveModify()	'保存修改结果
	case "add"
		call add()	'添加考试计划界面
	case "saveadd"
		call saveAdd()	'保存添加结果
	case else
		call main()	'主界面
end select
%>
</body>
</html>
<%
call closeConn()

sub main()	'主界面
	'定义：Recordset对象，SQL字串，当前页面号，最大页面号，每页显示考试计划数，当前在本页第几条记录
	dim rsProject,strSqlProject,intCurPage,intMaxPage,intMaxPerPage,intCurRec,I
	
	intMaxPerPage = 20	'设定每页20个考试计划
	intCurPage = CLng(request.querystring("page"))
	
%>

<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="60" align="center"> ID </td>
		<td align="center"> 考试名称 </td>
		<td width="100" align="center"> 课程名称 </td>
		<td width="100" align="center"> 开始时间 </td>
		<td width="100" align="center"> 结束时间 </td>
		<td width="100" align="center"> 操 作 </td>
	</tr>
	<%
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select P.*,C.coursename from project P,course C where P.courseid=C.courseid"
	rsProject.open strSqlProject,G_CONN,1,1
	if rsProject.bof and rsProject.eof then
		response.write "<tr class='tdbg'><td colspan='7' align='center'>没有考试计划</td></tr>"
	end if
	rsProject.pagesize = intMaxPerPage
	intMaxPage = rsProject.pagecount
	if intCurPage > rsProject.pagecount then
		intCurPage = rsProject.pagecount
	elseif intCurPage < 1 then
		intCurPage = 1
	end if
	if rsProject.pagecount > 0 then
		rsProject.absolutepage = intCurPage
	end if
	intCurRec = 1
	while not rsProject.eof and intCurRec <= intMaxPerPage
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'>" & rsProject("prjid") & "</td>"
		response.write "<td align='center'>" & rsProject("prjname") & "</td>"
		response.write "<td align='center'>" & rsProject("coursename") & "</td>"
		response.write "<td align='center'>" & FormatDatetime(rsProject("starttime"),2) & "</td>"
		response.write "<td align='center'>" & FormatDatetime(rsProject("endtime"),2) & "</td>"
		response.write "<td align='center'>"
		response.write "<a href='#' onClick=""if(confirm('删除此考试计划将连同与此考试计划有关的考试记录,你确认吗?') == true) window.open('admin_project.asp?action=del&prjid=" & rsProject("prjid") & "&page=" & intCurPage & "','_self')"">删除</a> | "
		response.write "<a href='admin_project.asp?action=modify&prjid=" & rsProject("prjid") & "&page=" & intCurPage & "'>修改</a> "
		response.write "</td></tr>"
		rsProject.movenext
		intCurRec = intCurRec + 1
	wend
	rsProject.close
	set rsProject = nothing
	%>
</table>
<center>
<%
call showPageCtrl(intMaxPage,intCurPage,"admin_project.asp?page=")
%>
</center>
<%
end sub

sub add()	'添加考试计划界面
%>
<form action="admin_project.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 添加考试计划 </td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">考试计划名称：</td>
		<td>
			<input name="prjname" type="text" class="text" size="25" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">计划开始时间：</td>
		<td>
			<input name="starttime" type="text" class="text" size="18" maxlength="20" value="<%=FormatDatetime(Date(),2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">计划结束时间：</td>
		<td>
			<input name="endtime" type="text" class="text" size="20" maxlength="50" value="<%=FormatDatetime(Date() + 7,2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">考试限制时间：</td>
		<td>
			<input name="limittime" type="text" class="text" size="6" maxlength="5" value="90"> 分钟
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right"> 考试课程：</td>
		<td>
			<%
			call showCourseList(1)
			%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">单选题数量：</td>
		<td>
			<input name="ss_count" type="text" class="text" size="6" maxlength="5" value="40">
			每题1分
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">多选题数量：</td>
		<td>
			<input name="ms_count" type="text" class="text" size="6" maxlength="5" value="20">
			每题2分
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">是非题数量：</td>
		<td>
			<input name="b_count" type="text" class="text" size="6" maxlength="5" value="20">
			每题1分
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" height="30" colspan="2">
			<input type="submit" value="&nbsp;添&nbsp;&nbsp;加&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveAdd()	'保存添加结果
	dim rsProject,strSqlProject,strPrjName,dtmStartTime,dtmEndTime,intLimitTime,intCourseID
	dim intSS_Count,intMS_Count,intB_Count,strErr
	
	strErr = ""
	strPrjName = trim(request.form("prjname"))
	if strPrjName = "" then
		strErr = "<li>考试计划名称为空！</li>"
	end if
	if IsDate(trim(request.form("starttime"))) = false then
		strErr = strErr & "<li>计划开始时间格式不正确！</li>"
	else
		dtmStartTime = CDate(trim(request.form("starttime")))
	end if
	if IsDate(trim(request.form("endtime"))) = false then
		strErr = strErr & "<li>计划结束时间格式不正确！</li>"
	else
		dtmEndTime = CDate(trim(request.form("endtime")))
	end if
	if IsNumeric(Trim(request.form("ss_count"))) = true then
		intSS_Count = CLng(Trim(request.form("ss_count")))
	else
		intSS_Count = 0
	end if
	if IsNumeric(Trim(request.form("ms_count"))) = true then
		intMS_Count = CLng(Trim(request.form("ms_count")))
	else
		intMS_Count = 0
	end if
	if IsNumeric(Trim(request.form("b_count"))) = true then
		intB_Count = CLng(Trim(request.form("b_count")))
	else
		intB_Count = 0
	end if
	if IsNumeric(Trim(request.form("courseid"))) = true then
		intCourseID = CLng(Trim(request.form("courseid")))
	else
		strErr = strErr & "<li>课程选择错误！</li>"
	end if
	if G_CONN.Execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = 0 then
		strErr = strErr & "<li>课程选择错误！</li>"
	end if
	if IsNumeric(Trim(request.form("limittime"))) = true then
		intLimitTime = CLng(Trim(request.form("limittime")))
	else
		strErr = strErr & "<li>请填写考试限制时间！</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		exit sub
	end if
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select * from project where prjid=0"
	rsProject.open strSqlProject,G_CONN,1,3
	rsProject.addnew
	rsProject("prjname") = strPrjName
	rsProject("starttime") = dtmStartTime
	rsProject("endtime") = dtmEndTime
	rsProject("settime") = now()
	rsProject("ss_count") = intSS_Count
	rsProject("ms_count") = intMS_Count
	rsProject("b_count") = intB_Count
	rsProject("limittime") = intLimitTime
	rsProject("courseid") = intCourseID
	rsProject("setadmin") = G_CONN.execute("select adminid from admin where adminname='" & request.cookies("aoyi")("adminname") & "'")("adminid")
	rsProject.update
	rsProject.close
	set rsProject = nothing
	call closeConn()
	response.redirect "admin_Project.asp"
end sub

sub modify()	'修改考试计划界面
	dim rsProject,strSqlProject,intPrjID,strErr
	if IsNumeric(Trim(request.querystring("prjid"))) = true then
		intPrjID = CLng(Trim(request.querystring("prjid")))
	else
		strErr = "<li>请正确选择考试计划！</li>"
		showErrMsg(strErr)
		exit sub
	end if
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select * from project where prjid=" & intPrjID
	rsProject.open strSqlProject,G_CONN,1,1
	if rsProject.bof and rsProject.eof then
		strErr = "<li>此考试计划不存在！</li>"
		showErrMsg(strErr)
		exit sub
	end if
%>
<form action="admin_project.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="prjid" type="hidden" value="<%=intPrjID%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 修改考试计划 </td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">考试计划名称：</td>
		<td>
			<input name="prjname" type="text" class="text" size="25" maxlength="128" value="<%=rsProject("prjname")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">计划开始时间：</td>
		<td>
			<input name="starttime" type="text" class="text" size="18" maxlength="20" value="<%=FormatDatetime(rsProject("starttime"),2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">计划结束时间：</td>
		<td>
			<input name="endtime" type="text" class="text" size="20" maxlength="50" value="<%=FormatDatetime(rsProject("endtime"),2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">考试限制时间：</td>
		<td>
			<input name="limittime" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("limittime")%>"> 分钟
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right"> 考试课程：</td>
		<td>
			<%
			call showCourseList(CLng(rsProject("courseid")))
			%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">单选题数量：</td>
		<td>
			<input name="ss_count" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("ss_count")%>">
			每题1分
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">多选题数量：</td>
		<td>
			<input name="ms_count" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("ms_count")%>">
			每题2分
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">是非题数量：</td>
		<td>
			<input name="b_count" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("b_count")%>">
			每题1分
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" height="30" colspan="2">
			<input type="submit" value="&nbsp;修&nbsp;&nbsp;改&nbsp;">&nbsp;&nbsp;
			<input type="reset" value="&nbsp;重&nbsp;&nbsp;写&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
	rsProject.close
	set rsProject = nothing
end sub

sub saveModify()	'保存修改结果
	dim rsProject,strSqlProject,intPrjID,strPrjName,dtmStartTime,dtmEndTime,intLimitTime
	dim intCourseID,intSS_Count,intMS_Count,intB_Count,strErr
	
	strErr = ""
	strPrjName = trim(request.form("prjname"))
	if strPrjName = "" then
		strErr = "<li>考试计划名称为空！</li>"
	end if
	if IsDate(trim(request.form("starttime"))) = false then
		strErr = strErr & "<li>计划开始时间格式不正确！</li>"
	else
		dtmStartTime = CDate(trim(request.form("starttime")))
	end if
	if IsDate(trim(request.form("endtime"))) = false then
		strErr = strErr & "<li>计划结束时间格式不正确！</li>"
	else
		dtmEndTime = CDate(trim(request.form("endtime")))
	end if
	if IsNumeric(Trim(request.form("prjid"))) = true then
		intPrjID = CLng(Trim(request.form("prjid")))
	else
		strErr = strErr & "<li>此考试计划不存在！</li>"
	end if
	if IsNumeric(Trim(request.form("ss_count"))) = true then
		intSS_Count = CLng(Trim(request.form("ss_count")))
	else
		intSS_Count = 0
	end if
	if IsNumeric(Trim(request.form("ms_count"))) = true then
		intMS_Count = CLng(Trim(request.form("ms_count")))
	else
		intMS_Count = 0
	end if
	if IsNumeric(Trim(request.form("b_count"))) = true then
		intB_Count = CLng(Trim(request.form("b_count")))
	else
		intB_Count = 0
	end if
	if IsNumeric(Trim(request.form("courseid"))) = true then
		intCourseID = CLng(Trim(request.form("courseid")))
	else
		strErr = strErr & "<li>课程选择错误！</li>"
	end if
	if G_CONN.Execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = 0 then
		strErr = strErr & "<li>课程选择错误！</li>"
	end if
	if IsNumeric(Trim(request.form("limittime"))) = true then
		intLimitTime = CLng(Trim(request.form("limittime")))
	else
		strErr = strErr & "<li>请填写考试限制时间！</li>"
	end if
	if G_CONN.execute("select count(*) as reccount from prj_student where state<>1 and prjid=" & intPrjID)("reccount") > 0 then
		strErr = strErr & "<li>此考试计划正在使用中，不能修改！</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		exit sub
	end if
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select * from project where prjid=" & intPrjID
	rsProject.open strSqlProject,G_CONN,1,3
	if rsProject.bof and rsProject.eof then
		strErr = "<li>此考试计划不存在！</li>"
		rsProject.close
		set rsProject = nothing
		showErrMsg(strErr)
		exit sub
	end if
	rsProject("prjname") = strPrjName
	rsProject("starttime") = dtmStartTime
	rsProject("endtime") = dtmEndTime
	rsProject("settime") = now()
	rsProject("ss_count") = intSS_Count
	rsProject("ms_count") = intMS_Count
	rsProject("b_count") = intB_Count
	rsProject("limittime") = intLimitTime
	rsProject("courseid") = intCourseID
	rsProject("setadmin") = G_CONN.execute("select adminid from admin where adminname='" & request.cookies("aoyi")("adminname") & "'")("adminid")
	rsProject.update
	rsProject.close
	set rsProject = nothing
	call closeConn()
	response.redirect "admin_Project.asp"
end sub

sub del()	'删除考试计划
	dim intPrjID,strErr
	
	intPrjID = CLng(Trim(request.querystring("prjid")))
	if G_CONN.execute("select count(*) as reccount from project where starttime<=date() and endtime>=date() and prjid in (select prjid from prj_student) and prjid=" & intPrjID)("reccount") > 0 then
		strErr = "<li>在考试计划使用中不能删除此计划！</li>"
		showErrMsg(strErr)
		exit sub
	end if
	G_CONN.begintrans
	G_CONN.execute "delete from prj_process where prjid=" & intPrjID
	G_CONN.execute "delete from prj_student where prjid=" & intPrjID
	G_CONN.execute "delete from project where prjid=" & intPrjID
	G_CONN.committrans
	call closeConn()
	response.redirect "admin_project.asp"
end sub
%>