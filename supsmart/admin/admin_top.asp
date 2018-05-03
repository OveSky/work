<!--#include file="admin_inc.asp"-->
<% checkPower "" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=siteName%>-后台头部</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="images/Main.css" rel="stylesheet" type="text/css" />
<script type="text/JavaScript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div id="uptop">
    <div class="up_logo"><img src="images/logo.png" /></div>
    <div class="up_rctr"><div class="up_ico3" onclick="location.href='index.asp?action=loginout';">退出系统</div></div>
    <div class="up_rctr"><div class="up_ico2" onclick="window.parent.frames.mainFrame.location.reload();">系统刷新</div></div>
    <div class="up_rctr"><div class="up_ico1">修改密码</div></div>
    <div class="up_rctr">
        <div class="up_pic"></div>
        <div class="up_ptxt"><%=readCookie("UserName")%>，<br /><%=readCookie("UserRole")%>！</div>
    </div>
</div>
</body>
</html>
<%terminateAllObjects%>