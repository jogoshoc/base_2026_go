<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Impr_recibo_variables.asp"-->

<!--#include file="libs/smarty.asp"-->
<%
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Search") then
	DisplayCloseWindow()
	response.End
end if

field = REQUEST.querystring("field")
if not CheckFieldPermissions(field,"") then
	DisplayCloseWindow()
	response.End
end if

'//	construct sql


set keys = CreateObject("Scripting.Dictionary")
keys.Add "NrProtoc",postvalue("key1")
keys.Add "DtMovim",postvalue("key2")
where=KeyWhere(keys,"")

sql=gstrSQL
sql = AddWhere(sql,where)

	dbConnection=""
	db_connect()
	Set rsf = server.CreateObject("ADODB.Recordset")

rsf.Open sql,dbConnection, 1, 2
if rsf.EOF then
	DisplayCloseWindow()
	response.End
end if

if not isnull(rsf(field)) then
  response.Write replace(my_htmlspecialchars(cstr(rsf(field))),vbcrlf,"<br>")
end if

'echobig(rsf(field),8192)
rsf.Close
DisplayCloseWindow()
response.End


function DisplayCloseWindow()
	response.Write "<br>"
	response.Write "<hr size=1 noshade>"
	response.Write "<a href=# onClick=""window.close();return false;"">" & "Fechar Janela" & "</a>"
end function



%>
