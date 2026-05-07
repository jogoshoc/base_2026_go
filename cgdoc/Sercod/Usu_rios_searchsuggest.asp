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

dim objDict, numDictEl, objFields
set objDict = Server.CreateObject("Scripting.Dictionary") 
set objFields = Server.CreateObject("Scripting.Dictionary") 
numDictEl = 0

strSQL = "SELECT * FROM " & AddTableWrappers(strOriginalTableName) & " WHERE 1<0"
rs.Open strSQL, dbConnection,1,2

for i=0 to db_numfields(rs) - 1
	objFields.Add db_fieldname(rs,i),db_fieldname(rs,i)
next

rs.Close

if not IsEmpty(Request.QueryString("searchFor")) and Request.QueryString("searchFor") <> "" then


	dim searchFor, searchField, whereCondition
	searchFor = postvalue("searchFor")
	searchField = postvalue("searchField")
	if suggestAllContent then
		whereCondition = " like '%" & replace(searchFor,"'","''") & "%'"
	else
		whereCondition = " like '" & replace(searchFor,"'","''") & "%'"
	end if
	
		if searchField = "" then
		searchField="NúmeroDoUsuário"
		
		if objFields.Exists(searchField)=true then
			strSQL = "SELECT DISTINCT TOP 10 " & AddFieldWrappers(searchField) & " FROM " & AddTableWrappers(strOriginalTableName) & " WHERE " &_
			AddFieldWrappers(searchField) & whereCondition & " ORDER BY 1"
			rs.Open strSQL, dbConnection,1,2
			do while not rs.EOF
				for each fld in rs.fields
					pos=InStr(rs(searchField),vbLf)
					if not IsNull(pos) and pos <> 0 then
						objDict.Add numDictEl,Left(fld.value,pos)
						numDictEl = numDictEl + 1
					else
						objDict.Add numDictEl,fld.value
						numDictEl = numDictEl + 1
					end if
				next
				rs.MoveNext
			loop
			rs.Close
		end if
		searchField="Nome"
		
		if objFields.Exists(searchField)=true then
			strSQL = "SELECT DISTINCT TOP 10 " & AddFieldWrappers(searchField) & " FROM " & AddTableWrappers(strOriginalTableName) & " WHERE " &_
			AddFieldWrappers(searchField) & whereCondition & " ORDER BY 1"
			rs.Open strSQL, dbConnection,1,2
			do while not rs.EOF
				for each fld in rs.fields
					pos=InStr(rs(searchField),vbLf)
					if not IsNull(pos) and pos <> 0 then
						objDict.Add numDictEl,Left(fld.value,pos)
						numDictEl = numDictEl + 1
					else
						objDict.Add numDictEl,fld.value
						numDictEl = numDictEl + 1
					end if
				next
				rs.MoveNext
			loop
			rs.Close
		end if
		searchField="Seção"
		
		if objFields.Exists(searchField)=true then
			strSQL = "SELECT DISTINCT TOP 10 " & AddFieldWrappers(searchField) & " FROM " & AddTableWrappers(strOriginalTableName) & " WHERE " &_
			AddFieldWrappers(searchField) & whereCondition & " ORDER BY 1"
			rs.Open strSQL, dbConnection,1,2
			do while not rs.EOF
				for each fld in rs.fields
					pos=InStr(rs(searchField),vbLf)
					if not IsNull(pos) and pos <> 0 then
						objDict.Add numDictEl,Left(fld.value,pos)
						numDictEl = numDictEl + 1
					else
						objDict.Add numDictEl,fld.value
						numDictEl = numDictEl + 1
					end if
				next
				rs.MoveNext
			loop
			rs.Close
		end if
		searchField="Privilegio"
		
		if objFields.Exists(searchField)=true then
			strSQL = "SELECT DISTINCT TOP 10 " & AddFieldWrappers(searchField) & " FROM " & AddTableWrappers(strOriginalTableName) & " WHERE " &_
			AddFieldWrappers(searchField) & whereCondition & " ORDER BY 1"
			rs.Open strSQL, dbConnection,1,2
			do while not rs.EOF
				for each fld in rs.fields
					pos=InStr(rs(searchField),vbLf)
					if not IsNull(pos) and pos <> 0 then
						objDict.Add numDictEl,Left(fld.value,pos)
						numDictEl = numDictEl + 1
					else
						objDict.Add numDictEl,fld.value
						numDictEl = numDictEl + 1
					end if
				next
				rs.MoveNext
			loop
			rs.Close
		end if
	else 
	  if objFields.Exists(searchField)=true then
		origfield=GetFieldByGoodFieldName(searchField,"")
		if origfield <> "" then searchField=origfield
		myType=GetFieldType(searchField,"")
		if (IsNumberType(myType) or IsCharType(myType)) and CheckFieldPermissions(searchField,"") then
			strSQL = "SELECT DISTINCT TOP 10 " & AddFieldWrappers(searchField) & " FROM " & AddTableWrappers(strOriginalTableName) &_
			" WHERE " & AddFieldWrappers(searchField) & whereCondition & " ORDER BY 1"
			rs.Open strSQL, dbConnection,1,2
			do while not rs.EOF
				for each fld in rs.fields
					pos=InStr(rs(searchField),vbLf)
					if not IsNull(pos) and pos <> 0 then
						objDict.Add numDictEl,Left(fld.value,pos)
						numDictEl = numDictEl + 1
					else
						objDict.Add numDictEl,fld.value
						numDictEl = numDictEl + 1
					end if
				next
				rs.MoveNext
			loop
			rs.Close		
		end if
	  end if
		end if
end if


dim allItems
allItems = objDict.Items 'Get all the items into an array

for i=0 to objDict.Count - 1
	for j=i+1 to objDict.Count - 1
		if allItems(i)>allItems(j) then
			tmpVar=allItems(i)
			allItems(i)=allItems(j)
			allItems(j)=tmpVar
		end if
	next 
next 

if objDict.Count < 10 then
	for i=0 to objDict.Count - 1 
		if suggestAllContent then
			response.write Replace(Left(allItems(i),50),searchFor,"<b>" & searchFor & "</b>",1,1,1) & vbLf
		else
			response.write Left(allItems(i),50) & vbLf
		end if
	next
else
	for i=0 to 9 
		if suggestAllContent then
			response.write Replace(Left(allItems(i),50),searchFor,"<b>" & searchFor & "</b>",1,1,1) & vbLf
		else
			response.write Left(allItems(i),50) & vbLf
		end if
	next
end if
%>