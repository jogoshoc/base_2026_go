# Target Domain Model — Projeto CGDoc

> Gerado pelo Reversa Designer em 2026-05-07 (Fase 2)

## Aggregates

### Auth Aggregate

```
Root: Usuario
├── Invariantes:
│   - Username único
│   - Senha hash ou texto (compatibilidade inicial)
│   - Privilegio em {adm, user, vis}
├── Comandos:
│   - Login(username, password) → Session
│   - Logout(sessionId)
│   - ValidateSession(sessionId) → bool
└── Eventos: (não aplicável - não é event-driven)
```

### Cadastro Aggregate

```
Root: Cadastro
├── Invariantes:
│   - NrProtoc único por sistema (sadm-/sercod-)
│   - NrProtoc não pode ser vazio
│   - DtEntr (data entrada) obrigatória
├── Comandos:
│   - CreateCadastro(data) → id
│   - UpdateCadastro(id, data)
│   - DeleteCadastro(id)
│   - SearchCadastro(criteria) → []Cadastro
└── Eventos: (não aplicável)
```

### Tramitacao Aggregate

```
Root: Tramitacao
├── Invariantes:
│   - NrProtoc referencia Cadastro existente
│   - Destino obrigatório
│   - DtMovim não pode ser futuro
├── Comandos:
│   - CreateTramitacao(cadastroId, destino) → id
│   - ListTramitacoes(cadastroId) → []Tramitacao
└── Eventos: (não aplicável)
```

### Moviment Aggregate

```
Root: Moviment
├── Invariantes:
│   - NrProtoc referencia Cadastro existente
│   - DtMovim não pode ser futuro
├── Comandos:
│   - CreateMoviment(cadastroId, data) → id
│   - ListMovimentacoes(cadastroId) → []Moviment
└── Eventos: (não aplicável)
```

---

## Entidades

| Entidade | Agregate Pai | PK | Campos Principais |
|----------|--------------|-----|-------------------|
| Usuario | Auth | Código | NrUsuário, Senha, Privilegio, Nome, Unidade, Seção |
| Cadastro | Cadastro | Controle | NrProtoc, DtEntr, Descr, Nome, Assunto, TipoDoc, Nat, Destino, Obs, Usuario, PastaArquiv, CPF, MASP |
| Tramitacao | Tramitacao | CodMov | NrProtoc, DtMovim, OrigNome, DestNome, Obs, Prazo, Emissor, Assunto, TipoDoc, Descr, Nome, DtEntr |
| Moviment | Moviment | CodMov | NrProtoc, DtMovim, OrigNome, DestNome, Obs, Prazo, UsuaMov, Cumprido |

---

## Value Objects

| Value Object | Descrição | Validação |
|--------------|-----------|-----------|
| NrProtoc | Número de protocolo com prefixo | Formato: `{sadm\|sercod\|sercod_sadm}-XXXXXXXX` |
| DataHora | Timestamp data entrada | Formato ISO 8601 |
| Privilegio | Nível de acesso | Enum {adm, user, vis} |
| NivelAcesso | Nível de acesso para RBAC | Enum {admin, user, guest} |

---

## Regras de Domínio

| BR | Regra | Local no Domínio |
|----|-------|------------------|
| BR-MIGRAR-001 | Usuário autenticado | `middleware/auth.go` |
| BR-MIGRAR-002 | Senha lembrada 1 ano | `AuthService.Login()` |
| BR-MIGRAR-003 | Admin irrestrito | `CheckSecurity()` |
| BR-MIGRAR-004 | Sessão expira 20min | `session/middleware.go` |
| BR-MIGRAR-005 | RBAC (admin/user/guest) | `domain/valueobjects/nivelacesso.go` |
| BR-MIGRAR-006 | Verificação de permissão | `CheckSecurity()` |
| BR-MIGRAR-008 | NrProtoc com prefixo | `valueobjects/nrprotoc.go` |
| BR-MIGRAR-009 | NrProtoc único | `CadastroRepository` (UK constraint) |
| BR-MIGRAR-010 | Destino obrigatório | `Tramitacao.Validate()` |
| BR-MIGRAR-013 | CRUD completo | Services em `application/` |

---

## Rastreabilidade para Legado

| Legado | Novo | Tipo |
|--------|------|------|
| `SAdm/login.asp` | `application/auth/` | Transformado |
| `SAdm/Cadastro_*.asp` | `application/cadastro/` | Fundido |
| `SAdm/Tramitacao_*.asp` | `application/tramitacao/` | Fundido |
| `SAdm/Moviment_*.asp` | `application/moviment/` | Fundido |
| `include/dbcommon.asp` | `infrastructure/database/` | Modernizado |
| `Usuários` (tabela) | `domain/entities/usuario.go` | 1-para-1 |
| `Cadastro` (tabela) | `domain/entities/cadastro.go` | 1-para-1 |
| `Tramitacao` (tabela) | `domain/entities/tramitacao.go` | 1-para-1 |
| `Moviment` (tabela) | `domain/entities/moviment.go` | 1-para-1 |

---

## Notas

- Sistema não é event-driven; não há necessidade de eventos de domínio explícitos
- Paradigma Go (CSP) não impõe event sourcing; estado em memória/DB é suficiente
- Agregates são transaction boundaries claros (cadastro → tramitação/movimentação)