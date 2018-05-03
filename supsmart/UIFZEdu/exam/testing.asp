<%
option explicit
Response.expires=-1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","no-store"
%>

<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考试</title>
<style>
td {
	font-size:14px;
	line-height:18px;
}
input.btn {
	background:#000000;
	color:#FFFFFF;
	border:1px #FFFFFF solid;
}

</style>
</head>
<body>
<%
dim rsTest,strSqlTest,rsTemp,strSqlTemp,rsPS,strSqlPS,intPrjID,intPSID,intStudentID
dim intTotalMark,intSSCount,intSSMark,intMSCount,intMSMark,intBCount,intBMark
dim strPrjName,dtmStartTime,intLimitTime,intState,dtmStartDate,dtmEndDate
if checkStudentLogin() = false then	'验证考生是否已登录
	response.redirect "student_login.asp"
end if
intPrjID = CLng(request.querystring("prjid"))
intStudentID = request.cookies("aoyi")("studentid")
'读取考试信息
strSqlTest = "select starttime,endtime,limittime,prjname,ss_count,ms_count,b_count from project where prjid=" & intPrjID
set rsTest = server.createobject("ADODB.Recordset")
rsTest.open strSqlTest,G_CONN,1,1
'验证是否存在本次考试
if rsTest.bof and rsTest.eof then
	response.write "<script>alert('此次考试不存在!');window.open('index_main.asp','_self');</script>"
	rsTest.close
	set rsTest = nothing
	response.end
end if
strPrjName = rsTest("prjname")
intSSCount = rsTest("ss_count")
intSSMark = intSSCount
intMSCount = rsTest("ms_count")
intMSMark = intMSCount * 2
intBCount = rsTest("b_count")
intBMark = intBCount
intTotalMark = intSSMark + intMSMark + intBMark
dtmStartDate = rsTest("starttime")
dtmEndDate = rsTest("endtime")
intLimitTime = rsTest("limittime")
rsTest.close
'验证现在是否在可考试时间内
if now() < dtmStartDate or now() > dtmEndDate + 1 then
	response.write "<script>alert('现在不在考试计划时间内!');window.open('index_main.asp','_self');</script>"
	set rsTest = nothing
	response.end
end if
'验证现在是否有其他正在进行的考试
if G_CONN.execute("select count(*) as reccount from prj_student where prjid<>" & intPrjID & " and studentid=" & intStudentID & " and state=2")("reccount") > 0 then
	response.write "<script>alert('你有其他考试正在进行中，不能同时进行两次考试！');window.open('index_main.asp','_self')</script>"
	set rsTest= nothing
	response.end
end if
'取得本考生本次考试的状态
set rsTemp = server.createobject("ADODB.Recordset")
strSqlTemp = "select state from prj_student where prjid=" & intPrjID & " and studentid=" & intStudentID
rsTemp.open strSqlTemp,G_CONN,1,1
if rsTemp.bof and rsTemp.eof then
	intState = 0
else
	intState = rsTemp("state")
end if
rsTemp.close
set rsTemp = nothing
if intState = 1 then
	response.write "<script>alert('你已经参加过此次考试了,不能再次参加此次考试!');window.open('index_main.asp','_self');</script>"
	set rsTest = nothing
	response.end
elseif intState = 0 then	'当考生第一次参加此次考试时进行考生的初始化，生成试卷等操作
	'生成试卷
	if makePaper(intPrjID,intStudentID) = false then
		Response.Write "<script>alert('生成试卷失败!');window.open('index_main.asp','_self');</script>"
		set rsTest = nothing
		Response.End
	end if
	'在prj_student增加相应的考生考试记录
	strSqlPS = "select * from prj_student where prjid=" & intPrjID & " and studentid=" & intStudentID
	set rsPS = server.createobject("ADODB.Recordset")
	rsPS.open strSqlPS,G_CONN,1,3
	if rsPS.bof and rsPS.eof then
		rsPS.addnew
		rsPS("prjid") = intPrjID
		rsPS("studentid") = intStudentID
		rsPS("state") = 2
		rsPS("starttime") = now()
		rsPS.update
	else
		rsPS("state") = 2
		rsPS("starttime") = now()
		rsPS.update
	end if
	rsPS.close
	set rsPS = nothing
