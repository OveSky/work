<!--#include virtual="supsmart/VipOrder.asp"-->

<%if MO_AddBook>=8 then%>
	<head>
	 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<title>学员通讯录</title>
	<style type="text/css">
	
	.lg {
		font-size: 36px;
		text-align: center;
		font-family: "微软雅黑";
	}
	
	</style>
	
	</head>
	
	<%
	'变更权限——————————写入数据库'$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	dim SqlR(),SqlRdate,RSQL,RSQL1,RConn,Rrs,Rn,Ri
	ReDim Preserve SqlR(10,8)  '10是大类 一级   8是小类 二级'
	if len(Request.querystring("id"))>0 then
		SqlRdate="wS"
		RSQL="UPDATE Idea_User SET VIPOrder = '"&Request.form("V"&Request.querystring("id"))&"'  WHERE ID= '"& Request.querystring("id")&"'"	
		SqlR(0,0)=12
		%>
		
			<!--#include file="myFun_SqlRefresh.asp"-->
		<%
			Response.Redirect("AddressBookStu.asp")
	end if	
	
		
		
		
	Dim SQLFLlist,rs
	SQLFLlist= "SELECT remark, UserName, Phone, NickName,FamilyName,POST,VIPOrder,ID  FROM Idea_User  WHERE (remark = N'学员家长')"
	Set Conn=Server.CreateObject("SsFadodb.SsFConn")
	set rs=Conn.Rs("wS","SsF",SQLFLlist,1)
	%>         
	 
	   <p class="lg"> 丰正教育通讯录（简化版）</p>
	   
	 <h3 align="center"> 按绑定先后顺序排列，此版本临时使用</h3>
		<table width="98%" border="3" align="center" cellpadding="0" cellspacing="1" bordercolor="#000066" bgcolor="#FFFFFF" class="lg">
	                <tr>
						<th>姓名</th>
						<th>手机</th>		
						<th>微信昵称</th>
						<th>家长姓名</th>
						<th>关系</th>
						<%if MO_AddBook=9 then%>
							<th>级别</th>	
							<th>变更</th>
						<%end if%>
	                 </tr>
	        
	<%
	do While not rs.eof
	%>
	                  <tr>
	                    <td><%=rs(1)%></td>
	                    <td><a href="tel://<%=rs(2)%>"><%=rs(2)%></a></td>					
	                    <td><%=rs(3)%></td>
	                    <td><%=rs(4)%></td>
	                    <td><%=rs(5)%></td>
	                    <%if MO_AddBook=9 then%>
	                    	<form action="AddressBookStu.asp?id=<%=rs(7)%>"  name="form1" method="post"  target="_self" >
								<td><input style="width: 60px;font-size: 20px;" type="text" name="V<%=rs(7)%>" id="V<%=rs(7)%>"  value="<%=rs(6)%>" ></td>	
								<td><input type="submit" value="变更" ></td>	
							</form>
						<%end if%>
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