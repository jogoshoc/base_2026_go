# Paradigm Decision — Projeto CGDoc

> Gerado pelo Reversa Paradigm Advisor em 2026-05-06
> Atualizado em 2026-05-06 (ajuste de stack)

## Paradigma do Legado

**Detectado:** OO clássico (ASP Clássico + VBScript + Active Record)

### Evidências

| Evidência | Artefato | Confiança |
|-----------|----------|-----------|
| Lógica de negócio em scripts ASP com acesso direto ao banco | `architecture.md` — "Frontend: ASP Clássico + Smarty" | 🟢 CONFIRMADO |
| Padrão Active Record — entidades com lógica de acesso a dados | `domain.md` — Regras de negócio em entidades | 🟡 INFERIDO |
| Controllers anêmicos com lógica nos modelos | `SAdm/design.md` — Fluxo CRUD | 🟡 INFERIDO |
| Ausência de injeção de dependência | `architecture.md` — Stack tecnológico | 🟢 CONFIRMADO |

---

## Paradigma Natural da Stack Alvo

**Inferido:** CSP / Go routines (event-driven leve com concorrência)

| Stack declarada | Paradigma natural | Alternativas |
|-----------------|-------------------|--------------|
| Go (Golang) + MariaDB | CSP / goroutines | Procedural estruturado |

**Justificativa:** Go é nativamente concurrent com goroutines e channels. O paradigma natural é comunicação sequencial de processos (CSP), mas para uma migração "cópia perfeita" podemos usar estrutura procedural estruturada mais próxima do ASP original.

---

## Gap Identificado

**De:** OO clássico (legado ASP)
**Para:** CSP / Go routines (Go + MariaDB)

**Severidade:** Moderada-alta

### Implicações Concretas

**Implicação 1: Sessão HTTP stateful**
O legado usa ASP Session. Go com HTTP padrão é stateless. Precisamos manter estado em memória (sync.Map) ou via cookie/token para "cópia perfeita".

**Implicação 2: Template Engine**
O legado usa Smarty. Em Go, precisamos de template similar (html/template ou Go templates) para manter UI idêntica.

**Implicação 3: Banco de dados - Active Record**
Legado usa ADO direto. Go precisa de driver (go-sql-driver/mysql) + repository pattern para manter acesso similar.

**Implicação 4: Estrutura de arquivos**
Legado tem ~100 arquivos ASP por módulo. Go pode usar estrutura de diretórios similar para manter organização familiar.

---

## Opções de Migração

### Opção 1: Adotar o paradigma natural da stack (Transformacional)
Usar goroutines, channels, e padrões Go idiomaticos.

- **Prós:** Código Go nativo, alta performance
- **Contras:** Maior refatoração, maior distância do legado

### Opção 2: Forçar paradigma similar ao legado (Conservador) ← ESCOLHIDA
Manter estrutura procedural, templates similar, sessão stateful.

- **Prós:** CópiaPerfeita, zero aprendizado para usuários
- **Contras:** Menos idiomático, mas adequado ao objetivo

### Opção 3: Híbrido (Equilibrado)
Combinar padrões Go com estrutura familiar.

- **Prós:** Progressivo
- **Contras:** Mistura paradigmas

---

## Decisão do Usuário

> **Escolha:** 2 (Forçar paradigma similar ao legado)
> **Justificativa:** "CópiaPerfeita para garantir zero aprendizado aos usuários"

### Apetite Derivado

`conservative` — manter paradigma próximo ao legado

---

## Contrato para Próximos Agentes

| Implicação | Agente afetado | Ação esperada |
|------------|----------------|---------------|
| Sessão stateful | Curator, Designer | Implementar gestão de sessão em memória/cookie |
| Template similar a Smarty | Designer | Usar html/template com sintaxe próxima |
| Repository pattern | Curator, Designer | Definir entidades e queries SQL |
| Estrutura de arquivos | Designer | Manter organização similar ao legado |
| **Prefixo único NrProtoc** | Curator, Designer, Data Master | Implementar sistema de prefixos (sadm-0000000, sercod-0000000) para permitir unificação futura |

---

## Regra de Arquitetura: Prefixo Único NrProtoc

> **Importante:** Esta regra deve ser implementada em toda a migração.

### Problema
- `NrProtoc` é o índice principal nos 3 bancos de dados
- Sem prefixo, unificação futura causará colisão de IDs

### Solução
- Cada banco terá prefixo único:
  - **SAdm:** `sadm-0000001`
  - **Sercod:** `sercod-0000001`
- Lógica de geração em Go deve respeitar o prefixo
- Queries SQL devem filtrar por prefixo para manter isolamento

### Artefatos afetados
- Schema MariaDB (CREATE TABLE com prefixo)
- Lógica de geração de novos protocolos (Go)
- Repositories Go (insert com prefixo)

---

## Schema Disponíveis

| Arquivo | Conteúdo |
|---------|----------|
| `cgdoc/SAdm/db/cgdoc_SAdm.sql` | Schema completo do módulo SAdm (~85k linhas) |
| `cgdoc/Sercod/db/cgdoc_sercod.sql` | Schema do módulo Sercod |
| `cgdoc/Sercod/SAdm/db/cgdoc_sercod_SAdm.sql` | Schema adicional |

---

## Referências

- Catálogo de paradigmas: `references/paradigm-catalog.md`
- Brief: `migration_brief.md`
- Arquitetura legado: `architecture.md`
- Domain: `domain.md`