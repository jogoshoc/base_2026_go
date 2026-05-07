<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Cadastro_variables.asp"-->

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
'//	processing NrProtoc - start

	value = postvalue("value_NrProtoc")
	ttype=postvalue("type_NrProtoc")
	toadd=true
if myRequest.Exists("value_NrProtoc") or myRequest.Exists("value_NrProtoc[]") or myRequest.Exists("type_NrProtoc") then
	
			value=prepare_for_db("NrProtoc",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("NrProtoc")=value
		end if
	
end if
	

'	processibng NrProtoc - end
'//	processing DtEntr - start

	value = postvalue("value_DtEntr")
	ttype=postvalue("type_DtEntr")
	toadd=true
if myRequest.Exists("value_DtEntr") or myRequest.Exists("value_DtEntr[]") or myRequest.Exists("type_DtEntr") then
	
			value=prepare_for_db("DtEntr",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("DtEntr")=value
		end if
	
end if
	

'	processibng DtEntr - end
'//	processing Nat - start

	value = postvalue("value_Nat")
	ttype=postvalue("type_Nat")
	toadd=true
if myRequest.Exists("value_Nat") or myRequest.Exists("value_Nat[]") or myRequest.Exists("type_Nat") then
	
			value=prepare_for_db("Nat",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Nat")=value
		end if
	
end if
	

'	processibng Nat - end
'//	processing Emissor - start

	value = postvalue("value_Emissor")
	ttype=postvalue("type_Emissor")
	toadd=true
if myRequest.Exists("value_Emissor") or myRequest.Exists("value_Emissor[]") or myRequest.Exists("type_Emissor") then
	
			value=prepare_for_db("Emissor",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Emissor")=value
		end if
	
end if
	

'	processibng Emissor - end
'//	processing Destino - start

	value = postvalue("value_Destino")
	ttype=postvalue("type_Destino")
	toadd=true
if myRequest.Exists("value_Destino") or myRequest.Exists("value_Destino[]") or myRequest.Exists("type_Destino") then
	
			value=prepare_for_db("Destino",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Destino")=value
		end if
	
end if
	

'	processibng Destino - end
'//	processing TipoDoc - start

	value = postvalue("value_TipoDoc")
	ttype=postvalue("type_TipoDoc")
	toadd=true
if myRequest.Exists("value_TipoDoc") or myRequest.Exists("value_TipoDoc[]") or myRequest.Exists("type_TipoDoc") then
	
			value=prepare_for_db("TipoDoc",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("TipoDoc")=value
		end if
	
end if
	

'	processibng TipoDoc - end
'//	processing Descr - start

	value = postvalue("value_Descr")
	ttype=postvalue("type_Descr")
	toadd=true
if myRequest.Exists("value_Descr") or myRequest.Exists("value_Descr[]") or myRequest.Exists("type_Descr") then
	
			value=prepare_for_db("Descr",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Descr")=value
		end if
	
end if
	

'	processibng Descr - end
'//	processing Assunto - start

	value = postvalue("value_Assunto")
	ttype=postvalue("type_Assunto")
	toadd=true
if myRequest.Exists("value_Assunto") or myRequest.Exists("value_Assunto[]") or myRequest.Exists("type_Assunto") then
	
			value=prepare_for_db("Assunto",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Assunto")=value
		end if
	
end if
	

'	processibng Assunto - end

'//	processing Nome - start

	value = postvalue("value_Nome")
	ttype=postvalue("type_Nome")
	toadd=true
if myRequest.Exists("value_Nome") or myRequest.Exists("value_Nome[]") or myRequest.Exists("type_Nome") then
	
			value=prepare_for_db("Nome",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Nome")=value
		end if
	
end if
'	processibng Nome - end

'//	processing MASP - start

	value = postvalue("value_MASP")
	ttype=postvalue("type_MASP")
	toadd=true
if myRequest.Exists("value_MASP") or myRequest.Exists("value_MASP[]") or myRequest.Exists("type_MASP") then
	
			value=prepare_for_db("MASP",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("MASP")=value
		end if
	
end if
'	processibng MASP - end


'//	processing CPF - start

	value = postvalue("value_CPF")
	ttype=postvalue("type_CPF")
	toadd=true
if myRequest.Exists("value_CPF") or myRequest.Exists("value_CPF[]") or myRequest.Exists("type_CPF") then
	
			value=prepare_for_db("CPF",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("CPF")=value
		end if
	
end if

'	processibng CPF - end

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
'//	processing Usuario - start

	value = postvalue("value_Usuario")
	ttype=postvalue("type_Usuario")
	toadd=true
if myRequest.Exists("value_Usuario") or myRequest.Exists("value_Usuario[]") or myRequest.Exists("type_Usuario") then
	
			value=prepare_for_db("Usuario",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Usuario")=value
		end if
	
end if
	

'	processibng Usuario - end





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
'	insert Controle field
	strValue=false
	if avalues.exists("Controle") then 	_
		strValue = avalues.Item("Controle")
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

'	insert DtEntr field
	strValue=false
	if avalues.exists("DtEntr") then 	_
		strValue = avalues.Item("DtEntr")
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

'	insert Descr field
	strValue=false
	if avalues.exists("Descr") then 	_
		strValue = avalues.Item("Descr")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Descr")
								rs("Descr") = strValue					
	call report_error
	end if

'	insert Emissor field
	strValue=false
	if avalues.exists("Emissor") then 	_
		strValue = avalues.Item("Emissor")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Emissor")
								rs("Emissor") = strValue					
	call report_error
	end if

'	insert Nome field
	strValue=false
	if avalues.exists("Nome") then 	_
		strValue = avalues.Item("Nome")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Nome")
								rs("Nome") = strValue					
	call report_error
	end if

'	insert MASP field
	strValue=false
	if avalues.exists("MASP") then 	_
		strValue = avalues.Item("MASP")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_MASP")
								rs("MASP") = strValue					
	call report_error
	end if

'	insert CPF field
	strValue=false
	if avalues.exists("CPF") then 	_
		strValue = avalues.Item("CPF")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_CPF")
								rs("CPF") = strValue					
	call report_error
	end if

'	insert Assunto field
	strValue=false
	if avalues.exists("Assunto") then 	_
		strValue = avalues.Item("Assunto")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Assunto")
								rs("Assunto") = strValue					
	call report_error
	end if

'	insert TipoDoc field
	strValue=false
	if avalues.exists("TipoDoc") then 	_
		strValue = avalues.Item("TipoDoc")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_TipoDoc")
								rs("TipoDoc") = strValue					
	call report_error
	end if

'	insert Nat field
	strValue=false
	if avalues.exists("Nat") then 	_
		strValue = avalues.Item("Nat")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Nat")
								rs("Nat") = strValue					
	call report_error
	end if

'	insert Destino field
	strValue=false
	if avalues.exists("Destino") then 	_
		strValue = avalues.Item("Destino")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Destino")
								rs("Destino") = strValue					
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

'	insert Usuario field
	strValue=false
	if avalues.exists("Usuario") then 	_
		strValue = avalues.Item("Usuario")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Usuario")
								rs("Usuario") = strValue					
	call report_error
	end if

'	insert PastaArquiv field
	strValue=false
	if avalues.exists("PastaArquiv") then 	_
		strValue = avalues.Item("PastaArquiv")
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

	keys("NrProtoc")=postvalue("copyid1")

'//	copy record
if getRequestForm("copyid1")<>"" then
	sstrWhere=KeyWhere(keys,"")
	strSQL=gstrSQL
	strSQL=AddWhere(strSQL,sstrWhere)
	LogInfo(strSQL)
	rs.open strSQL,dbConnection, 1, 2
	if not rs.EOF then
		defvalues("NrProtoc")=dbvalue(rs("NrProtoc"))
		defvalues("DtEntr")=dbvalue(rs("DtEntr"))
		defvalues("Nat")=dbvalue(rs("Nat"))
		defvalues("Emissor")=dbvalue(rs("Emissor"))
		defvalues("Destino")=dbvalue(rs("Destino"))
		defvalues("TipoDoc")=dbvalue(rs("TipoDoc"))
		defvalues("Descr")=dbvalue(rs("Descr"))
		defvalues("Assunto")=dbvalue(rs("Assunto"))
		defvalues("Nome")=dbvalue(rs("Nome"))
		defvalues("CPF")=dbvalue(rs("CPF"))				
		defvalues("MASP")=dbvalue(rs("MASP"))
		defvalues("Obs")=dbvalue(rs("Obs"))
		defvalues("Usuario")=dbvalue(rs("Usuario"))
	end if
'//	clear key fields
	defvalues("NrProtoc")=""
'//call CopyOnLoad event
	DoEvent "Call CopyOnLoad(defvalues,sstrWhere)"
else
	defvalues("NrProtoc")=GetRequestForm("masterkey")
	defvalues("DtEntr")=date()
	defvalues("Emissor")="DRH/SECT"
	defvalues("Destino")="DRH/SECT"
	defvalues("Usuario")=Session("UserID")&" - "&Now()
end if

'	save previously enterd values
if readavalues then
	if avalues.exists("NrProtoc") then
		defvalues("NrProtoc")= avalues("NrProtoc")
	end if
	if avalues.exists("DtEntr") then
		defvalues("DtEntr")= avalues("DtEntr")
	end if
	if avalues.exists("Descr") then
		defvalues("Descr")= avalues("Descr")
	end if
	if avalues.exists("Emissor") then
		defvalues("Emissor")= avalues("Emissor")
	end if
	if avalues.exists("Nome") then
		defvalues("Nome")= avalues("Nome")
	end if
	if avalues.exists("CPF") then
		defvalues("CPF")= avalues("CPF")
	end if		
	if avalues.exists("MASP") then
		defvalues("MASP")= avalues("MASP")
	end if
	if avalues.exists("Assunto") then
		defvalues("Assunto")= avalues("Assunto")
	end if
	if avalues.exists("TipoDoc") then
		defvalues("TipoDoc")= avalues("TipoDoc")
	end if
	if avalues.exists("Nat") then
		defvalues("Nat")= avalues("Nat")
	end if
	if avalues.exists("Destino") then
		defvalues("Destino")= avalues("Destino")
	end if
	if avalues.exists("Obs") then
		defvalues("Obs")= avalues("Obs")
	end if
	if avalues.exists("Usuario") then
		defvalues("Usuario")= avalues("Usuario")
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
	if validatetype<>"" then bodyonload=bodyonload & "define('value_NrProtoc','" & validatetype & "','Nr Protoc');"
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
	if validatetype<>"" then bodyonload=bodyonload & "define('value_CPF','" & validatetype & "','CPF');"
  	validatetype=""
	validatetype=validatetype & "IsRequired"
	if validatetype<>"" then bodyonload=bodyonload & "define('value_MASP','" & validatetype & "','MASP');"
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
	includes=includes & "var AUTOCOMPLETE_TABLE='Cadastro_autocomplete.asp';" & vbcrlf
	includes=includes & "var SUGGEST_TABLE='Cadastro_searchsuggest.asp';" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE='Cadastro_lookupsuggest.asp';" & vbcrlf
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
	readonlyfields.Add "Usuario",my_htmlspecialchars(GetData(defvalues,"Usuario", ""))

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


smarty_display("Cadastro_add.htm")

function report_error
	if Err.number<>0 then
	  message = "<div class=message><<< " & "Registro NÃO foi adicionado" & " >>><br><br>" & Err.Description & "</div>"
	  readavalues=true
	  errorhappened=true
	  err.clear
	end if
end function
%>
