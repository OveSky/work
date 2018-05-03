﻿<%
'微信错误代码函数
function weixin_err(byval t0)
	if isnul(t0) then weixin_err="" : exit function
	dim t1
	select case t0
		case "-1":		t1="系统繁忙"
		case "0":		t1="请求成功"
		case "40001":	t1="获取access_token时AppSecret错误，或者access_token无效"
		case "40002":	t1="不合法的凭证类型"
		case "40003":	t1="不合法的OpenID"
		case "40004":	t1="不合法的媒体文件类型"
		case "40005":	t1="不合法的文件类型"
		case "40006":	t1="不合法的文件大小"
		case "40007":	t1="不合法的媒体文件id"
		case "40008":	t1="不合法的消息类型"
		case "40009":	t1="不合法的图片文件大小"
		case "40010":	t1="不合法的语音文件大小"
		case "40011":	t1="不合法的视频文件大小"
		case "40012":	t1="不合法的缩略图文件大小"
		case "40013":	t1="不合法的APPID"
		case "40014":	t1="不合法的access_token"
		case "40015":	t1="不合法的菜单类型"
		case "40016":	t1="不合法的按钮个数"
		case "40017":	t1="不合法的按钮个数"
		case "40018":	t1="不合法的按钮名字长度"
		case "40019":	t1="不合法的按钮KEY长度"
		case "40020":	t1="不合法的按钮URL长度"
		case "40021":	t1="不合法的菜单版本号"
		case "40022":	t1="不合法的子菜单级数"
		case "40023":	t1="不合法的子菜单按钮个数"
		case "40024":	t1="不合法的子菜单按钮类型"
		case "40025":	t1="不合法的子菜单按钮名字长度"
		case "40026":	t1="不合法的子菜单按钮KEY长度"
		case "40027":	t1="不合法的子菜单按钮URL长度"
		case "40028":	t1="不合法的自定义菜单使用用户"
		case "40029":	t1="不合法的oauth_code"
		case "40030":	t1="不合法的refresh_token"
		case "40031":	t1="不合法的openid列表"
		case "40032":	t1="不合法的openid列表长度"
		case "40033":	t1="不合法的请求字符，不能包含\uxxxx格式的字符"
		case "40035":	t1="不合法的参数"
		case "40038":	t1="不合法的请求格式"
		case "40039":	t1="不合法的URL长度"
		case "40050":	t1="不合法的分组id"
		case "40051":	t1="分组名字不合法"
		case "41001":	t1="少access_token参数"
		case "41002":	t1="少appid参数"
		case "41003":	t1="少refresh_token参数"
		case "41004":	t1="少secret参数"
		case "41005":	t1="少多媒体文件数据"
		case "41006":	t1="少media_id参数"
		case "41007":	t1="少子菜单数据"
		case "41008":	t1="少oauth code"
		case "41009":	t1="少openid"
		case "42001":	t1="access_token超时"
		case "42002":	t1="refresh_token超时"
		case "42003":	t1="oauth_code超时"
		case "43001":	t1="需要GET请求"
		case "43002":	t1="需要POST请求"
		case "43003":	t1="需要HTTPS请求"
		case "43004":	t1="需要接收者关注"
		case "43005":	t1="需要好友关系"
		case "44001":	t1="多媒体文件为空"
		case "44002":	t1="POST的数据包为空"
		case "44003":	t1="图文消息内容为空"
		case "44004":	t1="文本消息内容为空"
		case "45001":	t1="多媒体文件大小超过限制"
		case "45002":	t1="消息内容超过限制"
		case "45003":	t1="标题字段超过限制"
		case "45004":	t1="描述字段超过限制"
		case "45005":	t1="链接字段超过限制"
		case "45006":	t1="图片链接字段超过限制"
		case "45007":	t1="语音播放时间超过限制"
		case "45008":	t1="图文消息超过限制"
		case "45009":	t1="接口调用超过限制"
		case "45010":	t1="创建菜单个数超过限制"
		case "45015":	t1="回复时间超过限制"
		case "45016":	t1="系统分组，不允许修改"
		case "45017":	t1="分组名字过长"
		case "45018":	t1="分组数量超过上限"
		case "46001":	t1="存在媒体数据"
		case "46002":	t1="存在的菜单版本"
		case "46003":	t1="存在的菜单数据"
		case "46004":	t1="存在的用户"
		case "47001":	t1="解析JSON/XML内容错误"
		case "48001":	t1="api功能未授权"
		case "50001":	t1="用户未授权该api"
		case else:		t1="未知错误："&t0
	end select
	weixin_err=t1
end function
%>