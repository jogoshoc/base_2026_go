# SAdm — Secretaria Administrativa, Design Técnico

> Design do módulo de gestão de processos administrativos.

## Interface

### Páginas e Rotas

| Arquivo ASP | Descrição | Método |
|-------------|-----------|--------|
| `login.asp` | Página de login | GET/POST |
| `menu.asp` | Menu principal | GET |
| `logout.asp` | Logout (via querystring) | GET |
| `Cadastro_list.asp` | Listagem de cadastros | GET |
| `Cadastro_add.asp` | Formulário de adição | GET |
| `Cadastro_addnewitem.asp` | Processa adição | POST |
| `Cadastro_edit.asp` | Formulário de edição | GET |
| `Cadastro_search.asp` | Busca avançada | GET/POST |
| `Cadastro_print.asp` | Impressão | GET |
| `Tramitacao_list.asp` | Listagem de tramitações | GET |
| `Tramitacao_addnewitem.asp` | Nova tramitação | POST |
| `Moviment_list.asp` | Listagem de movimentações | GET |
| `Moviment_addnewitem.asp` | Nova movimentação | POST |
| `Usu_rios_list.asp` | Gestão de usuários | GET |

### Entidades do Banco

| Entidade | Campos |
|----------|--------|
| Usuários | Usuário (PK), Senha, Privilégio |
| Cadastro | N_Processo (PK), Nome, Data, Descrição |
| Tramitação | id (PK), Protocolo, Data_Tramite, Destino, Origem, Processo (FK), Usuario (FK) |
| Movimentação | id (PK), Processo (FK), Data_Movto, Tipo, Descricao, Usuario (FK) |

## Fluxo Principal

### Login
1. Usuário acessa `login.asp`
2. Se GET: exibe formulário
3. Se POST com credenciais:
   - Consulta tabela `Usuários` com usuário e senha
   - Se válido: cria sessão (UserID, AccessLevel, GroupID)
   - Redireciona para `menu.asp` ou URL de retorno
   - Se inválido: exibe mensagem "Login Inválido"
4. Se botão "remember_password": armazena credenciais em cookies por 1 ano

### Autenticação de Página Protegida
1. Qualquer páginaProtected verifica `Session("UserID")`
2. Se vazio: redireciona `login.asp?message=expired`
3. Verifica `CheckSecurity(Session("OwnerID"), operacao)`
4. Se sem permissão: exibe mensagem de erro e encerra

### Busca Avançada
1. Usuário acessa `*_search.asp`
2. Sistema exibe formulário com campos de filtro
3. Usuário define critérios (campo, operador, valor)
4. Define tipo de combinação (AND/OR)
5. Submit armazena filtros em Session
6. Página de lista aplica filtros na query SQL

### CRUD Cadastro
1. **List:** Consulta todos registros com paginação
2. **Add:** Formulário → POST → INSERT → redirect para list
3. **Edit:** Formulário pré-preenchido → POST → UPDATE → redirect para list
4. **Delete:** POST → DELETE (se permitido) → redirect para list

## Fluxos Alternativos

- **Sessão expirada:** Redireciona para `login.asp?message=expired`
- **Credenciais inválidas:** Exibe mensagem "Login Inválido", mantém formulário
- **Sem permissão:** Exibe "Você não tem permissão para acessar esta tabela"
- **Busca vazia:** Exibe mensagem "Nenhum registro encontrado"
- **Erro de banco:** Exibe mensagem genérica, não expõe detalhes

## Dependências

| Componente | Arquivo | Uso |
|------------|---------|-----|
| Conexão DB | `include/dbcommon.asp` | Factory de conexão ADO |
| CheckSecurity | `include/aspfunctions.asp:1534` | Verificação de permissão |
| Smarty | `libs/smarty.asp` | Template engine |
| Variáveis de entidade | `include/Cadastro_variables.asp` | Definição de campos |

## Decisões de Design Identificadas

| Decisão | Evidência no código | Confiança |
|---------|---------------------|-----------|
| Autenticação via banco Access | `login.asp:53-68` | 🟢 |
| Sessão ASP nativa | Todas páginas | 🟢 |
| RBAC com owner-based | `aspfunctions.asp:1542-1545` | 🟡 |
| Admin bypass total | `aspfunctions.asp:1537-1538` | 🟢 |
| Busca com session storage | `Cadastro_list.asp:30-49` | 🟢 |
| Templates Smarty | `login.asp:125` | 🟢 |

## Estado Interno

### Variáveis de Sessão

| Variável | Tipo | Descrição |
|----------|------|-----------|
| UserID | String | ID do usuário logado |
| AccessLevel | String | Nível (Admin/User/Guest) |
| GroupID | String | Grupo/Privilégio |
| OwnerID | String | ID do proprietário |
| MyURL | String | URL de retorno pós-login |
| `{TableName}_search` | Integer | Flag de busca ativa |
| `{TableName}_asearch*` | Dictionary | Critérios de busca avançada |

## Observabilidade

- Erros de banco: `Call ReportError` após operações
- Validações: JavaScript no client-side
- Redirects: `Response.Redirect` com URL absoluta

## Riscos e Lacunas

- 🔴 Schema exato do Access não disponível — inferido a partir de código
- 🟡 Lógica de expiração de sessão não explicitada no código
- 🟡 Detalhes de implementação do ADO não visíveis
- 🟡 Campos opcionais de cada entidade não completos