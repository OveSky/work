<%
session.codepage=65001
response.charset="utf-8"
server.scripttimeout=999999	
dim RedirectTo
RedirectTo="WinClassIndex1to4W.asp"
%>
<!--#include virtual="supsmart/VipOrderWin.asp"-->

<%if MO_Win>=1 then%>
	<!--#include file="../inc/myFun.asp"-->
	<html><head>
			<meta charset="utf-8">
			<title>优典集团丰正校区管理系统-教师4周排课桌面看板</title>
			
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
			//筛选选项 全职兼职
			function TCChange(obj){
					var objV=obj.value;
					switch(objV){
					case "全部显示":
						obj.value="有问题";
						break;
					case "有问题":
						obj.value="全部显示";
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
	ReDim Preserve TeaName(100,5)	
	ReDim Preserve StuName(1000,5)	
	
	
	TeaNameSX=""
	
	JobT=""
	if len(request.form("JobT"))>0 then
		TeaNameSX=request.form("TeaName")
		session("TeaNameSX")=request.form("TeaName")
		if request.form("JobT")="全职兼职" then
			JobT=""
		else
			JobT=request.form("JobT")
		end if
	end if
	
	
	
	'查询老师 及数量'
	
	if request.form("TeaConfirm")="有问题" then
		RSQL="SELECT     TOP (100) PERCENT ClaID, 老师, 教师科目, 科目, 教师确认标示, 教师确认备注  FROM dbo.vw_ClassView  WHERE (日期 > CONVERT(DATETIME, '2018-01-01', 102)) AND (教师确认标示 = 3 OR 教师确认标示 = 4)"
	else
		RSQL="SELECT EmpID, name,教师科目,职务  FROM  employee WHERE (职务 LIKE N'%老师%') and (name LIKE N'%"&session("TeaNameSX")&"%') and (职务 LIKE N'%"&JobT&"%')  ORDER BY 职务 DESC,教师科目,EmpID"
	end if	
		
	Set RConn=Server.CreateObject("SsFadodb.SsFConn")
	set Rrs=RConn.Rs("S","SsF",RSQL,1)
	Rn=0
	do While not Rrs.eof	
		for Ri=1 to 4
			TeaName(Rn+2,Ri)=Rrs(Ri-1)
		next
		if TeaName(Rn+2,3)="" then
			TeaName(Rn+2,3)="选择科目"
		end if
		Rrs.MoveNext
		Rn=Rn+1
	Loop
	TeaName(0,3)=Rn
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
			<li ><a onclick="WTeaOpen(this);" ><span class="bo7">加教师</span></a></li>
			<!--<li ><a onclick="WTeaMOpen(this);" ><span class="bo8">教师管理</span></a></li>-->
			<li ><a href="WinClassIndex.asp"><input type="button" value="切换到教师单周排课界面"> </a></li>
			<li ><a href="WinClassIndex2.asp"><input type="button" value="切换到学生查询界面"> </a></li>
			
			<li ></li>
		
		<form action="WinClassIndex1to4W.asp"  name="form1" method="post"  target="_self" >
			<li ><span class="bo8">筛选</span></li>
			<li ><input	class="Find" type="text" name="TeaName"  placeholder="老师名关键字" value="<%=session("TeaNameSX")%>">  </li>
			<li ><input	class="Find" type="text" name="JobT" onclick="QJChange(this);"  value="全职兼职" readonly="true">  </li>
			<li ><input	class="Find" type="text" name="TeaConfirm" onclick="TCChange(this);"  value="全部显示" readonly="true">  </li>
			<li ><input	class="Find" type="text" name="Bday"  onclick=SelectDate(this); value="<%=session("Bday")%>" >  </li>
			
			<li ><input	class="Find" type="submit" value="点击筛选">  </li>
		</form>	
		
		</ul>
	</div>
	
	
	<%RedirectTo="WinClassIndex1to4W.asp"%>
	<!--#include file="WinStuAdd.asp"-->
	<!--#include file="WinTeaAdd.asp"-->
	<!--#include file="WinClaAdd.asp"-->
	
	
	
	<table border="1">
		
		<tr><td colspan="3"></td><td colspan="10" style="align-content: center;"><%=TeaName(2,1)%><input type="button" onclick="location.href='PostMsg.asp?RTo=WinClassIndex1to4W&EmpID=<%=TeaName(2,1)%>&MsgType=1'" value="回复老师已修改完毕"> </td></TR>
		
		<%
			dim Bday4
			Bday4=cdate(session("Bday"))
			FOR i=1 TO 4
				TeaName(1+i,1)=TeaName(2,1)
				TeaName(1+i,2)=TeaName(2,2)
				TeaName(1+i,3)=TeaName(2,3)
				%>
			<tr><td style="width: 10px;" id="T<%=TeaName(1+i,1)%>"><%=TeaName(1+i,2)%>
				
				
				
				
				<%
				'单个老师排课单
				SqlR(0,0)=3
				SqlR(2,0)=19		
				'ClaID,老师, 教师科目, 科目, 年级, 6日期, 7上课时间, 8下课时间, 9上课人数, 10学员1, 11课程类型1, 学员2, 课程类型2, 学员3, 课程类型3, 16备注,锁单标示,18教师确认标示,19教师确认备注
				SqlR(1,0)=202 	
				
				for n=1 to 20
					sqlR(2,n)=NULL
				next
				sqlR(2,2)=TeaName(1+i,2)	
				sqlR(2,5)=Bday4
				sqlR(2,6)=Bday4+7
				
				if request.form("TeaConfirm")="有问题" then
					sqlR(2,7)="Problem"
				end if
				sqlR(4,0)="  日期,上课时间"
				%>
				<!--#include file="myFun_SqlRefresh.asp"-->
				<%'RSQL%>
				
				</td><%
				C_i=2	
				
				
					
				FOR ii=1 TO 7
				if weekday(Bday4+ii-1,2)>=6 Then
					tdcolor="Lime"
				Else
					tdcolor="#FFFFFF"
				end if
				
				'锁单条件'////////////////////////////////////////////////////////////////////////////
				DayLock=0
				CheckOpenLock="CheckOpen(this)"
				if (now()-30)> (Bday4+ii-1) then
					DayLock=1
					CheckOpenLock=""
				end if
				
				
				%>
				
				<td>
					<table border="0">
						<tr style="background-color:<%=tdcolor%>;"><th >
							<%if DayLock=1 AND MO_Win<9 then%>
								<img src="../images/lock.png" />											
							<%end if%>
							<%=month(Bday4+ii-1)%>月<%=day(Bday4+ii-1)%>日  <%=CHWeek(Bday4+ii-1)%>
							<td></td>
						</th></tr>
			
						<tr>
							<%
							
							
							
							
							for hi=7 to 21
								ToWinInf0=TeaName(1+i,1)&"_"&TeaName(1+i,2)&"_"&FormatDate(Bday4+ii-1,2)&"_"&hi&"_"&TeaName(1+i,3)
								ToWinInf1=""
								if SqlR(0,3)=0 then
									%><tr><td onclick="CheckClose(this);"></td><td class="smallW" style="background-color:<%=tdcolor%>;" onclick="<%=CheckOpenLock%>;" id="<%=ToWinInf0%>"><%=hi%></td></tr><%
								else
									CDay=FormatDate(cdate(SqlR(C_i,6)),2)
									CBhour=hour(SqlR(C_i,7))
									ChourNum=round((Cdate(SqlR(C_i,8))-cdate(SqlR(C_i,7)))*24,0)
									
				
									
									if cdate(CDay)<>Bday4+ii-1 or C_i-1>SqlR(0,3) or SqlR(C_i,4)=""  then
										%>								
										<tr><td  onclick="CheckClose(this);"></td><td class="smallW" style="background-color:<%=tdcolor%>;" onclick="<%=CheckOpenLock%>;" id="<%=ToWinInf0%>"><%=hi%></td></tr><%
									else
										if 	CBhour>hi then
											%><tr><td  onclick="CheckClose(this);"></td><td  class="smallW" style="background-color:<%=tdcolor%>;" onclick="<%=CheckOpenLock%>;" id="<%=ToWinInf0%>"><%=hi%></td></tr><%	
										else
											if CBhour<hi then
												CBhour=hi
											end if
											%>
											<%dim TCtypeColor
											TCtypeColor="white"
											if Cdate(SqlR(C_i,7))<Cdate(SqlR(C_i-1,8)) or SqlR(C_i,18)=4 then
												TCtypeColor="red"
											else
												if SqlR(C_i,18)=3 then
													TCtypeColor="yellow"
												end if
											end if
											select case true
												case Cdate(SqlR(C_i,7))<Cdate(SqlR(C_i-1,8)) or SqlR(C_i,18)=4
													TCtypeColor="red"
												case SqlR(C_i,18)=3
													TCtypeColor="yellow"
												case SqlR(C_i,18)=1 
													TCtypeColor="Aqua"
											end select
											%>
											<tr  border="1" style="background-color: <%=TCtypeColor%>;">
												<TD	 rowspan=<%=ChourNum%>  style="display: none;" id="Del<%=SqlR(C_i,1)%>">
													<%if SqlR(C_i,18)=1 and MO_Win<9 then%>
														<img src="../images/lock.png" />	
													<%else%>
														<DIV class="bo bo1" onclick="DelClass(this);" id="<%=SqlR(C_i,1)%>,<%=TeaName(1+i,1)%>">作废此课[<%=SqlR(C_i,1)%>]</DIV>
													<%end if%>												
												</TD>
											
											
												<td rowspan=<%=ChourNum%> id="DelC<%=SqlR(C_i,1)%>">
													<%if len(SqlR(C_i,19))>0  then
														if LEFT(SqlR(C_i,19),2)<>"OK" then%>
															<%=SqlR(C_i,19)%><br>
														<%end if%>
													<%end if%>
													
													
													<%IF cint(SqlR(C_i,9))>3 THEN%>
														<div class="item">
															<span class="bo bo5"><%=SqlR(C_i,4)%><%=FormatDate(cdate(SqlR(C_i,7)),4)%>-<%=FormatDate(cdate(SqlR(C_i,8)),4)%>&nbsp;<span class="bo bo6"><%=SqlR(C_i,9)%>人班课</span></span>
															<div class="tooltip">
																<%
																dim AllName
																AllName=""
																RSQL="SELECT dbo.Class.ClaID, dbo.Student.Name FROM dbo.Student RIGHT OUTER JOIN dbo.ClassMatch ON dbo.Student.StuID = dbo.ClassMatch.StuID RIGHT OUTER JOIN  dbo.Class ON dbo.ClassMatch.ClaID = dbo.Class.ClaID  WHERE (dbo.Class.ClaID ="&SqlR(C_i,1)&")"
																Set RConn=Server.CreateObject("SsFadodb.SsFConn")
																set Rrs=RConn.Rs("S","SsF",RSQL,1)
																Rn=0
																do While not Rrs.eof	
																	AllName=AllName&","&Rrs(1)
																	Rrs.MoveNext																
																Loop															
																Rrs.close:set Rrs=nothing
																set RConn=nothing															
																	
																%>
																<p><%=SqlR(C_i,9)%>人:<%=AllName%></p>
																
															</div>
														</div>
													<%ELSE%>
														<span class="bo bo5"><%=SqlR(C_i,4)%><%=FormatDate(cdate(SqlR(C_i,7)),4)%>-<%=FormatDate(cdate(SqlR(C_i,8)),4)%></span>
														<%for m=1 to cint(SqlR(C_i,9))
															if SqlR(C_i,9+m*2)="试听" then%>
																<span class="bo bo7"><%=SqlR(C_i,8+m*2)%></span>
															<%else%>
																<span><%=SqlR(C_i,8+m*2)%></span>
															<%end if%>
														<%next%>
													<%END IF%>											
												</td>
												<%for n=1 to ChourNum%>
													<%if DayLock=1 AND MO_Win<9 then%>
														<td class="smallW2" ><%=hi+n-1%></td></tr>
													<%else%>
														<td class="smallW2"  onclick="CheckDelete(this);" id="<%=SqlR(C_i,1)%>"><%=hi+n-1%></td></tr>
													<%end if%>
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
			
			Bday4=Bday4+7
		NEXT%>
		
	</table>
	
	
	
	
	
	
	
	
	
	
	
	
	</html>
	
<%END IF%>