<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考生注册</title>
<link href="student.css" rel="stylesheet" type="text/css">
<Script Laguage="JScript">
	//在客户端验证用户输入合法性
	function confirmInput()
	{
		if(document.frmReg.username.value == '')
		{
			alert('登录名称不能为空!');
			document.frmReg.username.focus();
			return false;
		}
		if(document.frmReg.pwd.value == '')
		{
			alert('密码不能为空!');
			document.frmReg.pwd.focus();
			return false;
		}
		if(document.frmReg.pwd.value != document.frmReg.confirmpwd.value)
		{
			alert('密码与确认密码不符!');
			document.frmReg.confirmpwd.focus();
			return false;
		}
		if(document.frmReg.studentname.value == '')
		{
			alert('请输入你的真实姓名。');
			document.frmReg.studentname.focus();
			return false;
		}
		if(document.frmReg.birthday.value == '')
		{
			alert('请按正确格式输入你的生日。');
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
			<font color="#FFFFFF"><strong>新 考 生 注 册</strong></font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			登录名称：
		</td>
		<td> 
			<input name="username" type="text" class="text" size="20" maxlength="25"> <font color="red">*</font>
		</td>
		<td width="257">
			登录名称必需是字母、数字、下划线等字符的组合且长度不能超过25个字符。
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			登录密码：
		</td>
		<td colspan=2> 
			<input name="pwd" type="password" class="text" size="20" maxlength="25"> <font color="red">*</font>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			确认密码：
		</td>
		<td width="156"> 
			<input name="confirmpwd" type="password" class="text" size="20" maxlength="25"> <font color="red">*</font>
		</td>
		<td>
			请再输入一次你的密码。
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			真实姓名：
		</td>
		<td> 
			<input name="studentname" type="text" class="text" size="15" maxlength="50" colspan="2"> <font color="red">*</font>
		</td>
		<td>
			请输入你的真实姓名。
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			性别：
		</td>
		<td colspan="2"> 
			<input name="sex" type="radio" checked value="1">男</input>&nbsp;&nbsp;
			<input name="sex" type="radio" value="0">女</input>
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			出生日期：
		</td>
		<td> 
			<input name="birthday" type="text" class="text" size="15" maxlength="16"> <font color="red">*</font>
		</td>
		<td>
			请按正确格式填写日期<br>如：1983-11-3 1983年11月3日。
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			E-mail地址：
		</td>
		<td colspan="2"> 
			<input name="email" type="text" class="text" size="24" maxlength="128">
		</td>
	</tr>
	<tr class="tdbg">
		<td width="81" align="right">
			电话号码：
		</td>
		<td colspan="2"> 
			<input name="tel" type="text" class="text" size="20" maxlength="50">
		</td>
	</tr>
	<tr class="tdbg">
		<td align="center" height="30" colspan="3"> 
			<input type="button" onClick="confirmInput();" value="&nbsp;注&nbsp;&nbsp;册&nbsp;">&nbsp;&nbsp;
			<input type="reset"  value="&nbsp;重&nbsp;&nbsp;写&nbsp;">
		</td>
	</tr>
</table>
</form>
</body>
</html>
