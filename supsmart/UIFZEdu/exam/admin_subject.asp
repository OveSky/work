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
<title>试题库管理</title>
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
			&nbsp;&nbsp;试&nbsp;&nbsp;题&nbsp;&nbsp;库&nbsp;&nbsp;管&nbsp;&nbsp;理&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_subject.asp">试题库管理首页</a> | <a href="admin_subject.asp?action=add">添加试题</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction
if checkAdminLogin() = false then	'进行管理员登录验证
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_SUBJECT) = false then
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
		call del()	'删除试题
	case "saveadd"
		call saveadd()	'保存添加结果
	case "add"	'添加试题界面
		call add()
	case "savemodify"	'保存修改结果
		call saveModify()
	case "modify"	'修改试题界面
		call modify()
	case else
		call main()	'主界面
end select

sub main()	'主界面
	dim rsSubject,strSqlSubject,intMaxPage,I,intMaxPerPage,intCurPage,intCurRec,intCourseID,intType
%>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="70" align="center">选中</td>
		<td width="100" align="center">试题ID</td>		
		<td width="100" align="center">类型</td>
		<td width="150" align="center">所属课程</td>
		<td width="150" align="center">操作</td>	
	</tr>
	<%
	intMaxPerPage = 18 '定义每页显示多少条题目
	if IsNumeric(Trim(request.querystring("page"))) = true then
		intCurPage = CLng(Trim(request.querystring("page")))
	else
		intCurPage = 1
	end if
	if IsNumeric(Trim(request.querystring("courseid"))) = true then
		intCourseID = CLng(Trim(request.querystring("courseid")))
	else
		intCourseID = 0
	end if
	if IsNumeric(Trim(request.querystring("type"))) = true then
		intType = CLng(Trim(request.querystring("type")))
	else
		intType = 0
	end if
	set rsSubject = server.createobject("ADODB.Recordset")
	strSqlSubject = "select S.*,C.coursename from subject S,course C where S.courseid=C.courseid"
	if intCourseID > 0 then
		strSqlSubject = strSqlSubject & " and C.courseid=" & intCourseID
	end if
	if intType > 0 then
		strSqlSubject = strSqlSubject & " and S.type=" & intType
	end if
	strSqlSubject = strSqlSubject & " order by id desc"
	rsSubject.open strSqlSubject,G_CONN,1,1
	rsSubject.pagesize = intMaxPerPage
	if intCurPage < 1 then
		intCurPage = 1
	elseif intCurPage > rsSubject.pagecount then
		intCurPage = rsSubject.pagecount
	end if
	intMaxPage = rsSubject.pagecount
	if not rsSubject.eof and not rsSubject.bof then
		rsSubject.absolutepage = intCurPage
	end if
	if rsSubject.bof or rsSubject.eof then
		response.write "<tr class='tdbg'><td colspan='6' align='center'>没有试题</td></tr>"
	end if
	intCurRec = 1
	while not rsSubject.eof and intCurRec <= intMaxPerPage
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'><input name='subjectid" & rsSubject("id") & "' onClick='checkup(this);' type='checkbox' value='" & rsSubject("id") & "'></td>"
		response.write "<td align='center'>" & rsSubject("id") & "</td>"
		response.write "<td align='center'><a href='admin_subject.asp?courseid=" & intCourseID & "&type=" & rsSubject("type") & "'>"
		select case rsSubject("type")
		case 1
			response.write "单选题"
		case 2
			response.write "多选题"
		case 3
			response.write "是非题"
		end select
		response.write "</a></td>"
		response.write "<td align='center'><a href='admin_subject.asp?courseid=" & rsSubject("courseid") & "&type=" & intType & "'>" & rsSubject("coursename") & "</a></td>"
		response.write "<td align='center'>"
		response.write "<a href='#' onClick=""if(confirm('即将删除此试题，确认删除吗？') == true) window.open('/admin_subject.asp?action=del&subjectid=" & rsSubject("id") & "')"">删除</a> | "
		response.write "<a href='admin_subject.asp?action=modify&subjectid=" & rsSubject("id") & "'>修改</a>"
		response.write "</td></tr>"
		rsSubject.movenext
		intCurRec = intCurRec + 1
	wend
	rsSubject.close
	set rsSubject = nothing
	call closeConn()
	%>
