<%
''//''网页数据写入数据库  查询数据库  更新数据库
''<!--#include file="../inc/myFun_SqlRefresh.asp"-->
''//	'myFun_SqlRefresh 接口数据'
''//	dim SqlR(),SqlRdate,RSQL,RSQL1,RConn,Rrs,Rn,Ri
''//	ReDim Preserve SqlR(10,8)  '10是大类 一级   8是小类 二级'
''//	SqlR(0,0)=1	'接口类型' ；
''		SqlR(1,0)	查询用SQL 编码;
''			查询SqlR(1,1)需要的话存储 查询条件变量数量
'		SqlR(2,0)	查询写入变更读取 数据	列数量；
'		sqlR(3,0)	写入变更读取 数据	行数量；查询条件数量
'		sqlR(4,0)	排序条件,全字段

'		SqlRdate 	'数据库' S对应supsmart(默认)   WS对应 wxdateSS；'
'		SqlR(0,2)	写入变更主表名；
'		SqlR(0,3)	查询输出行数；

''大类:		0是公共参数;1表头/SQL条件；2/3……数据   
			'sqlR(2,X)临时条件，数据读出后覆盖
			'' sqlR(3,X)临时条件对应字段类型（1数值	2字符	3日期大于等	4日期小于等于	5日期大于等于且小于等于(只能一个放最后)），数据读出后覆盖
			
'#################################################################################################################'
if len(SqlRdate)<=1 then
	SqlRdate="S"
end if


