<%

'//	locale settings

'	locale settings

set locale_info = CreateObject("Scripting.Dictionary")

'	date settings
locale_info.Add "LOCALE_ICENTURY", "1"
locale_info.Add "LOCALE_IDATE", "1"
locale_info.Add "LOCALE_ILDATE", "1"
locale_info.Add "LOCALE_SDATE", "/"
locale_info.Add "LOCALE_SLONGDATE", "dddd, d' de 'MMMM' de 'yyyy"
locale_info.Add "LOCALE_SSHORTDATE", "d/M/yyyy"
'	weekday names
locale_info.Add "LOCALE_IFIRSTDAYOFWEEK", "6"
locale_info.Add "LOCALE_SDAYNAME1", "segunda-feira"
locale_info.Add "LOCALE_SDAYNAME2", "terça-feira"
locale_info.Add "LOCALE_SDAYNAME3", "quarta-feira"
locale_info.Add "LOCALE_SDAYNAME4", "quinta-feira"
locale_info.Add "LOCALE_SDAYNAME5", "sexta-feira"
locale_info.Add "LOCALE_SDAYNAME6", "sábado"
locale_info.Add "LOCALE_SDAYNAME7", "domingo"
locale_info.Add "LOCALE_SABBREVDAYNAME1", "seg"
locale_info.Add "LOCALE_SABBREVDAYNAME2", "ter"
locale_info.Add "LOCALE_SABBREVDAYNAME3", "qua"
locale_info.Add "LOCALE_SABBREVDAYNAME4", "qui"
locale_info.Add "LOCALE_SABBREVDAYNAME5", "sex"
locale_info.Add "LOCALE_SABBREVDAYNAME6", "sáb"
locale_info.Add "LOCALE_SABBREVDAYNAME7", "dom"
'	month names
locale_info.Add "LOCALE_SMONTHNAME1", "janeiro"
locale_info.Add "LOCALE_SMONTHNAME2", "fevereiro"
locale_info.Add "LOCALE_SMONTHNAME3", "março"
locale_info.Add "LOCALE_SMONTHNAME4", "abril"
locale_info.Add "LOCALE_SMONTHNAME5", "maio"
locale_info.Add "LOCALE_SMONTHNAME6", "junho"
locale_info.Add "LOCALE_SMONTHNAME7", "julho"
locale_info.Add "LOCALE_SMONTHNAME8", "agosto"
locale_info.Add "LOCALE_SMONTHNAME9", "setembro"
locale_info.Add "LOCALE_SMONTHNAME10", "outubro"
locale_info.Add "LOCALE_SMONTHNAME11", "novembro"
locale_info.Add "LOCALE_SMONTHNAME12", "dezembro"
locale_info.Add "LOCALE_SABBREVMONTHNAME1", "jan"
locale_info.Add "LOCALE_SABBREVMONTHNAME2", "fev"
locale_info.Add "LOCALE_SABBREVMONTHNAME3", "mar"
locale_info.Add "LOCALE_SABBREVMONTHNAME4", "abr"
locale_info.Add "LOCALE_SABBREVMONTHNAME5", "mai"
locale_info.Add "LOCALE_SABBREVMONTHNAME6", "jun"
locale_info.Add "LOCALE_SABBREVMONTHNAME7", "jul"
locale_info.Add "LOCALE_SABBREVMONTHNAME8", "ago"
locale_info.Add "LOCALE_SABBREVMONTHNAME9", "set"
locale_info.Add "LOCALE_SABBREVMONTHNAME10", "out"
locale_info.Add "LOCALE_SABBREVMONTHNAME11", "nov"
locale_info.Add "LOCALE_SABBREVMONTHNAME12", "dez"
'	time settings
locale_info.Add "LOCALE_ITIME", "1"
locale_info.Add "LOCALE_ITIMEMARKPOSN", "0"
locale_info.Add "LOCALE_ITLZERO", "1"
locale_info.Add "LOCALE_S1159", ""
locale_info.Add "LOCALE_S2359", ""
locale_info.Add "LOCALE_STIME", ":"
locale_info.Add "LOCALE_STIMEFORMAT", "HH:mm:ss"
'	currency settings
locale_info.Add "LOCALE_ICURRDIGITS", "2"
locale_info.Add "LOCALE_ICURRENCY", "0"
locale_info.Add "LOCALE_INEGCURR", "0"
locale_info.Add "LOCALE_SCURRENCY", "R$ "
locale_info.Add "LOCALE_SMONDECIMALSEP", ","
locale_info.Add "LOCALE_SMONGROUPING", "3;0"
locale_info.Add "LOCALE_SMONTHOUSANDSEP", "."
'	numbers formatting settings
locale_info.Add "LOCALE_IDIGITS", "2"
locale_info.Add "LOCALE_INEGNUMBER", "1"
locale_info.Add "LOCALE_SDECIMAL", ","
locale_info.Add "LOCALE_SGROUPING", "3;0"
locale_info.Add "LOCALE_SNEGATIVESIGN", "-"
locale_info.Add "LOCALE_SPOSITIVESIGN", ""
locale_info.Add "LOCALE_STHOUSAND", "."


