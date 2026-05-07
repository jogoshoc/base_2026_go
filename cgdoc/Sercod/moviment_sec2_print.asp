<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/moviment_sec2_variables.asp"-->

<!--#include file="libs/smarty.asp"-->

<%if SESSION("UserID")="" then
	SESSION("MyURL")=request.ServerVariables("SCRIPT_NAME")&"?"&request.ServerVariables("QUERY_STRING")
	response.Redirect "login.asp?message=expired"
	response.End
end if
if not CheckSecurity(SESSION("OwnerID"),"Export") then
	response.Write "<p>" & "Você não tem permissão para acessar esta tabela" & "<a href=""login.asp"">" & "Voltar à página de Login" & "</a></p>"
	response.End
end if


dbConnection=""
db_connect()
Set rs = server.CreateObject("ADODB.Recordset")
Set rss = server.CreateObject("ADODB.Recordset")

if request("a")="" then
	strSQL=SESSION(strTableName & "_sql")
else

	
sWhere = ""	
for ind=1 to request("mdelete[]").Count
		sWhere = sWhere & GetFullFieldName("CodMov","") & "=" & make_db_value("CodMov", request("mdelete1[]").Item(request("mdelete[]").Item(ind)),"","")
                    sWhere = sWhere & " and "
		sWhere = sWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", request("mdelete2[]").Item(request("mdelete[]").Item(ind)),"","")
        	if ind<request("mdelete[]").Count then sWhere = sWhere & " or " end if
next
strSQL = AddWhere(gstrSQL,sWhere)

end if	

LogInfo(strSQL)


'//	 Pagination:
numrows=GetRowCount(strSQL)
mypage=cint(SESSION(strTableName & "_pagenumber"))
if mypage=0 then mypage=1

'//	page size
PageSize=cint(SESSION(strTableName & "_pagesize"))
if PageSize=0 then PageSize=gPageSize

recno=1
	
if numrows>0 then
	maxRecords = numrows
	maxpages=int(maxRecords/PageSize)
	if maxRecords mod PageSize <> 0 then maxpages=maxpages+1
	if mypage > maxpages then mypage = maxpages
	if mypage<1 then mypage=1
	maxrecs=PageSize
	
		strSQL = AddTop(strSQL, mypage*PageSize)
	end if
	rs.Open strSQL, dbConnection,1,2
	if not rs.EOF then rs.Move(PageSize*(mypage-1))

'	hide colunm headers if needed
recordsonpage=numrows-(mypage-1)*PageSize
if recordsonpage>PageSize then _
	recordsonpage=PageSize
	if recordsonpage>=1 then
		smarty.Add "column1show",true
	else
		smarty.Add "column1show",false
	end if



	Set rowinfo = CreateObject("Scripting.Dictionary")

	
ri=0
	while not rs.EOF and recno<=PageSize
		Set row = CreateObject("Scripting.Dictionary")
		col=0
		
		while not rs.EOF and recno<=PageSize and col<1
			col=col+1

			recno=recno+1
			keylink=""
			keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("CodMov"))))
			keylink=keylink & "&key2=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("NrProtoc"))))

Set fso = CreateObject("Scripting.FileSystemObject")


'//	Solucao - 
	value=""
				value = ProcessLargeText(GetData(rs,"Solucao", ""),"field=Solucao" & keylink,"",MODE_PRINT)
			row.Add col & "Solucao_value",value & "&nbsp;"

'//	DtMovim - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtMovim", "Short Date"),"field=DtMovim" & keylink,"",MODE_PRINT)
			row.Add col & "DtMovim_value",value & "&nbsp;"

'//	DestNome - 
	value=""
				value = ProcessLargeText(GetData(rs,"DestNome", ""),"field=DestNome" & keylink,"",MODE_PRINT)
			row.Add col & "DestNome_value",value & "&nbsp;"

'//	Obs - 
	value=""
				value = ProcessLargeText(GetData(rs,"Obs", ""),"field=Obs" & keylink,"",MODE_PRINT)
			row.Add col & "Obs_value",value & "&nbsp;"

'//	Prazo - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"Prazo", "Short Date"),"field=Prazo" & keylink,"",MODE_PRINT)
			row.Add col & "Prazo_value",value & "&nbsp;"

'//	Cumprido - 
	value=""
				value = ProcessLargeText(GetData(rs,"Cumprido", ""),"field=Cumprido" & keylink,"",MODE_PRINT)
			row.Add col & "Cumprido_value",value & "&nbsp;"
			rs.MoveNext
			row.Add col & "show",true
		wend
		rowinfo.Add ri,row
		ri=ri+1
	wend
	smarty.Add "rowinfo",rowinfo
	rs.Close


	
'//	display master table info
mastertable=SESSION(strTableName & "_mastertable")
dim masterkeys()
smarty.Add "showmasterfile","empty.htm"
i=0
if mastertable="Cadastro" then
'//	include proper masterprint.php code%>
	<!--#include file="include/Cadastro_masterprint.asp"-->
	<%
	redim preserve masterkeys(i+1)
	masterkeys(i)=SESSION(strTableName & "_masterkey1")
	i=i+1
	DisplayMasterTableInfo "moviment_sec2", masterkeys
	if smarty.exists("showmasterfile") then smarty.remove("showmasterfile")
	smarty.Add "showmasterfile","Cadastro_masterprint.htm"
end if

strSQL=SESSION(strTableName & "_sql")
smarty_display("moviment_sec2_print.htm")
%>