</table>
<center>
<%
call showPageCtrl(intMaxPage,intCurPage,"admin_subject.asp?courseid=" & intCourseID & "&type=" & intType & "&page=")
%>
</center>
<center>
<form name=frmDel>
	<input type="hidden" name="action" value="del">
	<input type="hidden" name="subjectid" value=",">
	<input type="submit" value="删除选中题目" onClick="delSubject(document.all.frmDel.subjectid);">
</form>
</center>
<script language="JAVAScript">
function delSubject(objSubjectid)
{
	if(objSubjectid.value == ",")
		objSubjectid.value = "0";
	else
		objSubjectid.value = objSubjectid.value.substring(1,objSubjectid.value.length - 1);
}
function checkup(objCheckbox)
{
	var strId = document.all.frmDel.subjectid.value;
	if(objCheckbox.checked == false)
		document.all.frmDel.subjectid.value = strId.replace(',' + objCheckbox.value + ',',',');
	else
		document.all.frmDel.subjectid.value = strId + objCheckbox.value + ',';
}
</script>
</body>
</html>
<%
end sub

sub add()	'添加试题界面
%>
<form name="frmAdd" action="admin_subject.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<input name="iscontinue" type="hidden" value="0">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 添 加 试 题 </td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">所属课程：</td>
		<td>
			<%call showCourseList(1)%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">试题内容：</td>
		<td>
			<textarea name="content" class="text" cols="50" rows="6"></textarea>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">试题类型：</td>
		<td>
			<input name="type" type="radio" checked value="1"> 单选题&nbsp;&nbsp;
			<input name="type" type="radio" value="2"> 多选题&nbsp;&nbsp;
			<input name="type" type="radio" value="3"> 是非题&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项1：</td>
		<td>
			<input name="option1" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项2：</td>
		<td>
			<input name="option2" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项3：</td>
		<td>
			<input name="option3" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项4：</td>
		<td>
			<input name="option4" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项5：</td>
		<td>
			<input name="option5" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项6：</td>
		<td>
			<input name="option6" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">正确答案：</td>
		<td>
			<input name="answer" type="radio" value="1">是&nbsp;&nbsp;
			<input name="answer" type="radio" value="0">否<br>
			<input name="answer1" type="checkbox" value="1"> 选项1&nbsp;&nbsp;
			<input name="answer2" type="checkbox" value="2"> 选项2&nbsp;&nbsp;
			<input name="answer3" type="checkbox" value="4"> 选项3&nbsp;&nbsp;
			<input name="answer4" type="checkbox" value="8"> 选项4&nbsp;&nbsp;
			<input name="answer5" type="checkbox" value="16"> 选项5&nbsp;&nbsp;
			<input name="answer6" type="checkbox" value="32"> 选项6
		</td>
	</tr>	

	<tr class="tdbg">
		<td height="30" colspan="2" align="center">
			<input type="submit" value="&nbsp;保&nbsp;&nbsp;存&nbsp;">&nbsp;&nbsp;
			<input type="submit" onClick="document.all.frmAdd.iscontinue.value='1';" value="&nbsp;保存并继续添加&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveAdd()	'保存添加结果
	dim rsSubject,strSqlSubject,strErr
	dim strContent,intType,intAnswer,intCourseID
	dim strOption1,strOption2,strOption3,strOption4,strOption5,strOption6
	
	strErr = ""
	strContent = Trim(request.form("content"))
	if strContent = "" then
		strErr = "<li>题目内容为空!</li>"
	end if
	intType = CLng(Trim(request.form("type")))
	if intType < 1 or intType > 3 then
		strErr = strErr & "<li>题目类型选择错误!</li>"
	end if
	intCourseID = CLng(Trim(request.form("courseid")))
	if G_CONN.execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = 0 then
		strErr = strErr & "<li>课程选择错误!</li>"
	end if
	strOption1 = Trim(request.form("option1"))
	strOption2 = Trim(request.form("option2"))
	strOption3 = Trim(request.form("option3"))
	strOption4 = Trim(request.form("option4"))
	strOption5 = Trim(request.form("option5"))
	strOption6 = Trim(request.form("option6"))
	if strOption1 & strOption2 & strOption3 & strOption4 & strOption5 & strOption6 = "" then
		strErr = strErr & "<li>至少要填写一个选项内容!</li>"
	end if
	if intType < 3 then
		if IsNumeric(Trim(request.form("answer1"))) = true then
			intAnswer = CLng(Trim(request.form("answer1")))
		end if
		if IsNumeric(Trim(request.form("answer2"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer2")))
		end if
		if IsNumeric(Trim(request.form("answer3"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer3")))
		end if
		if IsNumeric(Trim(request.form("answer4"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer4")))
		end if
		if IsNumeric(Trim(request.form("answer5"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer5")))
		end if
		if IsNumeric(Trim(request.form("answer6"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer6")))
		end if
		if intAnswer < 1 or intAnswer > 63 then
			strErr = strErr & "<li>答案选择错误!</li>"
		end if
	else
		intAnswer = CLng(Trim(request.form("answer")))
		if intAnswer <> 1 and intAnswer <> 0 then
			strErr = strErr & "<li>答案选择错误!</li>"
		end if
	end if
	
	if strErr <> "" then
		call closeConn()
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	set rsSubject = server.createobject("ADODB.Recordset")
	strSqlSubject = "select * from subject where id=0"
	rsSubject.open strSqlSubject,G_CONN,1,3
	rsSubject.addnew
	rsSubject("content") = strContent
	rsSubject("type") = intType
	rsSubject("option1") = strOption1
	rsSubject("option2") = strOption2
	rsSubject("option3") = strOption3
	rsSubject("option4") = strOption4
	rsSubject("option5") = strOption5
	rsSubject("option6") = strOption6
	rsSubject("answer") = intAnswer
	rsSubject("courseid") = intCourseID
	rsSubject.update
	rsSubject.close
	set rsSubject = nothing
	call closeConn()
	if request.form("iscontinue") = "1" then
		response.redirect "admin_subject.asp?action=add"
	else
		response.redirect "admin_subject.asp"
	end if
end sub

sub modify()	'修改试题界面
	dim rsSubject,strSqlSubject,intSubjectID,strErr
	
	strErr = ""
	intSubjectID = CLng(Trim(request.querystring("subjectid")))
	set rsSubject = server.createobject("ADODB.Recordset")
	strSqlSubject = "select * from subject where id=" & intSubjectID
	rsSubject.open strSqlSubject,G_CONN,1,1
	if rsSubject.bof or rsSubject.eof then
		strErr = "<li>试题ID不存在!</li>"
	end if
	if strErr <> "" then
	end if
%>
<form name="frmModify" action="admin_subject.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="subjectid" type="hidden" value="<%=intSubjectID%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> 修 改 试 题 </td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">所属课程：</td>
		<td>
			<%call showCourseList(rsSubject("courseid"))%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">试题内容：</td>
		<td>
			<textarea name="content" class="text" cols="50" rows="6"><%=rsSubject("content")%></textarea>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">试题类型：</td>
		<td>
			<input name="type" type="radio" <%if rsSubject("type")=1 then Response.Write "checked"%> value="1"> 单选题&nbsp;&nbsp;
			<input name="type" type="radio" <%if rsSubject("type")=2 then Response.Write "checked"%> value="2"> 多选题&nbsp;&nbsp;
			<input name="type" type="radio" <%if rsSubject("type")=3 then Response.Write "checked"%> value="3"> 是非题&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项1：</td>
		<td>
			<input name="option1" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option1")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项2：</td>
		<td>
			<input name="option2" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option2")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项3：</td>
		<td>
			<input name="option3" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option3")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项4：</td>
		<td>
			<input name="option4" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option4")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项5：</td>
		<td>
			<input name="option5" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option5")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">可选项6：</td>
		<td>
			<input name="option6" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option6")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">正确答案：</td>
		<td>
			<input name="answer" type="radio" <%if rsSubject("type")=3 and rsSubject("answer")=1 then Response.Write "checked"%> value="1">是&nbsp;&nbsp;
			<input name="answer" type="radio" <%if rsSubject("type")=3 and rsSubject("answer")=0 then Response.Write "checked"%> value="0">否<br>
			<input name="answer1" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 1) > 0) then Response.Write "checked"%> value="1"> 选项1&nbsp;&nbsp;
			<input name="answer2" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 2) > 0) then Response.Write "checked"%> value="2"> 选项2&nbsp;&nbsp;
			<input name="answer3" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 4) > 0) then Response.Write "checked"%> value="4"> 选项3&nbsp;&nbsp;
			<input name="answer4" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 8) > 0) then Response.Write "checked"%> value="8"> 选项4&nbsp;&nbsp;
			<input name="answer5" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 16) > 0) then Response.Write "checked"%> value="16"> 选项5&nbsp;&nbsp;
			<input name="answer6" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 32) > 0) then Response.Write "checked"%> value="32"> 选项6
		</td>
	</tr>	

	<tr class="tdbg">
		<td height="30" colspan="2" align="center">
			<input type="submit" value="&nbsp;保&nbsp;&nbsp;存&nbsp;">&nbsp;&nbsp;
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveModify()	'保存修改结果
	dim rsSubject,strSqlSubject,strErr
	dim strContent,intType,intAnswer,intCourseID,intSubjectID
	dim strOption1,strOption2,strOption3,strOption4,strOption5,strOption6
	
	strErr = ""
	if IsNumeric(Trim(Request.Form("subjectid"))) = false then
		strErr = "<li>试题ID错误!</li>"
	else
		intSubjectID = CLng(Trim(Request.Form("subjectid")))
	end if
	strContent = Trim(request.form("content"))
	if strContent = "" then
		strErr = "<li>题目内容为空!</li>"
	end if
	intType = CLng(Trim(request.form("type")))
	if intType < 1 or intType > 3 then
		strErr = strErr & "<li>题目类型选择错误!</li>"
	end if
	intCourseID = CLng(Trim(request.form("courseid")))
	if G_CONN.execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = "" then
		strErr = strErr & "<li>课程选择错误!</li>"
	end if
	strOption1 = Trim(request.form("option1"))
	strOption2 = Trim(request.form("option2"))
	strOption3 = Trim(request.form("option3"))
	strOption4 = Trim(request.form("option4"))
	strOption5 = Trim(request.form("option5"))
	strOption6 = Trim(request.form("option6"))
	if strOption1 & strOption2 & strOption3 & strOption4 & strOption5 & strOption6 = "" then
		strErr = strErr & "<li>至少要填写一个选项内容!</li>"
	end if
	if intType < 3 then
		if IsNumeric(Trim(request.form("answer1"))) = true then
			intAnswer = CLng(Trim(request.form("answer1")))
		end if
		if IsNumeric(Trim(request.form("answer2"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer2")))
		end if
		if IsNumeric(Trim(request.form("answer3"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer3")))
		end if
		if IsNumeric(Trim(request.form("answer4"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer4")))
		end if
		if IsNumeric(Trim(request.form("answer5"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer5")))
		end if
		if IsNumeric(Trim(request.form("answer6"))) = true then
			intAnswer = intAnswer + CLng(Trim(request.form("answer6")))
		end if
		if intAnswer < 1 or intAnswer > 63 then
			strErr = strErr & "<li>答案选择错误!</li>"
		end if
	else
		intAnswer = CLng(Trim(request.form("answer")))
		if intAnswer <> 1 and intAnswer <> 0 then
			strErr = strErr & "<li>答案选择错误!</li>"
		end if
	end if
	
	if strErr <> "" then
		call closeConn()
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	set rsSubject = server.createobject("ADODB.Recordset")
	strSqlSubject = "select * from subject where id=" & intSubjectID
	rsSubject.open strSqlSubject,G_CONN,1,3
	if rsSubject.bof and rsSubject.eof then
		strErr = "<li>此试题不存在!</li>"
		showErrMsg(strErr)
		rsSubject.close
		set rsSubject = nothing
	end if
	rsSubject("content") = strContent
	rsSubject("type") = intType
	rsSubject("option1") = strOption1
	rsSubject("option2") = strOption2
	rsSubject("option3") = strOption3
	rsSubject("option4") = strOption4
	rsSubject("option5") = strOption5
	rsSubject("option6") = strOption6
	rsSubject("answer") = intAnswer
	rsSubject("courseid") = intCourseID
	rsSubject.update
	rsSubject.close
	set rsSubject = nothing
	call closeConn()
	response.redirect "admin_subject.asp"
end sub

sub del()	'删除试题
	dim strSubjectID,strErr
	
	strSubjectID = Trim(request.querystring("subjectid"))
	if strSubjectID = "" then
		strSubjectID = Trim(request.form("subjectid"))
	end if
	if strSubjectID = "" then
		strErr = "<li>请选择要删除的试题！</li>"
		showErrMsg(strErr)
		response.write "</body></html>"
		call closeConn()
		exit sub
	end if
	if G_CONN.execute("select count(*) as reccount from prj_process where subid in (" & strSubjectID & ")")("reccount") > 0 then
		strErr = "<li>此试题正在使用中，不能被删除！</li>"
		call closeConn()
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	G_CONN.execute "delete from subject where id in (" & strSubjectID & ")"
	call closeConn()
	response.redirect "admin_subject.asp"
end sub
%>