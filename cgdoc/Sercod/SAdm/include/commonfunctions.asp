<%
'////////////////////////////////////////////////////////////////////////////////
'// table and field info functions
'////////////////////////////////////////////////////////////////////////////////


function GetTableData(atable,key,default)
    dim table
	table=atable
	If atable = "" Then table = strTableName
	if not tables_data.Exists(table) then
		GetTableData = default
		exit function
	end if
	if not tables_data(table).Exists(key) then
		GetTableData = default
		exit function
	end if
	GetTableData = tables_data(table)(key)
end function

function GetFieldData(atable,field,key,default)
    dim table
	table=atable
	If atable = "" Then table = strTableName
	if not tables_data.Exists(table) then
		GetFieldData = default
		exit function
	end if
	if not tables_data(table).Exists(field) then
		GetFieldData = default
		exit function
	end if
	if not tables_data(table)(field).Exists(key) then
		GetFieldData = default
		exit function
	end if
	GetFieldData = tables_data(table)(field)(key)
end function

' return field label
Function Label(field, table)
	Label = GetFieldData(table,field,"Label",field)
end function

' return filename field if any
Function GetFilenameField(field, table)
	GetFilenameField = GetFieldData(table,field,"Filename","")
End Function

'     return hyperlink prefix
Function GetLinkPrefix(field, table)
	GetLinkPrefix = GetFieldData(table,field,"LinkPrefix","")
end function

'     return database field type
'     using ADO DataTypeEnum constants
'     the full list available at:
'     http://msdn.microsoft.com/library/default.asp?url=/library/en-us/ado270/htm/mdcstdatatypeenum.asp
Function GetFieldType(field, table)
	GetFieldType = GetFieldData(table,field,"FieldType","")
end function

'     return Edit format
Function GetEditFormat(field, table)
	GetEditFormat = GetFieldData(table,field,"EditFormat","")
end function

'     return View format
Function format(field, table)
	format = GetFieldData(table,field,"ViewFormat","")
end function

'     show time in datepicker or not
Function DateEditShowTime(field, table)
	DateEditShowTime = GetFieldData(table,field,"ShowTime",false)
end function

'	use FastType Lookup wizard or not
Function FastType(field, table)
	FastType = GetFieldData(table,field,"FastType",false)
end function

'     return field name
Function GetFieldByGoodFieldName(field, atable)
    dim table
	table=atable
	If atable = "" Then table = strTableName
	if not tables_data.Exists(table) then
		GetFieldByGoodFieldName = ""
		exit function
	end if

	for each f in tables_data(table)
		if VarType(tables_data(table)(f)) = 9 then
			if tables_data(table)(f)("GoodName")=field then
				GetFieldByGoodFieldName = f
				exit function
			end if 
		end if
	next
	GetFieldByGoodFieldName = ""
end function

'     return the full database field original name
Function GetFullFieldName(field, table)
	GetFullFieldName = GetFieldData(table,field,"FullName",field)
end function

'     return height of text area
Function GetNRows(field, table)
	GetNRows = GetFieldData(table,field,"nRows",field)
end function

'     return width of text area
Function GetNCols(field, table)
	GetNCols = GetFieldData(table,field,"nCols",field)
end function

'     return number of chars to show before More... link
Function GetNumberOfChars(table)
	GetNumberOfChars = GetTableData(table,".NumberOfChars",0)
end function

'     return table short name
Function GetTableURL(atable)
	dim table
	table=atable
	If atable = "" Then table = strTableName

        If "Cadastro" = table Then
                GetTableURL = "Cadastro"
                Exit Function
        End If
        If "Impr_recibo" = table Then
                GetTableURL = "Impr_recibo"
                Exit Function
        End If
        If "Moviment" = table Then
                GetTableURL = "Moviment"
                Exit Function
        End If
        If "Tramitacao" = table Then
                GetTableURL = "Tramitacao"
                Exit Function
        End If
        If "Moviment2" = table Then
                GetTableURL = "Moviment2"
                Exit Function
        End If
        If "moviment_sec" = table Then
                GetTableURL = "moviment_sec"
                Exit Function
        End If
        If "Usuários" = table Then
                GetTableURL = "Usu_rios"
                Exit Function
        End If
        If "_AudMoviment" = table Then
                GetTableURL = "_AudMoviment"
                Exit Function
        End If
        If "moviment_sec2" = table Then
                GetTableURL = "moviment_sec2"
                Exit Function
        End If
End Function

'     return table Owner ID field
Function GetTableOwnerID()
	GetTableOwnerID = GetTableData(strTableName,".OwnerID","")
end function

'     is field marked as required
Function IsRequired(field, table)
	IsRequired = GetFieldData(table,field,"IsRequired",false)
end function

'     use Rich Text Editor or not
Function UseRTE(field, table)
	UseRTE = GetFieldData(table,field,"UseRTE",false)
end function


'     add timestamp to filename when uploading files or not
Function UseTimestamp(field, table)
	UseTimestamp = GetFieldData(table,field,"UseTimestamp",false)
end function

Function GetUploadFolder(field, table)
	Dim path
	path = GetFieldData(table,field,"UploadFolder","")
	If Len(path) > 0 then
		if Mid(path, Len(path) - 1) <> "/" Then path = path & "/"
	end if
	GetUploadFolder = path
End Function

Function GetFieldIndex(field, table)
	GetFieldIndex = GetFieldData(table,field,"Index",0)
End Function

'     return Date field edit type
Function DateEditType(field, table)
	DateEditType=GetFieldData(table,field,"DateEditType",0)
end function

' returns text edit parameters
Function GetEditParams(field, table)
	GetEditParams=GetFieldData(table,field,"EditParams","")
end function

'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//
'// data output functions
'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//

'     format field value for output
Function GetData(data, field, fformat)
	
        Dim ret, numbers, l, fso, link, title, iquery, thumbnailed,thumbprefix
        Dim arr(6)
        Set fso = CreateObject("Scripting.FileSystemObject")
        ret = ""
' long binary data?
        If IsBinaryType(GetFieldType(field,"")) Then
                GetData="Dados Binários longos demais, Não pode ser exibido"
                Exit Function
        Else
			if GetFieldType(field,"") <> 205 then
				if GetFieldType(field,"")=19 then
					ret = CLng(data(field))
				else
					ret = data(field) 
				end if
			end if
        End If
		If isnull(ret) Then
                GetData = ""
                Exit Function
        End If
		if vartype(ret)=11 then
			if ret=false then
                GetData = ""
                Exit Function
			end if
        End If
        
        If fformat = FORMAT_DATE_SHORT Then
                ret = format_shortdate(db2time(data(field)))
        Elseif fformat = FORMAT_DATE_LONG Then
			ret = format_longdate(db2time(data(field)))
		ElseIf fformat = FORMAT_DATE_TIME Then
			ret = format_datetime(db2time(data(field)))
		ElseIf fformat = FORMAT_TIME Then
			If IsDateFieldType(GetFieldType(field,"")) Then
				ret = fformat_time(db2time(data(field)))
			Else
				numbers = parsenumbers(data(field))
				If UBound(numbers) = 0 Then
					GetData = ""
					Exit Function
				End If
				l = UBound(numbers)
				While l < 3
					ReDim Preserve numbers(l + 1)
					numbers(l) = 0
					l=l+1
				Wend
				arr(0) = 0
				arr(1) = 0
				arr(2) = 0
				arr(3) = numbers(0)
				arr(4) = numbers(1)
				arr(5) = numbers(2)
				ret = fformat_time(arr)
			End If
		ElseIf fformat = FORMAT_NUMBER Then
			ret = FormatNumber(CDbl(data(field)))
		ElseIf fformat = FORMAT_CURRENCY Then
			ret = FormatCurrency(CDbl(data(field)))
		ElseIf fformat = FORMAT_CHECKBOX Then
			If CStr(data(field)) <> "" And CStr(data(field)) <> "0" Then
				l = "yes"
			Else
				l = "no"
			End If
			ret = "<img src=""images/check_" & l & ".gif"" border=0>"
		ElseIf fformat = FORMAT_PERCENT Then
			ret=""
			if isNumeric(data(field)) or vartype(data(field))=14 then ret = (CDBL(data(field)) * 100) & "%"	
		ElseIf fformat = FORMAT_PHONE_NUMBER Then
			If Len(ret) = 7 Then
				ret = Mid(ret, 1, 3) & "-" & Mid(ret, 4)
			Else
				If Len(ret) = 10 Then ret = "(" & Mid(ret, 1, 3) & ") " & Mid(ret, 4, 3) & "-" & mid(ret, 7)
			End If
		ElseIf fformat = FORMAT_FILE_IMAGE Then
			If not CheckImageExtension(ret) Then
				GetData = ""
				Exit Function
			End If
			thumbnailed=false
			thumbprefix=""
			if thumbnailed then
		 ' show thumbnail
				thumbname = thumbprefix & ret
				if mid(GetLinkPrefix(field,""),1,7)<>"http://" then
					if not fso.FileExists(server.MapPath(AddLinkPrefix(field,thumbname,""))) then _
						thumbname = ret
				end if
				ret="<a target=_blank href=""" & my_htmlspecialchars(AddLinkPrefix(field,ret,""))& """>"
				ret= ret & "<img border=0"
				ret=ret & " src=""" & my_htmlspecialchars(AddLinkPrefix(field,thumbname,"")) & """></a>"
			else
				ret = "<img src=""" & AddLinkPrefix(field, ret,"") & """ border=0>"
			end if
		ElseIf fformat = FORMAT_HYPERLINK Then
			ret = GetHyperlink(ret, field, data, strTableName)
		ElseIf fformat = FORMAT_EMAILHYPERLINK Then
			link = ret
			title = ret
			If Mid(ret, 1, 7) = "mailto:" Then
				title = Mid(ret, 8)
			Else
				link = "mailto:" & link
			End If
			ret = "<a href=""" & link & """>" & title & "</a>"
		ElseIf fformat = FORMAT_FILE Then
			iquery = "field=" & server.URLEncode(field)
			If strTableName = "Cadastro" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("NrProtoc")))
			End If
			If strTableName = "Impr_recibo" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("NrProtoc")))
				iquery = iquery & "&key2=" & server.URLEncode(dbvalue(data("DtMovim")))
			End If
			If strTableName = "Moviment" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("CodMov")))
				iquery = iquery & "&key2=" & server.URLEncode(dbvalue(data("NrProtoc")))
			End If
			If strTableName = "Tramitacao" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("NrProtoc")))
			End If
			If strTableName = "Moviment2" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("CodMov")))
				iquery = iquery & "&key2=" & server.URLEncode(dbvalue(data("NrProtoc")))
			End If
			If strTableName = "moviment_sec" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("CodMov")))
				iquery = iquery & "&key2=" & server.URLEncode(dbvalue(data("NrProtoc")))
			End If
			If strTableName = "Usuários" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("NúmeroDoUsuário")))
			End If
			If strTableName = "_AudMoviment" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("ID")))
			End If
			If strTableName = "moviment_sec2" Then
				iquery = iquery & "&key1=" & server.URLEncode(dbvalue(data("CodMov")))
				iquery = iquery & "&key2=" & server.URLEncode(dbvalue(data("NrProtoc")))
			End If
			GetData = "<a href=""" & GetTableURL(strTableName) & "_download.asp?" & iquery & """.>" & ret & "</a>"
			Exit Function
		ElseIf GetEditFormat(field,"") = EDIT_FORMAT_CHECKBOX And fformat = FORMAT_NONE Then
			If ret <> "" And ret <> 0 Then
				ret="Sim"
			Else
				ret="Não"
			End If
		ElseIf fformat = FORMAT_CUSTOM Then 
			ret = CustomExpression(data, field, strTableName)
		End If
        GetData = ret
End Function

'     return custom expression
Function CustomExpression(data, field, table)
        If table = "" Then table = strTableName
        strValue = data(field)
        CustomExpression = strValue
End Function

Function my_htmlspecialchars(str)
        Dim ret
        if IsArray(str) then 
			ret = str(0)
        else
			ret=str
		end if	
        if len(ret)>0 then
			ret = Replace(ret, "&", "&amp;")
			ret = Replace(ret, """", "&quot;")
			ret = Replace(ret, "'", "&#039;")
			ret = Replace(ret, "<", "&lt;")
			ret = Replace(ret, ">", "&gt;")
		end if
        my_htmlspecialchars = ret
End Function

Function ProcessLargeText(strValue, iquery, table, mode)
	Dim cNumberOfChars, ret, ind
	If mode = "" Then mode = MODE_LIST

	cNumberOfChars = GetNumberOfChars(table)
	If Mid(strValue, 1, 8) = "<a href=" Then
		ProcessLargeText = strValue
		Exit Function
	End If
	If Mid(strValue, 1, 23) = "<img src=""images/check_" Then
		ProcessLargeText = strValue
		Exit Function
	End If
	If cNumberOfChars > 0 And Len(strValue) > cNumberOfChars And (Len(strValue) < 200 Or Len(iquery)=0) And mode = MODE_LIST Then
		ret = Mid(strValue, 1, cNumberOfChars)
		ret = my_htmlspecialchars(ret)
		ret = ret & " <a href=""#"" onClick=""javascript: pwin = window.open('',null,'height=300,width=400,status=yes,resizable=yes,toolbar=no,menubar=no,location=no,left=150,top=200,scrollbars=yes');" 
		ind = 1
		ret = ret & "pwin.document.write('" & my_htmlspecialchars(jsreplace(Replace(Mid(strValue, 1, 801), vbcrlf, "<br>"))) & "');" 
		ret=ret & "pwin.document.write('<br><hr size=1 noshade><a href=# onClick=\'window.close();return false;\'>" & "Fechar Janela" & "</a>');" 
		ret=ret & "return false;"">" & "Mais" & " ...</a>"
	Elseif cNumberOfChars > 0 And Len(strValue) > cNumberOfChars And mode = MODE_LIST Then
		table = GetTableURL(table)
		ret = Mid(strValue, 1, cNumberOfChars)
		ret = my_htmlspecialchars(ret)
		ret = ret & " <a href=#  onClick=""javascript: pwin = window.open('',null,'height=300,width=400,status=yes,resizable=yes,toolbar=no,menubar=no,location=no,left=150,top=200,scrollbars=yes');" 
		ret=ret & " pwin.location='" & table & "_fulltext.asp?" & iquery & "'; return false;"">" & "Mais" & " ...</a>" 
	Elseif cNumberOfChars > 0 And Len(strValue) > cNumberOfChars And mode = MODE_PRINT Then
		ret = Mid(strValue, 1, cNumberOfChars)
		If Len(strValue) > cNumberOfChars Then ret = ret & " ..."
	Else
		ret = my_htmlspecialchars(strValue)
	End If
	if not isnull(ret) then _
		ret = replace(ret,vbcrlf,"<br>")
	ProcessLargeText = ret
