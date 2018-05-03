<!--#include file="admin_inc.asp"-->
<%
checkPower ""
dim action : action = getForm("action", "get")
dim keyword,page,vtype,stype
Select case action
	case "delall" : delAll
	case "del" : delInfo
	case "edit" : editInfo
	case "save" : saveInfo
	case else : main
End Select 
terminateAllObjects

Sub main
	dim i,sqlStr,rsObj,allPage,allRecordset,numPerPage,whereStr
	numPerPage= 20
	vtype = getForm("type", "both") : if isNul(vtype) then vtype=1
	whereStr="where IsJf="&vtype&""
	keyword = URLDecode(getForm("keyword", "both")) : if not isNul(keyword) then whereStr = whereStr&" and OpenID='"&keyword&"'"
	page = getint(getForm("page", "get"),1)
	if page=0 then page=1
	sqlStr = "select * from {pre}Xfmx "&whereStr&" order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	rsObj.pagesize = numPerPage
	allRecordset = rsObj.recordcount : allPage= rsObj.pagecount
	if page>allPage then page=allPage
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>收支明细</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="images/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：收支明细 > <%if vtype=1 then%>积分列表<%else%>佣金列表<%end if%></div>
</div>
<div class="m_t2">
    <div class="m_t21"><a href="admin_details.asp">积分列表</a></div>
    <div class="m_t22"><a href="admin_details.asp?type=0">佣金列表</a></div>
</div>
<form method="post" name="listform" action="?type=<%=vtype%>" style="display:inline;">
<div class="m_ctr">
    <div class="m_title">
        <div class="m_c5">选择</div>
        <div class="m_c5">编号</div>
        <div class="m_c10">用户</div>
        <div class="m_c12">订单号</div>
        <div class="m_c8"><%if vtype=1 then%>积分<%else%>佣金<%end if%></div>
        <div class="m_c25">说明</div>
        <div class="m_c15">店铺</div>
        <div class="m_c10">状态</div>
        <div class="m_c9" style="border:0;">操作</div>
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
        <div class="m_c10"><%=conn.db("select NickName from {pre}User where OpenID='"&rsObj("OpenID")&"'","1")(0)%></div>
        <div class="m_c12"><%=rsObj("OrderID")%></div>
        <div class="m_c8"><%=rsObj("Nums")%></div>
        <div class="m_c25"><%=filterStr(rsObj("Content"))%></div>
        <div class="m_c15"><%
		    if rsObj("Nums")>=0 then
			    echo idtoShop(rsObj("ShopID"))
			else
			    if rsObj("ShopID")=1 then
				    echo "提现[<font color='#f46b0a'>申请中</font>]"
				else
			        echo "提现[<font color='#2a982a'>提现成功</font>]"
				end if
			end if
	    %></div>
        <div class="m_c10"><%if rsObj("Nums")>=0 then Echo "<font color='#F46B0A'>收入</font>" else Echo "<font color='#2a982a'>支出</font>"%></div>
        <div class="m_c9" style="border:0;color:#1866a4;"><%if rsObj("Nums")<0 then%><a href="?action=edit&id=<%=m_id%>&type=<%=vtype%>">编辑</a> | <%end if%><a href="?action=del&id=<%=m_id%>&type=<%=vtype%>" onClick="return confirm('确定要删除吗')">删除</a></div>
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
    <input type="submit" class="input_btn" value="批量删除" onmouseover="this.className='input_btn1'" onmouseout="this.className='input_btn'" onclick="if(confirm('确定要删除吗')){listform.action='?action=delall&type=<%=vtype%>';}else{return false}" />
    <select name="keyword" class="input_select" style="margin-top:0;height:32px;">
        <option value="">请选择会员</option>
        <%userList ""%>
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

Sub editInfo
	dim id,sqlStr,rsObj,m_color,rsObj1,i
	id=clng(getForm("id","get"))
	stype = getForm("type","get")
	sqlStr = "select * from {pre}Xfmx where ID="&id
	set rsObj = conn.db(sqlStr,"1")
	if rsObj.eof then alert "没找到记录","",1
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>提现处理</title>
<link href="images/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="../inc/image/jquery-1.4.2.min.js"></script>
<script type="text/javascript" charset="utf-8" src="../inc/image/DatePicker/WdatePicker.js"></script>
</head>
<body>
<div class="m_top">
    <div class="m_t1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您当前的位置：收支明细 > 提现处理</div>
</div>
<form action="?action=save&type=<%=stype%>" method="post">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100" height="46"><div class="td_left">订单号：</div></td>
            <td>
                <input type="text" name="m_oid" id="m_oid" class="input_txt" value="<%=rsObj("OrderID")%>" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">提现金额：</div></td>
            <td>
                <input type="text" name="m_user" value="<%=re(rsObj("Nums"),"-","")%>" class="input_txt" readonly="readonly" /><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="98"><div class="td_left">收款信息：</div></td>
            <td>
                <textarea name="m_info" cols="50" rows="4" class="input_textarea1" readonly="readonly"><%=codeTextarea(rsObj("Content"),"de")%></textarea><div class="m_et2"></div>
            </td>
        </tr>
        <tr>
            <td width="100" height="46"><div class="td_left">订单状态：</div></td>
            <td>
                <select name="m_type" class="input_select">
					<%if rsObj("ShopID")<=1 then%><option value="1" <%if rsObj("ShopID")=1 then%>selected="selected"<%end if%>>申请中</option><%end if%>
                    <%if rsObj("ShopID")<=1 then%><option value="0">驳回申请</option><%end if%>
                    <%if rsObj("ShopID")<=2 then%><option value="2" <%if rsObj("ShopID")=2 then%>selected="selected"<%end if%>>提现成功</option><%end if%>
                </select><div class="m_et2"></div>
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
	stype = getForm("type","get")
	conn.db "delete from {pre}Xfmx where id="&id,"0"
	alert "","admin_details.asp?type="&stype,""
End Sub

Sub delAll
	dim ids : ids = replace(getForm("m_id","post")," ","")
	stype = getForm("type","get")
	conn.db "delete from {pre}Xfmx where id in("&ids&")","0" 
	alert "","admin_details.asp?type="&stype,""
End Sub

Sub saveInfo
	dim id,m_type,m_openid,m_oid
	id = getForm("m_id","post")
	m_openid = getForm("m_openid","post")
	m_type = getForm("m_type","post")
	m_oid = getForm("m_oid","post")
	stype = getForm("type","get")
	if cint(m_type)=0 then
	    conn.db "delete from {pre}Xfmx where id="&id,"0"
		PostMsg "",m_openid,"您的提现订单："&m_oid&"收款信息有误已被驳回，请重新申请！"
	elseif cint(m_type)=2 then
	    conn.db "update {pre}Xfmx set ShopID="&m_type&" where id="&id,"0"
		PostMsg "",m_openid,"您的提现订单："&m_oid&"已处理完毕，请注意查收！"
	end if
	alert "","admin_details.asp?type="&stype,""
End Sub
%>