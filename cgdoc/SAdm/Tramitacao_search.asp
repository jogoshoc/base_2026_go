<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Tramitacao_variables.asp"-->

<!--#include file="libs/smarty.asp"-->
<%
'//	check if logged in
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Search") then
	SESSION("MyURL")=request.ServerVariables("SCRIPT_NAME")&"?"&request.ServerVariables("QUERY_STRING")
	response.Redirect "login.asp?message=expired"
	response.End
end if

'//connect database

dbConnection=""
db_connect()
  	Set rs = server.CreateObject("ADODB.Recordset")


includes="<STYLE>" & vbcrlf
includes=includes & "	vis1{ visibility:""visible"" }" & vbcrlf
includes=includes & "	vis2{ visibility:""hidden"" }" & vbcrlf
includes=includes & "</STYLE>" & vbcrlf
if useAJAX then
	includes=includes & "<script language=""JavaScript"" type=""text/javascript"" src=""include/jquery.js""></script>" & vbcrlf
	includes=includes & "<script language=""JavaScript"" type=""text/javascript"" src=""include/ajaxsuggest.js""></script>" & vbcrlf
end if
includes=includes & "<script language=""JavaScript"" src=""include/calendar.js""></script>" & vbcrlf
includes=includes & "<script language=""JavaScript"" src=""include/jsfunctions.js""></script>" & vbcrlf
includes=includes & "<script language=""JavaScript"">" & vbcrlf
includes=includes & "var locale_dateformat = " & locale_info.Item("LOCALE_IDATE") & vbcrlf
includes=includes & "var locale_datedelimiter = """ & locale_info.Item("LOCALE_SDATE") & """" & vbcrlf
includes=includes & "var bLoading=false" & vbcrlf
includes=includes & "var TEXT_PLEASE_SELECT='" & addslashes("Favor Selecionar") & "'" & vbcrlf
if useAJAX then
	includes=includes & "var SUGGEST_TABLE = ""Tramitacao_searchsuggest.asp""" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE=""Tramitacao_lookupsuggest.asp""" & vbcrlf
	includes=includes & "var AUTOCOMPLETE_TABLE=""Tramitacao_autocomplete.asp""" & vbcrlf
end if
includes=includes & "var detect = navigator.userAgent.toLowerCase();" & vbcrlf

includes=includes & "function checkIt(sstring)" & vbcrlf
includes=includes & "{" & vbcrlf
includes=includes & "	place = detect.indexOf(sstring) + 1;" & vbcrlf
includes=includes & "	thestring = sstring;" & vbcrlf
includes=includes & "	return place;" & vbcrlf
includes=includes & "}" & vbcrlf


includes=includes & "function ShowHideControls()" & vbcrlf
includes=includes & "{" & vbcrlf
includes=includes & "	document.getElementById('second_NrProtoc').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_NrProtoc'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_DtMovim').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_DtMovim'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_OrigNome').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_OrigNome'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_DestNome').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_DestNome'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_Emissor').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_Emissor'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_Assunto').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_Assunto'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_Descr').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_Descr'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_Nome').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_Nome'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_DtEntr').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_DtEntr'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	return false;" & vbcrlf
includes=includes & "}" & vbcrlf
includes=includes & "function ResetControls()" & vbcrlf
includes=includes & "{" & vbcrlf
includes=includes & "	var i;" & vbcrlf
includes=includes & "	e = document.forms[0].elements; " & vbcrlf
includes=includes & "	for (i=0;i<e.length;i++) " & vbcrlf
includes=includes & "	{" & vbcrlf
includes=includes & "		if (e[i].name!='type' && e[i].className!='button' && e[i].type!='hidden')" & vbcrlf
includes=includes & "		{" & vbcrlf
includes=includes & "			if(e[i].type=='select-one')" & vbcrlf
includes=includes & "				e[i].selectedIndex=0;" & vbcrlf
includes=includes & "			else if(e[i].type=='select-multiple')" & vbcrlf
includes=includes & "			{" & vbcrlf
includes=includes & "				var j;" & vbcrlf
includes=includes & "				for(j=0;j<e[i].options.length;j++)" & vbcrlf
includes=includes & "					e[i].options[j].selected=false;" & vbcrlf
includes=includes & "			}" & vbcrlf
includes=includes & "			else if(e[i].type=='checkbox' || e[i].type=='radio')" & vbcrlf
includes=includes & "				e[i].checked=false;" & vbcrlf
includes=includes & "			else " & vbcrlf
includes=includes & "				e[i].value = ''; " & vbcrlf
includes=includes & "		}" & vbcrlf
includes=includes & "		else if(e[i].name.substr(0,6)=='value_' && e[i].type=='hidden')"& vbcrlf
includes=includes & "			e[i].value = ''; "& vbcrlf
includes=includes & "	}" & vbcrlf
includes=includes & "	ShowHideControls();	" & vbcrlf
includes=includes & "	return false;" & vbcrlf
includes=includes & "}" & vbcrlf

