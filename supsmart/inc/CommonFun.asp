<%
'==========================
'Code for IdeaCMS函数
'==========================
Sub Echo(byval p0)
	Response.Write p0
End Sub

Sub Died
	Response.End()
End Sub

Function iif(p0,p1,p2)
	if p0=true then iif=p1 else iif=p2
End Function

Function isOutSubmit()
	dim s1, s2
	s1 = getRefer : s2 = getServername
	isOutSubmit=iif(Mid(s1,8,len(s2))<>s2,true,false)
End Function

Function getRefer()
	getRefer = request.ServerVariables("HTTP_REFERER")
End Function

Function getServername()
	getServername = request.ServerVariables("server_name")
End Function

Function MyUrl()
	Dim ScriptAddress, M_ItemUrl, M_item
	ScriptAddress = CStr(Request.ServerVariables("PATH_INFO")) '取得当前地址
	M_ItemUrl = ""
	If not isnul(Request.QueryString) Then
		ScriptAddress = ScriptAddress & "?"
		For Each M_item In Request.QueryString
			M_ItemUrl = M_ItemUrl & M_Item &"="& Server.URLEncode(Request.QueryString(""&M_Item&"")) & "&"
		Next
		M_ItemUrl=left(M_ItemUrl,len(M_ItemUrl)-1)
	end if
	MyUrl = "http://" & CStr(Request.ServerVariables("HTTP_HOST")) & ScriptAddress & M_ItemUrl
End Function

Function isNul(p0)
	if isnull(p0) or p0 = "" then isNul = true else isNul = false 
End Function

Function isNum(p0)
	isnum=true : if not isnumeric(p0) then isnum=false
End Function

Function isExistStr(str,patternstr)
	if isNul(str) or isNul(patternstr) then isExistStr=false : Exit Function
	if instr(str,patternstr)>0 then isExistStr=true else isExistStr=false
End Function

Function PubTemp()
    PubTemp="/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"
End Function

Function PubPic()
    PubPic="/"&sitePath&"Upload/Pic/"
End Function

Function PubFile()
    PubFile="/"&sitePath&"Upload/File/"
End Function

Function re(Byval p0,Byval p1,Byval p2)
	on error resume next
	if isNul(p0) or len(p0)=0 then p0=""
	if isNul(p1) or len(p1)=0 then p1=""
	if isNul(p2) or len(p2)=0 then p2=""
	re=replace(p0,p1,p2)
End Function

Function readCookie(p0)
	readCookie = encodeHtml(request.cookies(p0))
End Function

Sub setCookie(p0,p1)
	response.cookies(p0) = p1
End Sub

Function getForm(p0,p1)
	Select case p1
		case "get"
			getForm=encodeHtml(trim(request.QueryString(p0)))
		case "post"
			getForm=encodeHtml(trim(request.Form(p0)))
		case "tpost"
			getForm=request.Form(p0)
		case else
		    getForm=iif(isNul(request.QueryString(p0)),encodeHtml(trim(request.Form(p0))),encodeHtml(trim(request.QueryString(p0))))
	End Select
End Function

Function getint(byval p0,byval p1)
    if isnul(p0) then
	    getint=p1
	else
	    if isnum(p0) then getint=clng(p0) else getint=p1
	end if
End Function

