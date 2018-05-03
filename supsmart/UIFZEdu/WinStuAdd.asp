<script type="text/javascript">
	//增单区块展开/隐藏
	function WStuOpen(obj){
		document.getElementById("WStu").style.display='block';
	}
	
	function WStuClose(obj){
		document.getElementById("WStu").style.display='none';
	}
		
</script>		

			
<%

'作废—————————写入数据库'$$$$$$$$$$$$$$$$$$$$$$$$$$$$
if Request.querystring("R")=4 and Request.querystring("T")="Stu"  then
	SqlR(1,0)=102
	SqlR(0,0)=12
	SqlR(0,2)="Class"
	SqlR(0,3)="ClaID"
	sqlR(0,4)=cint(Request.querystring("id"))
	
	%>
	
		<!--#include file="myFun_SqlRefresh.asp"-->
	<%
		Response.Redirect(RedirectTo&"#T"&Request.querystring("Tid"))
end if





'添加'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

if Request.querystring("R")=1 and Request.querystring("T")="Stu"  then  
	
	SqlR(0,0)=1
	SqlR(0,2)="Student"
	SqlR(2,0)=9
	sqlR(3,0)=1
	
	SqlR(1,1)="Name"
	SqlR(1,2)="年级"
	SqlR(1,3)="课时性质"
	SqlR(1,4)="生日"
	SqlR(1,5)="渠道来源"
	SqlR(1,6)="排课需求"
	SqlR(1,7)="MobilePhone"
	SqlR(1,8)="登记时间"
	SqlR(1,9)="状态"
	for iii=1 to SqlR(2,0)-1
		SqlR(2,iii)=request.form("W"&iii)
	next
	SqlR(2,8)=now()
	SqlR(2,9)="0"
	%>
	<!--#include file="myFun_SqlRefresh.asp"-->
	
	
	
	<%
	'//	'Session.Abandon()
	Response.Redirect(RedirectTo)

end if
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA



%>

<div id="WStu" class="fixed" style="width:600px;height:auto;left:180;background-color:black;display:none;">
	<form action="<%=RedirectTo%>?R=1&T=Stu"  name="form1" method="post"  target="_self" >
			
			
		<ul><h3 class="bo7">必填：</h3></ul>
		<ul>
		  	<li style="display: inline;"><input	class="Find" type="text" name="W1" id="W1"  value="" placeholder="姓名" ></li>
			<li style="display: inline;"><select class="Find" name="W2" id="W2">
					<option value="未知" selected>选择年级</option>
						<%
						Set Conn=Server.CreateObject("SsFadodb.SsFConn")
						SQL="SELECT  TOP (100) PERCENT 数据  FROM   dbo.Data WHERE  (类别编号 = 1) AND (作废标示 IS NULL)  ORDER BY 数据编号"
						set rs=Conn.Rs("S","SsF",SQL,1)
						do While not rs.eof	
							
						%>
					<option value="<%=RS(0)%>" ><%=RS(0)%></option>
					<%      	rs.MoveNext
						Loop
						rs.close:set rs=nothing
						set conn=nothing	
					%>
				</select>
			</li>
			<li style="display: inline;"><select class="Find" name="W3" id="W3">
					<option value="试听" selected>试听</option>
					<option value="一对一" >一对一</option>
					<option value="一对二" >一对二</option>
					<option value="一对三" >一对三</option>
					<option value="小班课" >小班课</option>
					<option value="大班课" >大班课</option>
			</select>
			</li>
			<li style="display: inline;"><input	class="Find" type="text" name="W7" id="W7"  value="" placeholder="手机号" ></li>
		</ul> 		
		<ul><h3 class="bo7">选填：</h3></ul>
		<ul>	
			<li  style="display: inline;"><b class="bo bo7">生日</b><input	type="text" name="W4" id="W4" class="Find" onclick=SelectDate(this); value="2005-1-1"  readonly="true"></li>
			&nbsp;&nbsp;&nbsp;
			<li style="display: inline;"><input	class="Find" type="text" name="W5" id="W5"  value="" placeholder="渠道来源" ></li>
			<li style="display: inline;"><input	class="Find" type="text" name="W6" id="W6"  value="" placeholder="排课需求" ></li>
		</ul>		
		
			<input  class="Button RedButton Button18" type="submit" value="添加">
			<br>
			<input  class="Button RedButton Button18" type="button" onclick="WStuClose(this)" value="关闭"> 
		
	</form>		
	
</div>



