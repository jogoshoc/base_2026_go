<%@ Language=VBScript %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Servidor Web do IIS 5.1</title>
</head>
<body>
<%
' Configurando algumas variáveis para apresentar informações do servidor
Dim strComputerName, strServerSoftware, strServerIP
strComputerName = Request.ServerVariables("SERVER_NAME")
strServerSoftware = Request.ServerVariables("SERVER_SOFTWARE")
strServerIP = Request.ServerVariables("LOCAL_ADDR")

' Verificando se as extensões do FrontPage estão instaladas
Dim blnFrontPageExtensions
blnFrontPageExtensions = False
On Error Resume Next
Dim fso, testFile
Set fso = Server.CreateObject("Scripting.FileSystemObject")
' Verifica se existe o arquivo _vti_inf.html - indicativo das Extensões do FrontPage
If fso.FileExists(Server.MapPath("/_vti_inf.html")) Then
    blnFrontPageExtensions = True
End If
On Error Goto 0
%>

<h1>Bem-vindo ao Servidor Web do Microsoft IIS 5.1</h1>

<p>Esta página foi gerada automaticamente pelo Microsoft Internet Information Services 5.1.</p>

<h2>Informações do Servidor:</h2>
<ul>
    <li><strong>Nome do servidor:</strong> <%= strComputerName %></li>
    <li><strong>Software do servidor:</strong> <%= strServerSoftware %></li>
    <li><strong>Endereço IP do servidor:</strong> <%= strServerIP %></li>
    <li><strong>Extensões do FrontPage:</strong> <% If blnFrontPageExtensions Then Response.Write("Instaladas") Else Response.Write("Não instaladas") End If %></li>
</ul>

<h2>Links úteis:</h2>
<ul>
    <li><a href="http://localhost/iishelp/iis/misc/default.asp">Documentação online do IIS 5.1</a></li>
    <% If blnFrontPageExtensions Then %>
    <li><a href="/_vti_inf.html">Informações de configuração do FrontPage</a></li>
    <% End If %>
</ul>

<hr>
<p><em>Data e hora atual do servidor: <%= Now() %></em></p>

</body>
</html>