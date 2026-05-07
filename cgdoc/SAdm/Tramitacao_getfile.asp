<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Tramitacao_variables.asp"-->
<%
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Search")then
	response.Redirect "login.asp"
	response.End
end if

Response.Expires = 0
Response.Buffer = True
Response.Clear

strFilename=REQUEST.querystring("filename")
ext=mid(strFilename,len(strFilename)-4)

select case ext
	case ".asf"	ctype = "video/x-ms-asf"
	case ".avi" ctype = "video/avi"
	case ".doc" ctype = "application/msword"
	case ".zip" ctype = "application/zip"
	case ".xls" ctype = "application/vnd.ms-excel"
	case ".gif" ctype = "image/gif"
	case ".jpg" ctype = "image/jpeg"
	case "jpeg" ctype = "image/jpeg"
	case ".wav" ctype = "audio/wav"
	case ".mp3" ctype = "audio/mpeg3"
	case ".mpg" ctype = "video/mpeg"
	case "mpeg" ctype = "video/mpeg"
	case ".rtf" ctype = "application/rtf"
	case ".htm" ctype = "text/html"
	case "html" ctype = "text/html"
	case ".asp" ctype = "text/asp"
	case else ctype = "application/octet-stream"
end select

field = REQUEST.querystring("field")
if not CheckFieldPermissions(field,"") then response.End

'//	construct sql

set keys = CreateObject("Scripting.Dictionary")
keys.Add ("NrProtoc"),postvalue("key1")
where=KeyWhere(keys,"")

sql=gstrSQL
sql = AddWhere(sql,where)

dbConnection=""
db_connect()
Set rs = server.CreateObject("ADODB.Recordset")


rs.Open sql,dbConnection, 1,2

if rs.EOF then
	rs.Close
	response.Redirect "login.asp"
	response.End
end if

binTemp = rs(field).GetChunk(2000000)

if IsNull(binTemp) then
	response.end
end if

Response.ContentType = ContentType
Response.AddHeader "Content-Disposition", "attachment;Filename=""" & strFileName & """"
Response.AddHeader "Content-Length", lenb(db_stripslashesbinary(binTemp))

Response.BinaryWrite binTemp

rs.Close
response.End

%>
