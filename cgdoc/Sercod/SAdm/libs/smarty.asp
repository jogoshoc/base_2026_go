<%

set foreachstack = CreateObject("Scripting.Dictionary")
set foreachvars = CreateObject("Scripting.Dictionary")

function process_tag(str)
Dim i
' remove {}
    str=mid(str,2,len(str)-2)
	str=trim(str)
	process_tag=""
	fore=""
	if len(str)=0 then exit function
	if mid(str,1,1)="$" then
		if instr(1,str,".")=0 then
			process_tag = "response.write smarty(""" & mid(str,2) & """)"
		else
			item=""
			p=instr(1,str,".")
			item=mid(str,p+1)
			forvar=mid(str,2,p-2)
			forexpr=""
			for each tt in foreachvars
				if foreachvars(tt)=forvar then
					forexpr=foreachstack(tt)
					exit for
				end if
			next
'			process_tag = "response.write smarty(""" & session("fore") & """)(dd)(""" & item & """)"
			process_tag = "response.write " & forexpr & "(""" & item & """)"
		end if
	elseif mid(str,1,2)="if" then
		expr=trim(mid(str,3))
		expr=mid(expr,2)
		var=expr
		for i=1 to len(expr)
		  c = asc(mid(expr,i,1))
		  if not ( c>=asc("a") and c<=asc("z") or c>=asc("0") and c<=asc("9") or c>=asc("A") and c<=asc("Z") or c=asc("_") or c=asc(".")) then
 		     var=left(expr,i-1)
		     exit for
		  end if
		next
		oper=""
		if len(expr)>len(var) then
			oper=mid(expr,len(var)+1)
			oper=replace(oper,"!=","<>")
			oper=replace(oper,"==","=")
		end if
		
		p=instr(1,var,".")
		if p>0 then
			item=mid(var,p+1)
			forvar=left(var,p-1)
			forexpr=""
			for each tt in foreachvars
				if foreachvars(tt)=forvar then
					forexpr=foreachstack(tt)
					exit for
				end if
			next
'			var="smarty(""" & session("fore") & """)(dd)(""" & item & """)"
			var=forexpr & "(""" & item & """)"
		else
			var="smarty(""" & var & """)"
		end if
		process_tag=" if " & var & oper & " then "
	elseif mid(str,1,4)="else" then
		process_tag="else"
	elseif mid(str,1,3)="/if" then
		process_tag="end if"
	elseif mid(str,1,7)="foreach" then
		p1=instr(1,str,"$")
		p2=instr(p1,str," ")
		var = mid(str,p1+1,p2-p1-1)
		p4=instr(1,str,"item=")
		foritem = mid(str,p4+5)
		item=var
		forvar=mid(str,p1+1,p2-p1-1)
		p3=instr(1,forvar,".")
		if p3>0 then
			item=mid(forvar,p3+1)
			forvar=left(forvar,p3-1)
			forexpr=""
			for each tt in foreachvars
				if foreachvars(tt)=forvar then
					forexpr=foreachstack(tt)
					exit for
				end if
			next
		else
			forexpr="smarty"
		end if

		foreachvars.Add foreachvars.Count, foritem
		foreachstack.Add foreachstack.Count, forexpr & "(""" & item & """)(dd"& CStr(foreachstack.Count) & ")"

'		process_tag="for each dd in smarty(""" & session("fore") & """)"
		process_tag="for each dd"& CStr(foreachvars.Count-1)&" in " & forexpr & "(""" & item & """)"
	elseif mid(str,1,8)="/foreach" then
		dd=0
		process_tag="next"
		foreachstack.Remove foreachstack.Count-1
		foreachvars.Remove foreachvars.Count-1
	elseif mid(str,1,17)="include_if_exists" then		
	p=instr(1,str,"file=")
	if p>0 then
		process_tag= "set fs=Server.CreateObject(""Scripting.FileSystemObject"") : if fs.FileExists(Server.Mappath(""" & mid(str,p+6,len(str)-p-6) & """))=true then Server.Execute(""" & mid(str,p+6,len(str)-p-6) & """)" 
	end if	
	elseif mid(str,1,7)="include" then
		p=instr(1,str,"file=")
		if p>0 then
			process_tag="smart_smarty_display(""" & smarty(mid(str,p+7,len(str)-p-7)) & """)"
		end if
		
	elseif mid(str,1,18)="build_edit_control" then
		str2=mid(str,20)
		str2=replace(str2,"field=",vbcrlf & "bec_field=")
		str2=replace(str2,"mode=",vbcrlf & "bec_mode=")
		str2=replace(str2,"second=",vbcrlf & "bec_second=")
		str2=replace(str2,"value=",vbcrlf & "bec_value=")
		str2 = "bec_second=false" & vbcrlf & str2 & vbcrlf
		p1=instr(1,str2,"$")
		do while p1>0
			p2=instr(p1,str2,vbcrlf)
			str2 = left(str2,p1-1) & "smarty.item(""" & trim(mid(str2,p1+1,p2-p1-1)) & """)" & mid(str2,p2)
			p1=instr(1,str2,"$")
		loop
		process_tag = str2 & "smarty_function_build_edit_control()"
	elseif mid(str,1,13)="mlang_message" then
		p=instr(1,str,"tag=")
		if p>0 then
			process_tag="smarty_function_mlang_message(" & mid(str,p+4) & ")"
		end if
	elseif mid(str,1,10)="show_chart" then
		process_tag="smarty_function_show_chart(""" & Replace(mid(str,11),"""", """""") & """)"
	elseif mid(str,1,7)="doevent" then
		p=instr(1,str,"name=")
		if p>0 then
			process_tag="DoEvent ""Call " & mid(str,p+6) & ""
		end if
	end if
