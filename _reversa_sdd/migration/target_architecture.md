# Target Architecture — Projeto CGDoc

> Gerado pelo Reversa Designer em 2026-05-07 (Fase 2)

## Visão Geral

Sistema de gestão de documentos e processos administrativos migrado para Go + MariaDB. Mantém interface idêntica ao legado (CópiaPerfeita) com arquitetura moderna testável.

---

## Diagrama de Arquitetura

```mermaid
graph TB
    subgraph "Camada de Apresentação"
        UI[Go Templates / HTML]
        MW[Middleware]
        Auth[Auth Middleware]
    end

    subgraph "Camada de Interface"
        H[HTTP Handlers]
        R[Router (chi)]
    end

    subgraph "Camada de Aplicação"
        S[Services]
        A[Auth Service]
        C[Cadastro Service]
        T[Tramitacao Service]
        M[Moviment Service]
    end

    subgraph "Camada de Domínio"
        E[Entities]
        V[Value Objects]
        RULES[Business Rules]
    end

    subgraph "Infraestrutura"
        DB[(MariaDB)]
        REP[Repositories]
        SESS[Sessão Go]
    end

    UI --> MW
    MW --> H
    H --> R
    R --> S
    S --> E
    S --> REP
    REP --> DB
    E --> RULES
```

---

## Componentes

| Componente | Tipo | Descrição |
|------------|------|-----------|
| `cmd/sadm` | Entry Point | API SAdm (porta 8081) |
| `cmd/sercod` | Entry Point | API Sercod (porta 8082) |
| `internal/interfaces/http` | API | Handlers HTTP com chi router |
| `internal/interfaces/middleware` | Middleware | Auth, Session, Logging |
| `internal/application` | Service | Casos de uso por domínio |
| `internal/domain/entities` | Domain | Entidades de negócio |
| `internal/domain/valueobjects` | Domain | Value objects |
| `internal/infrastructure/database` | DB | Repositories MariaDB |
| `internal/infrastructure/session` | Session | Gerência de sessão (20min) |
| `internal/infrastructure/templates` | Template | Go templates (compatível Smarty) |

---

## Bounded Contexts

| Context | Responsabilidade | Regras associadas |
|---------|------------------|-------------------|
| **Auth** | Autenticação, sessão, RBAC | BR-MIGRAR-001 a 007 |
| **Cadastro** | CRUD de processos/documentos | BR-MIGRAR-008, 009, 013, 014, 018 |
| **Tramitacao** | Encaminhamento entre departamentos | BR-MIGRAR-010, 019 |
| **Moviment** | Registro de ações sobre processos | BR-MIGRAR-020 |

---

## Decisões Arquiteturais

| Decisão | Justificativa | Rastreabilidade |
|---------|---------------|-----------------|
| Clean Architecture + Repository Pattern | Separação clara, testável, Go idiomático | `topology_decision.md` |
| 2 entry points (sadm, sercod) | Mantém módulos separados do legado | `topology_decision.md` |
| MariaDB unificado | 3 bancos Access → 1 MariaDB | `data_migration_plan.md` |
| Sessão com 20min timeout | Paridade com padrão IIS | `questions.md` |
| Admin ID via config | 1088608 em variável ambiente | `questions.md` |
| BCrypt (futuro) | Security upgrade pós-parallel run | `target_business_rules.md` |

---

## Honra ao Paradigma Escolhido

| Implicação do Paradigm Decision | Implementação |
|--------------------------------|---------------|
| **Go idiomatic** | Pacotes por camada, interfaces, Error handling nativo |
| **CSP/Go routines** | Handlers concurrently-safe, sync.Map para sessão |
| **Sem estado compartilhado** | Sessão em memória ou cookie assinado |
| **Interfaces explícitas** | Repository interfaces em `domain/` |

---

## Honra à Topologia Escolhida

**Opção:** Modernizar (Clean Architecture)

**Árvore final:**

```
cmd/
├── sadm/main.go
├── sercod/main.go
└── shared/main.go

internal/
├── config/
│   └── config.go
├── domain/
│   ├── entities/
│   │   ├── cadastro.go
│   │   ├── tramitacao.go
│   │   ├── moviment.go
│   │   └── usuario.go
│   └── valueobjects/
│       ├── nrprotoc.go
│       └── timestamp.go
├── application/
│   ├── auth/
│   ├── cadastro/
│   ├── tramitacao/
│   └── moviment/
├── interfaces/
│   ├── http/
│   │   ├── sadm/
│   │   └── sercod/
│   └── middleware/
├── infrastructure/
│   ├── database/
│   │   └── repositories/
│   ├── session/
│   └── templates/
migrations/
└── 001_initial.sql
```

---

## Stack Tecnológico

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Go 1.21+ |
| Router | chi |
| Database | MariaDB |
| ORM | sqlx (raw SQL para paridade) |
| Templates | html/template |
| Session | sync.Map ou cookie |
| Auth | bcrypt (compatibilidade texto claro inicial) |