if useAJAX then
	includes=includes & "$(document).ready(function()" & vbcrlf
	includes=includes & "{" & vbcrlf
	includes=includes &	"document.forms.editform.value_NrProtoc.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_NrProtoc,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_NrProtoc.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_NrProtoc,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_NrProtoc.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_NrProtoc,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_NrProtoc.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_NrProtoc,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_OrigNome.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_OrigNome,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_OrigNome.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_OrigNome,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_OrigNome.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_OrigNome,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_OrigNome.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_OrigNome,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_DestNome.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_DestNome,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_DestNome.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_DestNome,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_DestNome.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_DestNome,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_DestNome.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_DestNome,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Emissor.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_Emissor,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_Emissor.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_Emissor,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Emissor.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_Emissor,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_Emissor.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_Emissor,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Assunto.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_Assunto,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_Assunto.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_Assunto,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Assunto.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_Assunto,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_Assunto.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_Assunto,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Descr.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_Descr,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_Descr.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_Descr,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Descr.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_Descr,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_Descr.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_Descr,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Nome.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_Nome,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_Nome.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_Nome,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Nome.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_Nome,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_Nome.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_Nome,'advanced1')};" & vbcrlf
	includes=includes & "});" & vbcrlf
	includes=includes & "</script>" & vbcrlf
	includes=includes & "<div id=""search_suggest""></div>" & vbcrlf
else 
	includes=includes & "function OnKeyDown(e)" & vbcrlf
	includes=includes & "{ if(!e) e = window.event; " & vbcrlf
	includes=includes & "if (e.keyCode == 13){	e.cancel = true; document.forms[0].submit();} }" & vbcrlf
	includes=includes & "</script>" & vbcrlf
end if 

smarty.Add "includes",includes
smarty.Add "noAJAX",(not useAJAX)


onload="onLoad=""javascript: ShowHideControls();"""
smarty.Add "onload",onload

if SESSION(strTableName & "_asearchtype")="or" then
	smarty.Add "any_checked"," checked"
	smarty.Add "all_checked",""
else
	smarty.Add "any_checked",""
	smarty.Add "all_checked"," checked"
end if

set editformats = CreateObject("Scripting.Dictionary")

if isobject(Session(strTableName & "_asearchnot")) then
	set strTableName_asearchnot = session(strTableName & "_asearchnot")
	set strTableName_asearchopt = session(strTableName & "_asearchopt")
	set strTableName_asearchfor = session(strTableName & "_asearchfor")
	set strTableName_asearchfor2 = session(strTableName & "_asearchfor2")
else
	set strTableName_asearchnot = CreateObject("Scripting.Dictionary")
	set strTableName_asearchopt = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfor = CreateObject("Scripting.Dictionary")
	set strTableName_asearchfor2 = CreateObject("Scripting.Dictionary")
end if
'// NrProtoc 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("NrProtoc")
	nnot=strTableName_asearchnot.Item("NrProtoc")
	smarty.Add "value_NrProtoc",strTableName_asearchfor.Item("NrProtoc")
	smarty.Add "value1_NrProtoc",strTableName_asearchfor2.Item("NrProtoc")
end if
	
if nnot<>"" then smarty.Add "not_NrProtoc"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_NrProtoc"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_NrProtoc",searchtype
'//	edit format
editformats.Add "NrProtoc","Text field"
'// DtMovim 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("DtMovim")
	nnot=strTableName_asearchnot.Item("DtMovim")
	smarty.Add "value_DtMovim",strTableName_asearchfor.Item("DtMovim")
	smarty.Add "value1_DtMovim",strTableName_asearchfor2.Item("DtMovim")
end if
	
if nnot<>"" then smarty.Add "not_DtMovim"," checked"
'//	write search options
options=""
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"
s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_DtMovim"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_DtMovim",searchtype
'//	edit format
editformats.Add "DtMovim","Date"
'// OrigNome 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("OrigNome")
	nnot=strTableName_asearchnot.Item("OrigNome")
	smarty.Add "value_OrigNome",strTableName_asearchfor.Item("OrigNome")
	smarty.Add "value1_OrigNome",strTableName_asearchfor2.Item("OrigNome")
