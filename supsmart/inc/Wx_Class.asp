<%
'微信接口函数
dim Access_token,Sendtext,strJson,objTest,Token_Time,Expires_In
Dim GetTokenUrl:GetTokenUrl="https://api.weixin.qq.com/cgi-bin/token?"	'获取access_token接口
Dim SendMsgUrl:SendMsgUrl="https://api.weixin.qq.com/cgi-bin/message/custom/send?"	'发送消息接口
Dim SendMenuUrl:SendMenuUrl="https://api.weixin.qq.com/cgi-bin/menu/"	'自定义菜单接口
'Dim GetUserListUrl:GetUserListUrl="https://api.weixin.qq.com/cgi-bin/user/get?"	'获取粉丝列表
Dim GetUserInfoUrl:GetUserInfoUrl="https://api.weixin.qq.com/cgi-bin/user/info?"	'获取粉丝信息接口
Dim UpPicUrl:UpPicUrl="https://api.weixin.qq.com/cgi-bin/media/upload?access_token="	'增加临时素材接口
Dim GetEwmUrl:GetEwmUrl="https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token="  '获取永久二维码接口
Dim TemplateSendUrl:TemplateSendUrl="https://api.weixin.qq.com/cgi-bin/message/template/send?access_token="  '获取模块发送格式接口


'主动发送消息给管理员
Function PostMsgManager(MsgType,FromUserOpenid,Content)
	dim MsgTypeV
	select case MsgType
		case 1
			MsgTypeV="新增关注"
		case 2
			MsgTypeV="发言"
		case 3
			MsgTypeV="回复"
	end select
	dim RConn,Rrs,PMUserName
	Set RConn=Server.CreateObject("SsFadodb.SsFConn")
	set Rrs=RConn.Rs("wS","SsF","SELECT NickName, UserName, openID  FROM dbo.Idea_User  WHERE  (openID ='"&FromUserOpenid&"')" ,1)
	PMUserName=Rrs(1)
	Rrs.close:set Rrs=nothing
	set RConn=nothing		
	
	Access_token=GetToken()
	strJson=GetURL(GetUserInfoUrl&"&access_token="&Access_token&"&openid="&FromUserOpenid&"")
	Call InitScriptControl:Set objTest = getJSONObject(strJson)
	if len(objTest.subscribe)>0 and objTest.subscribe=1 then
		if len(PMUserName)>0 then
			PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU","【"&PMUserName&"】"&MsgTypeV&"："&Content '新增关注发顾峥
		else
			PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU","【"&objTest.nickname&"】"&MsgTypeV&"："&Content '新增关注发顾峥
		end if
	else
		PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU",PMUserName& "没有关注"		
	end if
End Function

Function OSPostMsg(MsgType,FromUserOpenid,Content)
	dim MsgTypeV
	select case MsgType
		case 0
			MsgTypeV="通知"
		case 1
			MsgTypeV="公告"
		case 2
			MsgTypeV="系统留言"
		case 3
			MsgTypeV="系统预警"
	end select
	dim RConn,Rrs,PMUserName
	Set RConn=Server.CreateObject("SsFadodb.SsFConn")
	set Rrs=RConn.Rs("wS","SsF","SELECT NickName, UserName, openID  FROM dbo.Idea_User  WHERE  (openID ='"&FromUserOpenid&"')" ,1)
	PMUserName=Rrs(1)
	Rrs.close:set Rrs=nothing
	set RConn=nothing		

	Access_token=GetToken()
	strJson=GetURL(GetUserInfoUrl&"&access_token="&Access_token&"&openid="&FromUserOpenid&"")
	Call InitScriptControl:Set objTest = getJSONObject(strJson)
	if len(objTest.subscribe)>0 and objTest.subscribe=1 then
		PostMsg "",FromUserOpenid,MsgTypeV&"："&"【"&PMUserName&"】"&Content '
		'PostMsg "","ocdJl0yUCC4Z_OCQyDc7D-DieIEU",MsgTypeV&"TO"&"【"&PMUserName&"】"&Content '发顾峥  ocdJl02MV-ouARoTlyvwL1CsJyTU
	else
		PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU",PMUserName& "没有关注"
	end if
End Function

'被动返回文本消息
function RequestSendText(fromusername,tousername,returnstr)
	RequestSendText="<xml>" &_
	"<ToUserName><![CDATA["&fromusername&"]]></ToUserName>" &_
	"<FromUserName><![CDATA["&tousername&"]]></FromUserName>" &_
	"<CreateTime>"&now&"</CreateTime>" &_
	"<MsgType><![CDATA[text]]></MsgType>" &_
	"<Content><![CDATA[" & decodeHtml(returnstr) & "]]></Content>" &_
	"</xml>"
