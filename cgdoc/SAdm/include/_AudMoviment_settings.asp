<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","_AudMoviment"
	tdata.Add ".OwnerID",""

	
'	CodMov
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "CodMov"
	        	fdata.Add "FullName", "[_AudMoviment].[CodMov]"
	
		
	
	fdata.Add "Index", 1
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "CodMov",fdata
	
'	NrProtoc
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "NrProtoc"
	        	fdata.Add "FullName", "[_AudMoviment].[NrProtoc]"
	
		
	
	fdata.Add "Index", 2
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "NrProtoc",fdata
	
'	DataAlteracao
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DataAlteracao"
	        	fdata.Add "FullName", "[_AudMoviment].[DataAlteracao]"
	
		
	
	fdata.Add "Index", 3
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=255"
				fdata.Add "FieldPermissions",true
	tdata.Add "DataAlteracao",fdata
	
'	DataAnt
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DataAnt"
	        	fdata.Add "FullName", "[_AudMoviment].[DataAnt]"
	
		
	
	fdata.Add "Index", 4
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "DataAnt",fdata
	
'	DataMod
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DataMod"
	        	fdata.Add "FullName", "[_AudMoviment].[DataMod]"
	
		
	
	fdata.Add "Index", 5
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "DataMod",fdata
	
'	OrigAnt
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "OrigAnt"
	        	fdata.Add "FullName", "[_AudMoviment].[OrigAnt]"
	
		
	
	fdata.Add "Index", 6
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "OrigAnt",fdata
	
'	OrigMod
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "OrigMod"
	        	fdata.Add "FullName", "[_AudMoviment].[OrigMod]"
	
		
	
	fdata.Add "Index", 7
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "OrigMod",fdata
	
'	DestAnt
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DestAnt"
	        	fdata.Add "FullName", "[_AudMoviment].[DestAnt]"
	
		
	
	fdata.Add "Index", 8
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "DestAnt",fdata
	
'	DestMod
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "DestMod"
	        	fdata.Add "FullName", "[_AudMoviment].[DestMod]"
	
		
	
	fdata.Add "Index", 9
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "DestMod",fdata
	
'	ObsAnt
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 201
	fdata.Add "EditFormat", "Text area"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "ObsAnt"
	        	fdata.Add "FullName", "[_AudMoviment].[ObsAnt]"
	
		
	
	fdata.Add "Index", 10
	
		fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " rows=250"
		fdata.Add "nRows", 250
			fdata("EditParams") = fdata("EditParams") & " cols=500"
		fdata.Add "nCols", 500
				fdata.Add "FieldPermissions",true
	tdata.Add "ObsAnt",fdata
	
'	ObsMod
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 201
	fdata.Add "EditFormat", "Text area"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "ObsMod"
	        	fdata.Add "FullName", "[_AudMoviment].[ObsMod]"
	
		
	
	fdata.Add "Index", 11
	
		fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " rows=250"
		fdata.Add "nRows", 250
			fdata("EditParams") = fdata("EditParams") & " cols=500"
		fdata.Add "nCols", 500
				fdata.Add "FieldPermissions",true
	tdata.Add "ObsMod",fdata
	
'	PrazoAnt
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "PrazoAnt"
	        	fdata.Add "FullName", "[_AudMoviment].[PrazoAnt]"
	
		
	
	fdata.Add "Index", 12
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "PrazoAnt",fdata
	
'	PrazoMod
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "PrazoMod"
	        	fdata.Add "FullName", "[_AudMoviment].[PrazoMod]"
	
		
	
	fdata.Add "Index", 13
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "PrazoMod",fdata
	
'	ID
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "ID"
	        	fdata.Add "FullName", "[_AudMoviment].[ID]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 14
	
			fdata.Add "EditParams",""
					fdata.Add "FieldPermissions",true
	tdata.Add "ID",fdata
tables_data.Add "_AudMoviment", tdata
%>