<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Usu_rios_variables.asp"-->

<%
if SESSION("UserID")="" then
	SESSION("MyURL")=request.ServerVariables("SCRIPT_NAME")&"?"&request.ServerVariables("QUERY_STRING")
	response.Redirect "login.asp?message=expired"
	response.End
end if
if not CheckSecurity(SESSION("OwnerID"),"Search") and  not CheckSecurity(SESSION("OwnerID"),"Add") then
	response.Write "<p>" & "Você não tem permissão para acessar esta tabela" & " <a href=""login.asp"">" & "Voltar à página de Login" & "</a></p>"
	response.End
end if
%>

<!--#include file="libs/smarty.asp"-->

<%
	on error resume next

	dbConnection=""
	db_connect()
	call ReportError
   	Set rs = server.CreateObject("ADODB.Recordset")
   	Set rss = server.CreateObject("ADODB.Recordset")


'	process reqest data, fill session variables

if (Request.Form="" and Request.QueryString="") then

	For Each key in Session.Contents
		if left(key, len(strTableName)+1 ) = strTableName & "_"  and _
				InStr(Mid(key, len(strTableName)+2), "_" )<1 then
			Session.Contents.Remove(key)
		end if
	Next

	set strTableName_asearchnot = CreateObject("Scripting.Dictionary")
	set strTableName_asearchopt = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfor = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfortype = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfor2 = CreateObject("Scripting.Dictionary")
	set session(strTableName & "_asearchnot")= strTableName_asearchnot
	set session(strTableName & "_asearchopt") = strTableName_asearchopt
	set session(strTableName & "_asearchfor") = strTableName_asearchfor
	set session(strTableName & "_asearchfor2") = strTableName_asearchfor2
	set session(strTableName & "_asearchfortype") = strTableName_asearchfortype
end if

if REQUEST("a")="showall" then
	SESSION(strTableName & "_search")=0
elseif REQUEST("a")="search" then
		SESSION(strTableName & "_searchfield")=postvalue("SearchField")
		SESSION(strTableName & "_searchoption")=postvalue("SearchOption")
		SESSION(strTableName & "_searchfor")=postvalue("SearchFor")
		if postvalue("SearchFor")<>"" or postvalue("SearchOption")="Empty" then
			SESSION(strTableName & "_search")=1
		else
			SESSION(strTableName & "_search")=0
		end if
		SESSION(strTableName & "_pagenumber")=1
elseif REQUEST("a")="advsearch" then

	set strTableName_asearchnot = CreateObject("Scripting.Dictionary")
	set strTableName_asearchopt = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfor = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfor2 = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfortype = CreateObject("Scripting.Dictionary")
		
	tosearch=0
	asearchfield = postvalue("asearchfield[]")
	if not isarray(asearchfield) then
	  dim t
	  t=asearchfield
	  redim asearchfield(1)
	  asearchfield(0)=t
	end if
	SESSION(strTableName & "_asearchtype") = postvalue("type")
	if SESSION(strTableName & "_asearchtype")="" then SESSION(strTableName & "_asearchtype")="and"
	for field=0 to ubound(asearchfield)
		gfield=asearchfield(field)
		asopt=postvalue("asearchopt_" & GoodFieldName(asearchfield(field)))
		value1=postvalue("value_" & GoodFieldName(asearchfield(field)))
		if value1="" then value1=postvalue("value_" & GoodFieldName(asearchfield(field)) & "[]")
		ttype=postvalue("type_" & GoodFieldName(asearchfield(field)))
		value2=postvalue("value1_" & GoodFieldName(asearchfield(field)))
		if value2="" then value2=postvalue("value_1" & GoodFieldName(asearchfield(field)) & "[]")
		nnot=postvalue("not_" & GoodFieldName(asearchfield(field)))
		
		if not SafeIsEmpty(value1) or asopt="Empty" then
			tosearch=1
			strTableName_asearchopt.Add gfield,asopt
			if not isArray(value1) then 
				strTableName_asearchfor.Add gfield,value1
			else
				strTableName_asearchfor.Add gfield,combinevalues(value1)
			end if
			strTableName_asearchfortype.Add gfield,ttype
			if not SafeIsEmpty(value2) then strTableName_asearchfor2.Add gfield,value2
			strTableName_asearchnot.Add gfield,nnot
		end if
	next
	set SESSION(strTableName & "_asearchnot")= strTableName_asearchnot
	set SESSION(strTableName & "_asearchfortype")= strTableName_asearchfortype
	set SESSION(strTableName & "_asearchopt") = strTableName_asearchopt
	set SESSION(strTableName & "_asearchfor") = strTableName_asearchfor
	set SESSION(strTableName & "_asearchfor2") = strTableName_asearchfor2
	if tosearch<>0 then
		SESSION(strTableName & "_search")=2
	else
		SESSION(strTableName & "_search")=0
	end if
	SESSION(strTableName & "_pagenumber")=1
