<!--#include virtual="supsmart/VipOrder.asp"-->


<%
'家长 老师 两种界面'
dim FBType,CMID,FBID,SqlR(),SqlRdate,RSQL,RConn,Rrs,Rn,Ri,i,FBData(),RedirectTo
RedirectTo="FeedbackContent.asp"
ReDim Preserve SqlR(10,20) 
ReDim Preserve FBData(5,20)  '0 CMID, 1 老师名字, 2 学生名字, 3 EmpID, 4 StuID,5 科目, 6 日期, 7 上课时间,8 下课时间, 9 课时, 10 FBid'
FBType=Request.querystring("T")
CMID=Request.querystring("CMID")
FBID=Request.querystring("FBID")
if len(FBType)<1 Then
	Response.Write("请返回上一步！")	
Else
	RSQL="SELECT  dbo.ClassMatch.CMID, dbo.employee.name AS 老师名字, dbo.Student.Name AS 学生名字, dbo.employee.EmpID, dbo.Student.StuID, dbo.Class.科目, dbo.Class.日期, dbo.Class.上课时间, dbo.Class.下课时间, dbo.Class.课时, dbo.Feedback.FBid  FROM dbo.Student RIGHT OUTER JOIN  dbo.Feedback RIGHT OUTER JOIN dbo.ClassMatch ON dbo.Feedback.FBid = dbo.ClassMatch.FBid AND dbo.Feedback.CMID = dbo.ClassMatch.CMID ON dbo.Student.StuID = dbo.ClassMatch.StuID LEFT OUTER JOIN  dbo.employee RIGHT OUTER JOIN  dbo.Class ON dbo.employee.EmpID = dbo.Class.老师ID ON dbo.ClassMatch.ClaID = dbo.Class.ClaID  WHERE  (dbo.ClassMatch.CMID ="&CMID&")"
	Set RConn=Server.CreateObject("SsFadodb.SsFConn")
	set Rrs=RConn.Rs("S","SsF",RSQL,1)
	do While not Rrs.eof	
		for Rn=1 to 10
			FBData(1,Rn)=Rrs(Rn)
		next
		Rrs.MoveNext		
	Loop	
	Rrs.close:set Rrs=nothing
	set RConn=nothing
end if


'//////////////////////////////////////////////////////////////////////////////////////////////'
'第一次查看时间戳' 留言批量添加时间戳




'//////////////////////////////////////////////////////////////////////////////////////////////'

'反馈内容填写 修改'
if Request.querystring("R")=1 then  '' 
	
	if len(FBID)<1 then
		'教师反馈写入'
		SqlR(0,0)=1
		SqlR(0,2)="Feedback"
		SqlR(2,0)=11
		sqlR(3,0)=1
		
		SqlR(1,1)="CMID"
		SqlR(1,2)="主贴ID"
		SqlR(1,3)="发言人姓名"
		SqlR(1,4)="学员姓名"
		SqlR(1,5)="发言人ID"
		SqlR(1,6)="学员ID"
		SqlR(1,7)="反馈时间"
		SqlR(1,8)="反馈关键词"
		SqlR(1,9)="反馈内容"
		SqlR(1,10)="反馈附件"
		SqlR(1,11)="评分"
		
		SqlR(2,1)=CMID
		SqlR(2,2)=0
		for i=1 to 4
			SqlR(2,2+i)=request.form("FB"&i)
		next
		SqlR(2,7)=now()
		SqlR(2,8)=request.form("keyword")
		SqlR(2,9)=request.form("FBCText")
		SqlR(2,10)=""
		SqlR(2,11)=0
		%>
		<!--#include file="myFun_SqlRefresh.asp"-->
		<%
		'查询获得FBID'
		SqlR(0,0)=3
		SqlR(2,0)=1		'列数'
		SqlR(3,0)=1		'行数'
		RSQL="SELECT FBid FROM dbo.Feedback WHERE (CMID ="&CMID&")"
		%>
		<!--#include file="myFun_SqlRefresh.asp"-->
		<%
		'获取查询数据'
		FBID=sqlR(2,1)
		%>
		
	
		<%
		'更新学生排课信息 FBID'
		SqlR(0,0)=2
		SqlR(0,2)="ClassMatch"
		SqlR(0,3)="CMID"  '筛选条件'
		sqlR(0,4)=CMID  '筛选条件'
		SqlR(2,0)=1		' 更新列数'
		
		SqlR(1,1)="FBid"
		SqlR(2,1)=FBID	
		
		%>
		<!--#include file="myFun_SqlRefresh.asp"-->
			
		<%
			
	Else
	'管理者修改'
		SqlR(0,0)=2
		SqlR(0,2)="Feedback"
		SqlR(0,3)="FBid"  '筛选条件'
		sqlR(0,4)=FBID  '筛选条件'
		SqlR(2,0)=4		' 更新列数'
		
		SqlR(1,1)="反馈时间"
		SqlR(1,2)="反馈关键词"
		SqlR(1,3)="反馈内容"
		SqlR(1,4)="反馈附件"
		
		SqlR(2,1)=now()
		SqlR(2,2)=request.form("keyword")
		SqlR(2,3)=request.form("FBCText")
		SqlR(2,4)=""
	%>
	
		<!--#include file="myFun_SqlRefresh.asp"-->
	<%
	
	


	end if
	Response.Redirect(RedirectTo&"?T=Tea&CMID="&CMID&"&FBID="&FBID)
