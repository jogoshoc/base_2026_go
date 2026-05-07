<%
crlf = chr(13) & chr(10)

function StrWhere(strField, psSearchFor, strSearchOption, psSearchFor2, sSearchType)


	
	if Request.Form("NeedQuotes" & BuildFieldName(strField))="" then 
		bNeedQ = IfNeedQuotes(GetFieldType(strTableName, strField))
	else
		if Request.Form("NeedQuotes" & BuildFieldName(strField)) = "True" then
			bNeedQ = true 
		else
			bNeedQ = false
		end if
	end if
	
	StrWhere = PrepareSearchField(strField, strSearchOption) & " "

	if bNeedQ and not IsDateFieldType(GetFieldType(strTableName, strField)) and IsSortableField(GetFieldType(strTableName, strField)) then
		StrWhere = DBUpper(StrWhere)
	end if

	sSearchFor=Replace(psSearchFor,"'","''")
	sSearchFor2=Replace(psSearchFor2,"'","''")	
	
	strQuote1 = "'"
	strQuote2 = "'"

	' date fields
	if IsDateFieldType(GetFieldType(strTableName, strField)) then 
		if GetDatabaseType() = DATABASE_Access or InStr(1, strConnection, "dBase Driver") > 0 then
				strQuote1="#"
				strQuote2="#"
		elseif InStr(1, strConnection, "*.dbf") > 0 then
				strQuote1="{"
				strQuote2="}"
		end if
		
		if sSearchType = "Basic" then
			if IsDate(sSearchFor) then
				sSearchFor = CDate(sSearchFor)
				sSearchFor = Year(sSearchFor) & "-" & iif(Month(sSearchFor)<10, "0", "") & Month(sSearchFor) & "-" & iif(Day(sSearchFor)<10, "0", "") & Day(sSearchFor)
				
			else
				if strSearchOption<>"Contains" and strSearchOption<>"Starts with ..." and strSearchOption<>"IsNull" then
					StrWhere = ""
					Exit Function			
				end if
			end if
		
		else
			
			' check parameters to be valid date values
			DateFormat = DateEditType(strField)
			if FormatDbDate(sSearchFor, DateFormat)<>"" and (sSearchFor2="" or sSearchFor2="0-0-0" or FormatDbDate(sSearchFor2, DateFormat)<>"") then
				sSearchFor = FormatDbDate(sSearchFor, DateFormat)  
				sSearchFor2 = FormatDbDate(sSearchFor2, DateFormat)  
			else
				if strSearchOption<>"Contains" and strSearchOption<>"Starts with ..." and strSearchOption<>"IsNull" then
					StrWhere = ""
					Exit Function
				end if
			end if

		
		end if
		if strSearchOption<>"Contains" and strSearchOption<>"Starts with ..." then
			sSearchFor = strQuote1 & sSearchFor & strQuote2
			sSearchFor2 = strQuote1 & sSearchFor2 & strQuote2
		end if
		
	end if

' IMAGE/TEXT/NTEXT fields
	if not IsSortableField(GetFieldType(strTableName, strField)) and strSearchOption<>"IsNull" and _
		strSearchOption<>"Contains" and strSearchOption<>"Starts with ..." then			
			StrWhere = ""
			Exit Function	
	end if



	if bNeedQ and strSearchOption<>"Contains" and strSearchOption<>"Starts with ..." and not IsDateFieldType(GetFieldType(strTableName, strField)) then
		sSearchFor=DBUpper(strQuote1 & Replace(sSearchFor,"'","''") & strQuote2) 
		sSearchFor2=DBUpper(strQuote1 & Replace(sSearchFor2,"'","''") & strQuote2) 
	end if
	if not bNeedQ and strSearchOption<>"Contains" and strSearchOption<>"Starts with ..." then
		sSearchFor= CStr(CSmartDbl(sSearchFor)) 
		if sSearchFor2<>"" then sSearchFor2= CStr(CSmartDbl(sSearchFor2)) end if
	end if

	Select Case strSearchOption
	      Case "Contains"			StrWhere = StrWhere &  " like " & DbUpper( "'%" & sSearchFor & "%'")
	      Case "Equals"			StrWhere = StrWhere &  "=" & sSearchFor 
	      Case "Starts with ..."		StrWhere = StrWhere &  " like " & DbUpper( "'" & sSearchFor & "%'" )
	      Case "More than ..."		StrWhere = StrWhere &  ">" & sSearchFor
	      Case "Less than ..."		StrWhere = StrWhere &  "<" & sSearchFor
	      Case "Equal or more than ..."	StrWhere = StrWhere &  ">=" & sSearchFor
	      Case "Equal or less than ..."	StrWhere = StrWhere &  "<=" & sSearchFor
	      Case "Between" 
	      		StrWhere = StrWhere &  ">=" & sSearchFor 
	      		if sSearchFor2<>"" then  StrWhere = StrWhere & " and " & GetFullFieldName(strTableName,strField) & "<=" & sSearchFor2
	      Case "IsNull"
			StrWhere = StrWhere & " is null "
			if bNeedQ and not IsDateFieldType(GetFieldType(strTableName, strField)) and IsSortableField(GetFieldType(strTableName, strField)) then 
				StrWhere = StrWhere & " or " & PrepareSearchField(strField, strSearchOption) & "=''"
			end if
			strWhere = " (" & strWhere & ") "
	End Select

end function


Function PrepareSearchField(strField, strSearchOption)

PrepareSearchField = GetFullFieldName(strTableName,strField)

if IsMoneyField(GetFieldType(strTableName, strField)) and _ 
	(strSearchOption="Contains" or strSearchOption="Starts with ...") then
		PrepareSearchField = "CAST(" & PrepareSearchField & " AS VARCHAR(20))"
end if

End Function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function IsDateFieldType(nType)

	if nType=7 or nType=133 or nType=134 or nType=135 then 
		IsDateFieldType = True
	else
		IsDateFieldType = False
	end if

end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function IsGUIDField(nType)

	if nType=72 then 
		return True
	else
		return False
	end if

end function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

function IsBinaryField(Field)

if (Field.Attributes and 128) and ( Field.Type = 204 or Field.Type = 205 ) then
	IsBinaryField = True
else
	IsBinaryField = False
end if

End Function

Function IsFloat(nType)

	IsFloat = false
	if nType=14 or nType=5 or nType=131 then IsFloat=true end if

End Function

function IsSortableField(nType)

if nType = 128 or nType = 201 or (nType>=203 and nType <= 205) then
	IsSortableField = False
else
	IsSortableField = True
end if

End Function

Function IsMoneyField(nType)
	if GetDatabaseType()=DATABASE_MSSQLServer and nType = 14 then
		IsMoneyField = True
	else
		IsMoneyField = False	
	end if

End Function


function GetData(Field, Format)

' long binary data?
if IsBinaryField(Field) then
	GetData = "LONG BINARY DATA - CANNOT BE DISPLAYED" 
elseif Field.Type = 11 then
	if IsNull(Field.Value) then
		GetData="No"
	else
		if Field.Value = "True" or CLng(Field.Value)<>0 then 
			GetData = "Yes"
		else 
			GetData = "No"
		end if
	end if
else 
	if Field.Type <> 205 then
            if Field.Type=19 then
            	GetData = CLng(Field.Value)
            else
            	GetData = Field.Value 
            end if
	end if
end if

if isnull(GetData) then 
  GetData=""
else
  GetData=CStr(GetData)
end if

if Format = FORMAT_DATE_SHORT	and GetData<>"" _ 
	then GetData = FormatDateTime(GetData,2) 
if Format = FORMAT_DATE_LONG	and GetData<>"" _ 
	then GetData = FormatDateTime(GetData,1) 
if Format = FORMAT_DATE_TIME	and GetData<>"" _ 
	then GetData = FormatDateTime(GetData,0)
if Format = FORMAT_CURRENCY and GetData<>"" _ 
 	then GetData = FormatCurrency(GetData)
if Format = FORMAT_PERCENT and GetData<>"" and IsNumeric(GetData) _ 
 	then GetData = CDBL(GetData)*100 & "%"
if Format = FORMAT_NUMBER and GetData<>"" and IsNumeric(GetData) _ 
 	then GetData = FormatNumber(CDbl(GetData), 2)
if Format = FORMAT_CHECKBOX then 
	checked="no"
	if LCase(GetData)="yes" or (IsNumeric(GetData) and GetData<>"0") or LCase(GetData)="true" or LCase(GetData)="on" then checked="yes"
	GetData = "<img src=""images/check_" & checked & ".gif"" border=0>"
end if
if Format = FORMAT_PHONE_NUMBER and GetData<>"" then
 	if Len(GetData)=7 then
		GetData = Left(GetData,3) & "-" & Mid(GetData, 4)
	elseif Len(GetData)=10 then
		GetData = "(" & Left(GetData,3) & ") " & Mid(GetData, 4, 3) & "-" & Mid(GetData, 7)	
	end if
end if

