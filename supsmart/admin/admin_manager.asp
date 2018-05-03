<!--#include file="admin_inc.asp"-->
<%
checkPower ""

dim action : action = getForm("action", "get")
dim keyword,page,vtype
Select case action
	case "add" : addManager
	case "delall" : delAll
	case "del" : delManager
	case "edit" : editManager
	case "save" : saveManager
	case else : main
End Select 
terminateAllObjects

Sub main
	dim i,sqlStr,rsObj,allPage,allRecordset,numPerPage
	numPerPage= 20
	page = getint(getForm("page", "get"),1)
	if page=0 then page=1
	sqlStr = "select ID,UserName,LastLoginTime,LastLoginIP,RoleID,Working,ShopID from {pre}Manager order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>管理员管理</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：系统管理 > 管理员列表</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_config.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_config.asp?action=upload">上传设置</a></div>
    <div class="m_t23"><a href="admin_config.asp?action=other">付款设置</a></div>
    <div class="m_t24"><a href="admin_manager.asp">管理员列表</a></div>
    <div class="m_t25"><a href="admin_manager.asp?action=add">添加管理员</a></div>
</div>
<form method="post" name="listform" style="display:inline;">
<div class="m_ctr">
    <div class="m_title">
        <div class="m_c5">选择</div>
        <div class="m_c5">编号</div>
        <div class="m_c10">用户名</div>
        <div class="m_c15">所属角色</div>
        <div class="m_c15">所属店铺</div>
        <div class="m_c15">最近登录时间</div>
        <div class="m_c15">最近登录IP</div>
        <div class="m_c9">用户状态</div>
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
        <div class="m_c10"><%=rsObj(1)%></div>
        <div class="m_c15"><%if rsObj(4)=0 then echo "<font color='#F46B0A'>超级管理员</font>" else echo "<font color='#2a982a'>店铺管理员</font>"%></div>
        <div class="m_c15"><%if rsObj(4)=0 then echo "所有店铺" else echo idToShop(rsObj(6))%></div>
        <div class="m_c15"><%=rsObj(2)%></div>
        <div class="m_c15"><%=rsObj(3)%></div>
        <div class="m_c9"><%if rsObj(5)=0 then Echo "<font color='#F46B0A'>锁定</font>" else Echo "<font color='#2a982a'>激活</font>"%></div>
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
	Sub addManager
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加管理员</title>
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：系统管理 > 添加管理员</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_config.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_config.asp?action=upload">上传设置</a></div>
    <div class="m_t23"><a href="admin_config.asp?action=other">付款设置</a></div>
    <div class="m_t24"><a href="admin_manager.asp">管理员列表</a></div>
    <div class="m_t25"><a href="admin_manager.asp?action=add">添加管理员</a></div>
</div>
<form action="?action=save&acttype=add" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">用户名：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" /><div class="m_et2">请填写用户名称</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">密码：</div></td>
            <td><input type="password" name="m_pwd" id="m_pwd" class="input_txt" /><div class="m_et2">请填写用户密码</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">确认密码：</div></td>
            <td><input type="password" name="m_vpwd" class="input_txt" /><div class="m_et2">请填写确认密码</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属角色：</div></td>
            <td>
                <select name="m_role" id="m_role" class="input_select" onChange="selectShop(this.options[this.selectedIndex].value)">
                    <option value="0">超级管理员</option>
                    <option value="1">店铺管理员</option>
                </select><div class="m_et2">选择管理员角色</div>
            </td>
        </tr>
        <tr id="shop" style="display:none;">
            <td height="46"><div class="td_left">所属店铺：</div></td>
            <td>
                <select name="m_shop" id="m_shop" class="input_select" style="width:150px;">
                    <option value="0">选择所属店铺</option>
                    <%shopList ""%>
                </select><div class="m_et2">选择所属店铺</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">用户状态：</div></td>
            <td>
                <input type="radio" name="m_show" value="1" checked="checked" class="input_radio" /><div class="m_txt">激活</div>
                <input type="radio" name="m_show" value="0" class="input_radio" /><div class="m_txt">锁定</div>
            </td>
        </tr>

        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认添加" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写用户名');return false;}if($('#m_pwd').val().length==0){alert('请填写用户密码');return false;}if($('#m_role').val()==1 && $('#m_shop').val()==0){alert('请选择店铺');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
<script language="javascript">
function selectShop(value){
	if (value=="0"){$('#shop').hide();}
	if (value=="1"){$('#shop').show();}
}
</script>
</body>
</html>
<%
	End Sub
	
	Sub editManager
		dim id,sqlStr,rsObj
		id=clng(getForm("id","get"))
		sqlStr = "select *  from {pre}Manager where ID="&id
		set rsObj = conn.db(sqlStr,"1")
		if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//Dtd XHTML 1.0 transitional//EN" "http://www.w3.org/tr/xhtml1/Dtd/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>编辑管理员</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：系统管理 > 编辑管理员</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_config.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_config.asp?action=upload">上传设置</a></div>
    <div class="m_t23"><a href="admin_config.asp?action=other">付款设置</a></div>
    <div class="m_t24"><a href="admin_manager.asp">管理员列表</a></div>
    <div class="m_t25"><a href="admin_manager.asp?action=add">添加管理员</a></div>
