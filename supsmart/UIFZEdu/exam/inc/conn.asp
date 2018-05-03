<%
Dim G_CONN	'定义Connection全局对象

'连接数据库
Sub ConnectDatabase()
	Dim strConnStr
	Dim strDB
	strDB="database/exam.mdb"      '数据库文件的位置
	Set G_CONN = Server.CreateObject("ADODB.Connection")
	strConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(strDB)
	G_CONN.Open strConnStr
End Sub

'关闭数据库连接
Sub CloseConn()
	G_CONN.close
	Set G_CONN=Nothing
End Sub

Call ConnectDatabase()	'连接数据库
%>