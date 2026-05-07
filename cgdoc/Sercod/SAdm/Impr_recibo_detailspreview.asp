<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Impr_recibo_variables.asp"-->

<%
if SESSION("UserID")="" then
	response.End
end if
if not CheckSecurity(SESSION("OwnerID"),"Search") then
	response.End
end if

dbConnection=""
db_connect()
Set rs = server.CreateObject("ADODB.Recordset")
Set rss = server.CreateObject("ADODB.Recordset")
dim recordsCounter


strSQL = gstrSQL


str = SecuritySQL("Search")
if len(str)>0 then _
	where = where & " and " & str
strSQL=AddWhere(strSQL,where)

strSQL=strSQL & " " & gstrOrderBy

rs.Open strSQL, dbConnection,1,2

if GetRowCount(strSQL) <> 0 then
	response.write "Ítens Encontrados" & ": <strong>" & GetRowCount(strSQL) & "</strong>"
			if GetRowCount(strSQL) > 10 then
			response.write ". Displaying first: <strong>10</strong>.<br /><br />"
		else
			response.write "<br /><br />"
		end if
	response.write "<table cellpadding=1 cellspacing=1 border=0 align=left class=""detailtable""><tr>"
	response.write "<td><strong>DtMovim</strong></td>"
	response.write "<td><strong>Destino</strong></td>"
	response.write "<td><strong>NrProtoc</strong></td>"
	response.write "<td><strong>Descr</strong></td>"
	response.write "<td><strong>Nome</strong></td>"
	response.write "</tr>"
	do while not rs.EOF
		recordsCounter = recordsCounter + 1
					if recordsCounter > 10 then Exit Do
		response.write "<tr>"
		keylink=""
		keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("NrProtoc"))))
		keylink=keylink & "&key2=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("DtMovim"))))

	Set fso = CreateObject("Scripting.FileSystemObject")

	'//	DtMovim - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtMovim", "Short Date"),"field=DtMovim" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Destino - 
	value=""
				value = ProcessLargeText(GetData(rs,"Destino", ""),"field=Destino" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	NrProtoc - 
	value=""
				value = ProcessLargeText(GetData(rs,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Descr - 
	value=""
				value = ProcessLargeText(GetData(rs,"Descr", ""),"field=Descr" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Nome - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nome", ""),"field=Nome" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
		response.write "</tr>"
		rs.MoveNext
	loop
rs.Close	
	response.write "</table>"
else
	response.write "Ítens Encontrados" & ": <strong>" & GetRowCount(strSQL) & "</strong>"
end if

response.write "counterSeparator" & postvalue("counter")
%>