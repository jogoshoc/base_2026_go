# SAdm — Secretaria Administrativa, Tarefas de Implementação

> Tarefas para reimplementar o módulo SAdm a partir do legado.

## Pré-requisitos
- [ ] Dependências disponíveis: ASP.NET Core ou similar
- [ ] Schema do banco Access migrado para SQL Server/PostgreSQL
- [ ] Template engine替代方案 (Razor ou similar)
- [ ] Biblioteca de sessão e autenticação configurada

## Tarefas

- [ ] T-01, Implementar autenticação de usuários
  - Origem no legado: `cgdoc/SAdm/login.asp:30-98`
  - Critério de pronto: Login válida credenciais e cria sessão; invalida retorna erro
  - Confiança: 🟢

- [ ] T-02, Implementar logout
  - Origem no legado: `cgdoc/SAdm/login.asp:3-8`
  - Critério de pronto: Destrói sessão, limpa cookies, redireciona para login
  - Confiança: 🟢

- [ ] T-03, Implementar middleware de autenticação
  - Origem no legado: `cgdoc/SAdm/Cadastro_list.asp:5-9`
  - Critério de pronto: Todas rotas protegidas verificam sessão ativa
  - Confiança: 🟢

- [ ] T-04, Implementar autorização RBAC (CheckSecurity)
  - Origem no legado: `cgdoc/SAdm/include/aspfunctions.asp:1534-1561`
  - Critério de pronto: Verifica nível de acesso e owner; admin tem bypass
  - Confiança: 🟡

- [ ] T-05, Implementar CRUD de Cadastro
  - Origem no legado: `cgdoc/SAdm/Cadastro_*.asp`
  - Critério de pronto: List, Add, Edit, Delete funcionam corretamente
  - Confiança: 🟡

- [ ] T-06, Implementar CRUD de Tramitação
  - Origem no legado: `cgdoc/SAdm/Tramitacao_*.asp`
  - Critério de pronto: Registra tramitação com destino e data
  - Confiança: 🟡

- [ ] T-07, Implementar CRUD de Movimentação
  - Origem no legado: `cgdoc/SAdm/Moviment_*.asp`
  - Critério de pronto: Registra movimentação com tipo e descrição
  - Confiança: 🟡

- [ ] T-08, Implementar busca simples
  - Origem no legado: `cgdoc/SAdm/Cadastro_list.asp`
  - Critério de pronto: Filtra por qualquer campo da entidade
  - Confiança: 🟢

- [ ] T-09, Implementar busca avançada (múltiplos critérios)
  - Origem no legado: `cgdoc/SAdm/Cadastro_list.asp:63-100`
  - Critério de pronto: Suporta AND/OR entre critérios, negação (NOT)
  - Confiança: 🟡

- [ ] T-10, Implementar gestão de usuários
  - Origem no legado: `cgdoc/SAdm/Usu_rios_*.asp`
  - Critério de pronto: CRUD de usuários com definição de privilégios
  - Confiança: 🟡

- [ ] T-11, Implementar funcionalidade "lembrar senha"
  - Origem no legado: `cgdoc/SAdm/login.asp:32-42`
  - Critério de pronto: Persiste credenciais em cookie por 1 ano
  - Confiança: 🟢

- [ ] T-12, Implementar paginação
  - Origem no legado: `cgdoc/SAdm/Cadastro_list.asp`
  - Critério de pronto: Navegação entre páginas de resultados
  - Confiança: 🟡

- [ ] T-13, Implementar impressão de relatórios
  - Origem no legado: `cgdoc/SAdm/*_print.asp`
  - Critério de pronto: Gera output para impressão
  - Confiança: 🟡

## Tarefas de Teste

- [ ] TT-01, Teste do happy path de login (credenciais válidas)
- [ ] TT-02, Teste de login com credenciais inválidas
- [ ] TT-03, Teste de acesso sem autenticação (redireciona)
- [ ] TT-04, Teste de acesso sem permissão (mensagem de erro)
- [ ] TT-05, Teste de CRUD completo de Cadastro
- [ ] TT-06, Teste de busca com múltiplos critérios (AND/OR)
- [ ] TT-07, Teste de paginação
- [ ] TT-08, Teste de logout (sessão destruída)

## Tarefas de Migração de Dados

- [ ] TM-01, Migrar tabela Usuários do Access para SQL
- [ ] TM-02, Migrar tabela Cadastro do Access para SQL
- [ ] TM-03, Migrar tabela Tramitação do Access para SQL
- [ ] TM-04, Migrar tabela Movimentação do Access para SQL

## Ordem Sugerida

1. **Primeiro:** T-01 (Login) + T-02 (Logout) + T-03 (Middleware auth) — base de tudo
2. **Segundo:** T-04 (Autorização) — depende de T-03
3. **Terceiro:** T-05 (CRUD Cadastro) — funcionalidade core
4. **Quarto:** T-06, T-07 (Tramitação/Movimentação) — dependem de T-05
5. **Quinto:** T-08, T-09 (Busca) — dependem de T-05
6. **Sexto:** T-10 (Gestão usuários) —admin functionality
7. **Sétimo:** T-11, T-12, T-13 — features complementares

**Bloqueios:**
- T-04 depende de T-03
- T-06, T-07 dependem de T-05
- T-08, T-09 dependem de T-05
- T-10 pode ser feito em paralelo após T-04

## Lacunas Pendentes (🔴)

- Schema exato das tabelas no Access — requer acesso ao arquivo .mdb
- Tempo de expiração de sessão — não encontrado no código
- Lógica completa de permissão por owner — parcialmente mapeada
- Campos opcionais de cada entidade — não completos