end if


if REQUEST("orderby")<> "" then SESSION(strTableName & "_orderby")=REQUEST("orderby")

if REQUEST("pagesize")<>"" then
	SESSION(strTableName & "_pagesize")=REQUEST("pagesize")
	SESSION(strTableName & "_pagenumber")=1
end if

if REQUEST("goto")<>"" then SESSION(strTableName & "_pagenumber")=REQUEST("goto")


'	process reqest data - end

includes=""

if useAJAX then
	includes = includes & "<script language=""JavaScript"" type=""text/javascript"" src=""include/jquery.js""></script>" & vbCrLf
	includes = includes & "<script language=""JavaScript"" type=""text/javascript"" src=""include/ajaxsuggest.js""></script>" & vbCrLf
end if
includes = includes & "<script language=""JavaScript"" src=""include/jsfunctions.js""></script>" & vbCrLf
includes = includes & "<script type=""text/javascript"">var bSelected=false;" & vbCrLf 
includes = includes & "var TEXT_FIRST = """ & "Primeiro" & """;" & vbCrLf
includes = includes & "var TEXT_PREVIOUS = """ & "Anterior" & """;" & vbCrLf 
includes = includes & "var TEXT_NEXT = """ & "Próximo" & """;" & vbCrLf
includes = includes & "var TEXT_LAST = """ & "Último" & """;" &vbCrLf
if useAJAX then
	includes = includes & "var SUGGEST_TABLE = ""Usu_rios_searchsuggest.asp"";" & vbCrLf
	includes = includes & "var MASTER_PREVIEW_TABLE = ""Usu_rios_masterpreview.asp"";" & vbCrLf
end if
includes = includes & "</script>" & vbCrLf
if useAJAX then
	includes = includes & "<div id=""search_suggest""></div><div id=""master_details""></div>" & vbCrLf
end if

smarty.Add "includes",includes
smarty.Add "useAJAX",useAJAX

'	process session variables
'	order by
strOrderBy=""
order_ind=-1

smarty.Add "order_dir_N_meroDoUsu_rio","a"
smarty.Add "order_dir_PG","a"
smarty.Add "order_dir_Nome","a"
smarty.Add "order_dir_Ramal","a"
smarty.Add "order_dir_Unidade","a"
smarty.Add "order_dir_Se__o","a"
smarty.Add "order_dir_Fotografia","a"
smarty.Add "order_dir_Privilegio","a"

if SESSION(strTableName & "_orderby")<> "" then
	order_field=mid(SESSION(strTableName & "_orderby"),2)
	order_dir=mid(SESSION(strTableName & "_orderby"),1,1)
	order_ind=GetFieldIndex(order_field,"")

	
	AddDict smarty,"order_dir_N_meroDoUsu_rio","a"
	if order_field="NúmeroDoUsuário" then
		if order_dir="a" then
			AddDict smarty,"order_dir_N_meroDoUsu_rio","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_N_meroDoUsu_rio","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_PG","a"
	if order_field="PG" then
		if order_dir="a" then
			AddDict smarty,"order_dir_PG","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_PG","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_Nome","a"
	if order_field="Nome" then
		if order_dir="a" then
			AddDict smarty,"order_dir_Nome","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_Nome","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_Ramal","a"
	if order_field="Ramal" then
		if order_dir="a" then
			AddDict smarty,"order_dir_Ramal","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_Ramal","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_Unidade","a"
	if order_field="Unidade" then
		if order_dir="a" then
			AddDict smarty,"order_dir_Unidade","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_Unidade","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_Se__o","a"
	if order_field="Seção" then
		if order_dir="a" then
			AddDict smarty,"order_dir_Se__o","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_Se__o","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_Fotografia","a"
	if order_field="Fotografia" then
		if order_dir="a" then
			AddDict smarty,"order_dir_Fotografia","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_Fotografia","<img src=""images/" & img & ".gif"" border=0>"
	end if
	
	AddDict smarty,"order_dir_Privilegio","a"
	if order_field="Privilegio" then
		if order_dir="a" then
			AddDict smarty,"order_dir_Privilegio","d"
			img="up"
		else
			img="down"
		end if
		AddDict smarty,"order_image_Privilegio","<img src=""images/" & img & ".gif"" border=0>"
	end if

	if order_ind<>"" then
		if order_dir="a" then
			strOrderBy="order by " & (order_ind) & " asc"
		else 
			strOrderBy="order by " & (order_ind) & " desc"
		end if
	end if
end if
if strOrderBy="" then strOrderBy=gstrOrderBy

'	page number
mypage=cint(SESSION(strTableName & "_pagenumber"))
if mypage=0 then mypage=1

'	page size
PageSize=cint(SESSION(strTableName & "_pagesize"))
if PageSize=0 then PageSize=gPageSize

	s=""
	if PageSize=10 then s="selected"
	smarty.Add "rpp10_selected",s
	s=""
	if PageSize=20 then s="selected"
	smarty.Add "rpp20_selected",s
	s=""
	if PageSize=30 then s="selected"
	smarty.Add "rpp30_selected",s
	s=""
	if PageSize=50 then s="selected"
	smarty.Add "rpp50_selected",s
	s=""
	if PageSize=100 then s="selected"
	smarty.Add "rpp100_selected",s
	s=""
	if PageSize=500 then s="selected"
	smarty.Add "rpp500_selected",s

' delete record
if request("mdelete[]").Count>0 then
	set keys = CreateObject("Scripting.Dictionary")
	for ind=1 to request("mdelete[]").Count
		AddDict keys,"NúmeroDoUsuário",request("mdelete1[]").Item(request("mdelete[]").Item(ind))
		strSQL="delete from " & AddTableWrappers(strOriginalTableName) & " where " & KeyWhere(keys,"")
'	delete only owned records
		strSQL=AddWhere(strSQL,SecuritySQL("Delete"))
		retval=true
		where = mid(strSQL,len("delete from " & AddTableWrappers(strOriginalTableName) & " where "))
		DoEvent "retval = BeforeDelete(""" & replace(where,"""","""""") & """)"
		if retval then
					LogInfo(strSQL)
			dbConnection.Execute strSQL
			DoEvent "AfterDelete()"
		end if
	next
	DoEvent "AfterMassDelete()"