' file-based image
if Format = FORMAT_FILE_IMAGE	then 

	if IsSafeImageExt(GetData) then
		GetData = "<img src=""" & AddLinkPrefix(strTableName, Field.Name,GetData) & """ border=0>"
	else
		GetData = ""
	end if

end if	

' document download
if Format = FORMAT_FILE	then 

	if isObject(rs) then
		key=""
		if strKeyField<>"" then key = GetData(rs.Fields(strKeyField), "")
		key2=""
		if strKeyField2<>"" then key2 = GetData(rs.Fields(strKeyField2), "")
		key3=""
		if strKeyField3<>"" then key3 = GetData(rs.Fields(strKeyField3), "")

		strImageWhere = " " & KeyWhere(key,key2,key3)
		GetData = "<a href=""##SHORTTABLENAME##_download.asp?fieldname=" & _ 
			Server.URLEncode(Field.Name) & "&where=" & Server.URLEncode(strImageWhere) & """>" & GetData & "</a>"
	else
		' master table case
		strImageWhere = " " & GetFullFieldName("##MASTERTABLENAME##","##MASTERKEY##") & "=" & Request("masterkey")
		GetData = "<a href=""##MASTERTABLEURL##_download.asp?fieldname=" & _ 
			Server.URLEncode(Field.Name) & "&where=" & Server.URLEncode(strImageWhere) & """>" & GetData & "</a>"
	end if	
			
end if
	
' hyperlink

if ((Field.Type=203 and Right(GetData,1)="#") and Format<>FORMAT_NONE ) _
	or Format = FORMAT_HYPERLINK	then

	str = GetData
	if isObject(rs) then
		GetData = GetHyperlink(rs, str, Field.Name, strTableName)
	else
		GetData = GetHyperlink(rsMaster, str, Field.Name, "##MASTERTABLENAME##")
	end if
	
end if

' email
if Format = FORMAT_EMAILHYPERLINK then		
	str = GetData

	' mailto hyperlink	
	if Left(str,7)="mailto:" then 
		strTitle = Mid(str,8)
	else
		strTitle = str
		str = "mailto:" & str
	end if
	
	GetData = "<a href=""" & str & """>" & strTitle & "</a>"
end if

'	if Format = FORMAT_NONE then _
'		GetData = HTMLEncode(GetData)
	
end function


function IsListField(strField)

IsListField = false

	 ##LISTFIELDS##if strField="##FIELD##" then IsListField = true end if 
	 ##/LISTFIELDS##

end function


' returns field label
function Label(strField)

	Label = strField
	##ALLFIELDS## if strField="##FIELD##" then Label = "##LABEL##" end if 
	##/ALLFIELDS##

end function

' returns field format
function Format(strField)

	Format = FORMAT_NONE
	##ALLFIELDS## if strField="##FIELD##" then Format = "##FORMAT##" end if 
	##/ALLFIELDS##

end function

' returns true if field is required
function IsRequired(strField)

	IsRequired = False
	##ALLFIELDS## if strField="##FIELD##" then IsRequired = "##ISREQUIRED##" end if 
	##/ALLFIELDS##

end function


' returns edit format
function GetEditFormat(strField)

	GetEditFormat = FORMAT_NONE
	##ALLFIELDS## if strField="##FIELD##" then GetEditFormat = "##EDITFORMAT##" end if 
	##/ALLFIELDS##

end function

' returns true if textarea uses RichTextEditor
Function UseRTE(strField)
	UseRTE = false
	##ALLFIELDS## if strField="##FIELD##" then UseRTE = ##USE_RTE## end if 
	##/ALLFIELDS##
End Function

' returns true if field format equals FORMAT_LOOKUP_WIZARD
function IsLookupField(strField)

	IsLookupField = false
	if Format(strField)=FORMAT_LOOKUP_WIZARD then 
		IsLookupField = true 
	end if 
end function


' returns Date Edit type
function DateEditType(strField)

	DateEditType = ""
	##ALLFIELDS## if strField="##FIELD##" then DateEditType = ##DATEEDITTYPE## end if 
	##/ALLFIELDS##

end function

function DateEditShowTime(strField)

	DateEditShowTime = ""
	##ALLFIELDS## if strField="##FIELD##" then DateEditShowTime = ##DATEEDITSHOWTIME## end if 
	##/ALLFIELDS##

end function


' returns text edit parameters
function GetEditParams(strField)
	##TEXTFIELDS## if strField="##FIELD##" then GetEditParams= "##EDITPARAMS##" end if 
	##/TEXTFIELDS##
end function

function IsSafeImageExt(strName)
	sExt = UCase(Right(Trim(strName),3))
	if sExt="JPG" or sExt="PEG" or sExt="GIF" or sExt="PNG" or sExt="BMP" then
		IsSafeImageExt = true
	else
		IsSafeImageExt = false
	end if
end function

' returns field's default value
function GetDefaultValue(strField)
	##ALLFIELDS## if strField="##FIELD##" then GetDefaultValue = ##DEFAULTVALUE## end if 
	##/ALLFIELDS##
	if LCase(GetDefaultValue) = "now()" then GetDefaultValue=now() end if
	if Len(GetDefaultValue)>2 then
		if Left(GetDefaultValue,1) = "'" and Right(GetDefaultValue,1)="'" then GetDefaultValue=Mid(GetDefaultValue,2, Len(GetDefaultValue)-2) end if
	end if
end function


Sub LogInfo(str)
if vDebug=true then
	Response.Write str & "<br>"
	if response.buffer then
		Response.Flush 
	end if
end if

end sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' returns True if Field type is Date, False otherwise
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function IsDateField(Field)

      nType = Field.Type
      		
      if nType = 7 or nType = 133 or nType = 134 or nType = 135 then
      	IsDateField = True
      else
      	IsDateField = False
      end if

End Function


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' returns HTML code that represents required Date edit control
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function GetDateEdit(FieldName, FieldValue, cType, OrigFieldName)
	
	strName = ""
	For index=1 to Len(FieldName)
		c = LCase(Mid(FieldName,index,1))
	   if (Asc(c)>=Asc("a") and Asc(c)<=Asc("z")) or ( Asc(c)>=Asc("0") and Asc(c)<=Asc("9")) then _
			strName = strName & c
	Next 
	
	if Len(strName) = 0 then Exit Function
			if (IsDate(FieldValue)) then
				dDate = CDate(FieldValue)
				d = Day(dDate)
				m = Month(dDate)
				y = Year(dDate)
				h = Hour(dDate)
				mi = Minute(dDate)
				s = Second(dDate)
			else
				d = 0
				m = 0
				y = 0
				h = 0
				mi = 0
				s = 0
			end if
		
   
	  if cType = EDIT_DATE_SIMPLE_DDMMYYYY_DP or cType = EDIT_DATE_SIMPLE_MMDDYYYY_DP then
			GetDateEdit = "<input type=text name=""" & FieldName & """ size = 20 value=""" & FieldValue & """>" 

			ovalue=""
			delimiter = "/"
			if cType=EDIT_DATE_SIMPLE_DDMMYYYY_DP then
				sundayfirst="false"
				dmy="true"
				fmt=1
			else
				sundayfirst="true"
				dmy="false"
				fmt=2
			end if
			withtime=false
			showtime="false"
			if DateEditShowTime(OrigFieldName) then
				withtime=true
				showtime="true"
			end if
			if d>0 then
				ovalue = format_datetime_custom(dDate,fmt,withtime)
				ovalue1 = format_datetime_custom(dDate,3,withtime)
			else
				ovalue1="0-0-0"
			end if
			onblur="var dt=parse_datetime(this.value," & dmy & "); if(dt!=null) document.forms.editform.ts" & strName & ".value=print_datetime(dt,0," & showtime & "); else document.forms.editform.ts" & strName & ".value='';"

			GetDateEdit = "<input type=""Text"" name=""" & FieldName & """ size = ""20"" value=""" & ovalue & """ onblur=""" & onblur & """>"
			GetDateEdit = GetDateEdit & "<input type=""Hidden"" name=""ts" & strName & """ value=""" & ovalue1 & """>&nbsp;&nbsp;"
			GetDateEdit = GetDateEdit & "<a href=""javascript:var v=show_calendar('update" & strName & "', document.forms.editform.ts" & strName &".value," & showtime & "," & sundayfirst &");"">" & _
				"<img src=""images/cal.gif"" width=16 height=16 border=0 alt=""" & ##SCRIPTMESSAGE(PICKUP_DATE)## & """></a>"
			GetDateEdit = GetDateEdit & "<script language=JavaScript>" & _
				"	function update" & strName & "(newDate) " & _
				"{ "
			if cType=EDIT_DATE_SIMPLE_DDMMYYYY_DP then
				GetDateEdit = GetDateEdit & "		document.forms.editform.elements['" & FieldName &"'].value =  print_datetime(newDate,1," & showtime &");"
			else
				GetDateEdit = GetDateEdit & "		document.forms.editform.elements['" & FieldName &"'].value =  print_datetime(newDate,2," & showtime &");"
			end if
			GetDateEdit = GetDateEdit & "		document.forms.editform.ts" & strName &".value =  print_datetime(newDate,0," & showtime &");"
			GetDateEdit = GetDateEdit & "	}</script>"
	

	  elseif cType = EDIT_DATE_DDMMYYYY_DP or cType = EDIT_DATE_MMDDYYYY_DP _
	  	 or  cType = EDIT_DATE_DDMMYYYY or cType = EDIT_DATE_MMDDYYYY then
			dp=true
			if cType=EDIT_DATE_DDMMYYYY or cType=EDIT_DATE_DDMMYYYY then
				dp=false
			end if

			if d>0 then
				ovalue = format_datetime_custom(dDate,0,false)
			else
				ovalue="0-0-0"
			end if
			ovalue1 = d & "-" & m & "-" & y
			retday="<select class=selects name=""day" & strName &""" onchange=""javascript: SetDate" & strName & "(); return true;"">" &_
				WriteDays(Now(),d) & "</select>"
			
			retmonth="<select class=selects name=""month" & strName &""" onchange=""javascript: SetDate" & strName & "(); return true;"">" &_
				WriteMonths(Now(),m) & "</select>"

			if cType=EDIT_DATE_DDMMYYYY or cType=EDIT_DATE_DDMMYYYY_DP then
				GetDateEdit = retday & "&nbsp;" & retmonth & "&nbsp;"
				sundayfirst="false"
			else
				GetDateEdit = retmonth & "&nbsp;" & retday & "&nbsp;"
				sundayfirst="true"
			end if
			GetDateEdit = GetDateEdit & "<select class=selects name=""year" & strName & """ onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteYears(now(),y) & "</select>"
			GetDateEdit = GetDateEdit & "<input type=hidden name=""" & FieldName & """ value=""" & ovalue & """>"
			if dp then
				GetDateEdit = GetDateEdit & "<input type=hidden name=""ts" & strName & """ value=""" & ovalue1 & """>&nbsp;" & _
					"<a href=""javascript:var v=show_calendar('update" & strName & "', document.forms.editform.ts" & strName & ".value,false," & sundayfirst & ");"">" & _
					"<img src=images/cal.gif width=16 height=16 border=0 alt=""" & ##SCRIPTMESSAGE(PICKUP_DATE)## & """></a>"
			end if
			GetDateEdit = GetDateEdit & "<script language=JavaScript>" & _
				"function SetDate" & strName & "()" & _
				"{ " & _
				"  if (document.forms.editform.month" & strName & ".value!='' && document.forms.editform.day" & strName & ".value!='' && document.forms.editform.year" & strName & ".value!='') {" & _
				"	document.forms.editform.elements['" & FieldName & "'].value= ''+document.forms.editform.year" & strName & ".value + " & _
				" 	'-' + document.forms.editform.month" & strName & ".value + '-' + document.forms.editform.day" & strName & ".value; "
			if dp then
				GetDateEdit = GetDateEdit & "   document.forms.editform.ts" & strName & ".value='' + document.forms.editform.day" & strName & ".value+'-'+document.forms.editform.month" & strName & ".value+'-'+document.forms.editform.year" & strName & ".value;"
			end if
			GetDateEdit = GetDateEdit & "  } else {"
			if dp then
				GetDateEdit = GetDateEdit & "	document.forms.editform.ts" & strName & ".value= '" & ovalue & "';"
			end if
			GetDateEdit = GetDateEdit & "	document.forms.editform.elements['" & FieldName & "'].value= '';"& _
				"   } "& _
				" } "& _
				" SetDate" & strName & "(); "
			if dp then
				GetDateEdit = GetDateEdit & "	function update" & strName & "(newDate) "& _
				"{ "& _
				"	var dt_datetime; "& _
				" 	var curdate = new Date(); "& _
				"		dt_datetime = newDate;"& _
				"		document.forms.editform.elements['" & FieldName & "'].value =  dt_datetime.getFullYear() + '-' + (dt_datetime.getMonth()+1) + '-' + dt_datetime.getDate();" & _
				"		document.forms.editform.day" & strName & ".selectedIndex = dt_datetime.getDate();" & _
				"		document.forms.editform.month" & strName & ".selectedIndex = dt_datetime.getMonth()+1;" & _
				"		for(i=0; i<document.forms.editform.year" & strName & ".options.length;i++)"&_
				"			if(document.forms.editform.year" & strName & ".options[i].value==dt_datetime.getFullYear())"&_
				"			{"&_
				"				document.forms.editform.year" & strName & ".selectedIndex=i;"&_
				"				break;"&_
				"			}"&_
				"  	document.forms.editform.ts" & strName & ".value = dt_datetime.getDate() + '-' + (dt_datetime.getMonth()+1) + '-' + dt_datetime.getFullYear();" & _
				"	}"
			end if
			GetDateEdit = GetDateEdit & " </script>"
	else
			GetDateEdit = "<input type=text name=""" & FieldName & """ size = 20 value=""" & FieldValue & """>" 
	end if

End Function

Function GetDateEditOld(FieldName, FieldValue, cType)
	
	strName = ""
	For index=1 to Len(FieldName)
		c = LCase(Mid(FieldName,index,1))
	   if (Asc(c)>=Asc("a") and Asc(c)<=Asc("z")) or ( Asc(c)>=Asc("0") and Asc(c)<=Asc("9")) then _
			strName = strName & c
	Next 
	
	if Len(strName) = 0 then Exit Function
			if (IsDate(FieldValue)) then
				dDate = CDate(FieldValue)
				d = Day(dDate)
				m = Month(dDate)
				y = Year(dDate)
			else
				d = 0
				m = 0
				y = 0
			end if
		
   Select Case cType
      Case EDIT_DATE_SIMPLE     
			GetDateEdit = "<input type=text name=""" & FieldName & """ size = 20 value=""" & FieldValue & """>" 

      Case EDIT_DATE_SIMPLE_DDMMYYYY_DP	   
			GetDateEdit = "<input type=text name=""" & FieldName & """ size = 20 value=""" & FieldValue & """>" 
			GetDateEdit = GetDateEdit & "<input type=hidden name=""ts" & strName & """ value=""" & d & "-" & m & "-" & y & """>"
			GetDateEdit = GetDateEdit & "<a href=""javascript:var v=show_calendar('update" & strName & "', document.forms.editform.ts" & strName & ".value);"">" & _
				"<img src=images/cal.gif width=16 height=16 border=0 alt=""" & ##SCRIPTMESSAGE(PICKUP_DATE)## & """></a>"

			GetDateEdit = GetDateEdit & vbCRLF & vbCRLF & "<script language=JavaScript>" & _
				"	function update" & strName & "(newDate) " & _
				"{ " & _
				"	var dt_datetime; " & _
				"	if (newDate!='' && newDate!=null)" & _
				"	{ " & _
				"		dt_datetime = str2dt(newDate);" & _
				"		document.forms.editform.elements['" & FieldName & "'].value =  dt_datetime.getDate() + '/' + (dt_datetime.getMonth()+1) + '/' + dt_datetime.getFullYear();" & _
				"  	document.forms.editform.ts" & strName & ".value = newDate; " & _
				"	}" & _
				"}" & _ 
				"</script>" & vbCRLF & vbCRLF

      Case EDIT_DATE_SIMPLE_MMDDYYYY_DP	   
			GetDateEdit = "<input type=text name=""" & FieldName & """ size = 20 value=""" & FieldValue & """>" 
			GetDateEdit = GetDateEdit & "<input type=hidden name=""ts" & strName & """ value=""" & d & "-" & m & "-" & y & """>"
			GetDateEdit = GetDateEdit & "<a href=""javascript:var v=show_calendar('update" & strName & "', document.forms.editform.ts" & strName & ".value);"">" & _
				"<img src=images/cal.gif width=16 height=16 border=0 alt=""" & ##SCRIPTMESSAGE(PICKUP_DATE)## & """></a>"

			GetDateEdit = GetDateEdit & vbCRLF & vbCRLF & "<script language=JavaScript>" & _
				"	function update" & strName & "(newDate) " & _
				"{ " & _
				"	var dt_datetime; " & _
				"	if (newDate!='' && newDate!=null)" & _
				"	{ " & _
				"		dt_datetime = str2dt(newDate);" & _
				"		document.forms.editform.elements['" & FieldName & "'].value = (dt_datetime.getMonth()+1) + '/' + dt_datetime.getDate() + '/' + dt_datetime.getFullYear();" & _
				"  	document.forms.editform.ts" & strName & ".value = newDate; " & _
				"	}" & _
				"}" & _ 
				"</script>" & vbCRLF & vbCRLF

		Case EDIT_DATE_DDMMYYYY
			
			GetDateEdit = "<select class=selects name=day" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteDays(Now(), d)
			GetDateEdit = GetDateEdit & "</select>"
			
			GetDateEdit = GetDateEdit & "<select name=month" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteMonths(Now(), m)
			GetDateEdit = GetDateEdit & "</select>"

			GetDateEdit = GetDateEdit & "<select class=selects name=year" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteYears(Now(), y)
			GetDateEdit = GetDateEdit & "</select>" & vbCRLF

			GetDateEdit = GetDateEdit & "<input type=hidden name=""" & FieldName & """ value=""" &  y & "-" & m & "-" & d  & """>" 

		GetDateEdit = GetDateEdit & "<script language=JavaScript>" & _
		"function SetDate" & strName & "()" & _
		"{ " & _ 
		"  if (document.forms.editform.month" & strName & ".value!='' && document.forms.editform.day" & strName & ".value!='' && document.forms.editform.year" & strName & ".value!='')" & _
		"	document.forms.editform.elements['" & FieldName & "'].value= ''+document.forms.editform.year" & strName & ".value + " & _
		" 	'-' + document.forms.editform.month" & strName & ".value + '-' + document.forms.editform.day" & strName & ".value; " & _
		"  else " & _
		"	document.forms.editform.elements['" & FieldName & "'].value= '';" & _
		" } " & _
		" </script>"
		
		Case EDIT_DATE_DDMMYYYY_DP

			GetDateEdit = "<select class=selects name=day" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteDays(Now(), d)
			GetDateEdit = GetDateEdit & "</select>"
			
			GetDateEdit = GetDateEdit & "<select name=month" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteMonths(Now(), m)
			GetDateEdit = GetDateEdit & "</select>"

			GetDateEdit = GetDateEdit & "<select class=selects name=year" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteYears(Now(), y)
			GetDateEdit = GetDateEdit & "</select>" & vbCRLF

			GetDateEdit = GetDateEdit & "<input type=hidden name=""ts" & strName & """ value=""" & d & "-" & m & "-" & y & """>" & vbCRLF
			GetDateEdit = GetDateEdit & "<input type=hidden name=""" & FieldName & """ value=""" &  y & "-" & m & "-" & d  & """>" 
			GetDateEdit = GetDateEdit & "<a href=""javascript:var v=show_calendar('update" & strName & "', document.forms.editform.ts" & strName & ".value);"">" & _
				"<img src=images/cal.gif width=16 height=16 border=0 alt=""" & ##SCRIPTMESSAGE(PICKUP_DATE)## & """></a>"

			GetDateEdit = GetDateEdit & "<script language=JavaScript>" & _
				"	function update" & strName & "(newDate) " & _
				"{ " & _
				"	var dt_datetime; " & _
				" 	var curdate = new Date(); " & _
				"	if (newDate!='' && newDate!=null)" & _
				"	{ " & _
				"		dt_datetime = str2dt(newDate);" & _
				"		document.forms.editform.elements['" & FieldName & "'].value =  dt_datetime.getFullYear() + '-' + (dt_datetime.getMonth()+1) + '-' + dt_datetime.getDate();" & _
				"		document.forms.editform.day" & strName & ".selectedIndex = dt_datetime.getDate();	" & _		
				"		document.forms.editform.month" & strName & ".selectedIndex = dt_datetime.getMonth()+1;	" & _		
				"		document.forms.editform.year" & strName & ".selectedIndex = dt_datetime.getFullYear()-curdate.getFullYear()+51;	" & _		
				"  	document.forms.editform.ts" & strName & ".value = newDate; " & _
				"	}" & _
				"}" & vbCRLF & _ 
		"function SetDate" & strName & "()" & _
		"{ " & _ 
		"  if (document.forms.editform.month" & strName & ".value!='' && document.forms.editform.day" & strName & ".value!='' && document.forms.editform.year" & strName & ".value!='')" & _
		"	document.forms.editform.elements['" & FieldName & "'].value= ''+document.forms.editform.year" & strName & ".value + " & _
		" 	'-' + document.forms.editform.month" & strName & ".value + '-' + document.forms.editform.day" & strName & ".value; " & _
		"  else " & _
		"	document.forms.editform.elements['" & FieldName & "'].value= '';" & _
		" } " & _
		" SetDate" & strName & "(); " & _
		" </script>" & vbCRLF

		Case EDIT_DATE_MMDDYYYY	

			GetDateEdit = "<select name=month" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteMonths(Now(), m)
			GetDateEdit = GetDateEdit & "</select>"

			GetDateEdit = GetDateEdit & "<select class=selects name=day" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteDays(Now(), d)
			GetDateEdit = GetDateEdit & "</select>"
			
			GetDateEdit = GetDateEdit & "<select class=selects name=year" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteYears(Now(), y)
			GetDateEdit = GetDateEdit & "</select>" & vbCRLF

			GetDateEdit = GetDateEdit & "<input type=hidden name=""" & FieldName & """ value=""" & FieldValue & """>" 

		GetDateEdit = GetDateEdit & "<script language=JavaScript>" & _
		"function SetDate" & strName & "()" & _
		"{ " & _ 
		"  if (document.forms.editform.month" & strName & ".value!='' && document.forms.editform.day" & strName & ".value!='' && document.forms.editform.year" & strName & ".value!='')" & _
		"	document.forms.editform.elements['" & FieldName & "'].value= ''+document.forms.editform.year" & strName & ".value + " & _
		" 	'-' + document.forms.editform.month" & strName & ".value + '-' + document.forms.editform.day" & strName & ".value; " & _
		"  else " & _
		"	document.forms.editform.elements['" & FieldName & "'].value= '';" & _
		" } " & _
		" </script>"

		Case EDIT_DATE_MMDDYYYY_DP

			GetDateEdit = "<select name=month" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteMonths(Now(), m)
			GetDateEdit = GetDateEdit & "</select>"

			GetDateEdit = GetDateEdit & "<select class=selects name=day" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteDays(Now(), d)
			GetDateEdit = GetDateEdit & "</select>"
			
			GetDateEdit = GetDateEdit & "<select class=selects name=year" & strName & " onchange=""javascript: SetDate" & strName & "(); return true;"">"
			GetDateEdit = GetDateEdit & WriteYears(Now(), y)
			GetDateEdit = GetDateEdit & "</select>" & vbCRLF

			GetDateEdit = GetDateEdit & "<input type=hidden name=""ts" & strName & """ value=""" & d & "-" & m & "-" & y & """>" & vbCRLF
			GetDateEdit = GetDateEdit & "<input type=hidden name=""" & FieldName & """ value=""" & y & "-" & m & "-" & d & """>" 
			GetDateEdit = GetDateEdit & "<a href=""javascript:var v=show_calendar('update" & strName & "', document.forms.editform.ts" & strName & ".value);"">" & _
				"<img src=images/cal.gif width=16 height=16 border=0 alt=""" & ##SCRIPTMESSAGE(PICKUP_DATE)## & """></a>"

			GetDateEdit = GetDateEdit & "<script language=JavaScript>" & _
				"	function update" & strName & "(newDate) " & _
				"{ " & _
				"	var dt_datetime; " & _
				" 	var curdate = new Date(); " & _
				"	if (newDate!='' && newDate!=null)" & _
				"	{ " & _
				"		dt_datetime = str2dt(newDate);" & _
				"		document.forms.editform.elements['" & FieldName & "'].value =  dt_datetime.getFullYear() + '-' + (dt_datetime.getMonth()+1) + '-' + dt_datetime.getDate();" & _
				"		document.forms.editform.day" & strName & ".selectedIndex = dt_datetime.getDate();	" & _		
				"		document.forms.editform.month" & strName & ".selectedIndex = dt_datetime.getMonth()+1;	" & _		
				"		document.forms.editform.year" & strName & ".selectedIndex = dt_datetime.getFullYear()-curdate.getFullYear()+51;	" & _		
				"  	document.forms.editform.ts" & strName & ".value = newDate; " & _
				"	}" & _
				"}" & vbCRLF & _ 
		"function SetDate" & strName & "()" & _
		"{ " & _ 
		"  if (document.forms.editform.month" & strName & ".value!='' && document.forms.editform.day" & strName & ".value!='' && document.forms.editform.year" & strName & ".value!='')" & _
		"	document.forms.editform.elements['" & FieldName & "'].value= ''+document.forms.editform.year" & strName & ".value + " & _
		" 	'-' + document.forms.editform.month" & strName & ".value + '-' + document.forms.editform.day" & strName & ".value; " & _
		"  else " & _
		"	document.forms.editform.elements['" & FieldName & "'].value= '';" & _
		" } " & _
		" </script>" & vbCRLF

		Case Else
			GetDateEdit = "<input type=text name=""" & FieldName & """ size = 20 value=""" & FieldValue & """>" 
   End Select
	


End Function



Function WriteDays(d, f)
if f="" then
	val=0
else
	val=CLng(f)
end if

WriteDays = WriteDays & "<option value=""""> </option>"
for x=1 to 31
	if x=val then 
		WriteDays = WriteDays & "<option value=" & x & " selected>" & x & "</option>"
	else
		WriteDays = WriteDays & "<option value=" & x & ">" & x & "</option>"
	end if