end if

'//////////////////////////////////////////////////////////////////////////////////////////////'

if Request.querystring("R")=2 then  
'家长打分写入'
	if len(request.form("starNumV"))>0 then
		'更新学生排课信息 FBID'
		SqlR(0,0)=2
		SqlR(0,2)="Feedback"
		SqlR(0,3)="FBid"  '筛选条件'
		sqlR(0,4)=FBID  '筛选条件'
		SqlR(2,0)=1		' 更新列数'
		
		SqlR(1,1)="评分"
		SqlR(2,1)=cint(request.form("starNumV"))	
		
		%>
		<!--#include file="myFun_SqlRefresh.asp"-->
		<%
	end if
	
	
'留言写入'
	if len(request.form("FBmessage"))>0 then
		SqlR(0,0)=1
		SqlR(0,2)="Feedback"
		SqlR(2,0)=11
		sqlR(3,0)=1
		
		SqlR(1,1)="CMID"
		SqlR(1,2)="主贴ID"
		SqlR(1,3)="发言人姓名"
		SqlR(1,4)="学员姓名"
		SqlR(1,5)="发言人ID"
		SqlR(1,6)="学员ID"
		SqlR(1,7)="反馈时间"
		SqlR(1,8)="反馈关键词"
		SqlR(1,9)="反馈内容"
		SqlR(1,10)="反馈附件"
		SqlR(1,11)="评分"
		
		SqlR(2,1)=CMID
		SqlR(2,2)=FBID
		SqlR(2,3)=USENAME
		SqlR(2,4)=FBData(1,2)
		if FBType="Stu" then
			SqlR(2,5)=StuID
		else
			SqlR(2,5)=EmpID
		end if
		SqlR(2,6)=FBData(1,4)
		
		SqlR(2,7)=now()
		SqlR(2,8)=""
		SqlR(2,9)=request.form("FBmessage")
		SqlR(2,10)=""
		SqlR(2,11)=0
		%>
		<!--#include file="myFun_SqlRefresh.asp"-->
		<%
		

	end if
	

	Response.Redirect(RedirectTo&"?T="&FBType&"&CMID="&CMID&"&FBID="&FBID)
end if

'//////////////////////////////////////////////////////////////////////////////////////////////'
%>

