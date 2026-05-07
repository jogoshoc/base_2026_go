# SAdm — Secretaria Administrativa

> Módulo de gestão de processos, cadastros, tramitações e movimentações.

## Visão Geral
Módulo principal do sistema CGDoc para gestão de processos administrativos.
Responsável pelo CRUD completo de cadastros, controle de tramitações entre departamentos
e registro de movimentações de processos.

## Responsabilidades
- Autenticação e controle de sessão de usuários
- CRUD de processos (Cadastro)
- Controle de tramitação de processos
- Registro de movimentações
- Busca avançada com múltiplos critérios
- Geração de relatórios e impressões

## Regras de Negócio

| ID | Regra | Confiança |
|----|-------|-----------|
| RB-01 | Usuário deve estar autenticado para qualquer operação | 🟢 |
| RB-02 | Senha pode ser lembrada por 1 ano via cookies | 🟢 |
| RB-03 | Usuário admin (ID 1088608) tem acesso irrestrito | 🟢 |
| RB-04 | Verificação de permissão via CheckSecurity(ownerId, operacao) | 🟢 |
| RB-05 | Admin ignora verificações de owner | 🟢 |
| RB-06 | Busca avançada suporta critérios múltiplos com AND/OR | 🟢 |
| RB-07 | Campos podem validar nomes de estados brasileiros | 🟢 |

## Requisitos Funcionais

| ID | Requisito | Prioridade | Critério de Aceite |
|----|-----------|-----------|-------------------|
| RF-01 | Login com usuário e senha | Must | Redireciona para menu se válido, exibe erro se inválido |
| RF-02 | Logout com destruição de sessão | Must | Session.Abandon, cookies limpos, redireciona para login |
| RF-03 | Listar cadastros com paginação | Must | Exibe registros com navegação de páginas |
| RF-04 | Busca por qualquer campo | Must | Filtro funciona para todos os campos da entidade |
| RF-05 | Busca avançada com múltiplos critérios | Must | Suporta AND/OR entre critérios, negação (NOT) |
| RF-06 | Adicionar novo cadastro | Must | Insere registro no banco e redireciona para lista |
| RF-07 | Editar cadastro existente | Must | Atualiza registro e mantém na página de edição |
| RF-08 | Excluir cadastro | Must | Remove registro (se permitido) |
| RF-09 | Tramitar processo para outro departamento | Must | Registra tramitação com destino e data |
| RF-10 | Registrar movimentação de processo | Must | Registra tipo, data e descrição |
| RF-11 | Imprimir relatório | Must | Gera output para impressão |
| RF-12 | Exportar dados | Must | Exporta para formato compatível (Excel/CSV) |
| RF-13 | Alterar senha de usuário | Could | Usuário pode alterar própria senha |

## Requisitos Não Funcionais

| Tipo | Requisito inferido | Evidência no código | Confiança |
|------|--------------------|---------------------|-----------|
| Segurança | Autenticação obrigatória em todas as páginas | `*_list.asp:5-9` verifica Session("UserID") | 🟢 |
| Segurança | Autorização via RBAC com CheckSecurity | `include/aspfunctions.asp:1534-1561` | 🟢 |
| Segurança | Admin tem bypass completo | `include/aspfunctions.asp:1537` | 🟢 |
| Performance | Sessão expira após inatividade | `login.asp:120` redireciona se session expired | 🟡 |
| Usabilidade | Lembrar senha por 1 ano | `login.asp:34-36` | 🟢 |

> Inferido a partir do código. Validar com equipe de operações.

## Critérios de Aceitação

```gherkin
Dado usuário logado com credenciais válidas
Quando acessa página de listagem
Então exibe lista de cadastros com paginação

Dado usuário logado com credenciais válidas
Quando submete busca com múltiplos critérios (nome=João AND cidade=SP)
Então retorna apenas registros que satisfazem todos os critérios

Dado usuário logado com credenciais válidas
Quando tenta acessar sem permissão
Então exibe mensagem "Você não tem permissão para acessar esta tabela"

Dado usuário com sessão expirada
Quando tenta acessar qualquer página
Então redireciona para login.asp?message=expired
```

## Prioridade (MoSCoW)

| Requisito | MoSCoW | Justificativa |
|-----------|--------|---------------|
| Login e autenticação | Must | Caminho crítico, sem isso nada funciona |
| Listagem e busca | Must | Funcionalidade principal do módulo |
| CRUD Cadastro | Must | Core business do sistema |
| CRUD Tramitação | Must | Funcionalidade central |
| CRUD Movimentação | Should | Importante mas pode ter fallback |
| Exportação | Should | Importante para integração |
| Impressão | Could | Raramente usada |

> Prioridade inferida por frequência de chamada e posição na cadeia de dependências.

## Rastreabilidade de Código

| Arquivo | Função / Classe | Cobertura |
|---------|-----------------|-----------|
| `cgdoc/SAdm/login.asp` | Autenticação | 🟢 |
| `cgdoc/SAdm/include/dbcommon.asp` | Constantes, conexão DB | 🟢 |
| `cgdoc/SAdm/include/aspfunctions.asp` | CheckSecurity, validações | 🟢 |
| `cgdoc/SAdm/Cadastro_list.asp` | Listagem, busca, paginação | 🟢 |
| `cgdoc/SAdm/Cadastro_add.asp` | Adição de registros | 🟢 |
| `cgdoc/SAdm/Cadastro_edit.asp` | Edição de registros | 🟢 |
| `cgdoc/SAdm/Cadastro_search.asp` | Busca avançada | 🟢 |
| `cgdoc/SAdm/Tramitacao_list.asp` | Listagem tramitações | 🟢 |
| `cgdoc/SAdm/Moviment_list.asp` | Listagem movimentações | 🟢 |
| `cgdoc/SAdm/Usu_rios_list.asp` | Gestão de usuários | 🟢 |
| `cgdoc/SAdm/libs/smarty.asp` | Template engine | 🟢 |

## Observações

- 🔴 **Lacuna:** Schema exato do banco Access não disponível — inferido a partir do código
- 🟡 **Inferido:** Tempo de expiração de sessão não encontrado explicitamente
- 🟡 **Inferido:** Lógica completa de permissão por owner não totalmente mapeada