next
end function

Function WriteMonths(d, f)
if f="" then
	val=0
else
	val=CLng(f)
end if
WriteMonths = WriteMonths & "<option value=""""> </option>"
for x=1 to 12
	if x=val then 
		WriteMonths = WriteMonths & "<option value=" & x & " selected>" & HRMonth(x) & "</option>"
	else
		WriteMonths = WriteMonths & "<option value=" & x & ">" & HRMonth(x) & "</option>"
	end if
next
end Function 


Function WriteYears(d, f)
if f="" then
	val=0
else
	val=CLng(f)
end if
WriteYears = WriteYears & "<option value=""""> </option>"
for x=Year(d)-50 to Year(d)+50
	if x=val then 
		WriteYears = WriteYears & "<option value=" & x & " selected>" & x & "</option>"
	else
		WriteYears = WriteYears & "<option value=" & x & ">" & x & "</option>"
	end if
next
end Function 

function HRMonth(i)

if i=1 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_JAN)##
if i=2 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_FEB)##
if i=3 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_MAR)##
if i=4 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_APR)##
if i=5 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_MAY)##
if i=6 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_JUN)##
if i=7 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_JUL)##
if i=8 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_AUG)##
if i=9 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_SEP)##
if i=10 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_OCT)##
if i=11 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_NOV)##
if i=12 then _
	HRMonth=##SCRIPTMESSAGE(MONTH_DEC)##
