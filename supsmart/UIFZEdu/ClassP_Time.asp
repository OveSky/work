
	<!--js选择菜单HEAD部分-->
	<link rel="stylesheet" type="text/css" href="../css/mui.picker.min.css" />
	<link href="../css/mui.picker.css" rel="stylesheet" />
	<link href="../css/mui.poppicker.css" rel="stylesheet" />
		
	
<!--#include file="../inc/myFun.asp"-->
	<%
	'myFun_SessionRefresh 接口数据'
	'myFun接口初始定义'
	dim SesR()
	ReDim Preserve SesR(10,4) 
	SesR(0,0)=1	'接口类型'JS选择控件预存数据
	SesR(0,1)=5	'定义缓存数量'
	
	SesR(1,1)="lesson"		'每组名称'
	SesR(1,2)="选择课程"		'session的显示默认值'
	SesR(2,1)="grade"		
	SesR(2,2)="选择年级"		
	SesR(3,1)="Date1"		
	SesR(3,2)="选择日期"		
	SesR(4,1)="Time1"		
	SesR(4,2)="上课时间"			
	SesR(5,1)="Time2"		
	SesR(5,2)="下课时间"			
	%>
	<!--#include file="myFun_SessionRefresh.asp"-->
		
	
	
	 
		<div class="mui-content">
			<div class="mui-card" align="center">
				<ul class="mui-table-view">
					<form action="ClassAddTea.asp" method="post"  target="_self">
						<li class="mui-table-view-cell mui-collapse">
							
							
							<div class="mui-input-group">
								<fieldset>
									 
									<div  align="center">
										<tr class="trcenter">
											<td  align="center">
												<input type="button" id="lessonX"  value="<%=Session("lessonV")%>">
												<input type="hidden" id="lesson" name="lesson" value="<%=Session("lesson")%>">
											</td>
											<td  align="center">
												<input type="button" id="gradeX" value="<%=Session("gradeV")%>">
												<input type="hidden" id="grade" name="grade" value="<%=Session("grade")%>">
											</td>
										</tr>
									</div>
								
									<div class="mui-input-row">
										<input type="button" id="Date1X" data-options='{"type":"date"}' class="btn" value="<%=Session("Date1V")%>">	
										<B><%=CHWeek(Session("Date1V"))%></B>
										<input type="hidden" id="Date1" name="Date1" value="<%=Session("Date1")%>">
									</div>
									<div  align="center">
										<tr  class="trcenter">
											<td  align="center">
												<input type="button" id='Time1X' data-options='{"type":"time"}' class="btnT1" value="<%=Session("Time1V")%>">
												<input type="hidden" id="Time1" name="Time1" value="<%=Session("Time1")%>">
											</td>
											<td  align="center">
												<input type="button" id='Time2X' data-options='{"type":"time"}' class="btnT2" value="<%=Session("Time2V")%>">
												<input type="hidden" id="Time2" name="Time2" value="<%=Session("Time2")%>">
											</td>
										</tr>
									</div>
								</fieldset>
								
								</div>
						</li>
							<%dim KK
								IF left(Session("Date1V"),2)="选择" THEN
									KK="确定"
								Else
									KK="修改"
								END IF
							%>
							<input type="submit" value="<%=KK%>">
						
					</form>	
					
					
					
					
					
					
	

		<!--js选择菜单END部分-->
		<script src="../js/mui.picker.min.js"></script>
		<script src="../js/mui.picker.js"></script>
		<script src="../js/mui.poppicker.js"></script>
		<script src="../js/ss.XZLesson.js"></script>
		<script src="../js/ss.XZgrade.js"></script>
		<script src="../js/ss.XZdate1.js"></script>
		<script src="../js/ss.XZTime1.js"></script>
		<script src="../js/ss.XZTime2.js"></script>
		
