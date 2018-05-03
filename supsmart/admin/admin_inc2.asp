
<%
'****************************************************
'Code for IdeaCMS
'****************************************************

Sub confirmMsg(byval p0,byval p1,byval p2)
	Echo("<script charset='utf-8'>if(confirm('"&p0&"')){location.href='"&p1&"'}else{location.href='"&p2&"'}</script>")
End Sub

Sub echoMsg(byval p0,byval p1, byval p2)
	dim errstr,cssstr,msgstr,picstr
	if cint(p0)=0 then msgstr=err_msg1 : picstr="/"&sitePath&"inc/image/msg_err.gif"
	if cint(p0)=1 then msgstr=err_msg2 : picstr="/"&sitePath&"inc/image/msg_jg.gif"
	if cint(p0)=2 then msgstr=err_msg3 : picstr="/"&sitePath&"inc/image/msg_ok.gif"
	cssstr="<style>.msg_ctr{position:absolute;width:402px;height:auto;background:#ccc;padding:5px;left:35%;top:30%;z-index:999;}img{border:0;}#msg{background:#fff;border:1px solid #7f8585;margin:0 auto;width:400px;height:167px;background:url(/"&sitePath&"inc/image/msg_bg.gif) repeat-x}.msgtitle{float:left;width:355px;line-height:33px;height:33px;font-size:14px;font-weight:bold;color:#044fa6;padding-left:15px;}.msgclose{margin:8px 8px 0 0;float:right;width:15px;height:17px;display:inline;}#msgbody{float:left;width:400px;height:92px;padding-top:8px;}.msgpic { margin:0 8px;float:left;width:62px;height:71px;display:inline;}.msginfo{ margin:0 auto;float:left;width:300px;height:61px;line-height:24px;font-size:14px;color:#3c4043;padding-left:10px;padding-top:10px;}#msgfoot{ margin:8px 8px 0 0;float:right;width:56px;height:27px;display:inline;}</style>"
	errstr=cssstr&"<div class='msg_ctr'><div id='msg'><div class='msgtitle'>"&msgstr&"</div><div class='msgclose'><a href='javascript:void(0);' onclick='history.go(-1);'><img src='/"&sitePath&"inc/image/msg_close.gif'></a></div><div id='msgbody'><div class='msgpic'><img src='"&picstr&"'></div><div class='msginfo'>"&p2&"</div></div><div id='msgfoot'><a href='javascript:void(0);' onclick='history.go(-1);'><img src='/"&sitePath&"inc/image/msg_btn.gif'></a></div></div></div>" 
	cssstr=""
	Echo(errstr) : Died
End Sub

function DateFormat(p0,p1)
	if isdate(p0) then
		dim i,temp
		temp=replace(p1,"yyyy",DatePart("yyyy",p0))
		temp=replace(temp,"mm",iif(len(DatePart("m",p0))>1,DatePart("m",p0),"0"&DatePart("m",p0)))
		temp=replace(temp,"dd",iif(len(DatePart("d",p0))>1,DatePart("d",p0),"0"&DatePart("d",p0)))
		temp=replace(temp,"hh",iif(len(DatePart("h",p0))>1,DatePart("h",p0),"0"&DatePart("h",p0)))
		temp=replace(temp,"nn",iif(len(DatePart("n",p0))>1,DatePart("n",p0),"0"&DatePart("n",p0)))
		temp=replace(temp,"ss",iif(len(DatePart("s",p0))>1,DatePart("s",p0),"0"&DatePart("s",p0)))
		DateFormat=temp
	else
		DateFormat=false
	end if
end function

Function idToRole(id)
    if clng(id)=0 then
	    idToRole="超级管理员"
	else
	    idToRole="店铺管理员"
	end if
End Function

Function idToShop(id)
    dim rsObj
	set rsObj=conn.db("select Title from {pre}Shop where ID="&id&"","1")
	if rsObj.eof then
		idToShop="未知店铺"
	else
		idToShop=rsObj(0)
	end if
	rsObj.close
	set rsObj=nothing
End Function

