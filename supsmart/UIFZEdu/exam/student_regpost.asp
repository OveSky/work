<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!--#include file="inc/conn.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>����ע��</title>
<link href="student.css" rel="stylesheet" type="text/css">
</head>

<body>
<%
	dim strErr	'������Ϣ
	dim strUserName,strPwd,strStudentName,strTel,strEmail,blnSex,dteBirthday,intStudentType
	dim strSqlReg,rsReg	'�����ѯ�����ַ�����Recordset����
	
	set rsReg =  Server.CreateObject("ADODB.Recordset")	'����ADO����

	'��������û�ע����Ϣ����Ч����֤
	strErr = ""
	'�û�����֤
	if trim(request.form("username")) = "" then
		strErr = strErr & "<li>�û���Ϊ��</li>" & vbcrlf
	else
		strUserName = trim(request.form("username"))
		'�ж�ϵͳ���Ƿ��Ѵ��ڴ��û���
		strSqlReg = "select studentid from student where username='" & strUserName & "'"
		rsReg.open strSqlReg,G_CONN,1,1
		if not rsReg.bof or not rsReg.eof then
			strErr = strErr & "<li>���û����Ѵ���</li>" & vbcrlf
		end if
		rsReg.close
	end if
	'������֤
	if trim(request.form("pwd")) = "" then
		strErr = strErr & "<li>����Ϊ��</li>" & vbcrlf
	elseif trim(request.form("pwd")) <> trim(request.form("confirmpwd")) then
		strErr = strErr & "<li>������ȷ�����벻��</li>" & vbcrlf
	else
		strPwd = trim(request.form("pwd"))
	end if
	'����������֤
	if not IsDate(trim(request.form("birthday"))) then
		strErr = strErr & "<li>�����������</li>" & vbcrlf
	else
		dteBirthday = CDate(trim(request.form("birthday")))
	end if
	'��ʵ������֤
	if trim(request.form("studentname")) = "" then
		strErr = strErr & "<li>��ʵ����Ϊ��</li>" & vbcrlf
	else
		strStudentName = trim(request.form("studentname"))
	end if
	'�Ա���֤
	if CInt(trim(request.form("sex"))) > 0 then
		blnSex = true
	else
		blnSex = false
	end if
	strEmail = trim(request.form("email"))
	strTel = trim(request.form("tel"))
	
	if strErr = "" then	'ͨ����֤���ע����Ϣ��ӵ����ݿⲢ�����û��ɹ�ע����Ϣ��������ҳ
		'�����ݿ������ע����Ϣ
		strSqlReg = "select * from student where studentid=0"
		rsReg.open strSqlReg,G_CONN,1,3
		rsReg.addnew
		rsReg("username") = strUserName
		rsReg("studentpwd") = strPwd
		rsReg("studentname") = strStudentName
		rsReg("sex") = blnSex
		rsReg("email") = strEmail
		rsReg("tel") = strTel
		rsReg("birthday") = dteBirthday
		rsReg("studenttype") = 0	'�������ͣ�0Ϊ�������Ŀ�����
		rsReg.update
		'�ͷ���Դ���ر����ݿ�����
		rsReg.close
		set rsReg = nothing
		call closeConn()
		'��ʾ�ɹ���Ϣ
%>
	<table width="500" align="center" cellspacing="1" cellpadding="5" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF">ע&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				��ϲ�㣡<br>
				���Ѿ��ɹ����ע����̣���ȴ�����Ա������ֻ�й���Ա������������ܵ�¼��ϵͳ��<br>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center" height="30">
				<button onClick="window.open('index_main.asp','main');">&nbsp;������ҳ&nbsp;</button>
			</td>
		</tr>
	</table>
<%
	else	'δͨ����֤����ʾ������Ϣ��������ע��ҳ��
%>
	<table width="500" align="center" cellspacing="1" cellpadding="5" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF">ע&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;ʧ&nbsp;&nbsp;&nbsp;&nbsp;��</font>
			</td>
		</tr>
		<tr class="tdbg">
			<td>
				ע��ʧ�ܿ���������ԭ����ɣ�<br>
				<%=strErr%>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				<button onClick="history.go(-1);">&nbsp;������һҳ&nbsp;</button>
			</td>
		</tr>
	</table>
<%
	end if	
%>
</body>
</html>
