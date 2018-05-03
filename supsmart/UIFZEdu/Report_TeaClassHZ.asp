<!--#include virtual="supsmart/VipOrder.asp"-->

<%if MO_Report>=3 then%>
	<head>
	 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<title>汇总报表-教师课时</title>
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
	SQLFLlist= "SELECT TOP (100) PERCENT dbo.employee.职务, dbo.employee.教师科目, dbo.employee.name, dbo.Class.教师确认标示, SUM(dbo.Class.课时) AS 上课课时, YEAR(dbo.Class.日期) * 100 + MONTH(dbo.Class.日期) AS 年月  FROM dbo.Class LEFT OUTER JOIN  dbo.employee ON dbo.Class.老师ID = dbo.employee.EmpID  WHERE  (dbo.Class.作废标示 IS NULL)  AND (dbo.Class.日期 < { fn NOW() })  GROUP BY dbo.employee.教师科目, dbo.employee.name, dbo.Class.教师确认标示, YEAR(dbo.Class.日期) * 100 + MONTH(dbo.Class.日期), dbo.employee.职务  HAVING  (dbo.Class.教师确认标示 < 4) AND (YEAR(dbo.Class.日期) * 100 + MONTH(dbo.Class.日期) = 201804)  ORDER BY dbo.employee.职务 DESC, dbo.employee.教师科目, dbo.employee.name, dbo.Class.教师确认标示"
	Set Conn=Server.CreateObject("SsFadodb.SsFConn")
	set rs=Conn.Rs("S","SsF",SQLFLlist,1)
	dim TeaNameB,TeaC(),i,ii
	TeaNameB=""
	ReDim Preserve TeaC(100,8)
	i=0
	for ii=1 to 4
		TeaC(0,3+ii)=0
	next
	%>         
	 
	   <p class="lg"> 汇总报表-教师课时（201804）</p>
	   
	 
		<table width="100%" border="3" align="center" cellpadding="0" cellspacing="1" bordercolor="#000066" bgcolor="#FFFFFF" class="lg">
            <tr>
            	<th>岗位</th>
            	<th>学科</th>
				<th>教师姓名</th>
				<th width="40px">未确认课时</th>		
				<th width="40px">确认课时</th>	
				<th width="40px">异议课时</th>	
				<th width="40px">课时小计</th>	
             </tr>
	        
	<%
	do While not rs.eof
		if TeaNameB<>rs(2) then
			i=i+1   
			TeaC(i,1)=rs(0)
			TeaC(i,2)=rs(1)
			TeaC(i,3)=rs(2)
			for ii=1 to 4
				TeaC(i,3+ii)=0
			next
			
		end if
			TeaNameB=rs(2)
			Select case cint(rs(3))
             case 0
             	TeaC(i,4)=cint(rs(4))
             case 1
             	TeaC(i,5)=cint(rs(4))
             case 3
             	TeaC(i,6)=cint(rs(4))
             end Select
	        TeaC(i,7)=TeaC(i,4)+TeaC(i,5)+TeaC(i,6)    
	  	rs.MoveNext
	Loop
	rs.close:set rs=nothing
	set conn=nothing
	
	for ii=1 to i
	%>
		<tr>
            <td>&nbsp;<%=TeaC(ii,1)%></td>
            <td>&nbsp;<%=TeaC(ii,2)%></td>
            <td>&nbsp;<%=TeaC(ii,3)%></td>
            <td align="right"><%=TeaC(ii,4)%></td>	
          	<td align="right"><%=TeaC(ii,5)%></td>	
       		<td align="right"><%=TeaC(ii,6)%></td>	
         	<td align="right"><%=TeaC(ii,7)%></td>	
          </tr>
	 <%
	 	TeaC(0,4)=TeaC(0,4)+TeaC(ii,4)
	 	TeaC(0,5)=TeaC(0,5)+TeaC(ii,5)
	 	TeaC(0,6)=TeaC(0,6)+TeaC(ii,6)
	 	TeaC(0,7)=TeaC(0,7)+TeaC(ii,7)
	 	next%>    
	 	 <td colspan="3">合计</td>
        
        <td align="right"><%=TeaC(0,4)%></td>	
      	<td align="right"><%=TeaC(0,5)%></td>	
   		<td align="right"><%=TeaC(0,6)%></td>	
     	<td align="right"><%=TeaC(0,7)%></td>	
	 	
	 	
	 </table>
	   
	<hr>

<%Else%>
	<h1>不好意思，这里保密！</h1>
<%END IF%>