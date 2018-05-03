<!--#include file="admin_inc.asp"-->
<%

dim action : action = getForm("action", "get")
Select case action
	case "editsite" : checkPower "" : editSite
	case "editupload" : checkPower "" : editUpload
	case "editother" : checkPower "" : editOther
	case "upload" : checkPower "" : upload
	case "other" : checkPower "" : other
	case else : checkPower "" : site
End Select
terminateAllObjects

Sub site
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>基本设置</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：系统管理 > 基本设置</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_config.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_config.asp?action=upload">上传设置</a></div>
    <div class="m_t23"><a href="admin_config.asp?action=other">付款设置</a></div>
    <div class="m_t24"><a href="admin_manager.asp">管理员列表</a></div>
    <div class="m_t25"><a href="admin_manager.asp?action=add">添加管理员</a></div>
</div>
<div class="m_ctr1">
    <form method="post" action="?action=editsite">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="110" height="46"><div class="td_left">运行状态：</div></td>
            <td>
                <input type="radio" name="errMode" class="input_radio" value="0" <%if errMode="0" then%>checked="checked"<%end if%> /><div class="m_txt">正常</div>
                <input type="radio" name="errMode" class="input_radio" value="1" <%if errMode="1" then%>checked="checked"<%end if%> /><div class="m_txt">调试</div>
                <div class="m_et2">调试状态将显示详细的错误信息,对快速找到错误有帮助</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">网站名称：</div></td>
            <td><input type="text" name="siteName" class="input_txt" value="<%=siteName%>" /><div class="m_et2"></div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">网站地址：</div></td>
            <td><input type="text" name="siteUrl" class="input_txt" value="<%=siteUrl%>" /><div class="m_et2">如：www.ideacms.net</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">网站路径：</div></td>
            <td><input type="text" name="sitePath" class="input_txt" value="<%=sitePath%>" /><div class="m_et2">必须以"/"结尾,根目录下这里设置为空</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">推广码背景：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="<%=siteLogo%>" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2"></div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">二维码位置：</div></td>
            <td><input type="text" name="m_ewmLocation" class="input_txt" value="<%=ewmLocation%>" style="width:120px;" /><div class="m_et2">格式：左边距离*顶部距离</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">总店幻灯片：</div></td>
            <td>
                <input type="text" name="m_slide" id="m_slide" class="input_txt" value="<%=slidePic%>" />
                <input type="button" value="上传" class="input_up" onclick="upImage1();" /><div class="m_et2"></div>
                <span style="display:none;"><script type="text/plain" id="upload_ue1"></script></span>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">提成比例：</div></td>
            <td><input type="text" name="m_tcbl" class="input_txt" value="<%=tcPercent%>" style="width:120px;" /><div class="m_et2">格式：0.5:0.3:0.2。三个数加起来等于1。</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">最低提现额：</div></td>
            <td><input type="text" name="m_zdtxe" class="input_txt" value="<%=tcAmount%>" style="width:120px;" /><div class="m_et2">请填写整数。如：50</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">数据库选择：</div></td>
            <td>
                <select name="databaseType" onChange="selectDataBase(this.options[this.selectedIndex].value)" class="input_select">
                    <option value="sql" <%if databaseType="sql" then Echo "selected" end if%>>MS-SqlServer</option>
                    <option value="acc"  <%if databaseType="acc" then Echo "selected" end if%>>Access</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr id="acc">
            <td height="46"><div class="td_left">数据库地址：</div></td>
            <td><input type="text" name="accessFilePath" class="input_txt" value="<%=accessFilePath%>" /><div class="m_et2"></div></td>
        </tr>
        <tr id="mssql1" <%if databaseType="acc" then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">服务器名称：</div></td>
            <td><input type="text" name="databaseServer" class="input_txt" value="<%=databaseServer%>" /><div class="m_et2">SQL服务器名称或IP地址</div></td>
        </tr>
        <tr id="mssql2" <%if databaseType="acc" then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">数据库名称：</div></td>
            <td><input type="text" name="databaseName" class="input_txt" value="<%=databaseName%>" /><div class="m_et2"></div></td>
        </tr>
        <tr id="mssql3" <%if databaseType="acc" then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">数据库账号：</div></td>
            <td><input type="text" name="databaseUser" class="input_txt" value="<%=databaseUser%>" /><div class="m_et2"></div></td>
        </tr>
        <tr id="mssql4" <%if databaseType="acc" then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">数据库密码：</div></td>
            <td><input type="password" name="databasePwd" class="input_txt" value="<%=databasePwd%>" /><div class="m_et2"></div></td>
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
<script language="javascript" charset="utf-8">
var editor = UE.getEditor('upload_ue');
editor.ready(function () {
	editor.setDisabled();
	editor.hide();
	editor.addListener('beforeInsertImage', function (t, arg) {
	   $("#m_pic").attr("value", arg[0].src.replace("/<%=sitePath%>upload/pic/",""));
	})
});
function upImage() {
   var myImage = editor.getDialog("insertimage");
   myImage.open();
}