locale_info("LOCALE_ILONGDATE")=GetLongDateFormat()
 
'//	locale functions
'//	number, currency, date & time functions


function fformat_number(val)
	dim sign, vint, frac, out, ptr, gi, fmul, i, sfrac
	dim grouping
	if not isNumeric(val) then 
		fformat_number=val
		exit function
	end if
	if val>=0 then
	  sign=1
	  vint = int(val)
	  frac = val-vint
	else 
	  sign=-1
	  vint = int(-val)
	  frac = -val-vint
	end if
	out = formatnumber(vint,0)
'//	grouping
    grouping=split(locale_info("LOCALE_SGROUPING"),";")
	if uBound(grouping)>0 and grouping(0)<>"" then
		ptr=len(out)
		for gi=0 to uBound(grouping)-1
			if not grouping(gi)<>"" then gi=gi-1
			if ptr<=grouping(gi) then
				ptr=0
				exit for
			end if
			out=substr(out,1,ptr-grouping(gi)) & locale_info("LOCALE_STHOUSAND") & substr(out,ptr-grouping(gi))
			ptr=ptr-grouping(gi)
		next
	end if
''//	fractional digits
    if locale_info("LOCALE_IDIGITS")>0 then
      fmul=1
      for i=0 to locale_info("LOCALE_IDIGITS")-1
        fmul=fmul*10
      next
      frac=round(frac*fmul)
	  sfrac=cstr(frac)
	  dl=len(sfrac)
	  while dl<cint(locale_info("LOCALE_IDIGITS"))
	    sfrac="0" & sfrac
	    dl=dl+1
	  wend
	  out=out & locale_info("LOCALE_SDECIMAL") & sfrac
    end if
''//	format output
	if sign>0 then
		fformat_number = locale_info("LOCALE_SPOSITIVESIGN") & out
		exit function
	else
		select case locale_info("LOCALE_INEGNUMBER")
			case 0 fformat_number = "(" & out & ")"
								exit function
			case 1 fformat_number = "-" & out
								exit function
			case 2 fformat_number = "- " & out
								exit function
			case 3 fformat_number = out & "-"
								exit function
			case 4 fformat_number = out & " -"
								exit function
		end select
	end if
	fformat_number=val
end function


function fformat_currency(val)
	dim sign, vint, frac, out, ptr, gi, fmul, sfrac
	dim grouping
	if not isNumeric(val) then format_currency = val
	if val>=0 then
		sign=1
		vint = int(val)
		frac = val-vint
	else 
	  sign=-1
	  vint = int(-val)
	  frac = -val-vint
	end if
	out = formatnumber(vint,0)
'//	grouping
    grouping=split(locale_info("LOCALE_SMONGROUPING"),";")
	if uBound(grouping)>0 and grouping(0)<>"" then
		ptr=len(out)
		for gi=0 to uBound(grouping)-1
			if not grouping(gi)<>"" then gi=gi-1
			if ptr<=grouping(gi) then
				ptr=0
				exit for
			end if
			out=substr(out,1,ptr-grouping(gi)) & locale_info("LOCALE_SMONTHOUSANDSEP") & substr(out,ptr-grouping(gi))
			ptr=ptr-grouping(gi)
		next
	end if