end function




Function BuildSelectControl(strName, strValue, bAdd)

	Set rsTemp = server.CreateObject ("ADODB.Recordset")
##if @BUILDER.strDatabaseType==DATABASE_MySQL || @BUILDER.strDatabaseType==DATABASE_Oracle##
	rsTemp.CursorLocation = 3
##endif##
	strSQL =""
	strSize = 1
	if IsNull(strValue) then strValue=""
	BuildSelectControl = " "

	bAddNewItem = false
	##LOOKUPFIELDS##
		if "##FIELD##" = strName then ##LOOKUPDATA## : strField="##FIELD##" : bAddNewItem = ##ADDNEWITEM## : strLookupTable="##LOOKUPTABLE##" : strLinkField="##LINKFIELD##" : strDisplayField="##DISPLAYFIELD##" end if 
	##/LOOKUPFIELDS##

	Dim arrVal
	sMultiple=""
	if strSize>1 then 
		sMultiple = "multiple"
		arrVal = Split(strValue, ",")
	end if

	if strSQL <> "" then 

      	rsTemp.open strSQL, dbConnection,1, 2
      	
      	if rsTemp.EOF then exit function
		onchange =""
		
##DROPDOWN##
if strName = "##CATEGORY_CONTROL##" then onchange = onchange & "SetSelection('##CATEGORY_CONTROL##', '##FIELD##', this.options[this.selectedIndex].value, '', arr_##GOOD_FIELD##); if (document.forms.editform.elements['##FIELD##'].onchange) document.forms.editform.elements['##FIELD##'].onchange();" end if
##/DROPDOWN##
	if onchange<>"" then onchange = "onchange=""" & onchange & """"
##DROPDOWN##
if strName = "##FIELD##" then
      	Response.Write "<select size = " & strSize & " name=""" & strName & """ " & sMultiple & " " & onchange & ">"
      	Response.Write "</select>"	
		exit function
end if
##/DROPDOWN##

      	Response.Write "<select size = " & strSize & " name=""" & strName & """ " & sMultiple & " " & onchange & ">"
      	' if CLng(strSize)<2 then _
      		Response.Write "<option value=""""></option>"	

      	while not rsTemp.Eof
	   	if not IsNull(rsTemp(0)) and not IsNull(rsTemp(1)) then
        		if Trim(CStr(rsTemp(0)))=Trim(CStr(strValue)) or InArray(arrVal, Trim(CStr(rsTemp(0)))) then 
        			Response.Write "<option value=""" & Server.HTMLEncode(rsTemp(0)) & """ selected>" & Server.HTMLEncode(rsTemp(1)) & "</option>"
        		else
        			Response.Write "<option value=""" & Server.HTMLEncode(rsTemp(0)) & """>" & Server.HTMLEncode(rsTemp(1)) & "</option>"
        		end if
	   	end if
      	   	rsTemp.MoveNext
      	wend

      	Response.Write "</select>"	

      	rsTemp.Close
      	set rsTemp = Nothing
	else
	
      	Response.Write "<select size = " & strSize & " name=""" & strName & """ " & sMultiple & ">"
      	' if CLng(strSize)<2 then _
      		Response.Write "<option value=""""></option>"	

		for ind=LBound(arr) to UBound(arr)
			bYes = false
			if IsNumeric(arr(ind)) then
				if CDbl(arr(ind)) = strValue or InArray(arrVal, CDbl(arr(ind))) then bYes = true
			end if
			if Trim(CStr(arr(ind)))=Trim(CStr(strValue)) or InArray(arrVal, Trim(CStr(arr(ind))) ) or bYes then
		      		Response.Write "<option value=""" & Server.HTMLEncode(arr(ind)) & """ selected>" & Server.HTMLEncode(arr(ind)) & "</option>"	
			else
		      		Response.Write "<option value=""" & Server.HTMLEncode(arr(ind)) & """>" & Server.HTMLEncode(arr(ind)) & "</option>"	
			end if
		next
      	Response.Write "</select>"	

	end if

	' "add new item" link
	if bAddNewItem and bAdd then 
	%>
	
	<a href=# onclick="window.open('##SHORTTABLENAME##_addnewitem.asp?Table=<%=Server.URLEncode(strLookupTable)%>&LinkField=<%=Server.URLEncode(strLinkField)%>&DisplayField=<%=Server.URLEncode(strDisplayField)%>&object=document.editform[\'<%=Server.URLEncode(strField)%>\']', 
			'AddNewItem', 'width=250,height=100,status=no,resizable=yes,top=200,left=200');">
		##PLAINMESSAGE(ADD_NEW)##</a>
		
	<%
	end if
End Function

Function BuildRadioControl(strName, strValue)

	Set rsTemp = server.CreateObject ("ADODB.Recordset")
##if @BUILDER.strDatabaseType==DATABASE_MySQL || @BUILDER.strDatabaseType==DATABASE_Oracle##
	rsTemp.CursorLocation = 3
##endif##
	strSQL =""
	if IsNull(strValue) then strValue=""
	BuildRadioControl=" "
	
	##RADIOFIELDS##
		if "##FIELD##" = strName then ##LOOKUPDATA## end if 
	##/RADIOFIELDS##

	if strSQL <> "" then 

      	rsTemp.open strSQL, dbConnection,1, 2
      	
      	if rsTemp.EOF then exit function
      	Response.Write "<input type=hidden name=""" & strName & """ value=""" & strValue & """>" 	

      	while not rsTemp.Eof
		if not IsNull(rsTemp(0)) and not IsNull(rsTemp(1)) then
        		if Trim(CStr(rsTemp(0)))=Trim(CStr(strValue)) then 
        			Response.Write "<input type=radio name=""radio" & strName & """ checked onclick=""this.form['" & strName & "'].value = '" & Server.HTMLEncode(rsTemp(0)) & "';return true; "">" & Server.HTMLEncode(rsTemp(1)) & "<br>"
        		else
        			Response.Write "<input type=radio name=""radio" & strName & """ onclick=""this.form['" & strName & "'].value = '" & Server.HTMLEncode(rsTemp(0)) & "';return true; "">" & Server.HTMLEncode(rsTemp(1))  & "<br>"
        		end if
		end if
     		rsTemp.MoveNext
      	wend

      	rsTemp.Close
      	set rsTemp = Nothing
	else

	
      	Response.Write "<input type=hidden name=""" & strName & """ value=""" & strValue & """>" 	

		for ind=LBound(arr) to UBound(arr)
			bYes = false
			if IsNumeric(arr(ind)) then
				if CDbl(arr(ind)) = strValue then bYes = true
			end if
			if Trim(CStr(arr(ind)))=Trim(CStr(strValue)) or bYes then
	      			Response.Write "<input type=radio name=""radio" & strName & """ checked onclick=""this.form['" & strName & "'].value = '" & Server.HTMLEncode(arr(ind)) & "';return true; "">" & Server.HTMLEncode(arr(ind))  & "<br>"
      			else
      				Response.Write "<input type=radio name=""radio" & strName & """ onclick=""this.form['" & strName & "'].value = '" & Server.HTMLEncode(arr(ind)) & "';return true; "">" & Server.HTMLEncode(arr(ind))  & "<br>"
	      		end if
		next

	end if


End Function



Function BuildEditControl(Field , sValue, sFormat, sMode)

sFieldName = Field.Name
nType = Field.Type


if Format(sFieldName) <> FORMAT_HTML and sFormat<>EDIT_FORMAT_TEXT_AREA then
	strEncoded = htmlencode(sValue)
else
	strEncoded = sValue
end if

' calculate default value

if sMode = "Add" or sFormat = EDIT_FORMAT_HIDDEN then
	sDefault = HTMLEncode(GetDefaultValue(sFieldName))	
else
	sDefault = strEncoded
end if


BuildEditControl =""

   Select Case sFormat

      Case EDIT_FORMAT_TEXT_FIELD   		
      	BuildEditControl = "<input type=text name=""" & sFieldName  & """"  & GetEditParams(sFieldName) & " value=""" & sDefault & """>"
      Case EDIT_FORMAT_TEXT_AREA   		
	if UseRTE(sFieldName) then
		sDefault = RTESafe(sDefault)
		BuildEditControl = "<script language=""JavaScript"" type=""text/javascript"">" & vbcrlf & _
		"writeRichText('" & sFieldName & "', '" & sDefault & "', 520, 200, true, false);" & vbcrlf & _
		"</script>"
	else
      		BuildEditControl = "<textarea " & GetEditParams(sFieldName) & " name=""" & sFieldName  & """>" & sDefault & "</textarea>"       
	end if
      Case EDIT_FORMAT_PASSWORD   		
	BuildEditControl = "<input type=password name=""" & sFieldName  & """"  & GetEditParams(sFieldName) & " value=""" & sDefault & """>"
      Case EDIT_FORMAT_DATE
	    if sMode = "Add" then
			sDefault = GetDefaultValue(sFieldName)
		end if
      	BuildEditControl = GetDateEdit(sFieldName , sDefault , DateEditType(sFieldName ),sFieldName)
      Case EDIT_FORMAT_RADIO   		
      	BuildEditControl = BuildRadioControl(sFieldName , sDefault)      
      Case EDIT_FORMAT_CHECKBOX   		
		   BuildEditControl = "<input type=checkbox name=""" & sFieldName  & """" 
		    val = Lcase(CStr(sDefault))
			if val="yes" or (IsNumeric(val) and val<>"0") or val="true" or val="on" then BuildEditControl = BuildEditControl & " checked "
			BuildEditControl = BuildEditControl &  ">"
      Case EDIT_FORMAT_DATABASE_IMAGE, EDIT_FORMAT_DATABASE_FILE

		strfilename=""
		onchangefile=""
		if sMode="Edit" then
' 		           	strImageWhere = " " & AddWrappers(strKeyField) & "=" & gstrQuote & GetData(rs.Fields(strKeyField), "") & gstrQuote
'       			if strKeyField2<>"" then strImageWhere = strImageWhere & " and " & AddWrappers(strKeyField2) & "=" & gstrQuote2 & GetData(rs.Fields(strKeyField2), "") & gstrQuote2
'       			if strKeyField3<>"" then strImageWhere = strImageWhere & " and " & AddWrappers(strKeyField3) & "=" & gstrQuote3 & GetData(rs.Fields(strKeyField3), "") & gstrQuote3
       			strPK = AddWrappers(strKeyField)
       			if strKeyField2<>"" then strPK = strPK & "," & AddWrappers(strKeyField2)
       			if strKeyField3<>"" then strPK = strPK & "," & AddWrappers(strKeyField3)
       			BuildEditControl = CreateImageControl(rs, sFieldName, GetFilenameField(strTableName, sFieldName))

		' filename edit
			if sFormat=EDIT_FORMAT_DATABASE_FILE and GetFilenameField(strTableName, sFieldName)<>"" then
				strfilename="<br>Filename:&nbsp;&nbsp;<input name=""" & GetFilenameField(strTableName, sFieldName) & """ size=""20"" maxlength=""50"" value=""" & rs(GetFilenameField(strTableName, sFieldName)) & """>"
				onchangefile="var path=this.form['" & sFieldName & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; this.form['" & GetFilenameField(strTableName, sFieldName) & "'].value=path.substr(pos+1);"
			end if
			strtype="<br><input type=""Radio"" name=""type" & sFieldName & """ value=""file0"" checked>" & ##SCRIPTMESSAGE(KEEP)##
			if sValue<>"" and not IsRequired(sFieldName) then
				strtype= strtype & "<input type=""Radio"" name=""type" & sFieldName & """ value=""file1"">" & ##SCRIPTMESSAGE(DELETE)##
				onchangefile = onchangefile & "this.form['type" & sFieldName & "'][2].checked=true;"
			else
				onchangefile= onchangefile & "this.form['type" & sFieldName & "'][1].checked=true;"
			end if
			
			strtype = strtype & "<input type=""Radio"" name=""type" & sFieldName & """ value=""file2"">" & ##SCRIPTMESSAGE(UPDATE)##
		else
			strtype="<input type=""hidden"" name=""type" & sFieldName & """ value=""file2"">"
			if sFormat=EDIT_FORMAT_DATABASE_FILE and GetFilenameField(strTableName, sFieldName)<>"" then
				strfilename = "<br>" & ##SCRIPTMESSAGE(FILENAME)## & ":&nbsp;&nbsp;<input name=""" & GetFilenameField(strTableName, sFieldName) & """ size=""20"" maxlength=""50"">"
				onchangefile = onchangefile & "var path=this.form['" & sFieldName & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; this.form['" & GetFilenameField(strTableName, sFieldName) & "'].value=path.substr(pos+1);"
			end if
		end if

		if not MaxSizeSet=true then
			maxsize="<input type=""hidden"" name=""MAX_FILE_SIZE"" value=""" & cMaxUploadFileSize & """>"
			MaxSizeSet = true
		end if

		if onchangefile <> "" then onchangefile="onChange=""" & onchangefile & """"
		BuildEditControl  = BuildEditControl  & disp & strtype & maxsize & _ 
			"<br><input type=""File"" name=""" & sFieldName & """ " & onchangefile & ">" & strfilename
			
      Case EDIT_FORMAT_LOOKUP_WIZARD    	
      	BuildEditControl = BuildSelectControl(sFieldName , sDefault, true)
      Case EDIT_FORMAT_HIDDEN   		
      	BuildEditControl = "<input type=hidden name=""" & sFieldName  & """" & " value=""" & sDefault & """>"
  	  Case EDIT_FORMAT_READONLY
		BuildEditControl = "<input type=hidden name=""" & sFieldName  & """" & " value=""" & sDefault & """>"' & Replace(GetLookupValue(sFieldName, sDefault), vbcrlf, "<br>")
      Case EDIT_FORMAT_FILE

		strfilename=""
		onchangefile=""
		jsfunc="<script language=""Javascript"">" & vbcrlf &_
"			function controlfilename" & BuildGoodFieldName(sFieldName) & "(enable)"& vbcrlf &_
"			{"& vbcrlf &_
"				if(enable)"& vbcrlf &_
"				{"& vbcrlf &_
"					document.forms.editform['" & sFieldName & "'].style.backgroundColor=""white"";" & vbcrlf &_
"					document.forms.editform['" & sFieldName & "'].disabled=false;" & vbcrlf &_
"				}" & vbcrlf &_
"				else"& vbcrlf &_
"				{"& vbcrlf &_
"					document.forms.editform['" & sFieldName & "'].style.backgroundColor=""gainsboro"";"& vbcrlf &_
"					document.forms.editform['" & sFieldName & "'].disabled=true;"& vbcrlf &_
"				}"& vbcrlf &_
"			}"& vbcrlf &_
"			</script>"& vbcrlf

		fieldname_size=30
		if UseTimestamp(sFieldName) then fieldname_size=50
		
		if sMode="Edit" then

		BuildEditControl = ""
			if Format(sFieldName)=FORMAT_FILE or Format(sFieldName)=FORMAT_FILE_IMAGE then
				BuildEditControl=GetData(rs(sFieldName), Format(sFieldName))
			end if
			
		' filename edit
			strfilename="<input type=hidden name=""filename" & sFieldName & """ value=""" & sValue & """><br>" & ##SCRIPTMESSAGE(FILENAME)## &":&nbsp;&nbsp;<input style=""background-color:gainsboro"" disabled name=""" & sFieldName & """ size=""" & CStr(filename_size) & """ maxlength=""100"" value=""" & strEncoded & """>"
			onchangefile="var path=this.form['file" & sFieldName & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; controlfilename" & BuildGoodFieldName(sFieldName) & "(true);"
			if UseTimestamp(sFieldName) then
			  onchangefile = onchangefile & " this.form['" & sFieldName & "'].value=addTimestamp(path.substr(pos+1));"
			else
			  onchangefile = onchangefile & " this.form['" & sFieldName & "'].value=path.substr(pos+1);"
			end if
			strtype="<br><input type=""Radio"" name=""type" & sFieldName & """ value=""upload0"" checked onclick=""controlfilename" & BuildGoodFieldName(sFieldName) & "(false)"">" & ##SCRIPTMESSAGE(KEEP)##
			if sValue<>"" and not IsRequired(sFieldName) then
				strtype= strtype & "<input type=""Radio"" name=""type" & sFieldName & """ value=""upload1"" onclick=""controlfilename" & BuildGoodFieldName(sFieldName) & "(false)"">" & ##SCRIPTMESSAGE(DELETE)##
				onchangefile = onchangefile & "this.form['type" & sFieldName & "'][2].checked=true;"
			else
				onchangefile= onchangefile & "this.form['type" & sFieldName & "'][1].checked=true;"
			end if
			
			strtype = strtype & "<input type=""Radio"" name=""type" & sFieldName & """ value=""upload2"" onclick=""controlfilename" & BuildGoodFieldName(sFieldName) & "(true)"">" & ##SCRIPTMESSAGE(UPDATE)##
		else
			strtype="<input type=""hidden"" name=""type" & sFieldName & """ value=""upload2"">"
			strfilename = "<br>" & ##SCRIPTMESSAGE(FILENAME)## & ":&nbsp;&nbsp;<input name=""" & sFieldName & """ size=""" & CStr(filename_size) & """ maxlength=""100"">"
			onchangefile = onchangefile & "var path=this.form['file" & sFieldName & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos;"
			if UseTimestamp(sFieldName) then
			  onchangefile = onchangefile & " this.form['" & sFieldName & "'].value=addTimestamp(path.substr(pos+1));"
			else
			  onchangefile = onchangefile & " this.form['" & sFieldName & "'].value=path.substr(pos+1);"
			end if
		end if

		if not MaxSizeSet=true then
			maxsize="<input type=""hidden"" name=""MAX_FILE_SIZE"" value=""" & cMaxUploadFileSize & """>"
			MaxSizeSet = true
		end if

		if onchangefile <> "" then onchangefile="onChange=""" & onchangefile & """"
		BuildEditControl  = BuildEditControl & jsfunc & disp & strtype & maxsize & _ 
			"<br><input type=""File"" name=""file" & sFieldName & """ " & onchangefile & ">" & strfilename
			
   End Select

