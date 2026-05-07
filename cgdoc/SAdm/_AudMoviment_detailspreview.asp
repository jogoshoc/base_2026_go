<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/_AudMoviment_variables.asp"-->

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
	response.write "<td><strong>CodMov</strong></td>"
	response.write "<td><strong>NrProtoc</strong></td>"
	response.write "<td><strong>DataAlteracao</strong></td>"
	response.write "<td><strong>DataAnt</strong></td>"
	response.write "<td><strong>DataMod</strong></td>"
	response.write "<td><strong>OrigAnt</strong></td>"
	response.write "<td><strong>OrigMod</strong></td>"
	response.write "<td><strong>DestAnt</strong></td>"
	response.write "<td><strong>DestMod</strong></td>"
	response.write "<td><strong>ObsAnt</strong></td>"
	response.write "<td><strong>ObsMod</strong></td>"
	response.write "<td><strong>PrazoAnt</strong></td>"
	response.write "<td><strong>PrazoMod</strong></td>"
	response.write "<td><strong>ID</strong></td>"
	response.write "</tr>"
	do while not rs.EOF
		recordsCounter = recordsCounter + 1
					if recordsCounter > 10 then Exit Do
		response.write "<tr>"
		keylink=""
		keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("ID"))))

	Set fso = CreateObject("Scripting.FileSystemObject")

	'//	CodMov - 
	value=""
				value = ProcessLargeText(GetData(rs,"CodMov", ""),"field=CodMov" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	NrProtoc - 
	value=""
				value = ProcessLargeText(GetData(rs,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DataAlteracao - 
	value=""
				value = ProcessLargeText(GetData(rs,"DataAlteracao", ""),"field=DataAlteracao" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DataAnt - 
	value=""
				value = ProcessLargeText(GetData(rs,"DataAnt", ""),"field=DataAnt" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DataMod - 
	value=""
				value = ProcessLargeText(GetData(rs,"DataMod", ""),"field=DataMod" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	OrigAnt - 
	value=""
				value = ProcessLargeText(GetData(rs,"OrigAnt", ""),"field=OrigAnt" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	OrigMod - 
	value=""
				value = ProcessLargeText(GetData(rs,"OrigMod", ""),"field=OrigMod" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DestAnt - 
	value=""
				value = ProcessLargeText(GetData(rs,"DestAnt", ""),"field=DestAnt" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DestMod - 
	value=""
				value = ProcessLargeText(GetData(rs,"DestMod", ""),"field=DestMod" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	ObsAnt - 
	value=""
				value = ProcessLargeText(GetData(rs,"ObsAnt", ""),"field=ObsAnt" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	ObsMod - 
	value=""
				value = ProcessLargeText(GetData(rs,"ObsMod", ""),"field=ObsMod" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	PrazoAnt - 
	value=""
				value = ProcessLargeText(GetData(rs,"PrazoAnt", ""),"field=PrazoAnt" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	PrazoMod - 
	value=""
				value = ProcessLargeText(GetData(rs,"PrazoMod", ""),"field=PrazoMod" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	ID - 
	value=""
				value = ProcessLargeText(GetData(rs,"ID", ""),"field=ID" & keylink,"",MODE_PRINT)
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