<!--#include file="inc/Main.asp"-->
<%
session.codepage=65001
response.charset="utf-8"
server.scripttimeout=999999

if instr(request.ServerVariables("HTTP_USER_AGENT"),"MicroMessenger")<=0 then alert "请在微信浏览器中打开！","",""

dim IsWeiXin,IsMobile,ConnVIP,rsVIP,USENAME,EmpID,StuID,NickName,VipOrder
viporder=0
IsWeiXin=0
IsMobile=0
if instr(request.ServerVariables("HTTP_USER_AGENT"),"MicroMessenger")>0 then  
	IsWeiXin=1  '微信端

	dim code : code = getForm("code","get")
	if isnul(session("openid")) and isnul(code) then 
		response.Redirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid="&wxFAppId&"&redirect_uri="&server.urlencode(MyUrl())&"&response_type=code&scope=snsapi_base&state=1#wechat_redirect")
	else
		
			dim GetOpenIDUrl : 			GetOpenIDUrl="https://api.weixin.qq.com/sns/oauth2/access_token?appid="&wxAppId&"&secret="&wxAppsecret&"&code="&code&"&grant_type=authorization_code"
			strJson=GetURL(GetOpenIDUrl)
			if not InStr(strJson,"errcode")>0 then
				Call InitScriptControl
				Set objTest = getJSONObject(strJson)
				   session("openid")=objTest.openid
				Set objTest=nothing
			end if
		
		if isnul(session("openid")) then 
			response.write("<h1>请重新进入入口。<br></h1>")
		else
			Set ConnVIP=Server.CreateObject("SsFadodb.SsFConn")
			set rsVIP=ConnVIP.Rs("wS","SsF","select * from Idea_User where OpenID='"&(session("openid"))&"'",1)
			
				if len(rsVIP("UserName"))>0 then
					USENAME=replace(rsVIP("UserName")," ","")
					EmpID=rsVIP("UserID")
					StuID=rsVIP("StuID")
					VipOrder=cint(rsVIP("VipOrder"))
				else
					'判断是否是绑定网页'
					dim ScriptName
					
					ScriptName = Request.ServerVariables("SCRIPT_NAME") 
					'response.write(ScriptName)
					IF ScriptName<>"/supsmart/UIFZEdu/BindingUser.asp" THEN
						response.write("<h1>你无权限查看内容。<br></h1>")
						Response.Redirect("/supsmart/UIFZEdu/BindingUser.asp")
						response.End()
					end if
				end if
				NickName=rsVIP("NickName")
			rsVIP.close:Set rsVIP=nothing
			set connVIP=nothing
		end if
	end if
ELSE
'OA web端
	


end if

%>



<%
'测试：
'USENAME="华强"
if USENAME="顾峥" then
	'USENAME="周晓丽"
	'VipOrder=20
	'EmpID=27
end if
'VipOrder=0




'权限分配方案'
'从0到99,99。0为访客，最低等级；99为最高等级'
'90以上可以改锁定原始单'其他登记均不可
'0'		访客：
'1-9'	客户权限
'5'		查看自己孩子课程的权限


'10'	新人：实习生，只允许查询通讯录，新人培训教程；
	'11'		

'20'	单店单部门


'30'	多店同部门


'40'	单店店长

'50'	多店店长

'60'	

'70'	
'90'	单店/多店系统维护员

'98'	管理者
'99'	所有者



'获取模块ID 获取模块授权等级'	ModuleOrder
'EmpIndex.asp'		员工 学员首页
dim MO_EI
select case true
	case VipOrder>=90
		MO_EI=9
	case VipOrder>=10 and VipOrder<=89
		MO_EI=2
	case VipOrder>0 and VipOrder<=9
		MO_EI=1
	case else 
		MO_EI=0
end select



'ClassAddTea.asp'  教师排课
dim MO_CAT_AddClass
select case true
	case VipOrder>=90
		MO_CAT_AddClass=9
	
	
	case else 
		MO_CAT_AddClass=0
end select


'ClassSearch.asp'  排课查询
dim MO_CS_AllView,MO_CS_Cdel
select case true
	case VipOrder>=90
		MO_CS_AllView=9 '查看全部排课记录'
	case VipOrder>=40 and VipOrder<=89
		MO_CS_AllView=4 '店长查看单店全部排课记录'
	case VipOrder>=10 and VipOrder<=39
		MO_CS_AllView=1 '只能查看自己的排课记录'
	case else 
		MO_CS_AllView=0 '不可看'
end select
	'ClassP_View.asp'
	if VipOrder>90 then
		MO_CS_Cdel=9	'排课作废'
	else
		MO_CS_Cdel=0
	end if
	
%>


<%
'AddressBook.asp'  通讯录
dim MO_AddBook
select case true
	case VipOrder>=90
		MO_AddBook=9
	case VipOrder>=10 and VipOrder<=89
		MO_AddBook=1
	case else
		MO_AddBook=0
end select
	


'报告'
dim MO_Report
select case true
	case VipOrder>=90
		MO_Report=9
	case VipOrder>=40 and VipOrder<=49
		MO_Report=4
	case VipOrder>=30 and VipOrder<=39
		MO_Report=3	
	case VipOrder>=20 and VipOrder<=29
		MO_Report=2
	case VipOrder>=10 and VipOrder<=19
		MO_Report=1
	case else
		MO_Report=0
end select



%>