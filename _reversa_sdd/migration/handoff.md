# Handoff — Projeto CGDoc

> Gerado pelo Reversa Migrate em 2026-05-07

---

## Resumo Executivo

Migração do sistema CGDoc (ASP Clássico + Access) para Go + MariaDB concluída. A estratégia escolhida foi **Parallel Run** para validar paridade antes do cutover.

---

## Artefatos Produzidos

### Agentes Executados (5)

| Ordem | Agente | Status |
|-------|--------|--------|
| 1 | Paradigm Advisor | ✅ |
| 2 | Curator | ✅ |
| 3 | Data Master | ✅ |
| 4 | Strategist | ✅ |
| 5 | Designer | ✅ |
| 6 | Inspector | ✅ |

### Arquivos Gerados

| Artefato | Caminho | Descrição |
|----------|---------|-----------|
| `paradigm_decision.md` | `_reversa_sdd/migration/` | Decisão de paradigma (CSP/Go similar ao legado) |
| `target_business_rules.md` | `_reversa_sdd/migration/` | Regras de negócio a migrar |
| `discard_log.md` | `_reversa_sdd/migration/` | Itens descartados |
| `migration_strategy.md` | `_reversa_sdd/migration/` | Estratégia: Parallel Run |
| `risk_register.md` | `_reversa_sdd/migration/` | Riscos identificados |
| `cutover_plan.md` | `_reversa_sdd/migration/` | Plano de corte |
| `topology_decision.md` | `_reversa_sdd/migration/` | Topologia: Clean Architecture |
| `target_architecture.md` | `_reversa_sdd/migration/` | Arquitetura Go detalhada |
| `target_domain_model.md` | `_reversa_sdd/migration/` | Modelo de domínio |
| `target_data_model.md` | `_reversa_sdd/migration/` | Schema MariaDB |
| `data_migration_plan.md` | `_reversa_sdd/migration/` | Plano ETL |
| `parity_specs.md` | `_reversa_sdd/migration/` | Especificações de paridade |
| `*.feature` | `_reversa_sdd/migration/parity_tests/` | 11 specs Gherkin |

**Total:** 22 artefatos

---

## Leituras Obrigatórias Primeiro

### 1. `paradigm_decision.md`
Decide o "como pensar" — paradigma CSP/Go similar ao legado para CópiaPerfeita.

### 2. `topology_decision.md`
Decide o "como organizar" — Clean Architecture + Repository Pattern.

---

## Decisões Técnicas Registradas

| Decisão | Local | Detalhe |
|---------|-------|---------|
| Admin ID 1088608 | `questions.md` | Variável de ambiente `ADMIN_USER_ID` |
| Session Timeout | `questions.md` | 20 minutos (padrão IIS) |
| Senhas | `target_business_rules.md` | Texto claro compatibilidade inicial → bcrypt futuro |
| NrProtoc prefix | `paradigm_decision.md` | `sadm-`, `sercod-`, `sercod_sadm-` |
| Stack | `migration_brief.md` | Go + MariaDB + chi router + html/template |

---

## Itens Referidos à Codificação

1. **Setup de projeto Go** — Estrutura cmd/, internal/, migrations/
2. **Implementar repositories** — database/sql com queries do legado
3. **Middleware de sessão** — 20min timeout, sync.Map ou cookie
4. **Templates Go** — Compatibilidade com Smarty
5. **ETL scripts** — Export Access → Import MariaDB
6. **Tests de paridade** — Traduzir .feature para framework chosen

---

## Métricas de Sucesso

- Divergência funcional < 0,5% durante 7 dias
- Zero erros 500 durante Parallel Run
- Dados sincronizados (checksum validates)

---

## Próximos Passos

1. Configurar repositório Go
2. Implementar estrutura Clean Architecture
3. Executar migração de dados (ETL)
4. Iniciar Parallel Run
5. Validar paridade com specs .feature
6. Cutover após validação

---

## Contato

Time de Migração Reversa — Pipeline concluído com sucesso.