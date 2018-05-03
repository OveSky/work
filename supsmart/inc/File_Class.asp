<%
'==========================
'Code for IdeaCMS文件类
'==========================
Class MainClass_File
	private objFso,objStream
	
	Private Sub Class_Initialize
		set objFso = server.createobject("Scripting.FileSystemObject")
		Set objStream = Server.CreateObject("Adodb.Stream")
	End Sub
	
	public Function getFolderList(Byval p0)
		dim filePath,objFolder,objSubFolder,objSubFolders,i
		i = 0 : redim  folderList(0) : filePath = server.mapPath(p0) : set objFolder=objFso.GetFolder(filePath) : set objSubFolders=objFolder.Subfolders
		for each objSubFolder in objSubFolders
			ReDim Preserve folderList(i)
			With objSubFolder
				folderList(i) = .name & ",文件夹," & .size/1000 & "k," & .DateLastModified & "," & p0 & "/" & .name
			End With
			i = i + 1 
		next 
		set objFolder=nothing : set objSubFolders=nothing
		getFolderList = folderList
	End Function
	
	public Function getFileList(Byval p0)
		dim filePath,objFolder,objFile,objFiles,i
		i = 0 : redim  fileList(0) : filePath = server.mapPath(p0) : set objFolder=objFso.GetFolder(filePath) : set objFiles=objFolder.Files
		for each objFile in objFiles
			ReDim Preserve fileList(i)
			With objFile
				fileList(i) = .name & "," & Mid(.name, InStrRev(.name, ".") + 1) & "," & .size/1000 & "KB," & .DateLastModified & "," & p0 & "/" & .name
			End With
			i = i + 1 
		next 
		set objFiles=nothing : set objFolder=nothing
		getFileList = fileList
	End Function
	
	public Function loadFile(ByVal p0,Byval p1)
		dim errid,errdes,fileCode,err_id,err_des
		if isNul(p1) then fileCode="utf-8" else fileCode=p1
		On Error Resume Next
		With objStream
			.Charset = fileCode : .Type = 2 : .Mode = 3 : .Open
			.LoadFromFile Server.MapPath(p0)
			If Err Then
				err_id=Err.number : err_des=Err.description : Err.Clear
				if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_loadfile
			End If
			.Position = 0
			loadFile = .ReadText
			.Close
		End With
	End Function
	
	public Function createTextFile(Byval p0,Byval p1,Byval p2)
		dim fileobj,fileCode : p1=replace(p1, "\", "/")
		if isNul(p2) then fileCode="utf-8" else fileCode=p2
		call createfolder(p1,"filedir")
		on error resume next
		set fileobj=objFso.CreateTextFile(server.mappath(p1),True) : fileobj.Write(p0) : set fileobj=nothing
		With objStream
			.Charset=fileCode:.Type=2:.Mode=3:.Open:.Position=0 : .WriteText p0:.SaveToFile Server.MapPath(p1), 2 : .Close
		End With
		if Err Then err.clear : createTextFile=false else createTextFile=true
	End Function
	
	public Function createFolder(Byval p0,Byval p1)
		dim subPathArray,lenSubPathArray,pathDeep,i,err_id,err_des
		on error resume next
		p0 = replace(p0,"\","/") : p0 = replace(server.mappath(p0),server.mappath("/"),"")
		subPathArray = split(p0,"\") : pathDeep = pathDeep & server.mappath("/")
		select case p1
			case "filedir"
				lenSubPathArray = ubound(subPathArray) - 1
			case "folderdir"
				lenSubPathArray = ubound(subPathArray)
		end select
		for i = 1 to lenSubPathArray
			pathDeep = pathDeep & "\" & subPathArray(i)
			if not objFso.FolderExists(pathDeep) then objFso.CreateFolder pathDeep
		next
		If Err Then
			err_id=Err.number : err_des=Err.description : Err.Clear
			if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_createFolder
		End If
	End Function
	
	public Function isExistFile(Byval p0)
		on error resume next
		if (objFso.FileExists(server.MapPath(p0))) then isExistFile = True else isExistFile = false
		if err then err.clear : isExistFile = false
	End Function
	
	public Function isExistFolder(Byval p0)
		on error resume next
		if objFso.FolderExists(server.MapPath(p0)) then isExistFolder = true else isExistFolder = false
		if err then err.clear : isExistFolder = false
	End Function
	
	public Function delFolder(Byval p0)
	    dim err_id,err_des
		on error resume next
		if isExistFolder(p0) = true Then objFso.DeleteFolder(server.mappath(p0))
		If Err Then
			err_id=Err.number : err_des=Err.description : Err.Clear
			if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_delFolder
		End If
	End Function
	
	public Function delFile(Byval p0)
	    dim err_id,err_des
		on error resume next
		if isExistFile(p0)=true then objFso.DeleteFile(server.mappath(p0))
		If Err Then
			err_id=Err.number : err_des=Err.description : Err.Clear
			if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_delFile
		End If
	End Function
	
	public Function moveFolder(p0,p1)
		dim voldFolder,vnewFolder,err_id,err_des
		voldFolder = p0 : vnewFolder = p1
		on error resume next
		if voldFolder <> vnewFolder then
			voldFolder=server.mappath(p0) : vnewFolder=server.mappath(p1)
			if not objFso.FolderExists(vnewFolder) then createFolder p1,"folderdir" 
			if objFso.FolderExists(voldFolder) then objFso.CopyFolder voldFolder,vnewFolder : objFso.DeleteFolder(voldFolder)
			If Err Then
				err_id=Err.number : err_des=Err.description : Err.Clear
				if errMode then echoMsg 0,err_id,err_des else echoMsg 0,err_id,err_moveFolder
			End If
		end if
	End Function
	
	public Function moveFile(ByVal p0,ByVal p1,Byval p2)
		dim srcPath,targetPath
		srcPath=Server.MapPath(p0) : targetPath=Server.MapPath(p1)
		if isExistFile(p0) then
			objFso.Copyfile srcPath,targetPath
			if p2="del" then delFile p0 
			moveFile=true
		else
			moveFile=false
		end if
	End Function
	
	Private Sub Class_Terminate()
		set objFso=nothing
		set objStream=nothing
	End Sub
End Class
%>