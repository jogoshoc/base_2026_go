<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/moviment_sec_variables.asp"-->

<!--#include file="libs/smarty.asp"-->

<%
	Set myRequest = CreateObject("Scripting.Dictionary")
	Set myRequestFiles = CreateObject("Scripting.Dictionary")
	if ParseMultiPartForm()=true then parse=1
	MaxSizeSet=false


'//	check if logged in
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Add") then
SESSION("MyURL")=request.ServerVariables("SCRIPT_NAME")&"?"&request.ServerVariables("QUERY_STRING")
	response.Redirect "login.asp?message=expired"
	response.End
end if

filename=""
message=""
readavalues=false
errorhappened=false

'//connect database
	dbConnection=""
	db_connect()
	Set rs = server.CreateObject("ADODB.Recordset")

'// insert new record if we have to

if getRequestForm("a")="added" then
	set afilename_values  = CreateObject("Scripting.Dictionary")
	set avalues = CreateObject("Scripting.Dictionary")
	set files_move = CreateObject("Scripting.Dictionary")

	dim toadd
	dim thumb
'//	processing DtMovim - start

	value = postvalue("value_DtMovim")
	ttype=postvalue("type_DtMovim")
	toadd=true
if myRequest.Exists("value_DtMovim") or myRequest.Exists("value_DtMovim[]") or myRequest.Exists("type_DtMovim") then
	
			value=prepare_for_db("DtMovim",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("DtMovim")=value
		end if
	
end if
	

'	processibng DtMovim - end
'//	processing DestNome - start

	value = postvalue("value_DestNome")
	ttype=postvalue("type_DestNome")
	toadd=true
if myRequest.Exists("value_DestNome") or myRequest.Exists("value_DestNome[]") or myRequest.Exists("type_DestNome") then
	
			value=prepare_for_db("DestNome",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("DestNome")=value
		end if
	
end if
	

'	processibng DestNome - end
'//	processing Obs - start

	value = postvalue("value_Obs")
	ttype=postvalue("type_Obs")
	toadd=true
if myRequest.Exists("value_Obs") or myRequest.Exists("value_Obs[]") or myRequest.Exists("type_Obs") then
	
			value=prepare_for_db("Obs",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Obs")=value
		end if
	
end if
	

'	processibng Obs - end
'//	processing Prazo - start

	value = postvalue("value_Prazo")
	ttype=postvalue("type_Prazo")
	toadd=true
if myRequest.Exists("value_Prazo") or myRequest.Exists("value_Prazo[]") or myRequest.Exists("type_Prazo") then
	
			value=prepare_for_db("Prazo",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Prazo")=value
		end if
	
end if
	

'	processibng Prazo - end
'//	processing UsuaMov - start

	value = postvalue("value_UsuaMov")
	ttype=postvalue("type_UsuaMov")
	toadd=true
if myRequest.Exists("value_UsuaMov") or myRequest.Exists("value_UsuaMov[]") or myRequest.Exists("type_UsuaMov") then
	
			value=prepare_for_db("UsuaMov",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("UsuaMov")=value
		end if
	
end if
	

'	processibng UsuaMov - end




'//	insert masterkey value if exists and if not specified
	if Session(strTableName & "_mastertable")="Tramitacao" then
			avalues("NrProtoc")=prepare_for_db("NrProtoc",SESSION(strTableName & "_masterkey1"),"","")
	end if

'//	add filenames to values
	for each akey in afilename_values
		avalues(akey)=afilename_values(akey)
	next
	
'//	before Add event
	retval = true
	DoEvent "retval = BeforeAdd(avalues)"

	if retval then

	on error resume next
	rs.Open "select * from " & AddTableWrappers(strOriginalTableName) & " where 1=0", dbConnection, 1,2
	rs.Addnew
	call report_error
	if IsUpdatable(rs("CodMov")) then
'	insert CodMov field
	strValue=false
	if avalues.exists("CodMov") then 	_
		strValue = avalues.Item("CodMov")
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
'	insert NrProtoc field
	strValue=false
	if avalues.exists("NrProtoc") then 	_
		strValue = avalues.Item("NrProtoc")
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
'	insert CodMovGeral field
	strValue=false
	if avalues.exists("CodMovGeral") then 	_
		strValue = avalues.Item("CodMovGeral")
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
'	insert DtMovim field
	strValue=false
	if avalues.exists("DtMovim") then 	_
		strValue = avalues.Item("DtMovim")
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
'	insert OrigNome field
	strValue=false
	if avalues.exists("OrigNome") then 	_
		strValue = avalues.Item("OrigNome")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_OrigNome")
								rs("OrigNome") = strValue					
	call report_error
	end if
'	insert DestNome field
	strValue=false
	if avalues.exists("DestNome") then 	_
		strValue = avalues.Item("DestNome")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_DestNome")
								rs("DestNome") = strValue					
	call report_error
	end if
'	insert Obs field
	strValue=false
	if avalues.exists("Obs") then 	_
		strValue = avalues.Item("Obs")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Obs")
								rs("Obs") = strValue					
	call report_error
	end if
'	insert Solucao field
	strValue=false
	if avalues.exists("Solucao") then 	_
		strValue = avalues.Item("Solucao")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Solucao")
								rs("Solucao") = strValue					
	call report_error
	end if
'	insert Prazo field
	strValue=false
	if avalues.exists("Prazo") then 	_
		strValue = avalues.Item("Prazo")
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
'	insert Cumprido field
	strValue=false
	if avalues.exists("Cumprido") then 	_
		strValue = avalues.Item("Cumprido")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Cumprido")
								rs("Cumprido") = strValue					
	call report_error
	end if
'	insert UsuaMov field
	strValue=false
	if avalues.exists("UsuaMov") then 	_
		strValue = avalues.Item("UsuaMov")
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
	on error goto 0
	if not errorhappened then	
'//	after add event		
		DoEvent "AfterAdd()"

		message="<div class=message><<< " & "Registro foi adicionado" & " >>></div>"
	end if
	else
		readavalues=true
	end if
	
end if


set defvalues = CreateObject("Scripting.Dictionary")
set keys = CreateObject("Scripting.Dictionary")

	keys("CodMov")=postvalue("copyid1")
	keys("NrProtoc")=postvalue("copyid2")

'//	copy record
if getRequestForm("copyid1")<>"" then
	sstrWhere=KeyWhere(keys,"")
	strSQL=gstrSQL
	strSQL=AddWhere(strSQL,sstrWhere)
	LogInfo(strSQL)
	rs.open strSQL,dbConnection, 1, 2
	if not rs.EOF then
		defvalues("DtMovim")=dbvalue(rs("DtMovim"))
		defvalues("DestNome")=dbvalue(rs("DestNome"))
		defvalues("Obs")=dbvalue(rs("Obs"))
		defvalues("Prazo")=dbvalue(rs("Prazo"))
		defvalues("UsuaMov")=dbvalue(rs("UsuaMov"))
	end if
'//	clear key fields
	defvalues("CodMov")=""
	defvalues("NrProtoc")=""
'//call CopyOnLoad event
	DoEvent "Call CopyOnLoad(defvalues,sstrWhere)"
else
	defvalues("DtMovim")=date()
	defvalues("UsuaMov")=Session("UserID")&" - "&Now()
end if

'	save previously enterd values
if readavalues then
	if avalues.exists("DtMovim") then
		defvalues("DtMovim")= avalues("DtMovim")
	end if
	if avalues.exists("DestNome") then
		defvalues("DestNome")= avalues("DestNome")
	end if
	if avalues.exists("Obs") then
		defvalues("Obs")= avalues("Obs")
	end if
	if avalues.exists("Prazo") then
		defvalues("Prazo")= avalues("Prazo")
	end if
	if avalues.exists("UsuaMov") then
		defvalues("UsuaMov")= avalues("UsuaMov")
	end if
end if

for each key in defvalues
	smarty.Add "value_" & GoodFieldName(key),defvalues(key)
next


'//	include files

includes=""

'//	validation stuff
bodyonload=""
onsubmit=""
includes=includes & "<script language=""JavaScript"" src=""include/validate.js""></script> "
includes=includes & "<script language=""JavaScript""> "
includes=includes & "var TEXT_FIELDS_REQUIRED='" & addslashes("Os seguintes campos são requeridos") & "'; "
includes=includes & "var TEXT_FIELDS_ZIPCODES='" & addslashes("") & "'; "
includes=includes & "var TEXT_FIELDS_EMAILS='" & addslashes("Os seguintes campos precisam ser Emails válidos") & "'; "
includes=includes & "var TEXT_FIELDS_NUMBERS='" & addslashes("Os seguintes campos precisam ser números") & "'; "
includes=includes & "var TEXT_FIELDS_CURRENCY='" & addslashes("Os seguintes campos precisam ser no formato Moeda") & "'; "
includes=includes & "var TEXT_FIELDS_PHONE='" & addslashes("Os seguintes campos precisam ser números de telefone") & "'; "
includes=includes & "var TEXT_FIELDS_PASSWORD1='" & addslashes("Os seguintes campos precisam ser senhas válidas") & "'; "
includes=includes & "var TEXT_FIELDS_PASSWORD2='" & addslashes("com um mínimo de 4 caracteres…") & "'; "
includes=includes & "var TEXT_FIELDS_PASSWORD3='" & addslashes("Não pode ser ‘password’") & "'; "
includes=includes & "var TEXT_FIELDS_STATE='" & addslashes("Os seguintes campos precisam ser nomes de Estados") & "'; "
includes=includes & "var TEXT_FIELDS_SSN='" & addslashes("Os seguintes campos precisam ser dados de identificação") & "'; "
includes=includes & "var TEXT_FIELDS_DATE='" & addslashes("Os seguintes campos precisam ser datas") & "'; "
includes=includes & "var TEXT_FIELDS_TIME='" & addslashes("Os seguintes campos devem ter o formato de hora v&#225;lida (24 horas)") & "'; "
includes=includes & "var TEXT_FIELDS_CC='" & addslashes("Os seguintes campos precisam ser de números  válidos de Cartão de Crédito") & "'; "
includes=includes & "var TEXT_FIELDS_SSN='" & addslashes("Os seguintes campos precisam ser dados de identificação") & "'; "
includes=includes & "</script> "
	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_DtMovim','" & validatetype & "','Data Distrib');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_DestNome','" & validatetype & "','Destino (func)');"

if bodyonload<>"" then
	onsubmit="return validate();"
	bodyonload="onload=""" & bodyonload & """"
end if

if useAJAX then
	includes=includes & "<script language=""JavaScript"" src=""include/jquery.js""></script>" & vbcrlf
	includes=includes & "<script language=""JavaScript"" src=""include/ajaxsuggest.js""></script>" & vbcrlf
end if
includes=includes & "<script language=""JavaScript"" src=""include/jsfunctions.js""></script> " & vbcrlf
includes=includes & "<script language=""JavaScript""> " & vbcrlf
includes=includes & "var locale_dateformat = " & locale_info("LOCALE_IDATE") & "; " & vbcrlf
includes=includes & "var locale_datedelimiter = """ & locale_info("LOCALE_SDATE") & """; " & vbcrlf
includes=includes & "var bLoading=false; " & vbcrlf
includes=includes & "var TEXT_PLEASE_SELECT='" & addslashes("Favor Selecionar") & "'; " & vbcrlf
if useAJAX then
	includes=includes & "var AUTOCOMPLETE_TABLE='moviment_sec_autocomplete.asp';" & vbcrlf
	includes=includes & "var SUGGEST_TABLE='moviment_sec_searchsuggest.asp';" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE='moviment_sec_lookupsuggest.asp';" & vbcrlf
end if
includes=includes & "</script> " & vbcrlf
if useAJAX then
	includes=includes & "<div id=""search_suggest""></div>" & vbcrlf
end if

	'//	include datepicker files
includes=includes & "<script language=""JavaScript"" src=""include/calendar.js""></script> "
	






smarty.Add "includes",includes
smarty.Add "bodyonload",bodyonload
if len(onsubmit)>0 then onsubmit="onSubmit=""" & onsubmit & """"
smarty.Add "onsubmit",onsubmit

smarty.Add "message",message


max_filesize_set=0

set readonlyfields = CreateObject("Scripting.Dictionary")

'//	show readonly fields
	readonlyfields.Add "UsuaMov",my_htmlspecialchars(GetData(defvalues,"UsuaMov", ""))

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


smarty_display("moviment_sec_add.htm")

function report_error
	if Err.number<>0 then
	  message = "<div class=message><<< " & "Registro NÃO foi adicionado" & " >>><br><br>" & Err.Description & "</div>"
	  readavalues=true
	  errorhappened=true
	  err.clear
	end if
end function
%>