if BuildEditControl ="" and sFormat<>EDIT_FORMAT_READONLY then

		' text area
		if nType  = 203 or nType  = 201 then
			BuildEditControl = "<textarea cols=50 rows=10 name=""" & sFieldName  & """>" & sDefault & "</textarea>" 
		end if

		' check box
		if nType = 11 or (nType=131 and ( sValue="Yes" or sValue="1" or sValue="0" or sValue="No" )) then
			BuildEditControl = "<input type=checkbox name=""" & sFieldName  & """"
		    val = Lcase(CStr(sDefault))
			if val="yes" or (IsNumeric(val) and val<>"0") or val="true" or val="on" then BuildEditControl = BuildEditControl & " checked "

			BuildEditControl = BuildEditControl & ">" 
		end if
		
		' set length for text or numeric 
		if nType>=2 and nType<=6 then
			strMaxLength = 10
			strSize = 10
		else
			if GetDatabaseType()= DATABASE_MySQL then
				strSize=20
				strMaxLength = 255
			else
				strMaxLength = Field.DefinedSize
				strSize = strMaxLength
			end if
		end if

		' date or datetime field
		if IsDateField(Field) then
		    if sMode = "Add" then
				sDefault = GetDefaultValue(sFieldName)
			end if
			BuildEditControl = GetDateEdit(sFieldName , sDefault , DateEditType(sFieldName ),sFieldName)
		elseif IsLookupField(sFieldName ) then
			BuildEditControl = BuildSelectControl(sFieldName , sValue, true)
		elseif nType <> 201 and nType <> 203 and nType <> 11 and nType <> 204 and nType <> 205 then
			BuildEditControl = "<input type=text name=""" & sFieldName  & """ maxlength = " & strMaxLength & " size = " & strSize & " value=""" & sDefault & """>" 
		elseif (Field.Attributes and 128) and ( nType = 204 or nType=205 ) then
		strfilename=""
		onchangefile=""
		if sMode="Edit" then
'             		strImageWhere = " " & AddWrappers(strKeyField) & "=" & gstrQuote & GetData(rs.Fields(strKeyField), "") & gstrQuote
'       			if strKeyField2<>"" then strImageWhere = strImageWhere & " and " & AddWrappers(strKeyField2) & "=" & gstrQuote2 & GetData(rs.Fields(strKeyField2), "") & gstrQuote2
'       			if strKeyField3<>"" then strImageWhere = strImageWhere & " and " & AddWrappers(strKeyField3) & "=" & gstrQuote3 & GetData(rs.Fields(strKeyField3), "") & gstrQuote3
       			strPK = AddWrappers(strKeyField)
       			if strKeyField2<>"" then strPK = strPK & "," & AddWrappers(strKeyField2)
       			if strKeyField3<>"" then strPK = strPK & "," & AddWrappers(strKeyField3)
       			BuildEditControl = CreateImageControl(rs, sFieldName, GetFilenameField(strTableName, sFieldName))

		' filename edit
			if sFormat=EDIT_FORMAT_DATABASE_FILE and GetFilenameField(strTableName, sFieldName)<>"" then
				strfilename="<br>" & ##SCRIPTMESSAGE(FILENAME)## & ":&nbsp;&nbsp;<input name=""" & GetFilenameField(strTableName, sFieldName) & """ size=""20"" maxlength=""50"" value=""" & rs(GetFilenameField(strTableName, sFieldName)) & """>"
				onchangefile="var path=this.form['" & sFieldName & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; this.form['" & GetFilenameField(strTableName, sFieldName) & "'].value=path.substr(pos+1);"
			end if
			strtype="<br><input type=""Radio"" name=""type" & sFieldName & """ value=""file0"" checked>" & ##SCRIPTMESSAGE(KEEP)##
			if sValue<>"" then
				strtype= strtype & "<input type=""Radio"" name=""type" & sFieldName & """ value=""file1"">" & ##SCRIPTMESSAGE(DELETE)##
				onchangefile = onchangefile & "this.form['type" & sFieldName & "'][2].checked=true;"
			else
				onchangefile= onchangefile & "this.form['type" & sFieldName & "'][1].checked=true;"
			end if
			
			strtype = strtype & "<input type=""Radio"" name=""type" & sFieldName & """ value=""file2"">" & ##SCRIPTMESSAGE(UPDATE)##
		else
			strtype="<input type=""hidden"" name=""type" & sFieldName & """ value=""file2"">"
			if sFormat=EDIT_FORMAT_DATABASE_FILE and GetFilenameField(strTableName, sFieldName)<>"" then
				strfilename = "<br>" & ##SCRIPTMESSAGE(FILENAME)## & ":&nbsp;&nbsp;<input name=""" & GetFilenameField(strTableName, sFieldName) & """ size=""20"" maxlength=""50"">"
				onchangefile = onchangefile & "var path=this.form['" & sFieldName & "'].value; var wpos=path.lastIndexOf('\\'); var upos=path.lastIndexOf('/'); var pos=wpos; if(upos>wpos) pos=upos; this.form['" & GetFilenameField(strTableName, sFieldName) & "'].value=path.substr(pos+1);"
			end if
		end if

		if not MaxSizeSet=true then
			maxsize="<input type=""hidden"" name=""MAX_FILE_SIZE"" value=""" & cMaxUploadFileSize & """>"
			MaxSizeSet = true
		end if

		if onchangefile <> "" then onchangefile="onChange=""" & onchangefile & """"
		BuildEditControl  = BuildEditControl  & disp & strtype & maxsize & _ 
			"<br><input type=""File"" name=""" & sFieldName & """ " & onchangefile & ">" & strfilename


		end if
end if

End Function

Function BuildFieldName(strFieldName)

	BuildFieldName = Replace(strFieldName," ","")
	BuildFieldName = Replace(BuildFieldName,"#","")
	BuildFieldName = Replace(BuildFieldName,"/","")
	BuildFieldName = Replace(BuildFieldName,"(","")
	BuildFieldName = Replace(BuildFieldName,")","")
	BuildFieldName = Replace(BuildFieldName,"'","")
	BuildFieldName = Replace(BuildFieldName,"_","")
	BuildFieldName = Replace(BuildFieldName,"-","")

End Function

Function RemoveWrappers(strValue)
	if strValue="" or IsNULL(strValue) then
		RemoveWrappers=""
		Exit Function
	end if

	if Left(strValue,1)=strLeftWrapper then
		RemoveWrappers = Mid(strValue, 2 ,Len(strValue)-2)
	else
		RemoveWrappers = strValue
	end if
	if Left(RemoveWrappers,1)="'" then
		RemoveWrappers = Mid(RemoveWrappers, 2 ,Len(RemoveWrappers)-2)
	else
		RemoveWrappers = RemoveWrappers
	end if
	RemoveWrappers  = Replace(RemoveWrappers, strRightWrapper & "." & strLeftWrapper, ".")
RemoveWrappers = CStr(RemoveWrappers)

End Function

Function ProcessLargeText(strValue,iquery,tablename,mode)

	if LCase(Left(LTrim(strValue),7))="<a href" Then 
		ProcessLargeText = strValue
		Exit Function
	end if

	if Left(strValue,23)="<img src=""images/check_" Then 
		ProcessLargeText = strValue
		Exit Function
	end if

 ProcessLargeText = strValue

if tablename="" then
	tablename="##SHORTTABLENAME##"
else
	tablename=GetTableURL(tablename)
end if

 vNumberOfChars = GetNumberOfChars(tablename)

if vNumberOfChars>0 and mode=MODE_PRINT then 
	ProcessLargeText = Left(ProcessLargeText, vNumberOfChars )
	if len(strValue)>vNumberOfChars then
		ProcessLargeText = ProcessLargeText & " ..."
	end if
	ProcessLargeText = HTMLEncode(ProcessLargeText)
	exit function
end if

if vNumberOfChars>0 then
	if Len(ProcessLargeText)>vNumberOfChars and (Len(ProcessLargeText)<200 or Len(iquery)=0) then
		ProcessLargeText = HTMLEncode(Left(ProcessLargeText, vNumberOfChars )) & _
		" <a href=""#"" onClick=""javascript: pwin = window.open('',null,'height=300,width=400,status=yes,resizable=yes,toolbar=no,menubar=no,location=no,left=150,top=200,scrollbars=yes'); "
		ind = 1
		ProcessLargeText = ProcessLargeText & "pwin.document.write('" & HTMLEncode(Replace(Replace(Replace(Mid(strValue,ind, ind+800),"'","\'"), vbcrlf, "<br>"), vblf, "<br>")) & "');" & vbcrlf
		ProcessLargeText = ProcessLargeText & "pwin.document.write('<br><hr size=1 noshade><a href=# onClick=\'window.close();return false;\'>" & ##SCRIPTMESSAGE(CLOSE_WINDOW)## & "</a>');"
		ProcessLargeText = ProcessLargeText & "return false;"">" & ##SCRIPTMESSAGE(MORE)## & " ...</a>"
	elseif Len(ProcessLargeText)>vNumberOfChars then
		ProcessLargeText = HTMLEncode(Left(ProcessLargeText, vNumberOfChars )) & _
		" <a href=""#"" onClick=""javascript: pwin = window.open('',null,'height=300,width=400,status=yes,resizable=yes,toolbar=no,menubar=no,location=no,left=150,top=200,scrollbars=yes'); "
		ProcessLargeText = ProcessLargeText & "pwin.location='" & tablename & "_fulltext.asp?" & iquery	& "';"
		ProcessLargeText = ProcessLargeText & "return false;"">" & ##SCRIPTMESSAGE(MORE)## & " ...</a>"
	else
		ProcessLargeText = HTMLEncode(ProcessLargeText)
	end if

end if

End Function

Function EscapeQuotes(strValue)
	EscapeQuotes = Replace(strValue, "'", "\'")
	EscapeQuotes = HTMLEncode(EscapeQuotes)
End Function

Function HTMLEncode(str)

if str="" or IsNull(str) then
	HTMLEncode=""
else
	HTMLEncode = Server.HTMLEncode(str)
end if

End Function



Function CreateImageControl(rsData, sFieldName, FilenameField)

		key=""
		if strKeyField<>"" then key = GetData(rsData.Fields(strKeyField), "")
		key2=""
		if strKeyField2<>"" then key2 = GetData(rsData.Fields(strKeyField2), "")
		key3=""
		if strKeyField3<>"" then key3 = GetData(rsData.Fields(strKeyField3), "")

		strImageWhere = " " & KeyWhere(key,key2,key3)

	if FilenameField="" then
		CreateImageControl = "<img border=0 src=""##SHORTTABLENAME##_imager.asp?picfield=" & _ 
			Server.URLEncode(sFieldName) & "&where=" & Server.URLEncode(strImageWhere) & """>"
	else
		CreateImageControl = "<img border=0 src=""##SHORTTABLENAME##_imager.asp?picfield=" & _ 
			Server.URLEncode(sFieldName) & "&where=" & Server.URLEncode(strImageWhere) & """>"

			binTemp = rsData(sFieldName).GetChunk(300)

			if not IsNull(binTemp) then
				CreateImageControl = "<a href=""##SHORTTABLENAME##_getfile.asp?picfield=" & _ 
				Server.URLEncode(sFieldName) & "&filename=" & Server.URLEncode(rsData(FilenameField)) _ 
				& "&where=" & Server.URLEncode(strImageWhere) & """>" & CreateImageControl & "</a>"
			end if
	end if
