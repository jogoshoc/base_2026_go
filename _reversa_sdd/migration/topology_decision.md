# Topology Decision — Projeto CGDoc

> Gerado pelo Reversa Designer em 2026-05-06 (Fase 1)

## Topologia Detectada do Legado

**Padrão:** Monolito sem fronteiras claras (package-by-feature implícito)

### Evidências

| Evidência | Artefato | Confiança |
|-----------|----------|-----------|
| 2 módulos sem estrutura MVC clara | `architecture.md` — "SAdm" e "Sercod" | 🟢 |
| Arquivos repetidos por entidade (~100 por módulo) | `inventory.md` — arquivos ASP | 🟢 |
| Mistura presentation/business/data no mesmo arquivo | `code-analysis.md` | 🟡 |
| 3 bancos de dados separados | `database/data-dictionary.md` | 🟢 |

### Árvore Legada

```
cgdoc/
├── SAdm/                    # Módulo 1
│   ├── login.asp           # Auth
│   ├── menu.asp
│   ├── Cadastro_*.asp      # CRUD ~10 arquivos
│   ├── Tramitacao_*.asp    # CRUD ~10 arquivos
│   ├── Moviment_*.asp      # CRUD ~10 arquivos
│   └── ...
├── Sercod/                  # Módulo 2 (clone)
│   └── ...
└── (mesma estrutura)
```

### Diagnóstico Estrutural

**Parcialmenteproblemático**

- ✅ Separação por módulo (SAdm/Sercod) faz sentido de negócio
- ❌ Arquivos ~100 por módulo sem padrão MVC
- ❌ Mistura de Presentation + Business + Data no mesmo arquivo
- ❌ Repetição de código (mesmo CRUD para cada entidade)
- ⚠️ 3 bancos para o mesmo sistema (necessário para tramitação)

---

## Topologia Moderna Proposta

**Padrão:** Clean Architecture + Repository Pattern

### Justificativa

1. **CópiaPerfeita:** Mantém UI idêntica (Go templates similar a Smarty)
2. **Testabilidade:** Repository pattern permite mocks (legado não tinha testes)
3. **Separação de responsabilidades:** Controllers → Services → Repositories
4. **Manutenibilidade:** Estrutura clara para novos desenvolvedores
5. **Go idiomático:** Segue convenções Go (pacotes, interfaces)

### Árvore Proposta

```
cmd/
├── sadm/          # Entry point SAdm
│   └── main.go
├── sercod/        # Entry point Sercod
│   └── main.go
└── shared/        # Entry point compartilhado (tramitação)

internal/
├── domain/        # Entidades de negócio
│   ├── entities/
│   ├── valueobjects/
│   └── events/
├── application/   # Casos de uso / Services
│   ├── auth/
│   ├── cadastro/
│   ├── moviment/
│   └── tramitacao/
├── infrastructure/ # Implementações
│   ├── database/   # Repositories MariaDB
│   ├── session/    # Gerência de sessão
│   └── templates/  # Go templates
├── interfaces/    # HTTP handlers
│   ├── http/
│   └── middleware/
└── config/        # Configurações

migrations/        # Schema MariaDB
```

---

## Opções de Topologia

### Opção 1: Preservar topologia legada (conservador)
Manter 2 aplicações separadas (SAdm + Sercod) com estrutura similar ao legado.

- **Prós:** Zero aprendizado, migração rápida
- **Contras:** Código não testável, estrutura confusa

### Opção 2: Adotar topologia moderna (transformacional) ← RECOMENDADA
Clean Architecture com Repository pattern.

- **Prós:** Testável, manutenível, idiomatic Go
- **Contras:** Curva de aprendizado

### Opção 3: Híbrido
Manter módulos SAdm/Sercod separados, mas aplicar Clean Architecture internamente.

- **Prós:** Balanceado
- **Contras:** Mais complexo

---

## Decisão do Usuário

> **Escolha:** 2
> **Justificativa:** Manter CópiaPerfeita com estrutura moderna testável

---

## Mapeamento Legado → Novo

| Legado | Novo | Tipo |
|--------|------|------|
| `SAdm/` | `cmd/sadm/` + `internal/` | Transformado |
| `Sercod/` | `cmd/sercod/` + `internal/` | Transformado |
| `Cadastro_*.asp` | `internal/application/cadastro/` | Fundido |
| `include/dbcommon.asp` | `internal/infrastructure/database/` | Modernizado |
| `libs/smarty.asp` | `internal/infrastructure/templates/` | Modernizado |

---

## Implicações para Designer (Fase 2)

1. Criar 2 entry points (sadm, sercod) + 1 compartido (tramitação)
2. Implementar Clean Architecture em `internal/`
3. Repository pattern para acesso MariaDB
4. Templates Go com estrutura similar Smarty
5. Sessão stateful com sync.Map ou cookie
6. Prefixo NrProtoc (sadm- / sercod-)