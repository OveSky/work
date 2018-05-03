<!--#include file="admin_inc.asp"-->
<%
checkPower ""

dim action : action = getForm("action", "get")
dim id : id = getForm("id","get")
dim keyword,page,vtype
Select case action
	case "add" : addInfo
	case "delall" : delAll
	case "del" : delInfo id,1
	case "edit" : editInfo
	case "save" : saveInfo
	case else : main
End Select 
terminateAllObjects

Sub main
	dim i,sqlStr,rsObj,allPage,allRecordset,numPerPage
	numPerPage= 20
	page = getint(getForm("page", "get"),1)
	if page=0 then page=1
	sqlStr = "select * from {pre}Shop order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>店铺管理</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：店铺管理 > 店铺列表</div>
</div>
<div class="m_t2">
    <div class="m_t24"><a href="admin_shop.asp">店铺列表</a></div>
    <div class="m_t25"><a href="admin_shop.asp?action=add">添加店铺</a></div>
</div>
<form method="post" name="listform" style="display:inline;">
<div class="m_ctr">
    <div class="m_title">
        <div class="m_c5">选择</div>
        <div class="m_c5">编号</div>
        <div class="m_c20">名称</div>
        <div class="m_c10">电话</div>
        <div class="m_c20">地址</div>
        <div class="m_c10">营业时间</div>
        <div class="m_c10">服务距离</div>
        <div class="m_c9">类型</div>
        <div class="m_c10" style="border:0;">&nbsp;&nbsp;操作</div>
    </div>
    <%
    if allRecordset=0 then
        Echo "<div class='m_cell1' style='text-align:center;'><a href='?action=add'>暂无数据，点击添加</a></div>"
    else  
        rsObj.absolutepage = page
        for i = 0 to numPerPage	
            dim m_id : m_id = rsObj(0)
    %>
    <div <%if i mod 2=0 then%>class="m_cell1"<%else%>class="m_cell2"<%end if%>>
        <div class="m_c5"><input type="checkbox" name="m_id" value="<%=m_id%>" class="input_check" /></div>
        <div class="m_c5"><%=rsObj(0)%></div>
        <div class="m_c20"><%=rsObj(1)%><%if rsObj("IsTop")=1 then echo "&nbsp;<font color=red>[顶]</font>"%><%if rsObj("IsPrint")=1 then echo "&nbsp;<font color=red>[印]</font>"%></div>
        <div class="m_c10"><%=rsObj(6)%></div>
        <div class="m_c20"><%=rsObj(5)%></div>
        <div class="m_c10"><%=rsObj(4)%></div>
        <div class="m_c10"><%=rsObj(9)%></div>
        <div class="m_c9"><%if rsObj(3)=0 then Echo "<font color='#F46B0A'>商城</font>" else Echo "<font color='#2a982a'>订餐</font>"%></div>
        <div class="m_c10" style="border:0;color:#1866a4;"><a href="?action=edit&id=<%=m_id%>">编辑</a> | <a href="?action=del&id=<%=m_id%>" onClick="return confirm('确定要删除吗')">删除</a></div>
    </div>
    <%
            rsObj.movenext
            if rsObj.eof then exit for
        next
        rsObj.close
        set rsObj=nothing
    end if
    %>
</div>
<div class="m_t3">
    <div class="m_t31">
        <div class="m_t311" style="border:0"><input type="checkbox" name="chkall" class="input_check" onclick="checkAll(this.checked,'m_id')" style="margin-top:6px;margin-left:0;"/><div class="f_left">&nbsp;全选</div></div>
    </div> 
    <input type="submit" class="input_btn" value="批量删除" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onclick="if(confirm('确定要删除吗')){listform.action='?action=delall';}else{return false}" />
    <div class="m_t32">
        <div class="m_t311"><a href="?page=1&type=<%=vtype%>&keyword=<%=server.urlencode(keyword)%>">首页</a></div>
        <div class="m_t311"><a href="?page=<%=(page-1)%>&type=<%=vtype%>&keyword=<%=server.urlencode(keyword)%>">上一页</a></div>
        <%=makePageNumber(page, 5, allPage, "admin","","")%>
        <div class="m_t311"><a href="?page=<%=(page+1)%>&type=<%=vtype%>&keyword=<%=server.urlencode(keyword)%>">下一页</a></div>
        <div class="m_t311" style="border:0;"><a href="?page=<%=allPage%>&type=<%=vtype%>&keyword=<%=server.urlencode(keyword)%>">尾页</a></div>
    </div>
    <div class="m_t32" style="margin-right:10px;">
        <div class="m_t311">每页 <%=numPerPage%> 条</div>
        <div class="m_t311" style="border:0;">当前 <%=Page%>/<%=allPage%> 页</div>
    </div>
