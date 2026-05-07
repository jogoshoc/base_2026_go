<!--#include file="Tramitacao_settings.asp"-->
<%
function DisplayMasterTableInfo(detailtable, keys)
	
	oldTableName=strTableName
	strTableName="Tramitacao"

strSQL = "select [NrProtoc],   [CodMov],   [DtMovim],   [OrigNome],   [DestNome],   [Obs],   [Prazo],   [Emissor],   [Assunto],   [TipoDoc],   [Descr],   [Nome],   [DtEntr]  From [Tramitacao]"
where=""

if detailtable="Moviment2" then
		where=where &  GetFullFieldName("NrProtoc",strTableName) & "=" & make_db_value("NrProtoc",keys(1-1),"","")
elseif(detailtable="moviment_sec") then
		where=where &  GetFullFieldName("NrProtoc",strTableName) & "=" & make_db_value("NrProtoc",keys(1-1),"","")
end if
if where="" then
	strTableName=oldTableName
	exit function
end if

	str = SecuritySQL("Export")
	if len(str)>0 then _
		where = where & " and " & str
	strSQL=AddWhere(strSQL,where)
	LogInfo(strSQL)

	dbConnection=""
	db_connect()
	Set rsm = server.CreateObject("ADODB.Recordset")
	rsm.Open strSQL,dbConnection,1,2
	keylink=""
	keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rsm("NrProtoc"))))

Set fso = CreateObject("Scripting.FileSystemObject")


'//	NrProtoc - 
	value=""
				value = ProcessLargeText(GetData(rsm,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_NrProtoc",value

'//	DtMovim - Short Date
	value=""
				value = ProcessLargeText(GetData(rsm,"DtMovim", "Short Date"),"field=DtMovim" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_DtMovim",value

'//	OrigNome - 
	value=""
				value = ProcessLargeText(GetData(rsm,"OrigNome", ""),"field=OrigNome" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_OrigNome",value

'//	DestNome - 
	value=""
				value = ProcessLargeText(GetData(rsm,"DestNome", ""),"field=DestNome" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_DestNome",value

'//	Obs - 
	value=""
				value = ProcessLargeText(GetData(rsm,"Obs", ""),"field=Obs" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_Obs",value

'//	Prazo - Short Date
	value=""
				value = ProcessLargeText(GetData(rsm,"Prazo", "Short Date"),"field=Prazo" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_Prazo",value

'//	Emissor - 
	value=""
				value = ProcessLargeText(GetData(rsm,"Emissor", ""),"field=Emissor" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_Emissor",value

'//	Assunto - 
	value=""
				value = ProcessLargeText(GetData(rsm,"Assunto", ""),"field=Assunto" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_Assunto",value

'//	TipoDoc - 
	value=""
				value = ProcessLargeText(GetData(rsm,"TipoDoc", ""),"field=TipoDoc" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_TipoDoc",value

'//	Descr - 
	value=""
				value = ProcessLargeText(GetData(rsm,"Descr", ""),"field=Descr" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_Descr",value

'//	Nome - 
	value=""
				value = ProcessLargeText(GetData(rsm,"Nome", ""),"field=Nome" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_Nome",value

'//	DtEntr - Short Date
	value=""
				value = ProcessLargeText(GetData(rsm,"DtEntr", "Short Date"),"field=DtEntr" & keylink,"",MODE_PRINT)
			smarty.Add "showmaster_DtEntr",value
	strTableName=oldTableName
end function
%>