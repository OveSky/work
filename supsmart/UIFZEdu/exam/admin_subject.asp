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
<title>��������</title>
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
			&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_subject.asp">����������ҳ</a> | <a href="admin_subject.asp?action=add">�������</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction
if checkAdminLogin() = false then	'���й���Ա��¼��֤
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_SUBJECT) = false then
	response.write "<center><font size=4>��û�н��д˲�����Ȩ�ޣ�����ϵͳ����Ա��ϵ��</font></center>"
	response.write "</body></html>"
	response.end
end if
strAction = trim(request.form("action"))
if strAction = "" then
	strAction = trim(request.querystring("action"))
end if
select case strAction
	case "del"
		call del()	'ɾ������
	case "saveadd"
		call saveadd()	'������ӽ��
	case "add"	'����������
		call add()
	case "savemodify"	'�����޸Ľ��
		call saveModify()
	case "modify"	'�޸��������
		call modify()
	case else
		call main()	'������
end select

sub main()	'������
	dim rsSubject,strSqlSubject,intMaxPage,I,intMaxPerPage,intCurPage,intCurRec,intCourseID,intType
%>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="70" align="center">ѡ��</td>
		<td width="100" align="center">����ID</td>		
		<td width="100" align="center">����</td>
		<td width="150" align="center">�����γ�</td>
		<td width="150" align="center">����</td>	
	</tr>
	<%
	intMaxPerPage = 18 '����ÿҳ��ʾ��������Ŀ
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
		response.write "<tr class='tdbg'><td colspan='6' align='center'>û������</td></tr>"
	end if
	intCurRec = 1
	while not rsSubject.eof and intCurRec <= intMaxPerPage
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'><input name='subjectid" & rsSubject("id") & "' onClick='checkup(this);' type='checkbox' value='" & rsSubject("id") & "'></td>"
		response.write "<td align='center'>" & rsSubject("id") & "</td>"
		response.write "<td align='center'><a href='admin_subject.asp?courseid=" & intCourseID & "&type=" & rsSubject("type") & "'>"
		select case rsSubject("type")
		case 1
			response.write "��ѡ��"
		case 2
			response.write "��ѡ��"
		case 3
			response.write "�Ƿ���"
		end select
		response.write "</a></td>"
		response.write "<td align='center'><a href='admin_subject.asp?courseid=" & rsSubject("courseid") & "&type=" & intType & "'>" & rsSubject("coursename") & "</a></td>"
		response.write "<td align='center'>"
		response.write "<a href='#' onClick=""if(confirm('����ɾ�������⣬ȷ��ɾ����') == true) window.open('/admin_subject.asp?action=del&subjectid=" & rsSubject("id") & "')"">ɾ��</a> | "
		response.write "<a href='admin_subject.asp?action=modify&subjectid=" & rsSubject("id") & "'>�޸�</a>"
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
	<input type="submit" value="ɾ��ѡ����Ŀ" onClick="delSubject(document.all.frmDel.subjectid);">
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

