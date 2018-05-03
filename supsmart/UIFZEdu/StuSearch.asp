<script type="text/javascript">
	//年级里学生清单展开关闭
	function GradeOC(obj)
	{
		var idx=obj.id;
		if(document.getElementById(idx+"List").style.display=='none')
		{document.getElementById(idx+"List").style.display='block';}
		else
		{document.getElementById(idx+"List").style.display='none';
		var	SSPVal=document.getElementById("SN00").value;
		document.getElementById("XX").value=SSPVal;
		}
	}
	function StuSearch()
	{
		var	SSVal=document.getElementById("StuSearch").value;
		var	SN00=document.getElementById("SN00").value;
		
		var SStemp=SN00.split(",");
		for(var j=1;j<SStemp.length;j++){
		document.getElementById("SSP_"+j).style.display='none';
		}
		var i=1;
		for(var n=1;n<SStemp.length;n++){
			if(SStemp[n].indexOf(SSVal)!==-1){
				var SSPtemp=SStemp[n].split("/");
				document.getElementById("SSP_"+i).value=SSPtemp[0];
				document.getElementById("SSP_"+i).title=SSPtemp[1];
				document.getElementById("SSP_"+i).style.display='block';
				document.getElementById("SSspan_"+i).innerText=SSPtemp[1];
				i=i+1;
			}
		}
		
		if(SSVal.length==0)
			{
			document.getElementById("StuSearchV1").style.display='block';
			document.getElementById("StuSearchV2").style.display='none';
			}
			else
			{
			document.getElementById("StuSearchV1").style.display='none';
			document.getElementById("StuSearchV2").style.display='block';
			}
			
			document.getElementById("XX").value=document.getElementById("SSP_1").value;
	}
	
	
</script>		

	<div style="float: left;"><input type="text" name="StuSearch" id="StuSearch" value="">	</div>
	<div onclick=StuSearch() ><B class="bo8" style="font-size: 18px;">搜索学生</B></DIV>
	<br>
	<div id="mycard-plus">
		<div class="default-tag tagbtn">
			<%
			
			'查询学生清单 '1StuID 2Name 3年级  4课时性质
			RSQL="SELECT  TOP (100) PERCENT dbo.Student.StuID, dbo.Student.Name, dbo.Student.年级, dbo.Student.课时性质, dbo.Student.状态  FROM         dbo.Student LEFT OUTER JOIN  dbo.Data ON dbo.Student.课时性质 = dbo.Data.数据 LEFT OUTER JOIN  dbo.Data AS Data_1 ON dbo.Student.年级 = Data_1.数据  WHERE   (dbo.Student.状态 <> 4)   ORDER BY Data_1.数据编号 DESC, dbo.Data.数据编号, dbo.Student.StuID DESC"
			Set RConn=Server.CreateObject("SsFadodb.SsFConn")
			set Rrs=RConn.Rs("S","SsF",RSQL,1)
			Rn=0
			StuName(0,0)=""
			do While not Rrs.eof	
				for Ri=1 to 4
					StuName(Rn+2,Ri)=Rrs(Ri-1)
					
				next
				StuName(0,0)=StuName(0,0)&","&StuName(Rn+2,1)&"/"&StuName(Rn+2,2)
				Rrs.MoveNext
				Rn=Rn+1
			Loop
			StuName(0,3)=Rn
			Rrs.close:set Rrs=nothing
			set RConn=nothing%>
			
			<input	type="hidden" name="SN00" id="SN00"  value="<%=StuName(0,0)%>">  
			
			
			<div id="StuSearchV1">
			<div>
			<%for si=2 to StuName(0,3)+1%>
				<%if StuName(si,3)<>StuName(si-1,3) then%>
					</div><div onclick=GradeOC(this) id="Grade<%=si%>" ><B class="bo4" >【<%=StuName(si,3)%>】</B></div><div class="clearfix" id="Grade<%=si%>List" style="display:none">
				<%end if%>
				<%if StuName(si,4)<>StuName(si-1,4) or (StuName(si,4)=StuName(si-1,4) and StuName(si,3)<>StuName(si-1,3)) then%>
					<div><a value="-1"><b style="color: yellow;background-color: black;"><%=StuName(si,4)%></b></a></div>
				<%end if%>
				<a value="<%=StuName(si,1)%>" title="<%=StuName(si,2)%>" href="javascript:void(0);"><span><%=StuName(si,2)%></span><em></em></a>		
			<%next%>
			</div>
			</div>
			<div id="StuSearchV2" style="display: none;">
			<%dim SSPi
				for SSPi=1 to 200%>
					<a value="84" title="xxx" id="SSP_<%=SSPi%>" href="javascript:void(0);" style="display: none;"><span id="SSspan_<%=SSPi%>">xx11x</span><em></em></a>	
				<%next%>
			</div>
			
		</div>
	</div>
	<SCRIPT type="text/javascript" src="../js/jquery-1.4.2.min.js"></SCRIPT>
	<SCRIPT type="text/javascript" src="../js/MoreTag.js"></SCRIPT>

</li>
<input type="hidden" class="bo bo1" value="翻页">
<input type="text" class="bo bo1" ID="XX" value="XX">
	