var editor1 = UE.getEditor('upload_ue1');
editor1.ready(function () {
	editor1.setDisabled();
	editor1.hide();
	editor1.addListener('beforeInsertImage', function (t, arg) {
	    for(var i=0;i<arg.length;i++){
		   $("#m_slide").val($("#m_slide").val()+arg[i].src.replace("/<%=sitePath%>upload/pic/","")+"|");
	   }
	})
});
function upImage1() {
   var myImage1 = editor1.getDialog("insertimage");
   myImage1.open();
}

function selectDataBase(value){
	if (value=="acc"){$("#acc").show();for (var i=1;i<=4;i++){$('#mssql'+i).hide();}}
	if (value=="sql"){$("#acc").hide();for (var i=1;i<=4;i++){$('#mssql'+i).show();}}
}
</script>
</body>
</html>
<%
End Sub

Sub upload
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>上传设置</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：系统管理 > 上传设置</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_config.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_config.asp?action=upload">上传设置</a></div>
    <div class="m_t23"><a href="admin_config.asp?action=other">付款设置</a></div>
    <div class="m_t24"><a href="admin_manager.asp">管理员列表</a></div>
    <div class="m_t25"><a href="admin_manager.asp?action=add">添加管理员</a></div>
</div>
<div class="m_ctr1">
    <form method="post" action="?action=editupload">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="140" height="46"><div class="td_left">允许上传文件类型：</div></td>
            <td>
                <input type="text" name="upType" class="input_txt" value="<%=configArr(1,0)%>" />
                <div class="m_et2">如：jpg/gif 用/隔开</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">允许上传文件大小：</div></td>
            <td><input type="text" name="upSize" class="input_txt" value="<%=configArr(2,0)%>" style="width:80px;" /><div class="m_txt">K</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">开启缩略图：</div></td>
            <td>
                <select name="pictype" onChange="selectPic(this.options[this.selectedIndex].value)" class="input_select">
                    <option value="0" <%if configArr(3,0)=0 then Echo "selected" end if%>>关闭</option>
                    <option value="1"  <%if configArr(3,0)=1 then Echo "selected" end if%>>开启</option>
                </select>
                <div class="m_et2">开启需要aspjpeg组件支持</div>
            </td>
        </tr>
        <tr id="pic1" <%if configArr(3,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">缩略图尺寸：</div></td>
            <td><input type="text" name="picSize" class="input_txt" value="<%=configArr(4,0)%>" /><div class="m_et2">格式：100*100，单位为像素</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">图片水印：</div></td>
            <td>
                <select name="marktype" onChange="selectMark(this.options[this.selectedIndex].value)" class="input_select">
                    <option value="0" <%if configArr(5,0)=0 then Echo "selected" end if%>>关闭</option>
                    <option value="1"  <%if configArr(5,0)=1 then Echo "selected" end if%>>开启</option>
                </select>
                <div class="m_et2">开启需要aspjpeg组件支持</div>
            </td>
        </tr>
        <tr id="pic2" <%if configArr(5,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">水印位置：</div></td>
            <td>
                <select name="markLocal" class="input_select">
                    <option value="0" <%if configArr(6,0)=0 then%>selected="selected"<%end if%>>左上</option>
                    <option value="1" <%if configArr(6,0)=1 then%>selected="selected"<%end if%>>左下</option>
                    <option value="2" <%if configArr(6,0)=2 then%>selected="selected"<%end if%>>居中</option>
                    <option value="3" <%if configArr(6,0)=3 then%>selected="selected"<%end if%>>右上</option>
                    <option value="4" <%if configArr(6,0)=4 then%>selected="selected"<%end if%>>右下</option>
                </select>
            </td>
        </tr>
        <tr id="pic3" <%if configArr(5,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">水印图片：</div></td>
            <td>
                <input type="text" name="markPic" id="m_pic" class="input_txt" value="<%=configArr(7,0)%>" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" />
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
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
<script language="javascript" charset="utf-8">
var editor = UE.getEditor('upload_ue');
editor.ready(function () {
	editor.setDisabled();
	editor.hide();
	editor.addListener('beforeInsertImage', function (t, arg) {
	   $("#m_pic").attr("value", arg[0].src.replace("/<%=sitePath%>upload/pic/",""));
	})
});
function upImage() {
   var myImage = editor.getDialog("insertimage");
   myImage.open();
}
function selectPic(value){
	if (value=="0"){$('#pic1').hide();}
	if (value=="1"){$('#pic1').show();}
}
function selectMark(value){
	if (value=="0"){for (var i=2;i<=3;i++){$('#pic'+i).hide();}}
	if (value=="1"){for (var i=2;i<=3;i++){$('#pic'+i).show();}}
}
</script>
</body>
</html>
<%
End Sub

Sub other
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>付款设置</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：系统管理 > 付款设置</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_config.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_config.asp?action=upload">上传设置</a></div>
    <div class="m_t23"><a href="admin_config.asp?action=other">付款设置</a></div>
    <div class="m_t24"><a href="admin_manager.asp">管理员列表</a></div>
    <div class="m_t25"><a href="admin_manager.asp?action=add">添加管理员</a></div>
</div>
<div class="m_ctr1">
    <form method="post" action="?action=editother">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="110" height="46"><div class="td_left">微信支付：</div></td>
            <td>
                <select name="m_wxpay" class="input_select" onChange="selectWxPay(this.options[this.selectedIndex].value)">
                    <option value="0" <%if cint(configArr(25,0))=0 then Echo "selected" end if%>>关闭</option>
                    <option value="1"  <%if cint(configArr(25,0))=1 then Echo "selected" end if%>>开启</option>
                </select>
                <div class="m_et2"></div>
            </td>
        </tr>
        <tr id="p11" <%if configArr(25,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">微信商户号：</div></td>
            <td><input type="text" name="m_shid" class="input_txt" value="<%=configArr(26,0)%>" /><div class="m_et2">微信支付申请通过后会下发到邮箱</div></td>
        </tr>
        <tr id="p12" <%if configArr(25,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">微信支付秘钥：</div></td>
            <td><input type="password" name="m_shkey" class="input_txt" value="<%=configArr(27,0)%>" /><div class="m_et2">登录微信支付管理平台账号设置->API安全中设置</div></td>
        </tr>
        <tr>
            <td width="110" height="46"><div class="td_left">支付宝支付：</div></td>
            <td>
                <select name="m_pay" class="input_select" onChange="selectPay(this.options[this.selectedIndex].value)">
                    <option value="0" <%if cint(configArr(8,0))=0 then Echo "selected" end if%>>关闭</option>
                    <option value="1"  <%if cint(configArr(8,0))=1 then Echo "selected" end if%>>开启</option>
                </select>
                <div class="m_et2"></div>
            </td>
        </tr>
        <tr id="p1" <%if configArr(8,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">支付宝PID：</div></td>
            <td><input type="text" name="aliPid" class="input_txt" value="<%=configArr(9,0)%>" /><div class="m_et2">在支付宝申请商家服务通过后获取的PID</div></td>
        </tr>
        <tr id="p2" <%if configArr(8,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">支付宝Key：</div></td>
            <td><input type="password" name="aliKey" class="input_txt" value="<%=configArr(10,0)%>" /><div class="m_et2">在支付宝申请商家服务通过后获取的Key</div></td>
        </tr>
        <tr id="p3" <%if configArr(8,0)=0 then%>style="display:none"<%end if%>>
            <td height="46"><div class="td_left">支付宝账号：</div></td>
            <td><input type="text" name="aliZh" class="input_txt" value="<%=configArr(11,0)%>" /><div class="m_et2">收款方的支付宝账号</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">货到付款：</div></td>
            <td>
                <select name="m_hdfk" class="input_select">
                    <option value="0" <%if cint(configArr(28,0))=0 then Echo "selected" end if%>>关闭</option>
                    <option value="1"  <%if cint(configArr(28,0))=1 then Echo "selected" end if%>>开启</option>
                </select>
                <div class="m_et2"></div>
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
<script language="javascript" charset="utf-8">
function selectPay(value){
	if (value=="0"){$('#p1').hide();$('#p2').hide();$('#p3').hide();}
	if (value=="1"){$('#p1').show();$('#p2').show();$('#p3').show();}
}
function selectWxPay(value){
	if (value=="0"){$('#p11').hide();$('#p12').hide();}
	if (value=="1"){$('#p11').show();$('#p12').show();}
}
</script>
</body>
</html>
<%
End Sub

Sub editSite
    dim m_tcbl : m_tcbl=getForm("m_tcbl","post")
	if isnul(m_tcbl) then
	    alert "提成比例为空！","",1
	else
	    if instr(m_tcbl,":")>0 then
		    dim tcarr : tcarr=split(m_tcbl,":")
			if ubound(tcarr)<>2 then
			    alert "提成比例填写错误！","",1
			else
			    if cint(cdbl(tcarr(0))+cdbl(tcarr(1))+cdbl(tcarr(2)))<>1 then alert "提成比例填写错误！","",1
			end if
		else
		    alert "提成比例填写错误！","",1
		end if
	end if
	dim m_zdtxe : m_zdtxe=getForm("m_zdtxe","post") : if not isNum(m_zdtxe) then alert "最低提现额填写错误！","",1
	dim configStr
	configStr="<%"&vbcrlf& _
	"errMode="""&getForm("errMode","post")&""""&vbcrlf& _
	"siteName="""&getForm("siteName","post")&""""&vbcrlf& _
	"siteUrl="""&getForm("siteUrl","post")&""""&vbcrlf& _
	"sitePath="""&getForm("sitePath","post")&""""&vbcrlf& _
	"siteLogo="""&getForm("m_pic","post")&""""&vbcrlf& _
	"ewmLocation="""&getForm("m_ewmlocation","post")&""""&vbcrlf& _
	"slidePic="""&getForm("m_slide","post")&""""&vbcrlf& _
	"tcPercent="""&m_tcbl&""""&vbcrlf& _
	"tcAmount="""&m_zdtxe&""""&vbcrlf& _
	"databaseType="""&getForm("databaseType","post")&""""&vbcrlf& _
	"databaseServer="""&getForm("databaseServer","post")&""""&vbcrlf& _
	"databaseName="""&getForm("databaseName","post")&""""&vbcrlf& _
	"databaseUser="""&getForm("databaseUser","post")&""""&vbcrlf& _
	"databasePwd="""&getForm("databasePwd","post")&""""&vbcrlf& _
	"accessFilePath="""&getForm("accessFilePath","post")&""""&vbcrlf& _
	"tablePre="""&tablePre&""""&vbcrlf&"%"&">"
	myfile.createTextFile configStr,"../inc/config.asp",""
	alert "配置修改成功","admin_config.asp",""
End Sub

Sub editUpload
    dim updateSql
    dim m_uptype:m_uptype=getForm("upType","post") : if isnul(m_uptype) then alert "文件类型不能为空","",1
	dim m_upsize:m_upsize=getForm("upSize","post") : if not isnum(m_upsize) then alert "文件大小必须为数字","",1
	dim m_pictype:m_pictype=getForm("pictype","post")
	dim m_picsize:m_picsize=getForm("picSize","post")
	dim m_marktype:m_marktype=getForm("marktype","post")
	dim m_markLocal:m_markLocal=getForm("markLocal","post")
	dim m_markPic:m_markPic=getForm("markPic","post")
	updateSql = "update {pre}Config set upType='"&m_uptype&"',upSize='"&m_upsize&"',isNarrow="&m_pictype&",picSize='"&m_picsize&"',isMark="&m_marktype&",markLocal="&m_markLocal&",markPic='"&m_markPic&"'"
	conn.db updateSql,"0"
	alert "修改成功","admin_config.asp?action=upload",""
End Sub

Sub editOther
    dim updateSql
	dim m_pay:m_pay=getForm("m_pay","post")
    dim m_aliPid:m_aliPid=getForm("aliPid","post")
	dim m_aliKey:m_aliKey=getForm("aliKey","post")
	dim m_aliZh:m_aliZh=getForm("aliZh","post")
	
	dim m_wxpay:m_wxpay=getForm("m_wxpay","post")
	dim m_shid:m_shid=getForm("m_shid","post")
	dim m_shkey:m_shkey=getForm("m_shkey","post")
	
	dim m_hdfk:m_hdfk=getForm("m_hdfk","post")
	
	updateSql = "update {pre}Config set aliPid='"&m_aliPid&"',aliKey='"&m_aliKey&"',aliZh='"&m_aliZh&"',isPay="&m_pay&",WxPay="&m_wxpay&",ShID='"&m_shid&"',ShKey='"&m_shkey&"',IsHdfk="&m_hdfk&""
	conn.db updateSql,"0"
	alert "修改成功","admin_config.asp?action=other",""
End Sub
%>