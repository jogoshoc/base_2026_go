<%


function bstr2shortint(str,bigendian)
	if bigendian then
		bstr2shortint=ascb(midb(str,1,1))*256+ascb(midb(str,2,1))
	else
		bstr2shortint=ascb(midb(str,2,1))*256+ascb(midb(str,1,1))
	end if
end function

function parsejpg(file)
'Extract info from a JPEG 
'	read all segments
	dim ptr
	dim stype
	dim seglen
	dim channels
	ptr=3
	dim ret(7)
	ret(0)=0
	set img_xfile = CreateObject("Scripting.Dictionary")
	do while true
		if lenb(file)<ptr+3 then _
			exit do
		stype=ascb(midb(file,ptr+1,1))
		if stype>=&Hc0 and stype<=&Hcf and stype<>&Hc4 and stype<>&Hcc then
			if lenb(file)<ptr+9 then _
				exit do
			ret(0)=bstr2shortint(midb(file,ptr+7,2),true)	'width
			ret(1)=bstr2shortint(midb(file,ptr+5,2),true)	'height
			ret(2)=ascb(midb(file,ptr+4,1))
			channels=ascb(midb(file,ptr+9,1))
			if channels=3 then
				ret(3)="DeviceRGB"
			elseif channels then
				ret(3)="DeviceCMYK"
			else
				ret(3)="DeviceGray"
			end if
			ret(4)="DCTDecode"
			ret(5)=lenb(file)
			ret(6)=file
			exit do
		end if
		seglen=bstr2shortint(midb(file,ptr+2,2),true)
		ptr=ptr+2+seglen
	loop
	parsejpg=ret
end function

function parsegif(file)
	dim ret(7)
	ret(0)=0
'	load file header
	dim version
	dim colorTable
	dim localColorTable
	version=midb(file,1,6)
	width=bstr2shortint(midb(file,7,2),false)
	height=bstr2shortint(midb(file,9,2),false)
	b = ascb(midb(file,11,1))
	if bitand(b,&H80)<>0 then
		bGlobalClr = true
	else
		bGlobalClr = false
	end if
	nColorRes = bitand(b,&H70)/16
	if bitand(b,&H08)<>0 then
		bSorted = true
	else
		bSorted = false
	end if
	pow = bitand(b,&H07)
	nTableSize=2
	dim i
	for i=1 to pow
		nTableSize = nTableSize*2
	next
	nBgColor = ascb(midb(file,12,1))
	nPixelRatio = ascb(midb(file,13,1))
	hdrLen = 13
	if bGlobalClr then
		colorTable = midb(file,hdrLen+1,3*nTableSize)
		hdrLen = hdrLen + 3*nTableSize
	end if
	ptr=hdrLen+1
'	load image
	do while true
		b = ascb(midb(file,ptr,1))
		ptr=ptr+1
		if b=&H21 then
'	extension, skip it
			ptr=ptr+1
			b=ascb(midb(file,ptr,1))
			while b>0
				ptr=ptr+1+b
				b=ascb(midb(file,ptr,1))
			wend
			ptr=ptr+1
		elseif b=&H2C then
'	load image header
			b=ascb(midb(file,ptr+8,1))
			bLocalClr = bitand(b,&H80)
			bInterlace = bitand(b,&H80)
			bSorted = bitand(b,&H80)
			nLocalTableSize = bitand(b,&H80)
			pow = bitand(b,&H07)
			nLocalTableSize=2
			for i=1 to pow
				nLocalTableSize = nLocalTableSize*2
			next
			if bLocalClr<>0 then
				localColorTable = midb(file,ptr+9,nLocalTableSize*3)
				ptr=ptr+9+nLocalTableSize*3
			else
				ptr=ptr+9
			end if
'	load image 
			data = LZWDecompress(midb(file,ptr))
'	return image info
			dim nColors
			dim pal
			dim colspace
			if bLocalClr<>0 then
				nColors = nLocalTableSize
				pal = localColorTable
				colspace="Indexed"
			elseif bGlobalClr<>0 then
				nColors = nTableSize
				pal = colorTable
				colspace="Indexed"
			else
				nColors = 0
				colspace="DeviceGray"
				pal=""
			end if
			ret(0)=width
			ret(1)=height
			ret(2)=colspace
			ret(3)=8
			ret(4)=pal
			ret(5)=lenb(data)
			ret(6)=data
		else
			parsegif=ret
			exit function
		end if
	loop
	
end function
%>
<!--#include file="lzw.asp"-->
<script language="jscript" runat="server">
	function bitand(n, mask)
	{
		return (n&mask);
	}
</script>
