<html><head>
		<meta charset="utf-8">
		<title>丰正教育管理系统-变更排课</title>
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
			<h1 class="mui-title">变更排课</h1>
		</header>
		<div class="mui-content">
			<div class="mui-card" align="center">
				<ul class="mui-table-view">
					<form action="text.asp" method="post"  target="_self">
						<li class="mui-table-view-cell mui-collapse">
							
							
							<div class="mui-input-group">
								
								<fieldset>	
									<div  align="center">
										<input type="button" id="classX"  value="选择课程">
									</div>
								</fieldset>	
								
								
								
								
								
								
								<fieldset>
									<div  align="center">
										<input type="button" id="gradeX"  value="选择老师">
										<input type="hidden" id="grade" name="grade" value="0">											
									</div>
									<div  align="center">
										<tr class="trcenter">
											<td  align="center">
												<input type="button" id="classX"  value="选择课程">
												<input type="hidden" id="class" name="class" value="0">
											</td>
											<td  align="center">
												<input type="button" id="gradeX" value="选择年级">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
										</tr>
									</div>
								</fieldset>
								
								<fieldset>
									<div class="mui-input-row">
										<input type="button" id="birthdayX" data-options='{"type":"date","beginYear":1996,"endYear":2016}' class="btn" value="选择日期">		<B>星期几</B>
										<input type="hidden" id="birthday" name="birthday" value="0">
									</div>
									<div  align="center">
										<tr  class="trcenter">
											<td  align="center">
												<input type="button" id="gradeX"  value="上课时间">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
											<td  align="center">
												<input type="button" id="teacherX" value="下课时间">
												<input type="hidden" id="teacher" name="teacher" value="0">
											</td>
										</tr>
									</div>
								</fieldset>
								
								<fieldset>	
									<div  align="center">
										<tr align="center" class="trcenter">
											<td  align="center" class="trcenter">
												<input type="button" id="gradeX"  value="选择学员1">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
											<td align="center"  class="trcenter">
												<label>1对2；剩余100课时</label>
											</td>
										</tr>
									</div>
									
									<div  align="center">
										<tr align="center">
											<td  align="center">
												<input type="button" id="gradeX"  value="选择学员2">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
											<td  align="center">
												<label>1对2；剩余100课时</label>
											</td>
										</tr>
									</div>
									
									<div  align="center">
										<tr align="center">
											<td  align="center">
												<input type="button" id="gradeX"  value="选择学员3">
												<input type="hidden" id="grade" name="grade" value="0">
											</td>
											<td  align="center">
												<label>1对3；剩余200课时</label>
											</td>
										</tr>
									</div>
								</fieldset>	
								
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
		<script>
			(function($) {
				$.init();
				//var result = $('#result')[0];
				var btns = $('.btn');
				btns.each(function(i, btn) {
					btn.addEventListener('tap', function() {
						var optionsJson = this.getAttribute('data-options') || '{}';
						var options = JSON.parse(optionsJson);
						var id = this.getAttribute('id');
						/*
						 * 首次显示时实例化组件
						 * 示例为了简洁，将 options 放在了按钮的 dom 上
						 * 也可以直接通过代码声明 optinos 用于实例化 DtPicker
						 */
						var picker = new $.DtPicker(options);
						picker.show(function(rs) {
							/*
							 * rs.value 拼合后的 value
							 * rs.text 拼合后的 text
							 * rs.y 年，可以通过 rs.y.value 和 rs.y.text 获取值和文本
							 * rs.m 月，用法同年
							 * rs.d 日，用法同年
							 * rs.h 时，用法同年
							 * rs.i 分（minutes 的第二个字母），用法同年
							 */
							document.getElementById("birthdayX").value=rs.text;
							document.getElementById("birthday").value=rs.text;
							//result.innerText = '选择结果: ' + rs.text;
							/* 
							 * 返回 false 可以阻止选择框的关闭
							 * return false;
							 */
							/*
							 * 释放组件资源，释放后将将不能再操作组件
							 * 通常情况下，不需要示放组件，new DtPicker(options) 后，可以一直使用。
							 * 当前示例，因为内容较多，如不进行资原释放，在某些设备上会较慢。
							 * 所以每次用完便立即调用 dispose 进行释放，下次用时再创建新实例。
							 */
							picker.dispose();
						});
					}, false);
				});
			})(mui);
			
			
			
			(function($, doc) {
				$.init();
				$.ready(function() {
					/**
					 * 获取对象属性的值
					 * 主要用于过滤三级联动中，可能出现的最低级的数据不存在的情况，实际开发中需要注意这一点；
					 * @param {Object} obj 对象
					 * @param {String} param 属性名
					 */
					var _getParam = function(obj, param) {
						return obj[param] || '';
					};
					//学校 普通示例
					var userPicker1 = new $.PopPicker();
					userPicker1.setData([{
						value: 'ygexx',
						text: '雅戈尔小学'
					}, {
						value: 'ygezx',
						text: '雅戈尔中学'
					}, {
						value: 'cqxx',
						text: '宸卿小学'
					}, {
						value: 'txgzx',
						text: '田莘耕中学 '
					}]);
					var showUserPickerButton1 = doc.getElementById('schoolX');
					//var userResult = doc.getElementById('userResult');
					showUserPickerButton1.addEventListener('tap', function(event) {
						userPicker1.show(function(items) {
							doc.getElementById("classX").value=items[0].text;
							doc.getElementById("class").value=items[0].text;
							//userResult.innerText = JSON.stringify(items[0]);
							//返回 false 可以阻止选择框的关闭
							//return false;
						});
					}, false);
					//普通示例
					var userPicker2 = new $.PopPicker();
					userPicker2.setData([{
						value: '-3',
						text: '小班'
					}, {
						value: '-2',
						text: '中班'
					}, {
						value: '-1',
						text: '大班'
					},{
						value: '1',
						text: '小学一年级'
					}, {
						value: '2',
						text: '小学二年级'
					}, {
						value: '3',
						text: '小学三年级'
					}, {
						value: '4',
						text: '小学四年级'
					}, {
						value: '5',
						text: '小学五年级'
					}, {
						value: '6',
						text: '小学六年级'
					},{
						value: '7',
						text: '初一'
					}, {
						value: '8',
						text: '初二'
					}, {
						value: '9',
						text: '初三'
					}, {
						value: '10',
						text: '高一'
					}, {
						value: '11',
						text: '高二'
					}, {
						value: '12',
						text: '高三'
					},{
						value: '13',
						text: '大学 '
					}]);
					var showUserPickerButton2 = doc.getElementById('gradeX');
					//var userResult = doc.getElementById('userResult');
					showUserPickerButton2.addEventListener('tap', function(event) {
						userPicker2.show(function(items) {
							doc.getElementById("grade").value=items[0].text;
							doc.getElementById("gradeX").value=items[0].text;
							//userResult.innerText = JSON.stringify(items[0]);
							//返回 false 可以阻止选择框的关闭
							//return false;
						});
					}, false);
					
				});
			})(mui, document);
		</script>

</body></html>