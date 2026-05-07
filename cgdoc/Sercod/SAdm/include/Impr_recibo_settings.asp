<%
Set tdata = CreateObject("Scripting.Dictionary")
	 tdata.Add ".NumberOfChars",80 
	tdata.Add ".ShortName","Impr_recibo"
	tdata.Add ".OwnerID",""

	
'	NrProtoc
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 3
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "NrProtoc"
	        	fdata.Add "FullName", "[Impr_recibo].[NrProtoc]"
	
		
	
	fdata.Add "Index", 1
	
			fdata.Add "EditParams",""
					fdata.Add "FieldPermissions",true
	tdata.Add "NrProtoc",fdata
	
'	DtMovim
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 135
	fdata.Add "EditFormat", "Date"
	fdata.Add "ViewFormat", "Short Date"
	
	
	fdata.Add "GoodName", "DtMovim"
	        	fdata.Add "FullName", "[Impr_recibo].[DtMovim]"
	 fdata.Add "IsRequired",true 
		
	
	fdata.Add "Index", 2
	 fdata.Add "DateEditType",13 
					fdata.Add "FieldPermissions",true
	tdata.Add "DtMovim",fdata
	
'	Destino
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Destino"
	        	fdata.Add "FullName", "[Impr_recibo].[Destino]"
	
		
	
	fdata.Add "Index", 3
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Destino",fdata
	
'	Descr
	set fdata = CreateObject("Scripting.Dictionary")
	
	
	
	fdata.Add "FieldType", 200
	fdata.Add "EditFormat", "Text field"
	fdata.Add "ViewFormat", ""
	
	
	fdata.Add "GoodName", "Descr"
	        	fdata.Add "FullName", "[Impr_recibo].[Descr]"
	
		
	
	fdata.Add "Index", 4
	
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
	        	fdata.Add "FullName", "[Impr_recibo].[Nome]"
	
		
	
	fdata.Add "Index", 5
	
			fdata.Add "EditParams",""
			fdata("EditParams") = fdata("EditParams") & " maxlength=50"
				fdata.Add "FieldPermissions",true
	tdata.Add "Nome",fdata
tables_data.Add "Impr_recibo", tdata
%>