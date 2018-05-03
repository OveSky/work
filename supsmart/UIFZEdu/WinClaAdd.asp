<script type="text/javascript">
		function CheckOpen(obj){
		var idx=obj.id;
		document.getElementById("XX").value=idx;
//		document.getElementById("WT1").value=idx;
		var Wtemp=idx.split("_");
//		Wtemp[3].value=Wtemp[3]+":00";
		for (var i=0;i<3;i++)
			{
			document.getElementById("WT"+i).value=Wtemp[i];
			}
//		document.getElementById("WT0").value=Wtemp[0];
//		document.getElementById("WT1").value=Wtemp[1];
//		document.getElementById("WT2").value=Wtemp[2];
		document.getElementById("WT3").value=Wtemp[3]+":00";
		document.getElementById("WT4").value=(parseInt(Wtemp[3],10)+2)+":00";
		document.getElementById("WT5").value=Wtemp[4]	
		document.getElementById("AddWindow").style.display='block';
	}
	
	function CheckClose(obj){
		document.getElementById("AddWindow").style.display='none';
	}
	
	//课程作废菜单展开关闭
	function CheckDelete(obj){	
		var idx=obj.id;
		if(document.getElementById("Del"+idx).style.display=='none')
		{
		document.getElementById("Del"+idx).style.display='block';
		document.getElementById("DelC"+idx).style.display='none';
		}
		else
		{
		document.getElementById("Del"+idx).style.display='none';
		document.getElementById("DelC"+idx).style.display='block';
		}
	}
	//作废单子 提示框
	function DelClass(obj){
		var idx=obj.id;
		
		var Wtemp=idx.split(",");
		var con;
		con=confirm("你确定要作废此单?"); //在页面上弹出对话框
		if(con==true){
			window.location.href="<%=RedirectTo%>?R=4&id="+Wtemp[0]+"&Tid="+Wtemp[1];
		}
		else
		{
		document.getElementById("Del"+Wtemp[0]).style.display='none';
		document.getElementById("DelC"+Wtemp[0]).style.display='block';
		}
	}
	//加小时
	function HourChange(obj){
		var vobj=document.getElementById("WT3").value;
		var tempobj=vobj.split(":");
		var hobj=parseInt(tempobj[0],10);
		var mobj=parseInt(tempobj[1],10);
					
		var HourA=obj.value;
		switch(HourA){
			case "1h":
				document.getElementById("WT4").value=(hobj+1)+":"+mobj;
				break;
			case "1.5h":
				if(mobj+30>=60){
					document.getElementById("WT4").value=(hobj+2)+":"+(mobj-30);
					break;	
				}
				else{
					document.getElementById("WT4").value=(hobj+1)+":"+(mobj+30);
					break;	
				}
			case "2h":
				document.getElementById("WT4").value=(hobj+2)+":"+mobj;
				break;
			case "-0.5h":
				document.getElementById("WT3").value=(hobj-1)+":"+"30";
				break;
			case "+0.5h":
				document.getElementById("WT3").value=(hobj)+":"+"30";
				break;
			}
	}	
		
</script>		

			
<%

'作废排课——————————写入数据库'$$$$$$$$$$$$$$$$$$$$$$$$$$$$
if Request.querystring("R")=4 then
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





'窗口添加排课'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Si=0
ActTagidR=""
	if len(request.form("ActTagid"))>0 then
		ActTagid=split(request.form("ActTagid"),",")
		for i=0 to ubound(ActTagid)
			if cint(ActTagid(i))<>-1 then
				if i=0 then
					ActTagidR=ActTagid(i)
				else	
					ActTagidR=ActTagidR&","&ActTagid(i)
				end if
			end if
		next
		ActTagid=split(ActTagidR,",")
		Si=ubound(ActTagid)+1		
	end if

