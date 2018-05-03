<!--#include virtual="supsmart/VipOrder.asp"-->
<%
	'清理所有sesson  避免各表之间串数据'
	openid=session("openid")
	Session.Abandon()
	session("openid")=openid




IF MO_EI>0 THEN	'默认0'
%>




	
	
	
	<html>
	
		<head>
			<meta charset="utf-8">
			<title>优典集团丰正校区管理系统</title>
			<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
			<meta name="apple-mobile-web-app-capable" content="yes">
			<meta name="apple-mobile-web-app-status-bar-style" content="black">
	
			<!--标准mui.css-->
			<link rel="stylesheet" href="../css/mui.min.css">
			<link rel="stylesheet" type="text/css" href="../css/icons-extra.css" />
			<!--App自定义的css-->
			<link rel="stylesheet" type="text/css" href="../css/app.css"/>
			<LINK rel=stylesheet href="../libs/PicTurn/PicTurn.css">
		</head>
	
		<body>
	
			<header class="mui-bar mui-bar-nav">
				<h1><%=USENAME%>,您好！</h1>
			      
				  
			</header>
			<div class="mui-content">
			        <ul class="mui-table-view mui-grid-view mui-grid-9">
			            
			            
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="StuClassSearch.asp">
			                    <span class="mui-icon mui-icon-search"></span>
			                    <div class="mui-media-body"><b style="color:blue">学员课程</b></div></a></li>    
			           
			           
			           
			    	    <%IF MO_EI>8 THEN%>
			   	       <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3">
			                    <span class="mui-icon mui-icon-compose"></span>
			                    <div class="mui-media-body"><b style="color:blue">课时统计</b></div></a></li>
			          
			          	<%end if%>
			        </ul> 
			</div>
			
			
			
			
			
	
	
			
		
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		</body>
		
	
	</html>

<%Else%>
	<h1>尚未开放！</h1>
<%END IF%>