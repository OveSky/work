<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>�ɼ���ѯ</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
dim intCourseID,dtmStartTime,dtmEndTime,strUserName
dim rsMark,strSqlMark,strErr

if checkStudentLogin() = false then	'��⿼����¼״̬
	response.redirect "student_login.asp"
end if
strErr = ""
intCourseID = CInt(request.form("courseid"))
'��֤���������Ƿ���ȷ
if Trim(request.form("starttime")) <> "" then
	if IsDate(Trim(request.form("starttime"))) = true then
		dtmStartTime = CDate(Trim(request.form("starttime")))
	else
		strErr = "<li>��ʼ���ڸ�ʽ����</li>" & vbcrlf
	end if
else
	dtmStartTime = CDate("2000-1-1")
end if
if Trim(request.form("endtime")) <> "" then
	if IsDate(Trim(request.form("endtime"))) = true then
		dtmEndTime = CDate(Trim(request.form("endtime")))
	else
		strErr = "<li>�������ڸ�ʽ����</li>" & vbcrlf
	end if
else
	dtmEndTime = CDate("2200-1-1")
end if

if strErr = "" then	'���ͨ����֤����ʾ����ѯ���
	strSqlMark = "select P.prjname,P_S.mark,P_S.state,P_S.starttime,P_S.endtime from project P,prj_student P_S where "
	strSqlMark = strSqlMark & "P.prjid = P_S.prjid and P_S.studentid=" & request.cookies("aoyi")("studentid") & " and P.starttime > #" & dtmStartTime & "# and P.starttime < #" & dtmEndTime & "# and (P_S.state=1 or P_S.state=3)"
	if intCourseID > 0 then
		strSqlMark = strSqlMark & " and P.courseid=" & intCourseID
	end if
	strSqlMark = strSqlMark & " order by P.starttime desc"
%>
	<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg" style="color:#FFFFFF">
			<td align="center">�Ծ�����</td>
			<td align="center">��ʼ����ʱ��</td>
			<td align="center">��������ʱ��</td>
			<td align="center">���Գɼ�</td>
		</tr>
<%
	set rsMark = server.createobject("ADODB.Recordset")
	rsMark.open strSqlMark,G_CONN,1,1
	if rsMark.bof and rsMark.eof then
		response.write "<tr class='tdbg'><td colspan='4' align='center'>û���ҵ����������ļ�¼</td></tr>" & vbcrlf
	end if
	while not rsMark.eof
		response.write "<tr class='tdbg'>" & vbcrlf
		response.write "<td>" & rsMark("prjname") & "</td>" & vbcrlf
		response.write "<td align='center'>" & formatdatetime(rsMark("starttime"),0) & "</td>" & vbcrlf
		response.write "<td align='center'>" & formatdatetime(rsMark("endtime"),0) & "</td>" & vbcrlf
		response.write "<td align='center'>" & rsMark("mark") & "</td>"
		rsMark.movenext
	wend
	response.write "</table>"
	rsMark.close
	set rsMark = nothing
else	'��ʾ������Ϣ
	showErrMsg(strErr)
end if
%>
</body>
</html>
