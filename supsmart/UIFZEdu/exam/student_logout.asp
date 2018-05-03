<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%option explicit%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>退出登录</title>
</head>

<body>
<%
'清除用户cookies信息并返回首页
response.cookies("aoyi")("username") = ""
response.cookies("aoyi")("studentid") = ""
response.cookies("aoyi")("studentname") = ""
response.cookies("aoyi")("sex") = ""
response.cookies("aoyi")("birthday") = ""
response.cookies("aoyi")("state") = ""
response.cookies("aoyi")("prjid") = ""
response.cookies("aoyi")("course") = ""
response.cookies("aoyi")("prjname") = ""
response.cookies("aoyi")("prjstarttime") = ""
response.redirect "index.asp"
%>
</body>
</html>
