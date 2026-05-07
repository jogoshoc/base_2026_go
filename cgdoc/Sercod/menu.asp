<%
if SESSION("UserID")="" then
	response.Redirect "login.asp"
	response.End
end if
%>
<!--#include file="include/dbcommon.asp"-->


<!--#include file="libs/smarty.asp"-->

<%

smarty.Add "username",SESSION("UserID")
res=false
if SESSION("AccessLevel") <> ACCESS_LEVEL_GUEST then res=true
smarty.Add "not_a_guest",res
strPerm = GetUserPermissions("Cadastro")
res=false
if not (instr(strPerm, "A")=0 and instr(strPerm, "S")=0) then res=true
AddDict smarty,"allow_Cadastro",res
strPerm = GetUserPermissions("Impr_recibo")
res=false
if not (instr(strPerm, "A")=0 and instr(strPerm, "S")=0) then res=true
AddDict smarty,"allow_Impr_recibo",res
strPerm = GetUserPermissions("Tramitacao")
res=false
if not (instr(strPerm, "A")=0 and instr(strPerm, "S")=0) then res=true
AddDict smarty,"allow_Tramitacao",res
strPerm = GetUserPermissions("Usuários")
res=false
if not (instr(strPerm, "A")=0 and instr(strPerm, "S")=0) then res=true
AddDict smarty,"allow_Usu_rios",res
strPerm = GetUserPermissions("_AudMoviment")
res=false
if not (instr(strPerm, "A")=0 and instr(strPerm, "S")=0) then res=true
AddDict smarty,"allow__AudMoviment",res


smarty_display("menu.htm")
%>