<!--#include virtual="supsmart/VipOrder.asp"-->

<%if MO_Report>=4 then%>
	<head>
	 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<title>汇总报表-学生课时</title>
	<style type="text/css">
	
	.lg {
		font-size: 36px;
		text-align: center;
		font-family: "微软雅黑";
	}
	
	</style>
	
	</head>
	
	<%
	Dim SQLFLlist,rs
	SQLFLlist= "SELECT   TOP (100) PERCENT dbo.Student.Name, dbo.ClassMatch.StuID, dbo.Student.年级, SUM(dbo.Class.课时) AS 小计  FROM   dbo.Student RIGHT OUTER JOIN  dbo.ClassMatch ON dbo.Student.StuID = dbo.ClassMatch.StuID LEFT OUTER JOIN dbo.Class ON dbo.ClassMatch.ClaID = dbo.Class.ClaID  WHERE (dbo.Class.作废标示 IS NULL)  AND (NOT (dbo.Student.Name = N'[小班课]')) GROUP BY dbo.Student.Name, dbo.ClassMatch.StuID,Student.年级  ORDER BY 小计 DESC"
	Set Conn=Server.CreateObject("SsFadodb.SsFConn")
	set rs=Conn.Rs("S","SsF",SQLFLlist,1)
	%>         
	 
	   <p class="lg"> 汇总报表-学生剩余课时（有出入请立即指正）</p>
	   
	 <h3 align="center"> 老师未确认的课时也计入！<b style="color:red">负数为超课时！！</b></h3>
		<table width="70%" border="3" align="center" cellpadding="0" cellspacing="1" bordercolor="#000066" bgcolor="#FFFFFF" class="lg">
	                <tr>
	                	<th>学生姓名</th>
	                	<th>学生ID</th>
						<th>年级</th>
						<th>剩余课时</th>					
	                 </tr>
	        
	<%
	do While not rs.eof
	%>
	                  <tr>
	                    <td>&nbsp;<%=rs(0)%></td>
	                    <td>&nbsp;<%=rs(1)%></td>
	                    <td>&nbsp;<%=rs(2)%></td>
	                    
	                    <td align="right"><%if len(rs(3))>0 then%><%=-cint(rs(3))%><%end if%></td>					
	                   
	                  </tr>
	                 
	                  
	<%
		rs.MoveNext
	Loop
	
	
	rs.close:set rs=nothing
	set conn=nothing
	%>
	
	 </table>
	   
	<hr>













	<%
	
	SQLFLlist= "SELECT     TOP (100) PERCENT dbo.Student.年级, dbo.Student.Name, SUM(dbo.Class.课时) AS 上课课时  FROM  dbo.Student LEFT OUTER JOIN   dbo.Data ON dbo.Student.年级 = dbo.Data.数据 RIGHT OUTER JOIN    dbo.ClassMatch ON dbo.Student.StuID = dbo.ClassMatch.StuID RIGHT OUTER JOIN   dbo.Class ON dbo.ClassMatch.ClaID = dbo.Class.ClaID  WHERE  (dbo.Class.作废标示 IS NULL) AND (dbo.Class.教师确认标示 = 1) AND (YEAR(dbo.Class.日期) * 100 + MONTH(dbo.Class.日期) = 201804)  GROUP BY dbo.Student.Name, dbo.Student.年级, dbo.Data.数据编号  ORDER BY dbo.Data.数据编号, dbo.Student.Name"
	Set Conn=Server.CreateObject("SsFadodb.SsFConn")
	set rs=Conn.Rs("S","SsF",SQLFLlist,1)
	%>         
	 
	   <p class="lg"> 汇总报表-学生课时（201804）</p>
	   
	 <h3 align="center"> 老师确认过的课时数，未确认的未计入！</h3>
		<table width="50%" border="3" align="center" cellpadding="0" cellspacing="1" bordercolor="#000066" bgcolor="#FFFFFF" class="lg">
	                <tr>
	                	<th>年级</th>
						<th>学生姓名</th>
						<th>课时</th>					
	                 </tr>
	        
	<%
	do While not rs.eof
	%>
	                  <tr>
	                    <td>&nbsp;<%=rs(0)%></td>
	                    <td>&nbsp;<%=rs(1)%></td>
	                    <td align="right"><%=rs(2)%></td>					
	                   
	                  </tr>
	                 
	                  
	<%
		rs.MoveNext
	Loop
	
	
	rs.close:set rs=nothing
	set conn=nothing
	%>
	
	 </table>
	   
	<hr>




<%Else%>
	<h1>不好意思，这里保密！</h1>
<%END IF%>