sub add()	'����������
%>
<form name="frmAdd" action="admin_subject.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<input name="iscontinue" type="hidden" value="0">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> �� �� �� �� </td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">�����γ̣�</td>
		<td>
			<%call showCourseList(1)%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">�������ݣ�</td>
		<td>
			<textarea name="content" class="text" cols="50" rows="6"></textarea>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">�������ͣ�</td>
		<td>
			<input name="type" type="radio" checked value="1"> ��ѡ��&nbsp;&nbsp;
			<input name="type" type="radio" value="2"> ��ѡ��&nbsp;&nbsp;
			<input name="type" type="radio" value="3"> �Ƿ���&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��1��</td>
		<td>
			<input name="option1" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��2��</td>
		<td>
			<input name="option2" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��3��</td>
		<td>
			<input name="option3" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��4��</td>
		<td>
			<input name="option4" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��5��</td>
		<td>
			<input name="option5" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��6��</td>
		<td>
			<input name="option6" type="text" class="text" size="50" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ȷ�𰸣�</td>
		<td>
			<input name="answer" type="radio" value="1">��&nbsp;&nbsp;
			<input name="answer" type="radio" value="0">��<br>
			<input name="answer1" type="checkbox" value="1"> ѡ��1&nbsp;&nbsp;
			<input name="answer2" type="checkbox" value="2"> ѡ��2&nbsp;&nbsp;
			<input name="answer3" type="checkbox" value="4"> ѡ��3&nbsp;&nbsp;
			<input name="answer4" type="checkbox" value="8"> ѡ��4&nbsp;&nbsp;
			<input name="answer5" type="checkbox" value="16"> ѡ��5&nbsp;&nbsp;
			<input name="answer6" type="checkbox" value="32"> ѡ��6
		</td>
	</tr>	

	<tr class="tdbg">
		<td height="30" colspan="2" align="center">
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;
			<input type="submit" onClick="document.all.frmAdd.iscontinue.value='1';" value="&nbsp;���沢�������&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveAdd()	'������ӽ��
	dim rsSubject,strSqlSubject,strErr
	dim strContent,intType,intAnswer,intCourseID
	dim strOption1,strOption2,strOption3,strOption4,strOption5,strOption6
	
	strErr = ""
	strContent = Trim(request.form("content"))
	if strContent = "" then
		strErr = "<li>��Ŀ����Ϊ��!</li>"
	end if
	intType = CLng(Trim(request.form("type")))
	if intType < 1 or intType > 3 then
		strErr = strErr & "<li>��Ŀ����ѡ�����!</li>"
	end if
	intCourseID = CLng(Trim(request.form("courseid")))
	if G_CONN.execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = 0 then
		strErr = strErr & "<li>�γ�ѡ�����!</li>"
	end if
	strOption1 = Trim(request.form("option1"))
	strOption2 = Trim(request.form("option2"))
	strOption3 = Trim(request.form("option3"))
	strOption4 = Trim(request.form("option4"))
	strOption5 = Trim(request.form("option5"))
	strOption6 = Trim(request.form("option6"))
	if strOption1 & strOption2 & strOption3 & strOption4 & strOption5 & strOption6 = "" then
		strErr = strErr & "<li>����Ҫ��дһ��ѡ������!</li>"
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
			strErr = strErr & "<li>��ѡ�����!</li>"
		end if
	else
		intAnswer = CLng(Trim(request.form("answer")))
		if intAnswer <> 1 and intAnswer <> 0 then
			strErr = strErr & "<li>��ѡ�����!</li>"
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

sub modify()	'�޸��������
	dim rsSubject,strSqlSubject,intSubjectID,strErr
	
	strErr = ""
	intSubjectID = CLng(Trim(request.querystring("subjectid")))
	set rsSubject = server.createobject("ADODB.Recordset")
	strSqlSubject = "select * from subject where id=" & intSubjectID
	rsSubject.open strSqlSubject,G_CONN,1,1
	if rsSubject.bof or rsSubject.eof then
		strErr = "<li>����ID������!</li>"
	end if
	if strErr <> "" then
	end if
