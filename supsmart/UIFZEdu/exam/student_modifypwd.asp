<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>�޸Ŀ�������</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
'���ݲ�ͬ�Ĳ���ֵ�������޸Ŀ����ύ�����뻹����ʾ���������޸�ҳ��
if checkStudentLogin() = true then
	if request.form("action") = "modify" then
		call modifyPwd()
	else
		call showModifyPwd()
	end if
else
	response.redirect "student_login.asp"
end if
	
'��ʾ�����޸�ҳ��
sub showModifyPwd()
	dim rsPwd,strSqlPwd
	
	set rsPwd = server.createobject("ADODB.Recordset")
	strSqlPwd = "select * from student where username='" & request.cookies("aoyi")("username") & "'"
	rsPwd.open strSqlPwd,G_CONN,1,1
	if rsPwd.bof or rsPwd.eof then
	rsPwd.close
		set rsPwd = nothing
		response.redirect "student_login.asp"
	end if
%>
	<form action="student_modifypwd.asp" method="post">
		<input name="action" type="hidden" value="modify">
	<table align="center" width="90%" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td colspan="3" align="center">
				<font color="#FFFFFF"><storng>&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right" width="200">
				��¼���ƣ�
			</td>
			<td>
				<%=rsPwd("username")%>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				�����룺
			</td>
			<td>
				<input name="pwd" class="text" type="password" size="18" maxlength="50">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				�����룺
			</td>
			<td>
				<input name="newpwd" class="text" type="password" size="18" maxlength="50">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				ȷ�����룺
			</td>
			<td>
				<input name="confirmpwd" class="text" type="password" size="18" maxlength="50">
			</td>
		</tr>
		<tr class="tdbg">
			<td colspan="2" height="30" align="center">
				<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" onClick="history.go(-1)" value="&nbsp;ȡ&nbsp;&nbsp;��&nbsp;">
			</td>
		</tr>

	</table>
	</form>
<%
	rsPwd.close
	set rsPwd = nothing
end sub
	
'�޸Ŀ�������
sub modifyPwd()
	dim rsModifyPwd,strSqlModifyPwd,strPwd,strNewPwd,strConfirmPwd,strErr
	
	strErr = ""
	'��֤�����ύ����������ȷ�������Ƿ�Ϸ�
	if trim(request.form("newpwd")) = "" then
		strErr = strErr & "<li>������Ϊ�գ�</li>" & vbcrlf
	else
		strNewPwd = trim(request.form("newpwd"))
	end if
	if trim(request.form("newpwd")) <> trim(request.form("confirmpwd"))  then
		strErr = strErr & "<li>��������ȷ�����벻����</li>" & vbcrlf
	else
		strConfirmPwd = trim(request.form("confirmpwd"))
	end if

	strPwd = trim(request.form("pwd"))	
	set rsModifyPwd = server.createobject("ADODB.Recordset")
	strSqlModifyPwd = "select studentpwd from student where username='" & request.cookies("aoyi")("username") & "'"
	rsModifyPwd.open strSqlModifyPwd,G_CONN,1,3
		
	'��֤������¼�Ƿ����
	if rsModifyPwd.bof or rsModifyPwd.eof then
		rsModifyPwd.close
		set rsModifyPwd = nothing
		response.redirect "student_login.asp"
	end if
	'��֤�������Ƿ���ȷ		
	if rsModifyPwd("studentpwd") <> strPwd then
		strErr = strErr & "<li>ԭ�������</li>" & vbcrlf
	end if
		
	if strErr = "" then
		'���ͨ����֤����п����������޸�
		rsModifyPwd("studentpwd") = strPwd
		rsModifyPwd.update
%>
	<table align="center" width="90%" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF"><strong>&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				���� <%=request.cookies("aoyi")("studentname")%> �������Ѿ��ɹ��޸ģ�<br>
				<a href="index.asp" target="_top">������ҳ</a>
			</td>
		</tr>
	</table>
<%
	else	'û��ͨ����֤����ʾ������Ϣ
		showErrMsg(strErr)
	end if
	rsModifyPwd.close
	set rsModifyPwd = nothing
end sub
%>
</body>
</html>