Select case SqlR(1,0)	''	100-199 通用SQL	201独立SQL
	case 100	'单表简单查询'		'sqlR(0,2)表名'sqlR(1,1)查ID sqlR(1,X)字段名 sqlR(2,X)筛选条件 和字段名X一致； 
		RSQL="SELECT "&sqlR(1,1)
		for Ri=1 to SqlR(2,0)
			RSQL=RSQL&" ,"&qlR(1,Ri)
		next
		RSQL=RSQL&" from "&sqlR(0,2)&" (1=1) "
		RSQL1=""
		for Ri=1 to SqlR(2,0)+1
			if len(sqlR(2,Ri))>0 Then
				Select case sqlR(3,Ri)
					case 1
						RSQL1=RSQL1&"  AND ("&sqlR(1,Ri)&"="&sqlR(2,Ri)&")  "
					case 2
						RSQL1=RSQL1&"  AND ("&sqlR(1,Ri)&" LIKE N'%"&sqlR(2,Ri)&"%')"
					case 3
						RSQL1=RSQL1&"  AND ("&sqlR(1,Ri)&" >='"&sqlR(2,Ri)&"') "
					case 4
						RSQL1=RSQL1&"  AND ("&sqlR(1,Ri)&" <='"&sqlR(2,Ri)&"') "
					case 5
						RSQL1=RSQL1&"  AND ("&sqlR(1,Ri)&" >='"&sqlR(2,Ri)&"') AND ("&sqlR(1,Ri)&" <='"&sqlR(2,Ri+1)&"') "
					
				end Select
			end if
		next
		RSQL=RSQL&RSQL1
		if len(sqlR(4,0))>0 then
			RSQL=RSQL&"  ORDER BY  "&sqlR(4,0)
		end if
		
		
		
	case 101	'获取最大值'	'sqlR(0,2)表名'sqlR(1,1)查最大值字段
		RSQL="SELECT  MAX("&sqlR(1,1)&") AS RMax FROM "&sqlR(0,2)	
	case 102	'作废'		'sqlR(0,2)表名'sqlR(0,3)需作废ID名称  sqlR(0,4)需作废ID
		RSQL="UPDATE "&sqlR(0,2)&" SET 作废标示 = '1',作废时间 = '"&now()&"'  WHERE "&sqlR(0,3)&" = '"& sqlR(0,4)&"'"	
	case 103	'获取字段中 不重复数据的数量'	'sqlR(0,2)表名'sqlR(1,1)查数量字段
		RSQL="SELECT  COUNT("&sqlR(1,1)&") AS RCount FROM "&sqlR(0,2)
	case 104	'教师确认'	'sqlR(0,2)表名'
		RSQL="UPDATE "&sqlR(0,2)&" SET 教师确认标示 = '"& sqlR(3,1)&"',教师确认时间 = '"&now()&"',教师确认备注='"& sqlR(3,2)&"'  WHERE "&sqlR(0,3)&" = '"& sqlR(0,4)&"'"	
		
		
	'################################################################################'
	'////////////////////////////////////////////////////'		
	case 201
		'where: sqlR(2,1) ClaID'	sqlR(2,2) 老师OR学员	;sqlR(2,3)  科目;sqlR(2,4)  年级;sqlR(2,5) sqlR(2,6) 日期开始/截止；sqlR(2,7) 课程类型  sqlR(2,X)临时条件，数据读出后覆盖
		RSQL="SELECT dbo.Class.ClaID, dbo.Class.上课人数, dbo.employee.name AS 老师, dbo.Class.科目, dbo.Student.年级, dbo.Class.日期, dbo.Class.上课时间, dbo.Class.下课时间, dbo.Class.备注, dbo.Student.Name AS 学员, dbo.ClassMatch.课程类型, dbo.Student.课时性质, dbo.employee.EmpID, dbo.Student.StuID,dbo.Class.锁单标示,dbo.Class.课时,dbo.Class.教师确认标示,dbo.Class.教师确认时间,dbo.Class.教师确认备注    FROM  dbo.employee RIGHT OUTER JOIN dbo.Class ON dbo.employee.EmpID = dbo.Class.老师ID LEFT OUTER JOIN dbo.Student RIGHT OUTER JOIN dbo.ClassMatch ON dbo.Student.StuID = dbo.ClassMatch.StuID ON dbo.Class.ClaID = dbo.ClassMatch.ClaID  WHERE (dbo.Class.作废标示 IS NULL) AND (dbo.Class.科目<>N'存课时')  "
		RSQL1=""
		if len(sqlR(2,1))>0 Then
			RSQL1=RSQL1&"  AND (dbo.Class.ClaID ="&sqlR(2,1)&")  "
		end if
		if len(sqlR(2,9))>0 Then
			RSQL1=RSQL1&"  AND (dbo.Class.教师确认标示 ="&sqlR(2,9)&")  "
		end if
		if len(sqlR(2,10))>2 Then
			RSQL1=RSQL1&"  AND ((教师确认标示=3) or (教师确认标示=0))   "
		end if
		if len(sqlR(2,11))>2 Then
			RSQL1=RSQL1&"  AND (教师确认标示=1)   "
		end if
		if len(sqlR(2,2))>0 Then
			RSQL1=RSQL1&"  AND  ((dbo.employee.name LIKE N'%"&sqlR(2,2)&"%') OR (dbo.Student.Name LIKE N'%"&sqlR(2,2)&"%')) "
		end if
		if len(sqlR(2,12))>0 Then
			RSQL1=RSQL1&"  AND  ((dbo.employee.name LIKE N'%"&sqlR(2,12)&"%') OR (dbo.Student.Name LIKE N'%"&sqlR(2,12)&"%')) "
		end if
		if len(sqlR(2,3))>0 Then
			RSQL1=RSQL1&"  AND  (dbo.Class.科目  LIKE N'%"&sqlR(2,3)&"%')"
		end if
		if len(sqlR(2,4))>0 Then
			RSQL1=RSQL1&"  AND  (dbo.Student.年级  LIKE N'%"&sqlR(2,4)&"%')"
		end if
		if len(sqlR(2,5))>0 and len(sqlR(2,6))>0  Then
			RSQL1=RSQL1&"  AND (dbo.Class.日期 >='"&sqlR(2,5)&"')  AND  (dbo.Class.日期 <= '"&sqlR(2,6)&"')  "	
		end if
		if len(sqlR(2,8))>0 then
			RSQL1=RSQL1&" ORDER BY  "&sqlR(2,8)
		Else
			RSQL1=RSQL1&" ORDER BY  dbo.Class.日期, dbo.Class.上课时间"
		end if
		RSQL=RSQL&RSQL1
	
	'////////////////////////////////////////////////////'
	case 202  'vw_ClassView'
		'where: sqlR(2,1) ClaID'	sqlR(2,2) 老师O	;sqlR(2,3)  科目;sqlR(2,4)  年级;sqlR(2,5) sqlR(2,6) 日期开始/截止；sqlR(2,7) 课程类型	sqlR(2,X)临时条件，数据读出后覆盖
		
		RSQL="SELECT  TOP (100) PERCENT ClaID,老师, 教师科目, 科目, 年级, 日期, 上课时间, 下课时间, 上课人数, 学员1, 课程类型1, 学员2, 课程类型2, 学员3, 课程类型3, 备注,锁单标示,教师确认标示,教师确认备注    FROM  dbo.vw_ClassView  WHERE  (上课人数 > 0)  AND (EmpID>0)  "
		RSQL1=""
		if len(sqlR(2,1))>0 Then
			RSQL1=RSQL1&"  AND (ClaID ="&sqlR(2,1)&")  "
		end if
		if len(sqlR(2,2))>0 Then
			RSQL1=RSQL1&"  AND (老师 LIKE N'%"&sqlR(2,2)&"%')  "
		end if
		if len(sqlR(2,3))>0 Then
			RSQL1=RSQL1&"  AND  (教师科目  LIKE N'%"&sqlR(2,3)&"%')"
		end if
		if len(sqlR(2,4))>0 Then
			RSQL1=RSQL1&"  AND  (年级  LIKE N'%"&sqlR(2,4)&"%')"
		end if
		if len(sqlR(2,5))>0 Then
			RSQL1=RSQL1&"  AND (日期 >='"&sqlR(2,5)&"') "	
		end if
		if len(sqlR(2,6))>0 Then
			RSQL1=RSQL1&"  AND (日期 <='"&sqlR(2,6)&"') "	
		end if
		if len(sqlR(2,7))>0 Then
			RSQL1=RSQL1&"  AND ((教师确认标示=3) or (教师确认标示=4))   "
		end if
		if len(sqlR(2,8))>0 Then
			RSQL1=RSQL1&"  AND (教师确认标示=1)    "
		end if
		RSQL=RSQL&RSQL1
		if len(sqlR(4,0))>0 then
			RSQL=RSQL&"  ORDER BY  "&sqlR(4,0)
		end if
