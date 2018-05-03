<%
session.codepage=65001
response.charset="utf-8"
server.scripttimeout=999999

dim MO_Win

%>
	<div id="WinLogin">
		<form action="<%=RedirectTo%>"  name="form1" method="post"  target="_self" >
			<ul>	
				<li style="display: inline;"><input	class="Find" type="text" name="VipName" id="VipName"  value="user"></li>
				<li style="display: inline;"><input	class="Find" type="text" name="VipPsw" id="VipPsw" value="" placeholder="请输密码">  </li>
				<input  class="Button RedButton Button18" type="submit" value="权限确认"> 
			</ul>
		</form>	
	</div>



<%
if len(Request.form("VipPsw"))>2 then
	session("VipName")=Request.form("VipName")
	session("VipPsw")=Request.form("VipPsw")
end if

if len(session("VipPsw"))<2 then


else 

	
	'获取模块ID 获取模块授权等级'	ModuleOrder
	'win界面权限

	select case true
		case session("VipName")="admin" and session("VipPsw")="fz666666"	''
			MO_Win=9
		case session("VipName")="manager" and session("VipPsw")="888888"
			MO_Win=2
		case session("VipName")="user" and session("VipPsw")="234567"	''
			MO_Win=1
		case else 
			MO_Win=0
			session("VipPsw")=""
	end select
	
	
end if

if MO_Win>0 then
	response.write("<script language=javascript>")
	response.write("document.getElementById('WinLogin').style.display='none';")
    response.write("</script>")	

end if
%>
