<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>新视点在线考试系统</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>
<%
dim rsExam,strSqlExam,intStudentID,blnIsToday
dim rsPS,strSqlPS

if IsNumeric(request.cookies("aoyi")("studentid")) = true then
	intStudentID = CLng(request.cookies("aoyi")("studentid"))
else
	intStudentID = 0
end if
'列出所有当前可以参加的考试
strSqlExam = "select C.coursename,P.starttime,P.endtime,P.prjname,P.prjid from project P,course C where P.courseid=C.courseid and P.endtime>=date() order by P.endtime"
set rsExam = server.createobject("ADODB.Recordset")
set rsPS = server.createobject("ADODB.Recordset")
rsExam.open strSqlExam,G_CONN,1,1
%>
<body>
	<table width="100%" border="0" cellpadding="0" cellspacing="5">
		<tr>
			<td height="30" width="500" background="images/hometdbg.gif">
				<font color="#FFFF00"><strong>&nbsp;考试课目</strong></font>
			</td>
			<td width="200"></td>
		</tr>
		<%
		while not rsExam.eof
			blnIsToday = false
			strSqlPS = "select count(*) as reccount from prj_student where state=1 and studentid=" & intStudentID & " and prjid=" & rsExam("prjid")
			rsPS.open strSqlPS,G_CONN,1,1
			response.write "<tr><td>"
			if rsExam("endtime") <= date() + 1 then	'今日即将结束的考试
				blnIsToday = true
			end if
			if blnIsToday = true then
				response.write "<img src='images/redtag.gif'>"	'显示红色标记
			else
				response.write "<img src='images/tag.gif'>"	'显示普通标记
			end if
			'如果当前时间在考试计划的时间内并且当前登录的学生没有参加过此次考试或正在进行考试则可以直接点击链接参加考试
			if rsPS("reccount") = 0 and rsExam("starttime") <= now() and intStudentID > 0 then
				if blnIsToday = true then
					response.write "<a class='hotexamA' title='点击参加此次考试'"
				else
					response.write "<a title='点击参加此次考试'"
				end if
				response.write "href='#' onClick=""if(confirm('你确定要参加此次考试吗？')==true) window.open('testing.asp?action=test&prjid=" & rsExam("prjid") & "','_self');"">"
				response.write "[" & rsExam("coursename") & "] " & rsExam("prjname") & "</a> "
			else
				if blnIsToday = true then
					response.write "<font color='#0000FF'>[" & rsExam("coursename") & "] " & rsExam("prjname") & "</font> "
				else
					response.write "[" & rsExam("coursename") & "] " & rsExam("prjname")
				end if
			end if
			response.write "<font color='#999999'> 时间：" & FormatDatetime(rsExam("starttime"),0) & " 至 " & FormatDatetime(rsExam("endtime"),0)
			response.write "</td></tr>"
			rsPS.close
			rsExam.movenext
		wend
		rsExam.close
		set rsPS = nothing
		set rsExam = nothing
		Call CloseConn()
		%>
</table>
</body>
</html>
