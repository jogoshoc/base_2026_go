<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/moviment_sec_variables.asp"-->

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
	includes=includes & "var SUGGEST_TABLE = ""moviment_sec_searchsuggest.asp""" & vbcrlf
	includes=includes & "var SUGGEST_LOOKUP_TABLE=""moviment_sec_lookupsuggest.asp""" & vbcrlf
	includes=includes & "var AUTOCOMPLETE_TABLE=""moviment_sec_autocomplete.asp""" & vbcrlf
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
includes=includes & "	document.getElementById('second_Solucao').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_Solucao'].value=='Between' ? '' : 'none';" & vbcrlf
includes=includes & "	document.getElementById('second_Cumprido').style.display =  "
includes=includes & "	document.forms.editform.elements['asearchopt_Cumprido'].value=='Between' ? '' : 'none';" & vbcrlf
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
	includes=includes &	"document.forms.editform.value_Solucao.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value_Solucao,'advanced')};" & vbcrlf
	includes=includes & "document.forms.editform.value1_Solucao.onkeyup=function(event) {searchSuggest(event,document.forms.editform.value1_Solucao,'advanced1')};" & vbcrlf
	includes=includes &	"document.forms.editform.value_Solucao.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value_Solucao,'advanced')};" & vbcrlf
	includes=includes &	"document.forms.editform.value1_Solucao.onkeydown=function(event) {return listenEvent(event,document.forms.editform.value1_Solucao,'advanced1')};" & vbcrlf
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
'// Solucao 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("Solucao")
	nnot=strTableName_asearchnot.Item("Solucao")
	smarty.Add "value_Solucao",strTableName_asearchfor.Item("Solucao")
	smarty.Add "value1_Solucao",strTableName_asearchfor2.Item("Solucao")
end if
	
if nnot<>"" then smarty.Add "not_Solucao"," checked"
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
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_Solucao"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_Solucao",searchtype
'//	edit format
editformats.Add "Solucao","Text field"
'// Cumprido 


nnot=""
opt=""
if SESSION(strTableName & "_search")=2 then
	opt=strTableName_asearchopt.Item("Cumprido")
	nnot=strTableName_asearchnot.Item("Cumprido")
	smarty.Add "value_Cumprido",strTableName_asearchfor.Item("Cumprido")
	smarty.Add "value1_Cumprido",strTableName_asearchfor2.Item("Cumprido")
end if
	
if nnot<>"" then smarty.Add "not_Cumprido"," checked"
'//	write search options
options=""
s=""
if opt="Equals" then s="selected"
options=options & "<OPTION VALUE=""Equals"" " & s & ">" & "Igual a" & "</option>"
searchtype = "<SELECT ID=""SearchOption"" NAME=""asearchopt_Cumprido"" SIZE=1 onChange=""return ShowHideControls();"">"
searchtype = searchtype & options
searchtype = searchtype & "</SELECT>"
smarty.Add "searchtype_Cumprido",searchtype
'//	edit format
editformats.Add "Cumprido","Lookup wizard"

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
smarty_display("moviment_sec_search.htm")

%>