End Function

'     construct hyperlink
Function GetHyperlink(str, field, data, table)
        Dim ret, title, link, i, target, ttype
        If Len(table) = 0 Then table = strTableName
        If Len(str) = 0 Then
                GetHyperlink = ""
                Exit Function
        End If
        ret = str
        title = ret
        link = ret
        If Mid(ret, Len(ret)) = "#" Then
                i = InStr(1, ret, "#")
				if i<Len(ret) then
	                title = Mid(ret, 1, i - 1)
    	            link = Mid(ret, i + 1, Len(ret) - i - 1)
        	        If title = "" Then title = link
				end if
        End If
        target = ""
        
        If InStr(1, link, "://") = 0 And Mid(link, 1, 7) <> "mailto:" Then link = prefix & link
        ret = "<a href=""" & link & """" & target & ">" & title & "</a>"
        GetHyperlink = ret
End Function

'     add prefix to the URL
Function AddLinkPrefix(field, link, table)
        If InStr(1, link, "://") = 0 And Mid(link, 1, 7) <> "mailto:" Then
                AddLinkPrefix = GetLinkPrefix(field, table) & link
                Exit Function
        End If
                AddLinkPrefix = link
End Function

'     return Totals string
Function GetTotals(field,value, stype, iNumberOfRows, sFormat)
        If stype = "AVERAGE" Then
                If iNumberOfRows <> 0 Then
                        value = round(value / iNumberOfRows,2)
                Else
                        GetTotals = ""
                        Exit Function
                End If
        End If
		dim sValue
		sValue=""
        If sFormat = FORMAT_CURRENCY Then
            sValue = fformat_currency(value)
        ElseIf sFormat = FORMAT_NUMBER Then 
			sValue = fformat_number(value)
		ElseIf sFormat = FORMAT_PERCENT Then 	
			sValue = fformat_number(value*100) & "%"	
		ElseIf sFormat = FORMAT_CUSTOM Then 	
			set tarr=CreateObject("Scripting.Dictionary")
			tarr(field)=value
			sValue = GetData(tarr,field,sFormat)
        ElseIf sFormat = FORMAT_NONE Then 
			sValue = value
        End If

        If stype = "COUNT" Then
                GetTotals = value
                Exit Function
        End If
        If stype = "TOTAL" Then
                GetTotals = sValue
                Exit Function
        End If
        If stype = "AVERAGE" Then
                GetTotals = sValue
                Exit Function
        End If
        GetTotals = ""
End Function


'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//
'// miscellaneous functions
'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//


'     return POST or GET value - single value or array

Function postvalue(name) '???
	dim value, i
	dim ret
	if parse<>1 then
		if request.form(name)<>"" then
			value=request.form(name)
			if request.form(name).Count=0 then 
	            postvalue = ""
	            exit function
			end if
			if request.form(name).Count=1 then 
				postvalue = value
				exit function
			end if
			redim ret(request.form(name).Count-1)
			for i=1 to request.form(name).Count
				ret(i-1)=request.form(name).Item(i)
			next
		elseif request.querystring(name)<>"" then
			value=request.querystring(name)
			if request.querystring(name).Count=0 then 
	            postvalue = ""
	            exit function
			end if
			if request.querystring(name).Count=1 then 
				postvalue = value
				exit function
			end if
			redim ret(request.querystring(name).Count-1)
			for i=1 to request.querystring(name).Count
				ret(i-1)=request.querystring(name).Item(i)
			next
		else
            postvalue = ""
            exit function
		end if
        postvalue = ret
        exit function
    else
		if getRequestForm(name & "[]")<>"" then
			name= name & "[]"
			postvalue=getRequestForm(name)
		else
			postvalue=getRequestForm(name)
            exit function
		end if
    end if
       
End Function

'     analog of strrpos function
Function my_strrpos(haystack, needle)
   Dim index
   index = InStrRev(haystack, needle)
   If index = 0 Then
       my_strrpos = False
       Exit Function
   End If
   index = Len(haystack) - Len(needle) - index
   my_strrpos = index
End Function

'     utf-8 analog of strlen function
Function strlen_utf8(str)
        Dim vlen, i, olen, c
        vlen = 0
        i = 0
        olen = Len(str)
        While i < olen
                c = Asc(Mid(str, i + 1, 1))
                If c < 128 Then
                        i = i + 1
                Else
                        If i < olen - 1 And c >= 192 And c <= 223 Then
                                i = i + 2
                        Else
                                If i < olen - 2 And c >= 224 And c <= 239 Then
                                        i = i + 3
                                Else
                                        If i < olen - 3 And c >= 240 Then
                                                i = i + 4
                                        Else
                                                i = olen + 1
                                        End If
                                End If
                        End If
                End If
                vlen = vlen + 1
        Wend
        strlen_utf8 = vlen
End Function

'     utf-8 analog of substr function
Function substr_utf8(str, index, strlen)
        Dim vlen, olen, oindex, c, i
        If strlen <= 0 Then
                substr_utf8 = ""
                Exit Function
        End If
        vlen = 0
        i = 0
        olen = Len(str)
        oindex = -1
        While i < olen
                If vlen = index Then oindex = i
                
                c = Asc(Mid(str, i + 1, 1))
                If c < 128 Then
                        i = i + 1
                Else
                        If i < olen - 1 And c >= 192 And c <= 223 Then
                                i = i + 2
                        Else
                                If i < olen - 2 And c >= 224 And c <= 239 Then
                                        i = i + 3
                                Else
                                        If i < olen - 3 And c >= 240 Then
                                                i = i + 4
                                        Else
                                                c = 200
                                        End If
                                End If
                        End If
                End If
                vlen = vlen + 1
                If oindex >= 0 And vlen = index + strlen Then
                        substr_utf8 = Mid(str, oindex + 1, i - oindex)
                        Exit Function
                End If
        Wend
        If oindex > 0 Then substr_utf8 = Mid(str, oindex + 1, olen - oindex)
        substr_utf8 = ""
End Function

'     read the whole file and return contents
Function myfile_get_contents(filename)
        Dim fso, handle, contents, fsize, f
        Set fso = CreateObject("Scripting.FileSystemObject")
        If Not fso.FileExists(filename) Then
                myfile_get_contents = False
                Exit Function
        End If
        f = fso.GetFile(filename)
        fsize = f.Size
        handle = fso.OpenTextFile(filename, 1, True)
        If handle Is Nothing Then
                myfile_get_contents = False
                Exit Function
        End If
        If fsize > 0 Then
                contents = fso.read(fsize)
        Else
                contents = ""
        End If
        fso.Close
        myfile_get_contents = contents
End Function

'     construct "good" field name
Function GoodFieldName(field)
        Dim i, t, ffield
        ffield=field
        For i = 0 To Len(ffield) - 1
                t = Asc(Mid(ffield, i + 1, 1))
                If (t < Asc("a") Or t > Asc("z")) And (t < Asc("A") Or t > Asc("Z")) And (t < Asc("0") Or t > Asc("9")) Then
                        If i > 0 Then
                                ffield = Left(ffield, i) & "_" & Mid(ffield, i + 2)
                        Else
                                ffield = "_" & Mid(ffield, i + 2)
                        End If
                End If
        Next
        GoodFieldName = ffield
End Function


Function LogInfo(sql)
        dSQL = sql
        If dDebug Then response.Write dSQL & "<br>"
End Function

'     suggest image type by extension
Function SupposeImageType(file)
	If LenB(file) > 1 And MidB(file, 1, 2) = chrb(asc("B")) & chrb(asc("M"))  Then
    	SupposeImageType = "image/bmp"
		Exit Function
	End If
	If LenB(file) > 2 And MidB(file, 1, 3) = chrb(asc("G")) & chrb(asc("I"))& chrb(asc("F"))  Then
		SupposeImageType = "image/gif"
		Exit Function
    End If
	if LenB(file) > 3 and  MidB(file, 1, 3) = chrb(&Hff) & chrb(&Hd8) & chrb(&Hff) then
		SupposeImageType = "image/jpeg"
		Exit Function
    End If
	if LenB(file) > 8 and MidB(file, 1, 8) = chrb(&H89) & chrb(&H50) & chrb(&H4e) & chrb(&H47) _
											& chrb(&H0d) & chrb(&H0a) & chrb(&H1a) & chrb(&H0a)  then
		SupposeImageType = "image/png"
		Exit Function
    End If
    SupposeImageType=""
End Function

'     check if file extension is image extension
Function CheckImageExtension(filename)
        Dim ext
        If Len(filename) < 4 or isnull(filename) Then
                CheckImageExtension = false
                Exit Function
        End If
        ext = UCase(right(filename,4))
        If ext = ".GIF" Or ext = ".JPG" Or ext = "JPEG" Or ext = ".PNG" Or ext = ".BMP" Then
                CheckImageExtension = True
                Exit Function
        End If
        CheckImageExtension = False
End Function


Function RTESafe(strText)
        Dim tmpString
'     returns safe code for preloading in the RTE
        tmpString = ""
        
        tmpString = Trim(strText)
        If tmpString = "" Then RTESafe = ""
        
'     convert all types of single quotes
        tmpString = Replace(tmpString, Chr(145), Chr(39))
        tmpString = Replace(tmpString, Chr(146), Chr(39))
        tmpString = Replace(tmpString, "'", "&#39;")
        
'     convert all types of double quotes
        tmpString = Replace(tmpString, Chr(147), Chr(34))
        tmpString = Replace(tmpString, Chr(148), Chr(34))
        
'     replace carriage returns & line feeds
        tmpString = Replace(tmpString, Chr(10), " ")
        tmpString = Replace(tmpString, Chr(13), " ")
        
        RTESafe = tmpString
End Function


Function tnow()
        tnow = Year(Now) & "-" & Month(Now) & "-" & Day(Now) & " " & Hour(Time) & ":" & Minute(Time) & ":" & Second(Now)
End Function

Function html_special_decode(str)
        Dim ret
        ret = str
        ret = Replace(ret, "&", "&amp;")
        ret = Replace(ret, """", "&quot;")
        ret = Replace(ret, "'", "&#039;")
        ret = Replace(ret, "<", "&lt;")
        ret = Replace(ret, ">", "&gt;")
        html_special_decode = ret
End Function

''//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//
'// database and SQL related functions
'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//'//

'     add WHERE clause to SQL string
Function AddWhere(strSQL, sWhere)
	if sWhere="" or InStr(strSQL, sWhere)>0 then 
		AddWhere = strSQL
		Exit Function
	end if
	n = InStrRev(LCase(strSQL), " where ")
	n1 = InStrRev(LCase(strSQL), " group by ")
	if n1=0 then n1=len(strSQL)

	if n > 0 then 
		AddWhere = Left(strSQL, n-1+Len(" where ")) & "(" & Mid(strSQL, n+Len(" where ")) & ") and (" & sWhere & ") "
	else
		AddWhere = Left(strSQL,n1) & " where (" & sWhere & ") " & Mid(strSQL,n1+1)
	end if
		
End Function

'     construct WHERE clause with key values
Function KeyWhere(keys(), table)
        Dim StrWhere, value
        If table = "" Then table = strTableName
        StrWhere = ""

'     Cadastro
        If table = "Cadastro" Then
                        value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
        End If

