				
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
					}, {
						value: '306',
						text: '物理 '
					}, {
						value: '307',
						text: '化学 '
					}]);
					var showUserPickerButton3 = doc.getElementById(v3X);
					showUserPickerButton3.addEventListener('tap', function(event) {
						userPicker3.show(function(items) {
							doc.getElementById(v3).value=items[0].text;
							doc.getElementById(v3X).value=items[0].text;
							document.cookie="lesson="+items[0].text; 
							document.cookie="lessonV="+items[0].text; 
							//userResult.innerText = JSON.stringify(items[0]);
							//返回 false 可以阻止选择框的关闭
							//return false;
						});
					}, false);
					
					
					
					
					
					
					//其他 普通示例
					
					
					
				});
			})(mui, document);