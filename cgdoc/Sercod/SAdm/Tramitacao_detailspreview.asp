<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Tramitacao_variables.asp"-->

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
	response.write "<td><strong>Nr Protoc</strong></td>"
	response.write "<td><strong>Data Movim.</strong></td>"
	response.write "<td><strong>Seção ORIGEM</strong></td>"
	response.write "<td><strong>Seção DESTINO</strong></td>"
	response.write "<td><strong>Obs</strong></td>"
	response.write "<td><strong>Prazo</strong></td>"
	response.write "<td><strong>Emissor</strong></td>"
	response.write "<td><strong>Assunto</strong></td>"
	response.write "<td><strong>Tipo</strong></td>"
	response.write "<td><strong>Descrição</strong></td>"
	response.write "<td><strong>Nome</strong></td>"
	response.write "<td><strong>Data Entrada</strong></td>"
	response.write "</tr>"
	do while not rs.EOF
		recordsCounter = recordsCounter + 1
					if recordsCounter > 10 then Exit Do
		response.write "<tr>"
		keylink=""
		keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("NrProtoc"))))

	Set fso = CreateObject("Scripting.FileSystemObject")

	'//	NrProtoc - 
	value=""
				value = ProcessLargeText(GetData(rs,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DtMovim - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtMovim", "Short Date"),"field=DtMovim" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	OrigNome - 
	value=""
				value = ProcessLargeText(GetData(rs,"OrigNome", ""),"field=OrigNome" & keylink,"",MODE_PRINT)
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
	'//	Emissor - 
	value=""
				value = ProcessLargeText(GetData(rs,"Emissor", ""),"field=Emissor" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Assunto - 
	value=""
				value = ProcessLargeText(GetData(rs,"Assunto", ""),"field=Assunto" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	TipoDoc - 
	value=""
				value = ProcessLargeText(GetData(rs,"TipoDoc", ""),"field=TipoDoc" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Descr - 
	value=""
				value = ProcessLargeText(GetData(rs,"Descr", ""),"field=Descr" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Nome - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nome", ""),"field=Nome" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	DtEntr - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtEntr", "Short Date"),"field=DtEntr" & keylink,"",MODE_PRINT)
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