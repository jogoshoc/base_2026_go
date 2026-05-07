<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Moviment2_variables.asp"-->
<%
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Search") then
	SESSION("MyURL")=request.ServerVariables("SCRIPT_NAME")&"?"&request.ServerVariables("QUERY_STRING")
	response.Redirect "login.asp"
	response.End
end if

field = REQUEST.querystring("field")

'//	check permissions
if not CheckFieldPermissions(field,"") then response.End
	

if  then response.End
'//	construct sql

Set keys = CreateObject("Scripting.Dictionary")

keys.Add "CodMov",postvalue("key1")
keys.Add "NrProtoc",postvalue("key2")
where=KeyWhere(keys,"")

sql=gstrSQL
sql = AddWhere(sql,where)

dbConnection=""
db_connect()


Set rsd = server.CreateObject("ADODB.Recordset")

rsd.Open sql,dbConnection,1,2

if rsd.EOF then response.End

strFileName = rsd(field)
strFileType = lcase(Right(strFileName, 4))

rsd.Close

' Feel Free to Add Your Own Content-Types Here
Select Case strFileType
Case ".asf"
ContentType = "video/x-ms-asf"
Case ".avi"
ContentType = "video/avi"
Case ".doc"
ContentType = "application/msword"
Case ".zip"
ContentType = "application/zip"
Case ".xls"
ContentType = "application/vnd.ms-excel"
Case ".gif"
ContentType = "image/gif"
Case ".jpg", "jpeg"
ContentType = "image/jpeg"
Case ".wav"
ContentType = "audio/wav"
Case ".mp3"
ContentType = "audio/mpeg3"
Case ".mpg", "mpeg"
ContentType = "video/mpeg"
Case ".rtf"
ContentType = "application/rtf"
Case ".htm", "html"
ContentType = "text/html"
Case ".asp"
ContentType = "text/asp"
Case ".pdf"
ContentType = "application/pdf"
Case Else
'Handle All Other Files
ContentType = "application/octet-stream"
End Select


Response.ContentType = ContentType
Response.AddHeader "Content-Disposition", "attachment;Filename=""" & strFileName & """"

Dim objStream
set objStream = Server.CreateObject("ADODB.Stream")
objStream.Type = 1
objStream.Open
objStream.LoadFromFile Server.MapPath(GetUploadFolder(field,"") & strFileName)
Response.BinaryWrite objStream.Read
'objStream.CloseSet 
set objStream = Nothing

%>
