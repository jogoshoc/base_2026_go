<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/moviment_sec_variables.asp"-->

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

'	process masterkey value
dim mastertable
mastertable=postvalue("mastertable")
if mastertable<>"" then
	SESSION(strTableName & "_mastertable")=mastertable
'	copy keys to session
	i=1
	while REQUEST("masterkey" & i)<>""
		SESSION(strTableName & "_masterkey" & i)=REQUEST("masterkey" & i)
		i=i+1
	wend
'	reset search and page number
	SESSION(strTableName & "_search")=0
	SESSION(strTableName & "_pagenumber")=1
else
	mastertable=SESSION(strTableName & "_mastertable")
end if


strSQL = gstrSQL

if mastertable="Tramitacao" then
	where =""
		where=where & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc",SESSION(strTableName & "_masterkey1"),"","")
end if

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
	response.write "<td><strong>Data Distrib</strong></td>"
	response.write "<td><strong>Destino (func)</strong></td>"
	response.write "<td><strong>Obs</strong></td>"
	response.write "<td><strong>Prazo</strong></td>"
	response.write "<td><strong>Cumprido</strong></td>"
	response.write "<td><strong>Solução</strong></td>"
	response.write "</tr>"
	do while not rs.EOF
		recordsCounter = recordsCounter + 1
					if recordsCounter > 10 then Exit Do
		response.write "<tr>"
		keylink=""
		keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("CodMov"))))
		keylink=keylink & "&key2=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("NrProtoc"))))

	Set fso = CreateObject("Scripting.FileSystemObject")

	'//	DtMovim - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtMovim", "Short Date"),"field=DtMovim" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DestNome - 
	value=""
				value = ProcessLargeText(GetData(rs,"DestNome", ""),"field=DestNome" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Obs - 
	value=""
				value = ProcessLargeText(GetData(rs,"Obs", ""),"field=Obs" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Prazo - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"Prazo", "Short Date"),"field=Prazo" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Cumprido - 
	value=""
				value = ProcessLargeText(GetData(rs,"Cumprido", ""),"field=Cumprido" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Solucao - 
	value=""
				value = ProcessLargeText(GetData(rs,"Solucao", ""),"field=Solucao" & keylink,"",MODE_PRINT)
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