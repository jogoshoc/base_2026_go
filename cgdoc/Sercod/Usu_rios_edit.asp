<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Usu_rios_variables.asp"-->

<!--#include file="libs/smarty.asp"-->
<%

'//	check if logged in
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Edit") then
	SESSION("MyURL")=request.ServerVariables("SCRIPT_NAME")&"?"&request.ServerVariables("QUERY_STRING")
	response.Redirect "login.asp?message=expired"
	response.End
end if

Set myRequest = CreateObject("Scripting.Dictionary")
Set myRequestFiles = CreateObject("Scripting.Dictionary")
if ParseMultiPartForm()=true then parse=1
MaxSizeSet=false

filename=""
message=""
readevalues=false
errorhappened=false

' connect database
dbConnection=""
db_connect()


Set rs = server.CreateObject("ADODB.Recordset")

set keys = CreateObject("Scripting.Dictionary")
keys("NúmeroDoUsuário")=postvalue("editid1")

'//	prepare data for saving
if getRequestForm("a")="edited" then
	sstrWhere=KeyWhere(keys,"")
	strSQL = "select * from " & AddTableWrappers(strOriginalTableName) & " where " & sstrWhere
	'//	select only owned records
	strSQL = AddWhere(strSQL,SecuritySQL("Edit"))
	set evalues = CreateObject("Scripting.Dictionary")
	set efilename_values = CreateObject("Scripting.Dictionary")
	set files_delete = CreateObject("Scripting.Dictionary")
	set files_move = CreateObject("Scripting.Dictionary")
	
'//	processing NúmeroDoUsuário - start
	value = postvalue("value_N_meroDoUsu_rio")
	ttype=postvalue("type_N_meroDoUsu_rio")
	toedit=true