End Function


Function InSQL(sField, sSQL)
	
	if InStr(1, LCase(sSQL), LCase(sField) & ",")<1 and InStr(1, LCase(sSQL), LCase(sField) & " ")<1 and _
		InStr(1, LCase(sSQL), strLeftWrapper & LCase(sField) & strRightWrapper & ",")<1 and InStr(1, LCase(sSQL), strLeftWrapper & LCase(sField) & strRightWrapper & " ")<1 then
			InSQL = False
	else
			InSQL = True
	end if
	
End Function

Function IsUpdatable(Field)

		if Field.Attributes and 4 or Field.Attributes and 8 then
			bUpdatable=true
		else
			bUpdatable=false
		end if		

		if bUpdatable then 
			IsUpdatable="True"
		else
			IsUpdatable="False"
		end if

		' long binary data
	'	if (Field.Attributes and 128) and ( Field.Type = 204 or Field.Type=205 ) then
	'		IsUpdatable="False"
	'	end if

End Function

Sub GetADOXConnection

   if InStr(1, strConnection, "Microsoft Access Driver") > 0 then
       set oCat = server.CreateObject("ADOX.Catalog") 
       if Err.number=0 then
       		ind = InStr(1, strConnection, "DBQ=")
       		if ind>0 then
       			ind2=InStr(ind+1, strConnection, ";")
				if ind2<ind then ind2=len(strConnection)+1
				sConnection = "Provider=Microsoft.Jet.OLEDB.4.0;Jet OLEDB:Engine Type=5;Data Source=" & Mid(strConnection, ind+Len("DBQ="), ind2-ind-Len("DBQ="))

				if InStr(LCASE(strConnection), "pwd=")<1 or Right(LCASE(strConnection),4)= "pwd="  then
      	 				oCat.ActiveConnection = sConnection
      	 			if Left(strOriginalTableName,1)="[" then
      			 		strADOXTableName = Mid(strOriginalTableName,2,len(strOriginalTableName)-2)
       				else
          				strADOXTableName = strOriginalTableName 
	   				end if
				end if
   			end if
       end if
       Err.Clear
   end if

