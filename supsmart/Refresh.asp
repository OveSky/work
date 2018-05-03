<!--#include file="../inc/Main.asp"-->
<!--#include file="../inc/MD5.asp"-->
<head>
<meta http-equiv="refresh" content="30">
<title><%=now()%></title>
</HEAD>
<a style="font-size:80px;"><%=now()%></a><br>
<a style="font-size:20px;">上月同日：<%=DateAdd("m",-1,now())%></a><br>
<%dim SetTime
'SetTime="2015-1-5"
'SetTime=#2015-1-5#
SetTime=now()
%>

<a style="font-size:20px;">上月初：<%=DateAdd("m",-1,SetTime)-day(SetTime)+1%></a><br>
<a style="font-size:20px;">上月底：<%=DateAdd("m",0,SetTime)-day(SetTime)%></a><br>
<a style="font-size:20px;">本月初：<%=DateAdd("m",0,SetTime)-day(SetTime)+1%></a><br>
<a style="font-size:20px;">本月底：<%=DateAdd("m",1,SetTime)-day(SetTime)%></a><br>
<%=year(DateAdd("m",0,now()))*100+month(DateAdd("m",0,now()))%><br>
<%
FDate0=#2016-1-1#
EDate0=#2016-6-1#


%>
<%=datediff("m",FDate0,EDate0)%><br>
<%=DateAdd("m",1,FDate0)%><br>


<%




'同步更新数据区




'售后完成 已关账部分信息标示 完成
if len(Request.cookies("GRS_OK"))<=0 and minute(now())<5 and hour(now())=20 then
	Response.Cookies("GRS_OK")=1
	Response.Cookies("GRS_OK").Expires= (now()+1/24)
	
	response.write("<script language=javascript>")
	response.write("window.open('GRS_OK.asp');")
	response.write("</script>")	
end if




'产品百日销售
if len(Request.cookies("Item100NUM"))<=0 and minute(now())<5 and hour(now())=4 then
	Response.Cookies("Item100NUM")=1
	Response.Cookies("Item100NUM").Expires= (now()+1/24)
	
	response.write("<script language=javascript>")
	response.write("window.open('Item100NUM.asp');")
	response.write("</script>")	
end if

'产品异常明细导入（呆滞 不足）
if len(Request.cookies("ItemBak_Exception"))<=0 and minute(now())<5 and hour(now())=6 and (day(now())=1 or day(now())=15 or day(now())=day(DateAdd("m",1,SetTime)-day(SetTime))) then
	Response.Cookies("ItemBak_Exception")=1
	Response.Cookies("ItemBak_Exception").Expires= (now()+1/24)
	
	response.write("<script language=javascript>")
	response.write("window.open('ItemBak_Exception.asp');")
	response.write("</script>")	
end if


'客户百日销售
if len(Request.cookies("Cust100NUM"))<=0 and minute(now())<5 and hour(now())=2 then
	Response.Cookies("Cust100NUM")=1
	Response.Cookies("Cust100NUM").Expires= (now()+1/24)
	
	response.write("<script language=javascript>")
	response.write("window.open('Cust100NUM.asp');")
	response.write("</script>")	
end if	
	
	
	
	

'客户月底  初步核算应收账，关账后这些记录删除，重新计算
if len(Request.cookies("YSZ"))<=0 and minute(now())<5 and hour(now())=5 and day(now())=1 then
	Response.Cookies("YSZ")=1
	Response.Cookies("YSZ").Expires= (now()+1/24)
	
	response.write("<script language=javascript>")
	response.write("window.open('YSZ.asp');")
	response.write("</script>")	
end if		
	
	
	
	
	'客户业务发生时间更新
