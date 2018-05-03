			
		
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
						value: '87',
						text: '小班'
					}, {
						value: '88',
						text: '中班'
					}, {
						value: '89',
						text: '大班'
					},{
						value: '90',
						text: '暑假班'
					},{
						value: '91',
						text: '寒假班'
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
					
					
					
					
					
				});
			})(mui, document);