'     Impr_recibo
        If table = "Impr_recibo" Then
                        value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
                        StrWhere = StrWhere & " and "
                value = make_db_value("DtMovim", keys("DtMovim"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("DtMovim","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("DtMovim","") & "=" & make_db_value("DtMovim", keys("DtMovim"),"","")
                End If
        End If

'     Moviment
        If table = "Moviment" Then
                        value = make_db_value("CodMov", keys("CodMov"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & "=" & make_db_value("CodMov", keys("CodMov"),"","")
                End If
                        StrWhere = StrWhere & " and "
                value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
        End If

'     Tramitacao
        If table = "Tramitacao" Then
                        value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
        End If

'     Moviment2
        If table = "Moviment2" Then
                        value = make_db_value("CodMov", keys("CodMov"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & "=" & make_db_value("CodMov", keys("CodMov"),"","")
                End If
                        StrWhere = StrWhere & " and "
                value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
        End If

'     moviment_sec
        If table = "moviment_sec" Then
                        value = make_db_value("CodMov", keys("CodMov"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & "=" & make_db_value("CodMov", keys("CodMov"),"","")
                End If
                        StrWhere = StrWhere & " and "
                value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
        End If

'     Usuários
        If table = "Usuários" Then
                        value = make_db_value("NúmeroDoUsuário", keys("NúmeroDoUsuário"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NúmeroDoUsuário","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NúmeroDoUsuário","") & "=" & make_db_value("NúmeroDoUsuário", keys("NúmeroDoUsuário"),"","")
                End If
        End If

'     _AudMoviment
        If table = "_AudMoviment" Then
                        value = make_db_value("ID", keys("ID"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("ID","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("ID","") & "=" & make_db_value("ID", keys("ID"),"","")
                End If
        End If

'     moviment_sec2
        If table = "moviment_sec2" Then
                        value = make_db_value("CodMov", keys("CodMov"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("CodMov","") & "=" & make_db_value("CodMov", keys("CodMov"),"","")
                End If
                        StrWhere = StrWhere & " and "
                value = make_db_value("NrProtoc", keys("NrProtoc"),"","")
                If IsNull(value) Then
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & " is null"
                Else
                        StrWhere = StrWhere & GetFullFieldName("NrProtoc","") & "=" & make_db_value("NrProtoc", keys("NrProtoc"),"","")
                End If
        End If
        KeyWhere = StrWhere
End Function

'     consctruct SQL WHERE clause for simple search
Function StrWhere(strField, SearchFor, strSearchOption, SearchFor2)
        Dim ttype, strQuote, sSearchFor, sSearchFor2, ttime, ret
        ttype = GetFieldType(strField,"")
        If strSearchOption = "Empty" Then
                If IsCharType(ttype) Then
                        StrWhere = "(" & GetFullFieldName(strField,"") & " is null or " & GetFullFieldName(strField,"") & "='')"
                        Exit Function
                Else
                        StrWhere = GetFullFieldName(strField,"") & " is null"
                        Exit Function
                End If
        End If
        strQuote = ""
        If NeedQuotes(ttype) Then strQuote = "'"
'     return none if trying to compare numeric field and string value
        sSearchFor = SearchFor
        sSearchFor2 = SearchFor2
        If IsBinaryType(ttype) or ttype=13 Then
			StrWhere = ""
			Exit Function
        End If
        If IsDateFieldType(ttype) And strSearchOption <> "Contains" And strSearchOption <> "Starts with ..." Then
                ttime = localdatetime2db(SearchFor,"")
                If IsNull(ttime) Then
                        StrWhere = ""
                        Exit Function
                End If
                sSearchFor = db_datequotes(ttime)
                If strSearchOption = "Between" Then
                        ttime = localdatetime2db(SearchFor2,"")
                        If IsNull(Time) Then
                                sSearchFor2 = ""
                        Else
                                sSearchFor2 = db_datequotes(ttime)
                        End If
                End If
        End If
        
        If strQuote = "" And Not IsNumeric(sSearchFor) And Not IsNumeric(sSearchFor) Then
            StrWhere = ""
            Exit Function
        Elseif strQuote = "" And strSearchOption <> "Contains" And strSearchOption <> "Starts with ..." Then
			sSearchFor = my_numeric(sSearchFor)
            sSearchFor2 = my_numeric(sSearchFor2)
		Elseif Not IsDateFieldType(ttype) And strSearchOption <> "Contains" And strSearchOption <> "Starts with ..." Then
				If IsTextType(ttype) Then
				sSearchFor = "N" & strQuote & db_addslashes(sSearchFor) & strQuote
				If strSearchOption = "Between" And sSearchFor2<>"" Then sSearchFor2 = "N" & strQuote & db_addslashes(sSearchFor2) & strQuote
            Else
					sSearchFor = db_upper("N" & strQuote & db_addslashes(sSearchFor) & strQuote)
	                If strSearchOption = "Between" And sSearchFor2<>"" Then sSearchFor2 = db_upper("N" & strQuote & db_addslashes(sSearchFor2) & strQuote)
    		End If
		Elseif Not IsDateFieldType(ttype) or strSearchOption="Contains" or strSearchOption="Starts with ..." Then 
			sSearchFor = db_addslashes(sSearchFor)
		End If
                                        
	if IsCharType(ttype)  and not IsTextType(ttype)  then
		strField=db_upper(GetFullFieldName(strField,""))
	else
		strField=GetFullFieldName(strField,"")
	end if

        ret = ""
        If strSearchOption = "Contains" Then
                if IsCharType(ttype)  and not IsTextType(ttype)  then
                        StrWhere = strField & " like " & db_upper("'%" & sSearchFor & "%'")
                        Exit Function
                Else
                        StrWhere = strField & " like '%" & sSearchFor & "%'"
                        Exit Function
                End If
        Elseif strSearchOption = "Equals" Then
			StrWhere = strField & "=" & sSearchFor
			Exit Function
        ElseIf strSearchOption = "Starts with ..." Then
			if IsCharType(ttype)  and not IsTextType(ttype)  then
            	StrWhere = strField & " like " & db_upper("'" & sSearchFor & "%'")
			Else
            	StrWhere = strField & " like '" & sSearchFor & "%'"
			End If
            exit function
		Elseif strSearchOption = "More than ..." Then
			StrWhere = strField & ">" & sSearchFor
            Exit Function
        Elseif strSearchOption = "Less than ..." Then
			StrWhere = strField & "<" & sSearchFor
            Exit Function
		Elseif strSearchOption = "Equal or more than ..." Then
			StrWhere = strField & ">=" & sSearchFor
			Exit Function
		Elseif strSearchOption = "Equal or less than ..." Then
			StrWhere = strField & "<=" & sSearchFor
			Exit Function
		Elseif strSearchOption = "Between" Then
			ret = strField & ">=" & sSearchFor
			If sSearchFor2 <> "" Then ret = ret & " and " & strField & "<=" & sSearchFor2
			StrWhere = ret
			Exit Function
		End If
        StrWhere = ""
End Function

'     construct SQL WHERE clause for Advanced search
Function StrWhereAdv(strField, SearchFor, strSearchOption, SearchFor2, etype)
        Dim ttype, ret, value, aSearchFor, i
        ttype = GetFieldType(strField,"")
        If IsBinaryType(ttype) Then
                StrWhereAdv = ""
                Exit Function
        End If
        If strSearchOption = "Empty" Then
                If IsCharType(ttype) Then
                        StrWhereAdv = "(" & GetFullFieldName(strField,"") & " is null or " & GetFullFieldName(strField,"") & "='')"
                        Exit Function
                Else
                        StrWhereAdv = GetFullFieldName(strField,"") & " is null"
                        Exit Function
                End If
        End If
        If GetEditFormat(strField,"") = EDIT_FORMAT_LOOKUP_WIZARD Then
                aSearchFor = splitvalues(SearchFor)
                ret = ""
                For i = 0 To UBound(aSearchFor) - 1
                        If Not (aSearchFor(i) = "null" Or aSearchFor(i) = "Null" Or aSearchFor(i) = "") Then
                                If Len(ret) <> 0 Then ret = ret & " or "
                                If strSearchOption = "Equals" Then
                                        aSearchFor(i) = make_db_value(strField, aSearchFor(i),"","")
                                        If Not (aSearchFor(i) = "null" Or aSearchFor(i) = "Null") Then ret = ret & GetFullFieldName(strField,"") & "=" & aSearchFor(i)
                                Else
                                        ret = ret & GetFullFieldName(strField,"") & " like '%" & aSearchFor(i) & "%'"
                                End If
                        End If
                Next
                If Len(ret) <> 0 Then ret = "(" & ret & ")"
                StrWhereAdv = ret
				exit function
        End If
        value1 = make_db_value(strField, SearchFor, etype,"")
        value2 = False
        If strSearchOption = "Between" Then value2 = make_db_value(strField, SearchFor2, etype,"")
        If strSearchOption <> "Contains" And strSearchOption <> "Starts with ..." And (IsNull(value1) Or IsNull(value2) or value1="null" or value2="null") Then
                StrWhereAdv = ""
                Exit Function
        End If

        if ischartype(ttype)  and not IsTextType(ttype)  then
                value1 = db_upper(value1)
                value2 = db_upper(value2)
                strField = db_upper(GetFullFieldName(strField,""))
	else
		strField=GetFullFieldName(strField,"")
	end if
	ret = ""
	If strSearchOption = "Contains" Then
		if ischartype(ttype)  and  not IsTextType(ttype)  then
			StrWhereAdv = strField & " like " & db_upper("'%" & db_addslashes(SearchFor) & "%'")
			Exit Function
		Else
			StrWhereAdv = strField & " like '%" & db_addslashes(SearchFor) & "%'"
			Exit Function
		End If
	ElseIf strSearchOption = "Equals" Then
		StrWhereAdv = strField & "=" & value1
		Exit Function
	ElseIf strSearchOption = "Starts with ..." Then
		if ischartype(ttype)  and  not IsTextType(ttype)  then
			StrWhereAdv = strField & " like " & db_upper("'" & db_addslashes(SearchFor) & "%'")
			Exit Function
		Else
			StrWhereAdv = strField & " like '" & db_addslashes(SearchFor) & "%'"
			Exit Function
		End If
	ElseIf strSearchOption = "More than ..." Then
		StrWhereAdv = strField & ">" & value1
		Exit Function
	ElseIf strSearchOption = "Less than ..." Then
		StrWhereAdv = strField & "<" & value1
		Exit Function
	ElseIf strSearchOption = "Equal or more than ..." Then
		StrWhereAdv = strField & ">=" & value1
		Exit Function
	ElseIf strSearchOption = "Equal or less than ..." Then
		StrWhereAdv = strField & "<=" & value1
		exit function
	ElseIf strSearchOption = "Between" Then
		ret = strField & ">=" & value1
		ret = ret & " and " & strField & "<=" & value2
		StrWhereAdv = ret
		Exit Function
	End If
	StrWhereAdv = ""
End Function

'     get count of rows from the query
Function GetRowCount(strSQL)
	strSQL=replace(strSQL,vbcrlf," ")
	strSQL=replace(strSQL,vblf," ")
	tstr = ucase(strSQL)
	ind1 = instr(tstr,"SELECT ")
	ind2 = instr(tstr," FROM ")
	ind3 = instr(tstr," GROUP BY ")
	if ind3=0 then
		ind3 = instr(tstr," ORDER BY ")
		if ind3=0 then ind3=len(strSQL)
	end if
	countstr=mid(strSQL,1,ind1+6) & " count(*) " & mid(strSQL,ind2+1,ind3-ind2)
	Set rc = server.CreateObject("ADODB.Recordset")
	rc.Open countstr,dbConnection
	cc=rc(0)
	rc.Close
	GetRowCount=CLng(cc)
End Function

'     add MSSQL Server TOP clause
Function AddTop(strSQL, n)
        Dim tstr, ind1
        tstr = UCase(strSQL)
        ind1 = InStr(tstr, "SELECT")
        AddTop = Mid(strSQL, 1, ind1 + 6) & " top " & n & Mid(strSQL, ind1 + 6)
End Function

'     add Oracle ROWNUMBER checking
Function AddRowNumber(strSQL, n)
        AddRowNumber = "select * from (" & strSQL & ") where rownum<" & (n + 1)
End Function

' test database type if values need to be quoted
Function NeedQuotesNumeric(ttype)
    If ttype = 203 Or ttype = 8 Or ttype = 129 Or ttype = 130 Or _
                ttype = 7 Or ttype = 133 Or ttype = 134 Or ttype = 135 Or _
                ttype = 201 Or ttype = 205 Or ttype = 200 Or ttype = 202 Or ttype = 72 Or ttype = 13 Then
                NeedQuotesNumeric = True
        Else
                NeedQuotesNumeric = False
        End If
End Function

'     using ADO DataTypeEnum constants
'     the full list available at:
'     http://msdn.microsoft.com/library/default.asp?url=/library/en-us/ado270/htm/mdcstdatatypeenum.asp

Function IsNumberType(ttype)
        If ttype = 20 Or ttype = 6 Or ttype = 14 Or ttype = 5 Or ttype = 10 _
        Or ttype = 3 Or ttype = 131 Or ttype = 4 Or ttype = 2 Or ttype = 16 _
        Or ttype = 21 Or ttype = 19 Or ttype = 18 Or ttype = 17 Or ttype = 139 or ttype=11 Then
                IsNumberType = True
                Exit Function
        End If
        IsNumberType = False
End Function

Function NeedQuotes(ttype)
        NeedQuotes = Not IsNumberType(ttype)
End Function

Function IsBinaryType(ttype)
        If ttype = 128 Or ttype = 205 Or ttype = 204 Then
                IsBinaryType = True
                Exit Function
        End If
        IsBinaryType = False
End Function

Function IsDateFieldType(ttype)
        If ttype = 7 Or ttype = 133 Or ttype = 135 Then
                IsDateFieldType = True
                Exit Function
        End If
        IsDateFieldType = False
End Function

Function IsCharType(ttype)
        If IsTextType(ttype) Or ttype = 8 Or ttype = 129 Or ttype = 200 Or ttype = 202 Or ttype = 130 Then
                IsCharType = True
                Exit Function
        End If
        IsCharType = False
End Function

Function IsTextType(ttype)
        If ttype = 201 Or ttype = 203 Then
                IsTextType = True
                Exit Function
        End If
        IsTextType = False
End Function



'      return user permissions on the table
'      A - Add
'      D - Delete
'      E - Edit
'      S - List/View/Search
'      P - Print/Export

function GetUserPermissions(table)
        if table="" then table=strTableName
        if SESSION("AccessLevel") = ACCESS_LEVEL_ADMIN then GetUserPermissions = "ADESP"
		dim sUserGroup
        sUserGroup=SESSION("GroupID")
        if table="Cadastro" and sUserGroup="adm" then
                    GetUserPermissions = "AS"
			exit function
		end if
        if table="Cadastro" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Cadastro" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Cadastro" and sUserGroup="cad" then
                    GetUserPermissions = "AS"
			exit function
		end if
        if table="Cadastro" and sUserGroup="cad sect" then
                    GetUserPermissions = "AS"
			exit function
		end if
        if table="Cadastro" and sUserGroup="vis" then
                    GetUserPermissions = "S"
			exit function
		end if
'      default permissions
        if table="Cadastro" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="Impr_recibo" and sUserGroup="adm" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Impr_recibo" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Impr_recibo" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Impr_recibo" and sUserGroup="cad" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Impr_recibo" and sUserGroup="cad sect" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Impr_recibo" and sUserGroup="vis" then
                    GetUserPermissions = "SP"
			exit function
		end if
'      default permissions
        if table="Impr_recibo" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="Moviment" and sUserGroup="adm" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Moviment" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Moviment" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Moviment" and sUserGroup="cad" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Moviment" and sUserGroup="cad sect" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Moviment" and sUserGroup="vis" then
                    GetUserPermissions = "SP"
			exit function
		end if
'      default permissions
        if table="Moviment" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="Tramitacao" and sUserGroup="adm" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Tramitacao" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Tramitacao" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Tramitacao" and sUserGroup="cad" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Tramitacao" and sUserGroup="cad sect" then
                    GetUserPermissions = "AS"
			exit function
		end if
        if table="Tramitacao" and sUserGroup="vis" then
                    GetUserPermissions = "S"
			exit function
		end if
'      default permissions
        if table="Tramitacao" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="Moviment2" and sUserGroup="adm" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Moviment2" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Moviment2" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Moviment2" and sUserGroup="cad" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Moviment2" and sUserGroup="cad sect" then
                    GetUserPermissions = "ASP"
			exit function
		end if
        if table="Moviment2" and sUserGroup="vis" then
                    GetUserPermissions = "SP"
			exit function
		end if
'      default permissions
        if table="Moviment2" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="moviment_sec" and sUserGroup="adm" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="moviment_sec" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="moviment_sec" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="moviment_sec" and sUserGroup="cad" then
                    GetUserPermissions = "AESP"
			exit function
		end if
        if table="moviment_sec" and sUserGroup="cad sect" then
                    GetUserPermissions = "AESP"
			exit function
		end if
        if table="moviment_sec" and sUserGroup="vis" then
                    GetUserPermissions = "SP"
			exit function
		end if
'      default permissions
        if table="moviment_sec" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="Usuários" and sUserGroup="adm" then
                    GetUserPermissions = "S"
			exit function
		end if
        if table="Usuários" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Usuários" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="Usuários" and sUserGroup="cad" then
                    GetUserPermissions = ""
			exit function
		end if
        if table="Usuários" and sUserGroup="cad sect" then
                    GetUserPermissions = ""
			exit function
		end if
        if table="Usuários" and sUserGroup="vis" then
                    GetUserPermissions = ""
			exit function
		end if
'      default permissions
        if table="Usuários" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="_AudMoviment" and sUserGroup="adm" then
                    GetUserPermissions = "S"
			exit function
		end if
        if table="_AudMoviment" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="_AudMoviment" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="_AudMoviment" and sUserGroup="cad" then
                    GetUserPermissions = ""
			exit function
		end if
        if table="_AudMoviment" and sUserGroup="cad sect" then
                    GetUserPermissions = "S"
			exit function
		end if
        if table="_AudMoviment" and sUserGroup="vis" then
                    GetUserPermissions = ""
			exit function
		end if
'      default permissions
        if table="_AudMoviment" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
        if table="moviment_sec2" and sUserGroup="adm" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="moviment_sec2" and sUserGroup="adm geral" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="moviment_sec2" and sUserGroup="adm sect" then
                    GetUserPermissions = "AEDSP"
			exit function
		end if
        if table="moviment_sec2" and sUserGroup="cad" then
                    GetUserPermissions = "AESP"
			exit function
		end if
        if table="moviment_sec2" and sUserGroup="cad sect" then
                    GetUserPermissions = "AESP"
			exit function
		end if
        if table="moviment_sec2" and sUserGroup="vis" then
                    GetUserPermissions = "SP"
			exit function
		end if
'      default permissions
        if table="moviment_sec2" then
            GetUserPermissions = ""              ' grant nothing by default
			exit function
		end if
end function


'      check whether field is viewable
function CheckFieldPermissions(field, table)
	CheckFieldPermissions = GetFieldData(table,field,"FieldPermissions",false)
end function

'
function CheckSecurity(strVal, strAction)
        if SESSION("AccessLevel")=ACCESS_LEVEL_ADMIN then
			CheckSecurity = true
            exit function
        end if
	dim strValue
	strValue=strVal
	if isnull(strValue) then
		strValue=""
	end if

        if strTableName="Usuários" then
                        if cstr(SESSION("OwnerID"))<>cstr(strValue) then
					CheckSecurity = false
                    exit function
                end if
                      
        end if
        '       check user group permissions
		dim strPerm
        strPerm = GetUserPermissions("")
        if strAction="Add" and instr(1,strPerm,"A")>0 or _
           strAction="Edit" and instr(1,strPerm, "E")>0 or _
           strAction="Delete" and instr(1,strPerm, "D")>0 or _
           strAction="Search" and instr(1,strPerm, "S")>0 or _
           strAction="Export" and instr(1,strPerm, "P")>0 then
                CheckSecurity = true
                exit function
        Else
                CheckSecurity = false
                exit function
        end if
        CheckSecurity = true
end function


'      add security WHERE clause to SELECT SQL command
function SecuritySQL(strAction)
	dim ownerid, ret, strPerm
        ownerid=SESSION("OwnerID")
        ret=""
        if SESSION("AccessLevel")=ACCESS_LEVEL_ADMIN then
                SecuritySQL = ""
                exit function
        end if
        ret=""

        if strTableName="Usuários" then
                        ret=GetFullFieldName(GetTableOwnerID(),"") & "=" & make_db_value(GetTableOwnerID(),ownerid,"","")
        end if


        strPerm = GetUserPermissions("")
        if strAction="Edit" and instr(strPerm, "E")>0 or _
           strAction="Delete" and instr(strPerm, "D")>0 or _
           strAction="Search" and instr(strPerm, "S")>0 or _
           strAction="Export" and instr(strPerm, "P")>0 then
                SecuritySQL = ret
        Else
                SecuritySQL = "1=0"
        end if
end function

'//////////////////////////////////////////////////////////////////////////////
'// editing functions
'////////////////////////////////////////////////////////////////////////////////

function make_db_value(field,value,controltype,postfilename)
        dim ret
        ret=prepare_for_db(field,value,controltype,postfilename)
        if vartype(ret)=11 then
			if ret=false then 
				make_db_value=ret
				exit function
			end if
		end if
        make_db_value=add_db_quotes(field,ret)
end function

function add_db_quotes(field,value)
		dim ttype, strvalue
        ttype=GetFieldType(field,"")
        if IsBinaryType(ttype) then
                add_db_quotes = db_addslashesbinary(value)
                exit function
        end if
	if IsNull(value) then
		add_db_quotes = "null"
		exit function
	end if

        if (CStr(value)="" or vartype(value)=11 and CStr(value)="False") and not ischartype(ttype) then
			add_db_quotes = "null"
			exit function
		end if
        if NeedQuotes(ttype) then
                if not IsDateFieldType(ttype) then
                        add_db_quotes="'" & db_addslashes(value) & "'"
                Else
                        add_db_quotes=db_datequotes(value)
                end if
        Else
                strvalue = cstr(value)
                strvalue = replace(strvalue,",",".")
                add_db_quotes=my_numeric(strvalue)
		end if

end function

function prepare_for_db(field,value,controltype,postfilename)
	dim ttype, ttime
	filename=""
	ttype=GetFieldType(field,"")
	if controltype="" then
		if isArray(value) then value=combinevalues(value)
		if (CStr(value)="" or vartype(value)=11 and CStr(value)="False") and not ischartype(ttype) then
			prepare_for_db = ""
			exit function
		end if
		prepare_for_db = value
		exit function
	elseif mid(controltype,1,4)="file" then 
		if (trim(value)="" or isnull(value)) and mid(controltype,1,5)<>"file1" then
			prepare_for_db=false
		else
			prepare_for_db=""
		end if
		if trim(postfilename)<>  "" then filename=trim(postfilename)
		exit function
	elseif mid(controltype,1,6)="upload" then
		if mid(controltype,6,1)="0" then 
			prepare_for_db = false
			exit function
		end if
		prepare_for_db = value
		exit function
	elseif controltype="time" then
		if isnull(value) then
			prepare_for_db=""
			exit function
		end if
		if value="" then
			prepare_for_db=""
			exit function
		end if
		vtime=localtime2db(value)
		if IsDateFieldType(GetFieldType(field,"")) then _
			vtime="2000-01-01 " & vtime
		prepare_for_db=vtime
		exit function
	elseif mid(controltype,1,4)="date" then
		dformat=cint(mid(controltype,5))
		if dformat=EDIT_DATE_SIMPLE or dformat=EDIT_DATE_SIMPLE_DP then
			ttime=localdatetime2db(value,"")
			if ttime="null" then
				prepare_for_db = ""
				exit function
			end if
			prepare_for_db = ttime
			exit function
		elseif dformat=EDIT_DATE_DD or dformat=EDIT_DATE_DD_DP then
			dim a
			a=split(value,"-")
			if ubound(a)<2 then
				prepare_for_db = null
				exit function
			Else
				y=a(0)
				m=a(1)
				d=a(2)
			end if
			if y<100 then
				if y<70 then
					y=y+2000
				Else
					y=y+1900
				end if
			end if
			prepare_for_db = cstr(y) & "-" & cstr(m) & "-" & cstr(d)
			exit function
		Else
			prepare_for_db = ""
			exit function
		end if
	elseif mid(controltype,1,8)="checkbox" then
		if value="on" then
			ret=1
		else 
			ret=0
		end if
		prepare_for_db = ret
		exit function
	Else
		prepare_for_db = false
		exit function
	end if
end function


'      combine checked values from multi-select list box

function combinevalues(arr())
        dim ret
        ret=""
        for i=0 to ubound(arr)
                if instr(1,arr(i),",")=0 and instr(1,arr(i),"""")=0 then
                        ret = ret & arr(i)
                Else
                        val = replace(arr(i),"""","""""")
                        ret = ret & """ & val & """
                end if
				if i<ubound(arr) then ret=ret & ","
        next
        combinevalues = ret
end function

'      split values for multi-select list box
function splitvalues(str)

        Dim arr2(20)
		arr2(0)=""
		if IsNULL(str) or str="" then 
			splitvalues = arr2
			exit function
		end if
        start=1
        i=1
		x=0
        inquot=false
        while i<=len(str)
                if i<len(str) and mid(str,i,1)="""" then 
					inquot = not inquot
                elseif i=len(str) or not inquot and mid(str,i,1)="," then
						if mid(str,i,1)<>"," then
							val = mid(str,start,i-start+1)
						else
							val=mid(str,start,i-start)
						end if
                        start=i+1
                        if len(val) and left(val,1)="""" then
                                val=mid(val,2,len(val)-2)
                                val=replace(val,"""""","""")
                        end if
                        arr2(x) = val
						x=x+1
                end if
                i=i+1
        wend
        splitvalues = arr2
end function


'////////////////////////////////////////////////////////////////////////////////
'// edit controls creation functions
'////////////////////////////////////////////////////////////////////////////////
'

'      write days dropdown
function WriteDays(d)
        ret="<option value=""""> </option>"
        for i=1 to 31
			s=""
			if cstr(i)=cstr(d) then s="selected"
            ret=ret & "<option value=""" & i & """ " & s & ">" & i & "</option>"
        next
        WriteDays = ret
end function

'      write months dropdown
function WriteMonths(m)
        dim monthnames(13)
        monthnames(1)="Janeiro"
        monthnames(2)="Fevereiro"
        monthnames(3)="Março"
        monthnames(4)="Abril"
        monthnames(5)="Maio"
        monthnames(6)="Junho"
        monthnames(7)="Julho"
        monthnames(8)="Agosto"
        monthnames(9)="Setembro"
        monthnames(10)="Outubro"
        monthnames(11)="Novembro"
        monthnames(12)="Dezembro"
        ret="<option value=""""></option>"
        for i=1 to 12
				s=""
				if cstr(i)=cstr(m) then s="selected"
                ret=ret & "<option value=""" & i & """ " & s & ">"  & monthnames(i) & "</option>"
        next
        WriteMonths = ret
end function

'      write years dropdown
function WriteYears(y)
        ret="<option value=""""> </option>"
        firstyear=year(now)-10
        if y<>0 then
			if firstyear>y-5 then firstyear=y-10
		end if
		lastyear=year(now)+10
        if y<>0 then
			if lastyear<y+5 then lastyear=y+10
		end if
        for i=firstyear to lastyear
			s=""
			if cstr(i)=cstr(y) then s="selected"
			ret=ret & "<option value=""" & i & """ " & s & ">" & i & "</option>"
        next
        WriteYears = ret
end function

'      returns HTML code that represents required Date edit control
function GetDateEdit(field, value, ttype, secondfield,search)
		if secondfield="" then secondfield=false
		
		if search="" then search=MODE_EDIT
		
        cfieldname=GoodFieldName(field)
        cfield="value_" & GoodFieldName(field)
        ctype="type_" & GoodFieldName(field)
        if secondfield then
                cfield="value1_" & GoodFieldName(field)
                ctype="type1_" & GoodFieldName(field)
        end if
        iname=cfield
        tvalue=value
        dim ttime
        ttime=db2time(tvalue)
        if CStr(ttime(0))="" then
                ttime(0)=0
                ttime(1)=0
                ttime(2)=0
                ttime(3)=0
                ttime(4)=0
                ttime(5)=0
        end if
        dp=0
        select case ttype
                Case EDIT_DATE_SIMPLE_DP
                        ovalue=value
                        if locale_info("LOCALE_IDATE")=1 then
                                fmt="dd" & locale_info("LOCALE_SDATE") & "MM" & locale_info("LOCALE_SDATE") & "yyyy"
                                sundayfirst="false"
                        else 
							if locale_info("LOCALE_IDATE")=0 then
									fmt="MM" & locale_info("LOCALE_SDATE") & "dd" & locale_info("LOCALE_SDATE") & "yyyy"
									sundayfirst="true"
							Else
									fmt="yyyy" & locale_info("LOCALE_SDATE") & "MM" & locale_info("LOCALE_SDATE") & "dd"
									sundayfirst="false"
							end if
						end if
                        if DateEditShowTime(field,"") then
                                if ttime(5)<>0 then
                                        fmt=fmt & " HH:mm:ss"
                                else 
									if ttime(3)<>0 or ttime(4)<>0 then
                                        fmt=fmt & " HH:mm"
                                    end if
                                end if
                        end if
                        if ttime(0)>0 then ovalue=format_datetime_custom(ttime,fmt)
                        ovalue1=ttime(2) & "-" & ttime(1) & "-" & ttime(0)
                        showtime="false"
                        if DateEditShowTime(field,"") then
                                showtime="true"
                                ovalue1=ovalue1 & " " & ttime(3) & ":" & ttime(4) & ":" & ttime(5)
                        end if
                        onblur="var dt=parse_datetime(this.value," & locale_info("LOCALE_IDATE") & "); if(dt!=null) document.forms.editform.ts" & iname & ".value=print_datetime(dt,-1," & showtime & "); else document.forms.editform.ts" & iname & ".value='';"
                        ret="<input type=""Text"" name=""" & iname & """ size = ""20"" value=""" & ovalue & """ onblur=""" & onblur & """>"
                        ret=ret & "<input type=""Hidden"" name=""ts" & iname & """ value=""" & ovalue1 & """>&nbsp;&nbsp;"
                        ret=ret & "<a href=""#"" onclick=""javascript:var v=show_calendar('update" & iname & "', document.forms.editform.ts" & iname & ".value," & showtime & "," & sundayfirst & "); return false;"">"
                        ret=ret & "<img src=""images/cal.gif"" width=16 height=16 border=0 alt=""" & "Clique aqui para indicar a data" & """></a>"
                        ret=ret & "<script language=JavaScript> function update" & iname & "(newDate){"
                        ret=ret & "document.forms.editform." & iname & ".value =  print_datetime(newDate," & locale_info("LOCALE_IDATE") & "," & showtime & ");"
                        ret=ret & "document.forms.editform.ts" & iname & ".value =  print_datetime(newDate,-1," & showtime & ");"
                        ret=ret & " }</script>"
                        response.Write ret
                        exit function
                Case EDIT_DATE_DD,EDIT_DATE_DD_DP
						if ttype=EDIT_DATE_DD_DP then 
							dp=1
						else
							dp=0
						end if
                        ovalue=value
                        if ttime(0)>0 then ovalue=format_datetime_custom(ttime,"yyyy-MM-dd")
                        retday="<select class=selects name=""day" & iname & """ onchange=""javascript: SetDate" & iname & "(); return true;"">" & WriteDays(ttime(2)) & "</select>"

                        retmonth="<select class=selectm name=""month" & iname & """ onchange=""javascript: SetDate" & iname & "(); return true;"">" & WriteMonths(ttime(1)) & "</select>"
                        retyear="<select class=selects name=""year" & iname & """ onchange=""javascript: SetDate" & iname & "(); return true;"">" & WriteYears(ttime(0)) & "</select>"
                        sundayfirst="false"
                        if locale_info("LOCALE_ILONGDATE")=1 then 
							ret=retday & "&nbsp;" & retmonth & "&nbsp;" & retyear
                        else 
							if locale_info("LOCALE_ILONGDATE")=0 then
									ret=retmonth & "&nbsp;" & retday & "&nbsp;" & retyear
									sundayfirst="true"
							Else
									ret=retyear & "&nbsp;" & retmonth & "&nbsp;" & retday
							end if
						end if

                        if dp<>0 then
                                ret=ret & "&nbsp;<a href=""#"" onclick=""javascript:var v=show_calendar('update" & iname & "', document.forms.editform.ts" & iname & ".value,false," & sundayfirst & "); return false;"">"
                                ret=ret & "<img src=images/cal.gif width=16 height=16 border=0 alt=""" & "Clique aqui para indicar a data" & """></a>"
                                ret=ret & "<input type=hidden name=""ts" & iname & """ value=""" & ttime(2) & "-" & ttime(1) & "-" & ttime(0) & """>"
                        end if
                        if ttime(0)>0 then
                                ret=ret & "<input type=hidden name=""" & iname & """ value=""" & ttime(0) & "-" & ttime(1) & "-" & ttime(2)  & """>"
                        Else
                                ret=ret & "<input type=hidden name=""" & iname & """ value="""">"
						end if
						
                        ret=ret & "<script language=JavaScript>"
                        ret=ret & "function SetDate" & iname & "(){"
                        ret=ret & "if (document.forms.editform.month" & iname & ".value!='' && document.forms.editform.day" & iname & ".value!='' && document.forms.editform.year" & iname & ".value!=''){"
                        ret=ret & "document.forms.editform." & iname & ".value= ''+document.forms.editform.year" & iname & ".value + "
                        ret=ret & "'-' + document.forms.editform.month" & iname & ".value + '-' + document.forms.editform.day" & iname & ".value; "
                        if dp<>0 then ret=ret & "document.forms.editform.ts" & iname & ".value='' + document.forms.editform.day" & iname & ".value+'-'+document.forms.editform.month" & iname & ".value+'-'+document.forms.editform.year" & iname & ".value; "
						ret=ret & "} else {"
						if dp<>0 then ret=ret & " document.forms.editform.ts" & iname & ".value= '" & ttime(2) & "-" & ttime(1) & "-" & ttime(0) & "'; "
                        ret=ret & "document.forms.editform." & iname & ".value= '';}}"
                        ret=ret & " SetDate" & iname & "(); "
                        if dp<>0 then
                                ret=ret & " function update" & iname & "(newDate){"
                                ret=ret & "var dt_datetime; "
                                ret=ret & "var curdate = new Date(); "
                                ret=ret & "dt_datetime = newDate;"
                                ret=ret & "document.forms.editform." & iname & ".value =  dt_datetime.getFullYear() + '-' + (dt_datetime.getMonth()+1) + '-' + dt_datetime.getDate();"
                                ret=ret & "document.forms.editform.day" & iname & ".selectedIndex = dt_datetime.getDate();"
                                ret=ret & "document.forms.editform.month" & iname & ".selectedIndex = dt_datetime.getMonth()+1;"
                                ret=ret & "for(i=0; i<document.forms.editform.year" & iname & ".options.length;i++)"
                                ret=ret & "if(document.forms.editform.year"  & iname & ".options[i].value==dt_datetime.getFullYear())"
                                ret=ret & "{document.forms.editform.year" & iname & ".selectedIndex=i; break;}"
                                ret=ret & "document.forms.editform.ts" & iname & ".value = dt_datetime.getDate() + '-' + (dt_datetime.getMonth()+1) + '-' + dt_datetime.getFullYear();}"
                        end if
                        ret=ret & " </script>"
                        response.Write ret
                        exit function
                Case EDIT_DATE_SIMPLE 
						ovalue=value
                        if ttime(0)>0 then
                                if ttime(3)<>0 or ttime(4)<>0 or ttime(5)<>0 then
                                        ovalue=format_datetime(ttime)
                                Else
                                        ovalue=format_shortdate(ttime)
                                end if
                        end if
                        response.Write "<input type=text name=""" & iname & """ size = ""20"" value=""" & my_htmlspecialchars(ovalue) & """>"                
				case else
                        ovalue=value
                        if ttime(0)>0 then
                                if ttime(3)<>0 or ttime(4)<>0 or ttime(5)<>0 then
                                        ovalue=format_datetime(ttime)
                                Else
                                        ovalue=format_shortdate(ttime)
                                end if
                        end if
                        response.Write "<input type=text name=""" & iname & """ size = ""20"" value=""" & my_htmlspecialchars(ovalue) & """>"
        end select
end function

'      create javascript array with values for dependent dropdowns
sub BuildSecondDropdownArray(arrName, strSQL)

        dim i
		response.Write arrName & "=new Array();" & vbcrlf
        i=0
        Set rs2 = server.CreateObject("ADODB.Recordset")
        rs2.Open strSQL,dbConnection
        while not rs2.EOF
                response.Write arrName & "[" & (i*3) & "]='" & jsreplace(dbvalue(rs2(0))) & "';" & vbcrlf
                response.Write arrName & "[" & (i*3 + 1) & "]='" & jsreplace(dbvalue(rs2(1))) &  "';" & vbcrlf
                response.Write arrName & "[" & (i*3 + 2) & "]='" & jsreplace(dbvalue(rs2(2))) & "';" & vbcrlf
                i=i+1
			rs2.movenext
        wend
        rs2.Close
end sub

'      create Lookup wizard control
function BuildSelectControl(field, value, values, secondfield, mode)
    dim i
	if secondfield="" then secondfield=false
    LookupSQL =""
    strSize = 1
	cfieldname=GoodFieldName(field)
	cfield="value_" & GoodFieldName(field)
	clookupfield="display_value_" & GoodFieldName(field)
	ctype="type_" & GoodFieldName(field)
	if secondfield then
		cfield="value1_" & GoodFieldName(field)
		ctype="type1_" & GoodFieldName(field)
	end if
	
	Set arr = CreateObject("Scripting.Dictionary")
	
	d=0
	if values<>"" then 
		arr.add d,values
		d=d+1
	end if
	addnewitem=false

	script=""
	if strTableName="Cadastro" and field="NrProtoc" then
		addnewitem= false 
		LinkField="ProxNr"
        DisplayField="ProxNr"
        LookupTable="ConsultaWebNovoNrProtoc"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "[ProxNr]"
				LookupSQL=LookupSQL & ",[ProxNr]"
				LookupSQL=LookupSQL & " from [ConsultaWebNovoNrProtoc] "
		
				
				
	end if
	if strTableName="Cadastro" and field="Emissor" then
		addnewitem= true 
		LinkField="Orgao"
        DisplayField="Orgao"
        LookupTable="Orgaos"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "distinct "
		LookupSQL=LookupSQL &  "[Orgao]"
				LookupSQL=LookupSQL & ",[Orgao]"
				LookupSQL=LookupSQL & " from [Orgaos] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		
				
	end if
	if strTableName="Cadastro" and field="TipoDoc" then
		addnewitem= true 
		LinkField="TipoDoc"
        DisplayField="TipoDoc"
        LookupTable="Tipodoc"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "[TipoDoc]"
				LookupSQL=LookupSQL & ",[TipoDoc]"
				LookupSQL=LookupSQL & " from [Tipodoc] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Tipodoc].[TipoDoc]"
		
				
	end if
	if strTableName="Cadastro" and field="Destino" then
		addnewitem= true 
		LinkField="Orgao"
        DisplayField="Orgao"
        LookupTable="Orgaos"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "distinct "
		LookupSQL=LookupSQL &  "[Orgao]"
				LookupSQL=LookupSQL & ",[Orgao]"
				LookupSQL=LookupSQL & " from [Orgaos] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		
				
	end if
	if strTableName="Moviment" and field="OrigNome" then
		addnewitem= true 
		LinkField="Orgao"
        DisplayField="Orgao"
        LookupTable="Orgaos"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "distinct "
		LookupSQL=LookupSQL &  "[Orgao]"
				LookupSQL=LookupSQL & ",[Orgao]"
				LookupSQL=LookupSQL & " from [Orgaos] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		
				
	end if
	if strTableName="Moviment" and field="DestNome" then
		addnewitem= true 
		LinkField="Orgao"
        DisplayField="Orgao"
        LookupTable="Orgaos"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "distinct "
		LookupSQL=LookupSQL &  "[Orgao]"
				LookupSQL=LookupSQL & ",[Orgao]"
				LookupSQL=LookupSQL & " from [Orgaos] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		
				
	end if
	if strTableName="Moviment2" and field="OrigNome" then
		addnewitem= true 
		LinkField="Orgao"
        DisplayField="Orgao"
        LookupTable="Orgaos"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "[Orgao]"
				LookupSQL=LookupSQL & ",[Orgao]"
				LookupSQL=LookupSQL & " from [Orgaos] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		
				
	end if
	if strTableName="Moviment2" and field="DestNome" then
		addnewitem= true 
		LinkField="Orgao"
        DisplayField="Orgao"
        LookupTable="Orgaos"
        strSize=1


		LookupSQL = "select "
				LookupSQL=LookupSQL &  "[Orgao]"
				LookupSQL=LookupSQL & ",[Orgao]"
				LookupSQL=LookupSQL & " from [Orgaos] "
		
				
				LookupSQL=LookupSQL & " ORDER BY [Orgaos].[Orgao]"
		
				
	end if
	if strTableName="moviment_sec" and field="Cumprido" then
		addnewitem= false 
		LinkField=""
        DisplayField=""
        LookupTable=""
        strSize=1

		arr.add d,"sim"
		d=d+1
	end if
	if strTableName="moviment_sec2" and field="Cumprido" then
		addnewitem= false 
		LinkField=""
        DisplayField=""
        LookupTable=""
        strSize=1

		arr.add d,"sim"
		d=d+1
	end if

'      multi-select
	multiple=""
	postfix=""
	dim res
	dim avalue
	if strSize>1 then
		avalue=splitvalues(value)
		multiple=" multiple"
		postfix="[]"
	Else
		redim avalue(0)
		avalue(0)=value
	end if

	if LookupSQL<>"" then
		if FastType(field,"") and useAJAX then
			lookup_SQL = ""
			lookup_value = ""
			
			if strTableName="Cadastro" and field="NrProtoc" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "[ProxNr]"
								lookup_SQL = lookup_SQL & ",[ProxNr]"
				lookup_SQL = lookup_SQL & " FROM [ConsultaWebNovoNrProtoc] "
								lookup_SQL = lookup_SQL & " WHERE [ProxNr]=" & make_db_value(field,value,"","") & ""
							end if
			if strTableName="Cadastro" and field="Emissor" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "DISTINCT "
				lookup_SQL = lookup_SQL & "[Orgao]"
								lookup_SQL = lookup_SQL & ",[Orgao]"
				lookup_SQL = lookup_SQL & " FROM [Orgaos] "
								lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
								end if
			if strTableName="Cadastro" and field="TipoDoc" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "[TipoDoc]"
								lookup_SQL = lookup_SQL & ",[TipoDoc]"
				lookup_SQL = lookup_SQL & " FROM [Tipodoc] "
								lookup_SQL = lookup_SQL & " WHERE [TipoDoc]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [TipoDoc]"
								end if
			if strTableName="Cadastro" and field="Destino" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "DISTINCT "
				lookup_SQL = lookup_SQL & "[Orgao]"
								lookup_SQL = lookup_SQL & ",[Orgao]"
				lookup_SQL = lookup_SQL & " FROM [Orgaos] "
								lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
								end if
			if strTableName="Moviment" and field="OrigNome" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "DISTINCT "
				lookup_SQL = lookup_SQL & "[Orgao]"
								lookup_SQL = lookup_SQL & ",[Orgao]"
				lookup_SQL = lookup_SQL & " FROM [Orgaos] "
								lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
								end if
			if strTableName="Moviment" and field="DestNome" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "DISTINCT "
				lookup_SQL = lookup_SQL & "[Orgao]"
								lookup_SQL = lookup_SQL & ",[Orgao]"
				lookup_SQL = lookup_SQL & " FROM [Orgaos] "
								lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
								end if
			if strTableName="Moviment2" and field="OrigNome" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "[Orgao]"
								lookup_SQL = lookup_SQL & ",[Orgao]"
				lookup_SQL = lookup_SQL & " FROM [Orgaos] "
								lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
								end if
			if strTableName="Moviment2" and field="DestNome" then 

								lookup_SQL = "SELECT "
								lookup_SQL = lookup_SQL & "[Orgao]"
								lookup_SQL = lookup_SQL & ",[Orgao]"
				lookup_SQL = lookup_SQL & " FROM [Orgaos] "
								lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
									lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
								end if
			if strTableName="moviment_sec" and field="Cumprido" then 

							end if
			if strTableName="moviment_sec2" and field="Cumprido" then 

							end if
			
			Set rs_lookup = server.CreateObject("ADODB.Recordset")
			rs_lookup.open lookup_SQL,dbConnection
			
			if not rs_lookup.EOF then
				lookup_value = rs_lookup(1)
				rs_lookup.Close
			else
				if strTableName="Cadastro" and field="NrProtoc" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "[ProxNr]"
										lookup_SQL = lookup_SQL & ",[ProxNr]"
					lookup_SQL = lookup_SQL & " FROM [ConsultaWebNovoNrProtoc] "
					lookup_SQL = lookup_SQL & " WHERE [ProxNr]=" & make_db_value(field,value,"","") & ""
									end if
				if strTableName="Cadastro" and field="Emissor" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "DISTINCT "
					lookup_SQL = lookup_SQL & "[Orgao]"
										lookup_SQL = lookup_SQL & ",[Orgao]"
					lookup_SQL = lookup_SQL & " FROM [Orgaos] "
					lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
										end if
				if strTableName="Cadastro" and field="TipoDoc" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "[TipoDoc]"
										lookup_SQL = lookup_SQL & ",[TipoDoc]"
					lookup_SQL = lookup_SQL & " FROM [Tipodoc] "
					lookup_SQL = lookup_SQL & " WHERE [TipoDoc]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [TipoDoc]"
										end if
				if strTableName="Cadastro" and field="Destino" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "DISTINCT "
					lookup_SQL = lookup_SQL & "[Orgao]"
										lookup_SQL = lookup_SQL & ",[Orgao]"
					lookup_SQL = lookup_SQL & " FROM [Orgaos] "
					lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
										end if
				if strTableName="Moviment" and field="OrigNome" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "DISTINCT "
					lookup_SQL = lookup_SQL & "[Orgao]"
										lookup_SQL = lookup_SQL & ",[Orgao]"
					lookup_SQL = lookup_SQL & " FROM [Orgaos] "
					lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
										end if
				if strTableName="Moviment" and field="DestNome" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "DISTINCT "
					lookup_SQL = lookup_SQL & "[Orgao]"
										lookup_SQL = lookup_SQL & ",[Orgao]"
					lookup_SQL = lookup_SQL & " FROM [Orgaos] "
					lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
										end if
				if strTableName="Moviment2" and field="OrigNome" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "[Orgao]"
										lookup_SQL = lookup_SQL & ",[Orgao]"
					lookup_SQL = lookup_SQL & " FROM [Orgaos] "
					lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
										end if
				if strTableName="Moviment2" and field="DestNome" then 

										lookup_SQL = "SELECT "
										lookup_SQL = lookup_SQL & "[Orgao]"
										lookup_SQL = lookup_SQL & ",[Orgao]"
					lookup_SQL = lookup_SQL & " FROM [Orgaos] "
					lookup_SQL = lookup_SQL & " WHERE [Orgao]=" & make_db_value(field,value,"","") & ""
											lookup_SQL = lookup_SQL & " ORDER BY [Orgao]"
										end if
				if strTableName="moviment_sec" and field="Cumprido" then 

									end if
				if strTableName="moviment_sec2" and field="Cumprido" then 

									end if
					
				Set rs_lookup1 = server.CreateObject("ADODB.Recordset")
				rs_lookup1.open lookup_SQL,dbConnection
				
				if not rs_lookup1.EOF then lookup_value = rs_lookup1(1)
				rs_lookup.Close
			end if
			
			response.Write "<input type=text autocomplete=""off"" name=""" & clookupfield & """ value=""" & my_htmlspecialchars(lookup_value) & """ onkeydown=""return listenEvent(event,this,'lookup');"" onkeyup=""lookupSuggest(event,this,'" & my_htmlspecialchars(jsreplace(lookup_value)) & "');"" onblur=""isSetFocus=false;showHideLookupError(this);"" onfocus=""isSetFocus=true;""  >"
			response.Write "<input type=hidden id=""" & cfield & """ name=""" & cfield & """ value=""" & my_htmlspecialchars(value) & """>"
			'      add new item
			if addnewitem and mode<>MODE_SEARCH then
				response.Write "<a href=# onclick=""window.open('" & GetTableURL(strTableName)& "_addnewitem.asp?field=" & jsreplace(my_htmlspecialchars(server.urlencode(field))) & "','AddNewItem', 'width=250,height=100,status=no,resizable=yes,top=200,left=200');"">" & "Incluir Novo" & "</a>"
			end if
		else
			LogInfo(LookupSQL)
			Set rse = server.CreateObject("ADODB.Recordset")
			rse.open LookupSQL,dbConnection
			onchange=""
			if onchange<>"" then onchange="onchange=""" & onchange & """"
			if useAJAX then
				response.Write "<select size = """ & strSize & """ id=""" & cfield & postfix & """ name=""" & cfield & postfix & """" & multiple & " " & ">"
			else 
				response.Write "<select size = """ & strSize & """ name=""" & cfield & postfix & """" & multiple & " " & onchange & ">"
			end if
			count = rse.recordcount
			if strSize<2 then
				response.Write "<option value="""">" & "Favor Selecionar" & "</option>"
			elseif mode=MODE_SEARCH then 
				response.Write "<option value=""""> </option>"
			end if
	
			dim found
			found=false

			while not rse.eof
				res=false
				for i=0 to ubound(avalue)
					if not isnull(rse(0)) then
						if CStr(rse(0))=avalue(i) then res=true
					end if
				next                        
				if res then
					found=true
					response.Write "<option value=""" & my_htmlspecialchars(rse(0)) & """ selected>" & my_htmlspecialchars(rse(1)) & "</option>"
				Else
					response.Write "<option value=""" & my_htmlspecialchars(rse(0)) & """>" & my_htmlspecialchars(rse(1)) & "</option>"
				end if
				rse.movenext  
			wend
			rse.Close
			response.Write "</select>"
'      add new item
			if addnewitem and mode<>MODE_SEARCH then
				response.Write "<a href=# onclick=""window.open('" & GetTableURL(strTableName)& "_addnewitem.asp?field=" & jsreplace(my_htmlspecialchars(server.urlencode(field))) & "','AddNewItem', 'width=250,height=100,status=no,resizable=yes,top=200,left=200');"">" & "Incluir Novo" & "</a>"
			end if
		end if
	Else
		response.Write "<select size = """ & strSize & """ name=""" & cfield & postfix & """ " & multiple & ">"
		if strSize<2 then
			response.Write "<option value="""">" & "Favor Selecionar" & "</option>"
		elseif mode=MODE_SEARCH then
			response.Write "<option value=""""> </option>"
		end if
		for opt=0 to arr.Count-1
			res=false
			for i=0 to ubound(avalue)
				if arr(opt)=avalue(i) then res=true
			next
			if res then
				response.Write "<option value=""" & my_htmlspecialchars(arr(opt)) & """ selected>" & my_htmlspecialchars(arr(opt)) & "</option>"
			Else
				response.Write "<option value=""" & my_htmlspecialchars(arr(opt)) & """>" & my_htmlspecialchars(arr(opt)) & "</option>"
			end if
		next
		response.Write "</select>"
	end if
end function

function BuildRadioControl(field, value,secondfield)
        if secondfield="" then secondfield=false
        dim cfieldname,cfield,ctype
        cfieldname=GoodFieldName(field)
        cfield="value_" & GoodFieldName(field)
        ctype="type_" & GoodFieldName(field)
        if secondfield then
                cfield="value1_" & GoodFieldName(field)
                ctype="type1_" & GoodFieldName(field)
        end if
        LookupSQL =""
        if strTableName="Cadastro" and  "Nat"=field then
                                        set arr = CreateObject("Scripting.Dictionary")
                        l=0
								arr.Add l,"Entrada" 
								l=l+1
								arr.Add l,"Saída" 
								l=l+1
        end if
        if len(LookupSQL)>1 then
				LogInfo(LookupSQL)
                Set rst = server.CreateObject("ADODB.Recordset")
                rst.open LookupSQL,dbConnection
                if rst.eof then 
                        BuildRadioControl = ""
                        exit function
                end if
                response.Write "<input type=hidden name=""" & cfield & """ value=""" & my_htmlspecialchars(value) & """>"
				while not rst.eof
                        if not isnull(rst(0)) and CStr(rst(0))=value then
                                response.Write "<input type=""Radio"" name=""radio_" & cfieldname & """ onclick=""javascript: " & cfield & ".value='" & db_addslashes(rst(0)) & "'; return true;"" checked>" & my_htmlspecialchars(rst(1)) & "<br>"
                        Else
                                response.Write "<input type=""Radio"" name=""radio_" & cfieldname & """ onclick=""javascript: " & cfield & ".value='" & db_addslashes(rst(0)) & "'; return true;"">"  & my_htmlspecialchars(rst(1)) & "<br>"
                        end if
                        rst.movenext
                wend
                rst.close
        Else
                response.Write "<input type=hidden name=""" & cfield & """ value=""" & my_htmlspecialchars(value) & """>"
                for each opt in arr
                        if arr.Item(opt)=value then
                                response.Write "<input type=""Radio"" name=""radio_" & cfieldname & """ onclick=""javascript: " & cfield & ".value='" & db_addslashes(arr.Item(opt)) & "'; return true;"" checked>" & my_htmlspecialchars(arr.Item(opt)) & "<br>"
                        Else
                                response.Write "<input type=""Radio"" name=""radio_" & cfieldname & """ onclick=""javascript: " & cfield & ".value='" & db_addslashes(arr.Item(opt)) & "'; return true;"">" & my_htmlspecialchars(arr.Item(opt)) & "<br>"
                        end if
				next
        end if
        BuildRadioControl = ""
end function

function BuildEditControl(field , value, fformat, edit, secondfield)
	if secondfield="" then secondfield=false
	cfieldname=GoodFieldName(field)
	cfield="value_" & GoodFieldName(field)
	ctype="type_" & GoodFieldName(field)
	if secondfield then
		cfield="value1_" & GoodFieldName(field)
		ctype="type1_" & GoodFieldName(field)
	end if
	ttype=GetFieldType(field,"")
	arr=""
	if fformat=EDIT_FORMAT_FILE and edit=MODE_SEARCH then fformat=""
	if fformat=EDIT_FORMAT_TEXT_FIELD then
		if IsDateFieldType(ttype) then
			response.Write "<input type=""hidden"" name=""" & ctype & """ value=""date" & EDIT_DATE_SIMPLE & """>" & GetDateEdit(field,value,0,secondfield,edit)
		Else
			if edit = MODE_SEARCH then
				response.write "<input type=""text"" autocomplete=""off"" name=""" & cfield & """ " & GetEditParams(field,"") & " value=""" & my_htmlspecialchars(value) & """>"
			else
			response.write "<input type=""text"" name=""" & cfield & """ " & GetEditParams(field,"") & " value=""" & my_htmlspecialchars(value) & """>"
			end if		
		end if
	elseif fformat=EDIT_FORMAT_TIME then 
		response.write "<input type=""hidden"" name=""" & ctype & """ value=""time"">"
		if IsDateFieldType(ttype) then
			dbtime=db2time(value)
			if ubound(dbtime)>0 then
				val=fformat_time(dbtime)
			else
				val=""
			end if
		else 
			arr=parsenumbers(value)
			if ubound(arr)>0 then
				dim dbtime(6)
				dbtime(0)=0
				dbtime(1)=0
				dbtime(2)=0
				dbtime(3)=0
				dbtime(4)=0
				dbtime(5)=0
				dim i
				for i=0 to 2
					if ubound(arr)>i then dbtime(i+3)=arr(i)
				next
				val=fformat_time(dbtime)
			else
				val=""
			end if
		end if
		response.write "<input type=""text"" name=""" & cfield & """ " & GetEditParams(field,"") & " value=""" & my_htmlspecialchars(val) & """>"
	elseif fformat=EDIT_FORMAT_TEXT_AREA then
			nWidth = GetNCols(field, strTableName)
			nHeight = GetNRows(field, strTableName)

		if UseRTE(field, strTableName) then
			value = RTESafe(value)
			
							response.Write "<script language=""JavaScript"" type=""text/javascript"">"
				response.Write "writeRichText(""" & cfield & """, '" & value & "', " & nWidth & " , " & nHeight & ", true, false);"
				response.Write "</script>"
					Else
			response.Write "<textarea name=""" & cfield & """ style=""width: " & nWidth & "px;height: " & nHeight & "px;"">"  & my_htmlspecialchars(value) & "</textarea>"
		end if
	elseif fformat=EDIT_FORMAT_PASSWORD then
		response.Write "<input type=""Password"" name=""" & cfield & """ " & GetEditParams(field,"") & " value=""" & my_htmlspecialchars(value) & """>"
	elseif fformat=EDIT_FORMAT_DATE then
		response.Write "<input type=""hidden"" name=""" & ctype & """ value=""date"  & DateEditType(field,"") & """>" & GetDateEdit(field,value,DateEditType(field,""),secondfield,edit)
	elseif fformat=EDIT_FORMAT_RADIO then
		a=BuildRadioControl(field,value,secondfield)
	elseif fformat=EDIT_FORMAT_CHECKBOX then
		if edit=MODE_ADD or edit=MODE_EDIT then
			ch=""
			if isNumeric(value) then
				if value<>0 then ch="checked"
			else
				if value<>"" and value<>"False" then ch="checked"
			end if
			response.Write "<input type=""hidden"" name=""" & ctype & """ value=""checkbox""><input type=""Checkbox"" name=""" & cfield & """ " & ch & ">"
		Else
			response.Write "<input type=""hidden"" name=""" & ctype & """ value=""checkbox"">"
			response.Write "<select name=""" & cfield & """>"
			dim val(3)
			val(0)=none
			val(1)="on"
			val(2)="off"
			dim show(3)
			show(0)=""
			show(1)="True"
			show(2)="False"
			for i=0 to 2
				sel=""
				if cstr(value)=val(i) then sel=" selected"
				response.Write "<option value=""" & val(i) & """" & sel & ">" & show(i) & "</option>"
			next
			response.Write "</select>"
		end if
	elseif fformat=EDIT_FORMAT_DATABASE_IMAGE or fformat=EDIT_FORMAT_DATABASE_FILE then
		iquery="field=" & server.urlencode(field)
		keylink=""
		if strTableName="Cadastro" then
			keylink=keylink & "&key1=" & server.urlencode(keys("NrProtoc"))
			iquery=iquery & keylink
		end if
		if strTableName="Impr_recibo" then
			keylink=keylink & "&key1=" & server.urlencode(keys("NrProtoc"))
			keylink=keylink & "&key2=" & server.urlencode(keys("DtMovim"))
			iquery=iquery & keylink
		end if
		if strTableName="Moviment" then
			keylink=keylink & "&key1=" & server.urlencode(keys("CodMov"))
			keylink=keylink & "&key2=" & server.urlencode(keys("NrProtoc"))
			iquery=iquery & keylink
		end if
		if strTableName="Tramitacao" then
			keylink=keylink & "&key1=" & server.urlencode(keys("NrProtoc"))
			iquery=iquery & keylink
		end if
		if strTableName="Moviment2" then
			keylink=keylink & "&key1=" & server.urlencode(keys("CodMov"))
			keylink=keylink & "&key2=" & server.urlencode(keys("NrProtoc"))
			iquery=iquery & keylink
		end if
		if strTableName="moviment_sec" then
			keylink=keylink & "&key1=" & server.urlencode(keys("CodMov"))
			keylink=keylink & "&key2=" & server.urlencode(keys("NrProtoc"))
			iquery=iquery & keylink
		end if
		if strTableName="Usuários" then
			keylink=keylink & "&key1=" & server.urlencode(keys("NúmeroDoUsuário"))
			iquery=iquery & keylink
		end if
		if strTableName="_AudMoviment" then
			keylink=keylink & "&key1=" & server.urlencode(keys("ID"))
			iquery=iquery & keylink
		end if
		if strTableName="moviment_sec2" then
			keylink=keylink & "&key1=" & server.urlencode(keys("CodMov"))
			keylink=keylink & "&key2=" & server.urlencode(keys("NrProtoc"))
			iquery=iquery & keylink
		end if
		disp=""
		strfilename=""
		onchangefile=""
		if edit=MODE_EDIT then
			if lenb(rs(field))>0 then
				dim pict
				pict=rs(field).GetChunk(20000000)
				if lenb(rs(field))>100 then
					value=db_stripslashesbinary(midb(pict,1,100))
				else
					value=db_stripslashesbinary(pict)
				end if
			else
				value=""
			end if
			itype=SupposeImageType(value)
			thumbnailed=false
			thumbfield=""
			
			if itype<>"" then
				if thumbnailed then
					disp = "<a target=_blank href=""" & GetTableURL(strTableName) & "_imager.asp?" & iquery & """>"
					disp = disp & "<img border=0"
					disp = disp & " src=""" & GetTableURL(strTableName) & "_imager.asp?field="&server.urlencode(thumbfield)&"&alt="& server.urlencode(field) & keylink &""">"
					disp = disp & "</a>"
				else
					disp="<img border=0 src=""" & GetTableURL(strTableName) & "_imager.asp?" & iquery & """>"
				end if
			Else
				if len(value)>0 then
					disp="<img border=0 src=""images/file.gif"">"
				Else
					disp="<img border=0 src=""images/no_image.gif"">"
				end if
			end if
'      filename
			if fformat=EDIT_FORMAT_DATABASE_FILE and itype="" and len(value)>0 then
				filename=rs(GetFilenameField(field,""))
				if filename="" then filename="file.bin"
				disp="<a href=""" & GetTableURL(strTableName) & "_getfile.asp?filename=" & my_htmlspecialchars(filename) & "&" & iquery & """>" & disp & "</a>"
			end if
'      filename edit
			if fformat=EDIT_FORMAT_DATABASE_FILE and GetFilenameField(field,"")<>"" then
				filename=rs(GetFilenameField(field,""))
				if filename="" then filename=""
				strfilename="<br>" & "Nome de Arquivo" & "&nbsp;&nbsp;<input name=""filename_" & cfieldname & """ size=""20"" maxlength=""50"" value=""" & my_htmlspecialchars(filename) & """>"
				onchangefile=onchangefile & "var path=this.form.elements['" & addslashes(cfield) & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; this.form.elements['filename_" & addslashes(cfieldname) & "'].value=path.substr(pos+1);"
			end if
			strtype="<br><input type=""Radio"" name=""" & ctype & """ value=""file0"" checked>" & "Manter"
			if len(value)>0 and not IsRequired(field,"") then
				strtype=strtype & "<input type=""Radio"" name=""" & ctype & """ value=""file1"">" & "Excluir Selecionados"
				onchangefile=onchangefile & "this.form.elements['" & addslashes(ctype) & "'][2].checked=true;"
			Else
				onchangefile=onchangefile & "this.form.elements['" & addslashes(ctype) & "'][1].checked=true;"
			end if
			strtype=strtype & "<input type=""Radio"" name=""" & ctype & """ value=""file2"">" & "Atualizar"
		Else
			strtype="<input type=""hidden"" name=""" & ctype & """ value=""file2"">"
			if fformat=EDIT_FORMAT_DATABASE_FILE and GetFilenameField(field,"")<>"" then
				strfilename="<br>" & "Nome de Arquivo" & "&nbsp;&nbsp;<input name=""filename_" & cfieldname & """ size=""20"" maxlength=""50"">"
				onchangefile=onchangefile & "var path=this.form.elements['" & addslashes(cfield) & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; this.form.elements['filename_" & addslashes(cfieldname) & "'].value=path.substr(pos+1);"
			end if
		end if
		maxsize=""
		if max_filesize_set=0 then
			maxsize="<input type=""hidden"" name=""MAX_FILE_SIZE"" value=""" & cMaxUploadFileSize & """>"
			max_filesize_set=1
		end if
		if onchangefile<>"" then onchangefile="onChange=""" & onchangefile & """"
		response.Write disp & strtype & maxsize & "<br><input type=""File"" name=""" & cfield & """ " & onchangefile & ">" & strfilename
	elseif fformat=EDIT_FORMAT_LOOKUP_WIZARD then
		BuildSelectControl field, value, arr, secondfield, edit
	elseif fformat=EDIT_FORMAT_HIDDEN then
		response.Write "<input type=""Hidden"" name=""" & cfield & """ value=""" & my_htmlspecialchars(value) & """>"
	elseif fformat=EDIT_FORMAT_READONLY then
		response.Write "<input type=""Hidden"" name=""" & cfield & """ value=""" & my_htmlspecialchars(value) & """>"
	elseif fformat=EDIT_FORMAT_FILE then
		disp=""
		strfilename=""
		onchangefile=""
		ffunction=""
		if edit=MODE_EDIT then
'      show current file
			if Format(field,"")=FORMAT_FILE or Format(field,"")=FORMAT_FILE_IMAGE then disp=GetData(rs,field,Format(field,"")) & "<br>"
			filename=value
			ffunction="<script language=""Javascript"">"
			ffunction=ffunction & "function controlfilename" & cfieldname & "(enable){" & vbcrlf
			ffunction=ffunction & "if(enable){" & vbcrlf
			ffunction=ffunction & "document.forms.editform." & cfield & ".style.backgroundColor=""white"";" & vbcrlf
			ffunction=ffunction & "document.forms.editform." & cfield & ".disabled=false;}" & vbcrlf
			ffunction=ffunction & "else{" & vbcrlf
			ffunction=ffunction & "document.forms.editform." & cfield & ".style.backgroundColor=""gainsboro"";" & vbcrlf
			ffunction=ffunction & "document.forms.editform." & cfield & ".disabled=true;}}</script>" & vbcrlf
'      filename edit
			filename_size=30
			if UseTimestamp(field,"") then filename_size=50
			strfilename="<input type=hidden name=""filename_" & cfieldname & """ value=""" & my_htmlspecialchars(filename) & """><br>" & "Nome de Arquivo" & "&nbsp;&nbsp;<input style=""background-color:gainsboro"" disabled name=""" & cfield & """ size=""" & filename_size & """ maxlength=""100"" value=""" & my_htmlspecialchars(filename) & """>"
			onchangefile=onchangefile & "var path=this.form.file_" & cfieldname & ".value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; controlfilename" & cfieldname & "(true);"
			if UseTimestamp(field,"") then
				onchangefile=onchangefile & "this.form." & cfield & ".value=addTimestamp(path.substr(pos+1)); "
			Else
				onchangefile=onchangefile & "this.form." & cfield & ".value=path.substr(pos+1); "
			end if
			strtype="<br><input type=""Radio"" name=""" & ctype & """ value=""upload0"" checked onclick=""controlfilename" & cfieldname & "(false)"">" & "Manter"
			if len(value)>0  and not IsRequired(field,"") then
				strtype=strtype & "<input type=""Radio"" name=""" & ctype & """ value=""upload1"" onclick=""controlfilename" & cfieldname & "(false)"">" & "Excluir Selecionados"
				onchangefile=onchangefile & "this.form." & ctype & "[2].checked=true;"
			Else
				onchangefile=onchangefile & "this.form." & ctype & "[1].checked=true;"
			end if
			strtype=strtype & "<input type=""Radio"" name=""" & ctype & """ value=""upload2"" onclick=""controlfilename" & cfieldname & "(true)"">" & "Atualizar"
		Else
			filename_size=30
			if UseTimestamp(field,"") then filename_size=50
			strtype="<input type=""hidden"" name=""" & ctype & """ value=""upload2"">"
			strfilename="<br>" & "Nome de Arquivo" & "&nbsp;&nbsp;<input name=""" & cfield & """ size=""" & filename_size & """ maxlength=""100"">"
			onchangefile=onchangefile & "var path=this.form.file_" & cfieldname  & ".value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos;"
			if UseTimestamp(field,"") then
				onchangefile=onchangefile & " this.form." & cfield & ".value=addTimestamp(path.substr(pos+1));"
			Else
				onchangefile=onchangefile & " this.form." & cfield & ".value=path.substr(pos+1);"
			end if
		end if
		maxsize=""
		if max_filesize_set=0 then
			maxsize="<input type=""hidden"" name=""MAX_FILE_SIZE"" value=""" & cMaxUploadFileSize & """>"
			max_filesize_set=1
		end if
		if onchangefile<>"" then onchangefile="onChange=""" & onchangefile & """"
		response.Write ffunction & disp & strtype & maxsize & "<br><input type=""File"" name=""file_" & cfieldname & """ " & onchangefile & ">" & strfilename
	end if
end function

Function pg_escape_string(name)
        name = Replace(name, "\", "\\")
        name = Replace(name, "'", "\'")
        return name
End Function

Function my_numeric(strName)
        If IsNumeric(strName) Then
                my_numeric = strName
        Else
                my_numeric = 0
        End If
End Function
Sub DoEvent(strEvent)

On Error Resume Next
Execute strEvent

If Err.Number <> 13 Then
        strMoreInfo = "Event: " & strEvent
        ReportError
End If
On Error GoTo 0

End Sub

Function ParseMultiPartForm
	if Request.TotalBytes = 0 then
		ParseMultiPartForm = false
		Exit Function
	end if
	ParseMultiPartForm = true
	Dim postData
	postData = Request.BinaryRead(Request.TotalBytes)
	contentType = Request.ServerVariables( "HTTP_CONTENT_TYPE")
	ctArray = split( contentType, ";")
	if trim(ctArray(0)) = "multipart/form-data" then
		errMsg = ""
		' grab the form boundry...
		bArray = split( trim( ctArray(1)), "=")
		boundry = Unicode2Bytes("--" & trim( bArray(1)))
		currentPos = 1
		inStrByte = 1
		While inStrByte > 0
			inStrByte = InStrB(currentPos, postData, boundry)
			m = inStrByte - currentPos
			If m > 1 Then
    			val = MidB(postData, currentPos, m)
    			
        		infoEnd = instrB( val, chrb(13) & chrb(10) & chrb(13) & chrb(10) )
        		if infoEnd > 0 then
        			varInfo = Bytes2String(midb( val , 1, infoEnd - 1))
        			varValue = midb( val , infoEnd + 4, lenb(val) - infoEnd - 5)
				if InStr(1, varInfo, "Content-Type") < 1 then varValue=Bytes2String(varValue)
				strField = getFieldName(varInfo)
				if myRequest.exists(strField) then
					myRequest(strField) = myRequest(strField) & "," & varValue
        			else
					myRequest.add strField, varValue
				end if
				
        		end if
			end if
			currentPos = lenb(boundry) + inStrByte
		wend
	else
		errMsg = "Wrong encoding type!"
	end if 

End Function


' This function retreives a field's name
function getFieldName( infoStr)
	sPos = inStr( infoStr, "name=")
	endPos = inStr( sPos + 6, infoStr, chr(34) & ";")
	if endPos = 0 then
		endPos = inStr( sPos + 6, infoStr, chr(34))
	end if
	getFieldName = mid( infoStr, sPos + 6, endPos - (sPos + 6))
end function

' This function retreives a file field's filename
function getFileName( infoStr)
	sPos = inStr( infoStr, "filename=")
	endPos = inStr( infoStr, chr(34) & crlf)
	getFileName = mid( infoStr, sPos + 10, endPos - (sPos + 10))
end function

' This function retreives a file field's mime type
function getFileType( infoStr)
	sPos = inStr( infoStr, "Content-Type: ")
	getFileType = mid( infoStr, sPos + 14)
end function

Function GetRequestForm(key)

if isEmpty(myRequest) then
	GetRequestForm=""
	Exit Function
end if

if myRequest.Exists(key) then
	GetRequestForm = myRequest(key)
else
	GetRequestForm = Request.QueryString(key)
end if

End Function

Function Unicode2Bytes(str)
	
For ind = 1 To len(str) 
     Unicode2Bytes = Unicode2Bytes& ChrB(Asc(Mid(str, ind, 1)))
Next 

End Function

function addslashes(str)
	str = replace(str,"'","\'")
	str = replace(str,"""","\""")
	addslashes = replace(str,"/","\/")
end function

Sub sendmail(email, subject, message)

Dim i
if email="" or isnull(email) then
	strMessage = "Email address is empty. Cannot send email."
	Exit Sub
end if

'On Error Resume Next

	Version = Request.ServerVariables("SERVER_SOFTWARE")
	If InStr(Version, "Microsoft-IIS") > 0 Then
		i = InStr(Version, "/")
		If i > 0 Then
			IISVer = Trim(Mid(Version, i+1))
		End If
	End If

	If IISVer <= "5.0" Then
		' Windows NT / 2000 
		Set myMail = Server.CreateObject("CDONTS.NewMail")
		myMail.From = cfrom
		myMail.To = email

		myMail.Subject = subject 
		myMail.Body = message 
		myMail.Send
		Set myMail = Nothing
Else
		' Windows XP / 2003 
        Set myMail=CreateObject("CDO.Message")
        myMail.Subject = subject 
        myMail.From=cfrom
        myMail.To=email
        myMail.TextBody= message 
        myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
        'Name or IP of remote SMTP server
        myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")=csmtpserver
        'Server port
        myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=csmtpport 
        ' SMTP username and passwords
        myMail.Configuration.Fields.Item("http://schemas.microsoft.com/c­do/configuration/sendpassword") = csmtppassword
        myMail.Configuration.Fields.Item("http://schemas.microsoft.com/c­do/configuration/sendusername") = csmtpuser
        myMail.Configuration.Fields.Update
        myMail.Send
        Set myMail = Nothing 
End If


	if Err.Number<>0 then
		strMessage = "Error happened sending email to " & email & "<br>" & Err.Source & "<br>" & Err.Number & "<br>" & Err.Description

		Err.Clear
	end if


End Sub

Function IsFloat(nType)

	IsFloat = false
	if nType=14 or nType=5 or nType=131 then IsFloat=true end if

End Function

Function Bytes2String(bytes)

	Dim i, byteord, nextbyteord

	For i = 1 to LenB(bytes)
		byteord = AscB(MidB(bytes, i, 1))
		If session.codepage<>65001 or byteord < &H80 Then ' Ascii
			Bytes2String= Bytes2String& Chr(byteord)
		Else ' Double-byte characters?
			if byteord >= &HC2 and byteord <= &HDF and i < LenB(bytes) then
				byteord2 = AscB(MidB(bytes, i+1, 1))
				On Error Resume Next
				charindex = (byteord-192)*64 + (byteord2-128)
				Bytes2String= Bytes2String& ChrW(charindex)
				If Err.Number <> 0 Then
					On Error GoTo 0
					Bytes2String= Bytes2String& Chr(byteord) & Chr(byteord2)
				End If
				i = i + 1
			elseif byteord >= 112 and byteord < 240 and i+1 < LenB(bytes) then
				byteord2 = AscB(MidB(bytes, i+1, 1))
				byteord3 = AscB(MidB(bytes, i+2, 1))
				On Error Resume Next
				charindex = (byteord-224)*4096 + (byteord2-128)*64 + (byteord3-128)
				Bytes2String= Bytes2String& ChrW(charindex)
				If Err.Number <> 0 Then
					On Error GoTo 0
					Bytes2String= Bytes2String& Chr(byteord) & Chr(byteord2) & Chr(byteord3)
				End If
				i = i + 2
			elseif i+2 < LenB(bytes) then
				byteord2 = AscB(MidB(bytes, i+1, 1))
				byteord3 = AscB(MidB(bytes, i+2, 1))
				byteord4 = AscB(MidB(bytes, i+3, 1))
				On Error Resume Next
				charindex = (byteord-240)*262144 + (byteord2-128)*4096 + (byteord3-128)*64 + (byteord4-128)
				Bytes2String= Bytes2String& ChrW(charindex)
				If Err.Number <> 0 Then
					On Error GoTo 0
					Bytes2String= Bytes2String& Chr(byteord) & Chr(byteord2) & Chr(byteord3) & Chr(byteord4)
				End If
				i = i + 3
			 Else 
			   Bytes2String= Bytes2String& Chr(byteord)
			 end if
		End If
	Next
End Function
Function CSmartDbl(strValue)

On Error Resume Next
CSmartDbl = CDbl(strValue)
if Err.Number<>0 then
    
	Err.Clear
	if InStr(strValue, ".")>0 then 
	   CSmartDbl = CDbl(Replace(strValue, ".", ","))
	elseif InStr(strValue, ",")>0 then 
	   CSmartDbl = CDbl(Replace(strValue, ",", "."))
	end if
	Err.Clear
end if

On Error Goto 0

End Function
sub DeleteFile(strFileName)

Set fso = CreateObject("Scripting.FileSystemObject")
if fso.FileExists(strFileName) then
	fso.DeleteFile(strFileName)
end if
set fso = Nothing

end sub

sub WriteToFile(strFileName, binData)
	Dim rsT
	Set rsT = Server.CreateObject("ADODB.Recordset")
	rsT.Fields.Append "File", 205, LenB(binData)
	rsT.Open
	rsT.AddNew
	rsT.Fields("File").AppendChunk binData
	rsT.Fields("File").AppendChunk "0"
	rsT.Update
	
	Dim stream
	Set stream = Server.CreateObject("ADODB.Stream")
	stream.Type = 1
	stream.Open
	stream.Write rsT.Fields("File").GetChunk(LenB(binData))
	stream.SaveToFile strFileName, 2

	stream.Close
	Set stream = Nothing
	rsT.Close
	Set rsT = Nothing
end sub

Function SafeURLEncode(str)

if IsNULL(str) then str = ""

SafeURLEncode = Server.URLEncode(CStr(str))

End Function

function dbvalue(value)
	if isnull(value) then
		dbvalue=""
		exit function
	end if
	if vartype(value)=7 then
		dbvalue=year(value) & "-" & month(value) & "-" & day(value) & " " & hour(value) & ":" & minute(value) & ":" & second(value)
		exit function
	end if
	dbvalue=value
	exit function
end function

Function SafeIsEmpty(str)

if IsArray(str) then
	SafeIsEmpty = false
	Exit Function
end if

SafeIsEmpty = (str="")

End Function


sub ReportError
if Err.number<>0 then
	response.flush
	Set objXML = Server.CreateObject("Microsoft.XMLDOM")
	Set objLst = Server.CreateObject("Microsoft.XMLDOM")
	Set objSlt = Server.CreateObject("Microsoft.XMLDOM")

	objXML.async = False
	objXML.Load (Server.MapPath("include/errors.xml"))
	If objXML.parseError.errorCode <> 0 Then
		Response.Write "error occurs <br>error message: " & objXML.parseError.reason & "<br> in the line " & objXML.parseError.line & "<br>line of XML that contains the error" & objXML.parseError.srcText
	End If

	Set objLst = objXML.getElementsByTagName("Keywords")
	Set objSlt = objXML.getElementsByTagName("Solution")
 	dim flag, noOfHeadlines, i, j, Description
	noOfHeadlines = objLst.length
	Dim ar 
	Dim kwords
	Description = lcase(err.Description)
	flag = 1
	i=0
	while flag and i<noOfHeadlines
		ar = objLst.item(i).text
		kwords = Split(ar, " ")
		nullfound = FALSE
		For j=0 to UBound(kwords)
			if InStr(Description, lcase(kwords(j)))=0 then
				nullfound = TRUE
				j=UBound(kwords)
			end if
		Next
		if not nullfound then
			Solution = objSlt.item(i).text
			flag = 0 
		end if	
		i = i+1
	wend
%>
</form>
<p align=center><font size=+2>ASP <%="Ocorreu o erro…"%></font></p>
<table border="0" cellpadding="3" cellspacing="1" width="700" bgcolor="#000000" align="center">
<tr><td bgcolor="#ccccff" colspan=2 align=middle><font size=+1><b><%="Informações Técnicas" %></b></font></td></tr>
<tr bgcolor="#cccccc"><td width=130 bgcolor="#ccccff"><b>Error number</b></td><td align="left"><%=Err.Number%></td></tr>
<tr bgcolor="#cccccc"><td bgcolor="#ccccff"><b><%="Descrição do Erro" %></b></td><td align="left"><font color=#cc3300><%=Err.Description%></font></td></tr>
<tr bgcolor="#cccccc"><td bgcolor="#ccccff"><b><%="URL" %></b></td><td align="left"><%=Request.ServerVariables("URL")%></td></tr>
<% if strSQL<>"" then %>
<tr bgcolor="#cccccc"><td bgcolor="#ccccff" ><b><%="Consulta de SQL" %></b></td><td align="left"><%=strSQL%></td></tr>
<% end if %>
<% if strMoreInfo<>"" then %>
<tr bgcolor="#cccccc"><td bgcolor="#ccccff" ><b>Additional info</b></td><td align="left"><%=strMoreInfo%></td></tr>
<% end if %>
<tr bgcolor="#cccccc"><td bgcolor="#ccccff"><b>Solution</b></td><td align="left"><%=Solution%></td></tr>
</table>
    <form target=_new action="http://www.xlinesoft.com/asprunner/errors/default.asp" method="post" name="frmerror">
	<input type='hidden' name='ErrorNumber' value="<%=Err.Number%>" />
	<input type='hidden' name='Description' value="<%=Err.Description%>" />
	<input type='hidden' name='SQL' value="<%=dSQL%>" />
    </form>
<p align=center>
<a href="#" onClick="document.forms.frmerror.submit();return false;"><font size=3><b>More info on this error</b></font></a>
</p>

<%
	Response.End
end if
end sub

sub AddDict(dict,key, value)
	if dict.Exists(key) then
		dict(key)=value
	else
		dict.add key,value
	end if
end sub

function jsreplace(str)
	jsreplace = replace(str,"\","\\")
	jsreplace = replace(jsreplace,vbcr,"\r")
	jsreplace = replace(jsreplace,vblf,"\n")
	jsreplace = replace(jsreplace,"'","\'")
end function
Sub DeleteUploadedFiles(where)

	dim i
	set rsTmp = Server.CreateObject("ADODB.Recordset")
	rsTmp.Open "select * from " & strOriginalTableName & " where " & where, dbConnection
	if not rsTmp.Eof then
		for i=0 to rsTmp.Fields.Count-1
			if GetEditFormat(rsTmp.Fields(i).Name, strTableName)=EDIT_FORMAT_FILE then 
				DeleteFile Server.MapPath(GetUploadFolder(rsTmp.Fields(i).Name, strTableName) & rsTmp(rsTmp.Fields(i).Name))
			end if
		next	
			rsTmp.Close
			set rsTmp = Nothing
	end if


End Sub

Function IsUpdatable(Field)

		if Field.Attributes and 4 or Field.Attributes and 8 then
			IsUpdatable=true
		else
			IsUpdatable=false
		end if		

End Function

Function FormExists(Name)
	for x = 1 to Request.Form.count() 
        if Request.Form.key(x) = Name then
			FormExists = True
			Exit Function
		end if
    next 

	FormExists = False
End Function	

function CreateThumbnail(value, size, ext)
	dim jpeg
	SafeCreateObject "Persits.Jpeg", jpeg
	if isnull(jpeg) then
		CreateThumbnail=value
		exit function
	end if
	on error resume next
	Jpeg.OpenBinary value
	if err.number<>0 then
		CreateThumbnail=value
		on error goto 0
		exit function
	end if
	on error goto 0
	dim sx,sy
	sx = Jpeg.OriginalWidth
	sy = Jpeg.OriginalHeight
	if sx<=size and sy<=size or sx=0 or sy=0 then
		CreateThumbnail=value
		exit function
	end if
	if sx>=sy then
		jpeg.Height=sy*size/sx
		jpeg.Width=size
	else
		jpeg.Width=sx*size/sy
		jpeg.Height=size
	end if

	dim ret
	CreateThumbnail=Jpeg.Binary
end function

sub SafeCreateObject(name,object)
	on error resume next
	set object = server.CreateObject(name)
	if err.Number<>0 then
		object=null
	end if
	on error goto 0
end sub

Function loadSelectContent(field, value)
	dim output, objDict, numDictEl

	Lookup = ""
	output = ""
	set objDict = Server.CreateObject("Scripting.Dictionary") 
	numDictEl = 0


	Set rsa = server.CreateObject("ADODB.Recordset")
	rsa.open LookupSQL,dbConnection

	do while not rsa.EOF
		for each fld in rsa.fields
			objDict.Add numDictEl, fld.value
			numDictEl = numDictEl + 1
		next
		rsa.MoveNext
	loop
	rsa.Close	

	loadSelectContent = objDict.Items
End Function

Function xmlencode(str)

	out=""
	l=len(str)
	ind=1
	for i=1 to l
		if Asc(Mid(str,i,1))>=128 then
			out = out & "&#" & Asc(Mid(str,i,1)) & ";"
			if ind<i then out = out & Mid(str,ind,i-ind)
			ind=i+1
		end if
	next

	if ind<=l then	out = out & Mid(str,ind)
	xmlencode = Replace(out, "'","&apos;")

End Function

Function ParseParams(str)
	
	Set params = CreateObject("Scripting.Dictionary")

	ind=1
	start=1
	while ind<Len(str)
		if Mid(str,ind,1) = "=" then
			name = Trim(Mid(str, start, ind-start))
			value = ""
			t = ind+1
			q=0  ' number of quotes
			s=0  ' number of spaces
			do while t<=len(str)
				if Mid(str,t,1)= """" then q = q + 1	
	                        if Mid(str,t,1)= " " then s = s + 1	
				if q=2 or s=1 or t=len(str) then 
					value = Mid(str, ind+1, t-ind)
					if Left(value,1)= """" then value = Mid(value,2)
					if Right(value,1)= """" then value = Left(value, Len(value)-1)
					ind = t
					start = t+1
					exit do
				end if
				t = t + 1
			loop
	
			if value<>"" then
				params.add name, trim(value)
				name=""
			end if
		end if
		ind = ind + 1
	wend 
	
	
	Set ParseParams = params
End Function

Function GetChartType(shorttable)

	GetChartType = ""
End Function

%>
