# SAdm — Mapeamento do Legado

> Arquivos do legado que compõem o módulo SAdm.

## Estrutura de Arquivos

```
cgdoc/SAdm/
├── login.asp                    # Autenticação
├── menu.asp                     # Menu principal
├── changepwd.asp                # Alteração de senha
├── include/
│   ├── dbcommon.asp             # Conexão DB, constantes
│   ├── aspfunctions.asp         # Funções utilitárias (CheckSecurity)
│   ├── commonfunctions.asp      # Funções comuns
│   ├── Cadastro_variables.asp   # Definição de campos
│   └── (outros _variables.asp)  # Definições por entidade
├── libs/
│   └── smarty.asp               # Template engine
├── Cadastro_*.asp              # CRUD de Cadastro (~10 arquivos)
├── Tramitacao_*.asp            # CRUD de Tramitação (~10 arquivos)
├── Moviment_*.asp              # CRUD Movimentação (~10 arquivos)
├── Moviment2_*.asp             # Movimentação secundária (~10 arquivos)
├── moviment_sec_*.asp          # Movimentação secretarial (~10 arquivos)
├── moviment_sec2_*.asp         # Movimentação secretarial 2 (~10 arquivos)
├── Usu_rios_*.asp              # Gestão de usuários (~10 arquivos)
├── Impr_recibo_*.asp           # Impressão de recibos (~10 arquivos)
├── _AudMoviment_*.asp          # Auditoria (~10 arquivos)
└── (outros arquivos)
```

## Arquivos por Funcionalidade

### Autenticação e Sessão

| Arquivo | Linhas | Função |
|---------|--------|--------|
| `login.asp` | 126 | Login, logout, sessão |
| `include/dbcommon.asp` | ~100 | Constantes de acesso |
| `include/aspfunctions.asp` | ~1600 | CheckSecurity |

### CRUD Cadastro

| Arquivo | Função |
|---------|--------|
| `Cadastro_list.asp` | Listagem, busca, paginação |
| `Cadastro_add.asp` | Formulário de adição |
| `Cadastro_addnewitem.asp` | Processa adição |
| `Cadastro_edit.asp` | Formulário de edição |
| `Cadastro_search.asp` | Busca avançada |
| `Cadastro_print.asp` | Impressão |
| `Cadastro_imager.asp` | Visualização de imagem |
| `Cadastro_download.asp` | Download |
| `Cadastro_fulltext.asp` | Busca em texto |
| `Cadastro_detailspreview.asp` | Preview |
| `Cadastro_searchsuggest.asp` | Auto-complete |

### CRUD Tramitação

Mesma estrutura do Cadastro (~10 arquivos com prefixo `Tramitacao_`)

### CRUD Movimentação

Mesma estrutura do Cadastro (~10 arquivos com prefixos `Moviment_`, `Moviment2_`, `moviment_sec_`, `moviment_sec2_`)

### Gestão de Usuários

Mesma estrutura do Cadastro (~10 arquivos com prefixo `Usu_rios_`)

## Contagem Total

| Categoria | Quantidade |
|-----------|------------|
| Arquivos principais | ~100 |
| Arquivos _vti_cnf | ~400+ (metadata) |
| Total estimado | ~500+ |

## Cobertura de Specs

| Unit | Arquivos Cobertos | % Cobertura |
|------|------------------|-------------|
| SAdm | ~100 principais | ~80% |

> Os arquivos _vti_cnf são metadados do FrontPage, não código de negócio.

## Arquivos Não Mapeados

- Arquivos de configuração do IIS
- Arquivos de tema/estilo (se existirem)
- Bibliotecas externas (Smarty)