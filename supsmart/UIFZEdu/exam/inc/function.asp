<%
'公用常量定义
CONST CONST_PURVIEW_ADMIN = 0 '超级管理员权限值
CONST CONST_PURVIEW_SUBJECT = 1	'维护试题档案权限值
CONST CONST_PURVIEW_STUDENT = 2	'维护考生档案权限值
CONST CONST_PURVIEW_PROJECT = 4	'维护考试计划权限值
CONST CONST_PURVIEW_COURSE = 8	'维护课程档案权限值

'检测管理员登录是否有效
function checkAdminLogin()
	dim rsCheckLogin,strSqlCheckLogin
	checkAdminLogin = true
	set rsCheckLogin = server.createobject("ADODB.Recordset")
	strSqlCheckLogin = "select * from admin where adminname='" & request.cookies("aoyi")("adminname") & "'"
	rsCheckLogin.open strSqlCheckLogin,G_CONN,1,1
	if rsCheckLogin.bof and rsCheckLogin.eof then
		checkAdminLogin = false
	end if
	rsCheckLogin.close
	set rsCheckLogin = nothing
end function

'检测当前管理员权限是否符合指定要求
function checkPurview(intPurview)
	dim rsCheckPurview,strSqlCheckPurview
	checkPurview = false
	set rsCheckPurview = server.createobject("ADODB.Recordset")
	strSqlCheckPurview = "select * from admin where adminname='" & request.cookies("aoyi")("adminname") & "'"
	rsCheckPurview.open strSqlCheckPurview,G_CONN,1,1
	if not rsCheckPurview.bof and not rsCheckPurview.eof then
		if rsCheckPurview("adminpurview") and intPurview <> 0 or rsCheckPurview("adminname") = "admin" then	'把数据库中权限值与指定权限值做与运算检测是否包含指定权限
			checkPurview = true
		end if
	end if
	rsCheckPurview.close
	set rsCheckPurview = nothing
end function

'检测当前考生登录是否有效
function checkStudentLogin()
	dim rsCheckLogin,strSqlCheckLogin
	checkStudentLogin = true
	set rsCheckLogin = server.createobject("ADODB.Recordset")
	strSqlCheckLogin = "select studentid from student where studenttype=1 and username='" & request.cookies("aoyi")("username") & "'"
	rsCheckLogin.open strSqlCheckLogin,G_CONN,1,1
	if rsCheckLogin.bof and rsCheckLogin.eof then
		checkStudentLogin = false
	end if
	rsCheckLogin.close
	set rsCheckLogin = nothing
end function

'显示课程选择列表
sub showCourseList(SelectedID)
	dim rsCourse,strSqlCourse
	
	set rsCourse = server.createobject("ADODB.Recordset")
	strSqlCourse = "select * from course"
	rsCourse.open strSqlCourse,G_CONN,1,1
	response.write "<select name='courseid' style='width:130px;'>" & vbcrlf
	response.write "<option value='0'>---所有课程---</option>"
	while not rsCourse.eof
		response.write "<option "
		if rsCourse("courseid") = SelectedID then
			response.write "selected"
		end if
		response.write " value='" & rsCourse("courseid") & "'>" & rsCourse("coursename") & "</option>" & vbcrlf
		rsCourse.movenext
	wend
	response.write "</select>"
	rsCourse.close
	set rsCourse = nothing
end sub

'显示错误信息
sub showErrMsg(strErrMsg)
%>
	<table align="center" width="500" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF" class="tborder">
		<tr class="tdtbg">
			<td align="center">
				<font color="#FFFFFF">&nbsp;操&nbsp;作&nbsp;失&nbsp;败&nbsp;</font>
			</td>
		</tr>
		<tr class="tdbg">
			<td align="center">
				操作没有成功，可能由于以下原因：<br>
				<%=strErrMsg%>
			</td>
		</tr>
		<tr class="tdbg">
			<td height="30" align="center">
				<input type="button" onClick="history.go(-1);" value="&nbsp;返回上一页&nbsp;">
			</td>
		</tr>
	</table>	
<%
end sub

'显示页面控制
sub showPageCtrl(intMaxPage,intCurPage,strUrl)
	dim I
	if intCurPage > 1 then
		response.write "<a href='" & strUrl & "1'>首页</a>&nbsp;&nbsp;<a href='" & strUrl & intCurPage - 1 & "'>上一页</a>&nbsp;&nbsp;"
	else
		response.write "首页&nbsp;&nbsp;上一页&nbsp;&nbsp;"
	end if
	response.write "第 <font color='red'>" & intCurPage & "</font>/" & intMaxPage & " 页&nbsp;&nbsp;"
	if intCurPage < intMaxPage then
		response.write "<a href='" & strUrl & intCurPage + 1 & "'>下一页</a>&nbsp;&nbsp;<a href='" & strUrl & intMaxPage & "'>尾页</a>&nbsp;&nbsp;"
	else
		response.write "下一页&nbsp;&nbsp;尾页&nbsp;&nbsp;"
	end if
	response.write "跳转到：<select onChange=""window.open('" & strUrl & "' + this.value,'_self');"">"
	for I = 1 to intMaxPage
		response.write "<option value='" & I & "'>第 " & I & " 页</option>"
	next
	response.write "</select>"