Function encodeHtml(Byval p0)
    dim reg : set reg = New Regexp
	reg.IgnoreCase = true : reg.Global = true
	if isNul(Trim(p0)) then encodeHtml="" : exit function
	p0=replace(p0,"&","&amp;")
	p0=replace(p0,"'","&#39;")
	p0=replace(p0,"""","&#34;")
	p0=replace(p0,"<","&lt;")
	p0=replace(p0,">","&gt;")
	reg.pattern="(w)(here)" : p0=reg.replace(p0,"$1h&#101;re")
	reg.pattern="(s)(elect)" : p0=reg.replace(p0,"$1el&#101;ct")
	reg.pattern="(i)(nsert)" : p0=reg.replace(p0,"$1ns&#101;rt")
	reg.pattern="(c)(reate)" : p0=reg.replace(p0,"$1r&#101;ate")
	reg.pattern="(d)(rop)" : p0=reg.replace(p0,"$1ro&#112;")
	reg.pattern="(a)(lter)" : p0=reg.replace(p0,"$1lt&#101;r")
	reg.pattern="(d)(elete)" : p0=reg.replace(p0,"$1el&#101;te")
	reg.pattern="(u)(pdate)" : p0=reg.replace(p0,"$1p&#100;ate")
	reg.pattern="(\s)(or)" : p0=reg.replace(p0,"$1o&#114;")
	reg.pattern="(java)(script)" : p0=reg.replace(p0,"$1scri&#112;t")
	reg.pattern="(j)(script)" : p0=reg.replace(p0,"$1scri&#112;t")
	reg.pattern="(vb)(script)" : p0=reg.replace(p0,"$1scri&#112;t")
	if instr(p0,"expression")<>0 then
		p0=replace(p0,"expression","e&#173;xpression",1,-1,0)
	end if
	encodeHtml=p0
	set reg=nothing
End Function

Function decodeHtml(Byval p0)
	if isNul(Trim(p0)) then decodeHtml="" : exit function
	p0=replace(p0,"&amp;","&")
	p0=replace(p0,"&#39;","'")
	p0=replace(p0,"&#34;","""")
	p0=replace(p0,"&lt;script&gt;","{ideacms:c1}")
	p0=replace(p0,"&lt;/script&gt;","{ideacms:c2}")
	p0=replace(p0,"&lt;iframe","{ideacms:c3}")
	p0=replace(p0,"&lt;/iframe&gt;","{ideacms:c4}")
	p0=replace(p0,"&lt;","<")
	p0=replace(p0,"&gt;",">")
	p0=replace(p0,"{ideacms:c1}","&lt;script&gt;")
	p0=replace(p0,"{ideacms:c2}","&lt;/script&gt;")
	p0=replace(p0,"{ideacms:c3}","&lt;iframe")
	p0=replace(p0,"{ideacms:c4}","&lt;/iframe&gt;")
	decodeHtml=p0
End Function

Function codeTextarea(Byval str,Byval enType)
	select case enType
		case "en"
			codeTextarea = re(re(str,chr(13)&chr(10),"<br>"),chr(32),"&nbsp;")
		case "de"
			codeTextarea = re(re(str,"<br>",chr(13)&chr(10)),"&nbsp;",chr(32))
	end select
End Function

Function filterStr(Byval p0)
	if isNul(p0) then  filterStr = "" : Exit Function
	dim regObj,outstr,rulestr : set regObj = New Regexp
	regObj.IgnoreCase = true : regObj.Global = true
	rulestr = "(<[a-zA-Z].*?>)|(<[\/][a-zA-Z].*?>)"
	regObj.Pattern = rulestr
	outstr = regObj.Replace(p0,"")
	outstr=re(outstr,"{ideacms:page}","")
	outstr=re(outstr,"&nbsp;","")
	set regObj = Nothing : filterStr = outstr
End Function

Sub alert(byval p0,byval p1,byval p2)
	if not isNul(p1) then p1="location.href='"&p1&"';"
	if not isNul(p0) then p0="alert('"&p0&"');"
	if not isNul(p2) then p2="history.go(-"&p2&");" 
	Echo("<script charset='utf-8'>"&p0&p1&p2&"</script>") : Died
End Sub

function DateFormat(p0,p1)
	if isdate(p0) then
		dim i,temp
		temp=replace(p1,"yyyy",DatePart("yyyy",p0))
		temp=replace(temp,"mm",iif(len(DatePart("m",p0))>1,DatePart("m",p0),"0"&DatePart("m",p0)))
		temp=replace(temp,"dd",iif(len(DatePart("d",p0))>1,DatePart("d",p0),"0"&DatePart("d",p0)))
		temp=replace(temp,"hh",iif(len(DatePart("h",p0))>1,DatePart("h",p0),"0"&DatePart("h",p0)))
		temp=replace(temp,"nn",iif(len(DatePart("n",p0))>1,DatePart("n",p0),"0"&DatePart("n",p0)))
		temp=replace(temp,"ss",iif(len(DatePart("s",p0))>1,DatePart("s",p0),"0"&DatePart("s",p0)))
		DateFormat=temp
	else
		DateFormat=false
	end if
end function

Function isInstallObj(p0)
	dim isInstall,obj
	on error resume next
	set obj=server.CreateObject(p0)
	if Err then 
		isInstallObj = false : err.clear
	else 
		isInstallObj=true : set obj = nothing
	end if
End Function

Function terminateAllObjects()
    dim err_id,err_des
	on error resume next
	if isobject(conn) then set conn=nothing
	if isobject(myfile) then set myfile = nothing
	if isobject(templateobj) then set templateobj = nothing
End Function

Function GetTopId(byval p0)
    dim sqlStr,rsObj,ChildArray,i
	GetTopId=-1
	sqlStr= "select ID,ChildPath from {pre}Navigation where ParentID=0"
	set rsObj = conn.db(sqlStr,"1")
	do while not rsObj.eof
	    ChildArray=split(rsObj(1),",")
		for i=0 to ubound (ChildArray)
		    if cint(ChildArray(i))=cint(p0) then GetTopId=rsObj(0) : exit for : exit do
		next
	rsObj.movenext
	loop
	rsObj.close
	set rsObj = nothing
End Function

Function makePageNumber(Byval currentPage,Byval pageListLen,Byval totalPages,Byval typeId,Byval sortId,Byval id)
	dim beforePages,pagenumber,idstr1,idstr2,idstr3
	dim beginPage,endPage,strPageNumber
	if pageListLen mod 2 = 0 then beforePages = pagelistLen / 2 else beforePages = clng(pagelistLen / 2) - 1
	if cint(currentPage) < 1  then currentPage = 1 else if cint(currentPage) > cint(totalPages) then currentPage = totalPages
	if cint(pageListLen) > cint(totalPages) then pageListLen=totalPages
	if cint(currentPage - beforePages) < 1 then
		beginPage = 1 : endPage = pageListLen
	elseif cint(currentPage - beforePages + pageListLen) > totalPages  then
		beginPage = totalPages - pageListLen + 1 : endPage = totalPages
	else 
		beginPage = currentPage - beforePages : endPage = currentPage - beforePages + pageListLen - 1
	end if	
	for pagenumber = beginPage to endPage
		if cint(pagenumber)=cint(currentPage) then
			strPageNumber=strPageNumber&"<div class='m_t312'>"&pagenumber&"</div>"
		else
		    if not isNul(id) then
				idstr1="typeid="&typeId&"&sortid="&sortId&"&id="&id&"" : idstr2="show-"&typeId&"-"&sortId&"-"&id : idstr3=conn.db("select TBm from {pre}"&idToName(cint(typeid))&" where id="&id&"","0")(0)
			else
				idstr1="typeid="&typeId&"&sortid="&sortId&"" : idstr2="list-"&typeId&"-"&sortId : idstr3="index"
			end if
			select case typeId
				case "guestlist"
				    strPageNumber=strPageNumber&"<a href='?page="&pagenumber&"'>"&pagenumber&"</a>&nbsp;"
				case "searchlist"
				    strPageNumber=strPageNumber&"<a href='?page="&pagenumber&"&keys="&sortId&"'>"&pagenumber&"</a>&nbsp;"
				case "admin" '后台分页
				    strPageNumber=strPageNumber&"<div class='m_t311'><a href='?page="&pagenumber&"&type="&vtype&"&keyword="&server.urlencode(keyword)&"'>"&pagenumber&"</a></div>"
				case else '前台分页
					if runMode="0" then
					    strPageNumber=strPageNumber&"<a href='?"&idstr1&"&page="&pagenumber&"'>"&pagenumber&"</a>&nbsp;"
					elseif runMode="1" then
						strPageNumber=strPageNumber&"<a href='"&idstr2&"-"&pagenumber&".html'>"&pagenumber&"</a>&nbsp;"
					elseif runMode="2" then
						strPageNumber=strPageNumber&"<a href='"&idstr3&"_"&pagenumber&".html'>"&pagenumber&"</a>&nbsp;"
					end if
			end select
		end if	
	next
	makePageNumber=strPageNumber
End Function

'检测是否为图片
Function Check_ispic(ByVal str)
	Select Case Right(Lcase(str),3)
		Case "jpg","gif","peg","bmp","png":Check_ispic=1
		Case Else:Check_ispic=0
   End Select
End Function
'裁剪图片
Sub Jpeg_Thumb(ByVal path,ByVal path2,ByVal blstr,ByVal stype,ByVal picType)
    if cint(picType)=0 then Exit Sub
	if Check_ispic(path)=0 Then Exit Sub
	Dim AspJpeg,AspJpeg2,bl_h,bl_w,s_w,s_h,PhotoQuality
	PhotoQuality=100
	Set AspJpeg=Server.CreateObject("Persits.Jpeg")
	Set AspJpeg2=Server.CreateObject("Persits.Jpeg")
	if Err Then Exit Sub
	if AspJpeg.Expires<Now Then Exit Sub
	AspJpeg.Open Trim(path)
	AspJpeg2.Open Trim(path)
	if instr(blstr,"*")>0 then
	    s_w=split(blstr,"*")(0)
		s_h=split(blstr,"*")(1)
		if not isNum(s_w) or not isNum(s_h) then Exit Sub
	else
	    Exit Sub 
	end if
	bl_w=s_w/AspJpeg.OriginalWidth
	bl_h=s_h/AspJpeg.OriginalHeight
	if s_w>0 Then
		if s_h>0 Then
			Select Case stype
			Case "1"    '裁剪法：宽度和高度都大于0时，先按最佳比例缩小再裁剪成指定大小，其中一个为0时，按比例缩小
				if bl_w<1 Or bl_h<1 Then
					if bl_w<bl_h Then
						AspJpeg.Height=s_h
						AspJpeg.Width=Round(AspJpeg.OriginalWidth * bl_h)   '按缩小成大比例者
					Else
						AspJpeg.Width=s_w
						AspJpeg.Height=Round(AspJpeg.OriginalHeight * bl_w)
					End if
					AspJpeg.Crop 0, 0, s_w, s_h
					AspJpeg.Quality=PhotoQuality
					AspJpeg.ToRGB
					AspJpeg.Save path2
				End if
			Case "2"  '补充法：在指定大小的背景图上附加上按最佳比例缩小的图片
				'创建一个指定大小的背景图
				AspJpeg2.Width=s_w
				AspJpeg2.Height=s_h
				AspJpeg2.Canvas.Brush.Solid=True            ' 图片边框内是否填充颜色
				AspJpeg2.Canvas.Brush.COLOR="&HFFFFFF"  '设定背景颜色
				AspJpeg2.Canvas.Bar -1, -1, AspJpeg2.Width+1, AspJpeg2.Height+1 '填充
				'按最佳比例缩小图片
				IF bl_w>bl_h Then
					IF bl_h<1 Then
						AspJpeg.Height=s_h
						AspJpeg.Width=Round(AspJpeg.OriginalWidth*bl_h)   '按缩小成小比例者
					End IF
				Else
					IF bl_w<1 Then
						AspJpeg.Width=s_w
						AspJpeg.Height=Round(AspJpeg.OriginalHeight*bl_w)
					End IF
				End IF
				'得到缩略图的坐标
				dim iLeft,iTop
				iLeft=(AspJpeg2.Width-AspJpeg.Width)/2
				iTop=(AspJpeg2.Height-AspJpeg.Height)/2
				AspJpeg2.DrawImage iLeft,iTop,AspJpeg   '将缩略图附加到背景上
				AspJpeg2.Quality=100
				AspJpeg2.ToRGB
				AspJpeg2.Save path2
			End Select
		Else
			if bl_w<1 Then
				AspJpeg.Width=s_w
				AspJpeg.Height=Round(AspJpeg.OriginalHeight*bl_w)
				AspJpeg.Quality=PhotoQuality
				AspJpeg.ToRGB
				AspJpeg.Save path2
			End if
		End if
	Else
		if s_h>0 And bl_h<1 Then
			AspJpeg.Height=s_h
			AspJpeg.Width=Round(AspJpeg.OriginalWidth*bl_h)
			AspJpeg.Quality=PhotoQuality
			AspJpeg.ToRGB
			AspJpeg.Save path2
		End if
	End if
	Set AspJpeg=Nothing
	Set AspJpeg2=Nothing
End Sub
'水印
Sub Mark_Jpeg(ByVal picPath,ByVal markPath,ByVal iLeft,ByVal iTop,ByVal outPath)
	IF Check_ispic(picPath)=0 Then Exit Sub
	Dim AspJpeg,AspJpeg2
	Set AspJpeg=Server.CreateObject("Persits.Jpeg")
	IF AspJpeg.Expires<Now Then Exit Sub
	AspJpeg.Open Trim(Server.MapPath(picPath))
	Set AspJpeg2=Server.CreateObject("Persits.Jpeg")
	AspJpeg2.Open Trim(Server.MapPath(markPath))  '打开水印图片
	AspJpeg.Interpolation=1
    AspJpeg.Quality=100 
	AspJpeg.Canvas.DrawImage iLeft,iTop,AspJpeg2
	AspJpeg.Save Server.MapPath(outPath)
	Set AspJpeg2=Nothing	
	Set AspJpeg= Nothing
End Sub

Sub Mark_Txt(ByVal picPath,ByVal picTxt)
	dim jpeg : Set Jpeg = Server.CreateObject("Persits.Jpeg")
	Jpeg.Open Server.MapPath(picPath)
	Jpeg.Canvas.Font.Color = &HB665C1'' red 颜色
	Jpeg.Canvas.Font.Family = "黑体" '字体
	Jpeg.Canvas.Font.Size = 23      '//水印字体大小 
	Jpeg.Canvas.Font.Bold = true '是否加粗
	Jpeg.Canvas.Font.Quality = 4 ' 文字清晰度
	Jpeg.Canvas.Print 292, 40, picTxt
	Jpeg.Save Server.MapPath(picPath)
	set Jpeg=nothing
End Sub

'添加临时图片素材
Sub Upload_PicMedia(ByVal picPath,ByVal openID)
    dim Access_token : Access_token=GetToken()
    Dim UploadData : Set UploadData = New XMLUploadImpl
	UploadData.Charset = "gb2312"
	UploadData.AddForm "UpPic", "11" '文本域的名称和内容
	UploadData.AddFile "ImgFile", Server.MapPath(picPath), "image/jpg", GetFileBinary(Server.MapPath(picPath))'图片或者其它文件
	dim strJson2 : strJson2=UploadData.Upload(UpPicUrl&Access_token&"&type=image")
	if InStr(strJson2,"errcode")>0 then exit sub
	Call InitScriptControl:dim objTest2 : Set objTest2 = getJSONObject(strJson2)
	conn.db "update {pre}User set REwmID='"&objTest2.media_id&"',REwmDate='"&objTest2.created_at&"' where OpenID='"&openID&"'","0"
	set objTest2=nothing
End Sub


'添加临时图片素材
Function Upload_LPicMedia(ByVal picPath)
    dim Access_token : Access_token=GetToken()
    Dim UploadData : Set UploadData = New XMLUploadImpl
	UploadData.Charset = "gb2312"
	UploadData.AddForm "UpPic", "11" '文本域的名称和内容
	UploadData.AddFile "ImgFile", Server.MapPath(picPath), "image/jpg", GetFileBinary(Server.MapPath(picPath))'图片或者其它文件
	dim strJson2 : strJson2=UploadData.Upload(UpPicUrl&Access_token&"&type=image")
	if InStr(strJson2,"errcode")>0 then exit Function
	Call InitScriptControl:dim objTest2 : Set objTest2 = getJSONObject(strJson2)
	Upload_LPicMedia=objTest2.media_id
	set objTest2=nothing
End Function



'添加永久图片素材
Function Upload_YPicMedia(ByVal picPath)
	dim Access_token : Access_token=GetToken()
	dim UpYPicUrl:UpYPicUrl="https://api.weixin.qq.com/cgi-bin/material/add_material?access_token="	'增加永久素材接口
    Dim UploadData : Set UploadData = New XMLUploadImpl
	UploadData.Charset = "gb2312"
	UploadData.AddForm "UpPic", "11" '文本域的名称和内容
	UploadData.AddFile "ImgFile", Server.MapPath(picPath), "image/jpg", GetFileBinary(Server.MapPath(picPath))'图片或者其它文件
	dim strJson2 : strJson2=UploadData.Upload(UpYPicUrl&Access_token&"&type=image")
	if InStr(strJson2,"errcode")>0 then Upload_YPicMedia=strJson2 : exit Function
	Call InitScriptControl:dim objTest2 : Set objTest2 = getJSONObject(strJson2)
	Upload_YPicMedia=objTest2.media_id
	set objTest2=nothing
End Function

function TName(id)
    dim sqlStr,rsObj
    sqlStr= "select C_Name from {pre}Category where id="&id&""
	set rsObj = conn.db(sqlStr,"1")
	if not rsObj.eof then
	    TName=rsObj(0)
	else
	    TName="未知分类"
	end if
	rsObj.close
	set rsObj=nothing
end function

function keyToOpenID(byval id)
    dim rsObj
	set rsObj = conn.db("select * from {pre}User where ID="&Id&"","1")
	if not rsObj.eof then
	    keyToOpenID=rsObj("OpenID")
	else
	    keyToOpenID=""
	end if
	rsObj.close
	set rsObj=nothing
end function

function OpenidToNick(byval id)
    dim rsObj
	set rsObj = conn.db("select * from {pre}User where OpenID='"&Id&"'","1")
	if not rsObj.eof then
	    OpenidToNick=rsObj("NickName")
	else
	    OpenidToNick=""
	end if
	rsObj.close
	set rsObj=nothing
end function

function OpenidToID(byval id)
    dim rsObj
	set rsObj = conn.db("select * from {pre}User where OpenID='"&Id&"'","1")
	if not rsObj.eof then
	    OpenidToID=rsObj("ID")
	else
	    OpenidToID=0
	end if
	rsObj.close
	set rsObj=nothing
end function

function idToShop(byval id)
    dim rsObj
	set rsObj = conn.db("select * from {pre}Shop where ID="&Id&"","1")
	if not rsObj.eof then
	    idToShop=rsObj("Title")
	else
	    idToShop=""
	end if
	rsObj.close
	set rsObj=nothing
end function

function showOut(byval infoStr,byval sortid,byval id)
    dim sitedes,sitekeywords,gg_str
	dim rsObj,i,seoKeyArr,picarr,picindex,picstr,str1,str2
	set rsObj = conn.db("select * from {pre}Product where ID="&Id&"","1")
	if rsObj.eof then echoMsg 0,"","该页不存在"
	conn.db  "update {pre}Product set Hits=Hits+1 where ID="&Id&"","0"
	infoStr = re(infoStr,"[show:id]",rsObj("ID"))
	infoStr = re(infoStr,"[show:title]",rsObj("Title"))
	infoStr = re(infoStr,"[show:date]",rsObj("AddDate"))
	infoStr = re(infoStr,"[show:hits]",rsObj("Hits"))
	infoStr = re(infoStr,"[show:stock]",rsObj("Stock"))
	infoStr = re(infoStr,"[show:sales]",rsObj("PTotal"))
	infoStr = re(infoStr,"[show:info]",decodeHtml(rsObj("Content")))
	infoStr = re(infoStr,"[show:des]",decodeHtml(rsObj("Property")))
	infoStr = re(infoStr,"[show:yprice]",rsObj("YPrice"))
	infoStr = re(infoStr,"[show:dzprice]",rsObj("DZPrice"))
	if isNul(rsObj("PicStr")) then
		infoStr = re(infoStr,"[show:pic]","/"&sitePath&"inc/image/nopic_small.gif")
		infoStr = re(infoStr,"[show:piclist]","")
	else
		if instr(rsObj("PicStr"),"|")>0 then
			picarr=split(rsObj("PicStr"),"|")
			infoStr = re(infoStr,"[show:pic]",PubPic&picarr(0))
			str1="<ul id='slider'>" : str2="<div id='pagenavi' style='text-align:right;'>"
			if ubound(picarr)>2 then
			    for i=1 to ubound(picarr)-1
				    if i=1 then
					    str1=str1&"<li style='display:block'><img width='100%' src='"&pubpic&picarr(i)&"'/></li>"
						str2=str2&"<a href='javascript:void(0);' class='active'>"&i&"</a>"
					else
				        str1=str1&"<li><img width='100%' src='"&pubpic&picarr(i)&"'/></li>"
						str2=str2&"<a href='javascript:void(0);'>"&i&"</a>"
					end if
				next
				str1=str1&"</ul>"
				str2=str2&"</div>"
				infoStr=re(infoStr,"[show:piclist]",str1&str2)
			else
			    infoStr=re(infoStr,"[show:piclist]","")
			end if
		else
			infoStr = re(infoStr,"[show:pic]",PubPic&rsObj("PicStr"))
			infoStr = re(infoStr,"[show:piclist]","")
		end if
	end if
	if isNul(rsObj("PGg")) then
	    gg_str="<input type='hidden' name='p_gg' id='p_gg' value='默认规格'><div class='add_it13'>默认规格</div>"
	else
	    if instr(rsObj("PGg"),"|")>0 then
		    dim g,gg_arr : gg_arr=split(rsObj("PGg"),"|")
			for g=0 to ubound(gg_arr)
			    if g=0 then
				    gg_str="<input type='hidden' name='p_gg' id='p_gg' value='"&gg_arr(g)&"'><div id='g"&g&"' class='add_it13' onClick='changegg("&g&","&ubound(gg_arr)&");'>"&gg_arr(g)&"</div>"
				else
				    gg_str=gg_str&"<div id='g"&g&"' class='add_it12' onClick='changegg("&g&","&ubound(gg_arr)&");'>"&gg_arr(g)&"</div>"
				end if
			next
		else
		    gg_str="<input type='hidden' name='p_gg' id='p_gg' value='"&rsObj("PGg")&"'><div class='add_it13'>"&rsObj("PGg")&"</div>"
		end if
	end if
    infoStr = re(infoStr,"[show:ggstr]",gg_str)
	rsObj.close
	set rsObj = nothing
	infoStr = re(infoStr,"{ideacms:smalltype}",TName(SortID))
	showOut=infoStr
end function

function myorder(byval id)
    dim sql,rsObj,rsObj1
	dim o_str,o_pstr,o_pic,o_total
	dim o_arr,c_arr
	dim o_zt,o_pay
    select case id
	    case 0 : sql="select * from {pre}Order where OpenID='"&session("openid")&"' order by id desc"
		case 1 : sql="select * from {pre}Order where OrderType=0 and OpenID='"&session("openid")&"' order by id desc"
		case 2 : sql="select * from {pre}Order where OrderType=1 and OpenID='"&session("openid")&"' order by id desc"
		case 3 : sql="select * from {pre}Order where OrderType=2 and OpenID='"&session("openid")&"' order by id desc"
	end select
    set rsObj=conn.db(sql,"1")
	    if not rsObj.eof then
		    do while not rsObj.eof
				if rsObj("OrderType")=0 then
					o_zt="待支付"
					o_pay="去支付"
				elseif rsObj("OrderType")=1 then
					o_zt="待发货"
					if rsObj("PayType")=0 then o_pay="货到付款" else o_pay="微信支付" 
				elseif rsObj("OrderType")=2 then
					o_zt="待确认"
					o_pay="去确认"
				else
				    o_zt="已收货"
					if rsObj("PayType")=0 then o_pay="货到付款" else o_pay="微信支付"
				end if
			    o_str=o_str&"<div class='order_list' onClick=""location.href='?m=ordershow&id="&rsObj("ID")&"';"">"&vbcrlf
				o_str=o_str&"    <div class='order_lt1'>"&vbcrlf
				o_str=o_str&"    状&nbsp;&nbsp;态：<span>"&o_zt&"</span><br>"&vbcrlf
				
				o_arr=split(rsObj("OrderStr"),"|")
				o_pstr="" : o_total=0
				for i=1 to ubound(o_arr)
					c_arr=split(o_arr(i),"$")
					set rsObj1=conn.db("select * from {pre}Product where ID="&cint(c_arr(0))&"","1")
					if isnul(rsObj1("PicStr")) then
					    o_pic=PubPic&"nopic_small.gif"
					else
					    if instr(rsObj1("PicStr"),"|")>0 then
						    o_pic=PubPic&split(rsObj1("PicStr"),"|")(0)
						else
						    o_pic=PubPic&rsObj1("PicStr")
						end if
					end if
					o_pstr=o_pstr&"<div class='order_cell'>"&vbcrlf
                    o_pstr=o_pstr&"  <div class='order_pic'><img src='"&o_pic&"'></div>"&vbcrlf
                    o_pstr=o_pstr&"  <div class='order_txt'>"&vbcrlf
                    o_pstr=o_pstr&"  "&rsObj1("Title")&"<br>"&vbcrlf
                    o_pstr=o_pstr&"  "&c_arr(2)&"件&nbsp;&nbsp;<span>￥"&cint(c_arr(2))*cdbl(rsObj1("DzPrice"))&"</span>"&vbcrlf
                    o_pstr=o_pstr&"  </div>"&vbcrlf
                    o_pstr=o_pstr&"</div>"&vbcrlf
					o_total=o_total+cint(c_arr(2))*cdbl(rsObj1("DzPrice"))
					rsObj1.close
					set rsObj1=nothing
				next
				
				o_str=o_str&"    总&nbsp;&nbsp;价：<span>￥"&o_total&"</span>"&vbcrlf
				o_str=o_str&"    <div class='order_ztctr'>"&o_pay&"</div>"&vbcrlf
				o_str=o_str&"    </div>"&vbcrlf
				o_str=o_str&o_pstr
				o_str=o_str&"</div>"&vbcrlf
				
			rsObj.movenext
			loop
		end if
	rsObj.close
	set rsObj=nothing
	myorder=o_str
end function

'小票打印
Function ToUnixTime(strTime, intTimeZone)        
    If IsEmpty(strTime) or Not IsDate(strTime) Then strTime = Now        
    If IsEmpty(intTimeZone) or Not isNumeric(intTimeZone) Then intTimeZone = 0        
     ToUnixTime = DateAdd("h",-intTimeZone,strTime)        
     ToUnixTime = DateDiff("s","1970-1-1 0:0:0", ToUnixTime)        
End Function

function PostHTTPPage(url,data) 
	dim Http : set Http=server.createobject("MSXML2.SERVERXMLHTTP.3.0")
	Http.open "POST",url,false 
	Http.setRequestHeader "CONTENT-TYPE", "application/x-www-form-urlencoded" 
	Http.send(data) 
	if Http.readystate<>4 then 
	exit function 
	End if
	PostHTTPPage=bytesToBSTR(Http.responseBody,"utf-8") 
	set http=nothing 
	if err.number<>0 then err.Clear 
End function

function BytesToBstr(body,Cset) 
	dim objstream 
	set objstream = Server.CreateObject("adodb.stream")
	objstream.Type = 1 
	objstream.Mode =3 
	objstream.Open 
	objstream.Write body 
	objstream.Position = 0 
	objstream.Type = 2 
	objstream.Charset = Cset 
	BytesToBstr = objstream.ReadText 
	objstream.Close 
	set objstream = nothing 
End function

Function getIP() '获取客户端ip
	Dim strIPAddr  
	If Request.ServerVariables("HTTP_X_FORWARDED_FOR") = "" OR InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), "unknown") > 0 Then  
		strIPAddr = Request.ServerVariables("REMOTE_ADDR")  
	ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",") > 0 Then  
	   strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ",")-1)  
	ElseIf InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";") > 0 Then  
	   strIPAddr = Mid(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 1, InStr(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), ";")-1)  
	Else  
	   strIPAddr = Request.ServerVariables("HTTP_X_FORWARDED_FOR")  
	End If  
	getIP = Trim(Mid(strIPAddr, 1, 30))  
