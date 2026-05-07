<!--#include file="include/dbcommon.asp"-->
<!--#include file="libs/smarty.asp"-->
<%
changed=false

strMessage=""

if request.Form("btnSubmit") = "Submit" then
	dbConnection=""
	db_connect()
	Set rstemp = server.CreateObject("ADODB.Recordset")
	
	rstemp.Open "select * from [Usuários] where 1=0",dbConnection,1,2

	opass = postvalue("opass")
	newpass = postvalue("newpass")
	
	value = SESSION("UserID")
	if FieldNeedQuotes(rstemp,cUserNameField) then
		value="'" & db_addslashes(value) & "'"
	else
		value=my_numeric(value)
	end if
	passvalue = newpass
	if FieldNeedQuotes(rstemp,cPasswordField) then
		passvalue="'" & db_addslashes(passvalue) & "'"
	else
		passvalue=my_numeric(passvalue)
	end if
	rstemp.Close
	if newpass<>opass or 1=1 then
	   	sWhere = " where " & AddFieldWrappers(cUserNameField) & "=" & value
		strSQL = "select * from " & AddTableWrappers(cLoginTable) & sWhere
		rstemp.Open strSQL,dbConnection,1,2
		if not rstemp.EOF then
			if opass = rstemp(cPasswordField) then
				retval=true
				DoEvent "retval=BeforeChangePassword(request.form(""opass""),request.form(""newpass""))"
				if retval then
					strSQL= "update " & AddTableWrappers(cLoginTable) & " set " & AddFieldWrappers(cPasswordField) & "=" & passvalue & sWhere
					dbConnection.Execute strSQL
					changed = true
					doEvent "AfterChangePassword()"
					smarty.Add "backurl",SESSION("BackURL")
					smarty_display("changepwd_success.htm")
					response.End
				end if
			else
				strMessage = "Senha inválida"
			end if
		end if
	end if
else
	SESSION("BackURL") = request.ServerVariables("HTTP_REFERER")
end if

smarty.Add "backurl",SESSION("BackURL")
smarty.Add "message",strMessage
smarty_display("changepwd.htm")
%>