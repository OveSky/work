<!--#include virtual="supsmart/VipOrder.asp"-->

<%IF MO_EI>0 THEN	'默认0'%>
	<html><head>
			<meta charset="utf-8">
			<title>学员课程查询-优典集团丰正校区管理系统</title>
			<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
			<meta name="apple-mobile-web-app-capable" content="yes">
			<meta name="apple-mobile-web-app-status-bar-style" content="black">
	
			<!--标准mui.css-->
			<link rel="stylesheet" href="../css/mui.min.css">
			<script src="../js/mui.min.js"></script>
			
			<link rel="stylesheet" href="../css/MYstyle.css">
			
			<style>
				.mui-card .mui-control-content {
					padding: 10px;
				}
				
				.mui-control-content {
					height:566px;
				}
			</style>
		</head>
	
		
		
		
		<body>
			<header class="mui-bar mui-bar-nav">
				<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"> </a>
				<a href="StuIndex.asp"><h1 class="mui-title"><B ><%=USENAME%></B> 学员课程查询</h1> </a>
				
			</header>
		
		
			<div class="mui-content">
				<div style="padding: 10px 10px;">
					<div id="segmentedControl" class="mui-segmented-control">
						<a class="mui-control-item mui-active" href="#item1">课程安排</a>
						<a class="mui-control-item" href="#item2">课后反馈</a>
						<a class="mui-control-item" href="#item3">课外</a>
					</div>
				</div>
				<div>
					
					<div id="item1" class="mui-control-content  mui-active">
						<div id="scroll1" class="mui-scroll-wrapper">
							<div class="mui-scroll">
								<ul class="mui-table-view">
									<%
									dim RSQL,RConn,Rrs	
									if VipOrder>80 then
										RSQL="SELECT TOP (100) PERCENT dbo.Class.ClaID, dbo.Class.老师ID, dbo.employee.name AS 老师名字, dbo.Class.科目, dbo.Class.日期, dbo.Class.上课时间, dbo.Class.下课时间, dbo.Class.课时, dbo.ClassMatch.CMID, dbo.ClassMatch.StuID, dbo.Student.Name AS 学员名字, dbo.ClassMatch.FBid  FROM  dbo.employee RIGHT OUTER JOIN  dbo.Class ON dbo.employee.EmpID = dbo.Class.老师ID LEFT OUTER JOIN  dbo.Student RIGHT OUTER JOIN  dbo.ClassMatch ON dbo.Student.StuID = dbo.ClassMatch.StuID ON dbo.Class.ClaID = dbo.ClassMatch.ClaID WHERE  (dbo.Class.作废标示 IS NULL) AND (dbo.Class.日期 > { fn NOW() } - 2) AND (dbo.Class.课时 > 0) AND (dbo.Class.老师ID>0)  AND (dbo.ClassMatch.FBid IS NULL) ORDER BY  dbo.Class.日期,dbo.ClassMatch.StuID, dbo.Class.上课时间"
									else
										RSQL="SELECT TOP (100) PERCENT dbo.Class.ClaID, dbo.Class.老师ID, dbo.employee.name AS 老师名字, dbo.Class.科目, dbo.Class.日期, dbo.Class.上课时间, dbo.Class.下课时间, dbo.Class.课时, dbo.ClassMatch.CMID, dbo.ClassMatch.StuID, dbo.Student.Name AS 学员名字, dbo.ClassMatch.FBid  FROM  dbo.employee RIGHT OUTER JOIN  dbo.Class ON dbo.employee.EmpID = dbo.Class.老师ID LEFT OUTER JOIN  dbo.Student RIGHT OUTER JOIN  dbo.ClassMatch ON dbo.Student.StuID = dbo.ClassMatch.StuID ON dbo.Class.ClaID = dbo.ClassMatch.ClaID WHERE  (dbo.Class.作废标示 IS NULL) AND (dbo.Class.日期 > { fn NOW() } - 2)  AND (dbo.Student.Name = N'"&USENAME&"')  AND (dbo.Class.课时 > 0)  AND (dbo.Class.老师ID>0)  AND (dbo.ClassMatch.FBid IS NULL) ORDER BY dbo.Class.日期, dbo.ClassMatch.StuID, dbo.Class.上课时间"
									end if
									Set RConn=Server.CreateObject("SsFadodb.SsFConn")
									set Rrs=RConn.Rs("S","SsF",RSQL,1)
									do While not Rrs.eof	
									%>
										<li class="mui-table-view-cell" <%if cdate(Rrs(6))<now() then%> style="background-color: #1AC7C3;" <%end if%>>
												<span class="bo bo5"><%=Rrs(10)%></span>
												<span class="bo bo7"><%=Rrs(2)%>
													<span class="bo bo6"><%=Rrs(3)%></span>
												</span>
												<span class="bo bo7"><%=Rrs(4)%>
													<span class="bo bo6"><%=FormatDateTime(Rrs(5),4)%></span> -
													<span class="bo bo6"><%=FormatDateTime(Rrs(6),4)%></span> 
													</span> 
												</span> 										
											</li>
			
									<%	Rrs.MoveNext										
									Loop
									Rrs.close:set Rrs=nothing
									set RConn=nothing	
										
										
									%>
									
								</ul>
							</div>
						</div>
					</div>
					
					
					<div id="item2" class="mui-control-content ">
						<div id="scroll2" class="mui-scroll-wrapper">
							<div class="mui-scroll">
								<ul class="mui-table-view">
									<%
									
									if VipOrder>80 then
										RSQL="SELECT TOP (100) PERCENT dbo.Class.ClaID, dbo.Class.老师ID, dbo.employee.name AS 老师名字, dbo.Class.科目, dbo.Class.日期, dbo.Class.上课时间, dbo.Class.下课时间, dbo.Class.课时, dbo.ClassMatch.CMID, dbo.ClassMatch.StuID, dbo.Student.Name AS 学员名字, dbo.Feedback.FBid, dbo.Feedback.反馈关键词, dbo.Feedback.反馈时间   FROM dbo.Feedback RIGHT OUTER JOIN dbo.ClassMatch ON dbo.Feedback.FBid = dbo.ClassMatch.FBid AND dbo.Feedback.CMID = dbo.ClassMatch.CMID LEFT OUTER JOIN  dbo.Student ON dbo.ClassMatch.StuID = dbo.Student.StuID RIGHT OUTER JOIN  dbo.Class LEFT OUTER JOIN  dbo.employee ON dbo.Class.老师ID = dbo.employee.EmpID ON dbo.ClassMatch.ClaID = dbo.Class.ClaID  WHERE (dbo.Class.教师确认标示 = 1) AND (dbo.Class.作废标示 IS NULL) AND (dbo.Class.日期 >= CONVERT(DATETIME, '2018-04-29 00:00:00', 102)) AND  (dbo.Feedback.FBid IS not NULL) ORDER BY dbo.Class.日期 DESC, dbo.ClassMatch.StuID,  dbo.Class.上课时间"
									else
										RSQL="SELECT TOP (100) PERCENT dbo.Class.ClaID, dbo.Class.老师ID, dbo.employee.name AS 老师名字, dbo.Class.科目, dbo.Class.日期, dbo.Class.上课时间, dbo.Class.下课时间, dbo.Class.课时, dbo.ClassMatch.CMID, dbo.ClassMatch.StuID, dbo.Student.Name AS 学员名字, dbo.Feedback.FBid, dbo.Feedback.反馈关键词, dbo.Feedback.反馈时间   FROM dbo.Feedback RIGHT OUTER JOIN dbo.ClassMatch ON dbo.Feedback.FBid = dbo.ClassMatch.FBid AND dbo.Feedback.CMID = dbo.ClassMatch.CMID LEFT OUTER JOIN  dbo.Student ON dbo.ClassMatch.StuID = dbo.Student.StuID RIGHT OUTER JOIN  dbo.Class LEFT OUTER JOIN  dbo.employee ON dbo.Class.老师ID = dbo.employee.EmpID ON dbo.ClassMatch.ClaID = dbo.Class.ClaID  WHERE (dbo.Class.教师确认标示 = 1) AND (dbo.Class.作废标示 IS NULL) AND (dbo.Class.日期 >= CONVERT(DATETIME, '2018-04-29 00:00:00', 102)) AND  (dbo.Feedback.FBid IS not NULL) AND (dbo.Student.Name = N'"&USENAME&"')  ORDER BY dbo.Class.日期 DESC, dbo.ClassMatch.StuID,  dbo.Class.上课时间"
									end if 
									Set RConn=Server.CreateObject("SsFadodb.SsFConn")
									set Rrs=RConn.Rs("S","SsF",RSQL,1)
									do While not Rrs.eof	
									%>
										<a href="FeedbackContent.asp?T=Stu&CMID=<%=Rrs(8)%>&FBID=<%=Rrs(11)%>">
											<li class="mui-table-view-cell">
												<span class="bo bo5"><%=Rrs(10)%></span>
												<span class="bo bo7"><%=Rrs(2)%>
													<span class="bo bo6"><%=Rrs(3)%></span>
												</span>
												<span class="bo bo7"><%=Rrs(4)%>
													<span class="bo bo6"><%=FormatDateTime(Rrs(5),4)%></span> -
													<span class="bo bo6"><%=FormatDateTime(Rrs(6),4)%></span> 
													</span> 
												</span> 
												<span class="bo bo3"><%=Rrs(12)%></span>
											</li>
										</a>
									<%	Rrs.MoveNext										
									Loop
									Rrs.close:set Rrs=nothing
									set RConn=nothing	
										
										
									%>
									
								</ul>
							</div> 
						</div>
					</div>
					
					
					<div id="item3" class="mui-control-content">
						<div id="scroll3" class="mui-scroll-wrapper">
							<div class="mui-scroll">
								<ul class="mui-table-view">
									<li class="mui-table-view-cell">
										
									</li>
									
								</ul>
							</div> 
						</div>	
					</div>
						
						
					
					
				</div>	
			</div>
			
			
			
			
			
			<script src="../js/mui.min.js"></script>
			<script>
				mui.init({
					swipeBack: true //启用右滑关闭功能
				});
				(function($) {
					$('#scroll1').scroll({
						indicators: true //是否显示滚动条
					});
					var segmentedControl = document.getElementById('segmentedControl');
					$('.mui-input-group').on('change', 'input', function() {
						if (this.checked) {
							var styleEl = document.querySelector('input[name="style"]:checked');
							var colorEl = document.querySelector('input[name="color"]:checked');
							if (styleEl && colorEl) {
								var style = styleEl.value;
								var color = colorEl.value;
								segmentedControl.className = 'mui-segmented-control' + (style ? (' mui-segmented-control-' + style) : '') + ' mui-segmented-control-' + color;
							}
						}
					});
				})(mui);
				(function($) {
					$('#scroll2').scroll({
						indicators: true //是否显示滚动条
					});
					var segmentedControl = document.getElementById('segmentedControl');
					$('.mui-input-group').on('change', 'input', function() {
						if (this.checked) {
							var styleEl = document.querySelector('input[name="style"]:checked');
							var colorEl = document.querySelector('input[name="color"]:checked');
							if (styleEl && colorEl) {
								var style = styleEl.value;
								var color = colorEl.value;
								segmentedControl.className = 'mui-segmented-control' + (style ? (' mui-segmented-control-' + style) : '') + ' mui-segmented-control-' + color;
							}
						}
					});
				})(mui);
				(function($) {
					$('#scroll3').scroll({
						indicators: true //是否显示滚动条
					});
					var segmentedControl = document.getElementById('segmentedControl');
					$('.mui-input-group').on('change', 'input', function() {
						if (this.checked) {
							var styleEl = document.querySelector('input[name="style"]:checked');
							var colorEl = document.querySelector('input[name="color"]:checked');
							if (styleEl && colorEl) {
								var style = styleEl.value;
								var color = colorEl.value;
								segmentedControl.className = 'mui-segmented-control' + (style ? (' mui-segmented-control-' + style) : '') + ' mui-segmented-control-' + color;
							}
						}
					});
				})(mui);
			</script>
		</body>
	</html>



<%Else%>
	<h1>尚未开放！</h1>
<%END IF%>