<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Impr_recibo_variables.asp"-->

<%
if SESSION("UserID")="" or not CheckSecurity(SESSION("OwnerID"),"Search") then
	response.Redirect "login.asp?message=expired"
	response.End
end if

field = REQUEST.querystring("field")
if not CheckFieldPermissions(field,"") then 
	DisplayNoImage()
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
Set rsPic = server.CreateObject("ADODB.Recordset")


rsPic.Open sql,dbConnection ,1,2

if rsPic.EOF then
	DisplayNoImage()
	response.End
else
	value=rsPic(field).GetChunk(20000000)
	if isnull(value) or lenb(value)=0 then
		DisplayNoImage()
		response.End
	end if
end if

pos = instrb(value,Unicode2Bytes(".Picture"))
if pos>0 and pos<300 then
	pos1=instrb(pos,value,Unicode2Bytes("BM"))
	if pos1>0 and pos1<300 then
		value=midb(value,pos1)
	end if
end if 

itype=SupposeImageType(midb(value,1,100))
if itype<>"" then 
	Response.ContentType = itype
	response.BinaryWrite value
else
	DisplayFileImage
end if
'echobig(value)
response.End


function DisplayNoImage()
	Response.ContentType = "image/gif"
	Set fs = CreateObject("Scripting.FileSystemObject")
	Set a = fs.GetFile(Server.MapPath("images/no_image.gif"))
	Set b = a.OpenAsTextStream(1,-1)
	Response.BinaryWrite(b.Read(999999))
end function
Sub DisplayFileImage
	Response.ContentType = "image/gif"
	Set fs = CreateObject("Scripting.FileSystemObject")
	Set a = fs.GetFile(Server.MapPath("images/file.gif"))
	Set b = a.OpenAsTextStream(1,-1)
	Response.BinaryWrite(b.Read(999999))

End Sub


%>
