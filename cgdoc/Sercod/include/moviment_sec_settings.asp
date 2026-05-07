<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","moviment_sec"
	tdata.Add ".OwnerID",""

	
'	CodMov
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","CodDist" 
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "CodMov"
	        	fdata.Add "FullName", "[moviment_sec].[CodMov]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 1
	
			fdata.Add "EditParams",""
					tdata.Add "CodMov",fdata
	
'	NrProtoc
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Nr Protoc" 
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "NrProtoc"
	        	fdata.Add "FullName", "[moviment_sec].[NrProtoc]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 2
	
			fdata.Add "EditParams",""
					tdata.Add "NrProtoc",fdata
	
'	CodMovGeral
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Readonly"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "CodMovGeral"
	        	fdata.Add "FullName", "[moviment_sec].[CodMovGeral]"
	
		
	
	fdata.Add "Index", 3
	
					tdata.Add "CodMovGeral",fdata
	
'	DtMovim
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Data Distrib" 
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "DtMovim"
	        	fdata.Add "FullName", "[moviment_sec].[DtMovim]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 4
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "DtMovim",fdata
	
'	OrigNome
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Origem (seзгo)" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Readonly"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "OrigNome"
	        	fdata.Add "FullName", "[moviment_sec].[OrigNome]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 5
	
					tdata.Add "OrigNome",fdata
	
'	DestNome
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Destino (func)" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DestNome"
	        	fdata.Add "FullName", "[moviment_sec].[DestNome]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 6
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "DestNome",fdata
	
'	Obs
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Obs"
	        	fdata.Add "FullName", "[moviment_sec].[Obs]"
	
		
	
	fdata.Add "Index", 7
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=255"
				fdata.Add "FieldPermissions",true
	tdata.Add "Obs",fdata
	
'	Solucao
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Soluзгo" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Solucao"
	        	fdata.Add "FullName", "[moviment_sec].[Solucao]"
	
		
	
	fdata.Add "Index", 8
	
			fdata.Add "EditParams",""
					fdata.Add "FieldPermissions",true
	tdata.Add "Solucao",fdata
	
'	Prazo
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "Prazo"
	        	fdata.Add "FullName", "[moviment_sec].[Prazo]"
	
		
	
	fdata.Add "Index", 9
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "Prazo",fdata
	
'	Cumprido
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Cumprido"
	        	fdata.Add "FullName", "[moviment_sec].[Cumprido]"
	
		
	
	fdata.Add "Index", 10
	
					fdata.Add "FieldPermissions",true
	tdata.Add "Cumprido",fdata
	
'	UsuaMov
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Incluido por" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Readonly"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "UsuaMov"
	        	fdata.Add "FullName", "[moviment_sec].[UsuaMov]"
	
		
	
	fdata.Add "Index", 11
	
					tdata.Add "UsuaMov",fdata
tables_data.Add "moviment_sec", tdata
%>