end sub

'生成试卷
function makePaper(intPrjID,intStudentID)
	dim rsPaper,strSqlPaper,rsNew,strSqlNew,intCourseID,intCount,arrTemp,intSSCount,arrSS,intMSCount,arrMS,intBCount,arrB,intCurType,I,J,intPos,blnPass
	G_CONN.execute "delete from prj_process where prjid=" & intPrjID & " and studentid=" & intStudentID
	set rsPaper = server.createobject("ADODB.Recordset")
	strSqlPaper = "select courseid,ss_count,ms_count,b_count from project where prjid=" & intPrjID
	rsPaper.open strSqlPaper,G_CONN,1,1
	if not rsPaper.bof and not rsPaper.eof then
		intCourseID = rsPaper("courseid")
		intSSCount = rsPaper("ss_count")
		intMSCount = rsPaper("ms_count")
		intBCount = rsPaper("b_count")
	else
		rsPaper.close
		set rsPaper = nothing
		makePaper = false
		exit function
	end if
	rsPaper.close
	for intCurType = 1 to 3
		select case intCurType
		case 1
			intCount = intSSCount
		case 2
			intCount = intMSCount
		case 3
			intCount = intBCount
		end select
		if intCount > 0 then
			redim arrTemp(intCount)
			strSqlPaper = "select id from subject where type=" & intCurType & " and courseid=" & intCourseID
			rsPaper.open strSqlPaper,G_CONN,1,1
			if rsPaper.recordcount < intCount then	'判断当前题库内试题是否足够
				rsPaper.close
				set rsPaper = nothing
				makePaper = false
				exit function
			end if
			randomize timer
			intPos = int(rnd() * rsPaper.recordcount)
			arrTemp(1) = intPos
			for I = 2 to intCount
				intPos = int(rnd() * rsPaper.recordcount)
				blnPass = false
				while blnPass = false
					for J = 1 to I - 1
						if intPos = arrTemp(J) then
							exit for
						end if
					next
					if J = I then
						blnPass = true
					else
						'使用线性探测解决冲突问题
						intPos = intPos + 1
						if intPos = rsPaper.recordcount then
							intPos = 0
						end if
					end if
				wend
				arrTemp(I) = intPos
			next
			strSqlNew = "select * from prj_process"
			set rsNew = server.createobject("ADODB.Recordset")
			rsNew.open strSqlNew,G_CONN,1,3
			for I = 1 to intCount
				rsPaper.move arrTemp(I),1
				rsNew.addnew
				rsNew("prjid") = intPrjID
				rsNew("subid") = rsPaper("id")
				rsNew("studentid") = intStudentID
				rsNew.update
			next
			rsNew.close
			rsPaper.close
		end if
	next
	G_CONN.execute "update prj_student set state=2"
	G_CONN.execute "update prj_student set starttime=now()"
	set rsPaper = nothing
	makePaper = true
end function

function score(intPrjID,intStudentID)
	dim dtmStartTime,dtmEndTime,intMark,intLimitTime
'首先判断此试卷能否进行打分处理
	if G_CONN.execute("select count(*) as reccount from prj_student where state<>1 and "_
& "prjid=" & intPrjID & " and studentid=" & intStudentID)("reccount") = 0 then
	  score = false
	else
    '取得此考试的限制时间及进行考试的开始时间并计算出考试的结束时间
	  intLimitTime = G_CONN.execute("select limittime from project where prjid=" _
& intPrjID)("limittime")
	  dtmStartTime = G_CONN.execute("select starttime from prj_student where prjid=" _
& intPrjID & " and studentid=" & intStudentID)("starttime")
	  if DateDiff("n",dtmStartTime,Now()) > intLimitTime then
	    dtmEndTime = FormatDatetime(dtmStartTime,2) & " " _
& FormatDatetime(TimeSerial(Hour(dtmStartTime),Minute(dtmStartTime) _
+ intLimitTime,Second(dtmStartTime)),3)
	  else
		dtmEndTime = Now()
	  end if
'计算出考试试卷的得分
	  intMark = G_CONN.execute("select count(*) as recmark from prj_process P_P,subject "_
& "S where P_P.answer=S.answer and P_P.prjid=" & intPrjID & " and P_P.studentid=" _
& intStudentID & " and P_P.subid=S.id and (S.type=1 or S.type=3)")("recmark")
	  intMark = intMark + G_CONN.execute("select count(*)*2 as recmark from prj_process"_
& " P_P,subject S where P_P.answer=S.answer and P_P.prjid=" & intPrjID _
& " and P_P.studentid=" & intStudentID & " and P_P.subid=S.id and S.type=2")("recmark")
'将得分填入考试计划考生表（prj_student）并修改考试状态为已考
	  G_CONN.execute "update prj_student set state=1,endtime=#" & dtmEndTime _
& "#,mark=" & intMark & " where prjid=" & intPrjID & " and studentid=" & intStudentID
	  score = true
	end if
end function
%>