End Sub

Function GetLegendIcon(sFieldName, nType, i)
	
   	if sFieldName = strKeyField or sFieldName =strKeyField2 or sFieldName = strKeyField3 then
		GetLegendIcon = GetLegendIcon  & "&nbsp;<img src=images/icon_required.gif>"
		else
			if IsRequired(sFieldName) then
				GetLegendIcon = GetLegendIcon  & "&nbsp;<img src=images/icon_required.gif>"
			end if
	end if

End Function




function RTESafe(strText)
	'returns safe code for preloading in the RTE
	dim tmpString
	
	tmpString = trim(strText)
	if tmpString ="" or isNull(tmpString) then Exit Function
	
	'convert all types of single quotes
	tmpString = replace(tmpString, chr(145), chr(39))
	tmpString = replace(tmpString, chr(146), chr(39))
	tmpString = replace(tmpString, "'", "&#39;")
	
	'convert all types of double quotes
	tmpString = replace(tmpString, chr(147), chr(34))
	tmpString = replace(tmpString, chr(148), chr(34))
'	tmpString = replace(tmpString, """", "\""")
	
	'replace carriage returns & line feeds
	tmpString = replace(tmpString, chr(10), " ")
	tmpString = replace(tmpString, chr(13), " ")
	
	RTESafe = tmpString
