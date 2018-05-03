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
	dim i,sqlStr,rsObj,allPage,allRecordset,numPerPage,whereStr
	numPerPage= 20
	vtype = getForm("type", "both") : if not isNul(vtype) then whereStr="where ShopID="&vtype&""
	page = getint(getForm("page", "get"),1)
	if page=0 then page=1
	sqlStr = "select * from {pre}Category "&whereStr&" order by ShopID,C_Sequence"
	set rsObj = conn.db(sqlStr,"1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>类别管理</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：商品管理 > 商品类别</div>
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
        <div class="m_c20">类别名称</div>
        <div class="m_c20">类别描述</div>
        <div class="m_c20">所属店铺</div>
        <div class="m_c10">栏目图片</div>
        <div class="m_c9">排序</div>
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
        <div class="m_c5"><%=rsObj("ID")%></div>
        <div class="m_c20"><%=rsObj("C_Name")%></div>
        <div class="m_c20"><%=rsObj("C_Info")%></div>
        <div class="m_c20"><%=idToShop(rsObj("ShopID"))%></div>
        <div class="m_c10"><%if isnul(rsObj("C_Pic")) then%><img src="images/no.gif" /><%else%><img src="images/yes.gif" /><%end if%></div>
        <div class="m_c9"><%=rsObj("C_Sequence")%></div>
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
<title>添加类别</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：商品管理 > 添加类别</div>
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
            <td width="100" height="46"><div class="td_left">类别名称：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" /><div class="m_et2">请填写类别名称</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="98"><div class="td_left">类别描述：</div></td>
            <td>
                <textarea name="m_des" cols="50" rows="4" class="input_textarea1"></textarea><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">栏目图片：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2"></div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">类别排序：</div></td>
            <td>
                <input type="text" name="m_px" id="m_px" class="input_txt" style="width:80px;" value="1" /><div class="m_et2">请填写整数</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属店铺：</div></td>
            <td>
                <select name="m_type" id="m_type" class="input_select">
                    <option value="0">请选择店铺</option>
                    <%shopList ""%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认添加" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写类别名称');return false;}if($('#m_type').val().length==0){alert('请选择店铺');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
</body>
</html>
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
</script>
<%
End Sub
	
Sub editInfo
	dim id,sqlStr,rsObj
	id=clng(getForm("id","get"))
	sqlStr = "select *  from {pre}Category where ID="&id
	set rsObj = conn.db(sqlStr,"1")
	if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>编辑类别</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="ueditor/ueditor.all.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：商品管理 > 编辑类别</div>
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
            <td width="100" height="46"><div class="td_left">类别名称：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" value="<%=rsObj("C_Name")%>"/><div class="m_et2">请填写类别名称</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="98"><div class="td_left">类别描述：</div></td>
            <td>
                <textarea name="m_des" cols="50" rows="4" class="input_textarea1"><%=codeTextarea(rsObj("C_Info"),"de")%></textarea><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">栏目图片：</div></td>
            <td>
                <input type="text" name="m_pic" id="m_pic" class="input_txt" value="<%=rsObj("C_Pic")%>" />
                <input type="button" value="上传" class="input_up" onclick="upImage();" /><div class="m_et2"></div>
                <span style="display:none;"><script type="text/plain" id="upload_ue"></script></span>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">类别排序：</div></td>
            <td>
                <input type="text" name="m_px" id="m_px" class="input_txt" style="width:80px;" value="<%=rsObj("C_Sequence")%>" /><div class="m_et2">请填写整数</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属店铺：</div></td>
            <td>
                <select name="m_type" id="m_type" class="input_select">
                    <option value="0">请选择店铺</option>
                    <%shopList rsObj("ShopID")%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认修改" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写类别名称');return false;}if($('#m_type').val().length==0){alert('请选择店铺');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
    <input type="hidden" name="m_id" value="<%=id%>">
</form>
</body>
</html>
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
</script>
<%
End Sub

Sub delInfo(id,flag)
	conn.db "delete from {pre}category where id="&id,"0" 
	if flag then alert "","admin_category.asp",""
End Sub

Sub delAll
	dim ids,idArray,idsLen,i
	ids = replace(getForm("m_id","post")," ","")
	idArray=split(ids,",") : idsLen=ubound(idArray)
	for i=0 to idsLen
		delInfo idArray(i),0
	next 
	alert "","admin_category.asp",""
End Sub

Sub saveInfo
    dim actType : actType = getForm("acttype","get")
	dim updateSql,insertSql
	dim m_name:m_name=getForm("m_name","post") : if isNul(m_name) then alert "请填写类别名称","",1
	dim m_des:m_des=codeTextarea(getForm("m_des","post"),"en")
	dim m_px:m_px=getForm("m_px","post")
	dim m_type:m_type=getForm("m_type","post") : if m_type=0 then alert "请选择店铺","",1
	dim m_pic:m_pic=getForm("m_pic","post")
	select case  actType
		case "edit"
			dim m_id:m_id=clng(getForm("m_id","post"))
			updateSql = "C_Name='"&m_name&"',C_Sequence="&m_px&",C_Info='"&m_des&"',ShopID="&m_type&",C_Pic='"&m_pic&"'"
			updateSql = "update {pre}category set "&updateSql&" where ID="&m_id
			conn.db  updateSql,"0"
			alert "","admin_category.asp",""
		case "add"
			insertSql = "insert into {pre}category(C_Name,C_Sequence,C_Info,ShopID,C_Pic) values ('"&m_name&"',"&m_px&",'"&m_des&"',"&m_type&",'"&m_pic&"')"
			conn.db insertSql,"0" 
			confirmMsg "添加成功,是否继续添加","admin_category.asp?action=add","admin_category.asp"
	end select
End Sub
%>
