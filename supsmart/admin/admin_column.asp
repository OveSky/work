<!--#include file="admin_inc.asp"-->
<%
checkPower ""

dim action : action = getForm("action", "get")
Select  case action
	case "del" : delColumnType
	case "delall" : delAll
	case "edit" : editColumnType
	case "add" : addColumnType
	case "save" : saveColumnType
	case "pubnav" : postmenu
	case else : main
End Select
terminateAllObjects

Sub main
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>自定义菜单管理</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：公众号设置 > 自定义菜单</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_wxconfig.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_column.asp">自定义菜单</a></div>
</div>
<form method="post" name="listform" style="display:inline;">
<div class="m_ctr">
    <div class="m_title">
        <div class="m_c5">选择</div>
        <div class="m_c5">编号</div>
        <div class="m_c25">名称</div>
        <div class="m_c40">类型</div>
        <div class="m_c10">排序</div>
        <div class="m_c14" style="border:0;">&nbsp;&nbsp;操作</div>
    </div>
    <% typeList 0,0 %>
</div>
<div class="m_t3">
    <div class="m_t31">
        <div class="m_t311" style="border:0"><input type="checkbox" name="chkall" class="input_check" onclick="checkAll(this.checked,'m_id')" style="margin-top:6px;margin-left:0;"/><div class="f_left">&nbsp;全选</div></div>
    </div> 
    <input type="submit" class="input_btn" value="批量删除" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onclick="if(confirm('确定要删除吗')){listform.action='?action=delall';}else{return false}" />
    <input type="button" value="添加菜单" class="input_btn" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onclick="location.href='?action=add';"/>
    <input type="button" value="发布菜单" class="input_btn" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onclick="if(confirm('确定要发布吗')){location.href='?action=pubnav';}else{return false}"/>
</div>
</form>
</body>
</html>
<%
End Sub

Sub addColumnType
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>添加菜单</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：公众号设置 > 添加菜单</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_wxconfig.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_column.asp">自定义菜单</a></div>
</div>
<form method="post" action="?action=save&acttype=add"> 
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">菜单名称：</div></td>
            <td>
                <input type="text" name="NavName" id="NavName" class="input_txt" /><div class="m_et2">请填写菜单名称</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">选择菜单：</div></td>
            <td>
                <select name="ParentID" class="input_select" />
                    <option value="0">顶级菜单</option>
                    <% NavList ""%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">链接地址：</div></td>
            <td>
                <select name="NavType" class="input_select" onchange="check_navnature(this.options[this.selectedIndex].value)" />
                    <option value="0">总店</option>
                    <%shopList1 ""%>
                    <option value="-3">会员中心</option>
                    <option value="-1">推广码</option>
                    <option value="-2">其他</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr id="t2" style="display:none;">
            <td width="100" height="46"><div class="td_left">其他地址：</div></td>
            <td>
                <input type="text" name="NavUrl" class="input_txt"><div class="m_et2">点击后将跳转到此地址</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">排序：</div></td>
            <td>
                <input type="text" name="Sequence" class="input_txt" style="width:80px;"><div class="m_et2"></div>
            </td>
        </tr>

        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认添加" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#NavName').val().length==0){alert('请填写菜单名称');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
</form>
<script language="javascript" charset="utf-8">
function check_navnature(value){
	if (value==-2){
		$("#t2").show();
	}
	else{
		$("#t2").hide();
	}
}
</script>
</body>
</html>
<%	
End Sub

Sub editColumnType
dim id,sqlStr,rsObj
	id=clng(getForm("id","get"))
	sqlStr = "select *  from {pre}Navigation where ID="&id
	set rsObj = conn.db(sqlStr,"1")
	if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>编辑菜单</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：公众号设置 > 编辑菜单</div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_wxconfig.asp">基本设置</a></div>
    <div class="m_t22"><a href="admin_column.asp">自定义菜单</a></div>
</div>
<form method="post" action="?action=save&acttype=edit">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">菜单名称：</div></td>
            <td>
                <input type="text" name="NavName" id="NavName" value="<%=rsObj("NavName")%>" class="input_txt" /><div class="m_et2">请填写菜单名称</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">选择菜单：</div></td>
            <td>
                <select name="ParentID" class="input_select" />
                    <option value="0">顶级菜单</option>
                    <% NavList rsObj("ParentID")%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">链接地址：</div></td>
            <td>
                <select name="NavType" class="input_select" onchange="check_navnature(this.options[this.selectedIndex].value)" />
                    <option value="0" <%if rsObj("NavType")=0 then%>selected="selected"<%end if%>>总店</option>
                    <%shopList1 rsObj("NavType")%>
                    <option value="-3" <%if rsObj("NavType")=-3 then%>selected="selected"<%end if%>>会员中心</option>
                    <option value="-1" <%if rsObj("NavType")=-1 then%>selected="selected"<%end if%>>推广码</option>
                    <option value="-2" <%if rsObj("NavType")=-2 then%>selected="selected"<%end if%>>其他</option>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr id="t2" <%if rsObj("NavType")>-2 then%>style="display:none"<%end if%>>
            <td width="100" height="46"><div class="td_left">其他地址：</div></td>
            <td>
                <input type="text" name="NavUrl" value="<%=rsObj("NavUrl")%>" class="input_txt"><div class="m_et2">点击后将跳转到此地址</div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">排序：</div></td>
            <td>
                <input type="text" name="Sequence" value="<%=rsObj("Sequence")%>" class="input_txt" style="width:80px;"><div class="m_et2"></div>
            </td>
        </tr>

        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认编辑" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onClick="if($('#NavName').val().length==0){alert('请填写菜单名称');return false;}" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
    <input type="hidden" name="m_id" value="<%=id%>">
