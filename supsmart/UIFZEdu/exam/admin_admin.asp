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
<title>���ӵ����߿���ϵͳ-��̨����</title>
<link href="admin.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td align="center">
			&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;Ա&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;
		</td>
	</tr>
	<tr class="tdbg">
		<td>
			<a href="admin_admin.asp">����Ա������ҳ</a> | <a href="admin_admin.asp?action=add">��Ӳ���Ա</a>
		</td>
	</tr>
</table>
<br>
<%
dim strAction

if checkAdminLogin() = false then	'���й���Ա��¼��֤
	response.redirect "admin_login.asp"
end if
if checkPurview(CONST_PURVIEW_ADMIN) = false then
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
		call del()	'ɾ������Ա
	case "modify"
		call modify()	'�޸Ĳ���Ա����
	case "savemodify"
		call saveModify()	'�����޸Ľ��
	case "add"
		call add()	'��Ӳ���Ա����
	case "saveadd"
		call saveAdd()	'������ӽ��
	case else
		call main()	'������
end select
call closeConn()

sub main()	'������
	dim rsAdmin,strSqlAdmin
%>
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td width="130" align="center"> ����ԱID</td>		
		<td align="center"> �� ¼ �� �� </td>
		<td width="150" align="center"> �� �� </td>
	</tr>
	<%
	set rsAdmin = server.createobject("ADODB.Recordset")
	strSqlAdmin = "select * from admin"
	rsAdmin.open strSqlAdmin,G_CONN,1,1
	if rsAdmin.bof and rsAdmin.eof then
		response.write "<tr class='tdtbg'><td colspan='3' align='center'>û�в���Ա</td></tr>"
	end if
	while not rsAdmin.eof
		response.write "<tr class='tdbg'>"
		response.write "<td align='center'>" & rsAdmin("adminid") & "</td>"
		response.write "<td>" & rsAdmin("adminname") & "</td>"
		response.write "<td align='center'>"
		if rsAdmin("adminname") <> "admin" then
			response.write "<a href='#' onClick=""if(confirm('����ɾ���˲���Ա��ȷ��ɾ����') == true) window.open('admin_admin.asp?action=del&adminid=" & rsAdmin("adminid") & "','_self')"">ɾ��</a> | "
			response.write "<a href='admin_admin.asp?action=modify&adminid=" & rsAdmin("adminid") & "'>�޸�</a>"
		end if
		response.write "</td></tr>"
		rsAdmin.movenext
	wend
	rsAdmin.close
	set rsAdmin = nothing
	%>
</table>
</body>
</html>
<%
end sub

sub add()	'��Ӳ���Ա����
%>
<form action="admin_admin.asp" method="post">
<input name="action" type="hidden" value="saveadd">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> �� �� �� �� Ա </td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��¼���ƣ�</td>
		<td>
			<input name="adminname" type="text" class="text" size="20" maxlength="25" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">��¼���룺</td>
		<td>
			<input name="adminpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">ȷ�����룺</td>
		<td>
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="130" align="right">Ȩ�����ã�</td>
		<td>
			<input name="adminpurview_subject" type="checkbox" value="1">ά������&nbsp;&nbsp;
			<input name="adminpurview_student" type="checkbox" value="2">ά����������&nbsp;&nbsp;
			<input name="adminpurview_project" type="checkbox" value="4">ά�����Լƻ�&nbsp;&nbsp;
			<input name="adminpurview_course" type="checkbox" value="8">ά���γ̵���
		</td>
	</tr>
	<tr class="tdbg">
		<td colspan="2" align="center" height="30">
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">
		</td>
	</tr>
</table>
</form>
<%
end sub

sub saveAdd()	'������ӽ��
	dim strAdminName,strAdminPwd,intAdminPurview,strErr
	
	strErr = ""
	if IsNumeric(Trim(request.form("adminpurview_subject"))) = true then
		intAdminPurview = CLng(trim(request.form("adminpurview_subject")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_student"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_student")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_project"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_project")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_course"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_course")))
	end if
	strAdminName = trim(request.form("adminname"))
	strAdminPwd = trim(request.form("adminpwd"))
	if intAdminPurview < 1 or intAdminPurview > 15 then
		strErr = "<li>Ȩ�����ô���</li>"
	end if
	if strAdminPwd <> trim(request.form("confirmpwd")) then
		strErr = strErr & "<li>������ȷ�����벻����</li>"
	end if
	if strAdminName = "" then
		strErr = strErr & "<li>�û���Ϊ�գ�</li>"
	end if
	if G_CONN.execute("select count(*) as reccount from admin where adminname='" & strAdminName & "'")("reccount") > 0 then
		strErr = strErr & "<li>ϵͳ���Ѵ��ڴ��û�����</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	G_CONN.execute "insert into admin (adminname,adminpwd,adminpurview) values ('" & Replace(strAdminName,"'","''") & "','" & Replace(strAdminPwd,"'","''") & "'," & intAdminPurview & ")"
	call closeConn()
	response.redirect "admin_admin.asp"
end sub

