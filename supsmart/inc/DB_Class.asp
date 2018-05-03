<%
'==========================
'Code for IdeaCMS数据连接类
'==========================
Class MainClass_DB
	public dbConn,dbRs,isConnect
	private connStr,vdbType
	private dbfile
	private err_id,err_des
	
	Private Sub Class_Initialize
		isConnect=false
	End Sub
	
	Public Property Let dbType(byval p0)
		if p0 = "sql" then vdbType=p0 else vdbType = "acc"
	End Property
	
	Private Sub getConnStr()
		if vdbType = "sql" then
			connStr = "Provider=Sqloledb;Data Source=" & databaseServer & ";Initial Catalog=" & databaseName & ";User ID=" & databaseUser & ";Password=" & databasePwd & ";"
		elseif vdbType = "acc" then
		    if sitePath<>"" then dbfile="/"&left(sitePath,len(sitePath)-1)&accessFilePath : else dbfile=accessFilePath
			connStr = "Provider=Microsoft.Jet.OLEdb.4.0;Data Source=" & server.mappath(dbfile)
		end if
	End Sub
	
	Public Sub connect()
		getConnStr
		if isObject(dbConn) = false or isConnect = false then
			On Error Resume Next
			set dbConn=server.CreateObject("ADODB.CONNECTION")
			dbConn.open connStr
			isConnect = true
			if Err then
			    err_id=Err.number : err_des=Err.description : Err.Clear : dbConn.close : set dbConn=nothing : isConnect = false
			    if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_dateconnect
			end if
		end if
	End Sub
	
	Function db(byval p0,byval p1)
		if not isConnect then connect
		On Error Resume Next
		p0 = replace(p0,"{pre}",tablepre)
		select case p1
			case "0"
				set db = dbConn.execute(p0)
			case "1"
				set db=server.CreateObject("ADODB.RECORDSET")
				db.open p0,dbConn,1,1
			case "2"
				set db=server.CreateObject("ADODB.RECORDSET")
				db.open p0,dbConn,3,3
			case "3"
				set dbRs=server.CreateObject("ADODB.RECORDSET")
				dbRs.open p0,dbConn,1,1
				if not dbRs.eof then db = dbRs.getRows()
				dbRs.close:set dbRs=nothing
		end select
		if Err then
			err_id=Err.number : err_des=Err.description : Err.Clear : dbConn.close : set dbConn=nothing : isConnect = false
			if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_datesql
		end if
	End Function
	
	Public Sub Class_Terminate()
		if isObject(dbRs) then set dbRs = nothing
		if isConnect then dbConn.close:set dbConn = nothing
	End Sub
End Class
%>