if Request.querystring("R")=1 and Si>0 then  '' 
	
	
	SqlR(0,0)=1
	SqlR(0,2)="Class"
	SqlR(2,0)=11
	sqlR(3,0)=1
	
	SqlR(1,1)="老师ID"
	SqlR(1,2)="年级"
	SqlR(1,3)="科目"
	SqlR(1,4)="日期"
	SqlR(1,5)="上课时间"
	SqlR(1,6)="下课时间"
	SqlR(1,7)="课时"
	SqlR(1,8)="上课人数"
	SqlR(1,9)="登记时间"
	SqlR(1,10)="锁单标示"
	SqlR(1,11)="教师确认标示"
	
	SqlR(2,1)=request.form("WT0")	'老师ID'
	session("WT0")=request.form("WT0")
	SqlR(2,2)=""	'年级'
	SqlR(2,3)=request.form("WT5")	'科目'
	SqlR(2,4)=request.form("WT2")	'日期'
	SqlR(2,5)=cdate(request.form("WT2"))+cdate(request.form("WT3"))	'上课时间'
	SqlR(2,6)=cdate(request.form("WT2"))+cdate(request.form("WT4"))	'下课时间'
	SqlR(2,7)=round((cdate(request.form("WT4"))-cdate(request.form("WT3")))*24,2) 	'课时'
	SqlR(2,8)=Si
	SqlR(2,9)=now()
	SqlR(2,10)=0
	SqlR(2,11)=0
	%>
	<!--#include file="myFun_SqlRefresh.asp"-->
	
	
	<%
	'查询获得ClaID'
	SqlR(0,0)=3
	SqlR(2,0)=1		'列数'
	SqlR(3,0)=1		'行数'
	
	SqlR(1,0)=101 	'通用SQL；
	sqlR(0,2)="Class"
	sqlR(1,1)="ClaID"
	%>
	<!--#include file="myFun_SqlRefresh.asp"-->
	<%
	'获取查询数据'
	NClaID=sqlR(2,1)
	%>
	
	
	
	<%
	'写入学生排课信息'
	SqlR(0,0)=1
	SqlR(0,2)="ClassMatch"
	SqlR(2,0)=5		'列数'
	SqlR(3,0)=Si	'行数'
	
	SqlR(1,1)="ClaID"
	SqlR(1,2)="StuID"
	SqlR(1,3)="科目"	
	SqlR(1,4)="课程类型"	
	SqlR(1,5)="序"
	
	for i=1 to Si
		SqlR(i+1,1)=cint(NClaID)
		SqlR(i+1,2)=cint(ActTagid(i-1))
		SqlR(i+1,3)=""
		SqlR(i+1,4)="正课"
		SqlR(i+1,5)=i
		
	next
	%>
	<!--#include file="myFun_SqlRefresh.asp"-->
		
	<%
	'//	'Session.Abandon()
	Response.Redirect(RedirectTo&"#T"&session("WT0"))

end if
'窗口添加排课'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA



%>

<div id="AddWindow" class="fixed" style="width:800px;height:auto;left:180;background-color:black;display:none;">
	<form action="<%=RedirectTo%>?R=1"  name="form1" method="post"  target="_self" >
			
			
		
		<ul>	
			<li style="display: inline;">
				<input	class="Find" type="text" name="WT1" id="WT1"  value="胡蜓"  readonly="true"  unselectable="on">
				<input	type="hidden" name="WT0" id="WT0"  value="">   
			</li>
			<li style="display: inline;"><select class="Find" style="background-color: yellow;" name="WT5" id="WT5">
					<option value="未知" selected>选择科目</option>
					<option value="语文" >语文</option>
					<option value="数学" >数学</option>
					<option value="英语" >英语</option>
					<option value="科学" >科学</option>
					<option value="奥数" >奥数</option>
					<option value="物理" >物理</option>
					<option value="化学" >化学</option>
				</select></li>
			&nbsp;&nbsp;	
			<li style="display: inline;"><input	type="text" name="WT2" id="WT2" class="Find" onclick=SelectDate(this); value="<%=Bday%>"  readonly="true"></li>
			&nbsp;
			<li style="display: inline;"><input	class="Find" type="text" name="WT3" id="WT3" value="17:00">  </li>
			<li style="display: inline;"><input  class="bo bo3" type="button" value="-0.5h" onclick=HourChange(this);> </li>
			<li style="display: inline;"><input  class="bo bo2" type="button" value="+0.5h" onclick=HourChange(this);> </li>
			<li style="display: inline;"><input	class="Find"  style="background-color: yellow;"  type="text"  name="WT4" id="WT4"   value="18:00">  </li>
			<li style="display: inline;"><input  class="bo bo1" type="button" value="1h" onclick=HourChange(this); > </li>
			<li style="display: inline;"><input  class="bo bo3" type="button" value="1.5h" onclick=HourChange(this);> </li>
			<li style="display: inline;"><input  class="bo bo2" type="button" value="2h" onclick=HourChange(this);> </li>
		
		</ul>
		<ul>
			<li><input	type="hidden" name="ActTagid" id="ActTagid"  value="">
				<input	type="hidden" name="ActTag" id="ActTag"  value="" > 
				<div class=" plus-tag tagbtn clearfix" id="myTags"></div>
				<input  class="Button RedButton Button18" type="submit" value="排课"> 
			
			<h3 class="bo7">学员名单：</h3>
			<!--#include file="StuSearch.asp"-->	

		</ul>	
		
	</form>		
	
</div>




