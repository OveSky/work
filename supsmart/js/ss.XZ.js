			
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
							document.getElementById("Date1X").value=rs.text;
							document.getElementById("Date1").value=rs.text;
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
					
					
					//年级 普通示例
					var userPicker1= new $.PopPicker();
					var v1='grade';
					var v1X=v1+'X';
					userPicker1.setData([{
						value: '187',
						text: '小班'
					}, {
						value: '188',
						text: '中班'
					}, {
						value: '189',
						text: '大班'
					},{
						value: '101',
						text: '一年级'
					}, {
						value: '102',
						text: '二年级'
					}, {
						value: '103',
						text: '三年级'
					}, {
						value: '104',
						text: '四年级'
					}, {
						value: '105',
						text: '五年级'
					}, {
						value: '106',
						text: '六年级'
					},{
						value: '107',
						text: '初一'
					}, {
						value: '108',
						text: '初二'
					}, {
						value: '109',
						text: '初三'
					}, {
						value: '110',
						text: '高一'
					}, {
						value: '111',
						text: '高二'
					}, {
						value: '112',
						text: '高三'
					}]);
					var showUserPickerButton1 = doc.getElementById(v1X);
					//var userResult = doc.getElementById('userResult');
					showUserPickerButton1.addEventListener('tap', function(event) {
						userPicker1.show(function(items) {
							doc.getElementById(v1).value=items[0].text;
							doc.getElementById(v1X).value=items[0].text;
							//userResult.innerText = JSON.stringify(items[0]);
							//返回 false 可以阻止选择框的关闭
							//return false;
						});
					}, false);
					
					
					
					//学校 普通示例
					var userPicker2 = new $.PopPicker();
					var v2='school';
					var v2X=v2+'X';
					userPicker2.setData([{
						value: '201',
						text: '雅戈尔小学'
					}, {
						value: '202',
						text: '雅戈尔中学'
					}, {
						value: '203',
						text: '宸卿小学'
					}, {
						value: '204',
						text: '田莘耕中学 '
					}]);
					var showUserPickerButton2 = doc.getElementById(v2X);
					//var userResult = doc.getElementById('userResult');
					showUserPickerButton2.addEventListener('tap', function(event) {
						userPicker2.show(function(items) {
							doc.getElementById(v2).value=items[0].text;
							doc.getElementById(v2X).value=items[0].text;
							//userResult.innerText = JSON.stringify(items[0]);
							//返回 false 可以阻止选择框的关闭
							//return false;
						});
					}, false);
					
					
					//课程 普通示例
					var userPicker3 = new $.PopPicker();
					var v3='lesson';
					var v3X=v3+'X';
					userPicker3.setData([{
						value: '301',
						text: '语文'
					}, {
						value: '302',
						text: '数学'
					}, {
						value: '303',
						text: '英语'
					}, {
						value: '304',
						text: '科学 '
					}, {
						value: '305',
						text: '奥数 '
					}]);
					var showUserPickerButton3 = doc.getElementById(v3X);
					showUserPickerButton3.addEventListener('tap', function(event) {
						userPicker3.show(function(items) {
							doc.getElementById(v3).value=items[0].text;
							doc.getElementById(v3X).value=items[0].text;
							//userResult.innerText = JSON.stringify(items[0]);
							//返回 false 可以阻止选择框的关闭
							//return false;
						});
					}, false);
					
					
					
					
					
					
					//其他 普通示例
					
					
					
				});
			})(mui, document);