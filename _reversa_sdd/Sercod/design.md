# Sercod — Secretaria de Códigos, Design Técnico

> Design do módulo de codificação de processos.

## Interface

### Estrutura de Arquivos

Idêntica ao SAdm. Ver `SAdm/design.md` para detalhes completos.

### Páginas e Rotas

| Arquivo ASP | Descrição |
|-------------|-----------|
| `login.asp` | Página de login |
| `menu.asp` | Menu principal |
| `Cadastro_list.asp` | Listagem |
| `Cadastro_add.asp` | Adição |
| `Cadastro_edit.asp` | Edição |
| `Cadastro_search.asp` | Busca avançada |
| `Tramitacao_list.asp` | Listagem tramitações |
| `Moviment_list.asp` | Listagem movimentações |
| `Usu_rios_list.asp` | Gestão de usuários |

## Fluxo Principal

Idêntico ao SAdm. Ver `SAdm/design.md` para detalhes.

## Fluxos Alternativos

Idênticos ao SAdm.

## Dependências

| Componente | Arquivo | Uso |
|------------|---------|-----|
| Conexão DB | `include/dbcommon.asp` | Factory de conexão ADO |
| CheckSecurity | `include/aspfunctions.asp` | Verificação de permissão |
| Smarty | `libs/smarty.asp` | Template engine |

## Decisões de Design Identificadas

| Decisão | Evidência no código | Confiança |
|---------|---------------------|-----------|
| Clone do SAdm | Estrutura de arquivos idêntica | 🟢 |
| Mesmo banco de dados | `db/SisprotWeb.mdb` | 🟢 |
| Autenticação compartilhada | `login.asp` | 🟢 |

## Estado Interno

Idêntico ao SAdm. Ver `SAdm/design.md`.

## Observabilidade

Idêntico ao SAdm.

## Riscos e Lacunas

- 🔴 Funcionalidades específicas de codificação não mapeadas
- 🟡 Este módulo precisa de análise mais profunda para identificar diferenciação do SAdm