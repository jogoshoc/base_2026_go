<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/moviment_sec2_variables.asp"-->

<%
dim field, value, lookupValue, checkFlag, lookupSQL, output, numDictEl

field = postvalue("searchField")
value = postvalue("searchFor")
lookupValue = postvalue("lookupValue")

dbConnection=""
db_connect()

LookupSQL = ""
output = ""
tmpvalue = ""
numDictEl = 0
set objDict = Server.CreateObject("Scripting.Dictionary") 

	if SESSION("UserID")="" then
		response.End
	end if
	if not CheckSecurity(SESSION("OwnerID"),"Search") and not CheckSecurity(SESSION("OwnerID"),"Add") and not CheckSecurity(SESSION("OwnerID"),"Edit") then
		response.End
	end if

if strTableName = "Cadastro" and field = "NrProtoc" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[ProxNr]"
		LookupSQL = LookupSQL & ",[ProxNr]"
	LookupSQL = LookupSQL & " FROM [ConsultaWebNovoNrProtoc] "
		LookupSQL = LookupSQL & " WHERE [ProxNr] LIKE '" & db_addslashes(value) & "%'"
	end if
if strTableName = "Cadastro" and field = "Emissor" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		end if
if strTableName = "Cadastro" and field = "TipoDoc" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[TipoDoc]"
		LookupSQL = LookupSQL & ",[TipoDoc]"
	LookupSQL = LookupSQL & " FROM [Tipodoc] "
		LookupSQL = LookupSQL & " WHERE [TipoDoc] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Tipodoc].[TipoDoc]"
		end if
if strTableName = "Cadastro" and field = "Destino" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		end if
if strTableName = "Moviment" and field = "OrigNome" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		end if
if strTableName = "Moviment" and field = "DestNome" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		end if
if strTableName = "Moviment2" and field = "OrigNome" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		end if
if strTableName = "Moviment2" and field = "DestNome" then
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(value) & "%'"
			LookupSQL = LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		end if
if strTableName = "moviment_sec" and field = "Cumprido" then
	end if
if strTableName = "moviment_sec2" and field = "Cumprido" then
	end if

Set rs = server.CreateObject("ADODB.Recordset")
rs.open LookupSQL,dbConnection

do while not rs.EOF
	tmpvalue = rs(0)
	objDict.Add numDictEl, tmpvalue
	numDictEl = numDictEl + 1
	tmpvalue = rs(1)
	objDict.Add numDictEl, tmpvalue
	numDictEl = numDictEl + 1
	rs.MoveNext
loop
rs.Close	

if strTableName = "Cadastro" and field = "NrProtoc" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[ProxNr]"
		LookupSQL = LookupSQL & ",[ProxNr]"
	LookupSQL = LookupSQL & " FROM [ConsultaWebNovoNrProtoc] "
		LookupSQL = LookupSQL & " WHERE [ProxNr]=" & lookupValue & ""
end if
if strTableName = "Cadastro" and field = "Emissor" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao]=" & lookupValue & ""
end if
if strTableName = "Cadastro" and field = "TipoDoc" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[TipoDoc]"
		LookupSQL = LookupSQL & ",[TipoDoc]"
	LookupSQL = LookupSQL & " FROM [Tipodoc] "
		LookupSQL = LookupSQL & " WHERE [TipoDoc]=" & lookupValue & ""
end if
if strTableName = "Cadastro" and field = "Destino" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao]=" & lookupValue & ""
end if
if strTableName = "Moviment" and field = "OrigNome" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao]=" & lookupValue & ""
end if
if strTableName = "Moviment" and field = "DestNome" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "DISTINCT "
	LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao]=" & lookupValue & ""
end if
if strTableName = "Moviment2" and field = "OrigNome" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao]=" & lookupValue & ""
end if
if strTableName = "Moviment2" and field = "DestNome" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
		LookupSQL = "SELECT "
		LookupSQL = LookupSQL & "[Orgao]"
		LookupSQL = LookupSQL & ",[Orgao]"
	LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao]=" & lookupValue & ""
end if
if strTableName = "moviment_sec" and field = "Cumprido" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
	end if
if strTableName = "moviment_sec2" and field = "Cumprido" then
	lookupValue = make_db_value(field,lookupValue,"","")
	
	end if

Set rs1 = server.CreateObject("ADODB.Recordset")
rs1.open LookupSQL,dbConnection

if not rs1.EOF then
	if strTableName = "Cadastro" and field = "NrProtoc" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "[ProxNr]"
				LookupSQL = LookupSQL & ",[ProxNr]"
		LookupSQL = LookupSQL & " FROM [ConsultaWebNovoNrProtoc] "
		LookupSQL = LookupSQL & " WHERE [ProxNr] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Cadastro" and field = "Emissor" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "DISTINCT "
		LookupSQL = LookupSQL & "[Orgao]"
				LookupSQL = LookupSQL & ",[Orgao]"
		LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Cadastro" and field = "TipoDoc" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "[TipoDoc]"
				LookupSQL = LookupSQL & ",[TipoDoc]"
		LookupSQL = LookupSQL & " FROM [Tipodoc] "
		LookupSQL = LookupSQL & " WHERE [TipoDoc] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Cadastro" and field = "Destino" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "DISTINCT "
		LookupSQL = LookupSQL & "[Orgao]"
				LookupSQL = LookupSQL & ",[Orgao]"
		LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Moviment" and field = "OrigNome" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "DISTINCT "
		LookupSQL = LookupSQL & "[Orgao]"
				LookupSQL = LookupSQL & ",[Orgao]"
		LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Moviment" and field = "DestNome" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "DISTINCT "
		LookupSQL = LookupSQL & "[Orgao]"
				LookupSQL = LookupSQL & ",[Orgao]"
		LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Moviment2" and field = "OrigNome" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "[Orgao]"
				LookupSQL = LookupSQL & ",[Orgao]"
		LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "Moviment2" and field = "DestNome" then
				LookupSQL = "SELECT "
				LookupSQL = LookupSQL & "[Orgao]"
				LookupSQL = LookupSQL & ",[Orgao]"
		LookupSQL = LookupSQL & " FROM [Orgaos] "
		LookupSQL = LookupSQL & " WHERE [Orgao] LIKE '" & db_addslashes(lookupValue) & "%'"
	end if
	if strTableName = "moviment_sec" and field = "Cumprido" then
			end if
	if strTableName = "moviment_sec2" and field = "Cumprido" then
			end if
		
	Set rs2 = server.CreateObject("ADODB.Recordset")
	rs2.open LookupSQL,dbConnection

	do while not rs2.EOF
		tmpvalue = rs2(0)
		objDict.Add numDictEl, tmpvalue
		numDictEl = numDictEl + 1
		tmpvalue = rs2(1)
		objDict.Add numDictEl, tmpvalue
		numDictEl = numDictEl + 1
		rs2.MoveNext
	loop
	rs2.Close	
		
end if
	
dim allItems, myItem
allItems = objDict.Items

if objDict.Count < 40 then
	for i=0 to objDict.Count - 1 
		myItem = allItems(i)
		response.write myItem & vbLf
		'response.write Replace(myItem,vbLf,"\\n") & vbLf
	next
else
	for i=0 to 39 
		myItem = allItems(i)
		response.write myItem & vbLf
		'response.write Replace(myItem,vbLf,"\\n") & vbLf
	next
end if

%>