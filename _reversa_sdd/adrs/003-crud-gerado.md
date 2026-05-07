# ADR-003: Arquitetura CRUD Gerada Automaticamente

## Status
Aceito

## Contexto
O sistema possui múltiplas entidades (Cadastro, Tramitação, Movimentação, Usuários) que seguem o mesmo padrão de operações.

## Decisão
Cada entidade segue um padrão fixo de 10 arquivos ASP:

| Sufixo | Função |
|--------|--------|
| `_list.asp` | Lista/busca |
| `_add.asp` | Formulário de adição |
| `_addnewitem.asp` | Processa adição |
| `_edit.asp` | Formulário de edição |
| `_search.asp` | Busca avançada |
| `_print.asp` | Impressão |
| `_imager.asp` | Visualização de imagem |
| `_getfile.asp` | Recupera arquivo |
| `_download.asp` | Download |
| `_fulltext.asp` | Busca em texto completo |
| `_detailspreview.asp` | Visualização rápida |
| `_searchsuggest.asp` | Auto-complete |

## Consequências

### Positivas
- Manutenção previsível
- Novas entidades seguem o mesmo padrão
- Interface consistente para o usuário

### Negativas
- Alto acoplamento (código repetido)
- Difícil customização por entidade
- ~100 arquivos por módulo para múltiplas entidades

## Referências
- Estrutura observada em `cgdoc/SAdm/`

---

## Metadata

| Campo | Valor |
|-------|-------|
| **Autor** | Reversa (retroativo) |
| **Data** | 2026-05-06 |
| **Confidence** | 🟢 CONFIRMADO |