</div>
</form>
</body>
</html>
<%
	End Sub
	Sub addInfo
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加店铺</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
<script type="text/javascript" charset="utf-8">
$(function(){
	UE.getEditor("m_info");
});
</script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：店铺管理 > 添加店铺</div>
</div>
<div class="m_t2">
    <div class="m_t24"><a href="admin_shop.asp">店铺列表</a></div>
    <div class="m_t25"><a href="admin_shop.asp?action=add">添加店铺</a></div>
</div>
<form action="?action=save&acttype=add" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">店铺名称：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" /><div class="m_et2">请填写店铺名称</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">店铺图片：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2">第一张为列表图片，后面为店招图片</div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">营业时间：</div></td>
            <td>
                <input type="text" name="m_hours" id="m_hours" class="input_txt" /><div class="m_et2">如：9:30-21:30</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系电话：</div></td>
            <td>
                <input type="text" name="m_tel" class="input_txt" /><div class="m_et2">请填写联系电话</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系QQ：</div></td>
            <td>
                <input type="text" name="m_qq" class="input_txt" /><div class="m_et2">请填写联系QQ</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">店铺地址：</div></td>
            <td>
                <input type="text" name="m_addr" class="input_txt" style="width:350px" /><div class="m_et2">请填写店铺地址</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">外送费：</div></td>
            <td>
                <input type="text" name="m_wsf" class="input_txt" /><div class="m_et2">如：￥2 (10元免外送费)</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">服务距离：</div></td>
            <td>
                <input type="text" name="m_fwjl" class="input_txt" /><div class="m_et2">如：3公里</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">配送区域：</div></td>
            <td>
                <input type="text" name="m_area" class="input_txt" style="width:500px" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">店铺类型：</div></td>
            <td>
                <select name="m_type" id="m_type" class="input_select">
                    <option value="0">商城</option>
                    <option value="1">订餐</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">店铺openID：</div></td>
            <td><input type="text" name="openID" class="input_txt" value="" /><div class="m_et2">用户管理中查询，用于接收订单信息</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">小票打印：</div></td>
            <td>
                <select name="m_print" class="input_select" onChange="selectPrint(this.options[this.selectedIndex].value)">
                    <option value="0">关闭</option>
                    <option value="1">开启</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr id="p1" style="display:none;">
            <td width="100" height="46"><div class="td_left">用户ID：</div></td>
            <td>
                <input type="text" name="m_partner" class="input_txt"/><div class="m_et2">云打印平台用户ID</div>
            </td>
        </tr>
        <tr id="p2" style="display:none;">
            <td width="100" height="46"><div class="td_left">apiKey：</div></td>
            <td>
                <input type="text" name="m_apikey" class="input_txt"/><div class="m_et2">云打印平台apikey</div>
            </td>
        </tr>
        <tr id="p3" style="display:none;">
            <td width="100" height="46"><div class="td_left">终端号：</div></td>
            <td>
                <input type="text" name="m_machine" class="input_txt"/><div class="m_et2">填写打印机背面终端号</div>
            </td>
        </tr>
        <tr id="p4" style="display:none;">
            <td width="100" height="46"><div class="td_left">打印机秘钥：</div></td>
            <td>
                <input type="text" name="m_mkey" class="input_txt"/><div class="m_et2">填写打印机背面秘钥</div>
            </td>
        </tr>
        <tr id="p5" style="display:none;">
            <td width="100" height="46"><div class="td_left">二维码地址：</div></td>
            <td>
                <input type="text" name="m_ewm" class="input_txt" style="width:350px;"/><div class="m_et2">填写二维码地址</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">店铺公告：</div></td>
            <td>
                <input type="text" name="m_gg" class="input_txt" style="width:500px" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="340"><div class="td_left">店铺描述：</div></td>
            <td>
                <textarea id="m_info" name="m_info" class="input_textarea"></textarea>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">其他设置：</div></td>
            <td>
                <input type="checkbox" class="input_check" name="m_top" value="1" style="margin-top:12px;" /><div class="m_txt">置顶</div>
            </td>
        </tr>
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认添加" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写店铺名称');return false;}if($('#m_hours').val().length==0){alert('请填写营业时间');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
<script language="javascript">
var editor = UE.getEditor('upload_ue');
editor.ready(function () {
	editor.setDisabled();
	editor.hide();
	editor.addListener('beforeInsertImage', function (t, arg) {
	   for(var i=0;i<arg.length;i++){
		   $("#m_pic").val($("#m_pic").val()+arg[i].src.replace("/<%=sitePath%>upload/pic/","")+"|");
	   }
	})
});
function upImage() {
   var myImage = editor.getDialog("insertimage");
   myImage.open();
}
function selectPrint(value){
	if (value=="0"){$('#p1').hide();$('#p2').hide();$('#p3').hide();$('#p4').hide();$('#p5').hide();}
	if (value=="1"){$('#p1').show();$('#p2').show();$('#p3').show();$('#p4').show();$('#p5').hide();}
}
</script>
</body>
</html>
<%
	End Sub
	
	Sub editInfo
		dim id,sqlStr,rsObj
		id=clng(getForm("id","get"))
		sqlStr = "select *  from {pre}Shop where ID="&id
		set rsObj = conn.db(sqlStr,"1")
		if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>编辑店铺</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