end function





Function CheckSecurity(strValue, strAction)

   	if cAdvSecurityMethod = ADVSECURITY_ALL or Session("AccessLevel")=ACCESS_LEVEL_ADMIN then
		CheckSecurity = True
		if Session("AccessLevel")=ACCESS_LEVEL_ADMIN then Exit Function
	end if

	if cAdvSecurityMethod = ADVSECURITY_EDIT_OWN and ( strAction="Edit" or strAction="Delete") then
		if RemoveWrappers(Session("OwnerID"))=RemoveWrappers(CStr(strValue)) then
			CheckSecurity = True
		else
			CheckSecurity = False
			Exit Function
		end if
	else
		CheckSecurity = True
	end if
	

##LOGIN##
	' check user group permissions
	strPerm = GetUserPermissions()
	if strAction="Add" and InStr(strPerm, "A")>0 or strAction="Edit" and InStr(strPerm, "E")>0 _
		or strAction="Delete" and InStr(strPerm, "D")>0 or strAction="Search" and InStr(strPerm, "S")>0 _ 
		or strAction="Export" and InStr(strPerm, "P")>0 then
		CheckSecurity = True
	else
		CheckSecurity = False
	end if
##/LOGIN##

End Function


##LOGIN##

Function GetUserPermissions()

sUserName = Session("GroupID")
Select Case sUserName
##USERGROUPS##
Case "##USERNAME##"
	GetUserPermissions = "##PERMISSIONS##"
##/USERGROUPS##
Case Else
	GetUserPermissions = "##DEFAULT_PERMISSIONS##"
End Select

End Function

##/LOGIN##

Function FormatDbDate(strValue,nFormat)

Dim i,j

	if strValue="0-0-0" then
		FormatDbDate=""
		Exit Function
	end if
	i=1
	j=0
	dim n(6)
	strTemp=""
	while i<=Len(strValue) and j<3
		if asc(mid(strValue,i,1))>=asc("0") and asc(mid(strValue,i,1))<=asc("9") then
			strTemp=strTemp & mid(strValue,i,1)
		else
			if len(strTemp)>0 then
				n(j)=CLng(strTemp)
				strTemp=""
				j=j+1
			end if
		end if
		i=i+1
	wend
	
	if j<2 then
		FormatDbDate = ""
		Exit Function
	end if
	
	if i<=Len(strValue) and i>0 then 
		sRem = Mid(strValue, i-1)
	end if
	
	if len(strTemp)>0 then
		n(j)=CLng(strTemp)
	end if
	d=0
	m=0
	y=0

	if nFormat=EDIT_DATE_SIMPLE_DDMMYYYY_DP then
		d=n(0)
		m=n(1)
		y=n(2)
	elseif nFormat=EDIT_DATE_SIMPLE_MMDDYYYY_DP then
		d=n(1)
		m=n(0)
		y=n(2)
	elseif nFormat=EDIT_DATE_DDMMYYYY or nFormat=EDIT_DATE_DDMMYYYY_DP or _
			nFormat=EDIT_DATE_MMDDYYYY or nFormat=EDIT_DATE_MMDDYYYY_DP then
		FormatDbDate = strValue
		Exit Function		
	else
		strValue = CDate(strValue)
		y = Year(strValue)
		m = Month(strValue)
		d = Day(strValue)
	end if
	if y<100 then
		if y<70 then
			y=y+2000
		else
			y=y+1900
		end if
	end if
	FormatDbDate=CStr(y) & "-" & iif(m<10, "0" & CStr(m), CStr(m)) & "-" & iif(d<10, "0" & CStr(d), CStr(d)) & sRem

end function

Function GetLookupValue(sFieldName, strData )
##ALLFIELDS##
	if sFieldName="##FIELD##" then
		##DBLOOKUPFIELD##
	       If Not IsNull(strData) Then
	
			strData = Replace(strData, "'", "''")
			if IfNeedQuotes(GetFieldType(strTableName, sFieldName)) then
				strData = GetQuote(strTableName,  sFieldName) & strData & GetQuote(strTableName,  sFieldName)
			end if
	
	           	sqlt = "SELECT ##DISPLAYFIELD## FROM ##LOOKUPTABLE## WHERE ##LINKFIELD## = " & strData
	       		Set rst = dbConnection.Execute(sqlt)
	       		If Not rst.EOF Then
	         		GetLookupValue = rst(0)
	       		End If
	       		rst.Close
	       		Set rst= Nothing
	       End If
		##/DBLOOKUPFIELD##
		##NOTDBLOOKUPFIELD##
			GetLookupValue = strData
		##/NOTDBLOOKUPFIELD##		
	end if
##/ALLFIELDS##		
End Function

Function InArray(arr, str)

if IsNull(arr) or IsEmpty(arr) then
	InArray = False
	Exit Function
end if

if UBound(arr)<LBound(arr) then 
	InArray = False
	Exit Function
end if

InArray = false

For ind=LBound(arr) to UBound(arr)
	if arr(ind)=str then
		InArray = true
		Exit Function
	end if
Next 


End Function


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

Function Bytes2String(bytes)

	For i = 1 to LenB(bytes)
		byteord = AscB(MidB(bytes, i, 1))
		If byteord < &H80 Then ' Ascii
			Bytes2String= Bytes2String& Chr(byteord)
		Else ' Double-byte characters?
			If i < LenB(bytes) Then
				nextbyteord = AscB(MidB(bytes, i+1, 1))
				On Error Resume Next
			        Bytes2String= Bytes2String& Chr(CInt(byteord) * &H100 + CInt(nextbyteord))
				If Err.Number <> 0 Then
					On Error GoTo 0
					Bytes2String= Bytes2String& Chr(byteord) & Chr(nextbyteord)
				End If
				i = i + 1
			ElseIf i = LenB(bytes) Then
				Bytes2String= Bytes2String& Chr(byteord)
			End If
		End If
	Next
End Function


Function GetTables()

sUserName = Session("GroupID")
Select Case sUserName
##USERGROUPS##
Case "##USERNAME##"
	GetTables = ##AVAILABLE_TABLES##
##/USERGROUPS##
Case Else
	GetTables = ##DEFAULT_TABLES##
End Select

End Function

function GetShortTableName(table)

	##TABLES##
	if table="##TABLENAME##" then	
		GetShortTableName = "##SHORTTABLENAME##"
		Exit Function
	end if
	##/TABLES##

End Function

function GetTableCaption(table)

	##TABLES##
	if table="##TABLENAME##" then
		GetTableCaption = "##CAPTION##"
		Exit Function
	end if
	##/TABLES##

End Function

function UseTimestamp(field)
	UseTimestamp=false
	##ALLFIELDS## if field="##FIELD##" then UseTimestamp = ##ADDTIMESTAMP## end if
	##/ALLFIELDS##
end function

function GetUploadFolder(field)
	GetUploadFolder=""
	##ALLFIELDS## if field="##FIELD##" then GetUploadFolder = "##UPLOADFOLDER##" end if
	##/ALLFIELDS##
	If Right(GetUploadFolder, 1)<>"/" then GetUploadFolder = GetUploadFolder & "/"
end function

Function SecuritySQL(strAction)

##LOGIN##
   	ownerid=Session("OwnerID")
	if Session("AccessLevel")=ACCESS_LEVEL_ADMIN then
		SecuritySQL = ""
		Exit Function
	end if
	ret=""
	if cAdvSecurityMethod = ADVSECURITY_VIEW_OWN or _ 
	   cAdvSecurityMethod = ADVSECURITY_EDIT_OWN and (strAction="Edit" or strAction="Delete") then
		ret=GetFullFieldName(strTableName,"##OWNERID##") & "=" & GetQuote(strTableName, "##OWNERID##") & ownerid & GetQuote(strTableName, "##OWNERID##")
	end if
	strPerm = GetUserPermissions()
	if strAction="Edit" and InStr(strPerm, "E")>0 or _ 
	   strAction="Delete" and InStr(strPerm, "D")>0 or _ 
	   strAction="Search" and InStr(strPerm, "S")>0 or _
	   strAction="Export" and InStr(strPerm, "P")>0 then
		SecuritySQL = ret
		Exit Function
	else
		SecuritySQL = "1=0"
		Exit Function
	end if
##/LOGIN##
	SecuritySQL = ""

End Function

Sub DeleteUploadedFiles(where)

	dim i
	set rsTmp = Server.CreateObject("ADODB.Recordset")
	rsTmp.Open "select * from " & strOriginalTableName & " " & where, dbConnection
	if not rsTmp.Eof then
		for i=0 to rsTmp.Fields.Count-1
			if GetEditFormat(rsTmp.Fields(i).Name)=EDIT_FORMAT_FILE then 
				DeleteFile Server.MapPath(GetUploadFolder(rsTmp.Fields(i).Name) & rsTmp(rsTmp.Fields(i).Name))
			end if
		next	
			rsTmp.Close
			set rsTmp = Nothing
	end if


End Sub

function KeyWhere(key,key2,key3)

KeyWhere = GetFullFieldName(strTableName,strKeyField) & "=" & gstrQuote & Replace(key,"'","''") & gstrQuote
		if strKeyField2<>"" then _
			KeyWhere=KeyWhere & " and " & GetFullFieldName(strTableName,strKeyField2) & "=" & gstrQuote2 & Replace(key2,"'","''") & gstrQuote2
		if strKeyField3<>"" then _
			KeyWhere=KeyWhere & " and " & GetFullFieldName(strTableName,strKeyField3) & "=" & gstrQuote3 & Replace(key3,"'","''") & gstrQuote3
end function
%>