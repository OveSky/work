<html><head>
		<meta charset="utf-8">
		<title>丰正教育管理系统-添加新学员</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">

		
		</style>
	</head>


ASP Page<BR>

	  <%DIM AA,BB
	  	
	  	
	  	
	  AA=request.form("school")
	  %>
	  <%=AA%>
	  <br>
	  <%
	  	BB=request.form("phone")
	  	%>
	  	  <%=BB%>
	  <br>
	  <%=request.form("grade")%><BR>
	  <%=request.form("birthday")%><BR>