end if

'	make sql "select" string

strSQL = gstrSQL

'	add search params

if SESSION(strTableName & "_search")=1 then
'	 regular search
	strSearchFor=trim(SESSION(strTableName & "_searchfor"))
	strSearchOption=trim(SESSION(strTableName & "_searchoption"))
	if SESSION(strTableName & "_searchfield")<> "" then
		strSearchField = SESSION(strTableName & "_searchfield")
		where = StrWhere(strSearchField, strSearchFor, strSearchOption, "")
		if where <>"" then
			strSQL = AddWhere(strSQL,where)
		else
			strSQL = AddWhere(strSQL,"1=0")
		end if
	else
		sstrWhere = "1=0"
		where=StrWhere("NúmeroDoUsuário", strSearchFor, strSearchOption, "")
		if where<>"" then sstrWhere=sstrWhere &  " or " & where
		where=StrWhere("Nome", strSearchFor, strSearchOption, "")
		if where<>"" then sstrWhere=sstrWhere &  " or " & where
		where=StrWhere("Seção", strSearchFor, strSearchOption, "")
		if where<>"" then sstrWhere=sstrWhere &  " or " & where
		where=StrWhere("Privilegio", strSearchFor, strSearchOption, "")
		if where<>"" then sstrWhere=sstrWhere &  " or " & where
		strSQL = AddWhere(strSQL,sstrWhere)
	end if