</form>
<script language="javascript" charset="utf-8">
function check_navnature(value){
	if (value==-2){
		$("#t2").show();
	}
	else{
		$("#t2").hide();
	}
}
</script>
</body>
</html>
<%	
End Sub

Sub saveColumnType	
	dim NavName : NavName = getForm("NavName","post") : if isNul(NavName) then alert "请填写菜单名称","",1
	dim actType : actType = getForm("acttype","get")
	if actType="edit" then dim m_id:m_id=clng(getForm("m_id","post"))
	dim ParentID : ParentID = getForm("ParentID","post")
	
	dim NavType : NavType = getForm("NavType","post")
	dim NavKeyID : NavKeyID = getForm("NavKeyID","post")
	dim NavUrl : NavUrl = getForm("NavUrl","post")
	dim Sequence : Sequence = getForm("Sequence","post") : if isNul(Sequence) then Sequence=1
	
	select case  actType
		case "edit"
			conn.db "update {pre}Navigation set ParentID="&ParentID&",NavName='"&NavName&"',NavType="&NavType&",NavKeyID='"&NavKeyID&"',NavUrl='"&NavUrl&"',Sequence="&Sequence&" where ID="&m_id&"","0"
			alert "","admin_column.asp",""
		case "add"
			conn.db "insert into {pre}Navigation(ParentID,NavName,NavType,NavKeyID,NavUrl,Sequence) values("&ParentID&",'"&NavName&"',"&NavType&",'"&NavKeyID&"','"&NavUrl&"',"&Sequence&")","0"
			alert "","admin_column.asp",""
    end select
End Sub

Sub delAll
	dim ids,i,rsObj
	ids = replace(getForm("m_id","post")," ","")
	if not isnul(ids) then
		if instr(ids,",")>0 then
			set rsObj=conn.db("select id from {pre}Navigation where id in ("&ids&") order by Sequence","0")
			    if not rsObj.eof then
				    do while not rsObj.eof
					    delColumnTypeById rsObj(0)
					rsObj.movenext
					loop
				end if
			rsObj.close
			set rsObj=nothing
		else
			delColumnTypeById ids
		end if
	end if
	alert "","admin_column.asp",""
End Sub

Sub delColumnType
	dim id : id=getForm("id","get")
	delColumnTypeById id
	alert "","admin_column.asp",""
End Sub

Sub delColumnTypeById(id)
	dim sqlStr,rsObj
	sqlStr="select * from {pre}Navigation where ID="&id
	set rsObj = conn.db(sqlStr,"1")
	if not rsObj.eof then
	    if rsObj("ParentID")=0 then
		    conn.db  "delete from {pre}Navigation where ID in (select id from {pre}Navigation where ParentID="&id&")", "0"
		end if
		conn.db  "delete from {pre}Navigation where ID="&id, "0"
	end if 
	rsObj.close
	set rsObj=nothing
End Sub

Sub typeList(topId,flag)
	dim sqlStr,rsObj,i
	sqlStr= "select * from {pre}Navigation where ParentID="&topId&" order by Sequence"
	set rsObj = conn.db(sqlStr,"1")
	if flag=0 and rsObj.eof then
	    Echo "<div class='m_cell1' style='text-align:center;'><a href='admin_column.asp?action=add'>暂无栏目，点击添加</a></div>"
	else
	do while not rsObj.eof 
