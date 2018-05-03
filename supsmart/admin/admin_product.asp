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
	case "show" : showInfo id
	case "hide" : hideInfo id
	case else : main
End Select 
terminateAllObjects

Sub main
	dim i,orderStr,whereStr,sqlStr,rsObj,allPage,allRecordset,numPerPage
	numPerPage= 20
	whereStr=" where 1=1"
	orderStr= " order by id desc"
	keyword = URLDecode(getForm("keyword", "both")) : if not isNul(keyword) then whereStr = whereStr&" and Title like '%"&keyword&"%'"
	vtype = getForm("type", "both") : if not isNul(vtype) then whereStr=whereStr&" and ShopID="&vtype&""
	page = getint(getForm("page", "get"),1)
	if page=0 then page=1
	sqlStr="select * from {pre}Product"&whereStr&orderStr
	set rsObj = conn.db(sqlStr,"1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>商品管理</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：商品管理 > 商品列表</div>
</div>
<div class="m_t2">
    <div class="m_t22"><a href="admin_product.asp">商品列表</a></div>
    <div class="m_t23"><a href="admin_product.asp?action=add">添加商品</a></div>
    <div class="m_t24"><a href="admin_category.asp">商品类别</a></div>
    <div class="m_t25"><a href="admin_category.asp?action=add">添加类别</a></div>
</div>
<form method="post" name="listform" style="display:inline;">
<div class="m_ctr">
    <div class="m_title">
        <div class="m_c5">选择</div>
        <div class="m_c5">编号</div>
        <div class="m_c20">名称</div>
        <div class="m_c15">店铺</div>
        <div class="m_c8">价格[提成]</div>
        <div class="m_c8">库存</div>
        <div class="m_c8">人气</div>
        <div class="m_c8">类别</div>
        <div class="m_c8">时间</div>
        <div class="m_c12" style="border:0;">&nbsp;&nbsp;操作</div>
    </div>
    <%
	if allRecordset=0 then
		if not isNul(keyword) then Echo "<div class='m_cell1' style='text-align:center;'>关键字 <font color=red>"""&keyword&"""</font> 没有记录</div>" else Echo "<div class='m_cell1' style='text-align:center;'><a href='?action=add'>还没有记录，点击添加</a></div>" 
	else  
		rsObj.absolutepage = page
		if not isNul(keyword) then Echo "<div class='m_cell1'>&nbsp;&nbsp;关键字 <font color=red> "&keyword&" </font> 的记录如下</div>"
		for i = 0 to numPerPage	
			dim m_id : m_id = rsObj(0)
	%>
    <div <%if i mod 2=0 then%>class="m_cell1"<%else%>class="m_cell2"<%end if%>>
        <div class="m_c5"><input type="checkbox" name="m_id" value="<%=m_id%>" class="input_check" /></div>
        <div class="m_c5"><%=rsObj("ID")%></div>
        <div class="m_c20" style="text-align:left">&nbsp;&nbsp;
		<%
			Echo ""&left(rsObj("Title"),20)&""
			if rsObj("IsTop") then Echo " [<font color=red>顶</font>]"
		%>
        </div>
        <div class="m_c15"><%=idToShop(rsObj("ShopID"))%></div>
        <div class="m_c8"><%=rsObj("DZPrice")%><font color=red>[<%=rsObj("PTc")%>]</font></div>
        <div class="m_c8"><%=rsObj("Stock")%></div>
        <div class="m_c8"><%=rsObj("Hits")%></div>
        <div class="m_c8"><%=TName(rsObj("SortID"))%></div>
        <div class="m_c8"><%isCurrentDay(formatdatetime(rsObj("AddDate"),2))%></div>
        <div class="m_c12" style="border:0;color:#1866a4;"><a href="?action=edit&id=<%=m_id%>">编辑</a> | <a href="?action=del&id=<%=m_id%>" onClick="return confirm('确定要删除吗')">删除</a> | <%if rsObj("IsShow")=0 then%><a href="?action=show&id=<%=m_id%>"><font color='#F46B0A'>上架</font></a><%else%><a href="?action=hide&id=<%=m_id%>">下架</a><%end if%></div>
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
    <input type="text" name="keyword" class="input_select" style="margin-top:0;height:28px;" value="请输入关键词" onfocus="this.value='';" />
    <select name="type" id="type" class="input_select" style="margin-top:0;height:32px;">
        <option value="">请选择店铺</option>
        <%shopList ""%>
    </select>
    <input type="submit" name="selectBtn"  value="查 询" class="input_btn" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'"/>
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
<title>添加商品</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="../inc/image/DatePicker/WdatePicker.js"></script>
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
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：商品管理 > 添加商品</div>
</div>
<div class="m_t2">
    <div class="m_t22"><a href="admin_product.asp">商品列表</a></div>
    <div class="m_t23"><a href="admin_product.asp?action=add">添加商品</a></div>
    <div class="m_t24"><a href="admin_category.asp">商品类别</a></div>
    <div class="m_t25"><a href="admin_category.asp?action=add">添加类别</a></div>
</div>
<form action="?action=save&acttype=add" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">商品名称：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" /><div class="m_et2">请填写商品名称</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属店铺：</div></td>
            <td>
                <select name="m_shop" id="m_shop" class="input_select" onChange="selectTypelist(this.options[this.selectedIndex].value)">
                    <option value="0">请选择店铺</option>
                    <%shopList ""%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属栏目：</div></td>
            <td>
                <select name="m_type" id="m_type" class="input_select"></select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">市场价：</div></td>
            <td>
                <input type="text" name="m_yprice" class="input_txt" value="" style="width:120px;" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">微信价：</div></td>
            <td>
                <input type="text" name="m_dzprice" class="input_txt" value="" style="width:120px;" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">商品规格：</div></td>
            <td>
                <input type="text" name="m_gg" class="input_txt" value="" /><div class="m_et2">不同规格用"|"隔开。如：16G版本|32G版本</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">库存：</div></td>
            <td>
                <input type="text" name="m_num" class="input_txt" value="9999" style="width:120px;" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">商品图片：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2">可上传多张图片</div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td width="100" height="340"><div class="td_left">商品描述：</div></td>
            <td valign="top" style="padding-top:8px;">
                <textarea id="m_info" name="m_info" class="input_textarea" style="position:absolute;z-index:9;"></textarea>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">发布日期：</div></td>
            <td>
                <input type="text" name="m_date" value="<%=date()%>" class="input_txt Wdate" style="width:145px;" onClick="WdatePicker()"/><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">提成金额：</div></td>
            <td>
                <input type="text" name="m_tc" value="0" class="input_txt" style="width:80px;"/><div class="m_et2">购买此产品后推荐人可获取的总提成</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">购买积分：</div></td>
            <td>
                <input type="text" name="m_jf" value="0" class="input_txt" style="width:80px;"/><div class="m_et2">购买此产品后可获取的积分</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">阅读次数：</div></td>
            <td>
                <input type="text" name="m_hits" value="0" class="input_txt" style="width:80px;"/><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">排序：</div></td>
            <td>
                <input type="text" name="m_sequence" class="input_txt" style="width:80px;"><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">其他设置：</div></td>
            <td>
                <input type="checkbox" class="input_check" name="m_show" value="1" style="margin-top:12px;" checked="checked" /><div class="m_txt">上架</div>
                <input type="checkbox" class="input_check" name="m_top" value="1" style="margin-top:12px;" /><div class="m_txt">置顶</div>
            </td>
        </tr>
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认添加" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写商品名称');return false;}if($('#m_shop').val()==0){alert('请选择店铺');return false;}if($('#m_type').val()==0){alert('请选择分类');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
<script language="javascript">
var selObj1 = $("#m_type"); 
selObj1.append("<option value='0'>请选择栏目</option>");
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
function selectTypelist(shop) {
	$.ajax({
		type:"GET",
		url:"../inc/AjaxFun.asp?action=getType&shop="+shop,
		cache: false,
		dataType:"html",
		success:function(date){
			var selObj = $("#m_type");  
			var selOpt = $("#m_type option");  
            selOpt.remove(); 
		    selObj.append(date);
		}
	});
}
</script>
</body>
</html>
<%
	End Sub
	
	Sub editInfo
		dim id,sqlStr,rsObj
		id=clng(getForm("id","get"))
		sqlStr = "select *  from {pre}Product where ID="&id
		set rsObj = conn.db(sqlStr,"1")
		if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>编辑商品</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="../inc/image/DatePicker/WdatePicker.js"></script>
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
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：商品管理 > 编辑商品</div>
</div>
<div class="m_t2">
    <div class="m_t22"><a href="admin_product.asp">商品列表</a></div>
    <div class="m_t23"><a href="admin_product.asp?action=add">添加商品</a></div>
    <div class="m_t24"><a href="admin_category.asp">商品类别</a></div>
    <div class="m_t25"><a href="admin_category.asp?action=add">添加类别</a></div>
</div>
<form action="?action=save&acttype=edit" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">商品名称：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" value="<%=rsObj("Title")%>"/><div class="m_et2">请填写商品名称</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属店铺：</div></td>
            <td>
                <select name="m_shop" id="m_shop" class="input_select" onChange="selectTypelist(this.options[this.selectedIndex].value)">
                    <option value="0">请选择店铺</option>
                    <%shopList rsObj("ShopID")%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属栏目：</div></td>
            <td>
                <select name="m_type" id="m_type" class="input_select">
                    <option value="0">请选择栏目</option>
                    <%categoryList rsObj("ShopID"),rsObj("SortID")%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">市场价：</div></td>
            <td>
                <input type="text" name="m_yprice" class="input_txt" value="<%=rsObj("YPrice")%>" style="width:120px;" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">微信价：</div></td>
            <td>
                <input type="text" name="m_dzprice" class="input_txt" value="<%=rsObj("DZPrice")%>" style="width:120px;" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">商品规格：</div></td>
            <td>
                <input type="text" name="m_gg" class="input_txt" value="<%=rsObj("PGg")%>" /><div class="m_et2">不同规格用"|"隔开。如：16G版本|32G版本</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">库存：</div></td>
            <td>
                <input type="text" name="m_num" class="input_txt" value="<%=rsObj("Stock")%>" style="width:120px;" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">商品图片：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="<%=rsObj("PicStr")%>" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2">可上传多张图片</div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td width="100" height="340"><div class="td_left">商品描述：</div></td>
            <td valign="top" style="padding-top:8px;">
                <textarea id="m_info" name="m_info" class="input_textarea" style="position:absolute;z-index:9;"><%=rsObj("Content")%></textarea>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">发布日期：</div></td>
            <td>
                <input type="text" name="m_date" value="<%=rsObj("AddDate")%>" class="input_txt Wdate" style="width:145px;" onClick="WdatePicker()"/><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">提成金额：</div></td>
            <td>
                <input type="text" name="m_tc" value="<%=rsObj("PTc")%>" class="input_txt" style="width:80px;"/><div class="m_et2">购买此产品后推荐人可获取的总提成</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">购买积分：</div></td>
            <td>
                <input type="text" name="m_jf" value="<%=rsObj("PJf")%>" class="input_txt" style="width:80px;"/><div class="m_et2">购买此产品后可获取的积分</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">阅读次数：</div></td>
            <td>
                <input type="text" name="m_hits" value="<%=rsObj("Hits")%>" class="input_txt" style="width:80px;"/><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">排序：</div></td>
            <td>
                <input type="text" name="m_sequence" value="<%=rsObj("Sequence")%>" class="input_txt" style="width:80px;"><div class="m_et2"></div>
            </td>
        </tr>

        <tr>
            <td width="100" height="46"><div class="td_left">其他设置：</div></td>
            <td>
                <input type="checkbox" class="input_check" name="m_show" value="1" style="margin-top:12px;" <% if rsObj("isShow")=1 then %>checked<% end if %> /><div class="m_txt">上架</div>
                <input type="checkbox" class="input_check" name="m_top" value="1" style="margin-top:12px;" <% if rsObj("isTop")=1 then %>checked<% end if %> /><div class="m_txt">置顶</div>
            </td>
        </tr>
        <input type="hidden" name="m_id" value="<%=id%>">
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认编辑" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写商品名称');return false;}if($('#m_shop').val()==0){alert('请选择店铺');return false;}if($('#m_type').val()==0){alert('请选择分类');return false;}" />
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
function selectTypelist(shop) {
	$.ajax({
		type:"GET",
		url:"../inc/AjaxFun.asp?action=getType&shop="+shop,
		cache: false,
		dataType:"html",
		success:function(date){
			var selObj = $("#m_type");  
			var selOpt = $("#m_type option");  
            selOpt.remove(); 
		    selObj.append(date);
		}
	});
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
	dim m_name:m_name=getForm("m_name","post") : if isNul(m_name) then alert "请填写商品标题","",1
	dim m_type:m_type=getForm("m_type","post") : if isNul(m_type) then alert "请选择分类","",1
	dim m_shop:m_shop=getForm("m_shop","post") : if isNul(m_shop) then alert "请选择店铺","",1
	dim m_yprice:m_yprice=getForm("m_yprice","post")
	dim m_dzprice:m_dzprice=getForm("m_dzprice","post")
	dim m_num : m_num=getForm("m_num","post")
	dim m_pic:m_pic=getForm("m_pic","post")
	dim m_info:m_info=getForm("m_info","post")
	dim m_info1:m_info1=getForm("m_info1","post")
	dim m_date:m_date=getForm("m_date","post")
	dim m_hits:m_hits=getForm("m_hits","post")
	dim m_top:m_top=getForm("m_top","post") : if isNul(m_top) then m_top=0
	dim m_show:m_show=getForm("m_show","post") : if isNul(m_show) then m_show=0
	dim m_sequence:m_sequence=getForm("m_sequence","post") : if isNul(m_sequence) then m_sequence=0
	
	dim m_gg:m_gg=getForm("m_gg","post")
	dim m_tc:m_tc=getForm("m_tc","post") : if isNul(m_tc) then m_tc=0
	dim m_jf:m_jf=getForm("m_jf","post") : if isNul(m_jf) then m_jf=0
	
	select case  actType
		case "edit"
			updateSql = "SortID="&m_type&",Title='"&m_name&"',YPrice='"&m_yprice&"',DZPrice='"&m_dzprice&"',Stock="&m_num&",PicStr='"&m_pic&"',Content='"&m_info&"',ShopID="&m_shop&",IsTop="&m_top&",IsShow="&m_show&",Hits="&m_hits&",AddDate='"&m_date&"',Sequence="&m_sequence&",PGg='"&m_gg&"',PTc="&m_tc&",PJf="&m_jf&""
			updateSql = "update {pre}Product set "&updateSql&" where ID="&m_id
			conn.db updateSql,"0"
			alert "","admin_product.asp",""
		case "add" 
			insertSql = "insert into {pre}Product(SortID,Title,YPrice,DZPrice,PicStr,PicIndex,Stock,Content,ShopID,IsTop,Hits,AddDate,Sequence,PGg,PTc,PJf,IsShow) values ("&m_type&",'"&m_name&"','"&m_yprice&"','"&m_dzprice&"','"&m_pic&"',1,"&m_num&",'"&m_info&"',"&m_shop&","&m_top&","&m_hits&",'"&m_date&"',"&m_sequence&",'"&m_gg&"',"&m_tc&","&m_jf&","&m_show&")"
			conn.db  insertSql,"0" 
			confirmMsg "添加成功,是否继续添加","admin_product.asp?action=add","admin_product.asp"
	end select
End Sub

Sub delInfo(id,flag)
	dim picStr,picArr,i,rsObj,j,idarr
	set rsObj=conn.db("select OrderID,OrderStr from {pre}Order","1")
	    if not rsObj.eof then
		    do while not rsObj.eof
			    if instr(rsObj(1),"|")>0 then
				    idarr=split(rsObj(1),"|")
				    for j=1 to ubound(idarr)-1
					    if clng(split(idarr(j),"$")(0))=clng(id) then alert "请先删除订单："&rsObj(0)&"","admin_product.asp",""
					next
				else
				    if clng(split(rsObj(1),"$")(0))=clng(id) then alert "请先删除订单："&rsObj(0)&"","admin_product.asp",""
				end if
			rsObj.movenext
			loop
		end if
	rsObj.close
	set rsObj=nothing
	picStr=conn.db("select PicStr from {pre}Product where ID="&id,"0")(0)
	picArr=split(picStr,"|")
	for i=0 to ubound(picArr)-1
	    if not isNul(picArr(i)) then
			if myfile.isExistFile(PubPic&picArr(i)) then myfile.delFile PubPic&picArr(i)
			if myfile.isExistFile(PubPic&"s"&picArr(i)) then myfile.delFile PubPic&"s"&picArr(i)
		end if
	next
	conn.db "delete from {pre}Product where id="&id,"0"
	if flag then alert "","admin_product.asp",""
End Sub

Sub delAll
	dim ids,idArray,idsLen,i
	ids = replace(getForm("m_id","post")," ","")
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		delInfo idArray(i),0
	next
	alert "","admin_product.asp",""
End Sub

Sub showInfo(id)
	conn.db "update {pre}Product set isShow=1 where id="&id,"0"
	alert "","admin_product.asp",""
End Sub

Sub hideInfo(id)
	conn.db "update {pre}Product set isShow=0 where id="&id,"0"
	alert "","admin_product.asp",""
End Sub
%>