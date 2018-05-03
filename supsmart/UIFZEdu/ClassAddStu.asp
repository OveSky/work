<html><head>
		<meta charset="utf-8">
		<title>丰正教育管理系统-学员排班</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		<!--标准mui.css-->
		<link rel="stylesheet" href="../css/mui.min.css">
		<!--App自定义的css-->
		<!--<link rel="stylesheet" type="text/css" href="../css/app.css"/>-->
		<link rel="stylesheet" type="text/css" href="../css/mui.picker.min.css" />
		<link href="../css/mui.picker.css" rel="stylesheet" />
		<link href="../css/mui.poppicker.css" rel="stylesheet" />
		<style type="text/css">
			.trcenter{
				width:100;
				font-size: 15;
				vertical-align:middle;
			}
		</style>
	</head>
	
	
	<body>
		<header class="mui-bar mui-bar-nav">
			<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left" href="#"> </a>
			<h1 class="mui-title">学员排班</h1>
		</header>
		<div class="mui-content">
			<div class="mui-card" align="center">
				<ul class="mui-table-view">
					<form action="text.asp" method="post"  target="_self">
						<li class="mui-table-view-cell mui-collapse">
							
							
							<div class="mui-input-group">
								<fieldset>
									<div  align="center">
										<input type="button" id="gradeX"  value="选择学生">
										<input type="hidden" id="grade" name="grade" value="0">											
									</div>
									<div  align="center">
										<tr class="trcenter">
											<td  align="center">
												<input type="button" id="classX"  value="选择课程">
												<input type="hidden" id="class" name="class" value="0">
											</td>
											<td  align="center">
												<label>年级</label>
											</td>
										</tr>
									</div>
								</fieldset>
								
								<fieldset>
									<div class="mui-input-row">
										<input type="button" id="birthdayX" data-options='{"type":"date","beginYear":1996,"endYear":2016}' class="btn" value="选择日期">	<B>星期几</B>
										<input type="hidden" id="birthday" name="birthday" value="0">
									</div>
									<div  align="center">
										<tr  class="trcenter">
											<td  align="center">
												<input type="button" id="gradeX"  value="开始时间">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
											<td  align="center">
												<input type="button" id="teacherX" value="截止时间">
												<input type="hidden" id="teacher" name="teacher" value="0">
											</td>
										</tr>
									</div>
								</fieldset>
								
								
								<div class="mui-card">
									<form class="mui-input-group">
										<div class="mui-input-row mui-radio mui-left">
											<tr >
												<td align="center">老师</td>
												<td align="center"><B>状态:未排满<BR>17:00-18:00</B></td>
											</tr>
											<input name="radio1" type="radio">
										</div>
										<div class="mui-input-row mui-radio mui-left">
											<label><I>老师</I><B>状态:无课<BR></B></label>
											<input name="radio1" type="radio" checked>
										</div>
										<div class="mui-input-row mui-radio mui-left mui-disabled">
											<label>disabled radio</label>
											<input name="radio1" type="radio" disabled="disabled">
										</div>
									</form>
								</div>
									
									
									
								
								
							</div>
						</li>
						<br>
						<input type="submit" value="确认">
								
					</form>
					
				</ul>
			</div>
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		<script src="../js/mui.min.js"></script>
		
	
		<script>
			mui.init({
				swipeBack:true //启用右滑关闭功能
			});
			
				
		</script>
		
		
		

		<script src="../js/mui.picker.min.js"></script>
		<script src="../js/mui.picker.js"></script>
		<script src="../js/mui.poppicker.js"></script>
		
		</script>

</body></html>