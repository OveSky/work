<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>����ע��</title>
<link href="student.css" rel="stylesheet" type="text/css">
<Script Laguage="JScript">
	//�ڿͻ�����֤�û�����Ϸ���
	function confirmInput()
	{
		if(document.frmReg.username.value == '')
		{
			alert('��¼���Ʋ���Ϊ��!');
			document.frmReg.username.focus();
			return false;
		}
		if(document.frmReg.pwd.value == '')
		{
			alert('���벻��Ϊ��!');
			document.frmReg.pwd.focus();
			return false;
		}
		if(document.frmReg.pwd.value != document.frmReg.confirmpwd.value)
		{
			alert('������ȷ�����벻��!');
			document.frmReg.confirmpwd.focus();
			return false;
		}
		if(document.frmReg.studentname.value == '')
		{
			alert('�����������ʵ������');
			document.frmReg.studentname.focus();
			return false;
		}
		if(document.frmReg.birthday.value == '')
		{
			alert('�밴��ȷ��ʽ����������ա�');
			document.frmReg.birthday.focus();
			return false;
		}
		document.frmReg.submit();
	}
</Script>
</head>

<body>
<form name="frmReg" action="student_regpost.asp" target="main" method="post">
<table width="90%" align="center" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
	<tr class="tdtbg">
		<td colspan="3" align="center">
			<font color="#FFFFFF"><strong>�� �� �� ע ��</strong></font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			��¼���ƣ�
		</td>
		<td> 
			<input name="username" type="text" class="text" size="20" maxlength="25"> <font color="red">*</font>
		</td>
		<td width="257">
			��¼���Ʊ�������ĸ�����֡��»��ߵ��ַ�������ҳ��Ȳ��ܳ���25���ַ���
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			��¼���룺
		</td>
		<td colspan=2> 
			<input name="pwd" type="password" class="text" size="20" maxlength="25"> <font color="red">*</font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			ȷ�����룺
		</td>
		<td width="156"> 
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="25"> <font color="red">*</font>
		</td>
		<td>
			��������һ��������롣
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			��ʵ������
		</td>
		<td> 
			<input name="studentname" type="text" class="text" size="15" maxlength="50" colspan="2"> <font color="red">*</font>
		</td>
		<td>
			�����������ʵ������
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			�Ա�
		</td>
		<td colspan="2"> 
			<input name="sex" type="radio" checked value="1">��</input>&nbsp;&nbsp;
			<input name="sex" type="radio" value="0">Ů</input>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			�������ڣ�
		</td>
		<td> 
			<input name="birthday" type="text" class="text" size="15" maxlength="16"> <font color="red">*</font>
		</td>
		<td>
			�밴��ȷ��ʽ��д����<br>�磺1983-11-3 1983��11��3�ա�
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			E-mail��ַ��
		</td>
		<td colspan="2"> 
			<input name="email" type="text" class="text" size="24" maxlength="128">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			�绰���룺
		</td>
		<td colspan="2"> 
			<input name="tel" type="text" class="text" size="20" maxlength="50">
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" height="30" colspan="3"> 
			<input type="button" onClick="confirmInput();" value="&nbsp;ע&nbsp;&nbsp;��&nbsp;">&nbsp;&nbsp;
			<input type="reset"  value="&nbsp;��&nbsp;&nbsp;д&nbsp;">
		</td>
	</tr>
</table>
</form>
</body>
</html>
