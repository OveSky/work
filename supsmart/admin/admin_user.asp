<!--#include file="admin_inc.asp"-->
<%
checkPower ""
dim action : action = getForm("action", "get")
dim keyword,page,vtype
Select case action
	case "delall" : delAll
	case "del" : delInfo
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
	sqlStr = "select * from {pre}User order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>用户管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：用户管理 > 用户列表</div>
</div>
<form method="post" name="listform" action="?" style="display:inline;">
<div class="m_ctr">
    <div class="m_title">
        <div class="m_c5">选择</div>
        <div class="m_c5">编号</div>
        <div class="m_c20">openID</div>
        <div class="m_c25">昵称</div>
        <div class="m_c10">性别</div>
        <div class="m_c14">地址</div>
        <div class="m_c12">推荐人</div>
        <div class="m_c8" style="border:0;">状态</div>
    </div>
    <%
    if allRecordset=0 then
        Echo "<div class='m_cell1' style='text-align:center;'>暂无数据！</div>"
    else  
        rsObj.absolutepage = page
        for i = 0 to numPerPage	
            dim m_id : m_id = rsObj(0)
    %>
    <div <%if i mod 2=0 then%>class="m_cell1"<%else%>class="m_cell2"<%end if%>>
        <div class="m_c5"><input type="checkbox" name="m_id" value="<%=m_id%>" class="input_check" /></div>
        <div class="m_c5"><%=rsObj("ID")%></div>
        <div class="m_c20"><%=rsObj("openID")%></div>
        <div class="m_c25"><% echo rsObj("NickName")&" ( <font color=red>"&conn.db("select count(*) from {pre}User where ParentID="&rsObj("ID")&"","1")(0)&"</font> 位会员)"%></div>
        <div class="m_c10"><% if rsObj("RSex") then echo "男" else echo "女"%></div>
        <div class="m_c14"><% echo rsObj("RCountry")&" "&rsObj("RProvince")&" "&rsObj("RCity")%></div>
        <div class="m_c12"><% if rsObj("ParentID")=0 then echo "无" else echo conn.db("select NickName from {pre}User where ID="&rsObj("ParentID")&"","1")(0)%></div>
        <div class="m_c8" style="border:0;color:#1866a4;"><%if rsObj("working") then echo "<font color='#2a982a'>关注</font>" else echo "<font color='#F46B0A'>取消关注</font>"%></div>
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

Sub editInfo
	dim id,sqlStr,rsObj,m_color,rsObj1,i
	id=clng(getForm("id","get"))
	sqlStr = "select * from {pre}Order where ID="&id
	set rsObj = conn.db(sqlStr,"1")
	if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>编辑订单</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="../inc/image/DatePicker/WdatePicker.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：订单管理 > 编辑订单</div>
</div>



<form action="?action=save" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">订单号：</div></td>
            <td>
                <input type="text" name="m_oid" id="m_oid" class="input_txt" value="<%=rsObj("OrderID")%>" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">订单信息：</div></td>
            <td valign="top">
                <table cellpadding="0" cellspacing="0" border="0" class="o_table">
                    <tr style="background:#f5f5f5;color:#237cc0;">
                        <td width="200" height="30" style="border-bottom:1px #cdddea solid;">产品名称</td>
                        <td width="150" style="border-bottom:1px #cdddea solid;">产品单价</td>
                        <td style="border-bottom:1px #cdddea solid;">订购数量</td>
                    </tr>
				<%
                    dim m_order : m_order=rsObj("OrderStr")
                    dim m_arr : m_arr=split(m_order,"|")
                    dim c_arr
                    for i=1 to ubound(m_arr)
                        c_arr=split(m_arr(i),"$")
                        set rsObj1=conn.db("select * from {pre}product where id="&cint(c_arr(0))&"","1")
                %>
                        <tr>
                            <td height="32"><%=rsObj1("Title")%></td>
                            <td><%=rsObj1("DzPrice")%></td>
                            <td><%=c_arr(2)%></td>
                        </tr>
                <%			
                        rsObj1.close
                        set rsObj1=nothing
                    next
                %>
                </table>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系人：</div></td>
            <td>
                <input type="text" name="m_user" value="<%=rsObj("LinkName")%>" class="input_txt" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系电话：</div></td>
            <td>
                <input type="text" name="m_tel" value="<%=rsObj("Telephone")%>" class="input_txt" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">联系地址：</div></td>
            <td>
                <input type="text" name="m_addr" value="<%=rsObj("Address")%>" class="input_txt" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">订购日期：</div></td>
            <td>
                <input type="text" name="m_addr" value="<%=rsObj("AddDate")%>" class="input_txt" style="width:145px;" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="98"><div class="td_left">订单备注：</div></td>
            <td>
                <textarea name="m_info" cols="50" rows="4" class="input_textarea1" readonly="readonly"><%=codeTextarea(rsObj("Content"),"de")%></textarea><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">订单状态：</div></td>
            <td>
                <select name="m_type" class="input_select">
					<%if rsObj("OrderType")<=0 then%><option value="0" <%if rsObj("OrderType")=0 then%>selected="selected"<%end if%>>等待付款</option><%end if%>
                    <%if rsObj("OrderType")<=1 then%><option value="1" <%if rsObj("OrderType")=1 then%>selected="selected"<%end if%>>已付款</option><%end if%>
                    <%if rsObj("OrderType")<=2 then%><option value="2" <%if rsObj("OrderType")=2 then%>selected="selected"<%end if%>>已发货</option><%end if%>
                </select><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="98"><div class="td_left">物流信息：</div></td>
            <td>
                <textarea name="m_wlinfo" cols="50" rows="4" class="input_textarea1"><%=codeTextarea(rsObj("OrderExpress"),"de")%></textarea><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td height="55" style="border:0;">&nbsp;</td>
            <td style="border:0;">
                <input type="submit" class="input_btn" value="确认修改" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
                <input type="reset" class="input_btn" value="取消重置" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" />
            </td>
        </tr>
    </table>
    <input type="hidden" name="m_id" value="<%=id%>">
    <input type="hidden" name="m_openid" value="<%=rsObj("OpenID")%>">
</form>
</body>
</html>
<%
    rsObj.close
    set rsObj = nothing
End Sub

Sub delInfo
	dim id : id = getForm("id","get")
	conn.db "delete from {pre}Order where id="&id,"0"
	alert "","admin_order.asp",""
End Sub

Sub delAll
	dim ids : ids = replace(getForm("m_id","post")," ","")
	conn.db "delete from {pre}Order where id in("&ids&")","0" 
	alert "","admin_order.asp",""
End Sub

Sub saveInfo
	dim id,m_type,m_wlinfo,m_openid,m_oid
	id = getForm("m_id","post")
	m_openid = getForm("m_openid","post")
	m_oid = getForm("m_oid","post")
	m_type = getForm("m_type","post")
	m_wlinfo=codeTextarea(getForm("m_wlinfo","post"),"en")
	conn.db "update {pre}Order set OrderType="&m_type&",OrderExpress='"&m_wlinfo&"' where id="&id,"0"
	if cint(m_type)=2 then PostMsg "",m_openid,"您的订单："&m_oid&"已发货。物流信息："&m_wlinfo&"。请注意查收！"  '给购买者发信息
	alert "","admin_order.asp",""
End Sub
%>