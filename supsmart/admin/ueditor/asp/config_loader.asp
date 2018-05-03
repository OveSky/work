<!--#include file="../../../inc/config.asp"-->
<!--#include file="../../../inc/lang.asp"-->
<!--#include file="../../../inc/DB_Class.asp"-->
<% 
    set conn=new MainClass_DB : conn.dbType=databaseType
	set rsObj=conn.db("select RoleID from {pre}Manager where UserName='"&request.cookies("UserName")&"' and Verifycode='"&request.cookies("Verifycode")&"'","1")
	    if rsObj.eof then
		    response.Write "<script>top.location.href='index.asp?action=login';</script>" : response.End()
		end if
	rsObj.close
	dim configStr : configStr=conn.db("select top 1 * from {pre}Config","3")
	set rsObj=nothing
%>
<%
    
	Set json = new ASPJson
    Set fso = Server.CreateObject("Scripting.FileSystemObject")

    Set stream = Server.CreateObject("ADODB.Stream")

    stream.Open()
    stream.Charset = "UTF-8"
    stream.LoadFromFile Server.MapPath( "config.json" )

    content = stream.ReadText()

    Set commentPattern = new RegExp
    commentPattern.Multiline = true
    commentPattern.Pattern = "/\*[\s\S]+?\*/"
    commentPattern.Global = true
    content = commentPattern.Replace(content, "")
    json.loadJSON( content )

    Set config = json.data
%>