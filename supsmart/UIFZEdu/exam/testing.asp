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
<title>����</title>
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
if checkStudentLogin() = false then	'��֤�����Ƿ��ѵ�¼
	response.redirect "student_login.asp"
end if
intPrjID = CLng(request.querystring("prjid"))
intStudentID = request.cookies("aoyi")("studentid")
'��ȡ������Ϣ
strSqlTest = "select starttime,endtime,limittime,prjname,ss_count,ms_count,b_count from project where prjid=" & intPrjID
set rsTest = server.createobject("ADODB.Recordset")
rsTest.open strSqlTest,G_CONN,1,1
'��֤�Ƿ���ڱ��ο���
if rsTest.bof and rsTest.eof then
	response.write "<script>alert('�˴ο��Բ�����!');window.open('index_main.asp','_self');</script>"
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
'��֤�����Ƿ��ڿɿ���ʱ����
if now() < dtmStartDate or now() > dtmEndDate + 1 then
	response.write "<script>alert('���ڲ��ڿ��Լƻ�ʱ����!');window.open('index_main.asp','_self');</script>"
	set rsTest = nothing
	response.end
end if
'��֤�����Ƿ����������ڽ��еĿ���
if G_CONN.execute("select count(*) as reccount from prj_student where prjid<>" & intPrjID & " and studentid=" & intStudentID & " and state=2")("reccount") > 0 then
	response.write "<script>alert('���������������ڽ����У�����ͬʱ�������ο��ԣ�');window.open('index_main.asp','_self')</script>"
	set rsTest= nothing
	response.end
end if
'ȡ�ñ��������ο��Ե�״̬
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
	response.write "<script>alert('���Ѿ��μӹ��˴ο�����,�����ٴβμӴ˴ο���!');window.open('index_main.asp','_self');</script>"
	set rsTest = nothing
	response.end
elseif intState = 0 then	'��������һ�βμӴ˴ο���ʱ���п����ĳ�ʼ���������Ծ�Ȳ���
	'�����Ծ�
	if makePaper(intPrjID,intStudentID) = false then
		Response.Write "<script>alert('�����Ծ�ʧ��!');window.open('index_main.asp','_self');</script>"
		set rsTest = nothing
		Response.End
	end if
	'��prj_student������Ӧ�Ŀ������Լ�¼
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
'ȡ�ÿ��ԵĿ�ʼʱ��
dtmStartTime = G_CONN.execute("select starttime from prj_student where prjid=" & intPrjID & " and studentid=" & intStudentID)("starttime")
'�жϵ�ǰ�Ƿ��ڿ���ʱ����
if DateDiff("n",dtmStartTime,now()) > intLimitTime then
	response.write "<script>alert('���ο���ʱ���ѹ��������ٽ��п��ԣ�');window.open('index_main.asp','_self');</script>"
	set rsTest = nothing
	response.end
end if
%>
<script language="jscript">
var dtmStartTime,intLimitTime

dtmStartTime = new Date(<%=Year(dtmStartTime)%>,<%=Month(dtmStartTime)%>,<%=Day(dtmStartTime)%>,<%=Hour(dtmStartTime)%>,<%=Minute(dtmStartTime)%>,<%=Second(dtmStartTime)%>);
intLimitTime = <%=intLimitTime%>;

function floatTestInfo()	//���Ƹ�����Ϣ�������·���ʾ
{
	var targetPosTop,targetPosLeft
	targetPosTop = document.body.scrollTop + document.body.clientHeight - 100;
	targetPosLeft = document.body.clientWidth + document.body.scrollLeft - 190;
	document.all.divTestInfo.style.posTop = document.all.divTestInfo.style.posTop + (targetPosTop - document.all.divTestInfo.style.posTop) * .2
	document.all.divTestInfo.style.posLeft = document.all.divTestInfo.style.posLeft + (targetPosLeft - document.all.divTestInfo.style.posLeft) * .2
	setTimeout('floatTestInfo();',50);
}

function ctrlTestTime()	//���ƿ���ʱ��
{
	var dtmCurrentTime = new Date();
	//����ʱ�����ʾ
	txtOddTime.value = intLimitTime - ((dtmCurrentTime.getHours() - dtmStartTime.getHours()) * 60 + dtmCurrentTime.getMinutes() - dtmStartTime.getMinutes());
	if(txtOddTime.value < 10)
	{
		txtOddTime.style.color = '#FF3300';
	}
	//�ڿ���ʱ�����ʱ���н���
	if(txtOddTime.value == 0)
	{
		alert('����ʱ���ѵ���ǿ�ƽ��н���');
		window.open('testfinish.asp?action=submitexam&prjid=<%=intPrjID%>&studentid=<%=intStudentID%>','_self');
	}
	window.setTimeout('ctrlTestTime();',1000);
}

