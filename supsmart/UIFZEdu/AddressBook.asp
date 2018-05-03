<!--#include virtual="supsmart/VipOrder.asp"-->

<%if MO_AddBook>=1 then
	dim RedirectTo
	RedirectTo="AddressBook.asp"
	%>
	<head>
	 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<title>通讯录</title>
	<style type="text/css">
	
	.lg {
		font-size: 36px;
		text-align: center;
		font-family: "微软雅黑";
	}
	
	</style>
	
	<script type="text/javascript">
		function PMConfirm(obj){
			var idx=obj.id;
			var Wtemp=idx.split("_");
			document.getElementById("ConfirmWin").style.display='block';
			document.getElementById("EmpID").value=Wtemp[1];
		}
		</script>	
	
	
	</head>
	
	
	
	<div align="center" style="position:fixed; top:80; left:80;display: none;background-color:#DFF0D8;font-size: 20px;" id="ConfirmWin">
		<form action="PostMsg.asp?RTo=AddressBook&MsgType=0"  name="form1" method="post"  target="_self" >
			<label>发送消息</label>
				
			<div >
				<textarea id="PMContent" name="PMContent" rows="5" placeholder="备注有问题内容"></textarea>
				<br>
				<input  class="Button RedButton Button18" type="submit" value="提交"> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input  class="Button RedButton Button16" type="button" onclick="location.href='<%=RedirectTo%>'" value="关闭"> 
				<input  type="hidden" id="EmpID" name="EmpID"> 
			</div>
			
			
		</form>
	</div>

	
	
	
	
	
	
	
	
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
			Response.Redirect("AddressBook.asp")
	end if	
	
		
		
		
	Dim SQLFLlist,rs
	SQLFLlist= "SELECT remark, UserName, Phone, NickName,VIPOrder,ID,UserID  FROM Idea_User  WHERE (remark = N'员工')"
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
						<%if MO_AddBook=9 then%>
							<th>级别</th>	
							<th>变更</th>
							<th>管理员<br>发消息</th>
						<%end if%>
	                 </tr>
	        
	<%
	do While not rs.eof
	%>
	                  <tr>
	                    <td>&nbsp;<%=rs(1)%></td>
	                    <td><a href="tel://<%=rs(2)%>"><%=rs(2)%></a></td>					
	                    <td width="50px">&nbsp;<%=rs(3)%></td>
	                    <%if MO_AddBook=9 then%>
	                    	<form action="AddressBook.asp?id=<%=rs(5)%>"  name="form1" method="post"  target="_self" >
								<td><input style="width: 60px;font-size: 20px;" type="text" name="V<%=rs(5)%>" id="V<%=rs(5)%>"  value="<%=rs(4)%>" ></td>	
								<td><input type="submit" value="变更" ></td>	
								<td><input type="button" onclick="PMConfirm(this);" id="Con_<%=rs(6)%>"  value="发消息"> </td>	
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