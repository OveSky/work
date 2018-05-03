<!--#include file="inc/Main.asp"-->
<!--#include file="inc/sha1.asp"-->
<%
dim signature,nonce,timestamp,echostr
dim xml_dom,StrSend
dim ToUserName,FromUserName,CreateTime,MsgType,strEventType
dim Content,MediaId,PicUrl,Format,ThumbMediaId,Location_X,Location_Y,Scale,Label,Title,Descriptions,Url,EventKey
dim Remark

signature = getForm("signature","get")
nonce = getForm("nonce","get")
timestamp = getForm("timestamp","get")
echostr = getForm("echostr","get")

'验证微信接口
If echostr<>"" then
	dim str,M
	dim Myarray:Myarray=Sort(Array(wxToken,timestamp,nonce))
	For M=0 To Ubound(Myarray)
		str=str&Myarray(M)
	Next
	if signature=Lcase(sha1(str)) then
		echo echostr : died
	end if
End if

'接收微信发过来的消息并返回消息到微信
call GetXmlData() : Echo StrSend

'获取微信主动发送过来的内容
Sub GetXmlData	
	set xml_dom = Server.CreateObject("MSXML2.DOMDocument")
	if xml_dom.load(request)=false then
		Died	'判断是否由微信Post正确的XML数据过来
	else
		ToUserName=xml_dom.getelementsbytagname("ToUserName").item(0).text '接收者微信账号。即我们的公众平台账号。
		FromUserName=xml_dom.getelementsbytagname("FromUserName").item(0).text '发送者微信账号。
		CreateTime=xml_dom.getelementsbytagname("CreateTime").item(0).text
		MsgType=xml_dom.getelementsbytagname("MsgType").item(0).text
		select case MsgType
			case "event"
				strEventType=xml_dom.getelementsbytagname("Event").item(0).text '微信事件
				select case strEventType
				    case "subscribe"    '关注
						EventKey=xml_dom.getelementsbytagname("EventKey").item(0).text
						GetUserInfo FromUserName,1,EventKey
						StrSend=GetSubscribeBack(EventKey)
						PostMsgManager 1,FromUserName,""	'提醒管理员
					case "unsubscribe"  '取消关注
						GetUserInfo FromUserName,0,""
						PostMsgManager 0,FromUserName,""	'提醒管理员
					case "CLICK"        '点击关键字
					    EventKey=xml_dom.getelementsbytagname("EventKey").item(0).text
						StrSend=GetPicMsgBack(EventKey)
					case "SCAN"         '扫描带参数二维码已关注后
					    EventKey=xml_dom.getelementsbytagname("EventKey").item(0).text
						PostMsgManager 1,FromUserName,""	'提醒管理员
				end select
			case "text"
				Content=xml_dom.getelementsbytagname("Content").item(0).text
				PostMsgManager 2,FromUserName,Content	'提醒管理员
				dim rsObj : set rsObj=conn.db("select * from {pre}User where OpenID='"&FromUserName&"'","1")
		        if rsObj.eof then GetUserInfo FromUserName,1,"" : rsObj.close : set rsObj=nothing
				StrSend=GetPicMsgBack(Content)
		end select
	end if
	set xml_dom=Nothing	
End Sub

'字典排序
Function Sort(ary)
	Dim KeepChecking,I,FirstValue,SecondValue
	KeepChecking = TRUE 
	Do Until KeepChecking = FALSE 
		KeepChecking = FALSE
		For I = 0 to UBound(ary) 
			If I = UBound(ary) Then Exit For 
			If ary(I) > ary(I+1) Then 
				FirstValue = ary(I)
				SecondValue = ary(I+1)
				ary(I) = SecondValue
				ary(I+1) = FirstValue
				KeepChecking = TRUE
			End If
		Next
	Loop
	Sort = ary 
End Function
%>