if len(Request.cookies("CustTradeDate"))<=0 and minute(now())<5 and hour(now())=1 then
	Response.Cookies("CustTradeDate")=1
	Response.Cookies("CustTradeDate").Expires= (now()+1/24)	
	response.write("<script language=javascript>")
	response.write("window.open('http://www.zjqtgroup.com/mis/qt/refresh/CustTradeDate.asp');")
	response.write("</script>")	

	Set Conn=Server.CreateObject("SsFadodb.SsFConn")
		SQL="update a1 set a1.fcurprepamount = a2.fysamt, a1.fcurreceamount = a2.fwhxamt, a1.fcurcomegobalance = a2.fhlamt from t_Organization a1 join (select kk.fcustid, sum(kk.fysamt) as fysamt, sum(kk.fwhxamt) as fwhxamt, sum(kk.fwhxamt - kk.fysamt) as fhlamt from (select aa.fcustid, 0 as fysamt, sum(aa.fwhxamount) as fwhxamt from (select a.fcustid, (case when fsourbilltypeid = 3001 then a.funcheckamount else -1 * a.funcheckamount end ) as fwhxamount from vw_arap_RBillList a) aa group by aa.fcustid Union all select a.fcustid, sum(a.funcheckamount) as fysamt, 0 as fwhxamt from t_rp_rbill a where a.fbilltypeid = 5002  group by a.fcustid ) kk group by kk.fcustid  ) a2 on a1.fitemid = a2.fcustid"
		set rsVT=Conn.Rs("K","SsF",SQL,0)
	set conn=nothing

end if


'产品信息更新
if len(Request.cookies("ItemCategory"))<=0 and minute(now())<5 and hour(now())=3 then
	Response.Cookies("ItemCategory")=1
	Response.Cookies("ItemCategory").Expires= (now()+1/24)	
	response.write("<script language=javascript>")
	response.write("window.open('http://www.zjqtgroup.com/mis/qt/refresh/ItemCategory.asp');")
	response.write("</script>")	
end if


'技术施工单 OPENID自动录入  4:30
if len(Request.cookies("JSSG_OpenID"))<=0 and minute(now())>30 and hour(now())=4 then
	Response.Cookies("JSSG_OpenID")=1
	Response.Cookies("JSSG_OpenID").Expires= (now()+1/24)
	response.write("<script language=javascript>")
	response.write("window.open('JSSG_OpenID.asp');")
	response.write("</script>")	
end if

'技术施工单 自动审批
if len(Request.cookies("JSSG_Audit"))<=0 and minute(now())<5 and hour(now())=5 then
	Response.Cookies("JSSG_Audit")=1
	Response.Cookies("JSSG_Audit").Expires= (now()+1/24)
	response.write("<script language=javascript>")
	response.write("window.open('JSSG_Audit.asp');")
	response.write("</script>")	
end if




'【触发更新】每笔销售单成本计算（11:50 17:50）
if len(Request.cookies("CostDaily"))<=0 and minute(now())>50 and (hour(now())=17 or hour(now())=11) then
	Response.Cookies("CostDaily")=1
	Response.Cookies("CostDaily").Expires= (now()+1/24)
	response.write("<script language=javascript>")
	response.write("window.open('CostDaily.asp');")
	response.write("</script>")	
end if


'【触发更新】每笔销售单返利计算（12:10 18:10）
if len(Request.cookies("RebateDaily"))<=0 and minute(now())>10 and (hour(now())=18 or hour(now())=12) then
	Response.Cookies("RebateDaily")=1
	Response.Cookies("RebateDaily").Expires= (now()+1/24)
	response.write("<script language=javascript>")
	response.write("window.open('RebateDaily.asp');")
	response.write("</script>")	
end if








'发送日报
if len(Request.cookies("AutoReportSend"))<=0 and minute(now())>30 and hour(now())=18 then
	Response.Cookies("AutoReportSend")=1
	Response.Cookies("AutoReportSend").Expires= (now()+1/24)	
	response.write("<script language=javascript>")
	response.write("window.open('http://www.zjqtgroup.com/mis/qt/refresh/AutoReportSend.asp');")
	response.write("</script>")	
end if