Function URLDecode(p0)
	dim deStr,strSpecial 
	dim c,i,v 
	deStr="" 
	strSpecial="!""#$%&'()*+,.-_/:;<=>?@[\]^`{|}~%" 
	for i=1 to len(p0) 
		c=Mid(p0,i,1) 
		if c="%" then 
			v=eval("&h"+Mid(p0,i+1,2)) 
			if inStr(strSpecial,chr(v))>0 then 
				deStr=deStr&chr(v) 
				i=i+2 
			else 
				v=eval("&h"+ Mid(p0,i+1,2) + Mid(p0,i+4,2)) 
				deStr=deStr & chr(v) 
				i=i+5 
			end if 
		else 
			if c="+" then deStr=deStr&" " else deStr=deStr&c 
		end if 
	next 
	URLDecode=deStr 
End function

Sub isCurrentDay(p0)
	if isNul(p0) then Echo "" : Exit Sub
	dim timeStr2 : timeStr2=date
	if instr(p0,timeStr2)>0 then Echo "<span style='color:red;'>"&p0&"</span>" else Echo "<span>"&p0&"</span>"
End Sub

Sub checkPower(power)
	dim rsObj,rName,rVerifycode
	rName=readCookie("UserName") : rVerifycode=readCookie("Verifycode")
	if isNul(rName) or isNul(rVerifycode) then
	    Echo "<script>top.location.href='index.asp?action=login';</script>" : Died
	else
	    set rsObj=conn.db("select RoleID from {pre}Manager where UserName='"&rName&"' and Verifycode='"&rVerifycode&"'","1")
		if rsObj.eof then
		    Echo "<script>top.location.href='index.asp?action=login';</script>" : Died
		else
		    if clng(rsObj(0))>0 then
			    if not isPower(power,conn.db("select RolePower from {pre}Role where ID="&rsObj(0)&"","0")(0)) then alert "暂无权限","",1
			end if
		end if
		rsObj.close
	    set rsObj=nothing
	end if
End Sub

Sub shopList(id)
	dim sqlStr,rsObj
	sqlStr= "select ID,Title from {pre}Shop order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub shopList1(id)
	dim sqlStr,rsObj
	sqlStr= "select ID,Title from {pre}Shop order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>&nbsp;&nbsp;└&nbsp;"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>&nbsp;&nbsp;└&nbsp;"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>&nbsp;&nbsp;└&nbsp;"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub userList(id)
	dim sqlStr,rsObj
	sqlStr= "select OpenID,NickName from {pre}User order by ID desc"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub NavList(id)
	dim sqlStr,rsObj
	sqlStr= "select ID,NavName from {pre}Navigation where ParentID=0 order by Sequence"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>&nbsp;&nbsp;|&nbsp;"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>&nbsp;&nbsp;|&nbsp;"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>&nbsp;&nbsp;|&nbsp;"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub categoryList(shopid,id)
	dim sqlStr,rsObj
	sqlStr= "select ID,C_Name from {pre}Category where ShopID="&shopid&" order by C_Sequence"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub rcategoryList(id)
	dim sqlStr,rsObj
	sqlStr= "select ID,C_Name from {pre}Category where C_Type=2 order by C_Sequence"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub scList(id)
	dim sqlStr,rsObj
	sqlStr= "select ID,Title from {pre}Material order by id desc"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
		else
		    if clng(id)=clng(rsObj(0)) then
		        Echo "<option value='"&rsObj(0)&"' selected>"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(0)&"'>"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub

Sub keyList(id)
	dim sqlStr,rsObj
	sqlStr= "select ID,Title from {pre}Keys order by id desc"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    if isNul(id) then
	        Echo "<option value='"&rsObj(1)&"'>"&rsObj(1)&"</option>"
		else
		    if id=rsObj(1) then
		        Echo "<option value='"&rsObj(1)&"' selected>"&rsObj(1)&"</option>"
			else
			    Echo "<option value='"&rsObj(1)&"'>"&rsObj(1)&"</option>"
			end if
		end if
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Sub
%>