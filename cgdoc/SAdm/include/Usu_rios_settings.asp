<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","Usu_rios"
	tdata.Add ".OwnerID","Seção"

	
'	NúmeroDoUsuário
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "N_meroDoUsu_rio"
	        	fdata.Add "FullName", "[Usuários].[NúmeroDoUsuário]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 1
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=8"
				fdata.Add "FieldPermissions",true
	tdata.Add "NúmeroDoUsuário",fdata
	
'	PG
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "PG"
	        	fdata.Add "FullName", "[Usuários].[PG]"
	
		
	
	fdata.Add "Index", 2
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=7"
				fdata.Add "FieldPermissions",true
	tdata.Add "PG",fdata
	
'	Nome
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Nome"
	        	fdata.Add "FullName", "[Usuários].[Nome]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 3
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Nome",fdata
	
'	Ramal
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Ramal"
	        	fdata.Add "FullName", "[Usuários].[Ramal]"
	
		
	
	fdata.Add "Index", 4
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=4"
				fdata.Add "FieldPermissions",true
	tdata.Add "Ramal",fdata
	
'	Unidade
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Unidade"
	        	fdata.Add "FullName", "[Usuários].[Unidade]"
	
		
	
	fdata.Add "Index", 5
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Unidade",fdata
	
'	Seção
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Se__o"
	        	fdata.Add "FullName", "[Usuários].[Seção]"
	 fdata.Add "IsRequired",true 
		
	 fdata.Add "UploadFolder","files" 
	fdata.Add "Index", 6
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=15"
				fdata.Add "FieldPermissions",true
	tdata.Add "Seção",fdata
	
'	Fotografia
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 128
	fdata.Add "EditFormat", "Database image"
	fdata.Add "ViewFormat", "Database Image"
	
	
	fdata.Add "GoodName", "Fotografia"
	        	fdata.Add "FullName", "[Usuários].[Fotografia]"
	
		
	
	fdata.Add "Index", 7
	
					fdata.Add "FieldPermissions",true
	tdata.Add "Fotografia",fdata
	
'	Senha
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Password"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Senha"
	        	fdata.Add "FullName", "[Usuários].[Senha]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 8
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=8"
				fdata.Add "FieldPermissions",true
	tdata.Add "Senha",fdata
	
'	Privilegio
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Privilegio"
	        	fdata.Add "FullName", "[Usuários].[Privilegio]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 9
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Privilegio",fdata
tables_data.Add "Usuários", tdata
%>