<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>�޸Ŀ�����Ϣ</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
'���ݲ�ͬ�Ĳ���ֵ�������޸Ŀ����ύ����Ϣ������ʾ������Ϣ�޸�ҳ��
if checkStudentLogin() = true then
	if request.form("action") = "modify" then
		call modifyInfo()
	else
		call showModifyInfo()
	end if
else
	response.redirect "student_login.asp"
end if

'��ʾ�޸Ŀ�����Ϣҳ��
sub showModifyInfo()
	dim rsInfo,strSqlInfo
	
	set rsInfo = server.createobject("ADODB.Recordset")
	strSqlInfo = "select * from student where username='" & request.cookies("aoyi")("username") & "'"
	rsInfo.open strSqlInfo,G_CONN,1,1
	if rsInfo.bof or rsInfo.eof then
		rsInfo.close
		set rsInfo = nothing
		response.redirect "/student_login.asp"
	end if
%>
	<form action="/student_modifyinfo.asp" method="post">
		<input name="action" type="hidden" value="modify">
	<table align="center" width="90%" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td colspan="3" align="center">
				<font color="#FFFFFF"><strong>&nbsp;��&nbsp;��&nbsp;��&nbsp;Ϣ&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				��¼���ƣ�
			</td>
			<td>
				<%=rsInfo("username")%>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				��ʵ������
			</td>
			<td>
				<input name="studentname" class="text" type="text" size="18" maxlength="25" value="<%=rsInfo("studentname")%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				�Ա�
			</td>
			<td>
				<input name="sex" type="radio" value="1"
				<%
				if rsInfo("sex") = true then
					response.write "checked"
				end if
				%>
				> ��&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="sex" type="radio" value="0"
				<%
				if rsInfo("sex") = false then
					response.write "checked"
				end if
				%>
				> Ů
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				�������ڣ�
			</td>
			<td>
				<input name="birthday" class="text" type="text" size="14" maxlength="20" value="<%=FormatDatetime(rsInfo("birthday"),2)%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				E-mail��ַ��
			</td>
			<td>
				<input name="email" class="text" type="text" size="20" maxlength="128" value="<%=rsInfo("email")%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td align="right">
				�绰���룺
			</td>
			<td>
				<input name="tel" class="text" type="text" size="20" maxlength="50" value="<%=rsInfo("tel")%>">
			</td>
		</tr>
		<tr class="tdbg">
			<td colspan="2" height="30" align="center">
				<input type="submit" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="reset" value="&nbsp;��&nbsp;&nbsp;ԭ&nbsp;">
			</td>
		</tr>

	</table>
	</form>
<%
	rsInfo.close
	set rsInfo = nothing
end sub

'�޸Ŀ�����Ϣ
sub modifyInfo()
	dim rsModifyInfo,strSqlModifyInfo,strStudentName,blnSex,strTel,strEmail,dteBirthday,strErr
	
	strErr = ""
	'��֤�����ύ����Ϣ�Ƿ�Ϸ�
	if trim(request.form("studentname")) = "" then
		strErr = strErr & "<li>��ʵ����Ϊ�ա�</li>" & vbcrlf
	else
		strStudentName = trim(request.form("studentname"))
	end if
	if IsDate(trim(request.form("birthday"))) = false then
		strErr = strErr & "<li>��������δ��д���ʽ����ȷ��</li>" & vbcrlf
	else
		dteBirthday = CDate(trim(request.form("birthday")))
	end if
	if CInt(request.form("sex")) > 0 then
		blnSex = true
	else
		blnSex = false
	end if
	strEmail = trim(request.form("email"))
	strTel = trim(request.form("tel"))
		
	if strErr = "" then
		'���ͨ����֤����п�����Ϣ���޸Ĳ���ʾ�ɹ���Ϣ
		set rsModifyInfo = server.createobject("ADODB.Recordset")
		strSqlModifyInfo = "select * from student where username='" & request.cookies("aoyi")("username") & "'"
		rsModifyInfo.open strSqlModifyInfo,G_CONN,1,3
		'��֤������¼�Ƿ����
		if rsModifyInfo.bof or rsModifyInfo.eof then
			rsModifyInfo.close
			set rsModifyInfo = nothing
			response.redirect "/student_login.asp"
		end if
		'�޸Ŀ�����Ϣ
		rsModifyInfo("studentname") = strStudentName
		rsModifyInfo("sex") = blnSex
		rsModifyInfo("birthday") = dteBirthday
		rsModifyInfo("email") = strEmail
		rsModifyInfo("tel") = strTel
		rsModifyInfo.update
		rsModifyInfo.close
		set rsModifyInfo = nothing
%>
	<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF"><strong>&nbsp;��&nbsp;��&nbsp;��&nbsp;Ϣ&nbsp;</strong></font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				���� <%=request.cookies("studentname")%> ����Ϣ�Ѿ��ɹ��޸ģ�<br>
				<a href="/index.asp" target="_top">������ҳ</a>
			</td>
		</tr>
	</table>
<%
	else	'û��ͨ����֤����ʾ������Ϣ
		showErrMsg(strErr)
	end if
end sub
%>
</body>
</html>