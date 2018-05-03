<script type="text/javascript">
	//增单区块展开/隐藏
	function WTeaOpen(obj){
		document.getElementById("WTea").style.display='block';
	}
	
	function WTeaClose(obj){
		document.getElementById("WTea").style.display='none';
	}
		
</script>		

			
<%

'作废—————————写入数据库'$$$$$$$$$$$$$$$$$$$$$$$$$$$$
if Request.querystring("R")=4 and Request.querystring("T")="Tea"  then
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

if Request.querystring("R")=1 and Request.querystring("T")="Tea"  then  
	
	SqlR(0,0)=1
	SqlR(0,2)="employee"
	SqlR(2,0)=11
	sqlR(3,0)=1
	
	SqlR(1,1)="Name"
	SqlR(1,2)="职务"
	SqlR(1,3)="教师科目"
	SqlR(1,4)="MobilePhone"
	SqlR(1,5)="生日"
	SqlR(1,6)="毕业院校"
	SqlR(1,7)="专业"
	SqlR(1,8)="学历"
	SqlR(1,9)="户籍"
	SqlR(1,10)="入职日期"
	SqlR(1,11)="登记时间"
	
	for iii=1 to SqlR(2,0)-1
		SqlR(2,iii)=request.form("W"&iii)
	next
	SqlR(2,11)=now()
	
	%>
	<!--#include file="myFun_SqlRefresh.asp"-->
	
	
	
	<%
	'//	'Session.Abandon()
	Response.Redirect(RedirectTo)

end if
'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA



%>

<div id="WTea" class="fixed" style="width:600px;height:auto;left:180;background-color:black;display:none;">
	<form action="<%=RedirectTo%>?R=1&T=Tea"  name="form1" method="post"  target="_self" >
			
			
		<ul><h3 class="bo7">必填：</h3></ul>
		<ul>
		  	<li style="display: inline;"><input	class="Find" type="text" name="W1" id="W1"  value="" placeholder="姓名" ></li>
			<li style="display: inline;"><select class="Find" name="W2" id="W2">
					<option value="全职老师" selected>全职老师</option>
					<option value="兼职老师" >兼职老师</option>
			</select>
			</li>
			<li style="display: inline;"><input	class="Find" style="width: 150px;" type="text" name="W3" id="W3"  value="" placeholder="科目（如：语文）" ></li>
			<li style="display: inline;"><input	class="Find" type="text" name="W4" id="W4"  value="" placeholder="手机号" ></li>
		</ul> 		
		<ul><h3 class="bo7">选填：</h3></ul>
		<ul>	
			<li style="display: inline;" ><b class="bo bo7">生日</b><input	type="text" name="W5" id="W5" class="Find" onclick=SelectDate(this); value="2000-1-1"></li>
			&nbsp;&nbsp;&nbsp;
			<li style="display: inline;"><input	class="Find" type="text" name="W6" id="W6"  value="" placeholder="毕业院校" ></li>
			<li style="display: inline;"><input	class="Find" type="text" name="W7" id="W7"  value="" placeholder="专业" ></li>
			<li style="display: inline;"><input	class="Find" type="text" name="W8" id="W8"  value="" placeholder="学历" ></li>
			<li style="display: inline;"><input	class="Find" type="text" name="W9" id="W9"  value="" placeholder="户籍" ></li>
			<li></li>
			<li><b class="bo bo7">入职日期</b><input	type="text" name="W10" id="W10" class="Find" onclick=SelectDate(this); value="<%=FormatDate(now(),2)%>"></li>
		</ul>		
		
			<input  class="Button RedButton Button18" type="submit" value="添加">
			<br>
			<input  class="Button RedButton Button18" type="button" onclick="WTeaClose(this)" value="关闭"> 
		
	</form>		
	
</div>