'//	fractional digits
    if locale_info("LOCALE_ICURRDIGITS")>0 then
      fmul=1
      for i=0 to locale_info("LOCALE_ICURRDIGITS")-1
        fmul=fmul*10
      next
      frac=round(frac*fmul)
	  sfrac=cstr(frac)
	  dl=len(sfrac)
	  while dl<cint(locale_info("LOCALE_ICURRDIGITS"))
	    sfrac="0" & sfrac
	    dl=dl+1
	  wend
	  out=out & locale_info("LOCALE_SMONDECIMALSEP") & sfrac
    end if
'//	format output
	if sign>0 then
		select case locale_info("LOCALE_ICURRENCY")
			case 0 fformat_currency = cstr(locale_info("LOCALE_SCURRENCY")) & cstr(out)
								exit function
			case 1 fformat_currency = cstr(out) & cstr(locale_info("LOCALE_SCURRENCY"))
								exit function
			case 2 fformat_currency = cstr(locale_info("LOCALE_SCURRENCY")) & " " & cstr(out)
								exit function
			case 3 fformat_currency = cstr(out) & " " & cstr(locale_info("LOCALE_SCURRENCY"))
								exit function
		end select
	else
		select case locale_info("LOCALE_INEGCURR")
			case 0 fformat_currency = "(" & cstr(locale_info("LOCALE_SCURRENCY")) & cstr(out) & ")"
								exit function
			case 1 fformat_currency = "-" & cstr(locale_info("LOCALE_SCURRENCY")) & cstr(out)
								exit function
			case 2 fformat_currency = cstr(locale_info("LOCALE_SCURRENCY")) & "-" & cstr(out)
								exit function
			case 3 fformat_currency = cstr(locale_info("LOCALE_SCURRENCY")) & cstr(out)
								exit function
			case 4 fformat_currency = "(" & cstr(out) & cstr(locale_info("LOCALE_SCURRENCY")) & ")"
								exit function
			case 5 fformat_currency = "-" & cstr(out) & cstr(locale_info("LOCALE_SCURRENCY"))
								exit function
			case 6 fformat_currency = cstr(out) & "-" & cstr(locale_info("LOCALE_SCURRENCY"))
								exit function
			case 7 fformat_currency = cstr(out) & cstr(locale_info("LOCALE_SCURRENCY")) & "-"
								exit function
			case 8 fformat_currency = "-" & cstr(out) & " " & cstr(locale_info("LOCALE_SCURRENCY"))
								exit function
			case 9 fformat_currency = "-" & cstr(locale_info("LOCALE_SCURRENCY")) & " " & cstr(out)
								exit function
			case 10 fformat_currency = cstr(out) & " " & cstr(locale_info("LOCALE_SCURRENCY")) & "-"
								exit function
			case 11 fformat_currency = cstr(locale_info("LOCALE_SCURRENCY")) & " " & cstr(out) & "-"
								exit function
			case 12 fformat_currency = cstr(locale_info("LOCALE_SCURRENCY")) & " -" & cstr(out)
								exit function
			case 13 fformat_currency = cstr(out) & "- " & cstr(locale_info("LOCALE_SCURRENCY"))
								exit function
			case 14 fformat_currency = "(" & cstr(locale_info("LOCALE_SCURRENCY")) & " " & cstr(out) & ")"
								exit function
			case 15 fformat_currency = "(" & cstr(out) & " " & cstr(locale_info("LOCALE_SCURRENCY")) & ")"
								exit function
		end select
	end if
	fformat_currency = val
end function


'//	converts mysql datetime to array(year,month,day,hour,minute,second)
function db2time(val)
	dim arr(6)
	arr(0)=""
	arr(1)=""
	arr(2)=""
	arr(3)=""
	arr(4)=""
	arr(5)=""
	if isnull(val) then
		db2time=arr
		exit function
	end if
	if isdate(val) then
		arr(0)=year(val)
		arr(1)=month(val)
		arr(2)=day(val)
		arr(3)=hour(val)
		arr(4)=minute(val)
		arr(5)=second(val)
		db2time=arr
		exit function
	end if
	str=CStr(val)
		dim isdst, havedate, havetime, pattern, y, mo, d, h, mi, s, vlen
	dim vnow(3)
	Dim regEx, Match, Matches
	Dim matchesCount
	Set regEx = New RegExp
	regEx.IgnoreCase = True
	regEx.Global = True
	pattern=""
	vnow(0)=year(now)
	vnow(1)=month(now)
	vnow(2)=day(now)
	
    havedate=0
	havetime=0
	if isNumeric(str) then
