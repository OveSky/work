		<script type="text/javascript">
		
			//作废单子 提示框
		function DelClass(obj){
			var idx=obj.id;
			
			var Wtemp=idx.split("_");
			var con;
			con=confirm("你确定要作废此单?"); //在页面上弹出对话框
			if(con==true){
				window.location.href="ClassAddTea.asp?R=4&id="+Wtemp[1];
			}
			else
			{
			document.getElementById("Del_"+Wtemp[1]).style.display='none';
			//document.getElementById("DelC"+Wtemp[0]).style.display='block';
			}
		}
		function TeaConfirm(obj){
			var idx=obj.id;
			var Wtemp=idx.split("_");
			document.getElementById("ConfirmWin").style.display='block';
			document.getElementById("TCid").value=Wtemp[1];
		}
		</script>	
		<%'教师确认——————————写入数据库'$$$$$$$$$$$$$$$$$$$$$$$$$$$$
		if Request.querystring("TC")=1 then
			SqlR(1,0)=104
			SqlR(0,0)=12
			
			SqlR(0,2)="Class"
			SqlR(0,3)="ClaID"
			sqlR(0,4)=cint(request.form("TCid"))
			SqlR(3,1)=request.form("TCType")
			SqlR(3,2)=request.form("BZContent")
			%>
			
				<!--#include file="myFun_SqlRefresh.asp"-->
		<%  Response.Redirect(RedirectTo)
		end if%>
		
		
		
		
		
		
		
		<%
		'查询已开课'
		SqlR(0,0)=3
		SqlR(2,0)=19		'列数'.ClaID,上课人数,老师,科目,年级， 日期,上课时间,下课时间, 备注, 学员，课程类型、课时性质,EmpID, StuID,锁单标示,16课时 17教师确认标示  19教师确认备注
		SqlR(3,0)=200		''最大行数  为0表示不设限
		SqlR(1,0)=201 
		'sqlR(2,9)=0		'教师确认标示'  0未确认  1确认正确  3有异议  4作废
		sqlR(2,8)=" dbo.Class.教师确认标示 DESC, dbo.Class.日期 DESC, 老师, dbo.Class.上课时间,dbo.Student.StuID"
		
		%>
		<!--#include file="myFun_SqlRefresh.asp"-->
		
		<%
		session("EmpID")=sqlR(2,13)	
			
		%>
		
		<div class="mui-content">
			
			<div class="mui-card" align="center" style="width:80%; position:fixed; top:80; left:0;z-index:999;display: none;background-color:#DFF0D8" id="ConfirmWin">
				<form action="<%=RedirectTo%>?TC=1"  name="form1" method="post"  target="_self" >
					<div class="mui-input-row mui-radio mui-left">
						<label>已上课  排课对的</label>
						<input name="TCType" id="" type="radio"  value="1" checked>
					</div>
					<div class="mui-input-row mui-radio mui-left">
						<label>有问题  请检查</label>
						<input name="TCType" type="radio"  value="3">
					</div>
					<div class="mui-input-row mui-radio mui-left">
						<label>没上课 作废了</label>
						<input name="TCType" type="radio" value="4">
					</div>
					<div class="mui-input-row" style="margin: 10px 5px;">
						<textarea id="BZContent" name="BZContent" rows="5" placeholder="备注有问题内容"></textarea>
						<br>
						<input  class="Button RedButton Button18" type="submit" value="提交"> 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input  class="Button RedButton Button16" type="button" onclick="location.href='<%=RedirectTo%>'" value="关闭"> 
						<input  type="hidden" id="TCid" name="TCid"> 
					</div>
					
					
				</form>
			</div>
			
			<div class="mui-card" align="center">
				<ul class="mui-table-view mui-table-view-striped mui-table-view-condensed">
					<%
					dim ClaID1,i,ii
					ClaID1=0
					for i=2 to Rn+1
						if ClaID1<>sqlR(i,1) then
							ClaID1=sqlR(i,1)
						
						%>
					<% DIM TCtypeColor
						TCtypeColor="white"
						Select case sqlR(i,17)
							case 0
								TCtypeColor="white"
							case 1
								TCtypeColor="Aqua"
							case 3
								TCtypeColor="yellow"	
						end Select
					%>							
						
					<li class="mui-table-view-cell"  style="background-color:<%=TCtypeColor%>">
				
						<div class="mui-slider-right mui-disabled">
	<!--						<a class="mui-btn mui-btn-red" href="ClassAddTea.asp?V=2&id=<%=sqlR(i,1)%>">修改</a>-->
						<%if MO_CS_Cdel>=9 then%>
							<a class="mui-btn mui-btn-red" onclick="DelClass(this);" id="Del_<%=sqlR(i,1)%>"  >作废</a>
						<%END IF%>
						<%if sqlR(i,17)=0 then%>
							<a class="mui-btn mui-btn-blue" onclick="TeaConfirm(this);" id="Con_<%=sqlR(i,1)%>"  >确认或提疑</a>
						<%END IF%>
						</div>
						
					<div class="mui-slider-handle"  style="background-color:<%=TCtypeColor%>">
						
						<div class="mui-table-cell"  style="background-color:<%=TCtypeColor%>">
							<div class="oa-contact-avatar mui-table-cell">
								<h4><%=sqlR(i,3)%></h4>
							</div>
							<div class="oa-contact-content mui-table-cell">
								<div class="mui-clearfix">
									<button type="button" class="mui-btn"><%=sqlR(i,6)%>
										<span class="mui-badge mui-badge-success"><%=FormatDateTime(sqlR(i,7),4)%></span>
										<span class="mui-badge mui-badge-success"><%=FormatDateTime(sqlR(i,8),4)%></span>
										<span class="mui-badge "><%=round((cdate(FormatDateTime(sqlR(i,8),4))-cdate(FormatDateTime(sqlR(i,7),4)))*24,1)%>h</span>
									</button>
									
								</div>
								<p class="oa-contact-email mui-h6">
									<span class="mui-badge mui-badge-danger"><%=sqlR(i,4)%></span>
									<span class="mui-badge mui-badge-danger"><%=sqlR(i,5)%></span>
									<%for ii=1 to sqlR(i,2)
										if sqlR(i+ii-1,11)="试听" then	%>
											<span class="mui-badge mui-badge-royal"><%=sqlR(i+ii-1,10)%></span>
										<%else%>
											<span class="mui-badge"><%=sqlR(i+ii-1,10)%></span>
									<%
										end if
									next%>
								
								</p>
							</div>
							<%=sqlR(i,19)%>
						</div>
					</div>
					</li>
					<%
						end if
					next%>
				</ul>
				
			</div>		
		</div>
		
		
		
		