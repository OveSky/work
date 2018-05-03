<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>成绩查询</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
dim intCourseID,dtmStartTime,dtmEndTime,strUserName
dim rsMark,strSqlMark,strErr

if checkStudentLogin() = false then	'检测考生登录状态
	response.redirect "student_login.asp"
end if
strErr = ""
intCourseID = CInt(request.form("courseid"))
'验证日期输入是否正确
if Trim(request.form("starttime")) <> "" then
	if IsDate(Trim(request.form("starttime"))) = true then
		dtmStartTime = CDate(Trim(request.form("starttime")))
	else
		strErr = "<li>起始日期格式错误</li>" & vbcrlf
	end if
else
	dtmStartTime = CDate("2000-1-1")
end if
if Trim(request.form("endtime")) <> "" then
	if IsDate(Trim(request.form("endtime"))) = true then
		dtmEndTime = CDate(Trim(request.form("endtime")))
	else
		strErr = "<li>结束日期格式错误</li>" & vbcrlf
	end if
else
	dtmEndTime = CDate("2200-1-1")
end if

if strErr = "" then	'如果通过验证则显示出查询结果
	strSqlMark = "select P.prjname,P_S.mark,P_S.state,P_S.starttime,P_S.endtime from project P,prj_student P_S where "
	strSqlMark = strSqlMark & "P.prjid = P_S.prjid and P_S.studentid=" & request.cookies("aoyi")("studentid") & " and P.starttime > #" & dtmStartTime & "# and P.starttime < #" & dtmEndTime & "# and (P_S.state=1 or P_S.state=3)"
	if intCourseID > 0 then
		strSqlMark = strSqlMark & " and P.courseid=" & intCourseID
	end if
	strSqlMark = strSqlMark & " order by P.starttime desc"
%>
	<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg" style="color:#FFFFFF">
			<td align="center">试卷名称</td>
			<td align="center">开始考试时间</td>
			<td align="center">结束考试时间</td>
			<td align="center">考试成绩</td>
		</tr>
<%
	set rsMark = server.createobject("ADODB.Recordset")
	rsMark.open strSqlMark,G_CONN,1,1
	if rsMark.bof and rsMark.eof then
		response.write "<tr class='tdbg'><td colspan='4' align='center'>没有找到符合条件的记录</td></tr>" & vbcrlf
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
else	'显示错误信息
	showErrMsg(strErr)
end if
%>
</body>
</html>
