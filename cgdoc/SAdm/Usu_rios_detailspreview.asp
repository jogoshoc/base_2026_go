<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Usu_rios_variables.asp"-->

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
			if GetRowCount(strSQL) > 5 then
			response.write ". Displaying first: <strong>5</strong>.<br /><br />"
		else
			response.write "<br /><br />"
		end if
	response.write "<table cellpadding=1 cellspacing=1 border=0 align=left class=""detailtable""><tr>"
	response.write "<td><strong>NúmeroDoUsuário</strong></td>"
	response.write "<td><strong>PG</strong></td>"
	response.write "<td><strong>Nome</strong></td>"
	response.write "<td><strong>Ramal</strong></td>"
	response.write "<td><strong>Unidade</strong></td>"
	response.write "<td><strong>Seção</strong></td>"
	response.write "<td><strong>Fotografia</strong></td>"
	response.write "<td><strong>Privilegio</strong></td>"
	response.write "</tr>"
	do while not rs.EOF
		recordsCounter = recordsCounter + 1
					if recordsCounter > 5  then Exit Do
		response.write "<tr>"
		keylink=""
		keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("NúmeroDoUsuário"))))

	Set fso = CreateObject("Scripting.FileSystemObject")

	'//	NúmeroDoUsuário - 
	value=""
				value = ProcessLargeText(GetData(rs,"NúmeroDoUsuário", ""),"field=N%FAmeroDoUsu%E1rio" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	PG - 
	value=""
				value = ProcessLargeText(GetData(rs,"PG", ""),"field=PG" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Nome - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nome", ""),"field=Nome" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Ramal - 
	value=""
				value = ProcessLargeText(GetData(rs,"Ramal", ""),"field=Ramal" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Unidade - 
	value=""
				value = ProcessLargeText(GetData(rs,"Unidade", ""),"field=Unidade" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Seção - 
	value=""
				value = ProcessLargeText(GetData(rs,"Seção", ""),"field=Se%E7%E3o" & keylink,"",MODE_PRINT)
			response.write "<td>" & value & "</td>"
	'//	Fotografia - Database Image
	value=""
						value = "<img"
							value=value & " border=0"
			value=value & " src=""Usu_rios_imager.asp?field=Fotografia" & keylink & """>"
			response.write "<td>" & value & "</td>"
	'//	Privilegio - 
	value=""
				value = ProcessLargeText(GetData(rs,"Privilegio", ""),"field=Privilegio" & keylink,"",MODE_PRINT)
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