sub modify()	'�޸Ĳ���Ա����
	dim rsAdmin,strSqlAdmin,intAdminID,strErr
	
	strErr = ""
	intAdminID = CLng(trim(request.querystring("adminid")))
	strSqlAdmin = "select * from admin where adminid=" & intAdminID
	set rsAdmin = server.createobject("ADODB.Recordset")
	rsAdmin.open strSqlAdmin,G_CONN,1,1
	if rsAdmin.bof and rsAdmin.eof then
		strErr = "<li>�˲���Ա�����ڣ�</li>"
	elseif rsAdmin("adminname") = "admin" then
		strErr = "<li>��������Ա���ܱ��޸ģ�</li>"
	end if
	if strErr <> "" then
		rsAdmin.close
		set rsAdmin = nothing
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
%>
<form action="admin_admin.asp" method="post">
<input name="action" type="hidden" value="savemodify">
<input name="adminid" type="hidden" value="<%=rsAdmin("adminid")%>">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="2" align="center"> �� �� �� �� Ա </td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">��¼���ƣ�</td>
		<td>
			<input name="adminname" type="text" class="text" size="20" maxlength="25" value="<%=rsAdmin("adminname")%>">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">��¼���룺(���ղ��޸�)</td>
		<td>
			<input name="adminpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">ȷ�����룺(���ղ��޸�)</td>
		<td>
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="50" value="">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="170" align="right">Ȩ�����ã�</td>
		<td>
			<input name="adminpurview_subject" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_SUBJECT) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="1">ά������&nbsp;&nbsp;
			<input name="adminpurview_student" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_STUDENT) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="2">ά����������&nbsp;&nbsp;
			<input name="adminpurview_project" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_PROJECT) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="4">ά�����Լƻ�&nbsp;&nbsp;
			<input name="adminpurview_course" 
			<%
			if (rsAdmin("adminpurview") and CONST_PURVIEW_COURSE) > 0 then
				response.write "checked"
			end if
			%>
			 type="checkbox" value="8">ά���γ̵���
		</td>
	</tr>
	<tr class="tdbg">
		<td colspan="2" align="center">
			<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;
			<input type="reset" value="&nbsp;��&nbsp;&nbsp;д&nbsp;">
		</td>
	</tr>
</table>
</form>
</body>
</html>
<%
	rsAdmin.close
	set rsAdmin = nothing
end sub

sub saveModify()	'�����޸Ľ��
	dim rsAdmin,strSqlAdmin,intAdminID,strAdminName,strAdminPwd,intAdminPurview,strErr
	strErr = ""
	intAdminID = CLng(Trim(request.form("adminid")))
	if IsNumeric(Trim(request.form("adminpurview_subject"))) = true then
		intAdminPurview = CLng(Trim(request.form("adminpurview_subject")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_student"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_student")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_project"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_project")))
	end if
	if IsNumeric(Trim(request.form("adminpurview_course"))) = true then
		intAdminPurview = intAdminPurview + CLng(Trim(request.form("adminpurview_course")))
	end if
	strAdminName = Trim(request.form("adminname"))
	strAdminPwd = Trim(request.form("adminpwd"))
	if intAdminPurview < 1 or intAdminPurview > 15 then
		strErr = "<li>Ȩ�����ô���</li>"
	end if
	if strAdminPwd <> Trim(request.form("confirmpwd")) then
		strErr = strErr & "<li>������ȷ�����벻����</li>"
	end if
	if strAdminName = "" then
		strErr = strErr & "<li>�û���Ϊ�գ�</li>"
	end if
	if strErr <> "" then
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	set rsAdmin = server.createobject("ADODB.Recordset")
	strSqlAdmin = "select * from admin where adminid=" & intAdminID
	rsAdmin.open strSqlAdmin,G_CONN,1,3
	if rsAdmin.bof and rsAdmin.eof then
		strErr = "<li>Ҫ�޸ĵ��û������ڣ�</li>"
	elseif strAdminName <> rsAdmin("adminname") and G_CONN.execute("select count(*) as reccount from admin where adminname='" & Replace(strAdminName,"'","''") & "'")("reccount") > 0 then
		strErr = "<li>���û����ѱ�������ʹ�ã�</li>"
	end if
	if strErr <> "" then
		rsAdmin.close
		set rsAdmin = nothing
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	rsAdmin("adminname") = strAdminName
	if strAdminPwd <> "" then
		rsAdmin("adminpwd") = strAdminPwd
	end if
	rsAdmin("adminpurview") = intAdminPurview
	rsAdmin.update
	rsAdmin.close
	set rsAdmin = nothing
	call closeConn()
	response.redirect "admin_admin.asp"
end sub

sub del()	'ɾ������Ա
	dim intAdminID,strErr
	
	intAdminID = CLng(Trim(request.querystring("adminid")))
	if G_CONN.execute("select * from admin where adminid=" & intAdminID)("adminname") = "admin" then
		strErr = "<li>���������ܱ�ɾ����</li>"
		call closeConn()
		showErrMsg(strErr)
		response.write "</body></html>"
		exit sub
	end if
	G_CONN.execute "delete from admin where adminid=" & intAdminID
	call closeConn()
	response.redirect "admin_admin.asp"
end sub
%>