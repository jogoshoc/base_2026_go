<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","Moviment2"
	tdata.Add ".OwnerID",""

	
'	CodMov
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "CodMov"
	        	fdata.Add "FullName", "[Moviment].[CodMov]"
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
	        	fdata.Add "FullName", "[Moviment].[NrProtoc]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 2
	
			fdata.Add "EditParams",""
					fdata.Add "FieldPermissions",true
	tdata.Add "NrProtoc",fdata
	
'	DtMovim
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Dt Movim" 
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "DtMovim"
	        	fdata.Add "FullName", "[Moviment].[DtMovim]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 3
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "DtMovim",fdata
	
'	OrigNome
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","ORIGEM" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "OrigNome"
	        	fdata.Add "FullName", "[Moviment].[OrigNome]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 4
	
					fdata.Add "FieldPermissions",true
	tdata.Add "OrigNome",fdata
	
'	DestNome
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","DESTINO" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DestNome"
	        	fdata.Add "FullName", "[Moviment].[DestNome]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 5
	
					fdata.Add "FieldPermissions",true
	tdata.Add "DestNome",fdata
	
'	Obs
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Obs"
	        	fdata.Add "FullName", "[Moviment].[Obs]"
	
		
	
	fdata.Add "Index", 6
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=255"
				fdata.Add "FieldPermissions",true
	tdata.Add "Obs",fdata
	
'	Prazo
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "Prazo"
	        	fdata.Add "FullName", "[Moviment].[Prazo]"
	
		
	
	fdata.Add "Index", 7
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "Prazo",fdata
	
'	UsuaMov
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Incluido por" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Readonly"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "UsuaMov"
	        	fdata.Add "FullName", "[Moviment].[UsuaMov]"
	
		
	
	fdata.Add "Index", 8
	
					tdata.Add "UsuaMov",fdata
	
'	PastaArquiv
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Soluчуo" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "PastaArquiv"
	        	fdata.Add "FullName", "[Moviment].[PastaArquiv]"
	
		
	
	fdata.Add "Index", 9
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=255"
				fdata.Add "FieldPermissions",true
	tdata.Add "PastaArquiv",fdata
	
'	Cumprido
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Cumprido"
	        	fdata.Add "FullName", "[Moviment].[Cumprido]"
	
		
	
	fdata.Add "Index", 10
	
			fdata.Add "EditParams",""
					fdata.Add "FieldPermissions",true
	tdata.Add "Cumprido",fdata
tables_data.Add "Moviment2", tdata
%>