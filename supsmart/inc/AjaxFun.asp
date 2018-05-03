<!--#include file="Main.asp"-->
<%
dim action : action = getForm("action", "get")

Select case action
	case "addOrder" : addOrder
	case "getType" : getType
End Select
terminateAllObjects

Sub addOrder()
    on error resume next
	dim order_str,sql,rsObj,i,shopid
	dim m_orderid : m_orderid=getForm("oid", "get")
	order_str=readCookie("OrderStr")
    dim m_yj : m_yj=0
	dim m_jf : m_jf=0
	dim o_arr : o_arr=split(order_str,"|")
	dim c_arr,c_tc,c_jf
	for i=1 to ubound(o_arr)
		c_arr=split(o_arr(i),"$")
		set rsObj=conn.db("select * from {pre}Product where ID="&cint(c_arr(0))&"","1")
			c_tc=rsObj("PTc")
			c_jf=rsObj("PJf")
		rsObj.close
		set rsObj=nothing
		m_yj=m_yj+cint(c_tc)*cint(c_arr(2))
		m_jf=m_jf+cint(c_jf)*cint(c_arr(2))
		conn.db "update {pre}Product set Stock=Stock-"&cint(c_arr(2))&",PTotal=PTotal+"&cint(c_arr(2))&" where ID="&cint(c_arr(0))&"","0"  '更改库存
		shopid=cint(c_arr(1))
	next
	
	set rsObj=conn.db("select * from {pre}UAddr where OpenID='"&session("openid")&"'","1")
		dim m_name : m_name=rsObj("UName")
		dim m_tel : m_tel=rsObj("UTel")
		dim m_addr : m_addr=rsObj("UProvince")&" "&rsObj("UCity")&" "&rsObj("UCounty")&rsObj("UAddr")
	rsObj.close
	set rsObj=nothing
	dim m_info : m_info=getForm("m_info","get")
	
	sql="insert into {pre}Order(OpenID,OrderID,OrderStr,LinkName,Telephone,Address,OrderType,OTc,OJf,ShopID,AddDate,Content,PayType) values('"&session("openid")&"','"&m_orderid&"','"&order_str&"','"&m_name&"','"&m_tel&"','"&m_addr&"',0,"&m_yj&","&m_jf&","&shopid&",'"&now()&"','"&m_info&"',1)"
	conn.db sql,"0"
	if err then
	    echo "ERR"
	else
	    setCookie "OrderStr",""
		echo "SUCCESS"
	end if
End Sub

Sub getType()
    dim shopid : shopid = getForm("shop","get")
	dim sqlStr,rsObj
	Echo "<option value='0'>请选择栏目</option>"
	sqlStr= "select ID,C_Name from {pre}Category where ShopID="&shopid&" order by C_Sequence"
	set rsObj = conn.db(sqlStr,"1")
	if not rsObj.eof then
		do while not rsObj.eof
			Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
		rsObj.movenext
		loop
	end if
	rsObj.close
	set rsObj = nothing
End Sub

%>