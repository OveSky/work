<!--#include virtual="supsmart/VipOrder.asp"-->
<%
	'清理所有sesson  避免各表之间串数据'
	openid=session("openid")
	Session.Abandon()
	session("openid")=openid




IF MO_EI>=2 THEN
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
			      <a href="../MUI/images/institution_3.png">重要通知：</a>
				  
			</header>
			<div class="mui-content">
			        <ul class="mui-table-view mui-grid-view mui-grid-9">
			            
			            
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="ClassAddTea.asp">
			                    <span class="mui-icon mui-icon-location"></span>
			                    <div class="mui-media-body"><b style="color:blue">老师排课</b></div></a></li>    
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="ClassSearch.asp">
			                    <span class="mui-icon mui-icon-search"></span>
			                    <div class="mui-media-body"><b style="color:blue">排课查询</b></div></a></li>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="FeedbackList.asp">
			                    <span class="mui-icon mui-icon-star"></span>
			                    <div class="mui-media-body"><b style="color:blue">反馈登记</b></div></a></li>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="">
			                    <span class="mui-icon mui-icon-search"></span>
			                    <div class="mui-media-body">Wait学员排班</div></a></li>
			           	<li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="Report_StuClassHZ.asp">
			                    <span class="mui-icon mui-icon-search"></span>
			                    <div class="mui-media-body"><b style="color:blue">月度学生课时</b></div></a></li>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="Report_TeaClassHZ.asp">
			                    <span class="mui-icon mui-icon-search"></span>
			                    <div class="mui-media-body"><b style="color:blue">月度教师课时</b></div></a></li>
						<li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="">
			                    <span class="mui-icon mui-icon-paperclip"></span>
			                    <div class="mui-media-body">Wait销课查询</div></a></li>  
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="">
			                    <span class="mui-icon mui-icon-eye"></span>
			                    <div class="mui-media-body">Wait投诉建议</div></a></li>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="AddressBook.asp">
			                    <span class="mui-icon mui-icon-phone"></span>
			                    <div class="mui-media-body"><b style="color:blue">通讯录</b></div></a></li>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="">
			                    <span class="mui-icon mui-icon-paperclip"><span class="mui-badge">？</span></span>
			                    <div class="mui-media-body">Wait报销</div></a></li>  
			             <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="">
			                    <span class="mui-icon mui-icon-star"><span class="mui-badge">？</span></span>
			                    <div class="mui-media-body">Wait制度/通知</div></a></li>  
			            
			            
			            <%if MO_EI=9 then%>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="AddressBookStu.asp">
			                    <span class="mui-icon mui-icon-phone"></span>
			                    <div class="mui-media-body"><b style="color:blue">学员通讯录</b></div></a></li>
			            <li class="mui-table-view-cell mui-media mui-col-xs-4 mui-col-sm-3"><a href="http://www.carman8.com/supsmart/test.asp">
			                    <span class="mui-icon mui-icon-info"></span>
			                    <div class="mui-media-body">测试</div></a></li>
			          	<%end if%>
			        </ul> 
			</div>
			
			
			
			
			
	
	
			
		
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		</body>
		
	
	</html>

<%Else%>
	<h1>不好意思，这里保密！</h1>
<%END IF%>