'//	timestamp
		havedate=1
		vlen=len(str)
		if vlen>=10 then havetime=1
		select case vlen
		  case 14 pattern="(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})"
		  case 12 pattern="(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})"
		  case 10 pattern="(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})"
		  case 8 pattern="(\d{4})(\d{2})(\d{2})"
		  case 6 pattern="(\d{2})(\d{2})(\d{2})"
		  case 4 pattern="(\d{2})(\d{2})"
		  case 2 pattern="(\d{2})"
	      case else
	        db2time = arr
		    exit function
	    end select
	    regEx.Pattern = pattern

		Set Matches = regEx.Execute(str)
		matchesCount = Matches.Count

		If matchesCount > 0 Then 
			set m=Matches(0)
			y = subMatches(0).Value

			If matchesCount > 1 Then
				mo = m.subMatches(1)
			Else
				mo = 1
			End If
			If matchesCount > 2 Then
				d = m.subMatches(2)
			Else
				d = 1
			End If
			If matchesCount > 3 Then
				h = m.subMatches(3)
			Else
				h = 0
			End If
			If matchesCount > 4 Then
				mi = m.subMatches(4)
			Else
				mi = 0
			end if
			If matchesCount > 5 Then
				s = m.subMatches(5)
			Else
				s = 0
			End If
		else
			db2time = arr
		    exit function
		end if
	else 
		if not isNumeric(str) and not isnull(str) and trim(str)<>"" then
	'// date,time,datetime
'			str=year(str) & "-" & month(str) & "-" & day(str) & " " & hour(str) & ":" & minute(str) & ":" & second(str)
			regEx.Pattern = "(\d{4})-(\d{1,2})-(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})"

			Set Matches = regEx.Execute(str)
			matchesCount = Matches.Count

			If matchesCount > 0 Then 
				set m=Matches(0)
				y = m.subMatches(0)
				mo = m.subMatches(1)
				d = m.subMatches(2)
				h = m.subMatches(3)
				mi = m.subMatches(4)
				s = m.subMatches(5)
				havedate=1
				havetime=1
			else 
				regEx.Pattern = "(\d{4})-(\d{1,2})-(\d{1,2})"
				Set Matches = regEx.Execute(str)
				matchesCount = Matches.Count

				If matchesCount > 0 Then 
					set m=Matches(0)
					y = m.subMatches(0)
					mo = m.subMatches(1)
					d = m.subMatches(2)
					h = 0
					mi = 0
					s = 0
					havedate=1
				else 
					regEx.Pattern = "(\d{2})-(\d{1,2})-(\d{1,2})"
					Set Matches = regEx.Execute(str)
					matchesCount = Matches.Count

					If matchesCount > 0 Then
						set m=Matches(0)
						y=vnow(0)
						mo=vnow(1)+1
						d=vnow(2)
						h = m.subMatches(3)
						mi = m.subMatches(4)
						s = m.subMatches(5)
						havetime=1
					else 
						db2time = arr
						exit function
					end if
				end if
			end if
		else
			db2time = arr
			exit function
		end if
	end if
	if havetime=0 then
		h=0
		mi=0
		s=0
	end if
	if havedate=0 then
		y=vnow(0)
		mo=vnow("1")+1
		d=vnow("2")
	end if
	arr(0)=y
	arr(1)=mo
	arr(2)=d
	arr(3)=h
	arr(4)=mi
	arr(5)=s
	db2time = arr
end function

function format_datetime(ttime())
	format_datetime = format_datetime_custom(ttime,locale_info("LOCALE_SSHORTDATE") & " " & locale_info("LOCALE_STIMEFORMAT"))
end function

function fformat_time(ttime())
	fformat_time = format_datetime_custom(ttime,locale_info("LOCALE_STIMEFORMAT"))
end function

function format_shortdate(ttime())
	format_shortdate = format_datetime_custom(ttime,locale_info("LOCALE_SSHORTDATE"))
end function

function format_longdate(ttime())
	format_longdate = format_datetime_custom(ttime,locale_info("LOCALE_SLONGDATE"))
end function

