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
<title>���Լƻ�����</title>
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
			&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_project.asp">���Լƻ���ҳ</a> | <a href="admin_project.asp?action=add">��ӿ��Լƻ�</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction

if checkAdminLogin() = false then	'���й���Ա��¼��֤
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_PROJECT) = false then
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
		call del()	'ɾ�����Լƻ�
	case "modify"
		call modify()	'�޸Ŀ����Լƻ�����
	case "savemodify"
		call saveModify()	'�����޸Ľ��
	case "add"
		call add()	'��ӿ��Լƻ�����
	case "saveadd"
		call saveAdd()	'������ӽ��
	case else
		call main()	'������
end select
%>
</body>
</html>
<%
call closeConn()

sub main()	'������
	'���壺Recordset����SQL�ִ�����ǰҳ��ţ����ҳ��ţ�ÿҳ��ʾ���Լƻ�������ǰ�ڱ�ҳ�ڼ�����¼
	dim rsProject,strSqlProject,intCurPage,intMaxPage,intMaxPerPage,intCurRec,I
	
	intMaxPerPage = 20	'�趨ÿҳ20�����Լƻ�
	intCurPage = CLng(request.querystring("page"))
	
%>

<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="60" align="center"> ID </td>
		<td align="center"> �������� </td>
		<td width="100" align="center"> �γ����� </td>
		<td width="100" align="center"> ��ʼʱ�� </td>
		<td width="100" align="center"> ����ʱ�� </td>
		<td width="100" align="center"> �� �� </td>
	</tr>
	<%
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select P.*,C.coursename from project P,course C where P.courseid=C.courseid"
	rsProject.open strSqlProject,G_CONN,1,1
	if rsProject.bof and rsProject.eof then
		response.write "<tr class='tdbg'><td colspan='7' align='center'>û�п��Լƻ�</td></tr>"
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
		response.write "<a href='#' onClick=""if(confirm('ɾ���˿��Լƻ�����ͬ��˿��Լƻ��йصĿ��Լ�¼,��ȷ����?') == true) window.open('admin_project.asp?action=del&prjid=" & rsProject("prjid") & "&page=" & intCurPage & "','_self')"">ɾ��</a> | "
		response.write "<a href='admin_project.asp?action=modify&prjid=" & rsProject("prjid") & "&page=" & intCurPage & "'>�޸�</a> "
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

sub add()	'��ӿ��Լƻ�����
%>
<form action="admin_project.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> ��ӿ��Լƻ� </td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">���Լƻ����ƣ�</td>
		<td>
			<input name="prjname" type="text" class="text" size="25" maxlength="128" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">�ƻ���ʼʱ�䣺</td>
		<td>
			<input name="starttime" type="text" class="text" size="18" maxlength="20" value="<%=FormatDatetime(Date(),2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">�ƻ�����ʱ�䣺</td>
		<td>
			<input name="endtime" type="text" class="text" size="20" maxlength="50" value="<%=FormatDatetime(Date() + 7,2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">��������ʱ�䣺</td>
		<td>
			<input name="limittime" type="text" class="text" size="6" maxlength="5" value="90"> ����
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right"> ���Կγ̣�</td>
		<td>
			<%
			call showCourseList(1)
			%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">��ѡ��������</td>
		<td>
			<input name="ss_count" type="text" class="text" size="6" maxlength="5" value="40">
			ÿ��1��
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">��ѡ��������</td>
		<td>
			<input name="ms_count" type="text" class="text" size="6" maxlength="5" value="20">
			ÿ��2��
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">�Ƿ���������</td>
		<td>
			<input name="b_count" type="text" class="text" size="6" maxlength="5" value="20">
			ÿ��1��
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" height="30" colspan="2">
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveAdd()	'������ӽ��
	dim rsProject,strSqlProject,strPrjName,dtmStartTime,dtmEndTime,intLimitTime,intCourseID
	dim intSS_Count,intMS_Count,intB_Count,strErr
	
	strErr = ""
	strPrjName = trim(request.form("prjname"))
	if strPrjName = "" then
		strErr = "<li>���Լƻ�����Ϊ�գ�</li>"
	end if
	if IsDate(trim(request.form("starttime"))) = false then
		strErr = strErr & "<li>�ƻ���ʼʱ���ʽ����ȷ��</li>"
	else
		dtmStartTime = CDate(trim(request.form("starttime")))
	end if
	if IsDate(trim(request.form("endtime"))) = false then
		strErr = strErr & "<li>�ƻ�����ʱ���ʽ����ȷ��</li>"
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
		strErr = strErr & "<li>�γ�ѡ�����</li>"
	end if
	if G_CONN.Execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = 0 then
		strErr = strErr & "<li>�γ�ѡ�����</li>"
	end if
	if IsNumeric(Trim(request.form("limittime"))) = true then
		intLimitTime = CLng(Trim(request.form("limittime")))
	else
		strErr = strErr & "<li>����д��������ʱ�䣡</li>"
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