if myRequest.Exists("value_N_meroDoUsu_rio") or myRequest.Exists("value_N_meroDoUsu_rio[]") or myRequest.Exists("type_N_meroDoUsu_rio") then
			value=prepare_for_db("NúmeroDoUsuário",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("NúmeroDoUsuário") = value
			end if
	end if

'//	update key value
	if value<>false then
		if keys.Exists("NúmeroDoUsuário") then keys.Remove("NúmeroDoUsuário")
		keys("NúmeroDoUsuário")=value
	end if

'//	processibng NúmeroDoUsuário - end

'//	processing PG - start
	value = postvalue("value_PG")
	ttype=postvalue("type_PG")
	toedit=true

if myRequest.Exists("value_PG") or myRequest.Exists("value_PG[]") or myRequest.Exists("type_PG") then
			value=prepare_for_db("PG",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("PG") = value
			end if
	end if


'//	processibng PG - end

'//	processing Nome - start
	value = postvalue("value_Nome")
	ttype=postvalue("type_Nome")
	toedit=true

if myRequest.Exists("value_Nome") or myRequest.Exists("value_Nome[]") or myRequest.Exists("type_Nome") then
			value=prepare_for_db("Nome",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Nome") = value
			end if
	end if


'//	processibng Nome - end

'//	processing Ramal - start
	value = postvalue("value_Ramal")
	ttype=postvalue("type_Ramal")
	toedit=true

if myRequest.Exists("value_Ramal") or myRequest.Exists("value_Ramal[]") or myRequest.Exists("type_Ramal") then
			value=prepare_for_db("Ramal",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Ramal") = value
			end if
	end if


'//	processibng Ramal - end

'//	processing Unidade - start
	value = postvalue("value_Unidade")
	ttype=postvalue("type_Unidade")
	toedit=true

if myRequest.Exists("value_Unidade") or myRequest.Exists("value_Unidade[]") or myRequest.Exists("type_Unidade") then
			value=prepare_for_db("Unidade",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Unidade") = value
			end if
	end if


'//	processibng Unidade - end

'//	processing Seção - start
	value = postvalue("value_Se__o")
	ttype=postvalue("type_Se__o")
	toedit=true

if myRequest.Exists("value_Se__o") or myRequest.Exists("value_Se__o[]") or myRequest.Exists("type_Se__o") then
			value=prepare_for_db("Seção",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Seção") = value
			end if
	end if


'//	processibng Seção - end

'//	processing Fotografia - start
	value = postvalue("value_Fotografia")
	ttype=postvalue("type_Fotografia")
	toedit=true

if myRequest.Exists("value_Fotografia") or myRequest.Exists("value_Fotografia[]") or myRequest.Exists("type_Fotografia") then
			value=prepare_for_db("Fotografia",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Fotografia") = value
			end if
	end if


'//	processibng Fotografia - end

'//	processing Senha - start
	value = postvalue("value_Senha")
	ttype=postvalue("type_Senha")
	toedit=true

if myRequest.Exists("value_Senha") or myRequest.Exists("value_Senha[]") or myRequest.Exists("type_Senha") then
			value=prepare_for_db("Senha",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Senha") = value
			end if
	end if


'//	processibng Senha - end

'//	processing Privilegio - start
	value = postvalue("value_Privilegio")
	ttype=postvalue("type_Privilegio")
	toedit=true

if myRequest.Exists("value_Privilegio") or myRequest.Exists("value_Privilegio[]") or myRequest.Exists("type_Privilegio") then
			value=prepare_for_db("Privilegio",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Privilegio") = value
			end if
	end if


'//	processibng Privilegio - end


	for each ekey in efilename_values
		if evalues.Exists(ekey) then evalues.Remove(ekey)
		evalues(ekey) = efilename_values.Item(ekey)
	next
'//	do event
	retval=true
	DoEvent "retval=BeforeEdit(evalues,sstrWhere)"
	if retval then
	on error resume next
	rs.Open strSQL, dbConnection, 1,2
	call report_error
	if IsUpdatable(rs("NúmeroDoUsuário")) then
'	update NúmeroDoUsuário field
	strValue=false
	if evalues.exists("NúmeroDoUsuário") then 	_
		strValue = evalues.Item("NúmeroDoUsuário")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_N_meroDoUsu_rio")
								rs("NúmeroDoUsuário") = strValue					
		call report_error
	end if
	end if
'	update PG field
	strValue=false
	if evalues.exists("PG") then 	_
		strValue = evalues.Item("PG")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_PG")
								rs("PG") = strValue					
		call report_error
	end if
'	update Nome field
	strValue=false
	if evalues.exists("Nome") then 	_
		strValue = evalues.Item("Nome")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Nome")
								rs("Nome") = strValue					
		call report_error
	end if
'	update Ramal field
	strValue=false
	if evalues.exists("Ramal") then 	_
		strValue = evalues.Item("Ramal")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Ramal")
								rs("Ramal") = strValue					
		call report_error
	end if
'	update Unidade field
	strValue=false
	if evalues.exists("Unidade") then 	_
		strValue = evalues.Item("Unidade")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Unidade")
								rs("Unidade") = strValue					
		call report_error
	end if
'	update Seção field
	strValue=false
	if evalues.exists("Seção") then 	_
		strValue = evalues.Item("Seção")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Se__o")
								rs("Seção") = strValue					
		call report_error
	end if
'	update Fotografia field
	strValue=false
	if evalues.exists("Fotografia") then 	_
		strValue = evalues.Item("Fotografia")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Fotografia")
					if ctype="file1" then
			rs("Fotografia") = ""
		elseif ctype="file2" then
			binData=GetRequestForm("value_Fotografia")
			rs("Fotografia").AppendChunk binData
		End If
		call report_error
	end if
'	update Senha field
	strValue=false
	if evalues.exists("Senha") then 	_
		strValue = evalues.Item("Senha")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Senha")
								rs("Senha") = strValue					
		call report_error
	end if
'	update Privilegio field
	strValue=false
	if evalues.exists("Privilegio") then 	_
		strValue = evalues.Item("Privilegio")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Privilegio")
								rs("Privilegio") = strValue					
		call report_error
	end if
	if not errorhappened then
		rs.Update
		call report_error
	end if
	rs.Close
'//	delete & move files
	on error goto 0
	if not errorhappened then
		Set fso = CreateObject("Scripting.FileSystemObject")
		for each file in files_delete 
			if fso.FileExists(file) then fso.DeleteFile(file)
		next
		for each file in files_move
			if fso.FileExists(file) then fso.MoveFile file(0),file(1)
		next
'//	after add event
		DoEvent "AfterEdit()"
		message="<div class=message><<< " & "Recordar gravacao" & " >>></div>"
	end if
	else
		readevalues=true
	end if
end if

'//	get current values and show edit controls

strSQL = gstrSQL

sstrWhere=KeyWhere(keys,"")
strSQL = AddWhere(strSQL,sstrWhere)
'//	select only owned records
strSQL = AddWhere(strSQL,SecuritySQL("Edit"))

LogInfo(strSQL)
Set rs = nothing
Set rs = server.CreateObject("ADODB.Recordset")
rs.Open strSQL,dbConnection,1,2
if rs.EOF then
	response.redirect "Usu_rios_list.asp?a=return"
	response.end
end if

'//	include files

includes=""

'//	validation stuff
bodyonload=""
onsubmit=""
includes=includes & "<script language=""JavaScript"" src=""include/validate.js""></script>"
includes=includes & "<script language=""JavaScript"">"
includes=includes & "var TEXT_FIELDS_REQUIRED='" & addslashes("Os seguintes campos são requeridos") & "';"
includes=includes & "var TEXT_FIELDS_ZIPCODES='" & addslashes("") & "';"
includes=includes & "var TEXT_FIELDS_EMAILS='" & addslashes("Os seguintes campos precisam ser Emails válidos") & "';"
includes=includes & "var TEXT_FIELDS_NUMBERS='" & addslashes("Os seguintes campos precisam ser números") & "';"
includes=includes & "var TEXT_FIELDS_CURRENCY='" & addslashes("Os seguintes campos precisam ser no formato Moeda") & "';"
includes=includes & "var TEXT_FIELDS_PHONE='" & addslashes("Os seguintes campos precisam ser números de telefone") & "';"
includes=includes & "var TEXT_FIELDS_PASSWORD1='" & addslashes("Os seguintes campos precisam ser senhas válidas") & "';"
includes=includes & "var TEXT_FIELDS_PASSWORD2='" & addslashes("com um mínimo de 4 caracteres…") & "';"
includes=includes & "var TEXT_FIELDS_PASSWORD3='" & addslashes("Não pode ser ‘password’") & "';"
includes=includes & "var TEXT_FIELDS_STATE='" & addslashes("Os seguintes campos precisam ser nomes de Estados") & "';"
includes=includes & "var TEXT_FIELDS_SSN='" & addslashes("Os seguintes campos precisam ser dados de identificação") & "';"
includes=includes & "var TEXT_FIELDS_DATE='" & addslashes("Os seguintes campos precisam ser datas") & "';"
includes=includes & "var TEXT_FIELDS_TIME='" & addslashes("Os seguintes campos devem ter o formato de hora v&#225;lida (24 horas)") & "';"
includes=includes & "var TEXT_FIELDS_CC='" & addslashes("Os seguintes campos precisam ser de números  válidos de Cartão de Crédito") & "';"
includes=includes & "var TEXT_FIELDS_SSN='" & addslashes("Os seguintes campos precisam ser dados de identificação") & "';"
includes=includes & "</script>"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_N_meroDoUsu_rio','" & validatetype & "','NúmeroDoUsuário');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Nome','" & validatetype & "','Nome');"
  	validatetype="IsTime"
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Se__o','" & validatetype & "','Seção');"
	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Senha','" & validatetype & "','Senha');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Privilegio','" & validatetype & "','Privilegio');"

if bodyonload<>"" then
	onsubmit="return validate();"
	bodyonload="onload="""& bodyonload & """"
end if

if useAJAX then
	includes=includes & "<script language=""JavaScript"" src=""include/jquery.js""></script>"
	includes=includes & "<script language=""JavaScript"" src=""include/ajaxsuggest.js""></script>"
end if
includes=includes & "<script language=""JavaScript"" src=""include/jsfunctions.js""></script>"
includes=includes & "<script language=""JavaScript"">" & _
"var locale_dateformat = " & locale_info("LOCALE_IDATE") & ";" & _
"var locale_datedelimiter = """ & locale_info("LOCALE_SDATE") & """;" & _
"var bLoading=false;" & _
"var TEXT_PLEASE_SELECT='" & addslashes("Favor Selecionar") & "';"
if useAJAX then
	includes=includes & "var AUTOCOMPLETE_TABLE='Usu_rios_autocomplete.asp';" & vbcrlf
	includes=includes & "var SUGGEST_TABLE='Usu_rios_searchsuggest.asp';" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE='Usu_rios_lookupsuggest.asp';" & vbcrlf
end if
includes=includes & "</script>" & vbcrlf
if useAJAX then
	includes=includes & "<div id=""search_suggest""></div>" & vbcrlf
end if





smarty.Add "includes",includes
smarty.Add "bodyonload",bodyonload

if len(onsubmit)>0 then onsubmit="onSubmit=""" & onsubmit & """"
smarty.Add "onsubmit",onsubmit

smarty.Add "key1",my_htmlspecialchars(keys("NúmeroDoUsuário"))
	smarty.Add "show_key1", my_htmlspecialchars(GetData(rs,"NúmeroDoUsuário", ""))

smarty.Add "message",message


max_filesize_set=0
set readonlyfields = CreateObject("Scripting.Dictionary")


	if readevalues then
		smarty.Add "value_N_meroDoUsu_rio",evalues("NúmeroDoUsuário")
	else
		smarty.Add "value_N_meroDoUsu_rio",dbvalue(rs("NúmeroDoUsuário"))
	end if
	if readevalues then
		smarty.Add "value_PG",evalues("PG")
	else
		smarty.Add "value_PG",dbvalue(rs("PG"))
	end if
	if readevalues then
		smarty.Add "value_Nome",evalues("Nome")
	else
		smarty.Add "value_Nome",dbvalue(rs("Nome"))
	end if
	if readevalues then
		smarty.Add "value_Ramal",evalues("Ramal")
	else
		smarty.Add "value_Ramal",dbvalue(rs("Ramal"))
	end if
	if readevalues then
		smarty.Add "value_Unidade",evalues("Unidade")
	else
		smarty.Add "value_Unidade",dbvalue(rs("Unidade"))
	end if
	if readevalues then
		smarty.Add "value_Se__o",evalues("Seção")
	else
		smarty.Add "value_Se__o",dbvalue(rs("Seção"))
	end if
	smarty.Add "value_Fotografia",""
	if readevalues then
		smarty.Add "value_Senha",evalues("Senha")
	else
		smarty.Add "value_Senha",dbvalue(rs("Senha"))
	end if
	if readevalues then
		smarty.Add "value_Privilegio",evalues("Privilegio")
	else
		smarty.Add "value_Privilegio",dbvalue(rs("Privilegio"))
	end if


linkdata=""

if useAJAX then
	linkdata = linkdata & "<script type=""text/javascript"">" & vbCrLf
	linkdata = linkdata & "$(document).ready(function(){ " & vbCrLf
	linkdata = linkdata & "function loadSelectContent(txt, selectControl, selectValue) {" & vbCrLf
	linkdata = linkdata & "$(""#""+selectControl).get(0).options[0]=new Option(TEXT_PLEASE_SELECT,"""");" & vbCrLf
	linkdata = linkdata & "var str = txt.split(""\n"")" & vbCrLf
	linkdata = linkdata & "var index = 0;" & vbCrLf
	linkdata = linkdata & "for(i=0,j=0; i < str.length - 1; i=i+2, j++) {" & vbCrLf
	linkdata = linkdata & "$(""#""+selectControl).get(0).options[j+1]=new Option(unescape(str[i+1]),unescape(str[i]));" & vbCrLf
	linkdata = linkdata & "if ( unescape(str[i]) == selectValue ) {index = j+1;} " & vbCrLf
	linkdata = linkdata & "}" & vbCrLf
	linkdata = linkdata & "$(""#""+selectControl).get(0).selectedIndex = index; }" & vbCrLf

	
	linkdata = linkdata & "});" & vbCrLf
	linkdata = linkdata & "</script>" & vbCrLf
else
end if

smarty.Add "linkdata",linkdata

where=sstrWhere

smarty_display("Usu_rios_edit.htm")

sub report_error
	if Err.number<>0 then
	  message = "<div class=message><<< " & "Registro NÃO foi editado" & " >>><br><br>" & Err.Description & "</div>"
	  readevalues=true
	  errorhappened=true
	  err.clear
	end if
end sub
%>