function simpledate2db(strdate,formatid)
	dim sstr, mmonth, dday, yyear
	dim numbers
	sstr=strdate
	numbers=parsenumbers(sstr)
	if uBound(numbers)=0 then simpledate2db = strdate 
	while uBound(numbers)<3
		numbers(uBound(numbers)+1)=1
	wend
	if formatid=0 then
		mmonth=numbers(0)
		dday=numbers(1)
		yyear=numbers(2)
	else 
		if formatid=1 then
			dday=numbers(0)
			mmonth=numbers(1)
			yyear=numbers(2)
		else 
			if formatid=2 then
				yyear=numbers(0)
				mmonth=numbers(1)
				dday=numbers(2)
			else
				simpledate2db = strdate
			end if
		end if
	end if
	if yyear<100 then
		if yyear<60 then
			yyear=yyear+2000
		else
			yyear=yyear+1900
		end if
	end if
	simpledate2db = yyear & "-" & mmonth & "-" & dday
end function


function localdate2db(strdate)
	localdate2db = simpledate2db(strdate,locale_info("LOCALE_IDATE"))
end function

function localtime2db(strtime)
'//	check if we use 12hours clock
	dim use12, pos, pm, amstr, pmstr, str, h, k
	dim numbers
	use12=0
	pos=instr(1,locale_info("LOCALE_STIMEFORMAT"),"h" & locale_info("LOCALE_STIME"))
	if pos>0 then 
		use12=1
'	determine am/pm
		pm=0
		amstr=locale_info("LOCALE_S1159")
		pmstr=locale_info("LOCALE_S2359")
		posam=instr(1,strtime,amstr)
		pospm=instr(1,strtime,pmstr)
		
		if posam=0 and pospm>0 then
			pm=1
		elseif posam>0 and pospm=0 then
			pm=0
		elseif posam=0 and pospm=0 then
			use12=0
		else
			if posam>pospm then _
				pm=1
		end if
	end if
	str=strtime
	numbers=parsenumbers(str)
	k=uBound(numbers)
	while k<3
		redim Preserve numbers(k+1)
		numbers(k)=0
		k=k+1
	wend
	h=numbers(0)
	m=numbers(1)
	s=numbers(2)
	if use12<>0 and h<>0 then
		if pm=0 and h=12 then h=0
		if pm=1 and h<12 then h=h+12
	end if
	localtime2db = cstr(h) & ":" & cstr(m) & ":" & cstr(s)
end function


function localdatetime2db(strdatetime,format)
	dim use12, locale_idate, pm, amstr, pmstr, pos, tm, mmonth, dday, yyear, h, m, s, l
	dim numbers
	locale_idate=locale_info("LOCALE_IDATE")
	if format="dmy" then locale_idate=1
	if format="mdy" then locale_idate=0
	if format="ymd" then locale_idate=2
'	check if we use 12hours clock
	use12=0
	pos=instr(1,locale_info("LOCALE_STIMEFORMAT"),"h" & locale_info("LOCALE_STIME"))
	if pos>0 then 
		use12=1
'	determine am/pm
		pm=0
		amstr=locale_info("LOCALE_S1159")
		pmstr=locale_info("LOCALE_S2359")
		posam=instr(1,strdatetime,amstr)
		pospm=instr(1,strdatetime,pmstr)
		
		if posam=0 and pospm>0 then
			pm=1
		elseif posam>0 and pospm=0 then
			pm=0
		elseif posam=0 and pospm=0 then
			use12=0
		else
			if posam>pospm then _
				pm=1
		end if
	end if
	numbers=parsenumbers(strdatetime)
	if isArray(numbers) then
		if uBound(numbers)<2 then	
			localdatetime2db = null
			exit function
		end if
	else
		localdatetime2db = null
		exit function
	end if
