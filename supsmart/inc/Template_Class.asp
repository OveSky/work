<%
'*********************
'Code for IdeaCMS
'*********************

Class MainClass_Template
	Public content
	Private regExpObj,strDictionary
	Private labelRule,matches,match,labelRuleField,labelRulePagelist,matchesPagelist,matchPagelist
	Private labelStr,loopStr,whereStr,whereType,whereSort,whereTime,DateArray,matchesfield,loopstrTotal,lnum,i,nloopstr,matchfield,fieldNameArr,m,fieldName,fieldArr,titlelen,infolen,labelArr
	Private ltype,lsort,lorder,ltime,orderStr,timestyle,lordertype
	Private sql
	
	Public Sub Class_Initialize()
		set regExpObj= new RegExp
		regExpObj.ignoreCase = true
		regExpObj.Global = true
		set strDictionary = server.CreateObject("SCRIPTING.DICTIONARY")
	End Sub
	
	Public Sub Class_Terminate()
		set regExpObj = nothing
		set strDictionary = nothing
	End Sub

	Public Function regExpReplace(contentstr,patternstr,replacestr)
		regExpObj.Pattern = patternstr
		regExpReplace = regExpObj.replace(contentstr,replacestr)
	End Function
	
	Public Function parseArr(Byval attr)
		dim attrStr,attrArray,attrDictionary,i,singleAttr,singleAttrKey,singleAttrValue
		attrStr = regExpReplace(attr,"[\s]+",chr(32))
		attrStr = trim(attrStr)
		attrArray = split(attrStr,chr(32))
		for i=0 to ubound(attrArray)
			singleAttr = split(attrArray(i),chr(61))
			singleAttrKey =  singleAttr(0)
			singleAttrValue =  singleAttr(1)
			if not strDictionary.Exists(singleAttrKey) then strDictionary.add singleAttrKey,singleAttrValue else strDictionary(singleAttrKey) = singleAttrValue
		next
		set parseArr = strDictionary
	End Function
	
	Public Function load(Byval filePath)
		content = myfile.loadFile(filePath,"")
	End Function
	
	Public Function parseTemplate()
	    dim lurl
		labelRule = "{ideacms:mytemplate([\s\S]*?)}"
		regExpObj.Pattern = labelRule
		set matches = regExpObj.Execute(content)
		for each match in matches
			labelStr = match.SubMatches(0)
			lurl = parseArr(labelStr)("url")
			content = re(content,match.value,myfile.loadFile("/"&sitePath&"template/"&defaultTemplate&"/"&templateFileFolder&"/"&lurl&"",""))
			strDictionary.removeAll
		next
		set matches = nothing
		content = re(content,"../css/","/"&sitePath&"template/"&defaultTemplate&"/css/")
		content = re(content,"../images/","/"&sitePath&"template/"&defaultTemplate&"/images/")
		content = re(content,"../js/","/"&sitePath&"template/"&defaultTemplate&"/js/")
	End Function

	Public Function parseGlobal()
	    dim expandjs,expandarr,ei,picstr,expandstr
		content = re(content,"{ideacms:indexlink}","/"&sitePath)
		content = re(content,"{ideacms:sitename}",siteName)
		if not isnul(readCookie("shop")) then
			if cint(readCookie("shop"))>0 then
				if conn.db("select ShopType from {pre}Shop where ID="&cint(readCookie("shop"))&"","1")(0)=0 then
					content = re(content,"{ideacms:mydir}","mall")
					content = re(content,"{ideacms:shoptype}","商城")
				else
					content = re(content,"{ideacms:mydir}","reserve")
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
					content = re(content,"{ideacms:shoptype}","下单")
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
				end if
			else
				content = re(content,"{ideacms:mydir}","")
			end if
		end if
		dim picarr,str1,str2,i
		str1="<ul id='slider'>" : str2="<div id='pagenavi' style='text-align:right;'>"
		if instr(slidePic,"|")>0 then
		    picarr=split(slidePic,"|")
			for i=0 to ubound(picarr)-1
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
			content=re(content,"{ideacms:slide}",str1&str2)
		else
			content=re(content,"{ideacms:slide}","")
		end if
	End Function
	
	Public Function parseIf()
		if not isExistStr(content,"{if:") then Exit Function
		dim matchIf,matchesIf,strIf,strThen,strThen1,strElse1,labelRule2,labelRule3
		dim ifFlag,elseIfArray,elseIfSubArray,elseIfArrayLen,resultStr,elseIfLen,strElseIf,strElseIfThen,elseIfFlag
		labelRule="{if:([\s\S]+?)}([\s\S]*?){end\s+if}":labelRule2="{elseif":labelRule3="{else}":elseIfFlag=false
		regExpObj.Pattern=labelRule
		set matchesIf=regExpObj.Execute(content)
		for each matchIf in matchesIf 
			strIf=matchIf.SubMatches(0):strThen=matchIf.SubMatches(1)
			if instr(strThen,labelRule2)>0 then
				elseIfArray=split(strThen,labelRule2):elseIfArrayLen=ubound(elseIfArray):elseIfSubArray=split(elseIfArray(elseIfArrayLen),labelRule3)
				resultStr=elseIfSubArray(1)
				Execute("if  "&strIf&" then resultStr=elseIfArray(0)")
				for elseIfLen=1 to elseIfArrayLen-1
					strElseIf=getSubStrByFromAndEnd(elseIfArray(elseIfLen),":","}","")
					strElseIfThen=getSubStrByFromAndEnd(elseIfArray(elseIfLen),"}","","start")
					Execute("if  "&strElseIf&" then resultStr=strElseIfThen")
					Execute("if  "&strElseIf&" then elseIfFlag=true else  elseIfFlag=false")
					if elseIfFlag then exit for
				next
				Execute("if  "&getSubStrByFromAndEnd(elseIfSubArray(0),":","}","")&" then resultStr=getSubStrByFromAndEnd(elseIfSubArray(0),""}"","""",""start""):elseIfFlag=true")
				content=re(content,matchIf.value,resultStr)
			else 
				if instr(strThen,"{else}")>0 then 
					strThen1=split(strThen,labelRule3)(0)
					strElse1=split(strThen,labelRule3)(1)
					Execute("if  "&strIf&" then ifFlag=true else ifFlag=false")
					if ifFlag then content=re(content,matchIf.value,strThen1) else content=re(content,matchIf.value,strElse1)
				else
					Execute("if  "&strIf&" then ifFlag=true else ifFlag=false")
					if ifFlag then content=re(content,matchIf.value,strThen) else content=re(content,matchIf.value,"")
				end if
			end if
			elseIfFlag=false
		next
		set matchesIf=nothing
	End Function
	
	Private sltype,j,str,nid,rslinkArray,lshop
	Public Function parseChannel(str)
		labelRule="{ideacms:"&str&"channel([\s\S]*?)}([\s\S]*?){/ideacms:"&str&"channel}"
		labelRuleField="\["&str&"channel:([\s\S]+?)\]"
		regExpObj.Pattern = labelRule
		set matches = regExpObj.Execute(content)
		for each match in matches
			loopstrTotal=""
			labelStr=match.SubMatches(0)
			loopStr=match.SubMatches(1)
			lshop=parseArr(labelStr)("shop")
			if isNul(ltype) then ltype=1
			DateArray=conn.db("select ID,C_Name,ShopID,C_Pic from {pre}Category where ShopID="&lshop&" order by C_Sequence","3")
			if isArray(DateArray) then lnum=ubound(DateArray,2) else lnum=-1
			regExpObj.Pattern=labelRuleField
			set matchesfield=regExpObj.Execute(loopStr)
			for i=0 to lnum
				nloopstr=loopStr
				for each matchfield in matchesfield
					fieldNameArr=regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
					fieldNameArr=trim(fieldNameArr)
					m=instr(fieldNameArr,chr(32))
					if  m > 0 then 
						fieldName=left(fieldNameArr,m - 1)
						fieldArr =	right(fieldNameArr,len(fieldNameArr) - m)
					else
						fieldName=fieldNameArr
						fieldArr =	""
					end if
					select case fieldName
						case "i"
							nloopstr=re(nloopstr,matchfield.value,i+1)
						case "sid"
							nloopstr=re(nloopstr,matchfield.value,DateArray(0,i))
						case "typename"
							nloopstr=re(nloopstr,matchfield.value,DateArray(1,i))
						case "link"
							nloopstr=re(nloopstr,matchfield.value,"?m=list&s="&DateArray(0,i)&"&shop="&DateArray(2,i))
						case "pic"
							if not isNul(DateArray(3,i)) then 
								nloopstr = replace(nloopstr,matchfield.value,PubPic&DateArray(3,i))
							else
								nloopstr = replace(nloopstr,matchfield.value,"/"&sitePath&"inc/image/nopic_small.gif")
							end if
					end select
				next
				loopstrTotal=loopstrTotal&nloopstr
			next
			set matchesfield=nothing
			content=re(content,match.value,loopstrTotal)
			strDictionary.removeAll
		next
		set matches=nothing
		content=re(content,"[channel:num]",i)
	End Function
	
	Public Function parseLoop(Byval str)
		dim sortArr,sortStr,sortI,lstart,wherestart,pnum
		labelRule = "{ideacms:"&str&"([\s\S]*?)}([\s\S]*?){/ideacms:"&str&"}"
		labelRuleField = "\["&str&":([\s\S]+?)\]"
		regExpObj.Pattern = labelRule
		set matches = regExpObj.Execute(content)
		for each match in matches
		    labelStr = match.SubMatches(0) : loopStr = match.SubMatches(1)
			set labelArr = parseArr(labelStr)
			lnum = labelArr("size")
			lsort = labelArr("sort")
			lorder = labelArr("order")
			lordertype = labelArr("ordertype")
			ltype = labelArr("type") : if isnul(ltype) then ltype=1
			lnum=getint(lnum,10)
			sortStr=""
			if not isNul(lsort) then
				if instr(lsort,",")>0 then 
					sortArr=split(lsort,",")
					for sortI=0 to ubound(sortArr)
						sortStr=sortStr&sortArr(sortI)&","
					next
					sortStr=left(sortStr,len(sortStr)-1)
				else
					sortStr=lsort
				end if
				whereSort=" and SortID in ("&sortStr&")"
			else 
				whereSort=""
			end if
			if str="product" and ltype=1 then wherestart=" and isShow=1 and shopID in (select ID from {pre}shop where ShopType=0)"
			if isNul(lordertype) then lordertype = "desc"
			select case lorder
				case "hit" : orderStr =" order by hits "&lordertype&",ID "&lordertype
				case "top" : orderStr =" order by IsTop "&lordertype&",ID "&lordertype
				case "queue" : orderStr =" order by Sequence "&lordertype&",ID "&lordertype
				case "date" : orderStr =" order by AddDate "&lordertype&",ID "&lordertype
				case "hot" : orderStr =" order by PTotal "&lordertype&",ID "&lordertype
				case else : orderStr =" order by ID "&lordertype
			end select
			set labelArr = nothing
			sql="select top "&lnum&" * from {pre}"&str&" where 1=1"&wherestart&whereSort&orderStr
			DateArray = conn.db(sql,"3")
			regExpObj.Pattern = labelRuleField
			set matchesfield = regExpObj.Execute(loopStr)
			loopstrTotal = ""
			if isArray(DateArray) then lnum = ubound(DateArray,2) else lnum=-1
			for i = 0 to lnum
			    nloopstr=loopStr
			    for each matchfield in matchesfield
					fieldNameArr = regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32)) : fieldNameArr = trim(fieldNameArr)
					m = instr(fieldNameArr,chr(32))
					if  m > 0 then 
						fieldName = left(fieldNameArr,m-1) : fieldArr = right(fieldNameArr,len(fieldNameArr)-m)
					else
						fieldName = fieldNameArr : fieldArr = ""
					end if
					select case str
					    case "product"
							select case fieldName
								case "id"
									nloopstr = re(nloopstr,matchfield.value,DateArray(0,i))
								case "i"
									nloopstr = re(nloopstr,matchfield.value,i)
								case "title"
									titlelen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(DateArray(2,i),titlelen))
								case "typename"
									nloopstr = re(nloopstr,matchfield.value,TName(DateArray(1,i)))
								case "link"
									nloopstr = re(nloopstr,matchfield.value,"/"&sitePath&"mall/?m=show&s="&DateArray(1,i)&"&id="&DateArray(0,i)&"&shop="&DateArray(18,i)&"&uid="&OpenidToID(session("openid"))&"")
								case "pic"
									dim picnum : picnum=cint(DateArray(4,i))-1
									if not isNul(DateArray(3,i)) then 
										if instr(DateArray(3,i),"|")>0 then 
											nloopstr = replace(nloopstr,matchfield.value,PubPic&split(DateArray(3,i),"|")(picnum))
										else
											nloopstr = replace(nloopstr,matchfield.value,PubPic&DateArray(3,i))
										end if
									else
										nloopstr = replace(nloopstr,matchfield.value,"/"&sitePath&"inc/image/nopic_small.gif")
									end if
								case "info"
									infolen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(filterStr(decodeHtml(DateArray(9,i))),infolen))
								case "hits"
									nloopstr = re(nloopstr,matchfield.value,DateArray(12,i))
								case "total"
									nloopstr = re(nloopstr,matchfield.value,DateArray(17,i))
								case "yprice"
									nloopstr = re(nloopstr,matchfield.value,DateArray(5,i))
								case "dzprice"
									nloopstr = re(nloopstr,matchfield.value,DateArray(6,i))
								case "shop"
									nloopstr = re(nloopstr,matchfield.value,idToShop(DateArray(18,i)))
							end select
						case "shop"
						    select case fieldName
						        case "id"
									nloopstr = re(nloopstr,matchfield.value,DateArray(0,i))
								case "i"
									nloopstr = re(nloopstr,matchfield.value,i)
								case "title"
									titlelen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(DateArray(1,i),titlelen))
								case "link"
								    if cint(DateArray(3,i))=0 then
									    nloopstr = re(nloopstr,matchfield.value,"/"&sitePath&"mall/?shop="&DateArray(0,i)&"")
									else
									    nloopstr = re(nloopstr,matchfield.value,"/"&sitePath&"reserve/?shop="&DateArray(0,i)&"")
									end if
								case "type"
								    if cint(DateArray(3,i))=0 then
<!--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$-->
									    nloopstr = re(nloopstr,matchfield.value,"*")
									else
									    nloopstr = re(nloopstr,matchfield.value,"*")
<!--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$-->
									end if
								case "pic"
									if not isNul(DateArray(2,i)) then 
										if instr(DateArray(2,i),"|")>0 then 
											nloopstr = replace(nloopstr,matchfield.value,PubPic&split(DateArray(2,i),"|")(0))
										else
											nloopstr = replace(nloopstr,matchfield.value,PubPic&DateArray(2,i))
										end if
									else
										nloopstr = replace(nloopstr,matchfield.value,"/"&sitePath&"inc/image/nopic_small.gif")
									end if
								case "info"
									infolen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(filterStr(decodeHtml(DateArray(11,i))),infolen))
								case "hits"
									nloopstr = re(nloopstr,matchfield.value,DateArray(19,i))
								case "date"
									nloopstr = re(nloopstr,matchfield.value,DateArray(4,i))
								case "addr"
									nloopstr = re(nloopstr,matchfield.value,DateArray(5,i))
								case "tel"
									nloopstr = re(nloopstr,matchfield.value,DateArray(6,i))
							end select
					end select
				next
				loopstrTotal = loopstrTotal & nloopstr
			next
			set matchesfield = nothing : content = re(content,match.value,loopstrTotal) : strDictionary.removeAll
		next
		set matches = nothing
	End Function
	
	Public Function parseList(sortIds,currentPage,listType,ordertype,shopid)
	    dim lenPagelist,SortId,strPagelist,lsize,rsObj,sql,timestyle
		labelRule = "{ideacms:list([\s\S]*?)}([\s\S]*?){/ideacms:list}"
		labelRuleField = "\[list:([\s\S]+?)\]"
		regExpObj.Pattern = labelRule
		set matches = regExpObj.Execute(content)
		for each match in matches
		    labelStr = match.SubMatches(0)
			loopStr = match.SubMatches(1)
			set labelArr = parseArr(labelStr)
			lsize = getint(labelArr("size"),12)
			lorder = labelArr("order") : lordertype = labelArr("ordertype") : if isNul(lordertype) then lordertype="desc"
			select case ordertype
				case "id" : orderStr =" order by ID "&lordertype
				case "hit" : orderStr =" order by hits "&lordertype&",ID "&lordertype
				case "top" : orderStr =" order by IsTop "&lordertype&",ID "&lordertype
				case "queue" : orderStr =" order by Sequence "&lordertype&",ID "&lordertype
				case "date" : orderStr =" order by AddDate "&lordertype&",ID "&lordertype
				case "hot" : orderStr =" order by PTotal "&lordertype&",ID "&lordertype
				case else : orderStr =" order by ID "&lordertype
			end select
			set labelArr = nothing
			select case listType
			    case 1
				    dim s_str
'$$$$$$$$$$$$$$$$$					
'				    if isnul(shopid) then s_str="isShow=1" else s_str="isShow=1 and ShopID="&shopid&""
	             	if isnul(shopid) then s_str="isShow=1" else s_str="isShow=1 and ShopID=1"			
'$$$$$$$$$$$$$$$$$						
				    if isnul(sortIds) then
						sql="select * from {pre}Product where "&s_str&" and shopID in (select ID from {pre}shop where ShopType=0)"&orderStr
					else
						sql="select * from {pre}Product where "&s_str&" and SortID="&sortIds&orderStr
					end if
				case 2
			        sql="select * from {pre}Shop where 1=1"&orderStr
			end select
			regExpObj.Pattern = labelRuleField
			set matchesfield = regExpObj.Execute(loopStr)
			set rsObj=conn.db(sql,"1")
			if rsObj.eof then
			    loopstrTotal="对不起，该分类无任何记录"
			else
				rsObj.pagesize = lsize
				if cint(currentPage)>rsObj.pagecount then currentPage=rsObj.pagecount
				rsObj.absolutepage=currentPage
				loopstrTotal = ""
				for i = 1 to lsize
					nloopstr=loopStr
					for each matchfield in matchesfield
						fieldNameArr = regExpReplace(matchfield.SubMatches(0),"[\s]+",chr(32))
						fieldNameArr = trim(fieldNameArr)
						m = instr(fieldNameArr,chr(32))
						if  m > 0 then 
							fieldName = left(fieldNameArr,m - 1)
							fieldArr =	right(fieldNameArr,len(fieldNameArr) - m)
						else
							fieldName = fieldNameArr
							fieldArr =	""
						end if
						select case listType
						case 1									
							select case fieldName
								case "i"
									nloopstr = re(nloopstr,matchfield.value,i)
								case "title"
									titlelen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(rsObj("Title"),titlelen))
								case "typename"
									nloopstr = re(nloopstr,matchfield.value,TName(rsObj("SortID")))
								case "link"
									nloopstr = re(nloopstr,matchfield.value,"/"&sitePath&"mall/?m=show&s="&rsObj("SortID")&"&shop="&rsObj("ShopID")&"&id="&rsObj("ID")&"&uid="&OpenidToID(session("openid"))&"")
								case "pic"
									dim picnum : picnum=cint(rsObj("PicIndex"))-1
									if not isNul(rsObj("PicStr")) then 
										if instr(rsObj("PicStr"),"|")>0 then 
											if cint(configArr(3,0))=0 then
												nloopstr = replace(nloopstr,matchfield.value,PubPic&split(rsObj("PicStr"),"|")(picnum))
											else
												if myfile.isExistFile(PubPic&"s"&split(rsObj("PicStr"),"|")(picnum)) then
													nloopstr = replace(nloopstr,matchfield.value,PubPic&"s"&split(rsObj("PicStr"),"|")(picnum))
												else
													nloopstr = replace(nloopstr,matchfield.value,PubPic&split(rsObj("PicStr"),"|")(picnum))
												end if
											end if
										else
											nloopstr = replace(nloopstr,matchfield.value,PubPic&rsObj("PicStr"))
										end if
									else
										nloopstr = replace(nloopstr,matchfield.value,"/"&sitePath&"inc/image/nopic_small.gif")
									end if
								case "info"
									infolen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(filterStr(decodeHtml(rsObj("Content"))),infolen))
								case "hits"
									nloopstr = re(nloopstr,matchfield.value,rsObj("Hits"))
								case "date"
									timestyle = parseArr(fieldArr)("style") : if isNul(timestyle) then timestyle = "m-d"
									select case timestyle
										case "yy-m-d"
											nloopstr = re(nloopstr,matchfield.value,FormatDate(rsObj("AddDate"),1))
										case "y-m-d"
											nloopstr = re(nloopstr,matchfield.value,FormatDate(rsObj("AddDate"),2))
										case "m-d"
											nloopstr = re(nloopstr,matchfield.value,FormatDate(rsObj("AddDate"),3))
									end select
								case "yprice"
									nloopstr = re(nloopstr,matchfield.value,rsObj("YPrice"))
								case "dzprice"
									nloopstr = re(nloopstr,matchfield.value,rsObj("DZPrice"))
								case "total"
									nloopstr = re(nloopstr,matchfield.value,rsObj("PTotal"))
								case "shop"
									nloopstr = re(nloopstr,matchfield.value,idToShop(rsObj("ShopID")))
							end select
						case 2
						    select case fieldName
								case "i"
									nloopstr = re(nloopstr,matchfield.value,i)
								case "title"
									titlelen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(rsObj("Title"),titlelen))
								case "info"
									infolen = getint(parseArr(fieldArr)("len"),10)
									nloopstr = re(nloopstr,matchfield.value,left(filterStr(decodeHtml(rsObj("ShopPost"))),infolen))
								case "link"
								    if cint(rsObj("ShopType"))=0 then
									    nloopstr = re(nloopstr,matchfield.value,"/"&sitePath&"mall/?shop="&rsObj("ID")&"")
									else
									    nloopstr = re(nloopstr,matchfield.value,"/"&sitePath&"reserve/?shop="&rsObj("ID")&"")
									end if
								case "pic"
									if not isNul(rsObj("PicStr")) then 
										if instr(rsObj("PicStr"),"|")>0 then 
											if cint(configArr(3,0))=0 then
												nloopstr = replace(nloopstr,matchfield.value,PubPic&split(rsObj("PicStr"),"|")(0))
											else
												if myfile.isExistFile(PubPic&"s"&split(rsObj("PicStr"),"|")(0)) then
													nloopstr = replace(nloopstr,matchfield.value,PubPic&"s"&split(rsObj("PicStr"),"|")(0))
												else
													nloopstr = replace(nloopstr,matchfield.value,PubPic&split(rsObj("PicStr"),"|")(0))
												end if
											end if
										else
											nloopstr = replace(nloopstr,matchfield.value,PubPic&rsObj("PicStr"))
										end if
									else
										nloopstr = replace(nloopstr,matchfield.value,"/"&sitePath&"inc/image/nopic_small.gif")
									end if
								case "type"
									if cint(rsObj("ShopType"))=0 then
<!--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$-->
									    nloopstr = re(nloopstr,matchfield.value,"-")
									else
									    nloopstr = re(nloopstr,matchfield.value,"*")
<!--$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$-->
										end if
								case "addr"
									nloopstr = re(nloopstr,matchfield.value,rsObj("ShopAddr"))
							end select
						end select
					next
					loopstrTotal = loopstrTotal & nloopstr
					rsObj.movenext
					if rsObj.eof then exit for
				next
			end if
			content = re(content,match.value,loopstrTotal)
			set matchesfield = nothing
			strDictionary.removeAll
		next
		set matches = nothing
	End Function
	
	Public Function parseComm()
	    parseTemplate() : parseChannel("") : parseLoop("product") : parseLoop("shop") : parseGlobal() : parseIf()
	End Function
	
	Public Function parseComm1()
	    parseTemplate() : parseLoop("product") : parseLoop("shop") : parseGlobal()
	End Function
	
	Private Function FormatDate(Byval t,Byval ftype)
		select case cint(ftype)
			case 1 : FormatDate = year(t)&"-"&month(t)&"-"&day(t)
			case 2 : FormatDate = right(year(t),2)&"-"&month(t)&"-"&day(t)
			case 3 : FormatDate = month(t)&"-"&day(t)
			case 4 : FormatDate = year(t)&"/"&month(t)
			case 5 : FormatDate = day(t)
		end select
	End Function

End Class
%>