end	Select 


'#################################################################################################################'
Select case SqlR(0,0)
	case 12	'SqlR(1,0)中需要更新写入的SQL
		Set RConn=Server.CreateObject("SsFadodb.SsFConn")
		set Rrs=RConn.Rs((SqlRdate),"SsF",RSQL,0)
		set RConn=nothing

	case 1	'写入数据库
		Set RConn=Server.CreateObject("SsFadodb.SsFConn")
		for Rn=1 to SqlR(3,0)
			RSQL="INSERT INTO "&SqlR(0,2)&" ("
			for Ri=1 to SqlR(2,0)-1
				RSQL=RSQL&SqlR(1,Ri)&","
			next
			RSQL=RSQL&SqlR(1,SqlR(2,0))&")"
			RSQL=RSQL&" values ("
			for Ri=1 to SqlR(2,0)-1
				RSQL=RSQL&"'"&SqlR(Rn+1,Ri)&"',"
			next
			RSQL=RSQL&"'"&SqlR(Rn+1,SqlR(2,0))&"')"
			
			set Rrs=RConn.Rs((SqlRdate),"SsF",RSQL,0)
		next
		
		set RConn=nothing
		
	
	
	case 2	'更新数据库 只更新一行	'sqlR(0,2)表名'sqlR(0,3)定位记录的字段名  sqlR(0,4)定位记录的数值
		Set RConn=Server.CreateObject("SsFadodb.SsFConn")
			RSQL="UPDATE "&SqlR(0,2)&" SET "&SqlR(1,1)&"='"&SqlR(2,1)&"'"
			for Ri=2 to SqlR(2,0)
				RSQL=RSQL&","&SqlR(1,Ri)&"='"&SqlR(2,Ri)&"'"
			next
			RSQL=RSQL&" WHERE "&sqlR(0,3)&" = '"&sqlR(0,4)&"'"	
			
			set Rrs=RConn.Rs((SqlRdate),"SsF",RSQL,0)
		
		set RConn=nothing
		
		
		
	
	case 3	'查询数据库  
	''	 SqlR(3,0)为最大行数  为0表示不设限
	
		Set RConn=Server.CreateObject("SsFadodb.SsFConn")
		set Rrs=RConn.Rs((SqlRdate),"SsF",RSQL,1)
		Rn=0
		do While not Rrs.eof	
			for Ri=1 to sqlR(2,0)
				sqlR(Rn+2,Ri)=Rrs(Ri-1)
			next
			Rrs.MoveNext
			if Rn>=SqlR(3,0) and SqlR(3,0)<>0 then
				exit do
			Else
				Rn=Rn+1
			end if
		Loop
		SqlR(0,3)=Rn
		Rrs.close:set Rrs=nothing
		set RConn=nothing
end	Select 
%>