end if
'取得考试的开始时间
dtmStartTime = G_CONN.execute("select starttime from prj_student where prjid=" & intPrjID & " and studentid=" & intStudentID)("starttime")
'判断当前是否在考试时间内
if DateDiff("n",dtmStartTime,now()) > intLimitTime then
	response.write "<script>alert('本次考试时间已过，不能再进行考试！');window.open('index_main.asp','_self');</script>"
	set rsTest = nothing
	response.end
end if
%>
<script language="jscript">
var dtmStartTime,intLimitTime

dtmStartTime = new Date(<%=Year(dtmStartTime)%>,<%=Month(dtmStartTime)%>,<%=Day(dtmStartTime)%>,<%=Hour(dtmStartTime)%>,<%=Minute(dtmStartTime)%>,<%=Second(dtmStartTime)%>);
intLimitTime = <%=intLimitTime%>;

function floatTestInfo()	//控制浮动信息板在右下方显示
{
	var targetPosTop,targetPosLeft
	targetPosTop = document.body.scrollTop + document.body.clientHeight - 100;
	targetPosLeft = document.body.clientWidth + document.body.scrollLeft - 190;
	document.all.divTestInfo.style.posTop = document.all.divTestInfo.style.posTop + (targetPosTop - document.all.divTestInfo.style.posTop) * .2
	document.all.divTestInfo.style.posLeft = document.all.divTestInfo.style.posLeft + (targetPosLeft - document.all.divTestInfo.style.posLeft) * .2
	setTimeout('floatTestInfo();',50);
}

function ctrlTestTime()	//控制考试时间
{
	var dtmCurrentTime = new Date();
	//控制时间的显示
	txtOddTime.value = intLimitTime - ((dtmCurrentTime.getHours() - dtmStartTime.getHours()) * 60 + dtmCurrentTime.getMinutes() - dtmStartTime.getMinutes());
	if(txtOddTime.value < 10)
	{
		txtOddTime.style.color = '#FF3300';
	}
	//在考试时间结束时进行交卷
	if(txtOddTime.value == 0)
	{
		alert('考试时间已到，强制进行交卷！');
		window.open('testfinish.asp?action=submitexam&prjid=<%=intPrjID%>&studentid=<%=intStudentID%>','_self');
	}
	window.setTimeout('ctrlTestTime();',1000);
}

function submitExam()	//交卷
{
	if(confirm('一旦交卷就不能再进行答题,你确认要交卷吗?')==true)
		window.open('testfinish.asp?action=submitexam&prjid=<%=intPrjID%>&studentid=<%=intStudentID%>','_self');
}

function saveAnswer(objAnswer)	//保存试题答案
{
	if(objAnswer.type == 'checkbox')	//如果是多选题刚分为选中或取消选中两种操作
		if(objAnswer.checked == true)
			window.open('test_saveanswer.asp?action=selected&answer=' + objAnswer.value + '&id=' + objAnswer.name,'fraSaveAnswer');
		else
			window.open('test_saveanswer.asp?action=selectcancel&answer=' + objAnswer.value + '&id=' + objAnswer.name,'fraSaveAnswer');	
	else
		window.open('test_saveanswer.asp?answer=' + objAnswer.value + '&id=' + objAnswer.name,'fraSaveAnswer')
	objAnswer.focus();
}

</script>
<script for=window event=onload language="JScript">
//在页面装载以后启动考试时间控制与控制面板浮动控制功能
	floatTestInfo();
	ctrlTestTime();
