<%
Dim G_CONN	'����Connectionȫ�ֶ���

'�������ݿ�
Sub ConnectDatabase()
	Dim strConnStr
	Dim strDB
	strDB="database/exam.mdb"      '���ݿ��ļ���λ��
	Set G_CONN = Server.CreateObject("ADODB.Connection")
	strConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath(strDB)
	G_CONN.Open strConnStr
End Sub

'�ر����ݿ�����
Sub CloseConn()
	G_CONN.close
	Set G_CONN=Nothing
End Sub

Call ConnectDatabase()	'�������ݿ�
%>