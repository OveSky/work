<%option explicit%>
<%
Response.expires=-1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","no-store"
%>

<!--#include file="inc/conn.asp"-->
<!--#include file="inc/function.asp"-->
<%
dim rsSaveAnswer,strSqlSaveAnswer,intAnswer,strAction,intID	'考生答案,动作(主要用于多选题,决定是选中还是取消),试题ID

intAnswer = CLng(trim(request.querystring("answer")))
strAction = request.querystring("action")
intID = request.querystring("id")
set rsSaveAnswer = server.createobject("ADODB.Recordset")
strSqlSaveAnswer = "select P_P.*,P_S.state,P_S.starttime,P.limittime from prj_process P_P,prj_student P_S,project P where P_P.studentid=P_S.studentid and P_P.prjid=P_S.prjid and P_S.prjid=P.prjid and P_P.id=" & intID
rsSaveAnswer.open strSqlSaveAnswer,G_CONN,1,3
if rsSaveAnswer("state") = 2 and DateDiff("n",rsSaveAnswer("starttime"),now()) < rsSaveAnswer("limittime") then	'验证此答案是否在有效的时间内提交的.
	if intAnswer = 0 or intAnswer = 1 or intAnswer = 2 or intAnswer = 4 or intAnswer = 8 or intAnswer = 16 or intAnswer = 32 then
	'保存答案
		if strAction = "selected" then
			if rsSaveAnswer("answer") < 0 then
				rsSaveAnswer("answer") = intAnswer
			else
				rsSaveAnswer("answer") = rsSaveAnswer("answer") or intAnswer
			end if
		elseif strAction = "selectcancel" then
			rsSaveAnswer("answer") = rsSaveAnswer("answer") and not intAnswer
		else
			rsSaveAnswer("answer") = intAnswer
		end if
		rsSaveAnswer.update
	else
		response.write "<script>alert('答案不合法!');</script>"
	end if
else
	response.write "<script>alert('现在不是考试时间,不能进行答题!');</script>"
end if
rsSaveAnswer.close
set rsSaveAnswer = nothing
%>