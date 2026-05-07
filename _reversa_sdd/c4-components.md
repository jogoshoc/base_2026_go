# C4 - Componentes

> Diagrama C4 Nível 3: Componentes do Módulo SAdm

```mermaid
C4Component
    title Diagrama de Componentes - Módulo SAdm

    ContainerDb(access, "Banco de Dados", "Access", "SisprotWeb.mdb")

    ContainerDb(usuarios_table, "Usuários", "Tabela", "Autenticação")
    ContainerDb(cadastro_table, "Cadastro", "Tabela", "Processos")
    ContainerDb(tramitacao_table, "Tramitação", "Tabela", "Encaminhamentos")
    ContainerDb(movimentacao_table, "Movimentação", "Tabela", "Histórico")

    Component(auth, "Módulo Auth", "login.asp", "Autenticação de usuários")
    Component(security, "Segurança", "CheckSecurity()", "Controle de acesso RBAC")
    Component(session, "Gerência Sessão", "Session", "Estado do usuário")
    Component(crud_cadastro, "CRUD Cadastro", "Cadastro_*.asp", "Gestão de processos")
    Component(crud_tramitacao, "CRUD Tramitação", "Tramitacao_*.asp", "Tramitação")
    Component(crud_moviment, "CRUD Movimentação", "Moviment_*.asp", "Movimentações")
    Component(search, "Busca Avançada", "*_search.asp", "Filtros com AND/OR")
    Component(template, "Smarty", "libs/smarty.asp", "Template engine")
    Component(dbconn, "Conexão DB", "dbcommon.asp", "Factory de conexão")

    Rel(funcionario, auth, "Login")
    Rel(auth, session, "Cria sessão")
    Rel(auth, usuarios_table, "Valida credenciais")
    Rel(security, usuarios_table, "Verifica permissões")
    Rel(security, session, "Lê nível acesso")

    Rel(crud_cadastro, dbconn, "Opera dados")
    Rel(crud_tramitacao, dbconn, "Opera dados")
    Rel(crud_moviment, dbconn, "Opera dados")
    Rel(search, dbconn, "Consulta filtros")

    Rel(dbconn, cadastro_table, "CRUD")
    Rel(dbconn, tramitacao_table, "CRUD")
    Rel(dbconn, movimentacao_table, "CRUD")

    Rel(crud_cadastro, template, "Renderiza")
    Rel(crud_tramitacao, template, "Renderiza")
    Rel(crud_moviment, template, "Renderiza")
    Rel(search, template, "Renderiza")
```

## Componentes por Camada

### Camada de Apresentação
| Componente | Arquivo | Descrição |
|------------|---------|-----------|
| Smarty | libs/smarty.asp | Template engine |

### Camada de Negócio
| Componente | Arquivo | Descrição |
|------------|---------|-----------|
| Módulo Auth | login.asp | Autenticação |
| Segurança | CheckSecurity() | RBAC |
| CRUD Cadastro | Cadastro_*.asp | Operações processo |
| CRUD Tramitação | Tramitacao_*.asp | Operações tramitação |
| CRUD Movimentação | Moviment_*.asp | Operações movimentação |
| Busca Avançada | *_search.asp | Filtros complexos |

### Camada de Dados
| Componente | Arquivo | Descrição |
|------------|---------|-----------|
| Conexão DB | dbcommon.asp | Factory de conexão ADO |

### Camada de Sessão
| Componente | Descrição |
|------------|-----------|
| Session | Variáveis de estado |