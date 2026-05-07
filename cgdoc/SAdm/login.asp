<%@ Language=VBScript %>
<!--#include file="include/dbcommon.asp"-->
<%if request.form("a")="logout" or request.querystring("a")="logout" then
	session.Abandon()
	Response.Cookies("username")=""
	Response.Cookies("password")=""
	Response.Redirect "login.asp"
	response.end
end if%>
<!--#include file="libs/smarty.asp"-->
<%

myurl=SESSION("MyURL")
SESSION("MyURL")=""

defaulturl=""
		defaulturl="menu.asp"



cAdminUserID = "1088608"


strMessage=""

if request.form("btnSubmit") <> "Login" then
	if request.Cookies("username")<>"" or request.Cookies("password")<>"" then smarty.Add "checked"," checked"
end if

if request.form("btnSubmit") = "Login" then

	if request.form("remember_password") = 1 then
		Response.Cookies("username") = postvalue("username")
		Response.Cookies("username").Expires = DateAdd("yyyy", 1, Now())
		Response.Cookies("password") = postvalue("password")
		Response.Cookies("password").Expires = DateAdd("yyyy", 1, Now())
		smarty.Add "checked"," checked"
	else
		Response.Cookies("username") = ""
		Response.Cookies("password") = ""
		smarty.Add "checked",""
	end if
'   	 username and password are stored in the database
	dbConnection = ""
   	db_connect()
   	Set rs = server.CreateObject("ADODB.Recordset")

	
	strUsername = postvalue("username")
	strPassword = postvalue("password")
		
	Set rsTemp = server.CreateObject("ADODB.Recordset")
	rsTemp.Open "select * from [Usuários] where 1=0",dbConnection,1,2

	if FieldNeedQuotes(rsTemp,cUserNameField) then 
		strUsername="'" & db_addslashes(strUsername) & "'"
	else
		strUsername=my_numeric(strUsername)
	end if
	if FieldNeedQuotes(rsTemp,cPasswordField) then 
		strPassword="'" & db_addslashes(strPassword) & "'"
	else
		strPassword=my_numeric(strPassword)
	end if
	rsTemp.close
		
	strSQL = "select * from [Usuários] where " & AddFieldWrappers(cUserNameField) & _
		"=" & strUsername & " and " & AddFieldWrappers(cPasswordField) & 	"=" & strPassword
	RetVal = True
	DoEvent "RetVal = BeforeLogin(postvalue(""username""), postvalue(""password""))"
	if RetVal = False then strSQL="select * from [Usuários] where 1<0"

	rs.Open strSQL,dbConnection, 1, 2
	'Call ReportError
 	if not rs.EOF then
		strPassword = postvalue("password")
		   		if CStr(rs(cUserNameField))=postvalue("username") and CStr(rs(cPasswordField))=strPassword then
			SESSION("UserID") = postvalue("username")
   			SESSION("AccessLevel") = ACCESS_LEVEL_USER
	   			if postvalue("username")=cAdminUserID then SESSION("AccessLevel") = ACCESS_LEVEL_ADMIN
					SESSION("GroupID") = dbvalue(rs("Privilegio"))
	
			DoEvent "Call AfterSuccessfulLogin()"				
			if myurl<>"" then
				response.Redirect myurl
			else
				response.Redirect defaulturl
			end if
			response.End
		else
			DoEvent "Call AfterUnsuccessfulLogin()"
			strMessage = "Login Inválido"
		end if
		rs.MoveNext
	else
		strMessage = "Login Inválido"
	end if
	rs.close
end if

SESSION("MyURL")=myurl
if myurl<>"" then
	smarty.Add "url",myurl
else
	smarty.Add "url",defaulturl
end if
if request.form("username")<>"" or request.querystring("username")<>"" then
	smarty.Add "value_username","value=""" & my_htmlspecialchars(postvalue("username")) & """"
else
	smarty.Add "value_username","value=""" & my_htmlspecialchars(request.Cookies("username")) & """"
end if


if request.form("password")<>"" then
	smarty.Add "value_password","value=""" & my_htmlspecialchars(postvalue("password")) & """"
else
	smarty.Add "value_password","value=""" & my_htmlspecialchars(request.Cookies("password")) & """"
end if

if request.querystring("message")="expired" then strMessage = "Sua sessão expirou. Favor faça novo login"


smarty.Add "message",strMessage

smarty_display("login.htm")
%>