%>
<form name="frmModify" action="admin_subject.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="subjectid" type="hidden" value="<%=intSubjectID%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> �� �� �� �� </td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">�����γ̣�</td>
		<td>
			<%call showCourseList(rsSubject("courseid"))%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">�������ݣ�</td>
		<td>
			<textarea name="content" class="text" cols="50" rows="6"><%=rsSubject("content")%></textarea>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">�������ͣ�</td>
		<td>
			<input name="type" type="radio" <%if rsSubject("type")=1 then Response.Write "checked"%> value="1"> ��ѡ��&nbsp;&nbsp;
			<input name="type" type="radio" <%if rsSubject("type")=2 then Response.Write "checked"%> value="2"> ��ѡ��&nbsp;&nbsp;
			<input name="type" type="radio" <%if rsSubject("type")=3 then Response.Write "checked"%> value="3"> �Ƿ���&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��1��</td>
		<td>
			<input name="option1" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option1")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��2��</td>
		<td>
			<input name="option2" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option2")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��3��</td>
		<td>
			<input name="option3" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option3")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��4��</td>
		<td>
			<input name="option4" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option4")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��5��</td>
		<td>
			<input name="option5" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option5")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ѡ��6��</td>
		<td>
			<input name="option6" type="text" class="text" size="50" maxlength="128" value="<%=rsSubject("option6")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��ȷ�𰸣�</td>
		<td>
			<input name="answer" type="radio" <%if rsSubject("type")=3 and rsSubject("answer")=1 then Response.Write "checked"%> value="1">��&nbsp;&nbsp;
			<input name="answer" type="radio" <%if rsSubject("type")=3 and rsSubject("answer")=0 then Response.Write "checked"%> value="0">��<br>
			<input name="answer1" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 1) > 0) then Response.Write "checked"%> value="1"> ѡ��1&nbsp;&nbsp;
			<input name="answer2" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 2) > 0) then Response.Write "checked"%> value="2"> ѡ��2&nbsp;&nbsp;
			<input name="answer3" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 4) > 0) then Response.Write "checked"%> value="4"> ѡ��3&nbsp;&nbsp;
			<input name="answer4" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 8) > 0) then Response.Write "checked"%> value="8"> ѡ��4&nbsp;&nbsp;
			<input name="answer5" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 16) > 0) then Response.Write "checked"%> value="16"> ѡ��5&nbsp;&nbsp;
			<input name="answer6" type="checkbox" <%if rsSubject("type") < 3 and ((rsSubject("answer") and 32) > 0) then Response.Write "checked"%> value="32"> ѡ��6
		</td>
	</tr>	

	<tr class="tdbg">
		<td height="30" colspan="2" align="center">
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveModify()	'�����޸Ľ��
	dim rsSubject,strSqlSubject,strErr
	dim strContent,intType,intAnswer,intCourseID,intSubjectID
	dim strOption1,strOption2,strOption3,strOption4,strOption5,strOption6
	
	strErr = ""
	if IsNumeric(Trim(Request.Form("subjectid"))) = false then
		strErr = "<li>����ID����!</li>"
	else
		intSubjectID = CLng(Trim(Request.Form("subjectid")))
	end if
	strContent = Trim(request.form("content"))
	if strContent = "" then
		strErr = "<li>��Ŀ����Ϊ��!</li>"
	end if
	intType = CLng(Trim(request.form("type")))
	if intType < 1 or intType > 3 then
		strErr = strErr & "<li>��Ŀ����ѡ�����!</li>"
	end if
	intCourseID = CLng(Trim(request.form("courseid")))
	if G_CONN.execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = "" then
		strErr = strErr & "<li>�γ�ѡ�����!</li>"
	end if
	strOption1 = Trim(request.form("option1"))
	strOption2 = Trim(request.form("option2"))
	strOption3 = Trim(request.form("option3"))
	strOption4 = Trim(request.form("option4"))
	strOption5 = Trim(request.form("option5"))
	strOption6 = Trim(request.form("option6"))
	if strOption1 & strOption2 & strOption3 & strOption4 & strOption5 & strOption6 = "" then
		strErr = strErr & "<li>����Ҫ��дһ��ѡ������!</li>"
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
			strErr = strErr & "<li>��ѡ�����!</li>"
		end if
	else
		intAnswer = CLng(Trim(request.form("answer")))
		if intAnswer <> 1 and intAnswer <> 0 then
			strErr = strErr & "<li>��ѡ�����!</li>"
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
		strErr = "<li>�����ⲻ����!</li>"
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

sub del()	'ɾ������
	dim strSubjectID,strErr
	
	strSubjectID = Trim(request.querystring("subjectid"))
	if strSubjectID = "" then
		strSubjectID = Trim(request.form("subjectid"))
	end if
	if strSubjectID = "" then
		strErr = "<li>��ѡ��Ҫɾ�������⣡</li>"
		showErrMsg(strErr)
		response.write "</body></html>"
		call closeConn()
		exit sub
	end if
	if G_CONN.execute("select count(*) as reccount from prj_process where subid in (" & strSubjectID & ")")("reccount") > 0 then
		strErr = "<li>����������ʹ���У����ܱ�ɾ����</li>"
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