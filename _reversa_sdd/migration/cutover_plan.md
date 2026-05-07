# Cutover Plan — Projeto CGDoc

> Gerado pelo Reversa Strategist em 2026-05-06
> Baseado na estratégia: Parallel Run

---

## Fase 1: Preparação

### Pré-requisitos
- [ ] Ambiente Go configurado
- [ ] Bancos MariaDB criados (SAdm, Sercod, Sercod_SAdm)
- [ ] Schema importado de arquivos .sql
- [ ] Código Go compilando
- [ ] Testes unitários passando

### Duração estimada: 2 semanas

---

## Fase 2: Migração SAdm

### Passos
| # | Passo | Owner | Duração | Pré-requisito |
|---|-------|-------|---------|---------------|
| 1 | Implementar Auth em Go | Dev | 3 dias | Código compilando |
| 2 | Implementar CRUD Cadastro | Dev | 5 dias | Auth ok |
| 3 | Implementar CRUD Moviment | Dev | 3 dias | Cadastro ok |
| 4 | Implementar Busca Avançada | Dev | 3 dias | CRUD ok |
| 5 | Implementar Templates Go | Dev | 3 dias | CRUD ok |
| 6 | Testes unitários | Dev | 2 dias | Feature completa |
| 7 | Deploy ambiente paralelo | Ops | 1 dia | Testes ok |

### Duração estimada: 3 semanas

---

## Fase 3: Parallel Run SAdm

### Passos
| # | Passo | Owner | Duração | Pré-requisito |
|---|-------|-------|---------|---------------|
| 1 | Levantar SAdm (Go) em paralelo | Ops | 4h | Deploy ok |
| 2 | Validar login/auth | QA | 1 dia | Ambos levantados |
| 3 | Validar CRUD Cadastro | QA | 2 dias | Login ok |
| 4 | Validar Moviment | QA | 1 dia | CRUD ok |
| 5 | Validar busca | QA | 1 dia | Dados ok |
| 6 | Validar performance | QA | 1 dia | Funcional ok |
| 7 | Comparar UI pixel-perfect | QA | 1 dia | Funcional ok |

### Duração estimada: 1 semana

### Critérios de Go/No-Go
- ✅ Todos os fluxos funcionando
- ✅ UI idêntica ao legado
- ✅ Performance <= 200ms por request
- ✅ Sem perda de dados

---

## Fase 4: Migração Sercod

### Passos
| # | Passo | Owner | Duração | Pré-requisito |
|---|-------|-------|---------|---------------|
| 1 | Implementar módulos em Go | Dev | 2 semanas | SAdm validado |
| 2 | Testes unitários | Dev | 1 semana | Feature completa |
| 3 | Deploy paralelo | Ops | 1 dia | Testes ok |
| 4 | Parallel Run | QA | 1 semana | Sercod validado |

### Duração estimada: 1 mês

---

## Fase 5: Migração Sercod_SAdm (Tramitação)

### Passos
| # | Passo | Owner | Duração | Pré-requisito |
|---|-------|-------|---------|---------------|
| 1 | Implementar tramitação | Dev | 1 semana | Ambos módulos ok |
| 2 | Teste integração | QA | 1 semana | Tramitação ok |
| 3 | Parallel Run 3 bases | QA | 1 semana | Integração ok |

### Duração estimada: 3 semanas

---

## Fase 6: Cutover Final

### Janela Sugerida
- **Data:** Final do projeto
- **Horário:** 22:00 - 06:00 (noite)
- **Downtime máximo:** 4 horas

### Passos
| # | Passo | Owner | Duração | Pré-requisito |
|---|-------|-------|---------|---------------|
| 1 | Backup final bancos | DBA | 1h | - |
| 2 | Parar legados (ASP) | Ops | 30min | Backup ok |
| 3 | Switch DNS para Go | Ops | 15min | Legado parado |
| 4 | Verificação final | QA | 2h | DNS switchado |
| 5 | Comunicação stakeholders | PM | 30min | Verificação ok |

### Duração estimada: 4 horas

---

## Rollback Plan

| Cenário | Ação | Tempo |
|---------|------|-------|
| UI não idêntica | Manter paralelo, ajustar, revalidar | 1-2 dias |
| Funcionalidade quebrada | Reverter para legado | 30 min |
| Performance ruim | Otimizar, re-benchmark | 1 semana |
| Perda de dados | Restaurar backup | 1 hora |

---

## Cronograma Total

| Fase | Duração |
|------|---------|
| Preparação | 2 semanas |
| Migração SAdm | 3 semanas |
| Parallel Run SAdm | 1 semana |
| Migração Sercod | 1 mês |
| Migração Sercod_SAdm | 3 semanas |
| **Total** | **~4 meses** |

---

## Stakeholders

| Papel | Responsabilidade |
|-------|-----------------|
| Dev | Implementação |
| QA | Validação |
| DBA | Schema, backup |
| Ops | Deploy, infraestrutura |
| PM | Comunicação |