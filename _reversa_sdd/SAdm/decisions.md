# SAdm — Decisões de Design

> Decisões arquiteturais identificadas no módulo SAdm.

## Decisões de Autenticação

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| Autenticação via banco Access | LDAP, OAuth, SAML | Sistema legado autônomo, sem AD |
| Sessão ASP nativa | JWT, Tokens | Simplicidade, tecnologia disponível |
| Credenciais em cookies (opcional) | Apenas sessão | Conveniência ao usuário |

## Decisões de Autorização

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| RBAC com 3 níveis | ACL, ABAC | Simples, suficiente para o caso |
| Admin bypass total | Verificação granular | Admin precisa gerenciar tudo |
| Owner-based permission | Permissão global | Registros pertencem a usuários |

## Decisões de Dados

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| Banco Access | SQL Server, MySQL | Tecnologia disponível no ambiente |
| ADO/OLE DB | ODBC, JDBC | Driver nativo para Access |
| Nomes de entidades em português | Nomes em inglês | Sistema legado brasileiro |

## Decisões de Interface

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| Templates Smarty | Razor, Blade | Template engine disponível |
| Busca em session storage | Query string, API | Persiste entre páginas |
| Paginação server-side | Client-side | Banco Access não suporta muita carga |

## Decisões de Busca Avançada

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| Múltiplos critérios com AND/OR | Apenas AND | Flexibilidade para usuários |
| Suporte a negação (NOT) | Apenas positivos | Necessidade de negócio |
| Operador "Empty" | Treat empty as null | Busca por valores nulos |

## Decisões de Segurança

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| Redirect ao session expire | Página de erro | Melhor UX |
| Mensagem genérica de erro | Detalhe do erro | Não expor informações |
| Validação client-side + server-side | Apenas server | UX + segurança |

## Incertezas e Questões Abertas

| Item | Status | Ação Necessária |
|------|--------|-----------------|
| Tempo de expiração de sessão | 🟡 | Validar com ops |
| Hash de senha | 🟡 | Verificar implementação |
| Campos opcionais completos | 🔴 | Acessar banco .mdb |
| Constraints de banco | 🔴 | Acessar schema |