'//	add current year if not specified
	if uBound(numbers)<3 then
		if locale_idate<>1 then
			mmonth=numbers(0)
			dday=numbers(1)
		else
			mmonth=numbers(1)
			dday=numbers(0)
		end if
		yyear=year(now)
	else
		if locale_idate=0 then	
			mmonth=numbers(0)
			dday=numbers(1)
			yyear=numbers(2)
		else 
			if locale_idate=1 then
				dday=numbers(0)
				mmonth=numbers(1)
				yyear=numbers(2)
			else 
				if locale_idate=2 then
					yyear=numbers(0)
					mmonth=numbers(1)
					dday=numbers(2)
				end if
			end if
		end if
	end if
	if mmonth=0 or dday=0 then 
		localdatetime2db = null
		exit function
	end if
	l=uBound(numbers)
	while l<6
		redim preserve numbers(l+1)
		numbers(l)=0
		l=l+1
	wend
	h=numbers(3)
	m=numbers(4)
	s=numbers(5)
	if use12=1 and h<>0 then
		if pm=0 and h=12 then h=0
		if pm=1 and h<12 then h=h+12
	end if
	if yyear<100 then
		if yyear<60 then 
			yyear=yyear+2000
		else
			yyear=yyear+1900
		end if
	end if
	localdatetime2db = yyear & "-" & mmonth & "-" & dday & " " & h & ":" & m & ":" & s
end function

function parsenumbers(str)
	dim i, num, pos, j
	dim ret()
	i=1
	num=0
	pos=1
	j=0
	if len(str)=0 or isnull(str) then
		redim ret(0)
		parsenumbers = ret
		exit function
	end if
	while i<=len(str)
		if isNumeric(mid(str,i,1)) and num=0 then
			num=1
			pos=i
		else 
			if not isNumeric(mid(str,i,1)) and num<>0 then
				reDim Preserve ret(j+1)
				ret(j)=cint(mid(str,pos,i-pos))
				j=j+1
				num=0
			end if
		end if
		i=i+1
	wend
	if num<>0 then 
		reDim Preserve ret(j+1)
		//ret(j)=cint(mid(cstr(str),pos,i-pos+1))
		j=j+1
	end if
	if j=0 then
		redim ret(0)
		parsenumbers = ret
		exit function
	end if
	parsenumbers = ret
end function

'//	returns day of week (1-7) for (monday-sunday)
function format_datetime_custom(ttime(),format)
	dim i,weekday, hour12, am, out, inquot, n
	dim keys
	Set subst = CreateObject("Scripting.Dictionary")
	if isnull(ttime) then
		format_datetime_custom = ""
		exit function
	else
		if uBound(ttime)<3 or ttime(0)="" then 
			format_datetime_custom = ""
			exit function
		end if
	end if
	if ttime(1)=0 then _
		ttime(1)=1
	i=1
	weekday=getdayofweek(ttime)

	subst.Add "dddd",locale_info("LOCALE_SDAYNAME" & weekday)
	subst.Add "ddd",locale_info("LOCALE_SABBREVDAYNAME" & weekday)
	if len(cstr(ttime(2)))=1 then 
		subst.Add "dd","0" & cstr(ttime(2))
	else
		subst.Add "dd",cstr(ttime(2))
	end if
	subst.Add "d",ttime(2)
	subst.Add "MMMM",locale_info("LOCALE_SMONTHNAME" & ttime(1))
	subst.Add "MMM",locale_info("LOCALE_SABBREVMONTHNAME" & ttime(1))
	if len(cstr(ttime(1)))=1 then 
		subst.Add "MM","0" & cstr(ttime(1))
	else
		subst.Add "MM",cstr(ttime(1))
	end if
	subst.Add "M",ttime(1)

	var = CStr(ttime(0))
	while len(var)<4
	     var = "0" & var
	wend 
	subst.Add "yyyy", var
	
	var = CStr((ttime(0) mod 100))
	while len(var)<2
	     var = "0" & var
	wend 
	subst.Add "yy", var

	subst.Add "y",(ttime(0) mod 10)
	subst.Add "gg",""
	if len(cstr(ttime(3)))=1 then 
		subst.Add "HH","0" & cstr(ttime(3))
	else
		subst.Add "HH",cstr(ttime(3))
	end if
	subst.Add "H",ttime(3)
	if len(cstr(ttime(4)))=1 then 
		subst.Add "mm","0" & cstr(ttime(4))
	else
		subst.Add "mm",cstr(ttime(4))
	end if
	subst.Add "m",ttime(4)
	if len(cstr(ttime(5)))=1 then 
		subst.Add "ss","0" & cstr(ttime(5))
	else
		subst.Add "ss",cstr(ttime(5))
	end if
	subst.Add "s",ttime(5)
	hour12=ttime(3)
	am=1
	if hour12>=12 then
		am=0
		hour12=hour12-12
	end if
	if hour12=0 then hour12=12
	subst.Add "hh",cstr(hour12)
	subst.Add "h",hour12
	if am=1 then
		subst.Add "tt",locale_info("LOCALE_S1159")
		subst.Add "t",mid(locale_info("LOCALE_S1159"),1,1)
	else
		subst.Add "tt",locale_info("LOCALE_S2359")
		subst.Add "t",mid(locale_info("LOCALE_S2359"),1,1)
	end if
	out=format
	inquot=0
	while i<=len(out)
		if mid(out,i,1)="'" then
			inquot=1-inquot
			out=mid(out,1,i) & mid(out,i+2)
			flag=1
		else 
			if inquot=0 then
				for each key in subst
					if mid(out,i,len(key))=key then
						out=mid(out,1,i-1) & subst(key) & mid(out,len(key)+i)
						i=i+len(subst(key))-1
						exit for
					end if
				next
			end if
		end if
		i=i+1
	wend
	format_datetime_custom = out