</script>
<iframe name="fraSaveAnswer" style="visibility:hidden;height:0px" src=""></iframe>
<!--考试控制面板开始-->
<div name="divTestInfo" id="divTestInfo" style="position:absolute;border:solid 0px #000;left:200px;width:180px;height:80px">
	<table width="100%" height="50" align="center" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="1">
		<tr>
			<td colspan="2" align="center" bgcolor="#000000"><font color="#FFFFFF"><strong>控制面板</strong></font></td>
		</tr>
		<tr>
			<td align="right" width="100" bgcolor="#000000">
				<font color="#FFFFFF">考试总时间:</font>
			</td>
			<td bgcolor="000000" align="right">
				<font color="#DDFF00"><strong><%=intLimitTime%></strong></font> <font color="#FFFFFF">分钟&nbsp;</font>
			</td>
		</tr>
		<tr>
			<td align="right" bgcolor="#000000">
				<font color="#FFFFFF">剩余时间:</font>
			</td>
			<td bgcolor="#000000" align="right" height="20">
				<input name="txtOddTime" type="text" size="3" readonly="" style="text-align:right;color:#AAFF00;border:0px solid #000000;background:#000000;font-weight:bold;" value="<%=intLimitTime-DateDiff("n",dtmStartTime,now())%>">
				<font color="#FFFFFF">分钟&nbsp;</font>
			</td>
		</tr>
		<tr>
			<td colspan="2" height="30" align="center" bgcolor="#000000">
				<input onClick="submitExam();" class="btn" type="button" value="&nbsp;交&nbsp;&nbsp;卷&nbsp;">
			</td>
		</tr>
	</table>
