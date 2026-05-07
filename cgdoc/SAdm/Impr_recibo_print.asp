<!--#include file="include/dbcommon.asp"-->
<!--#include file="include/Impr_recibo_variables.asp"-->

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
		sWhere = sWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", request("mdelete1[]").Item(request("mdelete[]").Item(ind)),"","")
                    sWhere = sWhere & " and "
		sWhere = sWhere & GetFullFieldName("DtMovim","") & "=" & make_db_value("DtMovim", request("mdelete2[]").Item(request("mdelete[]").Item(ind)),"","")
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
			keylink=keylink & "&key1=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("NrProtoc"))))
			keylink=keylink & "&key2=" & my_htmlspecialchars(server.urlencode(dbvalue(rs("DtMovim"))))

Set fso = CreateObject("Scripting.FileSystemObject")


'//	Descr - 
	value=""
				value = ProcessLargeText(GetData(rs,"Descr", ""),"field=Descr" & keylink,"",MODE_PRINT)
			row.Add col & "Descr_value",value & "&nbsp;"

'//	Nome - 
	value=""
				value = ProcessLargeText(GetData(rs,"Nome", ""),"field=Nome" & keylink,"",MODE_PRINT)
			row.Add col & "Nome_value",value & "&nbsp;"

'//	DtMovim - Short Date
	value=""
				value = ProcessLargeText(GetData(rs,"DtMovim", "Short Date"),"field=DtMovim" & keylink,"",MODE_PRINT)
			row.Add col & "DtMovim_value",value & "&nbsp;"

'//	Destino - 
	value=""
				value = ProcessLargeText(GetData(rs,"Destino", ""),"field=Destino" & keylink,"",MODE_PRINT)
			row.Add col & "Destino_value",value & "&nbsp;"

'//	NrProtoc - 
	value=""
				value = ProcessLargeText(GetData(rs,"NrProtoc", ""),"field=NrProtoc" & keylink,"",MODE_PRINT)
			row.Add col & "NrProtoc_value",value & "&nbsp;"
			rs.MoveNext
			row.Add col & "show",true
		wend
		rowinfo.Add ri,row
		ri=ri+1
	wend
	smarty.Add "rowinfo",rowinfo
	rs.Close


	

strSQL=SESSION(strTableName & "_sql")
smarty_display("Impr_recibo_print.htm")
%>