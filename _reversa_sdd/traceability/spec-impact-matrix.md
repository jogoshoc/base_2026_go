# Spec Impact Matrix — Projeto CGDoc

> Matriz de impacto entre componentes e funcionalidades

## Legenda
- **CRUD** = Create, Read, Update, Delete
- **→** = Impacta/Depende de

## Componentes vs Entidades

| Componente | Usuários | Cadastro | Tramitação | Movimentação | Audit |
|------------|:--------:|:--------:|:----------:|:------------:|:-----:|
| **Auth** | CRUD | | | | |
| **CheckSecurity** | Read | | | | |
| **Session** | Write | | | | |
| **Cadastro CRUD** | | CRUD | | | |
| **Tramitação CRUD** | | | CRUD | | |
| **Movimentação CRUD** | | | | CRUD | |
| **Busca Avançada** | | Read | Read | Read | |
| **Template Smarty** | | Render | Render | Render | Render |

## Componentes vs Regras de Negócio

| Componente | RB-01 (Sessão) | RB-02 (Lembrar senha) | RB-03 (Admin) | RB-04 (RBAC) | RB-05 (Owner) | RB-06 (Estado) | RB-07 (Busca) |
|------------|:--------------:|:---------------------:|:-------------:|:------------:|:-------------:|:--------------:|:-------------:|
| login.asp | ✓ | ✓ | ✓ | | | | |
| CheckSecurity() | | | ✓ | ✓ | ✓ | | |
| Session | ✓ | | | | | | |
| *_list.asp | | | | | | | ✓ |
| *_add.asp | | | | | | ✓ | |
| *_edit.asp | | | | | | ✓ | |
| *_search.asp | | | | | | | ✓ |

## Impacto de Mudanças

| Mudança Proposta | Afeta | Impacto | Risco |
|------------------|-------|---------|-------|
| Alterar método auth | login.asp, USUARIOS | Alto | Quebra autenticação |
| Mudar nível admin | CheckSecurity() | Alto | Perde controle |
| Novo campo em Cadastro | Cadastro_*.asp, Smarty | Médio | UI quebrada |
| Adicionar filtro na busca | *_search.asp | Baixo | Funcionalidade nova |
| Mudar banco de dados | dbcommon.asp | Crítico | Sistema inteiro |
| Alterar sessão | Session, todas páginas | Crítico | Sistema inteiro |

## Rastreabilidade Código → Documentação

| Arquivo | Artefato | Seção |
|---------|----------|-------|
| login.asp | domain.md | RB-01, RB-02, RB-03 |
| include/dbcommon.asp | permissions.md | Níveis de acesso |
| include/aspfunctions.asp | permissions.md | CheckSecurity |
| Cadastro_*.asp | data-dictionary.md | Entidade Cadastro |
| Tramitacao_*.asp | data-dictionary.md | Entidade Tramitação |
| Moviment_*.asp | data-dictionary.md | Entidade Movimentação |
| *_search.asp | domain.md | RB-07 |

---

## Confiança

| Símbolo | Significado |
|---------|-------------|
| 🟢 CONFIRMADO | Extraído diretamente do código |
| 🟡 INFERIDO | Baseado em padrões |
| 🔴 LACUNA | Informação não disponível |