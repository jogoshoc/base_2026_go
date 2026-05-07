# Matriz de Permissões — Projeto CGDoc

> Gerado pelo Reversa Detective em 2026-05-06
> Nível de Documentação: Completo

## Papéis de Usuário

O sistema define 3 níveis de acesso:

| Papel | Constante | Descrição |
|-------|-----------|-----------|
| Administrador | `ACCESS_LEVEL_ADMIN` | Acesso irrestrito a todas as operações |
| Usuário | `ACCESS_LEVEL_USER` | Acesso padrão às funcionalidades |
| Convidado | `ACCESS_LEVEL_GUEST` | Acesso restrito (leitura?) |

---

## Permissões por Operação

### Tabela de Permissões

| Operação | Administrador | Usuário | Convidado |
|----------|---------------|---------|-----------|
| **Search** | ✅ Sempre | ✅ Verifica `CheckSecurity` | ✅ Verifica `CheckSecurity` |
| **Add** | ✅ Sempre | ✅ Verifica `CheckSecurity` | ❌ Bloqueado |
| **Edit** | ✅ Sempre | ✅ Verifica `CheckSecurity` | ❌ Bloqueado |
| **Delete** | ✅ Sempre | ✅ Verifica `CheckSecurity` | ❌ Bloqueado |
| **Export** | ✅ Sempre | ✅ Verifica `CheckSecurity` | ❌ Bloqueado |
| **Print** | ✅ Sempre | ✅ Verifica `CheckSecurity` | ❟ Desconhecido |

---

## Função CheckSecurity

### Assinatura
```
CheckSecurity(strValue, strAction) -> Boolean
```

### Parâmetros
- `strValue`: OwnerID do registro (ou sessão)
- `strAction`: Operação (`Search`, `Add`, `Edit`, `Delete`, `Export`)

### Lógica de Verificação

```
1. Se cAdvSecurityMethod = ADVSECURITY_ALL OU AccessLevel = ADMIN
   → Retorna True

2. Se AccessLevel = ADMIN
   → Retorna True (e sai)

3. Se Session("OwnerID") = strValue
   → Retorna True

4. Caso contrário
   → Retorna False
```

---

## Variáveis de Sessão

| Variável | Tipo | Descrição |
|----------|------|-----------|
| `Session("UserID")` | String | ID do usuário logado |
| `Session("AccessLevel")` | String | Nível de acesso (ADMIN/USER/GUEST) |
| `Session("GroupID")` | String | Grupo/Privilégio do usuário |
| `Session("OwnerID")` | String | ID do proprietário dos dados |
| `Session("MyURL")` | String | URL de retorno após login |

---

## Controle por Página

Cada página ASP verifica permissões antes de executar:

```asp
' Verifica sessão
if Session("UserID")="" then
    response.Redirect "login.asp?message=expired"
end if

' Verifica permissão
if not CheckSecurity(Session("OwnerID"),"Search") then
    response.Write "Você não tem permissão..."
end if
```

---

## Recursos expostos na UI

As permissões são expostas no template Smarty:

| Variável Smarty | Descrição |
|-----------------|-----------|
| `allow_delete` | Mostrar botão de excluir |
| `allow_add` | Mostrar botão de adicionar |
| `allow_edit` | Mostrar botão de editar |
| `allow_export` | Mostrar botão de exportar |
| `allow_search` | Habilitar busca |

---

## Observações

- **RBAC Simples:** Não há granularidade por entidade — a mesma permissão se aplica a todas
- **Owner ID:** O sistema verifica se o usuário é "dono" do registro para permitir edição
- **Admin bypass:** Administrador ignora todas as verificações
- **Lacuna:** Detalhes de `ACCESS_LEVEL_GUEST` não confirmados no código

---

## Confiança

| Símbolo | Significado |
|---------|-------------|
| 🟢 CONFIRMADO | Extraído diretamente do código (`include/dbcommon.asp`, `include/aspfunctions.asp`) |
| 🟡 INFERIDO | Baseado em padrões |
| 🔴 LACUNA | Informação não disponível |