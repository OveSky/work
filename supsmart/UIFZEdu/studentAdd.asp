<html><head>
		<meta charset="utf-8">
		<title>优典集团丰正校区管理系统-添加新学员</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		<!--标准mui.css-->
		<link rel="stylesheet" href="../css/mui.min.css">
		<!--js选择菜单HEAD部分-->
		<link rel="stylesheet" type="text/css" href="../css/mui.picker.min.css" />
		<link href="../css/mui.picker.css" rel="stylesheet" />
		<link href="../css/mui.poppicker.css" rel="stylesheet" />
		
		
		
		<style>
		
		
		</style>
	</head>
	
	
	<body>
		<header class="mui-bar mui-bar-nav">
			<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left" href="#"> </a>
			<h1 class="mui-title">添加新学员</h1>
		</header>
		<div class="mui-content">
			<div class="mui-card" align="center">
				<ul class="mui-table-view">
					<form action="text.asp" method="post"  target="_self">
						<li class="mui-table-view-cell mui-collapse">
							
							
							<div class="mui-input-group">
								
								
									<div class="mui-input-row">
										<label>姓名</label>
										<input type="text" placeholder="姓名">
									</div>
									<div class="mui-input-row">
										<label>学校</label>
										<input type="button" id="schoolX" value="选择学校">
										<input type="hidden" id="school" name="school" value="0">
									</div>
									<div  align="center">
										<tr align="center">
											<td  align="center">
												<input type="button" id="gradeX"  value="选择年级" style="width:100;font-size: 15;vertical-align:middle;">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
											<td  align="center">
												<input type="text" placeholder="班级"  style="width:100;font-size: 15;vertical-align:middle;">											
											</td>
										</tr>
									</div>
									<br>
									<div class="mui-input-row">
										<label>手机</label>
										<input type="text" id="phone" name="phone" placeholder="手机号码">
									</div>
									<div class="mui-input-row">
										<label>生日</label>
										<input type="button" id="Date1X" data-options='{"type":"date","beginYear":1996,"endYear":2016}' class="btn" value="选择日期">	
										<input type="hidden" id="Date1" name="Date1" value="0">
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
		
		
		

		<!--js选择菜单END部分-->
		<script src="../js/mui.picker.min.js"></script>
		<script src="../js/mui.picker.js"></script>
		<script src="../js/mui.poppicker.js"></script>
		<script src="../js/ss.XZSchool.js"></script>
		<script src="../js/ss.XZgrade.js"></script>
		<script src="../js/ss.XZDate1.js"></script>

</body></html>