end if
	
if nnot<>"" then smarty.Add "not_OrigNome"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_OrigNome"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_OrigNome",searchtype
'//	edit format
editformats.Add "OrigNome","Text field"
'// DestNome 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("DestNome")
	nnot=strTableName_asearchnot.Item("DestNome")
	smarty.Add "value_DestNome",strTableName_asearchfor.Item("DestNome")
	smarty.Add "value1_DestNome",strTableName_asearchfor2.Item("DestNome")
end if
	
if nnot<>"" then smarty.Add "not_DestNome"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_DestNome"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_DestNome",searchtype
'//	edit format
editformats.Add "DestNome","Text field"
'// Emissor 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("Emissor")
	nnot=strTableName_asearchnot.Item("Emissor")
	smarty.Add "value_Emissor",strTableName_asearchfor.Item("Emissor")
	smarty.Add "value1_Emissor",strTableName_asearchfor2.Item("Emissor")
end if
	
if nnot<>"" then smarty.Add "not_Emissor"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_Emissor"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_Emissor",searchtype
'//	edit format
editformats.Add "Emissor","Text field"
'// Assunto 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("Assunto")
	nnot=strTableName_asearchnot.Item("Assunto")
	smarty.Add "value_Assunto",strTableName_asearchfor.Item("Assunto")
	smarty.Add "value1_Assunto",strTableName_asearchfor2.Item("Assunto")
end if
	
if nnot<>"" then smarty.Add "not_Assunto"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_Assunto"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_Assunto",searchtype
'//	edit format
editformats.Add "Assunto","Text field"
'// Descr 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("Descr")
	nnot=strTableName_asearchnot.Item("Descr")
	smarty.Add "value_Descr",strTableName_asearchfor.Item("Descr")
	smarty.Add "value1_Descr",strTableName_asearchfor2.Item("Descr")
end if
	
if nnot<>"" then smarty.Add "not_Descr"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_Descr"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_Descr",searchtype
'//	edit format
editformats.Add "Descr","Text field"
'// Nome 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("Nome")
	nnot=strTableName_asearchnot.Item("Nome")
	smarty.Add "value_Nome",strTableName_asearchfor.Item("Nome")
	smarty.Add "value1_Nome",strTableName_asearchfor2.Item("Nome")
end if
	
if nnot<>"" then smarty.Add "not_Nome"," checked"
'//	write search options
options=""
s=""
if opt="Contains" then s="selected"
options=options & "<OPTION VALUE=""Contains"" " & s  & ">" & "Contém" & "</option>"
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="Starts with ..." then s="selected"
options=options & "<OPTION VALUE=""Starts with ..."" " & s & ">" & "Inicia com" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"

s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_Nome"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_Nome",searchtype
'//	edit format
editformats.Add "Nome","Text field"
'// DtEntr 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("DtEntr")
	nnot=strTableName_asearchnot.Item("DtEntr")
	smarty.Add "value_DtEntr",strTableName_asearchfor.Item("DtEntr")
	smarty.Add "value1_DtEntr",strTableName_asearchfor2.Item("DtEntr")
end if
	
if nnot<>"" then smarty.Add "not_DtEntr"," checked"
'//	write search options
options=""
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
s=""
if opt="More than ..." then s= "selected"
options=options & "<OPTION VALUE=""More than ..."" " & s & ">" & "Maior que" & "</option>"
s=""
if opt="Less than ..." then s="selected"
options=options & "<OPTION VALUE=""Less than ..."" " & s & ">" & "Menor  que" & "</option>"
s=""
if opt="Equal or more than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or more than ..."" " & s  & ">" & "Igual ou maior que" & "</option>"
s=""
if opt="Equal or less than ..." then s="selected"
options=options & "<OPTION VALUE=""Equal or less than ..."" " & s & ">" & "Igual ou menor que" & "</option>"
s=""
if opt="Between" then s="selected"
options=options & "<OPTION VALUE=""Between"" " & s & ">" & "Entre" & "</option>"
s=""
if opt="Empty" then s="selected"
options=options & "<OPTION VALUE=""Empty"" " & s & ">" & "Vazio" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_DtEntr"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_DtEntr",searchtype
'//	edit format
editformats.Add "DtEntr","Date"

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
smarty_display("Tramitacao_search.htm")

%>