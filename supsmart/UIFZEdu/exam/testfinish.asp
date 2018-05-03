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
<title>����</title>
<link href="student.css" rel="stylesheet" type="text/css">
<style>
td {
	font-size:14px;
	line-height:18px;
}
</style>
</head>
<%
dim rsMark,strSqlMark,strErr
dim intPrjID,intStudentID,strPrjName,strStudentName,intTotalMark,intMark,intLimitTime,strAnswerColor
dim intSSCount,intMSCount,intBCount,arrAnswer,I,dtmStartTime,dtmEndTime
if checkStudentLogin() = false then
	call closeConn()
	response.redirect "student_login.asp"
end if
redim arrAnswer(31)
for I = 1 To 31
	if (I and 1) > 0 then
		arrAnswer(I) = "A"
	end if
	if (I and 2) > 0 then
		arrAnswer(I) = arrAnswer(I) & "B"
	end if
	if (I and 4) > 0 then
		arrAnswer(I) = arrAnswer(I) & "C"
	end if
	if (I and 8) > 0 then
		arrAnswer(I) = arrAnswer(I) & "D"
	end if
	if (I and 16) > 0 then
		arrAnswer(I) = arrAnswer(I) & "E"
	end if
	if (I and 32) > 0 then
		arrAnswer(I) = arrAnswer(I) & "F"
	end if
next
if IsNumeric(Trim(request.querystring("prjid"))) = true then
	intPrjID = CLng(Trim(request.querystring("prjid")))
end if
if IsNumeric(Trim(request.querystring("studentid"))) = true then
	intStudentID = CLng(Trim(request.querystring("studentid")))
end if

if score(intPrjID,intStudentID) = false then	'�з�
	response.write "<script>alert('�з�ʧ�ܣ�');window.open('index_main.asp','_self');</script>"
	call closeConn()
	response.end
end if
'ȡ�ÿ��Ի�����Ϣ
strStudentName = request.cookies("aoyi")("studentname")
set rsMark = server.createobject("ADODB.Recordset")
strSqlMark = "select P.prjname,P.limittime,P_S.starttime,P_S.endtime,P.ss_count,P.ms_count,P.b_count,P_S.mark from project P,prj_student P_S where P.prjid=P_S.prjid and P_S.prjid=" & intPrjID & " and P_S.studentid=" & intStudentID
rsMark.open strSqlMark,G_CONN,1,1
strPrjName = rsMark("prjname")
dtmStartTime = rsMark("starttime")
dtmEndTime = rsMark("endtime")
intSSCount = rsMark("ss_count")
intMSCount = rsMark("ms_count")
intBCount = rsMark("b_count")
intTotalMark = intSSCount + intMSCount * 2 + intBCount
intMark = rsMark("mark")
intLimitTime = rsMark("limittime")
rsMark.close