end function

'被动返图文本消息	
function RequestSendPicText(fromusername,tousername,title,descriptions,picurl,url)
	dim t
	t="<xml>"
	t=t&"<ToUserName><![CDATA["&fromusername&"]]></ToUserName>"
	t=t&"<FromUserName><![CDATA["&tousername&"]]></FromUserName>"
	t=t&"<CreateTime>"&now&"</CreateTime>"
	t=t&"<MsgType><![CDATA[news]]></MsgType>"
	t=t&"<ArticleCount>1</ArticleCount>"
	t=t&"<Articles>"
	t=t&"<item>"
	if not isnul(title) then t=t&"<Title><![CDATA["&title&"]]></Title>"
	if not isnul(descriptions) then t=t&"<Description><![CDATA["&descriptions&"]]></Description>"
	if not isnul(picurl) then		
		if instr(LCase(picurl), "http://") <= 0 then : picurl=siteUrl&PubPic&picurl
		t=t&"<PicUrl><![CDATA["&picurl&"]]></PicUrl>"
	end if
	if not isnul(url) then t=t&"<Url><![CDATA["&url&"]]></Url>"
	t=t&"</item>"
	t=t&"</Articles>"
	t=t&"</xml>"
	RequestSendPicText=t
end function

'被动返图片消息	
function RequestSendPic(fromusername,tousername,media_id)
	dim t
	t="<xml>"
	t=t&"<ToUserName><![CDATA["&fromusername&"]]></ToUserName>"
	t=t&"<FromUserName><![CDATA["&tousername&"]]></FromUserName>"
	t=t&"<CreateTime>"&now&"</CreateTime>"
	t=t&"<MsgType><![CDATA[image]]></MsgType>"
	t=t&"<Image>"
    t=t&"<MediaId><![CDATA["&media_id&"]]></MediaId>"
    t=t&"</Image>"
	t=t&"</xml>"
	RequestSendPic=t
end function


'查找关键字
function GetPicMsgBack(keyword)
    dim id,title,descriptions,picurl,url,rsObj,rsObj1
	keyword=encodeHtml(keyword)
	if keyword="getcode" then
	    set rsObj1=conn.db("select * from {pre}User where OpenID='"&FromUserName&"'","1")
			if datediff("s",FromUnixTime(rsObj1("REwmDate")),Now())<259200 then
				GetPicMsgBack=RequestSendPic(FromUserName,ToUserName,rsObj1("REwmID"))
			else
				Upload_PicMedia PubPic&"myewm"&rsObj1("ID")&".jpg",FromUserName
				GetPicMsgBack=RequestSendPic(FromUserName,ToUserName,conn.db("select REwmID from {pre}User where OpenID='"&FromUserName&"'","1")(0))
			end if
		rsObj1.close
		set rsObj1=nothing
	end if
end function

'调用关注回复
function GetSubscribeBack(keys)
    if keys=0 then
		if cint(configArr(13,0))=0 then
			GetSubscribeBack=RequestSendText(FromUserName,ToUserName,codeTextarea(configArr(14,0),"de"))
		else
			GetSubscribeBack=""
		end if
	else
	    dim pmsg : pmsg=PostMsg("",keyToOpenID(keys),"用户 “"&OpenidToNick(keyToOpenID(keys))&"” 您好，我们以打飞的的速度欣喜的告诉您。 “"&OpenidToNick(FromUserName)&"” 已经通过您的推广码关注了我们，一旦他购买我们商品，您将获取一定佣金！")
		GetSubscribeBack=RequestSendText(FromUserName,ToUserName,"亲爱的 “"&OpenidToNick(FromUserName)&"” ，您好。你已经通过 “"&OpenidToNick(keyToOpenID(keys))&"” 的介绍加入我们。在这里你不仅可以购买我们的特价商品，还可以通过 我的地盘-我要分销 获取您的推广码，有客户通过您的推广码关注并购买商品后，您将获得对应佣金！")
	end if
End function

