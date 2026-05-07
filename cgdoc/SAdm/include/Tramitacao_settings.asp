<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","Tramitacao"
	tdata.Add ".OwnerID",""

	
'	NrProtoc
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Nr Protoc" 
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "NrProtoc"
	        	fdata.Add "FullName", "[Tramitacao].[NrProtoc]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 1
	
			fdata.Add "EditParams",""
					fdata.Add "FieldPermissions",true
	tdata.Add "NrProtoc",fdata
	
'	CodMov
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "CodMov"
	        	fdata.Add "FullName", "[Tramitacao].[CodMov]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 2
	
			fdata.Add "EditParams",""
					tdata.Add "CodMov",fdata
	
'	DtMovim
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Data Movim." 
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "DtMovim"
	        	fdata.Add "FullName", "[Tramitacao].[DtMovim]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 3
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "DtMovim",fdata
	
'	OrigNome
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Seзгo ORIGEM" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "OrigNome"
	        	fdata.Add "FullName", "[Tramitacao].[OrigNome]"
	
		
	
	fdata.Add "Index", 4
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "OrigNome",fdata
	
'	DestNome
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Seзгo DESTINO" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DestNome"
	        	fdata.Add "FullName", "[Tramitacao].[DestNome]"
	
		
	
	fdata.Add "Index", 5
	
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
	        	fdata.Add "FullName", "[Tramitacao].[Obs]"
	
		
	
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
	        	fdata.Add "FullName", "[Tramitacao].[Prazo]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 7
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "Prazo",fdata
	
'	Emissor
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Emissor"
	        	fdata.Add "FullName", "[Tramitacao].[Emissor]"
	
		
	
	fdata.Add "Index", 8
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Emissor",fdata
	
'	Assunto
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Assunto"
	        	fdata.Add "FullName", "[Tramitacao].[Assunto]"
	
		
	
	fdata.Add "Index", 9
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=255"
				fdata.Add "FieldPermissions",true
	tdata.Add "Assunto",fdata
	
'	TipoDoc
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Tipo" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "TipoDoc"
	        	fdata.Add "FullName", "[Tramitacao].[TipoDoc]"
	
		
	
	fdata.Add "Index", 10
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "TipoDoc",fdata
	
'	Descr
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Descriзгo" 
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Descr"
	        	fdata.Add "FullName", "[Tramitacao].[Descr]"
	
		
	
	fdata.Add "Index", 11
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Descr",fdata
	
'	Nome
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Nome"
	        	fdata.Add "FullName", "[Tramitacao].[Nome]"
	
		
	
	fdata.Add "Index", 12
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Nome",fdata
	
'	DtEntr
	set fdata = CreateObject("Scripting.Dictionary")
	 fdata.Add "Label","Data Entrada" 
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "DtEntr"
	        	fdata.Add "FullName", "[Tramitacao].[DtEntr]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 13
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "DtEntr",fdata
tables_data.Add "Tramitacao", tdata
%>