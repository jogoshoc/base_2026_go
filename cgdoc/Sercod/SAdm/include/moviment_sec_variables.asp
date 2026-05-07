<%

strTableName="moviment_sec"

strOriginalTableName="moviment_sec"

gPageSize=20
ColumnsCount = 1

gstrOrderBy="ORDER BY [NrProtoc] DESC, [CodMov] ASC"
if len(gstrOrderBy)>0 and lcase(mid(gstrOrderBy,1,8))<>"order by" then gstrOrderBy="order by " & gstrOrderBy
	
gstrSQL = "select [CodMov],   [NrProtoc],   [CodMovGeral],   [DtMovim],   [OrigNome],   [DestNome],   [Obs],   [Solucao],   [Prazo],   [Cumprido],   [UsuaMov]  From [moviment_sec]"

'//	thumbnails

 Set thumbnail_fields = CreateObject("Scripting.Dictionary")
 Set thumbnail_prefixes = CreateObject("Scripting.Dictionary")
	thumbnail_fields.Add 0,"Field1"
	thumbnail_fields.Add 1,"Field2"
'//	field names are case-sensitive!
dim thumbnail_prefixes
	thumbnail_prefixes.Add "Field1","t1_"
	thumbnail_prefixes.Add "Field2","t2_"
	
thumbnail_maxsize = 150


%>
<!--#include file="moviment_sec_settings.asp"-->
<!--#include file="moviment_sec_events.asp"-->
