# Code-Spec Matrix

> Rastreabilidade: qual arquivo do legado está coberto por qual spec.

## Legenda

| Símbolo | Significado |
|---------|-------------|
| 🟢 | Cobertura total - comportamento extraído e documentado |
| 🟡 | Cobertura parcial - inferido, pode haver variações |
| 🔴 | Sem cobertura - não mapeado |
| n/a | Não aplicável - arquivo de configuração/metadata |

## Arquivos do Legado → Units

### Módulo SAdm

| Arquivo do Legado | Unit | Cobertura |
|-------------------|------|-----------|
| `cgdoc/SAdm/login.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/menu.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/changepwd.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/include/dbcommon.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/include/aspfunctions.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/include/commonfunctions.asp` | SAdm | 🟡 |
| `cgdoc/SAdm/libs/smarty.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Cadastro_list.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Cadastro_add.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Cadastro_addnewitem.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Cadastro_edit.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Cadastro_search.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Cadastro_print.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Tramitacao_list.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Tramitacao_*.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Moviment_list.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Moviment_*.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/moviment_sec_*.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/moviment_sec2_*.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Usu_rios_*.asp` | SAdm | 🟢 |
| `cgdoc/SAdm/Impr_recibo_*.asp` | SAdm | 🟡 |
| `cgdoc/SAdm/_AudMoviment_*.asp` | SAdm | 🟡 |

### Módulo Sercod

| Arquivo do Legado | Unit | Cobertura |
|-------------------|------|-----------|
| `cgdoc/Sercod/login.asp` | Sercod | 🟢 |
| `cgdoc/Sercod/menu.asp` | Sercod | 🟢 |
| `cgdoc/Sercod/include/dbcommon.asp` | Sercod | 🟢 |
| `cgdoc/Sercod/include/aspfunctions.asp` | Sercod | 🟢 |
| `cgdoc/Sercod/libs/smarty.asp` | Sercod | 🟢 |
| `cgdoc/Sercod/Cadastro_*.asp` | Sercod | 🟡 |
| `cgdoc/Sercod/Tramitacao_*.asp` | Sercod | 🟡 |
| `cgdoc/Sercod/Moviment_*.asp` | Sercod | 🟡 |
| `cgdoc/Sercod/Usu_rios_*.asp` | Sercod | 🟡 |

### Arquivos não mapeados (n/a)

| Arquivo | Motivo |
|---------|--------|
| `cgdoc/**/_vti_cnf/*` | Metadata FrontPage |
| Arquivos de configuração IIS | Não código |
| Arquivos de banco .mdb | Binary |

## Resumo de Cobertura

| Unit | Arquivos Cobertos | Total Estimado | % |
|------|-------------------|----------------|---|
| SAdm | ~60 | ~70 | ~86% |
| Sercod | ~30 | ~70 | ~43% |
| **Total** | **~90** | **~140** | **~64%** |

## Gap Analysis

### SAdm
- Cobertura boa (~86%)
- Lacunas: arquivos de impressão, auditoria

### Sercod
- Cobertura parcial (~43%)
- **Maior gap:** clone do SAdm, funcionalidades específicas não identificadas
- Ação recomendada: analisar banco de dados para identificar diferenciação

## Ação Recomendada

Para melhorar cobertura:
1. 🔴 Acessar arquivo `SisprotWeb.mdb` para validar schema
2. 🔴 Analisar diferenciação entre SAdm e Sercod
3. 🟡 Mapear campos completos de cada entidade