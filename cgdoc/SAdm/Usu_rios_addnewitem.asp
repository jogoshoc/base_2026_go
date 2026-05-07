<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Usu_rios_variables.asp"-->

<!--#include file="libs/smarty.asp"-->
<%
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Add") and not CheckSecurity(SESSION("OwnerID"),"Edit") then
	response.Redirect "login.asp"
	response.End
end if

field=postvalue("field")

categoryfield=""
categoryvalue=""
if categoryfield<>"" then _
	categoryvalue=postvalue("category")

table=""
linkfield=""
dispfield=""

if not CheckAddNewItemAllowed(field,table,linkfield,dispfield) then response.End

if len(request.Form("newitem"))>0 then
	object=GoodFieldName(field)
	dbConnection=""
	db_connect()
	Set rsn = server.CreateObject("ADODB.Recordset")

	strValue = postvalue("newitem")

'//	check if need quotes
	rsn.Open "select * from " & AddTableWrappers(table) & " where 1=0",dbConnection, 1, 2
	if NeedQuotes(db_fieldtype(rsn,dispfield)) then
		strValue="'" & db_addslashes(strValue) & "'"
	else
		strValue=my_numeric(strValue)
	end if
	rsn.Close
'	check for uniqueness
	strSQL = "select count(*) from " & AddTableWrappers(table) & " where " & AddFieldWrappers(dispfield) & "=" & strValue
	if categoryfield<>"" then
		if NeedQuotes(db_fieldtype(rsn,categoryfield)) then
			categoryvalue="'" & db_addslashes(categoryvalue) & "'"
		else
			categoryvalue=my_numeric(categoryvalue)
		end if
		strSQL= strSQL & " and " & AddFieldWrappers(categoryfield) & "=" & categoryvalue
	end if
	rsn.Open strSQL,dbConnection
	if CLng(rsn(0))=0 then
		strSQL = "insert into " & AddTableWrappers(table) & " (" & AddFieldWrappers(dispfield) & ") values (" & strValue & ")"
		if categoryfield<>"" then
			strSQL = "insert into " & AddTableWrappers(table) & " (" & AddFieldWrappers(dispfield) & ", "& AddFieldWrappers(categoryfield) &")"& _
			" values (" & strValue & "," & categoryvalue & ")"
		end if
		dbConnection.Execute strSQL
	end if
	rsn.Close
	strSQL = "select " & AddFieldWrappers(linkfield) & "," & AddFieldWrappers(dispfield) & " from " & AddTableWrappers(table) & " where " & AddFieldWrappers(dispfield) & "=" & strValue
	if categoryfield<>"" then
		strSQL= strSQL & " and " & AddFieldWrappers(categoryfield) & "=" & categoryvalue
	end if
	rsn.Open strSQL,dbConnection
	
	if FastType(field,"") and useAJAX then
%>	

<script>	

	window.opener.document.forms.editform.display_value_<%=object%>.value = '<% = replace(my_htmlspecialchars(rsn(1)),"'","\\'")%>';
	window.opener.document.forms.editform.value_<%=object%>.value = '<% = replace(my_htmlspecialchars(rsn(0)),"'","\\'")%>';
	window.opener.document.forms.editform.display_value_<%=object%>.focus();
	window.close();	
	
</script>

<%
	else
%>
	
<script>	

	window.opener.create_option(window.opener.document.forms.editform.value_<%=object%>, '<%=replace(my_htmlspecialchars(rsn(1)),"'","\\'")%>', '<%=replace(my_htmlspecialchars(rsn(0)),"'","\\'")%>');
	window.opener.document.forms.editform.value_<%=object%>.options[window.opener.document.forms.editform.value_<%=object%>.options.length-1].selected = true;		
	window.opener.document.forms.editform.value_<%=object%>.focus();
<% if categoryfield<>"" then %>	
	window.opener.arr_<% = object%>[opener.arr_<% = object%>.length]='<% = replace(my_htmlspecialchars(rsn(0)),"'","\\'")%>';
	window.opener.arr_<% = object%>[opener.arr_<% = object%>.length]='<% = replace(my_htmlspecialchars(rsn(1)),"'","\\'")%>';
	window.opener.arr_<% = object%>[opener.arr_<% = object%>.length]='<% = replace(my_htmlspecialchars(postvalue("category")),"'","\\'")%>';
<% end if %>	
	window.close();	
	
</script>
	
<%
	end if
	response.End
end if
%>
<link REL="stylesheet" href="include/style.css" type="text/css">
<body onload="document.forms[0].newitem.focus();">
<form method=post>
<div align=center><input type=text name=newitem size=30 maxlength=100>
<br><br><input class=button type=submit value="<%="Salvar"%>" id=submit1 name=submit1>
<input class=button type=button onClick='window.close();return false;' value="<%="Fechar Janela"%>">
</div>
</form>

<%
function CheckAddNewItemAllowed(field,table,linkfield,dispfield)
	CheckAddNewItemAllowed = false
end function
%>