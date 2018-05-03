<!--#include file="admin_inc.asp"-->



<%
dim action
action = getForm("action", "get")
Select case action
	case "login" : login
	case "check" : login : checkLogin
	case "loginout" : clearPower
	case else : main
End Select
terminateAllObjects

Sub login
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=siteName%>-后台登陆中心</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="images/login.css" rel="stylesheet" type="text/css" />
</head>
<body>
<!-- Login block -->
    <div class="login">
        <div class="navbar">
            <p><img src="images/login_logo.png"></p>
        </div>
        <div class="well">
            <div class="navbar-inner">
                <li><span>网站后台登陆</span></li>
            </div>
            <form method="post" action="index.asp?action=check" class="row-fluid">
                <div class="control-group">
                    <div class="icon"><i class="icon-user"></i></div>
                    <div class="controls"><input class="span12" type="text" name="input_name" id="input_name" /></div>
                </div>
                
                <div class="control-group">
                    <div class="icon"><i class="icon-lock"></i></div>
                    <div class="controls"><input class="span12" type="password" name="input_pwd" id="input_pwd" /></div>
                </div>

                <div class="control-group">
                    <div class="icon"><i class="icon-qrcode"></i></div>
                    <div class="code"><img id="safecode" src="../inc/code.asp" title="看不清,点击换一张" onClick="reloadcode();" style="cursor:pointer;" /></div>
                    <div class="controls"><input class="span13" type="text" name="input_yzm" id="input_yzm"/></div>
                </div>
                
                <div class="login-btn"><input type="submit" value="登 录" class="btn btn-danger btn-block" /></div>
            </form>
        </div>
    </div>
    <div class="nav_foot">Copyright © 2015 <a href="http://www.ideacms.net" target="_blank" title="IdeaCMS微信O2O营销系统">IdeaCMS.net</a> All rights reserved.</div>
    <!-- /login block -->
</html>
<script language="javascript" charset="utf-8"> 
function reloadcode() 
{ 
    document.getElementById("safecode").src ="../inc/code.asp?" + Math.random()
} 
</script> 
<%
End Sub

Sub main
checkPower ""
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=siteName%>-后台首页</title>
</head>
<frameset rows="70,*" cols="*" frameborder="no" border="0" framespacing="0">
    <frame src="admin_top.asp" name="topFrame" scrolling="No" noresize="noresize" id="topFrame" />
    <frameset cols="155,*" frameborder="no" border="0" framespacing="0" id="frame">
        <frame src="admin_left.asp" name="leftFrame" scrolling="auto" noresize="noresize" id="leftFrame" />
        <frame src="admin_main.asp" name="mainFrame" id="mainFrame" />
    </frameset>
</frameset>
<noframes><body></body></noframes>
</html>
<%
End Sub

Sub checkLogin
	dim username,pwd,validcode,errStr,rsObj,errFlag,ip,verifycode
	errFlag = false : errStr="" : ip = getIp
	if isOutSubmit then errFlag = true : errStr = errStr&"非法外部提交被禁止<br>"
	username = getForm("input_name","post") : pwd = getForm("input_pwd","post") : validcode = getForm("input_yzm","post")
	if Session("GetCode")<>validcode then errFlag = true : errStr = errStr&"验证码错误<br>"
	if isNul(username) or isNul(pwd) then errFlag = true : errStr = errStr&"用户名或密码为空<br>"
	set rsObj = conn.db("select * from {pre}Manager where UserName='"&username&"'","1")
	if rsObj.eof then
		 errFlag = true : errStr = errStr&"用户名不存在<br>"
	else
		if clng(rsObj("Working")) = 0 then errFlag = true : errStr = errStr&"账户已被锁定<br>"
		if trim(rsObj("Password")) <> md5(pwd) then errFlag = true : errStr = errStr&"密码不正确<br>"
		if not errFlag then	
		    verifycode=DateFormat(now,"yyyymmddhhnnss")
			setCookie "UserName",decodeHtml(rsObj("UserName"))
			setCookie "Verifycode",verifycode
			setCookie "UserRole",idToRole(rsObj("RoleID"))
			setCookie "RoleID",rsObj("RoleID")
			conn.db "update {pre}Manager set LastLoginTime='"&date()&"',LastLoginIP='"&ip&"',Verifycode='"&verifycode&"',LoginTimes=LoginTimes+1 where UserName='"&username&"'","0"
			Echo "<script>top.location.href='index.asp';</script>"
		end if
	end if
	echoMsg 0,"",errStr
End Sub

Sub clearPower
	setCookie "UserName",""
	setCookie "Verifycode",""
	setCookie "UserRole",""
	setCookie "RoleID",""
	Echo "<script>top.location.href='index.asp?action=login';</script>"
End Sub
%>
