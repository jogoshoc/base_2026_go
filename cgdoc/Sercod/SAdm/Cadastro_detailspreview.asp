<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Cadastro_variables.asp"-->

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
	response.write "<td><strong>Data Entrada</strong></td>"
	response.write "<td><strong>Natureza</strong></td>"
	response.write "<td><strong>EMISSOR</strong></td>"
	response.write "<td><strong>DESTINO</strong></td>"
	response.write "<td><strong>TipoDoc</strong></td>"
	response.write "<td><strong>Descrição</strong></td>"
	response.write "<td><strong>Assunto</strong></td>"
	response.write "<td><strong>Nome</strong></td>"
	response.write "<td><strong>Obs</strong></td>"
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
				if len(rs("NrProtoc"))>0 then
				strdata = make_db_value("NrProtoc",rs("NrProtoc"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[ProxNr]"
				LookupSQL=LookupSQL & " FROM [ConsultaWebNovoNrProtoc] WHERE [ProxNr] = " & strdata
							LogInfo(LookupSQL)
				rss.Open LookupSQL,dbConnection
				if not rss.EOF then
					value=ProcessLargeText(rss(0),"","",MODE_PRINT)
				else
					value=ProcessLargeText(GetData(rs,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_PRINT)
				end if
				rss.close
			else
				value=""
			end if
			response.write "<td>" & value & "</td>"
	'//	DtEntr - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtEntr", "Short Date"),"field=DtEntr" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Nat - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nat", ""),"field=Nat" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Emissor - 
	value=""
				if len(rs("Emissor"))>0 then
				strdata = make_db_value("Emissor",rs("Emissor"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[Orgao]"
				LookupSQL=LookupSQL & " FROM [Orgaos] WHERE [Orgao] = " & strdata
							LogInfo(LookupSQL)
				rss.Open LookupSQL,dbConnection
				if not rss.EOF then
					value=ProcessLargeText(rss(0),"","",MODE_PRINT)
				else
					value=ProcessLargeText(GetData(rs,"Emissor", ""),"field=Emissor" & keylink,"",MODE_PRINT)
				end if
				rss.close
			else
				value=""
			end if
			response.write "<td>" & value & "</td>"
	'//	Destino - 
	value=""
				if len(rs("Destino"))>0 then
				strdata = make_db_value("Destino",rs("Destino"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[Orgao]"
				LookupSQL=LookupSQL & " FROM [Orgaos] WHERE [Orgao] = " & strdata
							LogInfo(LookupSQL)
				rss.Open LookupSQL,dbConnection
				if not rss.EOF then
					value=ProcessLargeText(rss(0),"","",MODE_PRINT)
				else
					value=ProcessLargeText(GetData(rs,"Destino", ""),"field=Destino" & keylink,"",MODE_PRINT)
				end if
				rss.close
			else
				value=""
			end if
			response.write "<td>" & value & "</td>"
	'//	TipoDoc - 
	value=""
				if len(rs("TipoDoc"))>0 then
				strdata = make_db_value("TipoDoc",rs("TipoDoc"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[TipoDoc]"
				LookupSQL=LookupSQL & " FROM [Tipodoc] WHERE [TipoDoc] = " & strdata
							LogInfo(LookupSQL)
				rss.Open LookupSQL,dbConnection
				if not rss.EOF then
					value=ProcessLargeText(rss(0),"","",MODE_PRINT)
				else
					value=ProcessLargeText(GetData(rs,"TipoDoc", ""),"field=TipoDoc" & keylink,"",MODE_PRINT)
				end if
				rss.close
			else
				value=""
			end if
			response.write "<td>" & value & "</td>"
	'//	Descr - 
	value=""
				value = ProcessLargeText(GetData(rs,"Descr", ""),"field=Descr" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Assunto - 
	value=""
				value = ProcessLargeText(GetData(rs,"Assunto", ""),"field=Assunto" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Nome - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nome", ""),"field=Nome" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Obs - 
	value=""
				value = ProcessLargeText(GetData(rs,"Obs", ""),"field=Obs" & keylink,"",MODE_PRINT)
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