%>
<div <%if flag mod 2=0 then%>class="m_cell1"<%else%>class="m_cell2"<%end if%>>
    <div class="m_c5"><input type="checkbox" name="m_id" value="<%=rsObj("ID")%>" class="input_check" /></div>
    <div class="m_c5"><%=rsObj("ID")%></div>
    <div class="m_c25" style="text-align:left;">&nbsp;&nbsp;<%if rsObj("ParentID")>0 then%>&nbsp;&nbsp;└ <% end if %><%=rsObj("NavName")%></div>
    <div class="m_c40" style="text-align:left;">
	<%
		if rsObj("NavType")=-3 then
		    echo "&nbsp;&nbsp;[会员中心]"
		elseif rsObj("NavType")=-2 then
		    echo "&nbsp;&nbsp;["&rsObj("NavUrl")&"]"
		elseif rsObj("NavType")=-1 then
		    echo "&nbsp;&nbsp;[推广码]"
		elseif rsObj("NavType")=0 then
		    echo "&nbsp;&nbsp;[总店]"
		else
		    echo "&nbsp;&nbsp;["&conn.db("select Title from {pre}Shop where ID="&rsObj("NavType")&"","1")(0)&"]"
		end if
	%>
    </div>
    <div class="m_c10"><%=rsObj("Sequence") %></div>
    <div class="m_c14" style="border:0;color:#1866a4;"><a href="?action=edit&id=<%=rsObj("ID")%>">编辑</a> | <a href="?action=del&id=<%=rsObj("ID")%>" onClick="return confirm('确定要删除吗')">删除</a></div>
</div>
<%
        flag=flag+1
		typeList rsObj("ID"),flag
		rsObj.movenext
	loop
	end if
	rsObj.close
	set rsObj = nothing
End Sub

sub postmenu()
    On Error Resume Next
	dim Menutype,errcode
	Access_token=GetToken()
	if isnul(Access_token) then alert "接口出错，无法获取Access_token","",1
	strJson=PostURL(SendMenuUrl&"create?access_token="&Access_token,diyMenu())
	Call InitScriptControl:Set objTest = getJSONObject(strJson)
	errcode=objTest.errcode
	If errcode="0" then
		alert "自定义菜单发布成功","",1
	else
		alert "自定义菜单发布不成功，："&errcode,"",1
	end if
end sub

Function idToMyurl(id)
    dim s_type : s_type=conn.db("select ShopType from {pre}Shop where ID="&id&"","1")(0)
	if s_type=0 then
	    idToMyurl="http://"&siteUrl&"/"&sitePath&"mall/?shop="&id&""
	else
	    idToMyurl="http://"&siteUrl&"/"&sitePath&"reserve/?shop="&id&""
	end if
End Function

Function diyMenu()
	dim rsObj,rsObj1,Menutype,navtype,myurl
	set rsObj=conn.db("select * from {pre}Navigation where ParentID=0 order by Sequence","1")
	if not rsObj.eof then
		diyMenu="{""button"":["
			do while not rsObj.eof
			    set rsObj1=conn.db("select * from {pre}Navigation where ParentID="&rsObj("ID")&" order by Sequence","1")
				if rsObj1.eof then	'无子菜单
					if rsObj("NavType")=-1 then
						Menutype="""key"":""getcode"""
						navtype="click"
					else
					    if rsObj("NavType")=0 then
						    myurl="http://"&siteUrl&"/"&sitePath
						elseif rsObj("NavType")=-2 then
						    myurl=rsObj("NavUrl")
						elseif rsObj("NavType")=-3 then
						    myurl="http://"&siteUrl&"/"&sitePath&"user"
						else
						    myurl=idToMyurl(rsObj("NavType"))
						end if
						Menutype="""url"":"""&decodeHtml(myurl)&""""
						navtype="view"
					end if
					diyMenu=diyMenu&"{""type"":"""&navtype&""",""name"":"""&rsObj("NavName")&""","&Menutype&"},"		
				else
					diyMenu=diyMenu&"{""name"":"""&rsObj("NavName")&""",""sub_button"":["
					do while not rsObj1.eof						
						if rsObj1("NavType")=-1 then
						    Menutype="""key"":""getcode"""
						    navtype="click"
						else
							if rsObj1("NavType")=0 then
								myurl="http://"&siteUrl&"/"&sitePath
							elseif rsObj1("NavType")=-2 then
								myurl=rsObj1("NavUrl")
							elseif rsObj1("NavType")=-3 then
						        myurl="http://"&siteUrl&"/"&sitePath&"user"
							else
								myurl=idToMyurl(rsObj1("NavType"))
							end if
							Menutype="""url"":"""&decodeHtml(myurl)&""""
							navtype="view"
						end if
						diyMenu=diyMenu&"{""type"":"""&navtype&""",""name"":"""&rsObj1("NavName")&""","&Menutype&"},"		
					rsObj1.movenext
					loop				
					diyMenu=left(diyMenu,len(diyMenu)-1)
					diyMenu=diyMenu&"]},"
				end if	
				rsObj1.close
				set rsObj1=nothing
			rsObj.movenext
			loop
		diyMenu=left(diyMenu,len(diyMenu)-1)
		diyMenu=diyMenu&"]}"
	else
		diyMenu=""
	end if
	rsObj.close
	set rsObj=nothing
end Function
%>