sub modify()	'�޸Ŀ��Լƻ�����
	dim rsProject,strSqlProject,intPrjID,strErr
	if IsNumeric(Trim(request.querystring("prjid"))) = true then
		intPrjID = CLng(Trim(request.querystring("prjid")))
	else
		strErr = "<li>����ȷѡ���Լƻ���</li>"
		showErrMsg(strErr)
		exit sub
	end if
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select * from project where prjid=" & intPrjID
	rsProject.open strSqlProject,G_CONN,1,1
	if rsProject.bof and rsProject.eof then
		strErr = "<li>�˿��Լƻ������ڣ�</li>"
		showErrMsg(strErr)
		exit sub
	end if
%>
<form action="admin_project.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="prjid" type="hidden" value="<%=intPrjID%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> �޸Ŀ��Լƻ� </td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">���Լƻ����ƣ�</td>
		<td>
			<input name="prjname" type="text" class="text" size="25" maxlength="128" value="<%=rsProject("prjname")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">�ƻ���ʼʱ�䣺</td>
		<td>
			<input name="starttime" type="text" class="text" size="18" maxlength="20" value="<%=FormatDatetime(rsProject("starttime"),2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">�ƻ�����ʱ�䣺</td>
		<td>
			<input name="endtime" type="text" class="text" size="20" maxlength="50" value="<%=FormatDatetime(rsProject("endtime"),2)%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">��������ʱ�䣺</td>
		<td>
			<input name="limittime" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("limittime")%>"> ����
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right"> ���Կγ̣�</td>
		<td>
			<%
			call showCourseList(CLng(rsProject("courseid")))
			%>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="180" align="right">��ѡ��������</td>
		<td>
			<input name="ss_count" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("ss_count")%>">
			ÿ��1��
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">��ѡ��������</td>
		<td>
			<input name="ms_count" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("ms_count")%>">
			ÿ��2��
		</td>
	</tr>	
	<tr class="tdbg">
		<td width="180" align="right">�Ƿ���������</td>
		<td>
			<input name="b_count" type="text" class="text" size="6" maxlength="5" value="<%=rsProject("b_count")%>">
			ÿ��1��
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" height="30" colspan="2">
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;
			<input type="reset" value="&nbsp;��&nbsp;&nbsp;д&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
	rsProject.close
	set rsProject = nothing
end sub

sub saveModify()	'�����޸Ľ��
	dim rsProject,strSqlProject,intPrjID,strPrjName,dtmStartTime,dtmEndTime,intLimitTime
	dim intCourseID,intSS_Count,intMS_Count,intB_Count,strErr
	
	strErr = ""
	strPrjName = trim(request.form("prjname"))
	if strPrjName = "" then
		strErr = "<li>���Լƻ�����Ϊ�գ�</li>"
	end if
	if IsDate(trim(request.form("starttime"))) = false then
		strErr = strErr & "<li>�ƻ���ʼʱ���ʽ����ȷ��</li>"
	else
		dtmStartTime = CDate(trim(request.form("starttime")))
	end if
	if IsDate(trim(request.form("endtime"))) = false then
		strErr = strErr & "<li>�ƻ�����ʱ���ʽ����ȷ��</li>"
	else
		dtmEndTime = CDate(trim(request.form("endtime")))
	end if
	if IsNumeric(Trim(request.form("prjid"))) = true then
		intPrjID = CLng(Trim(request.form("prjid")))
	else
		strErr = strErr & "<li>�˿��Լƻ������ڣ�</li>"
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
		strErr = strErr & "<li>�γ�ѡ�����</li>"
	end if
	if G_CONN.Execute("select count(*) as reccount from course where courseid=" & intCourseID)("reccount") = 0 then
		strErr = strErr & "<li>�γ�ѡ�����</li>"
	end if
	if IsNumeric(Trim(request.form("limittime"))) = true then
		intLimitTime = CLng(Trim(request.form("limittime")))
	else
		strErr = strErr & "<li>����д��������ʱ�䣡</li>"
	end if
	if G_CONN.execute("select count(*) as reccount from prj_student where state<>1 and prjid=" & intPrjID)("reccount") > 0 then
		strErr = strErr & "<li>�˿��Լƻ�����ʹ���У������޸ģ�</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		exit sub
	end if
	set rsProject = server.createobject("ADODB.Recordset")
	strSqlProject = "select * from project where prjid=" & intPrjID
	rsProject.open strSqlProject,G_CONN,1,3
	if rsProject.bof and rsProject.eof then
		strErr = "<li>�˿��Լƻ������ڣ�</li>"
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

sub del()	'ɾ�����Լƻ�
	dim intPrjID,strErr
	
	intPrjID = CLng(Trim(request.querystring("prjid")))
	if G_CONN.execute("select count(*) as reccount from project where starttime<=date() and endtime>=date() and prjid in (select prjid from prj_student) and prjid=" & intPrjID)("reccount") > 0 then
		strErr = "<li>�ڿ��Լƻ�ʹ���в���ɾ���˼ƻ���</li>"
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