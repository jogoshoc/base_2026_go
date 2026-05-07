<%

dim MAX_LZW_BITS
dim lzTableSize
dim lzNext(0)
dim lzVals(0)
dim lzStack(0)
dim lzsp
dim lzBuf(0)

dim lzFresh
dim lzCodeSize
dim lzSetCodeSize
dim lzMaxCode
dim lzMaxCodeSize
dim lzFirstCode
dim lzOldCode
dim lzClearCode
dim lzEndCode
dim lzCurBit
dim lzLastBit
dim lzDone
dim lzLastByte
dim lzData

dim shltable


function LZWDecompress(data)

	dim i
	redim shltable(32)
	shltable(0)=1
	for i=1 to 31
		shltable(i)=2*shltable(i-1)
	next

	MAX_LZW_BITS = 12
	lzTableSize=1
	for i=1 to MAX_LZW_BITS
		lzTableSize=lzTableSize*2
	next
	redim lzNext(lzTableSize)
	redim lzVals(lzTableSize)
	redim lzStack(lzTableSize*2)
	redim lzBuf(280)
	
	lzData=data
	
	lzSetCodeSize = ascb(midb(data,1,1))
	lzCodeSize    = lzSetCodeSize + 1
	lzClearCode   = 1 
	for i=1 to lzSetCodeSize 
		lzClearCode=lzClearCode*2
	next
	lzEndCode     = lzClearCode + 1
	lzMaxCode     = lzClearCode + 2
	lzMaxCodeSize = lzClearCode *2
		
	lzCurBit   = 0
	lzLastBit  = 0
	lzDone     = 0
	lzLastByte = 2
	
	lzFresh = 1
	for i=0 to lzClearCode-1
		lzNext(i) = 0
		lzVals(i) = i
	next

	for i=lzClearCode to lzTableSize-1
		lzNext(i) = 0
		lzVals(i) = 0
	next

	lzsp = 0

	for i=0 to lzTableSize*2-1
		lzStack(i)=i
	next
	for i=0 to 279
		lzBuf(i)=i
	next
	
	stLen  = lenb(data)
	datLen = 0
	ret    = ""

	ptr=2

	dim  tmp
	tmp=""
	dim  tmp1
	tmp1=""
	dim  tmp2
	tmp2=""

	iIndex = LZWCommand(ptr)
	while iIndex >= 0
		tmp=tmp & chrb(iIndex)
		if lenb(tmp)>100 then
			tmp1=tmp1 & tmp
			tmp=""
		end if
		if lenb(tmp1)>1000 then
			tmp2=tmp2 & tmp1
			tmp1=""
		end if
		if lenb(tmp2)>10000 then
			ret=ret & tmp2
			tmp2=""
		end if
		iIndex = LZWCommand(ptr)
	wend
	ret=ret & tmp2 & tmp1 & tmp

	lzdatLen = lzstLen - lenb(data)
	if iIndex <> -2 then
		LZWDecompress=""
		exit function
	end if
	LZWDecompress=ret
end function


function LZWCommand(ptr)
	dim i
	if lzFresh<>0 then
		lzFresh = 0
		do 
			lzFirstCode = LZGetCode(ptr)
			lzOldCode   = lzFirstCode
		loop while lzFirstCode = lzClearCode
		LZWCommand=lzFirstCode
		exit function
	end if

	if lzsp > 0 then
		lzsp=lzsp-1
		LZWCommand=lzStack(lzsp)
		exit function
	end if

	dim Code
	Code = LZGetCode(ptr)
	while Code>=0
		if Code = lzClearCode then
			for i = 0 to lzClearCode-1
				lzNext(i) = 0
				lzVals(i) = i
			next

			for i=lzClearCode to lzTableSize-1
				lzNext(i) = 0
				lzVals(i) = 0
			next

			lzCodeSize    = lzSetCodeSize + 1
			lzMaxCodeSize = lzClearCode *2
			lzMaxCode     = lzClearCode + 2
			lzsp          = 0
			lzFirstCode   = LZGetCode(ptr)
			lzOldCode     = lzFirstCode
			LZWCommand=lzFirstCode
			exit function
		end if

		if Code = lzEndCode then
			LZWCommand=-2
			exit function
		end if
		dim InCode
		InCode = Code
		if Code >= lzMaxCode then
			lzStack(lzsp) = lzFirstCode
			lzsp = lzsp+1
			Code = lzOldCode
		end if

		while Code >= lzClearCode 
			lzStack(lzsp) = lzVals(Code)
			lzsp = lzsp+1
			if Code = lzNext(Code) then ' Circular table entry, big GIF Error!
				LZWCommand=-1
				exit function
			end if
			Code = lzNext(Code)
		wend

		lzFirstCode = lzVals(Code)
		lzStack(lzsp) = lzFirstCode
		lzsp = lzsp+1

			Code=lzMaxCode
			if Code  < lzTableSize then
				lzNext(Code) = lzOldCode
				lzVals(Code) = lzFirstCode
				lzMaxCode = lzMaxCode+1
				if lzMaxCode >= lzMaxCodeSize and lzMaxCodeSize < lzTableSize then
					lzMaxCodeSize = lzMaxCodeSize*2
					lzCodeSize = lzCodeSize+1
				end if
			end if

			lzOldCode = InCode
			if lzsp > 0 then
				lzsp = lzsp-1
				LZWCommand=lzStack(lzsp)
				exit function
			end if
		Code = LZGetCode(ptr)
	wend

	LZWCommand=Code
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''

function LZGetCode(ptr)
	dim i
	if lzCurBit + lzCodeSize >= lzLastBit then
		if lzDone<>0 then
			if lzCurBit >= lzLastBit then
				' Ran off the end of my bits
				LZGetCode=0
				exit function
			end if
			LZGetCode=-1
			exit function
		end if

		lzBuf(0) = lzBuf(lzLastByte - 2)
		lzBuf(1) = lzBuf(lzLastByte - 1)

		dim Count
		Count = ascb(midb(lzData,ptr,1))
		ptr=ptr+1

		
		if Count<>0 then
			for i = 0 to Count-1
				lzBuf(2 + i) = ascb(midb(lzData,ptr+i,1))
			next
			ptr=ptr+Count
		else 
			lzDone = 1
		end if

		lzLastByte = 2 + Count
		lzCurBit   = (lzCurBit - lzLastBit) + 16
		lzLastBit  = (2 + Count) * 8
	end if

	dim iRet
	iRet = 0
	dim j
	i = lzCurBit
	idiv8=bitshr(i,3)
	imod8=i mod 8
	j=0

	dim t
	t=0
	if lzCodeSize+imod8>=16 then
		iRet=cutbits3(lzBuf(idiv8),lzBuf(idiv8+1),lzBuf(idiv8+2),imod8,shltable(lzCodeSize)-1)
	else
		iRet=cutbits2(lzBuf(idiv8),lzBuf(idiv8+1),imod8,shltable(lzCodeSize)-1)
	end if

	lzCurBit =lzCurBit + lzCodeSize
	LZGetCode = iRet
end function
%>
<script language="jscript" runat="server">
	function cutbits2(n1,n2,offset,mask)
	{
		return (((n1 | (n2<<8) ))>>offset)&mask;
	}
	function cutbits3(n1,n2,n3,offset,mask)
	{
		return (((n1 | (n2<<8) | (n3<<16)))>>offset)&mask;
	}

	function bitshl(i, n)
	{
		return (i<<n);
	}
	function bitshr(i, n)
	{
		return (i>>n);
	}
	function bitor(n, mask)
	{
		return (n|mask);
	}

</script>