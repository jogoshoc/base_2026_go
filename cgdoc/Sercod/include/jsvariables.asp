<%

Sub DefineScriptMessages()

Response.Write "<script language=""JavaScript"">"

Response.Write "var TEXT_FIELDS_REQUIRED = '" & Replace(##SCRIPTMESSAGE(FIELDS_REQUIRED)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_ZIPCODES = '" & Replace(##SCRIPTMESSAGE(FIELDS_ZIPCODES)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_EMAILS = '" & Replace(##SCRIPTMESSAGE(FIELDS_EMAILS)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_NUMBERS = '" & Replace(##SCRIPTMESSAGE(FIELDS_NUMBERS)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_CURRENCY = '" & Replace(##SCRIPTMESSAGE(FIELDS_CURRENCY)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_PHONE = '" & Replace(##SCRIPTMESSAGE(FIELDS_PHONE)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_PASSWORD1 = '" & Replace(##SCRIPTMESSAGE(FIELDS_PASSWORD1)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_PASSWORD2 = '" & Replace(##SCRIPTMESSAGE(FIELDS_PASSWORD2)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_PASSWORD3 = '" & Replace(##SCRIPTMESSAGE(FIELDS_PASSWORD3)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_STATE = '" & Replace(##SCRIPTMESSAGE(FIELDS_STATE)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_SSN = '" & Replace(##SCRIPTMESSAGE(FIELDS_SSN)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_DATE = '" & Replace(##SCRIPTMESSAGE(FIELDS_DATE)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIELDS_CC = '" & Replace(##SCRIPTMESSAGE(FIELDS_CC)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_FIRST = '" & Replace(##SCRIPTMESSAGE(FIRST)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_PREVIOUS = '" & Replace(##SCRIPTMESSAGE(PREVIOUS)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_NEXT = '" & Replace(##SCRIPTMESSAGE(NEXT)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_LAST = '" & Replace(##SCRIPTMESSAGE(LAST)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_ADD_NEW = '" & Replace(##SCRIPTMESSAGE(ADD_NEW)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_PAGE1 = '" & Replace(##SCRIPTMESSAGE(PAGE1)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_PAGE2 = '" & Replace(##SCRIPTMESSAGE(PAGE2)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DETAILS_FOUND = '" & Replace(##SCRIPTMESSAGE(DETAILS_FOUND)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_JAN = '" & Replace(##SCRIPTMESSAGE(MONTH_JAN)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_FEB = '" & Replace(##SCRIPTMESSAGE(MONTH_FEB)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_MAR = '" & Replace(##SCRIPTMESSAGE(MONTH_MAR)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_APR = '" & Replace(##SCRIPTMESSAGE(MONTH_APR)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_MAY = '" & Replace(##SCRIPTMESSAGE(MONTH_MAY)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_JUN = '" & Replace(##SCRIPTMESSAGE(MONTH_JUN)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_JUL = '" & Replace(##SCRIPTMESSAGE(MONTH_JUL)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_AUG = '" & Replace(##SCRIPTMESSAGE(MONTH_AUG)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_SEP = '" & Replace(##SCRIPTMESSAGE(MONTH_SEP)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_OCT = '" & Replace(##SCRIPTMESSAGE(MONTH_OCT)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_NOV = '" & Replace(##SCRIPTMESSAGE(MONTH_NOV)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_MONTH_DEC = '" & Replace(##SCRIPTMESSAGE(MONTH_DEC)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_SA = '" & Replace(##SCRIPTMESSAGE(DAY_SA)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_MO = '" & Replace(##SCRIPTMESSAGE(DAY_MO)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_TU = '" & Replace(##SCRIPTMESSAGE(DAY_TU)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_WE = '" & Replace(##SCRIPTMESSAGE(DAY_WE)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_TH = '" & Replace(##SCRIPTMESSAGE(DAY_TH)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_FR = '" & Replace(##SCRIPTMESSAGE(DAY_FR)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_DAY_SU = '" & Replace(##SCRIPTMESSAGE(DAY_SU)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_CALENDAR = '" & Replace(##SCRIPTMESSAGE(CALENDAR)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_INVALID_FORMAT = '" & Replace(##SCRIPTMESSAGE(INVALID_FORMAT)##, "'", "\'") & "';" & vbcrlf
Response.Write "var TEXT_VIEW_SOURCE = '" & Replace(##SCRIPTMESSAGE(VIEW_SOURCE)##, "'", "\'") & "';" & vbcrlf
Response.Write "var locale_dateformat = " & LOCALE_IDATE & ";" & vbcrlf
Response.Write "var locale_datedelimiter = '" & LOCALE_SDATE & "';" & vbcrlf
Response.Write "var PLEASE_SELECT = '" & Replace(##SCRIPTMESSAGE(PLEASE_SELECT)##, "'", "\'") & "';" & vbcrlf

Response.Write "</script>"

End Sub
%>

