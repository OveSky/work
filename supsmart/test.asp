<!--#include file="inc/Main.asp"-->
<%

if instr(request.ServerVariables("HTTP_USER_AGENT"),"MicroMessenger")<=0 then alert "请在微信浏览器中打开！","",""

dim IsWeiXin,ConnVIP,rsVIP,USENAME,VipOrder
if instr(request.ServerVariables("HTTP_USER_AGENT"),"MicroMessenger")>0 then  
	IsWeiXin=1  '微信端

	dim code : code = getForm("code","get")
	if isnul(session("openid")) and isnul(code) then 
		response.Redirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid="&wxFAppId&"&redirect_uri="&server.urlencode(MyUrl())&"&response_type=code&scope=snsapi_base&state=1#wechat_redirect")
	else
		dim GetOpenIDUrl : 	GetOpenIDUrl="https://api.weixin.qq.com/sns/oauth2/access_token?appid="&wxAppId&"&secret="&wxAppsecret&"&code="&code&"&grant_type=authorization_code"
		strJson=GetURL(GetOpenIDUrl)
		if not InStr(strJson,"errcode")>0 then
			Call InitScriptControl
			Set objTest = getJSONObject(strJson)
			   session("openid")=objTest.openid
			Set objTest=nothing
		end if

		Set ConnVIP=Server.CreateObject("SsFadodb.SsFConn")
		set rsVIP=ConnVIP.Rs("wS","SsF","select * from Idea_User where OpenID='"&(session("openid"))&"'",1)
			if len(rsVIP("UserName"))>0 then
				USENAME=replace(rsVIP("UserName")," ","")
				VipOrder=rsVIP("VipOrder")
			else
				response.write("<h1>你无权限查看内容。<br></h1>")
				response.End()
			end if
		rsVIP.close:Set rsVIP=nothing
		set connVIP=nothing
	end if
ELSE
'OA 手机web端
	USERID=replace(Request.Cookies("oabusyusername")," ","")
	if len(USERID)>1 then
		Set ConnVIP=Server.CreateObject("SsFadodb.SsFConn")
		set rsVIP=ConnVIP.Rs("O","SsF","SELECT name,password FROM  userinf WHERE (username = N'"&(USERID)&"')",1)
		USENAME=replace(rs("name")," ","")
		oabusyuserpassword=replace(rs("password")," ","")
		rs.close:set rs=nothing
		set connVIP=nothing
	end if


end if




%>


<%=USENAME%><br>
<%=VipOrder%>