else 
	if SESSION(strTableName & "_search")=2 then
	'	 advanced search
		
		set strTableName_asearchfortype = SESSION(strTableName & "_asearchfortype")
		set strTableName_asearchnot = SESSION(strTableName & "_asearchnot")
		set strTableName_asearchopt = SESSION(strTableName & "_asearchopt")
		set strTableName_asearchfor = SESSION(strTableName & "_asearchfor")
		set strTableName_asearchfor2 = SESSION(strTableName & "_asearchfor2")

		sWhere=""
		for each f in strTableName_asearchfor
			strSearchFor=trim(strTableName_asearchfor.item(f))
			strSearchFor2=""
			ttype=strTableName_asearchfortype.item(f)
			
			for each i in strTableName_asearchfor2
				if f=i then strSearchFor2=trim(strTableName_asearchfor2.item(i))
			next
		
			if strSearchFor<>"" or true then
				if sWhere="" then
					if session(strTableName & "_asearchtype")="and" then
						sWhere="1=1"
					else
						sWhere="1=0"
					end if
				end if
				snot=strTableName_asearchnot.item(f)
				strSearchOption=trim(strTableName_asearchopt.Item(f))
				where=""
				where=StrWhereAdv(f, strSearchFor, strSearchOption, strSearchFor2,ttype)
				if where<>"" then
					if snot<>"" then where="not (" & where & ")"
					if SESSION(strTableName & "_asearchtype")="and" then
	   					sWhere=sWhere &  " and " & where
					else
	   					sWhere=sWhere &  " or " & where
	   				end if
				end if
			end if
		next
		strSQL = AddWhere(strSQL,sWhere)
	end if
end if
	



if SecuritySQL("Search")<>"" then strSQL = AddWhere(strSQL, SecuritySQL("Search"))



'	order by
strSQL=strSQL & " " & trim(strOrderBy)

'	save SQL for use in "Export" and "Printer-friendly" pages

SESSION(strTableName & "_sql") = strSQL

LogInfo(strSQL)


'	select and display records
if CheckSecurity(SESSION("OwnerID"),"Search") then
'	 Pagination:
	numrows=GetRowCount(strSQL)
	if numrows=0 then
		smarty.Add "rowsfound",false
		smarty.Add "message", "Nenhum Registro Encontrado"
	else
		smarty.Add "rowsfound",true
		smarty.Add "records_found",numrows
		maxRecords = numrows
		maxpages=int(maxRecords/PageSize)
		if maxRecords mod PageSize <> 0 then maxpages=maxpages+1
		if mypage > maxpages then mypage = maxpages
		if mypage<1 then mypage=1
		maxrecs=PageSize
		smarty.Add "page",mypage
		smarty.Add "maxpages",maxpages

'	write pagination
smarty.Add "pagination","<script language=""JavaScript"">WritePagination(" & mypage & "," & maxpages & ");function GotoPage(nPageNumber){window.location='Usu_rios_list.asp?goto='+nPageNumber;}</script>"
		
		strSQL = AddTop(strSQL, mypage*PageSize)
	end if
	rs.Open strSQL, dbConnection,1,2
	call ReportError
	if not rs.EOF then rs.Move(PageSize*(mypage-1))