'主动发送文本消息
Function PostMsg(FromUserName,ToUserName,StrMsg)
	Access_token=GetToken()
	Sendtext="{""touser"":"""&ToUserName&""",""msgtype"":""text"",""text"":{""content"":"""&StrMsg&"""}}"
	strJson=PostURL(SendMsgUrl&"&access_token="&Access_token,Sendtext)
	Call InitScriptControl: Set objTest = getJSONObject(strJson)
	if objTest.errcode="0" then
	else
		PostMsg="发送失败，"&weixin_err(objTest.errcode)
	end if
	Set objTest=nothing
End Function

'主动发送模块消息
Function PostTemplateMsg(FromUserName,ToUserName,StrMsg)
	Access_token=GetToken()
	Sendtext="{""touser"":""ocdJl02MV-ouARoTlyvwL1CsJyTU"",""template_id"":""ocdJl02MV-ouARoTlyvwL1CsJyTU"",""url"":""http://weixin.qq.com/download"",""miniprogram"":{""pagepath"":""index?foo=bar""},""data"":{""first"": {""value"":""恭喜你购买成功！"",""color"":""#173177""},""keyword1"":{""value"":""巧克力"",""color"":""#173177""},""keyword2"": {""value"":""39.8元"",""color"":""#173177""},""keyword3"": {""value"":""2014年9月22日"",""color"":""#173177""},""remark"":{""value"":""欢迎再次购买！"",""color"":""#173177""}}}"
	if len(Request.Cookies("Sendtext"))<1 then
		Response.Cookies("Sendtext")="Sendtext"
	end if
	
	if Sendtext<>Request.Cookies("Sendtext") then
		Response.Cookies("Sendtext")=Sendtext
		Response.Cookies("Sendtext").Expires=now()+1/1440
		strJson=PostURL(TemplateSendUrl&"&access_token="&Access_token,Sendtext)
		Call InitScriptControl: Set objTest = getJSONObject(strJson)
		if objTest.errcode="0" then
		else
			dim PostMsg
			PostMsg="主动发送文本消息 发送失败，"&weixin_err(objTest.errcode)
			response.write("<script>alert('"&PostMsg&"')</script>")
		end if
		Set objTest=nothing
	end if
	
End Function


'主动发送图片消息
Function PostPic(FromUserName,ToUserName,StrMsg)  '
	dim m_id
	m_id=Upload_LPicMedia(StrMsg)
	Access_token=GetToken()
	Sendtext="{""touser"":"""&ToUserName&""",""msgtype"":""image"",""image"":{""media_id"":"""&m_id&"""}}"
	strJson=PostURL(SendMsgUrl&"&access_token="&Access_token,Sendtext)
	Call InitScriptControl: Set objTest = getJSONObject(strJson)
	if objTest.errcode="0" then
	else
		'PostMsg="发送失败，"&weixin_err(objTest.errcode)
		'PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU","图片发送失败用户： "&ToUserName  'objTest.nickname
	end if
	Set objTest=nothing
End Function



'获取用户信息并入库
Sub GetUserInfo(id,stype,keys)
	Access_token=GetToken()
	strJson=GetURL(GetUserInfoUrl&"&access_token="&Access_token&"&openid="&id&"")
	if InStr(strJson,"errcode")>0 then exit sub
	Call InitScriptControl:Set objTest = getJSONObject(strJson)
	dim sql,rsObj
	if stype=1 then
	    if isnul(keys) then keys=0 else keys=cint(re(keys,"qrscene_",""))
	    set rsObj=conn.db("select * from {pre}User where OpenID='"&id&"'","1")
		if rsObj.eof then
		'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	        sql="insert into {pre}User (OpenID,NickName,Working,RSex,RCountry,RProvince,RCity,ParentID,tagid_list,VIPorder) values ('"&id&"','"&objTest.nickname&"',1,"&objTest.sex&",'"&objTest.country&"','"&objTest.province&"','"&objTest.city&"',"&keys&",'"&objTest.tagid_list&"',0)"
			conn.db sql,"0"
			
			PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU","新增关注用户： "&objTest.nickname '新增关注发顾峥
			
		'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
			
		else
		    sql="update {pre}User set Working=1,NickName='"&objTest.nickname&"',RSex="&objTest.sex&",RCountry='"&objTest.country&"',RProvince='"&objTest.province&"',RCity='"&objTest.city&"' where OpenID='"&id&"'"
			conn.db sql,"0"
		end if
		rsObj.close
		set rsObj=nothing
		
		'生成推广二维码
		dim uid : uid=conn.db("select id from {pre}User where OpenID='"&id&"'","1")(0)
		if isnul(objTest.headimgurl) then
			SaveRemoteFile PubPic&"headimg"&uid&".jpg","http://"&siteUrl&PubPic&"tx.jpg"
		else
			SaveRemoteFile PubPic&"headimg"&uid&".jpg",objTest.headimgurl
		end if
		conn.db "update {pre}User set HeadImg='headimg"&uid&".jpg' where OpenID='"&id&"'","0"
		if wxType<>"0" then
			dim strJson1 : strJson1=PostURL(GetEwmUrl&Access_token,"{""action_name"": ""QR_LIMIT_SCENE"", ""action_info"": {""scene"": {""scene_id"": """&uid&"""}}}")
			if InStr(strJson1,"errcode")>0 then exit sub
			Call InitScriptControl:dim objTest1 : Set objTest1 = getJSONObject(strJson1)
			dim myticket : myticket=objTest1.ticket
			Set objTest1=nothing
			SaveRemoteFile PubPic&"ewm"&uid&".jpg","https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket="&myticket
			Jpeg_Thumb server.MapPath(PubPic&"ewm"&uid&".jpg"),server.MapPath(PubPic&"sewm"&uid&".jpg"),"250*250",1,1
			Jpeg_Thumb server.MapPath(PubPic&"headimg"&uid&".jpg"),server.MapPath(PubPic&"sheadimg"&uid&".jpg"),"70*70",1,1
			Mark_Jpeg PubPic&siteLogo,PubPic&"sheadimg"&uid&".jpg","125","32",PubPic&"myewm"&uid&".jpg"
			Mark_Jpeg PubPic&"myewm"&uid&".jpg",PubPic&"sewm"&uid&".jpg",split(ewmLocation,"*")(0),split(ewmLocation,"*")(1),PubPic&"myewm"&uid&".jpg"
			Mark_Txt PubPic&"myewm"&uid&".jpg",objTest.nickname
			myfile.delFile PubPic&"sheadimg"&uid&".jpg"
			myfile.delFile PubPic&"sewm"&uid&".jpg"
			conn.db "update {pre}User set REwm='myewm"&uid&".jpg' where OpenID='"&id&"'","0"
			Upload_PicMedia PubPic&"myewm"&uid&".jpg",id
		end if
	else
	    sql="update {pre}User set Working=0 where OpenID='"&id&"'"
		conn.db sql,"0"
	end if
	
	Set objTest=nothing
End Sub

'网页获取OpenID
Sub GetOpenID(Url)
    dim code : code = getForm("code","get")
    dim openid : openid=session("openid")
	dim uid : uid = getForm("uid","get")
	dim rsObj
	 '服务号
		if isnul(openid) and isnul(code) then  '这里需要改成不弹窗口的
			response.Redirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid="&wxAppId&"&redirect_uri="&server.urlencode(Url)&"&response_type=code&scope=snsapi_base&state=1#wechat_redirect")
			'response.Redirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid="&wxFAppId&"&redirect_uri="&Url&"&response_type=code&scope=snsapi_base&state=1#wechat_redirect")
			%><%=code%><br><%
			
		else
			if isnul(openid) then
				dim GetOpenIDUrl : GetOpenIDUrl="https://api.weixin.qq.com/sns/oauth2/access_token?appid="&wxAppId&"&secret="&wxAppsecret&"&code="&code&"&grant_type=authorization_code"
				strJson=GetURL(GetOpenIDUrl)
				if not InStr(strJson,"errcode")>0 then
					Call InitScriptControl
					Set objTest = getJSONObject(strJson)
					session("openid")=objTest.openid
					set rsObj=conn.db("select * from {pre}User where OpenID='"&objTest.openid&"'","1")
					
						if rsObj.eof then
							dim GetUserUrl : GetUserUrl="https://api.weixin.qq.com/sns/userinfo?access_token="&objTest.access_token&"&openid="&objTest.openid&"&lang=zh_CN"
							dim strJson8 : strJson8=GetURL(GetUserUrl)
							if not InStr(strJson8,"errcode")>0 then
								Call InitScriptControl
								dim objTest8 : Set objTest8 = getJSONObject(strJson8)
			'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
									dim sql : sql="insert into {pre}User (OpenID,NickName,Working,RSex,RCountry,RProvince,RCity,ParentID,VIPorder) values ('"&objTest.openid&"','"&objTest8.nickname&"',0,"&objTest8.sex&",'"&objTest8.country&"','"&objTest8.province&"','"&objTest8.city&"',"&uid&"',99)"
									conn.db sql,"0"
								Set objTest8=nothing
							end if
						end if
			
				session("NickName")=rsObj("NickName")	
				session("Employee")=rsObj("Employee")   '中文的
				session("oabusyusername")=rsObj("oabusyusername")  '英文的
				session("VIPorder")=rsObj("VIPorder")	
			'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$			
	
    					
						
					rsObj.close : set rsObj=nothing
					Set objTest=nothing
				end if
			end if
		end if
	
End Sub

'获取最新Access_token
Private function GetToken()
	Access_token=configArr(18,0)
	Token_Time=configArr(19,0)
	Expires_In=600'configArr(20,0)  '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$	
	GetToken=Access_token
	If datediff("s",Token_Time,Now())>Expires_In then '当Access_token过期时，重新获取新Access_token
		strJson=GetURL(GetTokenUrl&"grant_type=client_credential&appid="&wxAppId&"&secret="&wxAppsecret&"")
		if InStr(strJson,"errcode")>0 then GetToken="":exit function
		Call InitScriptControl:Set objTest = getJSONObject(strJson)
		Access_token=objTest.access_token	'获取新Access_token
		Expires_In=objTest.expires_in
		
		if len(Access_token)<5 then
			PostMsg "","ocdJl02MV-ouARoTlyvwL1CsJyTU","发送失败"&objTest.nickname
		else
			conn.db "update {pre}Config set Access_token='"&Access_token&"',Token_Time='"&now()&"',Expires_In="&Expires_In&"","0"
		end if	
		
		GetToken=Access_token
		Set objTest=nothing
	End If
End function

'Post内容
Function PostURL(url,PostStr)
	dim Retrieval : Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
	With Retrieval
		.Open "POST", url, false ,"" ,""
		.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
		.Send(PostStr)
		PostURL = .responsetext
	End With
	Set Retrieval = Nothing
End Function

'Get内容
Function GetURL(url)
	dim http
	set http=server.createobject("microsoft.xmlhttp")
		http.open "get",url,false
		http.setRequestHeader "If-Modified-Since","0"
		http.send()
		GetURL=http.responsetext
	set http=nothing
End Function

'下载生成的二维码
Sub SaveRemoteFile(LocalFileName,RemoteFileUrl)
    dim Ads,Retrieval,GetRemoteData
    Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
    With Retrieval
    .Open "Get", RemoteFileUrl, False, "", ""
    .Send
    GetRemoteData = .ResponseBody
    End With
    Set Retrieval = Nothing
    Set Ads = Server.CreateObject("Adodb.Stream")
    With Ads
    .Type = 1
    .Open
    .Write GetRemoteData
    .SaveToFile server.MapPath(LocalFileName),2
    .Cancel()
    .Close()
    End With
    Set Ads=nothing
End Sub

'时间戳转换成普通日期
Function FromUnixTime(intTime) 
	If IsEmpty(intTime) or not isNum(intTime) Then 
		FromUnixTime = Now() 
		Exit Function 
	End If 	
	FromUnixTime = DateAdd("s", intTime, "1970-1-1 0:0:0") 
	FromUnixTime = DateAdd("h", 8, FromUnixTime) 
End Function
'生成时间戳
Function ToUnixTime(strTime, intTimeZone)
    If IsEmpty(strTime) or Not IsDate(strTime) Then strTime = Now
    If IsEmpty(intTimeZone) or Not isNumeric(intTimeZone) Then intTimeZone = 0
    ToUnixTime = DateAdd("h",-intTimeZone,strTime)
    ToUnixTime = DateDiff("s","1970-01-01 00:00:00", ToUnixTime)
End Function

'解析json
Dim sc4Json   
Sub InitScriptControl    
	Set sc4Json = Server.CreateObject("MSScriptControl.ScriptControl")    
	sc4Json.Language = "JavaScript"    
	sc4Json.AddCode "var itemTemp=null;function getJSArray(arr, index){itemTemp=arr[index];}"    
End Sub 
Function getJSONObject(strJSON)    
	sc4Json.AddCode "var jsonObject = " & strJSON    
	Set getJSONObject = sc4Json.CodeObject.jsonObject    
End Function 
Sub getJSArrayItem(objDest,objJSArray,index)    
	On Error Resume Next    
	sc4Json.Run "getJSArray",objJSArray, index    
	Set objDest = sc4Json.CodeObject.itemTemp    
	If Err.number=0 Then Exit Sub    
	objDest = sc4Json.CodeObject.itemTemp    
End Sub

%>