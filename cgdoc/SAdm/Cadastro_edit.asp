<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Cadastro_variables.asp"-->

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
keys("NrProtoc")=postvalue("editid1")

'//	prepare data for saving
if getRequestForm("a")="edited" then
	sstrWhere=KeyWhere(keys,"")
	strSQL = "select * from " & AddTableWrappers(strOriginalTableName) & " where " & sstrWhere
	set evalues = CreateObject("Scripting.Dictionary")
	set efilename_values = CreateObject("Scripting.Dictionary")
	set files_delete = CreateObject("Scripting.Dictionary")
	set files_move = CreateObject("Scripting.Dictionary")
	
'//	processing DtEntr - start
	value = postvalue("value_DtEntr")
	ttype=postvalue("type_DtEntr")
	toedit=true

if myRequest.Exists("value_DtEntr") or myRequest.Exists("value_DtEntr[]") or myRequest.Exists("type_DtEntr") then
			value=prepare_for_db("DtEntr",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("DtEntr") = value
			end if
	end if


'//	processibng DtEntr - end

'//	processing Descr - start
	value = postvalue("value_Descr")
	ttype=postvalue("type_Descr")
	toedit=true

if myRequest.Exists("value_Descr") or myRequest.Exists("value_Descr[]") or myRequest.Exists("type_Descr") then
			value=prepare_for_db("Descr",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Descr") = value
			end if
	end if


'//	processibng Descr - end

'//	processing Emissor - start
	value = postvalue("value_Emissor")
	ttype=postvalue("type_Emissor")
	toedit=true

if myRequest.Exists("value_Emissor") or myRequest.Exists("value_Emissor[]") or myRequest.Exists("type_Emissor") then
			value=prepare_for_db("Emissor",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Emissor") = value
			end if
	end if


'//	processibng Emissor - end

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

'//	processing Assunto - start
	value = postvalue("value_Assunto")
	ttype=postvalue("type_Assunto")
	toedit=true

if myRequest.Exists("value_Assunto") or myRequest.Exists("value_Assunto[]") or myRequest.Exists("type_Assunto") then
			value=prepare_for_db("Assunto",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Assunto") = value
			end if
	end if


'//	processibng Assunto - end

'//	processing TipoDoc - start
	value = postvalue("value_TipoDoc")
	ttype=postvalue("type_TipoDoc")
	toedit=true

if myRequest.Exists("value_TipoDoc") or myRequest.Exists("value_TipoDoc[]") or myRequest.Exists("type_TipoDoc") then
			value=prepare_for_db("TipoDoc",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("TipoDoc") = value
			end if
	end if


'//	processibng TipoDoc - end

'//	processing Nat - start
	value = postvalue("value_Nat")
	ttype=postvalue("type_Nat")
	toedit=true

if myRequest.Exists("value_Nat") or myRequest.Exists("value_Nat[]") or myRequest.Exists("type_Nat") then
			value=prepare_for_db("Nat",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Nat") = value
			end if
	end if


'//	processibng Nat - end

'//	processing Destino - start
	value = postvalue("value_Destino")
	ttype=postvalue("type_Destino")
	toedit=true

if myRequest.Exists("value_Destino") or myRequest.Exists("value_Destino[]") or myRequest.Exists("type_Destino") then
			value=prepare_for_db("Destino",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Destino") = value
			end if
	end if


'//	processibng Destino - end

'//	processing Obs - start
	value = postvalue("value_Obs")
	ttype=postvalue("type_Obs")
	toedit=true

if myRequest.Exists("value_Obs") or myRequest.Exists("value_Obs[]") or myRequest.Exists("type_Obs") then
			value=prepare_for_db("Obs",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Obs") = value
			end if
	end if


'//	processibng Obs - end


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
'	update Controle field
	strValue=false
	if evalues.exists("Controle") then 	_
		strValue = evalues.Item("Controle")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Controle")
								if strValue<>"" and IsNumeric(strValue) then 
			rs("Controle") = CLng(strValue)
		else
			rs("Controle") = null
		end if
		call report_error
	end if
	if IsUpdatable(rs("NrProtoc")) then
'	update NrProtoc field
	strValue=false
	if evalues.exists("NrProtoc") then 	_
		strValue = evalues.Item("NrProtoc")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_NrProtoc")
								if strValue<>"" and IsNumeric(strValue) then 
			rs("NrProtoc") = CLng(strValue)
		else
			rs("NrProtoc") = null
		end if
		call report_error
	end if
	end if
'	update DtEntr field
	strValue=false
	if evalues.exists("DtEntr") then 	_
		strValue = evalues.Item("DtEntr")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_DtEntr")
								if strValue="" then
			rs("DtEntr")=null
		else
			rs("DtEntr")=strValue
		end if
		call report_error
	end if
'	update Descr field
	strValue=false
	if evalues.exists("Descr") then 	_
		strValue = evalues.Item("Descr")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Descr")
								rs("Descr") = strValue					
		call report_error
	end if
'	update Emissor field
	strValue=false
	if evalues.exists("Emissor") then 	_
		strValue = evalues.Item("Emissor")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Emissor")
								rs("Emissor") = strValue					
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
'	update Assunto field
	strValue=false
	if evalues.exists("Assunto") then 	_
		strValue = evalues.Item("Assunto")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Assunto")
								rs("Assunto") = strValue					
		call report_error
	end if
'	update TipoDoc field
	strValue=false
	if evalues.exists("TipoDoc") then 	_
		strValue = evalues.Item("TipoDoc")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_TipoDoc")
								rs("TipoDoc") = strValue					
		call report_error
	end if
'	update Nat field
	strValue=false
	if evalues.exists("Nat") then 	_
		strValue = evalues.Item("Nat")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Nat")
								rs("Nat") = strValue					
		call report_error
	end if
'	update Destino field
	strValue=false
	if evalues.exists("Destino") then 	_
		strValue = evalues.Item("Destino")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Destino")
								rs("Destino") = strValue					
		call report_error
	end if
'	update Obs field
	strValue=false
	if evalues.exists("Obs") then 	_
		strValue = evalues.Item("Obs")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Obs")
								rs("Obs") = strValue					
		call report_error
	end if
'	update Usuario field
	strValue=false
	if evalues.exists("Usuario") then 	_
		strValue = evalues.Item("Usuario")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Usuario")
								rs("Usuario") = strValue					
		call report_error
	end if
'	update PastaArquiv field
	strValue=false
	if evalues.exists("PastaArquiv") then 	_
		strValue = evalues.Item("PastaArquiv")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_PastaArquiv")
								rs("PastaArquiv") = strValue					
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

LogInfo(strSQL)
Set rs = nothing
Set rs = server.CreateObject("ADODB.Recordset")
rs.Open strSQL,dbConnection,1,2
if rs.EOF then
	response.redirect "Cadastro_list.asp?a=return"
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
	if validatetype<>"" then bodyonload=bodyonload & "define('value_DtEntr','" & validatetype & "','Data Entrada');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Descr','" & validatetype & "','Descrição');"
	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Emissor','" & validatetype & "','EMISSOR');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Nome','" & validatetype & "','Nome');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Assunto','" & validatetype & "','Assunto');"
	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_TipoDoc','" & validatetype & "','TipoDoc');"
	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Nat','" & validatetype & "','Natureza');"
	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_Destino','" & validatetype & "','DESTINO');"

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
	includes=includes & "var AUTOCOMPLETE_TABLE='Cadastro_autocomplete.asp';" & vbcrlf
	includes=includes & "var SUGGEST_TABLE='Cadastro_searchsuggest.asp';" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE='Cadastro_lookupsuggest.asp';" & vbcrlf
end if
includes=includes & "</script>" & vbcrlf
if useAJAX then
	includes=includes & "<div id=""search_suggest""></div>" & vbcrlf
end if
'//	include datepicker files
includes=includes & "<script language=""JavaScript"" src=""include/calendar.js""></script>"





smarty.Add "includes",includes
smarty.Add "bodyonload",bodyonload

if len(onsubmit)>0 then onsubmit="onSubmit=""" & onsubmit & """"
smarty.Add "onsubmit",onsubmit

smarty.Add "key1",my_htmlspecialchars(keys("NrProtoc"))
	smarty.Add "show_key1", my_htmlspecialchars(GetData(rs,"NrProtoc", ""))

smarty.Add "message",message


max_filesize_set=0
set readonlyfields = CreateObject("Scripting.Dictionary")


	if readevalues then
		smarty.Add "value_DtEntr",evalues("DtEntr")
	else
		smarty.Add "value_DtEntr",dbvalue(rs("DtEntr"))
	end if
	if readevalues then
		smarty.Add "value_Descr",evalues("Descr")
	else
		smarty.Add "value_Descr",dbvalue(rs("Descr"))
	end if
	if readevalues then
		smarty.Add "value_Emissor",evalues("Emissor")
	else
		smarty.Add "value_Emissor",dbvalue(rs("Emissor"))
	end if
	if readevalues then
		smarty.Add "value_Nome",evalues("Nome")
	else
		smarty.Add "value_Nome",dbvalue(rs("Nome"))
	end if
	if readevalues then
		smarty.Add "value_Assunto",evalues("Assunto")
	else
		smarty.Add "value_Assunto",dbvalue(rs("Assunto"))
	end if
	if readevalues then
		smarty.Add "value_TipoDoc",evalues("TipoDoc")
	else
		smarty.Add "value_TipoDoc",dbvalue(rs("TipoDoc"))
	end if
	if readevalues then
		smarty.Add "value_Nat",evalues("Nat")
	else
		smarty.Add "value_Nat",dbvalue(rs("Nat"))
	end if
	if readevalues then
		smarty.Add "value_Destino",evalues("Destino")
	else
		smarty.Add "value_Destino",dbvalue(rs("Destino"))
	end if
	if readevalues then
		smarty.Add "value_Obs",evalues("Obs")
	else
		smarty.Add "value_Obs",dbvalue(rs("Obs"))
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

smarty_display("Cadastro_edit.htm")

sub report_error
	if Err.number<>0 then
	  message = "<div class=message><<< " & "Registro NÃO foi editado" & " >>><br><br>" & Err.Description & "</div>"
	  readevalues=true
	  errorhappened=true
	  err.clear
	end if
end sub
%>