End Function

Function randomStr(intLength) '生成随机字符串
	Dim strSeed, seedLength, pos, Str, i 
	strSeed = "abcdefghijklmnopqrstuvwxyz1234567890" 
	seedLength = Len(strSeed) 
	Str = "" 
	Randomize 
	For i = 1 To intLength 
	Str = Str + Mid(strSeed, Int(seedLength * Rnd) + 1, 1) 
	Next 
	randomStr = Str 
End Function 

Function GetPayID(openid,orderid,total)
    dim gstr,kstr,rstr : rstr=randomStr(32)
	dim m_ip : m_ip=getIp()
	gstr="<xml>"
	gstr=gstr&"<openid><![CDATA["&openid&"]]></openid>"
	gstr=gstr&"<body><![CDATA[wx-"&orderid&"]]></body>"
	gstr=gstr&"<out_trade_no><![CDATA["&orderid&"]]></out_trade_no>"
	gstr=gstr&"<total_fee>"&total&"</total_fee>"
	gstr=gstr&"<notify_url><![CDATA[http://"&siteUrl&"/"&sitePath&"pay/wxpay/notify_url.asp]]></notify_url>"
	gstr=gstr&"<trade_type><![CDATA[JSAPI]]></trade_type>"
	gstr=gstr&"<appid><![CDATA["&wxAppID&"]]></appid>"
	gstr=gstr&"<mch_id>"&configArr(26,0)&"</mch_id>"
	gstr=gstr&"<spbill_create_ip><![CDATA["&m_ip&"]]></spbill_create_ip>"
	gstr=gstr&"<nonce_str><![CDATA["&rstr&"]]></nonce_str>"
	kstr="appid="&wxAppID&"&body=wx-"&orderid&"&mch_id="&configArr(26,0)&"&nonce_str="&rstr&"&notify_url=http://"&siteUrl&"/"&sitePath&"pay/wxpay/notify_url.asp&openid="&openid&"&out_trade_no="&orderid&"&spbill_create_ip="&m_ip&"&total_fee="&total&"&trade_type=JSAPI&key="&configArr(27,0)&""
	gstr=gstr&"<sign><![CDATA["&UCase(md5(kstr))&"]]></sign>"
	gstr=gstr&"</xml>"
	GetPayID=gstr
