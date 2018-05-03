	
			
			
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
					
					
					
					
				});
			})(mui, document);