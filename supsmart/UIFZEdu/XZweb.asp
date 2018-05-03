<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>选择</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<link rel="stylesheet" href="../css/mui.min.css">
		<style>
			html,
			body {
				background-color: #efeff4;
			}
			
			.title {
				padding: 20px 15px 10px;
				color: #6d6d72;
				font-size: 15px;
				background-color: #fff;
			}
		</style>
		
	</head>


<%
session.codepage=65001
response.charset="utf-8"
server.scripttimeout=999999	
	
		if len(request("find1"))>0 then
			session("find1")=request("find1")
			if request("find1")=" " then
				 session("find1")=""
			end if
		else
			session("find1")=""
		end if

		if len(Request.querystring("Aid"))>0 then
			session("Aid")=Request.querystring("Aid")
			session("AXZ")=Request.querystring("AXZ")
			session("AF")=Request.querystring("AF")
		
		end if
		
		if len(session("AXZ"))<=0 Then
		Else
			Select case session("AXZ")
				case "Tea"
					AXZSQL="SELECT TOP (100) PERCENT EmpID, name, 教师科目, 职务, 备注   FROM dbo.employee WHERE (教师科目 <> N'无') AND (Name LIKE N'%"&session("find1")&"%') ORDER BY EmpID"
				case "Stu"
					AXZSQL="SELECT TOP (100) PERCENT dbo.Student.StuID, dbo.Student.Name, dbo.Student.年级, dbo.Student.课时性质, dbo.Student.剩余课时, dbo.Data.数据编号 FROM dbo.Student LEFT OUTER JOIN  dbo.Data ON dbo.Student.年级 = dbo.Data.数据  WHERE (dbo.Student.Name LIKE N'%"&session("find1")&"%') ORDER BY dbo.Data.数据编号 DESC, dbo.Student.课时性质"
				case "Cla"
					AXZSQL=""
			
			end Select
		end if 
		
		if len(session("AF"))<=0 Then
		Else
			ATo=session("AF")&".asp"
		end if 
		
	






		Set Conn=Server.CreateObject("SsFadodb.SsFConn")

%>
	

	<body>
		<div>
			<div class="mui-scroll">
				<div class="title">
					<form action="XZweb.asp?AXZ=<%=session("AXZ")%>&Aid=<%=session("Aid")%>&AF=<%=session("AF")%>"  name="form1" method="post"  target="_self" >
				<input type="text" name="find1" value="<%=session("find1")%>"  placeholder="名称">
				<input type="submit" value="搜索" >
				</form>
				</div>
				<ul class="mui-table-view mui-table-view-chevron">
					<li class="mui-table-view-cell">
							<a href="<%=ATo%>?AXZ=<%=session("AXZ")%>&Aid=<%=session("Aid")%>&id=0" class="mui-navigate-right">取消选择</a>
					</li>
					<hr>	
						<%			
							
						set rs=Conn.Rs("S","SsF",AXZSQL,1)
						do While not rs.eof					
						%>						
						<li class="mui-table-view-cell">
							<a href="<%=ATo%>?AXZ=<%=session("AXZ")%>&Aid=<%=session("Aid")%>&id=<%=rs(0)%>" class="mui-navigate-right"><%=rs(1)%>-<%=rs(2)%>&nbsp;&nbsp;&nbsp;<%=rs(3)%>&nbsp;&nbsp;&nbsp;<%=rs(4)%></a>
						</li>
						<%	
								rs.MoveNext
						Loop
						rs.close:set rs=nothing
						%>	
			</ul>
			</div>
		</div>
    
    
    
    
    
    
 			<script src="../js/mui.min.js"></script>
	
			<%set conn=nothing%>

 	</body>
 	</html>