End Function

Sub GoPrint(m_orderid,myopenid,paytype)
    on error resume next
    dim shopid : shopid=conn.db("select ShopID from {pre}Order where OrderID='"&m_orderid&"'","1")(0)
	dim orderstr : orderstr=conn.db("select orderstr from {pre}Order where OrderID='"&m_orderid&"'","1")(0)
    dim isprint : isprint=conn.db("select isPrint from {pre}Shop where ID="&cint(shopid)&"","1")(0)
	dim uid : uid=conn.db("select ID from {pre}User where OpenID='"&myopenid&"'","1")(0)
    if cint(isprint)=1 then
	    dim content,times,sign,mdate,url,poststr,paystr,rsObj,t_jf
		if paytype=0 then paystr="货到付款" else paystr="微信支付"
		set rsObj=conn.db("select * from {pre}Order where orderid='"&m_orderid&"'","1")
		    dim m_addr : m_addr=rsObj("Address")
			dim m_name : m_name=rsObj("LinkName")
			dim m_tel : m_tel=rsObj("Telephone")
			dim m_info : m_info=rsObj("Content")
		rsObj.close
		set rsObj=nothing
		set rsObj=conn.db("select * from {pre}Shop where id="&shopid&"","1")
		    dim s_tel : s_tel=rsObj("ShopTel")
			dim s_addr : s_addr=rsObj("ShopAddr")
			dim s_mpartner : s_mpartner=rsObj("P_Partner")
			dim s_mapi : s_mapi=rsObj("P_ApiKey")
			dim s_mcode : s_mcode=rsObj("P_Machine")
			dim s_mkey : s_mkey=rsObj("P_MKey")
			dim s_ewm : s_ewm=rsObj("P_Ewm")
			dim s_title : s_title=rsObj("Title")
		rsObj.close
		set rsObj=nothing
		set rsObj=conn.db("select * from {pre}Xfmx where IsJf=1 and OpenID='"&myopenid&"'","1")
			if not rsObj.eof then
				do while not rsObj.eof
					t_jf=t_jf+cint(rsObj("Nums"))
				rsObj.movenext
				loop
			else
				t_jf=0
			end if
		rsObj.close
		set rsObj=nothing
		
		dim c_str,m_title,m_price,m_total,i : m_total=0
		dim o_arr : o_arr=split(orderstr,"|")
		dim c_arr,c_jf,m_jf1
		for i=1 to ubound(o_arr)
		    c_arr=split(o_arr(i),"$")
			set rsObj=conn.db("select * from {pre}Product where ID="&cint(c_arr(0))&"","1")
				c_jf=rsObj("PJf")
				m_title=rsObj("Title")
				m_price=rsObj("DzPrice")
			rsObj.close
			set rsObj=nothing
			
			c_str=c_str&m_title&chr(13)&chr(10)
			c_str=c_str&"           "&FormatNumber(m_price,2)&"      *"&c_arr(2)&"      "&FormatNumber(CDbl(m_price)*cint(c_arr(2)),2)&""&chr(13)&chr(10)
			m_total=m_total+CDbl(m_price)*cint(c_arr(2))
			m_jf1=m_jf1+cint(c_jf)*cint(c_arr(2))
		next
		
		content=chr(64)&chr(64)&"2            "&s_title&"收据"&chr(13)&chr(10)&chr(13)&chr(10)
		content=content&"订单号："&m_orderid&chr(13)&chr(10)
		content=content&"下单时间："&now()&chr(13)&chr(10)
		content=content&"付款方式："&paystr&chr(13)&chr(10)
		content=content&"送货地址："&split(m_addr," ")(2)&chr(13)&chr(10)
		content=content&"客户姓名："&left(m_name,1)&"**"&chr(13)&chr(10)
		content=content&"联系电话："&m_tel&chr(13)&chr(10)
		content=content&"************************"&chr(13)&chr(10)
		content=content&"商品       单价       数量       小计"&chr(13)&chr(10)
		content=content&c_str
		content=content&"************************"&chr(13)&chr(10)
		content=content&"备注："&m_info&chr(13)&chr(10)
		content=content&"------------------------------------------------"&chr(13)&chr(10)
		content=content&chr(64)&chr(64)&"2                  应收款："&FormatNumber(m_total,2)&"元"&chr(13)&chr(10)
		content=content&"========================"&chr(13)&chr(10)
		content=content&"会员：00"&uid&chr(13)&chr(10)
		content=content&"积分："&m_jf1&"    累计积分："&t_jf&chr(13)&chr(10)
		content=content&"电话："&s_tel&chr(13)&chr(10)
		content=content&"地址："&s_addr&chr(13)&chr(10)
		content=content&"时间："&now()&chr(13)&chr(10)
		content=content&"机号："&s_mcode&chr(13)&chr(10)&chr(13)&chr(10)
		content=content&"    <q>"&s_ewm&"</q>"&chr(13)&chr(10)
		content=content&"        微信扫描关注我们公众号"&chr(13)&chr(10)&chr(13)&chr(10)
		
		times=ToUnixTime(now(), +8)
		sign=s_mapi&"machine_code"&s_mcode&"partner"&s_mpartner&"time"&times&s_mkey'生成字符串
		sign=UCase(MD5(sign))'MD5加密，并转为大写
		mdate="partner="&s_mpartner&"&machine_code="&s_mcode&"&time="&times&"&sign="&sign&"&content="&content
		url = "http://open.10ss.net:8888"
		poststr=PostHTTPPage(url,mdate)
		Call InitScriptControl:Set objTest = getJSONObject(poststr)
		if cint(objTest.state)="1" then
			PostMsg "",myopenid,"您的订单："&m_orderid&"小票已经打印成功，我们将尽快处理！感谢您的购买！"  '给购买者发信息
		else
			PostMsg "",openID,"用户 “"&m_name&"” 小票打印失败。订单号："&m_orderid&"！"  '给管理员发信息
		end if
		set objTest=nothing
	end if
End Sub

%>