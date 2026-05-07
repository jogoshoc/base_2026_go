<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Usu_rios_variables.asp"-->

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
'//	processing NúmeroDoUsuário - start

	value = postvalue("value_N_meroDoUsu_rio")
	ttype=postvalue("type_N_meroDoUsu_rio")
	toadd=true
if myRequest.Exists("value_N_meroDoUsu_rio") or myRequest.Exists("value_N_meroDoUsu_rio[]") or myRequest.Exists("type_N_meroDoUsu_rio") then
	
			value=prepare_for_db("NúmeroDoUsuário",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("NúmeroDoUsuário")=value
		end if
	
end if
	

'	processibng NúmeroDoUsuário - end
'//	processing PG - start

	value = postvalue("value_PG")
	ttype=postvalue("type_PG")
	toadd=true
if myRequest.Exists("value_PG") or myRequest.Exists("value_PG[]") or myRequest.Exists("type_PG") then
	
			value=prepare_for_db("PG",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("PG")=value
		end if
	
end if
	

'	processibng PG - end
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
'//	processing Ramal - start

	value = postvalue("value_Ramal")
	ttype=postvalue("type_Ramal")
	toadd=true
if myRequest.Exists("value_Ramal") or myRequest.Exists("value_Ramal[]") or myRequest.Exists("type_Ramal") then
	
			value=prepare_for_db("Ramal",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Ramal")=value
		end if
	
end if
	

'	processibng Ramal - end
'//	processing Unidade - start

	value = postvalue("value_Unidade")
	ttype=postvalue("type_Unidade")
	toadd=true
if myRequest.Exists("value_Unidade") or myRequest.Exists("value_Unidade[]") or myRequest.Exists("type_Unidade") then
	
			value=prepare_for_db("Unidade",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Unidade")=value
		end if
	
end if
	

'	processibng Unidade - end
'//	processing Seção - start

	value = postvalue("value_Se__o")
	ttype=postvalue("type_Se__o")
	toadd=true
if myRequest.Exists("value_Se__o") or myRequest.Exists("value_Se__o[]") or myRequest.Exists("type_Se__o") then
	
			value=prepare_for_db("Seção",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Seção")=value
		end if
	
end if
	

'	processibng Seção - end
'//	processing Fotografia - start

	value = postvalue("value_Fotografia")
	ttype=postvalue("type_Fotografia")
	toadd=true
if myRequest.Exists("value_Fotografia") or myRequest.Exists("value_Fotografia[]") or myRequest.Exists("type_Fotografia") then
	
			value=prepare_for_db("Fotografia",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Fotografia")=value
		end if
	
end if
	

'	processibng Fotografia - end
'//	processing Senha - start

	value = postvalue("value_Senha")
	ttype=postvalue("type_Senha")
	toadd=true
if myRequest.Exists("value_Senha") or myRequest.Exists("value_Senha[]") or myRequest.Exists("type_Senha") then
	
			value=prepare_for_db("Senha",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Senha")=value
		end if
	
end if
	

'	processibng Senha - end
'//	processing Privilegio - start

	value = postvalue("value_Privilegio")
	ttype=postvalue("type_Privilegio")
	toadd=true
if myRequest.Exists("value_Privilegio") or myRequest.Exists("value_Privilegio[]") or myRequest.Exists("type_Privilegio") then
	
			value=prepare_for_db("Privilegio",value,ttype,"")
		
		if vartype(value)=11 then 
			if value=false then toadd=false
		end if
		if toadd then
			avalues("Privilegio")=value
		end if
	
end if
	

'	processibng Privilegio - end


'//	insert ownerid value if exists
	avalues("Seção")=prepare_for_db("Seção",SESSION("OwnerID"),"","")



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
	if IsUpdatable(rs("NúmeroDoUsuário")) then
'	insert NúmeroDoUsuário field
	strValue=false
	if avalues.exists("NúmeroDoUsuário") then 	_
		strValue = avalues.Item("NúmeroDoUsuário")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_N_meroDoUsu_rio")
								rs("NúmeroDoUsuário") = strValue					
	call report_error
	end if
	end if
'	insert PG field
	strValue=false
	if avalues.exists("PG") then 	_
		strValue = avalues.Item("PG")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_PG")
								rs("PG") = strValue					
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
'	insert Ramal field
	strValue=false
	if avalues.exists("Ramal") then 	_
		strValue = avalues.Item("Ramal")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Ramal")
								rs("Ramal") = strValue					
	call report_error
	end if
'	insert Unidade field
	strValue=false
	if avalues.exists("Unidade") then 	_
		strValue = avalues.Item("Unidade")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Unidade")
								rs("Unidade") = strValue					
	call report_error
	end if
'	insert Seção field
	strValue=false
	if avalues.exists("Seção") then 	_
		strValue = avalues.Item("Seção")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Se__o")
								rs("Seção") = strValue					
	call report_error
	end if
'	insert Fotografia field
	strValue=false
	if avalues.exists("Fotografia") then 	_
		strValue = avalues.Item("Fotografia")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Fotografia")
					if ctype="file2" then
			binData=GetRequestForm("value_Fotografia")
'			If LenB(binData) Mod 2 > 0 Then
'				binData = binData & ChrB(0)
'			End If
			rs("Fotografia").AppendChunk binData
		End If
	call report_error
	end if
'	insert Senha field
	strValue=false
	if avalues.exists("Senha") then 	_
		strValue = avalues.Item("Senha")
	if not errorhappened and not (vartype(strValue)=11 and strValue=False) then
		if isnull(strValue) then strValue=""
		ctype = GetRequestForm("type_Senha")
								rs("Senha") = strValue					
	call report_error
	end if
'	insert Privilegio field
	strValue=false
	if avalues.exists("Privilegio") then 	_
		strValue = avalues.Item("Privilegio")
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

	keys("NúmeroDoUsuário")=postvalue("copyid1")

'//	copy record
if getRequestForm("copyid1")<>"" then
	sstrWhere=KeyWhere(keys,"")
	strSQL=gstrSQL
	strSQL=AddWhere(strSQL,sstrWhere)
	strSQL=AddWhere(strSQL,SecuritySQL("Search"))
	LogInfo(strSQL)
	rs.open strSQL,dbConnection, 1, 2
	if not rs.EOF then
		defvalues("NúmeroDoUsuário")=dbvalue(rs("NúmeroDoUsuário"))
		defvalues("PG")=dbvalue(rs("PG"))
		defvalues("Nome")=dbvalue(rs("Nome"))
		defvalues("Ramal")=dbvalue(rs("Ramal"))
		defvalues("Unidade")=dbvalue(rs("Unidade"))
		defvalues("Seção")=dbvalue(rs("Seção"))
		defvalues("Senha")=dbvalue(rs("Senha"))
		defvalues("Privilegio")=dbvalue(rs("Privilegio"))
	end if
'//	clear key fields
	defvalues("NúmeroDoUsuário")=""
'//call CopyOnLoad event
	DoEvent "Call CopyOnLoad(defvalues,sstrWhere)"
else
end if

'	save previously enterd values
if readavalues then
	if avalues.exists("NúmeroDoUsuário") then
		defvalues("NúmeroDoUsuário")= avalues("NúmeroDoUsuário")
	end if
	if avalues.exists("PG") then
		defvalues("PG")= avalues("PG")
	end if
	if avalues.exists("Nome") then
		defvalues("Nome")= avalues("Nome")
	end if
	if avalues.exists("Ramal") then
		defvalues("Ramal")= avalues("Ramal")
	end if
	if avalues.exists("Unidade") then
		defvalues("Unidade")= avalues("Unidade")
	end if
	if avalues.exists("Seção") then
		defvalues("Seção")= avalues("Seção")
	end if
	if avalues.exists("Senha") then
		defvalues("Senha")= avalues("Senha")
	end if
	if avalues.exists("Privilegio") then
		defvalues("Privilegio")= avalues("Privilegio")
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
	includes=includes & "var AUTOCOMPLETE_TABLE='Usu_rios_autocomplete.asp';" & vbcrlf
	includes=includes & "var SUGGEST_TABLE='Usu_rios_searchsuggest.asp';" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE='Usu_rios_lookupsuggest.asp';" & vbcrlf
end if
includes=includes & "</script> " & vbcrlf
if useAJAX then
	includes=includes & "<div id=""search_suggest""></div>" & vbcrlf
end if








smarty.Add "includes",includes
smarty.Add "bodyonload",bodyonload
if len(onsubmit)>0 then onsubmit="onSubmit=""" & onsubmit & """"
smarty.Add "onsubmit",onsubmit

smarty.Add "message",message


max_filesize_set=0

set readonlyfields = CreateObject("Scripting.Dictionary")

'//	show readonly fields

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


smarty_display("Usu_rios_add.htm")

function report_error
	if Err.number<>0 then
	  message = "<div class=message><<< " & "Registro NÃO foi adicionado" & " >>><br><br>" & Err.Description & "</div>"
	  readavalues=true
	  errorhappened=true
	  err.clear
	end if
end function
%>