%>
<body>
&nbsp;&nbsp;&nbsp;<a href="#" style="color:#00F;font-size:12px" onClick="window.print();">����ӡ��ҳ��</a>
<table width="550" align="center" border="0" cellspacing="5" cellpadding="5">
	<tr>
		<td align="center" height="40">
			<font size="4"><strong><%=strPrjName%></strong></font>
		</td>
	</tr>
	<tr>
		<td align="center">
			����:<%=strStudentName%>&nbsp;&nbsp;&nbsp;&nbsp;�ܷ�:<%=intTotalMark%>&nbsp;&nbsp;�÷�:<font color="#FF0000"><%=intMark%></font>&nbsp;&nbsp;��ʼʱ�䣺<%=dtmStartTime%>&nbsp;&nbsp;��ʱ��<%=DateDiff("n",dtmStartTime,dtmEndTime)%>����
		</td>
	</tr>
	<tr>
		<td><hr size="1" width="95%" color="#CCCCCC"></td>
	</tr>
	<%
	'��ʾ����ѡ����
	strSqlMark = "select P_P.answer as myanswer,S.answer,P_P.orderid,S.content,S.option1,S.option2,S.option3,S.option4,S.option5,S.option6 from prj_process P_P,subject S where S.type=1 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsMark.open strSqlMark,G_CONN,1,1
	if not rsMark.bof and not rsMark.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>����ѡ���ⲿ�� (��<%=intSSCount%>�� ÿ��1�� ��<%=intSSCount%>��)</strong></font>
		</td>
	</tr>
	<%
		while not rsMark.eof
	%>
		<tr>
			<td>
				<strong><%=rsMark("orderid")%>. </strong>
				<%=rsMark("content")%>
			</td>
		</tr>
		<tr>
			<td>
				<%
				if rsMark("option1") <> "" then
					response.write "&nbsp;A&nbsp;" & rsMark("option1")
					response.write "<br>"
				end if
				if rsMark("option2") <> "" then
					response.write "&nbsp;B&nbsp;" & rsMark("option2")
					response.write "<br>"
				end if
				if rsMark("option3") <> "" then
					response.write "&nbsp;C&nbsp;" & rsMark("option3")
					response.write "<br>"
				end if
				if rsMark("option4") <> "" then
					response.write "&nbsp;D&nbsp;" & rsMark("option4")
					response.write "<br>"
				end if
				if rsMark("option5") <> "" then
					response.write "&nbsp;E&nbsp;" & rsMark("option5")
					response.write "<br>"
				end if
				if rsMark("option6") <> "" then
					response.write "&nbsp;F&nbsp;" & rsMark("option6")
					response.write "<br>"
				end if
				response.write "<br>��Ĵ��ǣ�"
				if rsMark("myanswer") = rsMark("answer") then
					response.write "<font color='#00AA00'>" & arrAnswer(rsMark("myanswer")) & "</font>"
				elseif rsMark("myanswer") > -1 then
					response.write "<font color='#FF0000'>" & arrAnswer(rsMark("myanswer")) & "</font>"
				else
					response.write "<font color='#DD6600'>δ����</font>"
				end if
				response.write "&nbsp;&nbsp;&nbsp;&nbsp;��ȷ���ǣ�<font color='#0000FF'>" & arrAnswer(rsMark("answer")) & "</font>"
				%>
			</td>
		</tr>
	<%
			rsMark.movenext
		wend
		rsMark.close
	end if
	'��ʾ����ѡ����
	strSqlMark = "select P_P.answer as myanswer,S.answer,P_P.orderid,S.content,S.option1,S.option2,S.option3,S.option4,S.option5,S.option6 from prj_process P_P,subject S where S.type=2 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsMark.open strSqlMark,G_CONN,1,1
	if not rsMark.bof and not rsMark.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>����ѡ���ⲿ�� (��<%=intMSCount%>�� ÿ��2�� ��<%=intMSCount * 2%>��)</strong></font>
		</td>
	</tr>
	<%
		while not rsMark.eof
	%>
		<tr>
			<td>
				<strong><%=rsMark("orderid")%>. </strong>
				<%=rsMark("content")%>
			</td>
		</tr>
		<tr>
			<td>
				<%
				if rsMark("option1") <> "" then
					response.write "&nbsp;A&nbsp;" & rsMark("option1")
					response.write "<br>"
				end if
				if rsMark("option2") <> "" then
					response.write "&nbsp;B&nbsp;" & rsMark("option2")
					response.write "<br>"
				end if
				if rsMark("option3") <> "" then
					response.write "&nbsp;C&nbsp;" & rsMark("option3")
					response.write "<br>"
				end if
				if rsMark("option4") <> "" then
					response.write "&nbsp;D&nbsp;" & rsMark("option4")
					response.write "<br>"
				end if
				if rsMark("option5") <> "" then
					response.write "&nbsp;E&nbsp;" & rsMark("option5")
					response.write "<br>"
				end if
				if rsMark("option6") <> "" then
					response.write "&nbsp;F&nbsp;" & rsMark("option6")
					response.write "<br>"
				end if
				response.write "<br>��Ĵ��ǣ�"
				if rsMark("myanswer") = rsMark("answer") then
					response.write "<font color='#00AA00'>" & arrAnswer(rsMark("myanswer")) & "</font>"
				elseif rsMark("myanswer") > -1 then
					response.write "<font color='#FF0000'>" & arrAnswer(rsMark("myanswer")) & "</font>"
				else
					response.write "<font color='#DD6600'>δ����</font>"
				end if
				response.write "&nbsp;&nbsp;&nbsp;&nbsp;��ȷ���ǣ�<font color='#0000FF'>" & arrAnswer(rsMark("answer")) & "</font>"				
				%>
			</td>
		</tr>
	<%
		rsMark.movenext
		wend
		rsMark.close
	end if
	
	'��ʾ�Ƿ���
	strSqlMark = "select P_P.answer as myanswer,P_P.orderid,S.content,S.answer from prj_process P_P,subject S where S.type=3 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsMark.open strSqlMark,G_CONN,1,1
	if not rsMark.bof and not rsMark.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>�Ƿ��ⲿ�� (��<%=intBCount%>�� ÿ��1�� ��<%=intBCount%>��)</strong></font>
		</td>
	</tr>
	<%
		while not rsMark.eof
	%>
		<tr>
			<td>
				<strong><%=rsMark("orderid")%>. </strong>
				<%=rsMark("content")%>
				<br>
				��Ĵ��ǣ�
				<%
				if rsMark("myanswer") = rsMark("answer") then
					if rsMark("myanswer") = 1 then
						response.write "<font color='#00AA00'>��</font>"
					elseif rsMark("myanswer") = 0 then
						response.write "<font color='#00AA00'>��</font>"
					end if
				else
					if rsMark("myanswer") = 1 then
						response.write "<font color='#FF0000'>��</font>"
					elseif rsMark("myanswer") = 0 then
						response.write "<font color='#FF0000'>��</font>"
					else
						response.write "<font color='#DD6600'>δ����</font>"
					end if
				end if
				response.write "&nbsp;&nbsp;&nbsp;&nbsp;��ȷ���ǣ�"
				if rsMark("answer") = 1 then
					response.write "<font color='#0000FF'>��</font>"
				else
					response.write "<font color='#0000FF'>��</font>"
				end if
				%>
			</td>
		</tr>
	<%
		rsMark.movenext
		wend
		rsMark.close
	end if
	set rsMark = nothing
	G_CONN.Execute "delete from prj_process where prjid=" & intPrjID & " and studentid=" & intStudentID
	call closeConn()
	%>
</table>
</body>
</html>