'	hide colunm headers if needed
recordsonpage=numrows-(mypage-1)*PageSize
if recordsonpage>PageSize then _
	recordsonpage=PageSize
	if recordsonpage>=1 then
		smarty.Add "column1show",true
	else
		smarty.Add "column1show",false
	end if


	Set rowinfo = CreateObject("Scripting.Dictionary")
	shade=false
	recno=1
	editlink=""
	copylink=""
	ri=0
	Set fso = CreateObject("Scripting.FileSystemObject")
	while not rs.eof and recno<=PageSize
	Set row = CreateObject("Scripting.Dictionary")
		if not shade then
			row.Add "shadeclass","class=""shade"""
			row.Add "shadeclassname","shade"
			shade=true
		else
			row.Add "shadeclass",""
			row.Add "shadeclassname",""
			shade=false
		end if
col=0
		while not rs.EOF and recno<=PageSize and col<1
			col=col+1


'	key fields
			row.Add col & "id1",my_htmlspecialchars(dbvalue(rs("NúmeroDoUsuário")))
			row.Add col & "recno",recno
			recno=recno+1
'	detail tables
'	edit page link
			editlink=""
			editlink=editlink & "editid1=" & my_htmlspecialchars(SafeURLEncode(dbvalue(rs("NúmeroDoUsuário"))))
			row.Add col & "editlink",editlink

			copylink=""
			copylink=copylink & "copyid1=" & my_htmlspecialchars(SafeURLEncode(dbvalue(rs("NúmeroDoUsuário"))))
			row.Add col & "copylink",copylink
			keylink=""
			keylink=keylink & "&key1=" & my_htmlspecialchars(SafeURLEncode(dbvalue(rs("NúmeroDoUsuário"))))


'	NúmeroDoUsuário - 
	value=""
				value = ProcessLargeText(GetData(rs,"NúmeroDoUsuário", ""),"field=N%FAmeroDoUsu%E1rio" & keylink,"",MODE_LIST)
			row.Add col & "N_meroDoUsu_rio_value",value

'	PG - 
	value=""
				value = ProcessLargeText(GetData(rs,"PG", ""),"field=PG" & keylink,"",MODE_LIST)
			row.Add col & "PG_value",value

'	Nome - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nome", ""),"field=Nome" & keylink,"",MODE_LIST)
			row.Add col & "Nome_value",value

'	Ramal - 
	value=""
				value = ProcessLargeText(GetData(rs,"Ramal", ""),"field=Ramal" & keylink,"",MODE_LIST)
			row.Add col & "Ramal_value",value

'	Unidade - 
	value=""
				value = ProcessLargeText(GetData(rs,"Unidade", ""),"field=Unidade" & keylink,"",MODE_LIST)
			row.Add col & "Unidade_value",value

'	Seção - 
	value=""
				value = ProcessLargeText(GetData(rs,"Seção", ""),"field=Se%E7%E3o" & keylink,"",MODE_LIST)
			row.Add col & "Se__o_value",value

'	Fotografia - Database Image
	value=""
						value = "<img"
									value=value & " border=0"
			value=value & " src=""Usu_rios_imager.asp?field=Fotografia" & keylink & """>"
			row.Add col & "Fotografia_value",value

'	Privilegio - 
	value=""
				value = ProcessLargeText(GetData(rs,"Privilegio", ""),"field=Privilegio" & keylink,"",MODE_LIST)
			row.Add col & "Privilegio_value",value
		row.Add col & "show",true
		rs.MoveNext
		wend
		rowinfo.add ri,row
		ri=ri+1
	wend
	smarty.Add "rowinfo",rowinfo
	rs.Close
end if




if CheckSecurity(SESSION("OwnerID"),"Search") then
	if SESSION(strTableName & "_search")=1 then
		onload = "onLoad=""if(document.getElementById('SearchFor')) document.getElementById('ctlSearchFor').focus();"""
		smarty.Add "onload",onload
