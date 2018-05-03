<!--#include file="inc/Main.asp"-->
<!--#include file="inc/MD5.asp"-->
	


<%
	
dim RSQL,RConn,Rrs,MUsename,MOpenid
'RSQL="SELECT EmpID, name, WXopenID  FROM dbo.employee  WHERE  (remark ='员工')"   '员工'  学员家长
'RSQL="SELECT NickName, UserName, openID  FROM dbo.Idea_User  WHERE  (remark ='员工') and VIPOrder>=20"   '
RSQL="SELECT NickName, UserName, openID  FROM dbo.Idea_User  WHERE  (remark ='员工') and (POST ='兼职老师')"   '员工'  学员家长
Set RConn=Server.CreateObject("SsFadodb.SsFConn")
'set Rrs=RConn.Rs("S","SsF",RSQL,1)
set Rrs=RConn.Rs("wS","SsF",RSQL,1)
do While not Rrs.eof	
	MUsename=Rrs(1)
	MOpenid=Rrs(2)
	
	OSPostMsg 1,MOpenid,"好，为了让各位了解所上课时，现提供公众号查询排课和问题反馈功能，操作如下：员工入口-》员工首页-》排课查询；在对应课 右滑，点击 确认或提疑，根据实际情况填写；如列表里没有，可以填写《未排课课时问题反馈》，请尽快确认4月课程，便于财务核对工资。今后请每日课后及时确认，谢谢支持！有疑问联系白雪梅老师。"
	Rrs.MoveNext
Loop
Rrs.close:set Rrs=nothing
set RConn=nothing
		
		
%>