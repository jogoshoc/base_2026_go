<!--#include file="Cadastro_settings.asp"-->
<%
function DisplayMasterTableInfo(detailtable, keys)
	
	oldTableName=strTableName
	strTableName="Cadastro"

strSQL = "select [Controle],   [NrProtoc],   [DtEntr],   [Descr],   [Emissor],   [Nome],  [MASP], [CPF], [Assunto],   [TipoDoc],   [Nat],   [Destino],   [Obs],   [Usuario],   [PastaArquiv]  From [Cadastro]"
where=""

if detailtable="Moviment" then
		where=where & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc",keys(1-1),"","")
elseif detailtable="moviment_sec2" then
		where=where & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc",keys(1-1),"","")
end if
if where="" then
	strTableName=oldTableName
	exit function
end if

	str = SecuritySQL("Search")
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
				if len(rsm("NrProtoc")) then
				strdata = make_db_value("NrProtoc",rsm("NrProtoc"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[ProxNr]"
				LookupSQL=LookupSQL & " FROM [ConsultaWebNovoNrProtoc] WHERE [ProxNr] = " & strdata
							LogInfo(LookupSQL)
				Set lookuprow = server.CreateObject("ADODB.Recordset")
				lookuprow.Open LookupSQL,dbConnection
				if not lookuprow.EOF then
					value=ProcessLargeText(lookuprow(0),"","",MODE_LIST)
				else
					value=ProcessLargeText(GetData(rsm,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_LIST)
				end if
				lookuprow.Close
			end if
			smarty.add "showmaster_NrProtoc",value

'//	DtEntr - Short Date
			value=""
				value = ProcessLargeText(GetData(rsm,"DtEntr", "Short Date"),"field=DtEntr" & keylink,"",MODE_LIST)
			smarty.add "showmaster_DtEntr",value

'//	Nat - 
			value=""
				value = ProcessLargeText(GetData(rsm,"Nat", ""),"field=Nat" & keylink,"",MODE_LIST)
			smarty.add "showmaster_Nat",value

'//	Emissor - 
			value=""
				if len(rsm("Emissor")) then
				strdata = make_db_value("Emissor",rsm("Emissor"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[Orgao]"
				LookupSQL=LookupSQL & " FROM [Orgaos] WHERE [Orgao] = " & strdata
							LogInfo(LookupSQL)
				Set lookuprow = server.CreateObject("ADODB.Recordset")
				lookuprow.Open LookupSQL,dbConnection
				if not lookuprow.EOF then
					value=ProcessLargeText(lookuprow(0),"","",MODE_LIST)
				else
					value=ProcessLargeText(GetData(rsm,"Emissor", ""),"field=Emissor" & keylink,"",MODE_LIST)
				end if
				lookuprow.Close
			end if
			smarty.add "showmaster_Emissor",value

'//	Destino - 
			value=""
				if len(rsm("Destino")) then
				strdata = make_db_value("Destino",rsm("Destino"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[Orgao]"
				LookupSQL=LookupSQL & " FROM [Orgaos] WHERE [Orgao] = " & strdata
							LogInfo(LookupSQL)
				Set lookuprow = server.CreateObject("ADODB.Recordset")
				lookuprow.Open LookupSQL,dbConnection
				if not lookuprow.EOF then
					value=ProcessLargeText(lookuprow(0),"","",MODE_LIST)
				else
					value=ProcessLargeText(GetData(rsm,"Destino", ""),"field=Destino" & keylink,"",MODE_LIST)
				end if
				lookuprow.Close
			end if
			smarty.add "showmaster_Destino",value

'//	TipoDoc - 
			value=""
				if len(rsm("TipoDoc")) then
				strdata = make_db_value("TipoDoc",rsm("TipoDoc"),"","")
				LookupSQL="SELECT "
							LookupSQL=LookupSQL & "[TipoDoc]"
				LookupSQL=LookupSQL & " FROM [Tipodoc] WHERE [TipoDoc] = " & strdata
							LogInfo(LookupSQL)
				Set lookuprow = server.CreateObject("ADODB.Recordset")
				lookuprow.Open LookupSQL,dbConnection
				if not lookuprow.EOF then
					value=ProcessLargeText(lookuprow(0),"","",MODE_LIST)
				else
					value=ProcessLargeText(GetData(rsm,"TipoDoc", ""),"field=TipoDoc" & keylink,"",MODE_LIST)
				end if
				lookuprow.Close
			end if
			smarty.add "showmaster_TipoDoc",value

'//	Descr - 
			value=""
				value = ProcessLargeText(GetData(rsm,"Descr", ""),"field=Descr" & keylink,"",MODE_LIST)
			smarty.add "showmaster_Descr",value

'//	Assunto - 
			value=""
				value = ProcessLargeText(GetData(rsm,"Assunto", ""),"field=Assunto" & keylink,"",MODE_LIST)
			smarty.add "showmaster_Assunto",value

'//	Nome - 
			value=""
				value = ProcessLargeText(GetData(rsm,"Nome", ""),"field=Nome" & keylink,"",MODE_LIST)
			smarty.add "showmaster_Nome",value
			
'//	MASP - 
			value=""
				value = ProcessLargeText(GetData(rsm,"MASP", ""),"field=MASP" & keylink,"",MODE_LIST)
			smarty.add "showmaster_MASP",value			

'//	CPF - 
			value=""
				value = ProcessLargeText(GetData(rsm,"CPF", ""),"field=CPF" & keylink,"",MODE_LIST)
			smarty.add "showmaster_CPF",value

'//	Obs - 
			value=""
				value = ProcessLargeText(GetData(rsm,"Obs", ""),"field=Obs" & keylink,"",MODE_LIST)
			smarty.add "showmaster_Obs",value
	rsm.Close
	strTableName=oldTableName
end function
%>