<script type="text/javascript" charset="utf-8">
$(function(){
	UE.getEditor("m_info");
});
</script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：店铺管理 > 编辑店铺</div>
</div>
<div class="m_t2">
    <div class="m_t24"><a href="admin_shop.asp">店铺列表</a></div>
    <div class="m_t25"><a href="admin_shop.asp?action=add">添加店铺</a></div>
</div>
<form action="?action=save&acttype=edit" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">店铺名称：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" value="<%=rsObj("Title")%>" class="input_txt" /><div class="m_et2">请填写店铺名称</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">店铺图片：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="<%=rsObj("PicStr")%>" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2">第一张为列表图片，后面为店招图片</div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">营业时间：</div></td>
            <td>
                <input type="text" name="m_hours" id="m_hours" class="input_txt" value="<%=rsObj("ShopHours")%>" /><div class="m_et2">如：9:30-21:30</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系电话：</div></td>
            <td>
                <input type="text" name="m_tel" class="input_txt" value="<%=rsObj("ShopTel")%>"/><div class="m_et2">请填写联系电话</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系QQ：</div></td>
            <td>
                <input type="text" name="m_qq" class="input_txt" value="<%=rsObj("ShopQQ")%>"/><div class="m_et2">请填写联系QQ</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">店铺地址：</div></td>
            <td>
                <input type="text" name="m_addr" class="input_txt" style="width:350px" value="<%=rsObj("ShopAddr")%>" /><div class="m_et2">请填写店铺地址</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">外送费：</div></td>
            <td>
                <input type="text" name="m_wsf" class="input_txt" value="<%=rsObj("Courier")%>"/><div class="m_et2">如：￥2 (10元免外送费)</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">服务距离：</div></td>
            <td>
                <input type="text" name="m_fwjl" class="input_txt" value="<%=rsObj("Distance")%>"/><div class="m_et2">如：3公里</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">配送区域：</div></td>
            <td>
                <input type="text" name="m_area" class="input_txt" style="width:500px" value="<%=rsObj("ShopArea")%>"/><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">店铺类型：</div></td>
            <td>
                <select name="m_type" id="m_type" class="input_select">
                    <option value="0" <%if rsObj("ShopType")=0 then%>selected="selected"<%end if%>>商城</option>
                    <option value="1" <%if rsObj("ShopType")=1 then%>selected="selected"<%end if%>>订餐</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">店铺openID：</div></td>
            <td><input type="text" name="openID" class="input_txt" value="<%=rsObj("ShopOpenID")%>" /><div class="m_et2">用户管理中查询，用于接收订单信息</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">小票打印：</div></td>
            <td>
                <select name="m_print" class="input_select" onChange="selectPrint(this.options[this.selectedIndex].value)">
                    <option value="0" <%if rsObj("isPrint")=0 then%>selected="selected"<%end if%>>关闭</option>
                    <option value="1" <%if rsObj("isPrint")=1 then%>selected="selected"<%end if%>>开启</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr id="p1" <%if rsObj("isPrint")=0 then%>style="display:none;"<%end if%>>
            <td width="100" height="46"><div class="td_left">用户ID：</div></td>
            <td>
                <input type="text" name="m_partner" class="input_txt" value="<%=rsObj("P_Partner")%>"/><div class="m_et2">云打印平台用户ID</div>
            </td>
        </tr>
        <tr id="p2" <%if rsObj("isPrint")=0 then%>style="display:none;"<%end if%>>
            <td width="100" height="46"><div class="td_left">apiKey：</div></td>
            <td>
                <input type="text" name="m_apikey" class="input_txt" value="<%=rsObj("P_Apikey")%>"/><div class="m_et2">云打印平台apikey</div>
            </td>
        </tr>
        <tr id="p3" <%if rsObj("isPrint")=0 then%>style="display:none;"<%end if%>>
            <td width="100" height="46"><div class="td_left">终端号：</div></td>
            <td>
                <input type="text" name="m_machine" class="input_txt" value="<%=rsObj("P_Machine")%>"/><div class="m_et2">填写打印机背面终端号</div>
            </td>
        </tr>
        <tr id="p4" <%if rsObj("isPrint")=0 then%>style="display:none;"<%end if%>>
            <td width="100" height="46"><div class="td_left">打印机秘钥：</div></td>
            <td>
                <input type="text" name="m_mkey" class="input_txt" value="<%=rsObj("P_MKey")%>"/><div class="m_et2">填写打印机背面秘钥</div>
            </td>
        </tr>
        <tr id="p5" <%if rsObj("isPrint")=0 then%>style="display:none;"<%end if%>>
            <td width="100" height="46"><div class="td_left">二维码地址：</div></td>
            <td>
                <input type="text" name="m_ewm" class="input_txt" value="<%=rsObj("P_Ewm")%>" style="width:350px;"/><div class="m_et2">填写二维码地址</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">店铺公告：</div></td>
            <td>
                <input type="text" name="m_gg" class="input_txt" value="<%=rsObj("ShopGG")%>" style="width:500px" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="340"><div class="td_left">店铺描述：</div></td>
            <td>
                <textarea id="m_info" name="m_info" class="input_textarea"><%=rsObj("ShopPost")%></textarea>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">其他设置：</div></td>
            <td>
                <input type="checkbox" class="input_check" name="m_top" value="1" style="margin-top:12px;" <% if rsObj("isTop")=1 then %>checked<% end if %> /><div class="m_txt">置顶</div>
            </td>
        </tr>
        <input type="hidden" name="m_id" value="<%=id%>">
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认编辑" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写店铺名称');return false;}if($('#m_hours').val().length==0){alert('请填写营业时间');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
<script language="javascript">
var editor = UE.getEditor('upload_ue');
editor.ready(function () {
	editor.setDisabled();
	editor.hide();
	editor.addListener('beforeInsertImage', function (t, arg) {
	   for(var i=0;i<arg.length;i++){
		   $("#m_pic").val($("#m_pic").val()+arg[i].src.replace("/<%=sitePath%>upload/pic/","")+"|");
	   }
	})
});
function upImage() {
   var myImage = editor.getDialog("insertimage");
   myImage.open();
}
function selectPrint(value){
	if (value=="0"){$('#p1').hide();$('#p2').hide();$('#p3').hide();$('#p4').hide();$('#p5').hide();}
	if (value=="1"){$('#p1').show();$('#p2').show();$('#p3').show();$('#p4').show();$('#p5').show();}
}
</script>
</body>
</html>
<%
End Sub