end function

function getdayofweek(ttime())
	
dim daydif, i
'//	January 1, 2004 - Thursday
'//	Get the differewnce in days between January 1, 2004 and January 1 of given year
	daydif=0
	if ttime(0)>=2004 then
		for i=2004 to ttime(0)-1
			if isleapyear(i) then
				daydif=daydif+366
			else
				daydif=daydif+365
			end if
		next
	else
		for i=2003 to ttime(0) step -1
			if isleapyear(i) then
				daydif=daydif-366
			else
				daydif=daydif-365
			end if
		next
	end if
'//	to given month
	dim mdays(13)
	mdays(1)=31
	mdays(2)=28
	mdays(3)=31
	mdays(4)=30
	mdays(5)=31
	mdays(6)=30
	mdays(7)=31
	mdays(8)=31
	mdays(9)=30
	mdays(10)=31
	mdays(11)=30
	mdays(12)=31
	
	if isleapyear(ttime(0)) then mdays(2)=29
	
	for i=1 to ttime(1)-1
		daydif=daydif+mdays(i)
	next
'//	to given day
	daydif=daydif+ttime(2)-1
	if daydif>0 then 
		getdayofweek = (4+daydif-1) mod 7 + 1
		exit function
	end if
	getdayofweek = 7-(3-daydif) mod 7
end function

function isleapyear(y)
	if y mod 4 <>0 then 
		isleapyear = false
		exit function
	end if
	if y mod 100 <>0 then 
		isleapyear = true
		exit function
	end if
	if (y/100) mod 4 <> 0 then 
		isleapyear = false
		exit function
	end if
	isleapyear = true
end function

function GetLongDateFormat()
	dim format, dstart, inquote, dindex, mindex, yindex, i, c, f

	format=locale_info("LOCALE_SLONGDATE")

'//	dd,d - day
'//	MMMM, MMM, MM, M - month
'//	yyyy, yy, y - year
'//	dddd, ddd - day of week, ignore it
'//	'sdsd' - quoted string, ignore it.
	dstart=-1
	inquote=false
	dindex=-1
	mindex=-1
	yindex=-1
	i=0
	f=1
	while f=1
		c=""
		if i<len(format) then c=mid(format,i+1,1)
		if dstart>=0 and c<>"d" then
			if i-dstart<=2 then dindex=dstart
			dstart=-1
		end if
		if not inquote and c="\'" then
			inquote=true
		else 
			if c="\'" then
				inquote=false
			else 
				if not inquote then
					if dindex<0 and c="d" then
						if dstart<0 then dstart=i
					end if
					if yindex<0 and c="y" then yindex=i
					if mindex<0 and c="M" then mindex=i
				end if
			end if
		end if
		if i>=len(format) then f=0
		i=i+1
	wend
	if dindex<0 or mindex<0 or yindex<0 then 
		GetLongDateFormat = -1
		exit function
	end if
	if dindex<mindex and mindex<yindex then 
		GetLongDateFormat = 1	'// DMY 
		exit function
	end if
	if mindex<dindex and dindex<yindex then 
		GetLongDateFormat = 0	'// MDY
		exit function
	end if
	if yindex<mindex and mindex<dindex then 
		GetLongDateFormat = 2	'// YMD
		exit function
	end if
	if yindex<dindex and dindex<mindex then 
		GetLongDateFormat = 1	'// YDM
		exit function
	end if
	GetLongDateFormat = -1
end function

%>
