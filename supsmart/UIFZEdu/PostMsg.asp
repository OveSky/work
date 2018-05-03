<!--#include virtual="supsmart/inc/Main.asp"-->
<!--#include virtual="supsmart/inc/MD5.asp"-->	


<%
dim RedirectTo,EmpID,MUsename,MOpenid,MsgType,MsgContent
RedirectTo=Request.QueryString("RTo")  '不含.asp'
if len(Request.QueryString("EmpID"))>0 then
	EmpID=Request.QueryString("EmpID")
Else
	EmpID=Request.form("EmpID")
end if
MsgType=Request.QueryString("MsgType")


dim RSQL,RConn,Rrs
RSQL="SELECT EmpID, name, WXopenID  FROM dbo.employee  WHERE  (EmpID ="&EmpID&")"
Set RConn=Server.CreateObject("SsFadodb.SsFConn")
set Rrs=RConn.Rs("S","SsF",RSQL,1)
do While not Rrs.eof	
	MUsename=Rrs(1)
	MOpenid=Rrs(2)
	Rrs.MoveNext
Loop
Rrs.close:set Rrs=nothing
set RConn=nothing

Select case MsgType
	case 0
		MsgContent=Request.form("PMContent")
	case 1
		MsgContent="您提交的排课异议已修正，请重新确认！"
		
		
end Select
if len(Request.cookies("OSPostMsg"))<=0 then
	Response.Cookies("OSPostMsg")="SendComplete"
	Response.Cookies("OSPostMsg").Expires= (now()+5/1440)
	OSPostMsg 0,MOpenid,"亲,"&MsgContent
	
end if	
	
	











response.Redirect(RedirectTo&".asp")
response.End()
response.write("<script language=javascript>")
response.write("window.opener=null;")
response.write("window.open('', '_self', ''); ")
response.write("window.close();")
response.write("</script>")

%>