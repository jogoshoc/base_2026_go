<%

cCharset = "Windows-1252"

response.AddHeader "Content-type", "text/html;charset=" & cCharset

dDebug=false
useAJAX=true
suggestAllContent=true

Session.LCID = 1046
session.codepage=1252

dSQL=""

Set tables_data = CreateObject("Scripting.Dictionary")

%>
<!--#include file="locale.asp"-->
<!--#include file="events.asp"-->
<!--#include file="commonfunctions.asp"-->
<!--#include file="dbconnection.asp"-->
<%
Const FORMAT_NONE					= ""
Const FORMAT_DATE_SHORT				= "Short Date"
Const FORMAT_DATE_LONG				= "Long Date"
Const FORMAT_DATE_TIME				= "Datetime"
Const FORMAT_TIME					= "Time"
Const FORMAT_CURRENCY				= "Currency"
Const FORMAT_PERCENT				= "Percent"
Const FORMAT_HYPERLINK				= "Hyperlink"
Const FORMAT_EMAILHYPERLINK			= "Email Hyperlink"
Const FORMAT_FILE_IMAGE				= "File-based Image"
Const FORMAT_DATABASE_IMAGE			= "Database Image"
Const FORMAT_DATABASE_FILE			= "Database File"
Const FORMAT_FILE					= "Document Download"
Const FORMAT_LOOKUP_WIZARD			= "Lookup wizard"
Const FORMAT_PHONE_NUMBER			= "Phone Number"
Const FORMAT_NUMBER					= "Number"
Const FORMAT_HTML					= "HTML"
Const FORMAT_CHECKBOX				= "Checkbox"
Const FORMAT_CUSTOM					= "Custom"

Const EDIT_FORMAT_NONE				= ""
Const EDIT_FORMAT_TEXT_FIELD		= "Text field"
Const EDIT_FORMAT_TEXT_AREA			= "Text area"
Const EDIT_FORMAT_PASSWORD			= "Password"
Const EDIT_FORMAT_DATE				= "Date"
Const EDIT_FORMAT_TIME				= "Time"
Const EDIT_FORMAT_RADIO				= "Radio button"
Const EDIT_FORMAT_CHECKBOX			= "Checkbox"
Const EDIT_FORMAT_DATABASE_IMAGE	= "Database image"
Const EDIT_FORMAT_DATABASE_FILE		= "Database file"
Const EDIT_FORMAT_FILE				= "Document upload"
Const EDIT_FORMAT_LOOKUP_WIZARD		= "Lookup wizard"
Const EDIT_FORMAT_HIDDEN			= "Hidden field"
Const EDIT_FORMAT_READONLY			= "Readonly"

Const EDIT_DATE_SIMPLE				= 0
Const EDIT_DATE_SIMPLE_DP			= 11
Const EDIT_DATE_DD					= 12
Const EDIT_DATE_DD_DP				= 13

Const MODE_ADD						= 0
Const MODE_EDIT						= 1
Const MODE_SEARCH					= 2
Const MODE_LIST						= 3
Const MODE_PRINT					= 4
Const MODE_VIEW						= 5

Const LOGIN_HARDCODED				= 0
Const LOGIN_TABLE					= 1

Const ADVSECURITY_ALL				= 0
Const ADVSECURITY_VIEW_OWN			= 1
Const ADVSECURITY_EDIT_OWN			= 2
Const ADVSECURITY_NONE				= 3

Const ACCESS_LEVEL_ADMIN			= "Admin"
Const ACCESS_LEVEL_USER				= "User"
Const ACCESS_LEVEL_GUEST			= "Guest"

Const DATABASE_MySQL				= "MYSQL"
Const DATABASE_Oracle				= "ORACLE"
Const DATABASE_MSSQLServer			= "MS SQL SERVER"
Const DATABASE_Access				= "ACCESS"

Const RTE_BASIC 				= "BASIC"
Const RTE_FCK 					= "FCK"
Const RTE_INNOVA				= "INNOVA"


strLeftWrapper="["
strRightWrapper="]"

cLoginTable				= "Usuários"
cUserNameField			= "NúmeroDoUsuário"
cPasswordField			= "Senha"
cUserGroupField			= "Privilegio"
cEmailField				= ""

cFrom 					= ""
cSmtpServer 			= "localhost"
cSmtpPort 				= "25"
cSMTPUser				= ""
cSMTPPassword			= ""



function db_connect()
	set dbConnection = server.CreateObject("ADODB.Connection")
   	dbConnection.ConnectionString = strConnection
   	dbConnection.Open
