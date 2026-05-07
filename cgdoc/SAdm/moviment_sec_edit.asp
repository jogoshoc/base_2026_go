<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/moviment_sec_variables.asp"-->

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
keys("CodMov")=postvalue("editid1")
keys("NrProtoc")=postvalue("editid2")

'//	prepare data for saving
if getRequestForm("a")="edited" then
	sstrWhere=KeyWhere(keys,"")
	strSQL = "select * from " & AddTableWrappers(strOriginalTableName) & " where " & sstrWhere
	set evalues = CreateObject("Scripting.Dictionary")
	set efilename_values = CreateObject("Scripting.Dictionary")
	set files_delete = CreateObject("Scripting.Dictionary")
	set files_move = CreateObject("Scripting.Dictionary")
	
'//	processing DtMovim - start
	value = postvalue("value_DtMovim")
	ttype=postvalue("type_DtMovim")
	toedit=true

if myRequest.Exists("value_DtMovim") or myRequest.Exists("value_DtMovim[]") or myRequest.Exists("type_DtMovim") then
			value=prepare_for_db("DtMovim",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("DtMovim") = value
			end if
	end if


'//	processibng DtMovim - end

'//	processing DestNome - start
	value = postvalue("value_DestNome")
	ttype=postvalue("type_DestNome")
	toedit=true

if myRequest.Exists("value_DestNome") or myRequest.Exists("value_DestNome[]") or myRequest.Exists("type_DestNome") then
			value=prepare_for_db("DestNome",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("DestNome") = value
			end if
	end if


'//	processibng DestNome - end

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

'//	processing Solucao - start
	value = postvalue("value_Solucao")
	ttype=postvalue("type_Solucao")
	toedit=true

if myRequest.Exists("value_Solucao") or myRequest.Exists("value_Solucao[]") or myRequest.Exists("type_Solucao") then
			value=prepare_for_db("Solucao",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Solucao") = value
			end if
	end if


'//	processibng Solucao - end

'//	processing Prazo - start
	value = postvalue("value_Prazo")
	ttype=postvalue("type_Prazo")
	toedit=true

if myRequest.Exists("value_Prazo") or myRequest.Exists("value_Prazo[]") or myRequest.Exists("type_Prazo") then
			value=prepare_for_db("Prazo",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Prazo") = value
			end if
	end if


'//	processibng Prazo - end

'//	processing Cumprido - start
	value = postvalue("value_Cumprido")
	ttype=postvalue("type_Cumprido")
	toedit=true

if myRequest.Exists("value_Cumprido") or myRequest.Exists("value_Cumprido[]") or myRequest.Exists("type_Cumprido") then
			value=prepare_for_db("Cumprido",value,ttype,"")
		if vartype(value)=11 then 
			if value=false then _
				toedit=false
		end if
		if toedit then
			evalues("Cumprido") = value
			end if
	end if


'//	processibng Cumprido - end


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
	if IsUpdatable(rs("CodMov")) then
'	update CodMov field
	strValue=false
	if evalues.exists("CodMov") then 	_
		strValue = evalues.Item("CodMov")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_CodMov")
								if strValue<>"" and IsNumeric(strValue) then 
			rs("CodMov") = CLng(strValue)
		else
			rs("CodMov") = null
		end if
		call report_error
	end if
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
'	update CodMovGeral field
	strValue=false
	if evalues.exists("CodMovGeral") then 	_
		strValue = evalues.Item("CodMovGeral")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_CodMovGeral")
								if strValue<>"" and IsNumeric(strValue) then 
			rs("CodMovGeral") = CLng(strValue)
		else
			rs("CodMovGeral") = null
		end if
		call report_error
	end if
'	update DtMovim field
	strValue=false
	if evalues.exists("DtMovim") then 	_
		strValue = evalues.Item("DtMovim")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_DtMovim")
								if strValue="" then
			rs("DtMovim")=null
		else
			rs("DtMovim")=strValue
		end if
		call report_error
	end if
'	update OrigNome field
	strValue=false
	if evalues.exists("OrigNome") then 	_
		strValue = evalues.Item("OrigNome")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_OrigNome")
								rs("OrigNome") = strValue					
		call report_error
	end if
'	update DestNome field
	strValue=false
	if evalues.exists("DestNome") then 	_
		strValue = evalues.Item("DestNome")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_DestNome")
								rs("DestNome") = strValue					
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
'	update Solucao field
	strValue=false
	if evalues.exists("Solucao") then 	_
		strValue = evalues.Item("Solucao")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Solucao")
								rs("Solucao") = strValue					
		call report_error
	end if
'	update Prazo field
	strValue=false
	if evalues.exists("Prazo") then 	_
		strValue = evalues.Item("Prazo")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Prazo")
								if strValue="" then
			rs("Prazo")=null
		else
			rs("Prazo")=strValue
		end if
		call report_error
	end if
'	update Cumprido field
	strValue=false
	if evalues.exists("Cumprido") then 	_
		strValue = evalues.Item("Cumprido")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Cumprido")
								rs("Cumprido") = strValue					
		call report_error
	end if
'	update UsuaMov field
	strValue=false
	if evalues.exists("UsuaMov") then 	_
		strValue = evalues.Item("UsuaMov")
		
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_UsuaMov")
								rs("UsuaMov") = strValue					
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
	response.redirect "moviment_sec_list.asp?a=return"
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
	if validatetype<>"" then bodyonload=bodyonload & "define('value_DtMovim','" & validatetype & "','Data Distrib');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_DestNome','" & validatetype & "','Destino (func)');"

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
	includes=includes & "var AUTOCOMPLETE_TABLE='moviment_sec_autocomplete.asp';" & vbcrlf
	includes=includes & "var SUGGEST_TABLE='moviment_sec_searchsuggest.asp';" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE='moviment_sec_lookupsuggest.asp';" & vbcrlf
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

smarty.Add "key1",my_htmlspecialchars(keys("CodMov"))
	smarty.Add "show_key1", my_htmlspecialchars(GetData(rs,"CodMov", ""))
smarty.Add "key2",my_htmlspecialchars(keys("NrProtoc"))
	smarty.Add "show_key2", my_htmlspecialchars(GetData(rs,"NrProtoc", ""))

smarty.Add "message",message


max_filesize_set=0
set readonlyfields = CreateObject("Scripting.Dictionary")


	if readevalues then
		smarty.Add "value_DtMovim",evalues("DtMovim")
	else
		smarty.Add "value_DtMovim",dbvalue(rs("DtMovim"))
	end if
	if readevalues then
		smarty.Add "value_DestNome",evalues("DestNome")
	else
		smarty.Add "value_DestNome",dbvalue(rs("DestNome"))
	end if
	if readevalues then
		smarty.Add "value_Obs",evalues("Obs")
	else
		smarty.Add "value_Obs",dbvalue(rs("Obs"))
	end if
	if readevalues then
		smarty.Add "value_Solucao",evalues("Solucao")
	else
		smarty.Add "value_Solucao",dbvalue(rs("Solucao"))
	end if
	if readevalues then
		smarty.Add "value_Prazo",evalues("Prazo")
	else
		smarty.Add "value_Prazo",dbvalue(rs("Prazo"))
	end if
	if readevalues then
		smarty.Add "value_Cumprido",evalues("Cumprido")
	else
		smarty.Add "value_Cumprido",dbvalue(rs("Cumprido"))
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

smarty_display("moviment_sec_edit.htm")

sub report_error
	if Err.number<>0 then
	  message = "<div class=message><<< " & "Registro NÃO foi editado" & " >>><br><br>" & Err.Description & "</div>"
	  readevalues=true
	  errorhappened=true
	  err.clear
	end if
end sub
%>