Set Conn=Server.CreateObject("SsFadodb.SsFConn")
SQL="SELECT     TOP (100) PERCENT 参数名称1, UpdateTime,刷新频率DAY FROM dbo.sysVariable WHERE (刷新频率DAY < 360) ORDER BY UpdateTime"
	set rs=Conn.Rs("O","SsF",SQL,1)
	%>
	<table width="800" border="3" align="center" cellpadding="0" cellspacing="1" bordercolor="#000066" bgcolor="#FFFFFF">
		<%do While not rs.eof%>
			<TR>
				<TD><%=rs("参数名称1")%></td>
				<TD><%=rs("刷新频率DAY")%></td>
				
				<TD><%=rs("UpdateTime")%></td>
				<TD><%=round(now()-rs("UpdateTime"),0)%></td>
			</tr>
			
		<%	rs.MoveNext
		Loop
	rs.close()
	set rs=nothing%>
	</TABLE>
	<%
set conn=nothing








'关注产品库存变动提醒

if len(Request.cookies("ItemFollow"))<=0 then
	Response.Cookies("ItemFollow")=1
	Response.Cookies("ItemFollow").Expires= (now()+1/24/2) '半小时1次
	
	response.write("<script language=javascript>")
	response.write("window.open('ItemFollow.asp');")
	response.write("</script>")	
end if














%>











<%
dim rs,rs1,rs2
Set Conn=Server.CreateObject("SsFadodb.SsFConn")
On Error Resume Next
SQL="SELECT id,微信ID, 提醒时间, 跟进人群, 执行开始时间, 执行结束时间, 事件概述 FROM  GTD WHERE (完成标示 = 0) AND (是否提醒 = N'1') AND (提醒时间 <= { fn NOW() })  AND (已提醒时间 IS NULL) ORDER BY 提醒时间"
		set rs=Conn.Rs("O","SsF",SQL,1)
			
		On Error Resume Next
		if Err then
			err_id=Err.number : err_des=Err.description : Err.Clear : Conn.close : set Conn=nothing : isConnect = false
			if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_dateconnect
			 
		else
				do While not rs.eof
				'发送发起人
				PostMsg "",replace(rs("微信ID")," ",""),"【提醒】["&rs("执行开始时间")&"至"&rs("执行结束时间")&"]"&rs("事件概述")
				'发生主要执行人
				if len(rs("跟进人群"))>1 then
					Dim gjArray
						gjArray=split(rs("跟进人群"),",")
						for gj_i=0 to UBound(gjArray)
							No_i=0
							SQLgj="SELECT     OpenID, Employee FROM  dbo.Idea_User WHERE  (VIPOrder <= 10) and (Employee LIKE N'%"&(gjArray(gj_i))&"%')"
							set rsgj=Conn.Rs("W","SsF",SQLgj,1)
							On Error Resume Next
							if Err then
							else
									do While not rsgj.eof
									No_i=1
									if gj_i=0 then
									PostMsg "",replace(rsgj("OpenID")," ",""),"【主要执行人提醒】["&rs("执行开始时间")&"至"&rs("执行结束时间")&"]"&rs("事件概述")
									else
									PostMsg "",replace(rsgj("OpenID")," ",""),"【协助跟进人提醒】["&rs("执行开始时间")&"至"&rs("执行结束时间")&"]"&rs("事件概述")
									end if
									 rsgj.MoveNext
									Loop
								rsgj.close:set rsgj=nothing
									
									if No_i=0 then
									PostMsg "","oRXqBwzerWte0x9Gta32595G0tJ0","【提醒】"&gjArray(gj_i)&" 未关注！"
									end if
							end if	
						next
				end if
				
				
				
					On Error Resume Next
					if Err then
					err_id=Err.number : err_des=Err.description : Err.Clear : Conn.close : set Conn=nothing : isConnect = false
					if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_dateconnect
			 		else
						set rs1=Conn.Rs("O","SsF","Update GTD SET 已提醒时间='"&(now())&"' WHERE  (id= '"&rs("id")&"')",0)
						On Error Resume Next
					end if

				rs.MoveNext
				Loop
				rs.close:set rs=nothing

			
			set rs2=Conn.Rs("O","SsF","Update sysVariable SET UpdateTime='"&(now())&"' WHERE  (ID = 'v010')",0)
			
			set Conn=nothing

		end if


		
%>





