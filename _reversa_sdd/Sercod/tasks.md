# Sercod — Secretaria de Códigos, Tarefas de Implementação

> Tarefas para reimplementar o módulo Sercod.

## Pré-requisitos
- [ ] Same as SAdm (ver `SAdm/tasks.md`)
- [ ] Schema do banco Access migrado

## Tarefas

**Observação:** Este módulo é um clone do SAdm. As tarefas são idênticas, com foco em codificação de processos.

- [ ] T-01, Implementar autenticação
  - Origem no legado: `cgdoc/Sercod/login.asp`
  - Critério de pronto: Login funcional
  - Confiança: 🟢

- [ ] T-02, Implementar logout
  - Origem no legado: `cgdoc/Sercod/login.asp:3-8`
  - Critério de pronto: Logout funcional
  - Confiança: 🟢

- [ ] T-03, Implementar middleware de autenticação
  - Origem no legado: `cgdoc/Sercod/*_list.asp:5-9`
  - Critério de pronto: Rotas protegidas
  - Confiança: 🟢

- [ ] T-04, Implementar autorização RBAC
  - Origem no legado: `cgdoc/Sercod/include/aspfunctions.asp`
  - Critério de pronto: CheckSecurity funcional
  - Confiança: 🟡

- [ ] T-05, Implementar CRUD de Cadastro
  - Origem no legado: `cgdoc/Sercod/Cadastro_*.asp`
  - Critério de pronto: CRUD completo
  - Confiança: 🟡

- [ ] T-06, Implementar funcionalidades de codificação
  - Origem no legado: ?
  - Critério de pronto: Funcionalidade de numeração
  - Confiança: 🔴 (não mapeado)

- [ ] T-07, Implementar busca
  - Origem no legado: `cgdoc/Sercod/*_search.asp`
  - Critério de pronto: Busca funcional
  - Confiança: 🟢

- [ ] T-08, Implementar gestão de usuários
  - Origem no legado: `cgdoc/Sercod/Usu_rios_*.asp`
  - Critério de pronto: Gestão de usuários
  - Confiança: 🟡

## Tarefas de Teste

Same as SAdm. Ver `SAdm/tasks.md`.

## Tarefas de Migração de Dados

Same as SAdm. Ver `SAdm/tasks.md`.

## Ordem Sugerida

1. **Primeiro:** T-01 + T-02 + T-03 — autenticação base
2. **Segundo:** T-04 — autorização
3. **Terceiro:** T-05 — CRUD
4. **Quarto:** T-06 — codificação (requer análise adicional)
5. **Quinto:** T-07 + T-08 — busca e usuários

## Lacunas Pendentes (🔴)

- Funcionalidades específicas de codificação não identificadas
- Diferenciação exata entre SAdm e Sercod não mapeada
- Necessário acesso ao banco para entender diferença de entidades