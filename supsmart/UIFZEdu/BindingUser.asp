<!--#include virtual="supsmart/VipOrder.asp"-->



<html><head>
		<meta charset="utf-8">
		<title>丰正教育管理系统-用户绑定</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		<!--标准mui.css-->
		<link rel="stylesheet" href="../css/mui.min.css">
		<link rel="stylesheet" href="../css/MYstyle.css">
		<style>
		
		
		</style>
		<script type="text/javascript">
			//学员信息区块展开/隐藏
			function getValue(value){  
			    if(value==1){
					document.getElementById("StuInfo").style.display='block';
					document.getElementById("inname").placeholder="学生姓名"; 
				}else{
					document.getElementById("StuInfo").style.display='none';
					document.getElementById("inname").placeholder="员工姓名"; 	
				}
			}  
		</script>    


	</head>
	<body>
		<header class="mui-bar mui-bar-nav">
			<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left" href="#"> </a>
						
			<%	
			'判断是否绑定
			if len(USENAME)>1 then%>
				
				<%
				'更新时 保存原来联系方式 和备注'，重新绑定可以变更信息！
				dim Phone, Note,SQL,rs
				Set Conn=Server.CreateObject("SsFadodb.SsFConn")
				SQL="SELECT UserName, Phone, Note  FROM  dbo.Idea_User  WHERE (UserName = N'"&USENAME&"')"
					set rs=Conn.Rs("wS","SsF",SQL,1)
					Phone=rs("Phone")
					Note=rs("Note")	
					if len(rs("Note"))>1 then
						Note=rs("Note")	
					else 
						Note=""
					end if
				rs.close:set rs=nothing
				set conn=nothing
				%>			
				<h1 class="mui-title"><%=USENAME%>您已绑定,<br>您的联系方式：<%=Phone%></h1>
			<%else%>
				<h1 class="mui-title">亲，<%=NickName%>，请绑定</h1>
			<%end if%>
			
			
		</header>	


<%	
'绑定—————更新数据库'$$$$$$$$$$$$$$$$$$$$$$$$$$$$
''//	'myFun_SqlRefresh 接口数据'
dim SqlR(),SqlRdate,RSQL,RSQL1,RConn,Rrs,Ri
ReDim Preserve SqlR(10,8) 
if request.querystring("R")=1 and len(request.form("inname"))>1 AND len(request.form("phone"))>1 then
	SqlRdate="wS"
	SqlR(0,0)=2
	SqlR(0,2)="Idea_User"
	SqlR(0,3)="OpenID"
	sqlR(0,4)=session("openid")
	
	if len(USENAME)<1 then		'新绑定'
		if request.form("xzUserType")=1 then	'学员家长'
			SqlR(2,0)=5
			SqlR(1,1)="remark"
			SqlR(2,1)="学员家长"
			
			SqlR(1,4)="POST"
			SqlR(2,4)=request.form("StuPost")
			SqlR(1,5)="FamilyName"
			SqlR(2,5)=request.form("FamilyName")
		Else									'员工'
			SqlR(2,0)=3
			SqlR(1,1)="remark"
			SqlR(2,1)="员工"
		end if
		SqlR(1,2)="UserName"
		SqlR(2,2)=request.form("inname")
		SqlR(1,3)="Phone"
		SqlR(2,3)=request.form("phone")
	else'更新'
		'SqlR(2,0)=2
		'SqlR(1,1)="Phone"
		'SqlR(2,1)=request.form("phone")
		'SqlR(1,2)="Note"
		'SqlR(2,2)=Note&"原电话:"&Phone
	
	end if
	
	
%>
	<!--#include file="myFun_SqlRefresh.asp"-->
	
<%
	Response.Redirect("BindingUser.asp")
end if%>


		<div class="mui-content">
			<div class="mui-card" align="center">
				<ul class="mui-table-view">
					<%	
					'判断是否绑定，已绑定不能变更姓名
					if len(USENAME)<1 then%>
					<form action="BindingUser.asp?R=1" method="post"  target="_self">
						
							
							<div class="mui-card">
								
								 <label for="DoorCt">请选择用户类型: <%=SqlR(1,1)%>		

								 	<br>
						            <span class="bo bo7"><input type="radio" name="xzUserType" value="1" onclick="getValue(this.value)" checked="checked">家长OR学员 </span>
						            <span class="bo bo8"><input type="radio" name="xzUserType" value="2" onclick="getValue(this.value)">顾问OR老师  </span> 
						        </label>			
								<br><br>
								<div class="mui-input-group">
									
										<div class="mui-input-row">
											<label>姓名</label>
											<input type="text" id="inname"  name="inname" placeholder="学生姓名" value="<%=USENAME%>">
										</div>
										
										<div class="mui-input-row">
										<label>联系方式</label>
										<input type="text"  name="phone" placeholder="手机号">
									</div>	
								</div>	
									
								<div class="mui-input-group" id="StuInfo">	
									<div class="mui-input-row">
										<label>和学员关系</label>
										<input type="text" name="StuPost" placeholder="父亲、母亲" VALUE="">
									</div>	
									<div class="mui-input-row">
										<label>家长姓名</label>
										<input type="text" name="FamilyName" placeholder="家长姓名" VALUE="">
									</div>		
									
								</div>
							</div>
						<br>
						<input type="submit" value="绑定">	
								
					</form>
					<%END IF%>
				</ul>
			</div>
		</div>
		

		
		
		
		
		
		
		<script src="../js/mui.min.js"></script>
		
	
		<script>
			mui.init({
				swipeBack:true //启用右滑关闭功能
			});
		</script>
		
	
	
	
		
	
</body>	


<br><hr>
<h3>关注公众号</h3>
<img src="../images/qrcode_FZ.jpg"  height="200" width="200" >

</html>