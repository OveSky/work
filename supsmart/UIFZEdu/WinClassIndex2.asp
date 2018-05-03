<%
session.codepage=65001
response.charset="utf-8"
server.scripttimeout=999999	
dim RedirectTo
RedirectTo="WinClassIndex2.asp"
%>
<!--#include virtual="supsmart/VipOrderWin.asp"-->

<%if MO_Win>=1 then%>

	<!--#include file="../inc/myFun.asp"-->
	<html><head>
			<meta charset="utf-8">
			<title>优典集团丰正校区管理系统-学员排课桌面看板</title>
			
			<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=3,user-scalable=yes">
			<meta name="apple-mobile-web-app-capable" content="yes">
			<meta name="apple-mobile-web-app-status-bar-style" content="black">
			
			<link rel="stylesheet" href="../css/MYstyle.css">
			<link rel="stylesheet" href="../css/MoreTag.css">
			
			<SCRIPT type="text/javascript" src="../js/calendar.js"></SCRIPT>
			<SCRIPT type="text/javascript" src="../js/ss.Public.js"></SCRIPT>
			<script type="text/javascript">
			
			//筛选选项展开
			function CheckSX(obj){	
				if(document.getElementById("SX").style.display=='none'){document.getElementById("SX").style.display='block';}
				else{document.getElementById("SX").style.display='none';}
			}
				
			//筛选选项 全职兼职
			function QJChange(obj){
					var objV=obj.value;
					switch(objV){
					case "全职兼职":
						obj.value="全职";
						break;
					case "全职":
						obj.value="兼职";
						break;
					case "兼职":
						obj.value="全职兼职";
						break;
					}
				}
			
			
				//增单区块展开/隐藏
	
			</script>		
			<style>
				 table{  
			        border-collapse: collapse;  
			        border: 0px solid #999;  
			    }  
			      
			    table td {  
			        border-top: 0;  
			        border-right: 1px solid #999;  
			        border-bottom: 1px solid #999;  
			        border-left: 0;  
			    }  
			      
			    table tr.lastrow td {  
			        border-bottom: 0;  
			    }  
			      
			    table tr td.lastCol {  
			        border-right: 0;  
			    } 
				th{width: 200px;}
				td{height: 16px;}
				span{font-size: 12;}
				.tdcolor{background-color: whitesmoke;}
				.smallW{width: 1px;border-right-style:none;border-top-style:none;font-size: 8;} 
				.smallW2{width: 1px;border-left-style:none;border-top-style:none;font-size: 8;color:blue;}   /*border-bottom-style:none  border-left-style:none*/
				.Find{width: 80px;font-size: 12px;color: blue;}
				
			</style>
	
	</head>
				
	<%
	
	
	dim SqlR(),TeaName(),StuName()
	ReDim Preserve SqlR(200,20)	
	'ReDim Preserve TeaName(100,5)	
	ReDim Preserve StuName(1000,10)	
	
	
	StuNameSX=""
	gradeSX="初三"
	if len(request.form("grade"))>0 then
		StuNameSX=request.form("StuName")
		session("StuNameSX")=request.form("StuName")
		if len(StuNameSX)>0 or request.form("grade")="ALL" then
			gradeSX=""
		else
			gradeSX=request.form("grade")
		end if
	end if
	
	
	
	
	'查询学生及数量'
	RSQL="SELECT TOP (100) PERCENT dbo.Student.StuID, dbo.Student.Name, dbo.Student.年级, dbo.Student.课时性质, dbo.Student.购买总课时, dbo.Student.销课总课时, dbo.Student.剩余课时, dbo.Student.备注,  dbo.Student.状态  FROM dbo.Student LEFT OUTER JOIN  dbo.Data ON dbo.Student.年级 = dbo.Data.数据  WHERE (dbo.Student.Name LIKE N'%"&session("StuNameSX")&"%') AND (dbo.Student.年级 LIKE N'%"&gradeSX&"%') AND (dbo.Student.状态 <> 4)  ORDER BY dbo.Data.数据编号 DESC, dbo.Student.课时性质, dbo.Student.Name"
	Set RConn=Server.CreateObject("SsFadodb.SsFConn")
	set Rrs=RConn.Rs("S","SsF",RSQL,1)
	Rn=0
	Ri=1
	do While not Rrs.eof	
		for Ri=1 to 9
			StuName(Rn+2,Ri)=Rrs(Ri-1)		
		next
		Rrs.MoveNext
		Rn=Rn+1
	Loop
	StuName(0,3)=Rn
	Rrs.close:set Rrs=nothing
	set RConn=nothing
			
	%>
	
	
	
	
	<a name="top" id="top"></a>
	<div class="fixed"  style="width: 90px;">
		<li ><a href="#top"><span class="bo7">返回顶部</span></a></li>
		
		<li ><a onclick="CheckSX(this);" ><span class="bo6">高级</span></a></li>
	<%
		'周报 筛选起始日期'老师/全职兼职 
		'日报'
		
		if len(session("Bday"))<=0 then
			session("Bday")=FormatDate(now()-1,2)
		end if
		if len(request.form("Bday"))>0  then
			session("Bday")=FormatDate(request.form("Bday"),2)
		end if
		
	%>
		<ul id="SX" style="display:none;left:5">
			<li ><a onclick="WStuOpen(this);" ><span class="bo7">加学员</span></a></li>
			<!--<li ><a onclick="WStuMOpen(this);" ><span class="bo8">学员管理</span></a></li>-->
			<li ><a href="WinClassIndex.asp"><input type="button" value="切换到教师单周排课界面"> </a></li>
			<li ><a href="WinClassIndex1to4W.asp"><input type="button" value="切换到单老师4周排课界面"> </a></li>
			<li ></li>
			
		<form action="WinClassIndex2.asp"  name="form1" method="post"  target="_self" >
			<li ><span class="bo8">筛选</span></li>
			<li ><input	class="Find" type="text" name="StuName"  placeholder="学生名关键字" value="<%=session("StuNameSX")%>">  </li>
			<li style="display: inline;">
				<select class="Find" name="grade" id="grade">
					<option value="<%=gradeSX%>" selected><%=gradeSX%></option>
					<option value="ALL" >全部</option>
						<%
						Set Conn=Server.CreateObject("SsFadodb.SsFConn")
						SQL="SELECT  TOP (100) PERCENT 数据  FROM   dbo.Data WHERE  (类别编号 = 1) AND (作废标示 IS NULL)  ORDER BY 数据编号"
						set rs=Conn.Rs("S","SsF",SQL,1)
						do While not rs.eof	
						%>
					<option value="<%=rs(0)%>" ><%=rs(0)%></option>
						<%  rs.MoveNext
						Loop
						rs.close:set rs=nothing
						set conn=nothing	
						%>
				</select>
			</li>
			
			<li ><input	class="Find" type="text" name="Bday"  onclick=SelectDate(this); value="<%=session("Bday")%>" >  </li>
			
			<li ><input	class="Find" type="submit" value="点击筛选">  </li>
		</form>	
		</ul>
	</div>
	
	
	<%'RedirectTo="WinClassIndex2.asp"%>
	
	
	
	<table border="1">
		
		
		
		<%FOR i=1 TO StuName(0,3)%>
		<tr><td style="width: 50px;" id="T<%=StuName(1+i,1)%>">
			<%=StuName(1+i,2)%><br>
			<span class="bo bo9"><%=StuName(1+i,3)%></span><br>
			<%=StuName(1+i,7)%>
		</td>
			
			
			
			
			<%
			'单个学员排课单
			SqlR(0,0)=3
			SqlR(2,0)=14		
			'0Class.ClaID, 1dbo.Class.上课人数, 2dbo.employee.name AS 老师, 3dbo.Class.科目, 4dbo.Student.年级, 5dbo.Class.日期, 6dbo.Class.上课时间, 7dbo.Class.下课时间, 8dbo.Class.备注, 9dbo.Student.Name AS 学员, 10dbo.ClassMatch.课程类型,11 dbo.Student.课时性质, 12dbo.employee.EmpID, 14dbo.Student.StuID 
			SqlR(1,0)=201	
			
			for n=1 to 20
				sqlR(2,n)=NULL
			next
			sqlR(2,2)=StuName(1+i,2)	
			sqlR(2,5)=session("Bday")
			sqlR(2,6)=cdate(session("Bday"))+7		
			%>
			<!--#include file="myFun_SqlRefresh.asp"-->
			<%
			C_i=2	
			
			
				
			FOR ii=1 TO 7
			if weekday(cdate(session("Bday"))+ii-1,2)>=6 Then
				tdcolor="Lime"
			Else
				tdcolor="#FFFFFF"
			end if
			%>
			
			<td>
				<table border="0">
					<tr style="background-color:<%=tdcolor%>;"><th >
						<%=month(cdate(session("Bday"))+ii-1)%>月<%=day(cdate(session("Bday"))+ii-1)%>日  <%=CHWeek(cdate(session("Bday"))+ii-1)%>
						<td></td>
					</th></tr>
		
					<tr>
						<%
						
						
						
						
						for hi=7 to 21
							if SqlR(0,3)=0 then
								%><tr><td onclick="CheckClose(this);"></td><td class="smallW" style="background-color:<%=tdcolor%>;" ><%=hi%></td></tr><%
							else
								CDay=FormatDate(cdate(SqlR(C_i,6)),2)
								CBhour=hour(SqlR(C_i,7))
								ChourNum=round((Cdate(SqlR(C_i,8))-cdate(SqlR(C_i,7)))*24,0)
								
			
								
								if cdate(CDay)<>cdate(session("Bday"))+ii-1 or C_i-1>SqlR(0,3) or SqlR(C_i,4)=""  then
									%>								
									<tr><td  onclick="CheckClose(this);"></td><td class="smallW" style="background-color:<%=tdcolor%>;"><%=hi%></td></tr><%
								else
									if 	CBhour>hi then
										%><tr><td  onclick="CheckClose(this);"></td><td  class="smallW" style="background-color:<%=tdcolor%>;"><%=hi%></td></tr><%	
									else
										if CBhour<hi then
											CBhour=hi
										end if
										%><tr  border="1" <%if Cdate(SqlR(C_i,7))<Cdate(SqlR(C_i-1,8)) then%>style="background-color: red;"<%end if%>>
						
										
										
											<td rowspan=<%=ChourNum%> id="DelC<%=SqlR(C_i,1)%>">
												<span class="bo bo5"><%=SqlR(C_i,4)%><%=FormatDate(cdate(SqlR(C_i,7)),4)%>-<%=FormatDate(cdate(SqlR(C_i,8)),4)%></span><span class="bo bo7"><%=SqlR(C_i,3)%></span><span class="bo bo6"><%=SqlR(C_i,12)%></span>
											</td>
											<%for n=1 to ChourNum%>
												<td class="smallW2" ><%=hi+n-1%></td></tr>
												
											<%next
											hi=hi+ChourNum-1
											C_i=C_i+1
											%>
										</tr><%
										
									end if	
									
								end if
							end if
						next
						%>
					</tr>
				</table>
				
				
			</td>
			<%NEXT%>
		</tr>
		<tr ><td colspan="15" style="background-color:gray;height: 2px;"></td></tr>
		<%
			for m=1 to SqlR(0,3)
				SqlR(m+1,4)=""
			next
		
		
		NEXT%>
		
	</table>
	
	
	
	
	
	
	
	
	
	
	
	
	</html>
<%END IF%>