function submitExam()	//����
{
	if(confirm('һ������Ͳ����ٽ��д���,��ȷ��Ҫ������?')==true)
		window.open('testfinish.asp?action=submitexam&prjid=<%=intPrjID%>&studentid=<%=intStudentID%>','_self');
}

function saveAnswer(objAnswer)	//���������
{
	if(objAnswer.type == 'checkbox')	//����Ƕ�ѡ��շ�Ϊѡ�л�ȡ��ѡ�����ֲ���
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
//��ҳ��װ���Ժ���������ʱ������������帡�����ƹ���
	floatTestInfo();
	ctrlTestTime();
</script>
<iframe name="fraSaveAnswer" style="visibility:hidden;height:0px" src=""></iframe>
<!--���Կ�����忪ʼ-->
<div name="divTestInfo" id="divTestInfo" style="position:absolute;border:solid 0px #000;left:200px;width:180px;height:80px">
	<table width="100%" height="50" align="center" border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="1">
		<tr>
			<td colspan="2" align="center" bgcolor="#000000"><font color="#FFFFFF"><strong>�������</strong></font></td>
		</tr>
		<tr>
			<td align="right" width="100" bgcolor="#000000">
				<font color="#FFFFFF">������ʱ��:</font>
			</td>
			<td bgcolor="000000" align="right">
				<font color="#DDFF00"><strong><%=intLimitTime%></strong></font> <font color="#FFFFFF">����&nbsp;</font>
			</td>
		</tr>
		<tr>
			<td align="right" bgcolor="#000000">
				<font color="#FFFFFF">ʣ��ʱ��:</font>
			</td>
			<td bgcolor="#000000" align="right" height="20">
				<input name="txtOddTime" type="text" size="3" readonly="" style="text-align:right;color:#AAFF00;border:0px solid #000000;background:#000000;font-weight:bold;" value="<%=intLimitTime-DateDiff("n",dtmStartTime,now())%>">
				<font color="#FFFFFF">����&nbsp;</font>
			</td>
		</tr>
		<tr>
			<td colspan="2" height="30" align="center" bgcolor="#000000">
				<input onClick="submitExam();" class="btn" type="button" value="&nbsp;��&nbsp;&nbsp;��&nbsp;">
			</td>
		</tr>
	</table>
</div>
<!--���Կ���������-->
<table width="550" align="center" border="0" cellspacing="5" cellpadding="5">
	<tr>
		<td align="center" height="40">
			<font size="4"><strong><%=strPrjName%></strong></font>
		</td>
	</tr>
	<tr>
		<td align="center">
			����:<%=request.cookies("aoyi")("studentname")%>&nbsp;&nbsp;&nbsp;&nbsp;�ܷ�:<%=intTotalMark%>&nbsp;&nbsp;����ʱ��:<%=intLimitTime%>����
		</td>
	</tr>
	<tr>
		<td><hr size="1" width="95%" color="#CCCCCC"></td>
	</tr>
	<%
	'��ʾ����ѡ����
	strSqlTest = "select P_P.id,P_P.answer,P_P.orderid,S.content,S.option1,S.option2,S.option3,S.option4,S.option5,S.option6 from prj_process P_P,subject S where S.type=1 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsTest.open strSqlTest,G_CONN,1,1
	if not rsTest.bof and not rsTest.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>����ѡ���ⲿ�� (��<%=intSSCount%>�� ÿ��1�� ��<%=intSSMark%>��)</strong></font>
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

	'��ʾ����ѡ����
	strSqlTest = "select P_P.id,P_P.answer,P_P.orderid,S.content,S.option1,S.option2,S.option3,S.option4,S.option5,S.option6 from prj_process P_P,subject S where S.type=2 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsTest.open strSqlTest,G_CONN,1,1
	if not rsTest.bof and not rsTest.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>����ѡ���ⲿ�� (��<%=intMSCount%>�� ÿ��2�� ��<%=intMSMark%>��)</strong></font>
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
	
	'��ʾ�Ƿ���
	strSqlTest = "select P_P.id,P_P.answer,P_P.orderid,S.content from prj_process P_P,subject S where S.type=3 and P_P.subid=S.id and P_P.studentid=" & intStudentID & " and P_P.prjid=" & intPrjID & " order by P_P.orderid"
	rsTest.open strSqlTest,G_CONN,1,1
	if not rsTest.bof and not rsTest.eof then
	%>
	<tr>
		<td height="30">
			<font size=3><strong>�Ƿ��ⲿ�� (��<%=intBCount%>�� ÿ��1�� ��<%=intBMark%>��)</strong></font>
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
				 onClick="saveAnswer(this);" type="radio" value="1"> ��&nbsp;&nbsp;
				<input name="<%=rsTest("id")%>"
				<%
				if rsTest("answer") = 0 then
					response.write "checked"
				end if
				%>
				 onClick="saveAnswer(this);" type="radio" value="0"> ��
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
