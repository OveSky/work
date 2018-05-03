<%
''//''网页数据传递 更新缓存入session 	
''<!--#include file="../inc/myFun_SessionRefresh.asp"-->
''//	'myFun_SessionRefresh 接口数据'
''//	dim SesR(),SesR_i,SesR_j
''//	ReDim Preserve SesR(10,5)  '10是大类 一级   8是小类 二级'
''//	SesR(0,0)=1	'接口类型' 0大类是公共参数


Select case SesR(0,0)
	case 1	'JS选择控件预存数据'
	''//	SesR(0,1)=5	'定义缓存组数量'
	''//	SesR(1,1)="lesson"		'每组名称'
	''//	SesR(1,2)="选择课程"		'session的显示默认值'	
		for SesR_i=1 to SesR(0,1)
		
			if len(request.form(SesR(SesR_i,1)))<=1 and len(Session(SesR(SesR_i,1)))<=1 then
				Session(SesR(SesR_i,1))=0
			else
				if len(request.form(SesR(SesR_i,1)))>1 then
					Session(SesR(SesR_i,1))=request.form(SesR(SesR_i,1))	
				end if
			end if
			if len(Session(SesR(SesR_i,1)))<=1 then
				Session(SesR(SesR_i,1)&"V")=SesR(SesR_i,2)
			else
				Session(SesR(SesR_i,1)&"V")=Session(SesR(SesR_i,1))
			end if
		next
	
	
	case 2	'WEB菜单选择预存数据'XZweb.ASP
		''//SesR(0,0)=2	'接口类型''WEB菜单选择预存数据'
		''//SesR(0,1)=4	'定义缓存大类数量 大类名称为AXZ&Aid
		''//SesR(0,2)=5	'定义缓存小类数量 小类名称为 大类名称_I1 	默认Tea1_I1为Tea1id  Tea1_I2为Tea1Name,以此类推
		''//SesR(1,1)="Tea1"
		''//SesR(1,2)="选择老师"		'session I2的显示默认值'
	
		'判断是否有来源参数'无来源数据赋空值或指定数据
		for SesR_i=1 to SesR(0,1)
			if left(session(SesR(SesR_i,1)&"_I2"),2)="选择" or len(session(SesR(SesR_i,1)&"_I2"))<=0 then
				session(SesR(SesR_i,1)&"_I2")=SesR(SesR_i,2)
			end if
		next	
		
		
		
		'来源数据更新 读取数据库获取关联数据'
		session("Aid")=Request.querystring("Aid")
		session("AXZ")=Request.querystring("AXZ")
		

		
		
		
		'选择'
		if len(Request.querystring("id"))>0 then
			'逐一比对是哪个大类'
			for SesR_i=1 to SesR(0,1)
				if SesR(SesR_i,1)=session("AXZ")&session("Aid") then
					session(SesR(SesR_i,1)&"_I1")=cint(Request.querystring("id"))
					Select case session("AXZ")
					case "Tea"
						SesRSQL="SELECT  EmpID, name, 教师科目, 职务, 备注   FROM  dbo.employee WHERE (EmpID ="&session(SesR(SesR_i,1)&"_I1")&")"
					case "Stu"
						SesRSQL="SELECT StuID, Name, 年级, 课时性质, 剩余课时   FROM  dbo.Student WHERE (StuID = "&session(SesR(SesR_i,1)&"_I1")&")"
					end select
					
					Set SesRConn=Server.CreateObject("SsFadodb.SsFConn")
					set SesRrs=SesRConn.Rs("S","SsF",SesRSQL,1)
					do While not SesRrs.eof	
						for SesR_j=2 to SesR(0,2)
							session(SesR(SesR_i,1)&"_I"&(SesR_j))=SesRrs((SesR_j-1))
						next
					SesRrs.MoveNext
					Loop
					SesRrs.close:set SesRrs=nothing
					set SesRConn=nothing
				
					exit for
				end if
			next
		end if
	
	
		'取消选择'
		if left(session(session("AXZ")&session("Aid")&"_I2"),2)<>"选择" and cint(Request.querystring("id"))=0 then
			session(session("AXZ")&session("Aid")&"_I2")=SesR(SesR_i,2)
				for SesR_j=3 to SesR(0,2)
					session(session("AXZ")&session("Aid")&"_I"&(SesR_j))=""
				next
		end if
	
end	Select 
%>