<!--#include file="inc/Main.asp"-->
<!--#include file="inc/MD5.asp"-->



<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

InModule="Index"
%>
<!--#include file="LoginLog.asp"-->
<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%>


<%
'***********************
'Code for IdeaCMS
'***********************

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
if instr(request.ServerVariables("HTTP_USER_AGENT"),"MicroMessenger")<=0 then 'alert "请在微信浏览器中打开！","",""
response.Redirect("http://www.zjqtgroup.com/oaindex.asp")
end if
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



Call GetOpenID(MyUrl())
dim module,id,stype
module=getForm("m","get")
id=getForm("id","get")
stype=getForm("t","get")
setCookie "shop","0"



dim templatePath,infoStr,i,rsObj,sql,total,num,rsObj1
dim order_str,p_arr,shop_arr,pic_url
if module="shoplist" then
    templatePath = PubTemp&"shoplist.html"
	with templateObj : .load(templatePath) : .parseList "",1,2,stype,"" : .parseComm() : infoStr = .content end with
elseif module="plist" then
    templatePath = PubTemp&"productlist.html"
	with templateObj : .load(templatePath) : infoStr = .content end with
	infoStr=re(infoStr,"[shop:type]",stype)
	with templateObj : .content = infoStr : .parseList "",1,1,stype,"" : .parseComm() : infoStr = .content end with
elseif module="newslist" then
    templatePath = PubTemp&"newslist.html"
	with templateObj : .load(templatePath) : .parseList "",1,3,stype,"" : .parseComm() : infoStr = .content end with
else
    templatePath = PubTemp&"index.html"
	with templateObj : .load(templatePath) : .parseComm() : infoStr = .content : end with
end if
Echo infoStr
terminateAllObjects
%>