<html><head>
		<meta charset="utf-8">
		<title>课程反馈内容</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		<!--标准mui.css-->
		<link rel="stylesheet" href="../css/mui.min.css">
		<link rel="stylesheet" href="../css/MYstyle.css">
		<script src="../js/jquery.js"></script>

		<style>
			#starRating .photo span {
			    position: relative;
			    display: inline-block;
			    width: 44px;
			    height: 42px;
			    overflow: hidden;
			    margin-right: 23px;
			    cursor: pointer;
			}
			#starRating .photo span:last-child {
			    margin-right: 0px;
			}
			#starRating .photo span .nohigh {
			    position: absolute;
			    width: 44px;
			    height: 42px;
			    top: 0;
			    left: 0;
			    background: url("../images/star.png");
			}
			#starRating .photo span .high {
			    position: absolute;
			    width: 44px;
			    height: 42px;
			    top: 0;
			    left: 0;
			    background: url("../images/star1.png");
			}
			#starRating .starNum {
			    font-size: 26px;
			    color: #de4414;
			    margin-top: 4px;
			    margin-bottom: 10px;
			}
			#starRating .bottoms {
			    height: 54px;
			    border-top: 1px solid #d8d8d8;
			}
			#starRating .photo {
			    margin-top: 30px;
			}
			#starRating .bottoms a {
			    margin-bottom: 0;
			}
			#starRating .bottoms .garyBtn {
			    margin-right: 57px!important;
			}
			#starRating .bottoms a {
			    width: 130px;
			    height: 35px;
			    line-height: 35px;
			    border-radius: 3px;
			    display: inline-block;
			    font-size: 16px;
			    transition: all 0.2s linear;
			    margin: 16px 0 22px;
			    text-align: center;
			    cursor: pointer;
			}
			.garyBtn {
			    margin-right: 60px!important;
			    background-color: #e1e1e1;
			    color: #999999;
			}
			.blueBtn {
			    background-color: #1968b1;
			    color: #fff;
			}
			.blueBtn:hover {
			    background: #0e73d0;
			}
			
		</style>
		<script type="text/javascript">
		
		</script>    


	</head>
	<body>
		<header class="mui-bar mui-bar-nav">
			<%if FBType="Tea" then%>
				<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"> </a>
				<A href="FeedbackList.asp"><h1 class="mui-title"><%=USENAME%>&nbsp;&nbsp;请及时对学员做课后反馈</h1></A>
			<%else%>
				<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"> </a>
				<A href="StuClassSearch.asp"><h1 class="mui-title"><%=USENAME%>&nbsp;&nbsp;感谢查看课后反馈</h1></A>
			<%end if%>
		</header>	


		<%	
		
		
	
		%>

		<div class="mui-content">
			<div class="mui-card" align="center">
				<ul class="mui-table-view">
					
					<div>
						<ul class="mui-table-view">
							<li class="mui-table-view-cell">
								<span class="bo bo7">
									<%'0 CMID, 1 老师名字, 2 学生名字, 3 EmpID, 4 StuID,5 科目, 6 日期, 7 上课时间,8 下课时间, 9 课时, 10 FBid'
									if FBType="Tea" then%><%=FBData(1,2)%><%else%><%=FBData(1,1)%><%end if%>											
									 &nbsp; &nbsp;
									<span class="bo bo6"><%=FBData(1,5)%></span>
								</span>&nbsp; &nbsp;
								<span class="bo bo7"><%=FBData(1,6)%>&nbsp; &nbsp;
									<span class="bo bo6"><%=FormatDateTime(FBData(1,7),4)%></span> -
									<span class="bo bo6"><%=FormatDateTime(FBData(1,8),4)%></span> 
									<span class="bo bo1"><%=FBData(1,9)%>h</span> 
								</span> 									
						</ul>
					</div> 
					<form action="FeedbackContent.asp?R=1&T=Tea&CMID=<%=CMID%><%if len(FBID)>0 then%>&FBID=<%=FBID%><%end if%>" method="post"  target="_self">
							<%for i=1 to 4%>
								<input type="hidden" name="FB<%=i%>" value="<%=FBData(1,i)%>"  />
							<%next%>
							<div class="mui-card">
								<%
								dim keyword,FBCText
								FBData(2,0)=""
								if len(FBID)>0 then
									'查询获得 keyword,FBCText
									SqlR(0,0)=3
									SqlR(2,0)=5		'列数'
									SqlR(3,0)=1		'行数' 
									RSQL="SELECT 反馈时间, 反馈关键词, 反馈内容, 反馈附件, 评分 FROM dbo.Feedback WHERE (CMID ="&CMID&")"
									%>
									<!--#include file="myFun_SqlRefresh.asp"-->
									<div class="mui-input-row">
										<li><h5 <% if now()-cdate(SqlR(2,1))<1/1440 then%> style="color:blue;" <%end if%>>反馈时间&nbsp;&nbsp;<%=SqlR(2,1)%></h5></li>
									</div>
									<%
									'获取查询数据'
									for i=1 to 5
										FBData(2,i)=sqlR(2,i)
									next
									
									'锁定内容'
									IF VipOrder>80 then
										FBData(2,0)=""
									ELSE
										FBData(2,0)="  readonly="&chr(32)&"true"&chr(32)
									END IF
									
									
									
								else
									for i=1 to 5
										FBData(2,i)=""
									next	
									
									
								end if
								%>
								<div class="mui-input-row">
									<input type="text" id="keyword"  name="keyword" placeholder="填写反馈关键字：简单词组概括" value="<%=FBData(2,2)%>"  <%=FBData(2,0)%>>
								</div>
								
								<div class="mui-input-row" style="margin: 10px 5px;">
									<textarea id="FBCText" name="FBCText" rows="5" placeholder="(暂不支持表情)反馈正文，请表述学员学习情况，并针对性落实后续培训计划；勿有责任推卸给家长之词，谢谢！" <%=FBData(2,0)%>><%=FBData(2,3)%> </textarea>
								</div>
							</div>
							<br>
							
							<%if FBType="Tea" then%>
								<b>注：如发送错误，请及时联系白雪梅老师修改。</b><br>
								<%if len(FBID)<=0 then%>
									<input type="submit"  value="提交反馈">	
								<%else%>	
									<%if VipOrder>80 then%>
										<input type="submit"  value="管理者修改">
									<%end if%>
								<%end if%>
							<%end if%>
					</form>		
							
							
							
							
					<form action="FeedbackContent.asp?R=2&T=<%=FBType%>&CMID=<%=CMID%>&FBID=<%=FBID%>" method="post"  target="_self">
						
						<div id="starRating">
							<%if FBType="Stu" then%>
								<%if cint(FBData(2,5))=0 then%>
								    <p class="photo">
								        <span><i class="high"></i><i class="nohigh"></i></span>
								        <span><i class="high"></i><i class="nohigh"></i></span>
								        <span><i class="high"></i><i class="nohigh"></i></span>
								        <span><i class="high"></i><i class="nohigh"></i></span>
								        <span><i class="high"></i><i class="nohigh"></i></span>
								    </p>
								    <input type="hidden" value="0" id="starNumV" name="starNumV" readonly="true"/>
								    <p class="starNum">0.0分</p>
								<%else%>   
							 	   <p class="starNum"><%=FBData(2,5)%>分</p> 
								<%end if%>
							<%else%>   
							    <p class="starNum"><%=FBData(2,5)%>分</p>
							<%end if%>    
							</div>
					
						<hr>
						
						<div class="mui-card">
							<div class="mui-input-row">
								<h3 class="bo8">留言</h3>
								<div class="mui-input-row" style="margin: 10px 5px;">
									<textarea id="FBmessage" name="FBmessage" rows="5" placeholder="(暂不支持表情)沟通建议"></textarea>
								</div>
							</div>	
							<input type="submit"  value="留言">	
						</div>					
					</form>
					
					<%'’'*****************************************************************************************%>
					<h3 class="bo8">历史留言</h3>
						<%if len(FBID) then
							
							RSQL="SELECT TOP (100) PERCENT 主贴ID, 发言人姓名, 反馈时间, 反馈内容, 反馈附件  FROM  dbo.Feedback  WHERE   (主贴ID ="&FBID&")  ORDER BY 反馈时间 DESC"	
							Set RConn=Server.CreateObject("SsFadodb.SsFConn")
							set Rrs=RConn.Rs("S","SsF",RSQL,1)
							do While not Rrs.eof	
							%>
								<label><h5><%=Rrs(1)%>&nbsp;&nbsp; <%=Rrs(2)%></h5></label>
								<div class="mui-card">
									<div class="mui-input-row">
										<div align="left">
											<li><%=Rrs(3)%></li>
										</div>
									</div>							
								</div>			
							
							<%	Rrs.MoveNext										
							Loop
							Rrs.close:set Rrs=nothing
							set RConn=nothing							
								
						end if
						%>	
					
					
				</ul>
			</div>
		</div>
		

		
				
				
		
		
		
		
		
		<script>
		    $(function () {
		        //评分
		        var starRating = 0;
		        $('.photo span').on('mouseenter',function () {
		            var index = $(this).index()+1;
		            $(this).prevAll().find('.high').css('z-index',1)
		            $(this).find('.high').css('z-index',1)
		            $(this).nextAll().find('.high').css('z-index',0)
		            $('.starNum').html((index*2).toFixed(1)+'分')
		           
		        })
		        $('.photo').on('mouseleave',function () {
		            $(this).find('.high').css('z-index',0)
		            var count = starRating / 2
		            if(count == 5) {
		                $('.photo span').find('.high').css('z-index',1);
		            } else {
		                $('.photo span').eq(count).prevAll().find('.high').css('z-index',1);
		            }
		            $('.starNum').html(starRating.toFixed(1)+'分')
		        })
		        $('.photo span').on('click',function () {
		            var index = $(this).index()+1;
		            $(this).prevAll().find('.high').css('z-index',1)
		            $(this).find('.high').css('z-index',1)
		            starRating = index*2;
		            $('.starNum').html(starRating.toFixed(1)+'分');
		            document.getElementById("starNumV").value=starRating.toFixed(1)
		            //alert('评分：'+(starRating.toFixed(1)+'分'))
		        })
		        //取消评分
		        $('.cancleStar').on('click',function () {
		            starRating = 0;
		            $('.photo span').find('.high').css('z-index',0);
		            $('.starNum').html(starRating.toFixed(1)+'分');
		        })
		        //确定评分
		        $('.sureStar').on('click',function () {
		            if(starRating===0) {
		               // alert('最低一颗星！');
		            } else {
		               //alert('评分：'+(starRating.toFixed(1)+'分'))
		            }
		        })
		    })
		</script>

		<script src="../js/mui.min.js"></script>
		
	
		<script>
			mui.init({
				swipeBack:true //启用右滑关闭功能
			});
		</script>
		
	
	
	
	
	
	
	
	
	
	
	
	
</body>	









</html>