Sub saveInfo
	dim actType : actType = getForm("acttype","get")
	if actType="edit" then dim m_id:m_id=clng(getForm("m_id","post"))
	dim updateSql,insertSql,rsObj
	dim m_name:m_name=getForm("m_name","post") : if isNul(m_name) then alert "请填写店铺名称","",1
	dim m_pic:m_pic=getForm("m_pic","post")
	dim m_hours : m_hours=getForm("m_hours","post") : if isNul(m_hours) then alert "请填写营业时间","",1
	dim m_tel : m_tel=getForm("m_tel","post") 
	dim m_qq : m_qq=getForm("m_qq","post")  
	dim m_addr : m_addr=getForm("m_addr","post") 
	dim m_wsf : m_wsf=getForm("m_wsf","post") 
	dim m_fwjl : m_fwjl=getForm("m_fwjl","post") 
	dim m_area : m_area=getForm("m_area","post") 
	dim m_type : m_type=getForm("m_type","post") 
	dim m_print : m_print=getForm("m_print","post") 
	dim m_partner : m_partner=getForm("m_partner","post") 
	dim m_apikey : m_apikey=getForm("m_apikey","post") 
	dim m_machine : m_machine=getForm("m_machine","post") 
	dim m_mkey : m_mkey=getForm("m_mkey","post") 
	dim m_openid : m_openid=getForm("openID","post") 
	dim m_ewm : m_ewm=getForm("m_ewm","post")
	if m_print=1 then
	    if isNul(m_partner) or isNul(m_apikey) or isNul(m_machine) or isNul(m_mkey) then alert "请配置好小票机参数","",1
	end if
	dim m_gg : m_gg=getForm("m_gg","post") 
	dim m_info : m_info=getForm("m_info","post")
	dim m_top:m_top=getForm("m_top","post") : if isNul(m_top) then m_top=0
	select case  actType
		case "edit"
			updateSql = "Title='"&m_name&"',PicStr='"&m_pic&"',ShopType="&m_type&",ShopHours='"&m_hours&"',ShopAddr='"&m_addr&"',ShopTel='"&m_tel&"',ShopQQ='"&m_qq&"',Courier='"&m_wsf&"',Distance='"&m_fwjl&"',ShopArea='"&m_area&"',ShopPost='"&m_info&"',isPrint="&m_print&",P_Partner='"&m_partner&"',P_Apikey='"&m_apikey&"',P_Machine='"&m_machine&"',P_MKey='"&m_mkey&"',IsTop="&m_top&",ShopGG='"&m_gg&"',ShopOpenID='"&m_openid&"',P_Ewm='"&m_ewm&"'"
			updateSql = "update {pre}Shop set "&updateSql&" where ID="&m_id
			conn.db updateSql,"0"
			alert "","admin_shop.asp",""
		case "add" 
			insertSql = "insert into {pre}Shop(Title,PicStr,ShopType,ShopHours,ShopAddr,ShopTel,ShopQQ,Courier,Distance,ShopArea,ShopPost,isPrint,P_Partner,P_Apikey,P_Machine,P_MKey,IsTop,ShopGG,ShopOpenID,P_Ewm) values ('"&m_name&"','"&m_pic&"',"&m_type&",'"&m_hours&"','"&m_addr&"','"&m_tel&"','"&m_qq&"','"&m_wsf&"','"&m_fwjl&"','"&m_area&"','"&m_info&"',"&m_print&",'"&m_partner&"','"&m_apikey&"','"&m_machine&"','"&m_mkey&"',"&m_top&",'"&m_gg&"','"&m_openid&"','"&m_ewm&"')"
			conn.db  insertSql,"0" 
			confirmMsg "添加成功,是否继续添加","admin_shop.asp?action=add","admin_shop.asp"
	end select
End Sub

Sub delInfo(id,flag)
	dim picStr,picArr,i,rsObj,j,idarr
	conn.db "delete from {pre}Shop where id="&id,"0"
	if flag then alert "","admin_shop.asp",""
End Sub

Sub delAll
	dim ids,idArray,idsLen,i
	ids = replace(getForm("m_id","post")," ","")
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		delInfo idArray(i),0
	next
	alert "","admin_shop.asp",""
End Sub
%>