'	fill in search variables
'	//	field selection
		if SESSION(strTableName& "_searchfield")="NúmeroDoUsuário" then smarty.Add "search_N_meroDoUsu_rio","selected"
		if SESSION(strTableName& "_searchfield")="Nome" then smarty.Add "search_Nome","selected"
		if SESSION(strTableName& "_searchfield")="Seção" then smarty.Add "search_Se__o","selected"
		if SESSION(strTableName& "_searchfield")="Privilegio" then smarty.Add "search_Privilegio","selected"
'	// search type selection
		if SESSION(strTableName & "_searchoption")="Contains" then smarty.Add "search_contains_option_selected","selected"
		if SESSION(strTableName & "_searchoption")="Equals" then smarty.Add "search_equals_option_selected","selected"
		if SESSION(strTableName & "_searchoption")="Starts with ..." then smarty.Add "search_startswith_option_selected","selected"
		if SESSION(strTableName & "_searchoption")="More than ..." then smarty.Add "search_more_option_selected","selected"	
		if SESSION(strTableName & "_searchoption")="Less than ..." then smarty.Add "search_less_option_selected","selected"		
		if SESSION(strTableName & "_searchoption")="Equal or more than ..." then smarty.Add "search_equalormore_option_selected","selected"	
		if SESSION(strTableName & "_searchoption")="Equal or less than ..." then smarty.Add "search_equalorless_option_selected","selected"
		if SESSION(strTableName & "_searchoption")="Empty" then smarty.Add "search_empty_option_selected","selected"	

		smarty.Add "search_searchfor","value=""" & my_htmlspecialchars(SESSION(strTableName & "_searchfor")) & """"
	end if
end if

smarty.Add "userid",my_htmlspecialchars(SESSION("UserID"))


'	table selector
strPerm = GetUserPermissions("Cadastro")
f=false
if instr(strPerm, "A")<>0 or instr(strPerm, "S")<>0 then f=true
smarty.Add "allow_Cadastro",f
strPerm = GetUserPermissions("Impr_recibo")
f=false
if instr(strPerm, "A")<>0 or instr(strPerm, "S")<>0 then f=true
smarty.Add "allow_Impr_recibo",f
strPerm = GetUserPermissions("Tramitacao")
f=false
if instr(strPerm, "A")<>0 or instr(strPerm, "S")<>0 then f=true
smarty.Add "allow_Tramitacao",f
strPerm = GetUserPermissions("Usuários")
f=false
if instr(strPerm, "A")<>0 or instr(strPerm, "S")<>0 then f=true
smarty.Add "allow_Usu_rios",f
strPerm = GetUserPermissions("_AudMoviment")
f=false
if instr(strPerm, "A")<>0 or instr(strPerm, "S")<>0 then f=true
smarty.Add "allow__AudMoviment",f

smarty.Add "displayheader","<script language=""JavaScript"">DisplayHeader();</script>"

	smarty.Add "allow_delete",CheckSecurity(SESSION("OwnerID"),"Delete")
	smarty.Add "allow_add",CheckSecurity(SESSION("OwnerID"),"Add")
	smarty.Add "allow_edit",CheckSecurity(SESSION("OwnerID"),"Edit")
	smarty.Add "allow_export",CheckSecurity(SESSION("OwnerID"),"Export")
	smarty.Add "allow_search",CheckSecurity(SESSION("OwnerID"),"Search")
	if CheckSecurity(SESSION("OwnerID"),"Delete") or CheckSecurity(SESSION("OwnerID"),"Export") then
		smarty.Add "allow_deleteorexport", True
	else
		smarty.Add "allow_deleteorexport", False
	end if



strSQL=SESSION(strTableName & "_sql")

smarty_display("Usu_rios_list.htm")

%>