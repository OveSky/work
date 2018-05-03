<!--#include file="admin_inc.asp"-->
<%

dim action : action = getForm("action", "get")
Select case action
	case "editbase" : checkPower "" : editBase
	case else : checkPower "" : base
End Select
terminateAllObjects

Sub base
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>基本设置</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：公众号设置 > 基本设置</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_wxconfig.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_column.asp">自定义菜单</a></div>
</div>
<div class="m_ctr1">
    <form method="post" action="?action=editbase">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="120" height="46"><div class="td_left">公众号类型：</div></td>
            <td>
                <select name="wxType" onChange="selectWxtype(this.options[this.selectedIndex].value)" class="input_select">
                    <option value="0" <%if wxType="0" then Echo "selected" end if%>>认证订阅号</option>
                    <option value="1"  <%if wxType="1" then Echo "selected" end if%>>认证服务号</option>
                </select><div class="m_et2">如果是订阅号，需要绑定一个认证的服务号。</div>
            </td>
        </tr>
        <tr id="h1" <%if wxType="1" then %>style="display:none"<%end if%>>
            <td width="120" height="46"><div class="m_et2" style="float:right;">服务号AppID：</div></td>
            <td><input type="text" name="wxFAppId" class="input_txt" value="<%=wxFAppId%>" style="width:150px;" /><div class="m_et2">认证服务号公众平台->开发者中心获取</div></td>
        </tr>
        <tr id="h3" <%if wxType="1" then %>style="display:none"<%end if%>>
            <td width="120" height="46"><div class="m_et2" style="float:right;">授权网页：</div></td>
            <td><input type="text" name="wxFUrl" class="input_txt" value="<%=wxFUrl%>" /><div class="m_et2">服务号网页授权地址。不加http://</div></td>
        </tr>
        <tr id="h2" <%if wxType="1" then %>style="display:none"<%end if%>>
            <td width="120" height="46"><div class="m_et2" style="float:right;">未关注跳转：</div></td>
            <td><input type="text" name="wxTurn" class="input_txt" value="<%=wxTurn%>" /><div class="m_et2">未关注跳转到关注页面地址</div></td>
        </tr>
        <tr>
            <td width="120" height="46"><div class="td_left">AppID：</div></td>
            <td><input type="text" name="wxAppId" class="input_txt" value="<%=wxAppId%>" style="width:150px;" /><div class="m_et2">公众平台->开发者中心获取</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">AppSecret：</div></td>
            <td><input type="password" name="wxAppsecret" class="input_txt" value="<%=wxAppsecret%>" style="width:280px;" /><div class="m_et2">开发者中心获取</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">Token：</div></td>
            <td><input type="text" name="wxToken" class="input_txt" value="<%=wxToken%>" style="width:150px;" /><div class="m_et2">开发者中心获取</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">名称：</div></td>
            <td><input type="text" name="wxName" class="input_txt" value="<%=wxName%>" style="width:150px;" /><div class="m_et2">公众平台->公众号设置获取</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">微信号：</div></td>
            <td><input type="text" name="wxID" class="input_txt" value="<%=wxID%>" style="width:150px;" /><div class="m_et2">公众号设置获取</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">原始ID：</div></td>
            <td><input type="text" name="wxYID" class="input_txt" value="<%=wxYID%>" style="width:150px;" /><div class="m_et2">公众号设置获取</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">管理员openID：</div></td>
            <td><input type="text" name="openID" class="input_txt" value="<%=openID%>" /><div class="m_et2">用户管理中查询，用于接收订单信息</div></td>
        </tr>
        <tr>
            <td width="100" height="98"><div class="td_left">首次关注回复：</div></td>
            <td>
                <textarea name="m_wxtext" cols="50" rows="4" class="input_textarea1"><%=codeTextarea(conn.db("select top 1 wxText from {pre}Config","1")(0),"de")%></textarea><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认保存" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
    </form>
</div>
</body>
</html>
<script language="javascript">
function selectWxtype(value){
	if (value=="0"){$("#h1").show();$("#h2").show();$("#h3").show();}
	if (value=="1"){$("#h1").hide();$("#h2").hide();$("#h3").hide();}
}
</script>
<%
End Sub

Sub editBase
	dim configStr
	configStr="<%"&vbcrlf& _
	"wxAppId="""&getForm("wxAppId","post")&""""&vbcrlf& _
	"wxAppsecret="""&getForm("wxAppsecret","post")&""""&vbcrlf& _
	"wxToken="""&getForm("wxToken","post")&""""&vbcrlf& _
	"wxName="""&getForm("wxName","post")&""""&vbcrlf& _
	"wxID="""&getForm("wxID","post")&""""&vbcrlf& _
	"wxYID="""&getForm("wxYID","post")&""""&vbcrlf& _
	"openID="""&getForm("openID","post")&""""&vbcrlf& _
	"wxType="""&getForm("wxType","post")&""""&vbcrlf& _
	"wxFAppId="""&getForm("wxFAppId","post")&""""&vbcrlf& _
	"wxFUrl="""&getForm("wxFUrl","post")&""""&vbcrlf& _
	"wxTurn="""&getForm("wxTurn","post")&""""&vbcrlf&"%"&">"
	myfile.createTextFile configStr,"../inc/wxconfig.asp",""
	dim m_wxtext : m_wxtext = codeTextarea(getForm("m_wxtext","post"),"en")
	conn.db "update {pre}Config set wxText='"&m_wxtext&"'","0"
	alert "修改成功","admin_wxconfig.asp",""
End Sub
%>