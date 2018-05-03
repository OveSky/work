<!--#include file="admin_inc.asp"-->
<% checkPower "" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=siteName%>-后台左侧</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="images/Main.css" rel="stylesheet" type="text/css" />
<script type="text/JavaScript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body style="background:url(images/left_bg.gif) repeat-y;">
<div class="main_left">
    <div class="left_c12" id="lct1" onclick="changeNav(1);"><div class="left_txt2" id="lt1">系统首页</div></div>
    <div class="left_c21" id="lct2" onclick="changeNav(2);"><div class="left_txt1" id="lt2">店铺管理</div></div>
    <div class="left_c31" id="lct3" onclick="changeNav(3);"><div class="left_txt1" id="lt3">商品管理</div></div>
    <div class="left_c41" id="lct4" onclick="changeNav(4);"><div class="left_txt1" id="lt4">订单管理</div></div>
    <div class="left_c51" id="lct5" onclick="changeNav(5);"><div class="left_txt1" id="lt5">用户管理</div></div>
    <div class="left_c61" id="lct6" onclick="changeNav(6);"><div class="left_txt1" id="lt6">营销活动</div></div>
    <div class="left_c71" id="lct7" onclick="changeNav(7);"><div class="left_txt1" id="lt7">收支明细</div></div>
    <div class="left_c81" id="lct8" onclick="changeNav(8);"><div class="left_txt1" id="lt8">系统设置</div></div>
    <div class="left_c91" id="lct9" onclick="changeNav(9);"><div class="left_txt1" id="lt9">公众号设置</div></div>
</div>
</body>
</html>
<%terminateAllObjects%>
<script language="javascript" charset="utf-8">
function changeNav(id){
	for(var i=1;i<10;i++){
		$("#lct"+i).attr("className","left_c"+i+"1");
		$("#lt"+i).attr("className","left_txt1");
	}
	$("#lct"+id).attr("className","left_c"+id+"2");
	$("#lt"+id).attr("className","left_txt2");
	switch(id)
	{
	case 1:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_main.asp");
	  break;
	case 2:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_shop.asp");
	  break;
	case 3:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_product.asp");
	  break;
	case 4:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_order.asp");
	  break;
	case 5:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_user.asp");
	  break;
	case 6:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_main.asp");
	  break;
	case 7:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_details.asp");
	  break;
	case 8:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_config.asp");
	  break;
	case 9:
	  $(window.parent.document).find("#mainFrame").attr("src","admin_wxconfig.asp");
	  break;
    }
}
</script>