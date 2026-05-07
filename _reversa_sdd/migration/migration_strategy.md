# Migration Strategy — Projeto CGDoc

> Gerado pelo Reversa Strategist em 2026-05-06

## Contexto

| Aspecto | Valor |
|---------|-------|
| **Legado** | ASP Clássico + Access + Smarty |
| **Stack alvo** | Go + MariaDB |
| **Apetite** | Conservative (CópiaPerfeita) |
| **Gap de paradigma** | Moderado (OO clássico → CSP/Go) |
| **Módulos** | SAdm, Sercod, Sercod_SAdm (tramitação) |
| **Tamanho** | ~882 arquivos ASP, 3 bancos MariaDB |

---

## Estratégias Avaliadas

### 1. Big Bang (Troca direta)

**Descrição:** Migrar todo o sistema de uma vez. Legado desativado, novo ativado.

| Critério | Avaliação |
|----------|-----------|
| **Adequação ao apetite** | ❌ Baixa — alto risco para CópiaPerfeita |
| **Adequação ao gap** | ❌ Risco alto — mudança grande sem validação |
| **Custo** | Baixo |
| **Tempo** | Curto |
| **Risco** | Alto |

**Prós:** Simples, rápido
**Contras:** Sem validação, rollback difícil, usuário sente mudança

---

### 2. Parallel Run (Execução paralela)

**Descrição:** Sistema novo roda em paralelo com legado. Valida paridade antes de trocar.

| Critério | Avaliação |
|----------|-----------|
| **Adequação ao apetite** | ✅ Alta — valida CópiaPerfeita |
| **Adequação ao gap** | ✅ Alta — valida mudança de paradigma |
| **Custo** | Alto (2x infraestrutura) |
| **Tempo** | Longo |
| **Risco** | Baixo |

**Prós:** Validação completa, rollback fácil, transição gradual
**Contras:** Custo dobrado, complexidade operacional

---

### 3. Strangler Fig (Estrangler)

**Descrição:** Migrar módulo a módulo, componente a componente. Novas funcionalidades vão para o novo, legado é "estrangulado".

| Critério | Avaliação |
|----------|-----------|
| **Adequação ao apetite** | ⚠️ Média — pode fragmentar experiência |
| **Adequação ao gap** | ✅ Boa — migração gradual |
| **Custo** | Médio |
| **Tempo** | Médio |
| **Risco** | Médio |

**Prós:** Progressivo, cada módulo validado
**Contras:** Pode gerar experiência fragmentada, complexo gerenciar 2 sistemas

---

### 4. Branch by Abstraction (Ramificação por abstração)

**Descrição:** Criar abstração sobre o legado, implementar nova feature ao lado, ir movendo gradualmente.

| Critério | Avaliação |
|----------|-----------|
| **Adequação ao apetite** | ⚠️ Média — requer abstração bem desenhada |
| **Adequação ao gap** | ✅ Boa |
| **Custo** | Médio |
| **Tempo** | Longo |
| **Risco** | Médio |

**Prós:** Transição gradual, sem big bang
**Contras:** Abstração pode ser complexa para ASP → Go

---

## Recomendação

### ✅ Estratégia Recomendada: Parallel Run

**Justificativa:**

1. **CópiaPerfeita:** A meta é ter ZERO aprendizado do usuário. Parallel Run permite validar que a interface e funcionalidade são idênticas antes de trocar.

2. **Gap de paradigma:** Mudar de ASP → Go é mudança significativa. Parallel Run permite testar cada tela, cada fluxo, cada regra de negócio.

3. **Stakeholders híbridos:** Time interno + externos. Validação em paralelo permite participação do time sem risco.

4. **Três bancos:** SAdm, Sercod, Sercod_SAdm — migração em paralelo permite validar integridade entre eles.

### Implementação Proposta

1. **Fase 1:** Migrar SAdm para Go + MariaDB
2. **Fase 2:** Rodar SAdm (legado) e SAdm (Go) em paralelo
3. **Fase 3:** Validar paridade → se OK, migrar Sercod
4. **Fase 4:** Sercod em paralelo
5. **Fase 5:** Validar tramitação Sercod_SAdm
6. **Fase 6:** Cutover final

---

## Alternativas

Se recursos forem limitados: **Strangler Fig** com prioridade SAdm → Sercod → Sercod_SAdm.

---

## Próximos Passos

1. Aprovar estratégia (Parallel Run)
2. Designer detalha arquitetura
3. Implementar SAdm em Go
4. Validar em paralelo
5. Iterar para próximos módulos