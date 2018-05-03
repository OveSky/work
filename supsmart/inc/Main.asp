<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'=================
'Code for IdeaCMS
'=================
option explicit
session.codepage=65001
response.charset="utf-8"
server.scripttimeout=999999

dim siteName,siteLogo,siteUrl,sitePath,databaseType,databaseServer,databaseName,databaseUser,databasepwd,accessFilePath,tablePre,errMode,wxAppId,wxAppsecret,wxToken,wxName,wxID,wxYID,openID,wxType,wxFAppId,wxFUrl,wxFUrl2,wxTurn,ewmLocation,slidePic,tcPercent,tcAmount

%>
<!--#include file="config.asp"-->
<!--#include file="wxconfig.asp"-->
<!--#include file="lang.asp"-->
<!--#include file="CommonFun.asp"-->
<!--#include file="DB_Class.asp"-->
<!--#include file="File_Class.asp"-->
<!--#include file="Template_Class.asp"-->
<!--#include file="Up_Class.asp"-->
<!--#include file="Wx_class.asp"-->
<!--#include file="Wx_err.asp"-->


<%
	dim templateobj : set templateobj = new MainClass_Template
	dim myfile : set myfile=new MainClass_File
	dim conn : set conn=new MainClass_DB : conn.dbType=databaseType
	dim configArr : configArr=conn.db("select top 1 * from {pre}Config","3")
	dim defaultTemplate : defaultTemplate="skin1"
	dim templateFileFolder : templateFileFolder="html"
	dim Comeurl : If Request.ServerVariables("HTTP_REFERER")<>"" Then Comeurl=Request.ServerVariables("HTTP_REFERER") Else Comeurl="/"&sitePath
	
	
	
	
	dim InModule
%>