end function


' creates temporary file, returns filename
function process_file(filename)
	Dim Filepath
	Filepath = Server.MapPath("templates\" & Filename)	
	dim stream

	set stream=Server.CreateObject("ADODB.Stream")
	stream.CharSet=cCharset
	stream.type=2
	stream.Open
	stream.LoadFromFile Filepath

	dim text
	text = stream.ReadText
	stream.Close
	set stream=nothing
	dim linestart
	dim lineend
	linestart=1
	' create output string
	Dim res

	dim literal
	literal=false
	res=""
	' Read the file line by line
	Do While linestart>0
		lineend=instr(linestart,text,vbcrlf)
		Dim Line
		if lineend>0 then
			Line = mid(text,linestart,lineend-linestart)
			linestart=lineend+2
		else
			Line = mid(text,linestart)
			linestart=0
		end if
		' Process SMARTY tags
		dim pos,opos
		pos=1
		opos=1
		do 
			if literal then
				pos=InStr(opos,Line,"{/literal}")
				if pos>0 then
					res=res & "response.write """ & replace(Mid(Line,opos,pos-opos),"""","""""") & """" & vbcrlf
					opos=pos+len("{/literal}")
					literal=false
				else
					res=res & "response.write """ & replace(Mid(Line,opos),"""","""""") & """ & vbcrlf" & vbcrlf
					exit do
				end if
			end if
			pos=InStr(opos,Line,"{")
			if pos>0 then
				if pos>opos then _
					res=res & "response.write """ & replace(Mid(Line,opos,pos-opos),"""","""""") & """" & vbcrlf
				opos=pos
				pos=InStr(opos,Line,"}")
				if pos=0 then
					res=res & "response.write """ & replace(Mid(Line,opos),"""","""""") & """ & vbcrlf" & vbcrlf
					exit do
				end if
				if Mid(Line,opos,pos-opos+1)="{literal}" then
					literal=true
				else
					res=res & process_tag(Mid(Line,opos,pos-opos+1)) & vbcrlf
				end if
				opos=pos+1
			else
				res=res & "response.write """ & replace(Mid(Line,opos),"""","""""") & """ & vbcrlf" & vbcrlf
				exit do
			end if
		loop
	
	Loop
	process_file=res
end function

function smarty_function_build_edit_control()
	dim mode
	dim fformat
	if bec_mode="edit" then
		mode=MODE_EDIT
	else 
		if bec_mode="add" then
			mode=MODE_ADD
		else
			mode=MODE_SEARCH
		end if
	end if
	
	fformat=GetEditFormat(bec_field,"")
	if (mode=MODE_EDIT or mode=MODE_ADD) and fformat=EDIT_FORMAT_READONLY then
		response.Write readonlyfields(bec_field)
	end if
	if mode=MODE_SEARCH then
		fformat=editformats(bec_field)
	end if
	BuildEditControl bec_field,CStr(dbvalue(bec_value)),fformat,mode,bec_second
end function

function smarty_function_mlang_message(tag)
	response.Write " " & mlang_message(tag)
	response.Flush
	smarty_function_mlang_message = my_htmlspecialchars(mlang_message(tag))
end function

sub smarty_display(filename)
	smart_smarty_display(filename)
	set smarty=nothing
end sub

sub smart_smarty_display(filename)
	dim res
	res = process_file(filename)

'	response.write res
	execute res
end sub

function smarty_function_show_chart(str)

set params = ParseParams(str)

%>
<object 
classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" 
codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
width="<%=params("width")%>" 
height="<%=params("height")%>" 
align="middle">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="libs/swf/<%=GetChartType(params("name"))%>.swf?XMLFile=<%=params("name")%>_chartdata.asp%3Fwidth%3D<%=params("width")%>%26height%3D<%=params("height")%>" />
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" /> 
<embed src="libs/swf/<%=GetChartType(params("name"))%>.swf?XMLFile=<%=params("name")%>_chartdata.asp%3Fwidth%3D<%=params("width")%>%26height%3D<%=params("height")%>" quality="high" bgcolor="#ffffff" 
width="<%=params("width")%>" height="<%=params("height")%>" name="RELEASE" align="middle" allowScriptAccess="sameDomain" 
type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>

<%

end function




Set smarty = CreateObject("Scripting.Dictionary")

dd=0
Session("fore")="rowinfo"
%>