end function
function AddTableWrappers(strName)
	if mid(strName,1,1)=strLeftWrapper then
		AddTableWrappers = strName
		exit function
	end if
	dim arr
	arr=split(strName,".")
	ret=strLeftWrapper & arr(0) & strRightWrapper
	if ubound(arr)>0 then ret=ret & "." & strLeftWrapper & arr(1) & strRightWrapper
	AddTableWrappers = ret
end function

function db_upper(dbval)
	db_upper = "ucase(" & dbval & ")"
end function

function AddFieldWrappers(strName)
	if mid(strName,1,1)=strLeftWrapper then
		AddFieldWrappers = strName
	else
		AddFieldWrappers = strLeftWrapper & strName & strRightWrapper
	end if
end function
function FieldNeedQuotes(rs,field)
	ttype=db_fieldtype(rs,field)
	if ttype=20 or ttype=128 or ttype=11 or ttype=6 or ttype=14 or ttype=5 or ttype=3 or ttype=131 _
	or ttype=4	or ttype=2	or ttype=16 or ttype=21 or ttype=19 or ttype=18 or ttype=17 or ttype=139 then
		FieldNeedQuotes = false
	else
		FieldNeedQuotes = true
	end if
end function
function db_addslashes(str)
	db_addslashes = replace(str,"'","''")
end function
function db_datequotes(val)
	db_datequotes = "#" & val & "#"
end function
function db_stripslashesbinary(str)
'//	try to remove ole header for BMP pictures
	pos = instrb(str,unicode2bytes(".Picture"))
	if pos=0 or pos>300 then 
		db_stripslashesbinary = str
		exit function
	end if
	pos1=instrb(pos,str,unicode2bytes("BM"))
	if pos1=0 or pos1>300 then
		db_stripslashesbinary = str
		exit function
	end if
	db_stripslashesbinary = midb(str,pos1)
end function

function db_fieldtype(lhandle,fname)
	Dim i
	for i=0 to db_numfields(lhandle)-1
		if db_fieldname(lhandle,i)=fname then
			ttype=db_fieldtypen(lhandle,i)
			db_fieldtype = ttype
			exit function
		end if
	next
	db_fieldtype = ""
end function
function db_numfields(lhandle)
	db_numfields = lhandle.Fields.Count
end function

function db_fieldname(lhandle,fnumber)
	db_fieldname = lhandle.Fields(fnumber).Name
end function

function db_fieldtypen(lhandle,fnumber)
	db_fieldtypen = lhandle.Fields(fnumber).Type
end function

function date2str(val)
	if isnull(val) then
		date2str=""
		exit function
	end if
	if isdate(val) then
		date2str = CStr(year(val)) & "-" & CStr(month(val)) & "-" & CStr(day(val)) & _
				" " & CStr(hour(val)) & ":" & CStr(minute(val)) & ":" & CStr(second(val))
		exit function
	end if
	date2str=""
end function

Sub CalcSearchParameters

	if SESSION(strTableName & "_search")=2 then
	'	 advanced search
		
		set strTableName_asearchfortype = SESSION(strTableName & "_asearchfortype")
		set strTableName_asearchnot = SESSION(strTableName & "_asearchnot")
		set strTableName_asearchopt = SESSION(strTableName & "_asearchopt")
		set strTableName_asearchfor = SESSION(strTableName & "_asearchfor")
		set strTableName_asearchfor2 = SESSION(strTableName & "_asearchfor2")

		sWhere=""
		for each f in strTableName_asearchfor
			strSearchFor=trim(strTableName_asearchfor.item(f))
			strSearchFor2=""
			ttype=strTableName_asearchfortype.item(f)
			
			for each i in strTableName_asearchfor2
				if f=i then strSearchFor2=trim(strTableName_asearchfor2.item(i))
			next
		
			if strSearchFor<>"" or true then
				if sWhere="" then
					if session(strTableName & "_asearchtype")="and" then
						sWhere="1=1"
					else
						sWhere="1=0"
					end if
				end if
				snot=strTableName_asearchnot.item(f)
				strSearchOption=trim(strTableName_asearchopt.Item(f))
				where=""
				where=StrWhereAdv(f, strSearchFor, strSearchOption, strSearchFor2,ttype)
				if where<>"" then
					if snot<>"" then where="not (" & where & ")"
					if SESSION(strTableName & "_asearchtype")="and" then
	   					sWhere=sWhere &  " and " & where
					else
	   					sWhere=sWhere &  " or " & where
	   				end if
				end if
			end if
		next
		strSQL = AddWhere(strSQL,sWhere)
	end if

End Sub

%>