</div>
<!--考试控制面板结束-->
<table width="550" align="center" border="0" cellspacing="5" cellpadding="5">
	<tr>
		<td align="center" height="40">
			<font size="4"><strong><%=strPrjName%></strong></font>
		</td>
	</tr>
	<tr>
		<td align="center">
			姓名:<%=request.cookies("aoyi")("studentname")%>&nbsp;&nbsp;&nbsp;&nbsp;总分:<%=intTotalMark%>&nbsp;&nbsp;考试时间:<%=intLimitTime%>分钟
		</td>
	</tr>
	<tr>
		<td><hr size="1" width="95%" color="#CCCCCC"></td>
	</tr>
	<%
	'显示单项选择题
	strSqlTest = "select P_P.id,P_P.answer,P_P.orderid,S.content,S.option1,S.option2,S.option3,S.option4,S.option5,S.option6 from prj_process P_P,subject S where S.type=1 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsTest.open strSqlTest,G_CONN,1,1
	if not rsTest.bof and not rsTest.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>单项选择题部分 (共<%=intSSCount%>题 每题1分 共<%=intSSMark%>分)</strong></font>
		</td>
	</tr>
	<%
		while not rsTest.eof
	%>
		<tr>
			<td>
				<strong><%=rsTest("orderid")%>. </strong>
				<%=rsTest("content")%>
			</td>
		</tr>
		<tr>
			<td>
				<%
				if rsTest("option1") <> "" then
					response.write "&nbsp;A&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 1) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if
					response.write " onClick='saveAnswer(this);' type='radio' value='1'> " & rsTest("option1")
					response.write "<br>"
				end if
				if rsTest("option2") <> "" then
					response.write "&nbsp;B&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 2) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if					
					response.write " onClick='saveAnswer(this);' type='radio' value='2'> " & rsTest("option2")
					response.write "<br>"
				end if
				if rsTest("option3") <> "" then
					response.write "&nbsp;C&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 4) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if										
					response.write " onClick='saveAnswer(this);' type='radio' value='4'> " & rsTest("option3")
					response.write "<br>"
				end if
				if rsTest("option4") <> "" then
					response.write "&nbsp;D&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 8) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if										
					response.write " onClick='saveAnswer(this);' type='radio' value='8'> " & rsTest("option4")
					response.write "<br>"
				end if
				if rsTest("option5") <> "" then
					response.write "&nbsp;E&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 16) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if										
					response.write " onClick='saveAnswer(this);' type='radio' value='16'> " & rsTest("option5")
					response.write "<br>"
				end if
				if rsTest("option6") <> "" then
					response.write "&nbsp;F&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 32) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if					
					response.write" onClick='saveAnswer(this);' type='radio' value='32'> " & rsTest("option6")
					response.write "<br>"
				end if
				%>
			</td>
		</tr>
	<%
			rsTest.movenext
		wend
	end if
	rsTest.close

	'显示多项选择题
	strSqlTest = "select P_P.id,P_P.answer,P_P.orderid,S.content,S.option1,S.option2,S.option3,S.option4,S.option5,S.option6 from prj_process P_P,subject S where S.type=2 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsTest.open strSqlTest,G_CONN,1,1
	if not rsTest.bof and not rsTest.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>多项选择题部分 (共<%=intMSCount%>题 每题2分 共<%=intMSMark%>分)</strong></font>
		</td>
	</tr>
	<%
		while not rsTest.eof
	%>
		<tr>
			<td>
				<strong><%=rsTest("orderid")%>. </strong>
				<%=rsTest("content")%>
			</td>
		</tr>
		<tr>
			<td>
				<%
				if rsTest("option1") <> "" then
					response.write "&nbsp;A&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 1) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if
					response.write " onClick='saveAnswer(this);' type='checkbox' value='1'> " & rsTest("option1")
					response.write "<br>"
				end if
				if rsTest("option2") <> "" then
					response.write "&nbsp;B&nbsp;<input name='" & rsTest("id") & "' "					
					if (rsTest("answer") and 2) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if
					response.write " onClick='saveAnswer(this);' type='checkbox' value='2'> " & rsTest("option2")
					response.write "<br>"
				end if
				if rsTest("option3") <> "" then
					response.write "&nbsp;C&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 4) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if					
					response.write " onClick='saveAnswer(this);' type='checkbox' value='4'> " & rsTest("option3")
					response.write "<br>"
				end if
				if rsTest("option4") <> "" then
					response.write "&nbsp;D&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 8) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if					
					response.write " onClick='saveAnswer(this);' type='checkbox' value='8'> " & rsTest("option4")
					response.write "<br>"
				end if
				if rsTest("option5") <> "" then
					response.write "&nbsp;E&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 16) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if					
					response.write " onClick='saveAnswer(this);' type='checkbox' value='16'> " & rsTest("option5")
					response.write "<br>"
				end if
				if rsTest("option6") <> "" then
					response.write "&nbsp;F&nbsp;<input name='" & rsTest("id") & "' "
					if (rsTest("answer") and 32) > 0 and rsTest("answer") >= 0 then
						response.write "checked"
					end if					
					response.write " onClick='saveAnswer(this);' type='checkbox' value='32'> " & rsTest("option6")
					response.write "<br>"
				end if
				%>
			</td>
		</tr>
	<%
		rsTest.movenext
		wend
	end if
	rsTest.close
	
	'显示是非题
	strSqlTest = "select P_P.id,P_P.answer,P_P.orderid,S.content from prj_process P_P,subject S where S.type=3 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsTest.open strSqlTest,G_CONN,1,1
	if not rsTest.bof and not rsTest.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>是非题部分 (共<%=intBCount%>题 每题1分 共<%=intBMark%>分)</strong></font>
		</td>
	</tr>
	<%
		while not rsTest.eof
	%>
		<tr>
			<td>
				<strong><%=rsTest("orderid")%>. </strong>
				<%=rsTest("content")%>
			</td>
		</tr>
		<tr>
			<td>
				<input name="<%=rsTest("id")%>" 
				<%
				if rsTest("answer") = 1 then
					response.write "checked"
				end if
				%>
				 onClick="saveAnswer(this);" type="radio" value="1"> 是&nbsp;&nbsp;
				<input name="<%=rsTest("id")%>"
				<%
				if rsTest("answer") = 0 then
					response.write "checked"
				end if
				%>
				 onClick="saveAnswer(this);" type="radio" value="0"> 否
			</td>
		</tr>
	<%
		rsTest.movenext
		wend
	end if
	rsTest.close
	set rsTest = nothing
	call closeConn()
	%>
</table>
</body>
</html>
