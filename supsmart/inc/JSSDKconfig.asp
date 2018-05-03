<!--#include file="sha1.asp"-->
<!--#include file="JSSDK_Class.asp"-->

<script src="template/09/js/jquery.min.js"></script>



<%
Dim wxsdk 
set wxsdk = new JSSDK
	wxsdk.APPID="wx96fb90e810eed259"
	wxsdk.SECRET="db50eb70692b3daa6b948417b037edb4"
Dim signPackage : set signPackage = wxsdk.GetSignPackage()
%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
  /*
   * 注意：
   * 1. 所有的JS接口只能在公众号绑定的域名下调用，公众号开发者需要先登录微信公众平台进入“公众号设置”的“功能设置”里填写“JS接口安全域名”。
   * 2. 如果发现在 Android 不能分享自定义内容，请到官网下载最新的包覆盖安装，Android 自定义分享接口需升级至 6.0.2.58 版本及以上。
   * 3. 常见问题及完整 JS-SDK 文档地址：http://mp.weixin.qq.com/wiki/7/aaa137b55fb2e0456bf8dd9148dd613f.html
   *
   * 开发中遇到问题详见文档“附录5-常见错误及解决办法”解决，如仍未能解决可通过以下渠道反馈：
   * 邮箱地址：weixin-open@qq.com
   * 邮件主题：【微信JS-SDK反馈】具体问题
   * 邮件内容说明：用简明的语言描述问题所在，并交代清楚遇到该问题的场景，可附上截屏图片，微信团队会尽快处理你的反馈。
   */
  wx.config({
    debug: false,
    appId: '<%=signPackage("appId")%>',
    timestamp: <%=signPackage("timestamp")%>,
    nonceStr: '<%=signPackage("nonceStr")%>',
    signature: '<%=signPackage("signature")%>',
    jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ', 'onMenuShareWeibo', 'startRecord', 'stopRecord', 'onVoiceRecordEnd', 'playVoice', 'pauseVoice', 'stopVoice', 'onVoicePlayEnd', 'uploadVoice', 'downloadVoice', 'chooseImage', 'previewImage', 'uploadImage', 'downloadImage', 'translateVoice', 'getNetworkType', 'openLocation', 'getLocation', 'hideOptionMenu', 'showOptionMenu', 'hideMenuItems', 'showMenuItems', 'hideAllNonBaseMenuItem', 'showAllNonBaseMenuItem', 'closeWindow', 'scanQRCode']
  });
function getLocation(Lhref){  
 wx.getLocation({
    type: 'wgs84', // 默认为wgs84的谷歌gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'（谷歌地图 腾讯高德）
    success: function (res) {
        var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
        var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
        var speed = res.speed; // 速度，以米/每秒计
        var accuracy = res.accuracy; // 位置精度
		//alert(latitude);

				$.post('/JStoASPpost/getLocation.asp',
				{
				'latitude':latitude,
				'longitude':longitude,
				'speed':speed
				},
				function(data){
				window.location.href=Lhref;
				});
		}
	});
} 
  function scanQRCode(n)
  {
		wx.scanQRCode(
		{
			needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
			scanType: ["qrCode","barCode"], // 可以指定扫二维码还是一维码，默认二者都有
			success: function (res) 
			{
			var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
			//alert(result);
			
				$.post('/JStoASPpost/scanQRCode.asp',
				{
				'scanQRCode_n':n,
				'scanQRCode':result
				},
				function(data){
				window.location.reload(true); 
				});
			
			}
		});  

  }


  
</script>

