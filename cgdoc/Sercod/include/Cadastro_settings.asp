<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","Cadastro"
	tdata.Add ".OwnerID",""

	
    '	Controle
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Controle"
	fdata.Add "FullName", "[Cadastro].[Controle]"
	fdata.Add "Index", 1
	fdata.Add "EditParams",""
	tdata.Add "Controle",fdata
	
	'	NrProtoc
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","Nr Protoc" 
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "NrProtoc"
	fdata.Add "FullName", "[Cadastro].[NrProtoc]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 2
	fdata.Add "FieldPermissions",true
	tdata.Add "NrProtoc",fdata
	
	'	DtEntr
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","Data Entrada" 
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	fdata.Add "GoodName", "DtEntr"
	fdata.Add "FullName", "[Cadastro].[DtEntr]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 3
	fdata.Add "DateEditType",13 
	fdata.Add "FieldPermissions",true
	tdata.Add "DtEntr",fdata
    
	'	Descr
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","Descriчуo" 
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Descr"
	fdata.Add "FullName", "[Cadastro].[Descr]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 4
	fdata.Add "EditParams",""
	fdata.Add "FieldPermissions",true
	tdata.Add "Descr",fdata
	
	'	Emissor
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","EMISSOR" 
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Emissor"
	fdata.Add "FullName", "[Cadastro].[Emissor]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 5
	fdata.Add "FieldPermissions",true
	tdata.Add "Emissor",fdata
	
	'	Nome
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Nome"
	fdata.Add "FullName", "[Cadastro].[Nome]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 6
	fdata.Add "EditParams",""
	fdata.Add "FieldPermissions",true
	tdata.Add "Nome",fdata
    
	'	CPF
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 11
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "CPF"
	fdata.Add "FullName", "[Cadastro].[CPF]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 7
	fdata.Add "EditParams",""
	fdata.Add "FieldPermissions",true
	tdata.Add "CPF",fdata
    
	'	MASP
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 10
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "MASP"
	fdata.Add "FullName", "[Cadastro].[MASP]"
	fdata.Add "IsRequired",true
	fdata.Add "Index", 8
	fdata.Add "EditParams",""
	fdata.Add "FieldPermissions",true
	tdata.Add "MASP",fdata


	'	Assunto
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Assunto"
   	fdata.Add "FullName", "[Cadastro].[Assunto]"
    fdata.Add "IsRequired",true 
	fdata.Add "Index", 9
	fdata.Add "EditParams",""
	fdata.Add "FieldPermissions",true
	tdata.Add "Assunto",fdata
	
	'	TipoDoc
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "TipoDoc"
	fdata.Add "FullName", "[Cadastro].[TipoDoc]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 10
	fdata.Add "FieldPermissions",true
	tdata.Add "TipoDoc",fdata
	
	'	Nat
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","Natureza" 
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Radio button"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Nat"
   	fdata.Add "FullName", "[Cadastro].[Nat]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 11
	fdata.Add "FieldPermissions",true
	tdata.Add "Nat",fdata
	
	'	Destino
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","DESTINO" 
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Lookup wizard"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Destino"
	fdata.Add "FullName", "[Cadastro].[Destino]"
	fdata.Add "IsRequired",true 
	fdata.Add "Index", 12
	fdata.Add "FieldPermissions",true
	tdata.Add "Destino",fdata
	
	'	Obs
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 201
	fdata.Add "EditFormat", "Text area"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Obs"
   	fdata.Add "FullName", "[Cadastro].[Obs]"
	fdata.Add "Index", 13
	fdata.Add "EditParams",""
	fdata("EditParams") = fdata("EditParams") & " rows=60"
	fdata.Add "nRows", 60
	fdata("EditParams") = fdata("EditParams") & " cols=240"
	fdata.Add "nCols", 240
	fdata.Add "FieldPermissions",true
	tdata.Add "Obs",fdata
    
	'	Usuario
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "Label","Incluido por" 
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Readonly"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "Usuario"
	fdata.Add "FullName", "[Cadastro].[Usuario]"
	fdata.Add "Index", 14
	tdata.Add "Usuario",fdata
	
'	PastaArquiv
	set fdata = CreateObject("Scripting.Dictionary")
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	fdata.Add "GoodName", "PastaArquiv"
   	fdata.Add "FullName", "[Cadastro].[PastaArquiv]"
	fdata.Add "Index", 15
	fdata.Add "EditParams",""
	tdata.Add "PastaArquiv",fdata

tables_data.Add "Cadastro", tdata
%>