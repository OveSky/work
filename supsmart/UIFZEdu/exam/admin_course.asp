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

<title>�γ̹���</title>
<link href="admin.css" rel="stylesheet" type="text/css">
</head>
<body>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_course.asp">�γ̹�����ҳ</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction

if checkAdminLogin() = false then	'���й���Ա��¼��֤
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_COURSE) = false then
	response.write "<center><font size=4>��û�н��д˲�����Ȩ�ޣ�����ϵͳ����Ա��ϵ��</font></center>"
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

sub main()	'������
	dim rsCourse,strSqlCourse
%>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			�� �� / �� �� �� �� �� ��
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			&nbsp;���Ҫ��ӿγ̵�������ѿγ�IDɾ����<br>
			<a name="form">
			<form name="frmUpdate" action="admin_course.asp" method="post">
				<input name="action" type="hidden" value="saveupdate">
				�γ�ID��<input name="courseid" class="text" type="text" size="10" value="">&nbsp;&nbsp;
				�γ����ƣ�<input name="coursename" class="text" type="text" size="40" maxlength="128" value="">&nbsp;&nbsp;
				<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">
			</form>
		</td>
	</tr>
</table>
<br>

<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="70" align="center"> �� �� ID</td>		
		<td align="center"> �� �� �� �� </td>
		<td width="150" align="center"> �� �� </td>
	</tr>
	<%
	set rsCourse = server.createobject("ADODB.Recordset")
	strSqlCourse = "select * from course order by courseid desc"
	rsCourse.open strSqlCourse,G_CONN,1,1
	if rsCourse.bof and rsCourse.eof then
		response.write "<tr class='tdbg'><td colspan='3' align='center'>û�пγ̵���</td></tr>"
	end if
	while not rsCourse.eof
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'>" & rsCourse("courseid") & "</td>"
		response.write "<td>" & rsCourse("coursename") & "</td>"
		response.write "<td align='center'><a href='#' onClick=""if(confirm('����ɾ���˿γ̺ʹ˿γ̵����п��⣬ȷ��ɾ����') == true) window.open('admin_course.asp?action=del&courseid=" & rsCourse("courseid") & "','_self')"">ɾ��</a> | "
		response.write "<a href='#form' onClick=""document.all.frmUpdate.courseid.value=" & rsCourse("courseid") & ";document.all.frmUpdate.coursename.value='" & rsCourse("coursename") & "';"">�޸�</a>"
		response.write "</td></tr>"
		rsCourse.movenext
	wend
	rsCourse.close
	set rsCourse = nothing
	%>
</table>
<%
end sub

'�޸Ļ���ӿγ̵���
sub saveUpdate()
	dim rsCourse,strSqlCourse,intCourseID,strCourseName,strErr
	
	strCourseName = trim(request.form("coursename"))
	if strCourseName = "" then
		strErr = "<li>�γ���Ϊ�գ�</li>"
	end if
	if trim(request.form("courseid")) <> "" then	'��֤�Ƿ񴫵���ID�š�
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
	if rsCourse.bof and rsCourse.eof and intCourseID = -1 then	'��û��ID����ʱ��ӿγ�
		rsCourse.addnew
		rsCourse("coursename") = strCourseName
		rsCourse.update
	elseif not rsCourse.bof and not rsCourse.eof then	'��ID���ڲ���ID���������ݿ�ʱ���޸Ŀγ�
		rsCourse("coursename") = strCourseName
		rsCourse.update
	end if
	rsCourse.close
	set rsCourse = nothing
	call closeConn()
	response.redirect "admin_course.asp"
end sub

'ɾ���γ̵���  ע�⣺ֻ��û�б�������ʹ�õĿγ̲ſ���ɾ��
sub delCourse()
	dim intCourseID,strErr
	strErr = ""
	intCourseID = CLng(trim(request.querystring("courseid")))
	if G_CONN.execute("select count(*) as reccount from project where courseid=" & intCourseID)("reccount") > 0 then
		strErr = "<li>�˿γ��Ѿ������Լƻ�ʹ�ã�����ɾ����</li>"
	end if
	if strErr = "" then
		G_CONN.begintrans		'��ʼ����
		G_CONN.execute "delete from subject where courseid=" & intCourseID
		G_CONN.execute "delete from course where courseid=" & intCourseID
		G_CONN.committrans	'��������
		call closeConn()
		response.redirect "admin_course.asp"
	else
		showErrMsg(strErr)
	end if
end sub
%>