</div>
<form action="?action=save&acttype=edit" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">用户名：</div></td>
            <td>
                <input type="text" name="m_name" id="m_name" class="input_txt" value="<%=rsObj("UserName")%>"/><div class="m_et2">请填写用户名称</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">密码：</div></td>
            <td><input type="password" name="m_pwd" id="m_pwd" class="input_txt" /><div class="m_et2">请填写用户密码,不修改不填写</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">确认密码：</div></td>
            <td><input type="password" name="m_vpwd" class="input_txt" /><div class="m_et2">请填写确认密码,不修改不填写</div></td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">所属角色：</div></td>
            <td>
                <select name="m_role" id="m_role" class="input_select" onChange="selectShop(this.options[this.selectedIndex].value)">
                    <option value="0" <%if rsObj("RoleID")=0 then%>selected="selected"<%end if%>>超级管理员</option>
                    <option value="1" <%if rsObj("RoleID")=1 then%>selected="selected"<%end if%>>店铺管理员</option>
                </select><div class="m_et2">选择管理员角色</div>
            </td>
        </tr>
        <tr id="shop" <%if rsObj("RoleID")=0 then%>style="display:none;"<%end if%>>
            <td height="46"><div class="td_left">所属店铺：</div></td>
            <td>
                <select name="m_shop" id="m_shop" class="input_select" style="width:150px;">
                    <option value="0">选择所属店铺</option>
                    <%shopList rsObj("ShopID")%>
                </select><div class="m_et2">选择所属店铺</div>
            </td>
        </tr>
        <tr>
            <td height="46"><div class="td_left">用户状态：</div></td>
            <td>
                <input type="radio" name="m_show" value="1" <%if rsObj("Working")=1 then%>checked="checked"<%end if%> class="input_radio" /><div class="m_txt">激活</div>
                <input type="radio" name="m_show" value="0" <%if rsObj("Working")=0 then%>checked="checked"<%end if%> class="input_radio" /><div class="m_txt">锁定</div>
            </td>
        </tr>
        <input type="hidden" name="m_id" value="<%=id%>">
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认修改" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#m_name').val().length==0){alert('请填写用户名');return false;}if($('#m_role').val()==1 && $('#m_shop').val()==0){alert('请选择店铺');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
<script language="javascript">
function selectShop(value){
	if (value=="0"){$('#shop').hide();}
	if (value=="1"){$('#shop').show();}
}
</script>
</body>
</html>
<%
End Sub

Sub saveManager
	dim actType : actType = getForm("acttype","get")
	dim updateSql,insertSql,num
	dim m_name:m_name=getForm("m_name","post") : if isNul(m_name) then alert "请填写用户名","",1
	dim m_pwd:m_pwd=getForm("m_pwd","post")
	dim m_vpwd:m_vpwd=getForm("m_vpwd","post")
	dim m_role:m_role=getForm("m_role","post")
	dim m_show:m_show=getForm("m_show","post")
	dim m_shop:m_shop=getForm("m_shop","post")
	select case actType
		case "edit"
			dim m_id:m_id=clng(getForm("m_id","post"))
			if m_pwd<>m_vpwd then alert "两次密码不同","",1
			if (isNul(m_pwd) and isNul(m_vpwd)) then
			    updateSql = "UserName='"&m_name&"',RoleID="&m_role&",Working="&m_show&",ShopID="&m_shop&""
			else
			    updateSql = "UserName='"&m_name&"',[Password]='"&md5(m_pwd)&"',RoleID="&m_role&",Working="&m_show&",ShopID="&m_shop&""
			end if
			updateSql = "update {pre}Manager set "&updateSql&" where ID="&m_id
			conn.db  updateSql,"0"
			alert "","admin_manager.asp",""
		case "add"
		    num = conn.db("select count(*) from {pre}Manager where UserName='"&m_name&"'","0")(0)
	        if num>0 then alert "已经存在此用户，请更换名称","",1
		    if (isNul(m_pwd) or isNul(m_vpwd)) then alert "请先填写密码及确认密码","",1
		    if m_pwd<>m_vpwd then alert "两次密码不同","",1
			insertSql = "insert into {pre}Manager (UserName,[Password],RoleID,Working,ShopID) values ('"&m_name&"','"&md5(m_pwd)&"',"&m_role&","&m_show&","&m_shop&")"
			conn.db insertSql,"0" 
			confirmMsg "添加成功,是否继续添加","admin_manager.asp?action=add","admin_manager.asp"
	end select
End Sub

Sub delmanager
	dim UserName,id
	id=getForm("id","get")
	UserName = conn.db("select UserName from {pre}Manager where ID="&id,"0")(0)
	if UserName=readCookie("UserName") then 
		alert "不能删除自己","admin_manager.asp?id="&id,""
	else
		conn.db "delete from {pre}Manager where ID="&id,"0" 
		alert "","admin_manager.asp",""
	end if
End Sub

Sub delAll
	dim ids,idsArray,idsArraylen,i,UserName
	ids=replace(getForm("m_id","post")," ","")
	idsArray=split(ids,",") : idsArraylen=ubound(idsArray)
	for i=0 to idsArrayLen
		UserName = conn.db("select UserName from {pre}Manager where ID="&idsArray(i),"0")(0)
		if UserName<>readCookie("UserName") then conn.db "delete from {pre}Manager where ID="&idsArray(i),"0" 
	next
	alert "","admin_manager.asp",""
End Sub
%>
