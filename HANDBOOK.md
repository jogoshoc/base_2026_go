# HANDBOOK — CGDoc Go

> **Propósito**: Documento de handoff para a próxima equipe.
> **Data**: 19/06/2026
> **Estado**: Funcional. 8/8 tarefas concluídas. 10 commits no GitHub.

---

## 1. O QUE FOI FEITO

Migração completa do sistema CGDoc de ASP Clássico + Microsoft Access para Go + MariaDB.

### 1.1 Legado (não mexer)
```
/home/deploy/Apps/base_2026_go/cgdoc/
├── SAdm/        # Secretaria Administrativa (882 arquivos ASP)
├── Sercod/      # Secretaria de Códigos
├── libs/        # Smarty, FPDF
└── db/          # SisprotWeb.mdb + schemas .sql
```

### 1.2 Novo Sistema (Go)
```
/home/deploy/Apps/base_2026_go/
├── cmd/sadm/main.go        # SAdm — porta 8080 (host 5001)
├── cmd/sercod/main.go      # Sercod — porta 8082 (host 5002)
├── internal/
│   ├── application/
│   │   ├── auth/            # Auth service + bcrypt
│   │   ├── cadastro/        # Cadastro CRUD
│   │   ├── moviment/        # Movimentação
│   │   └── tramitacao/      # Tramitação
│   ├── config/
│   ├── domain/
│   │   ├── entities/
│   │   └── valueobjects/    # NrProtoc com prefixos
│   ├── infrastructure/
│   │   ├── database/        # Repositórios MariaDB
│   │   └── session/         # Session manager
│   └── interfaces/
│       ├── http/{sadm,sercod}/  # Handlers
│       └── middleware/       # Auth middleware
├── migrations/
│   ├── 001_initial_schema.sql
│   ├── 002_hash_passwords.sql  # bcrypt migration
│   └── etl-legado-to-go.sql
├── docker-entrypoint-initdb.d/
├── docker-compose.yml
├── Dockerfile
├── go.mod / go.sum
├── .env
└── HANDBOOK.md / AGENTS.md / CONVENTIONS.md / CLAUDE.md
```

### 1.3 Dados Migrados

| Banco | Cadastro | Moviment | Tramitacao | Usuarios | Orgaos | Tipodoc |
|-------|----------|----------|------------|----------|--------|---------|
| movedb_SAdm | ~80k | ~28k | ~28k | 22 | 628 | 74 |
| movedb_Sercod | ~102k | ~323 | ~323 | 25 | 513 | 189 |
| movedb_Sercod_SAdm | ~51k | ~25k | ~25k | 8 | 451 | — |

**Total: ~279k registros**

### 1.4 Correções e Melhorias Aplicadas

| # | Tarefa | Situação |
|---|--------|----------|
| 1 | Bug `cumplido` → `cumprido` (3 ocorrências) | ✅ Commit 647c110 |
| 2 | NULL values no banco (UPDATE NULL → "") | ✅ Todas as tabelas |
| 3 | Campo `senha` ausente nas queries SELECT | ✅ Commit daa7a73 |
| 4 | Login testado com usuário legado s1656743 | ✅ Funcionando |
| 5 | CRUD completo testado | ✅ Listar, criar, editar, deletar |
| 6 | bcrypt implementado | ✅ golang.org/x/crypto |
| 7 | Testes unitários (17 testes) | ✅ Todos passam |
| 8 | Rota /cadastro/view (estava 404) | ✅ Commit 1219f61 |
| 9 | Search dinâmico no repositório | ✅ 7 filtros |
| 10 | Push para GitHub (10 commits) | ✅ jogoshoc/base_2026_go |

---

## 2. ARQUITETURA

```
                        Internet
                           │
                    ┌──────┴──────┐
                    │   Servidor  │
                    │ contabo     │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         porta 5001   porta 5002   porta 3307
              │            │            │
        ┌─────┴─────┐ ┌───┴────┐  ┌────┴──────┐
        │ sadm-app  │ │sercod- │  │ MariaDB   │
        │ Go + chi  │ │  app   │  │ 10.11     │
        │ 8080:8080 │ │8082:8080│  │ cgdoc_db  │
        └─────┬─────┘ └───┬────┘  └────┬──────┘
              │            │            │
              └────────────┼────────────┘
                           │
                    ┌──────┴──────┐
                    │  3 bancos   │
                    │ movedb_*    │
                    └─────────────┘
```

### 2.1 Clean Architecture

```
interfaces/ (handlers HTTP, middleware)
    ↓ chamam
application/ (services com casos de uso)
    ↓ usam
domain/ (entities, value objects)
    ↑ implementam
infrastructure/ (database, session, bcrypt)
```

### 2.2 Fluxo de Autenticação

```
POST /login
  → authService.Login(username, password)
    → usuarioRepo.FindByNrUsuario(username)  -- busca senha + hash
    → auth.CheckPassword(plain, hash)         -- verifica bcrypt ou plain text
    → se plain text: auth.HashPassword(plain) → atualiza banco (migração gradual)
  → sessionMgr.CreateSession(userID)          -- cria sessão
  → set cookie CGDocSession                   -- redirect para /menu
```

---

## 3. AMBIENTE

### 3.1 Servidor
- **Hostname**: vmi2968998 (contabo-tailscale)
- **IP Tailscale**: 100.64.117.78
- **IP Público**: 157.173.124.16
- **Usuário**: deploy
- **Projeto**: `/home/deploy/Apps/base_2026_go/`
- **SSH**: Chave `id_ed25519_jogoshoc` (autentica como `jogoshoc` no GitHub)

### 3.2 Stack
| Item | Versão |
|------|--------|
| Go | 1.25.0 |
| MariaDB | 10.11.18 (Docker) |
| Docker Compose | v2.40.3 |
| chi router | v1.5.4 |
| go-sql-driver/mysql | v1.10.0 |
| golang.org/x/crypto | v0.31.0 (bcrypt) |

### 3.3 Credenciais
- **Root DB**: `root` / `cts@pmmgcgdoc` (porta 3307)
- **App DB**: `cgdoc_user` / `cts@pmmgcgdoc`
- **Admin app**: `1088608` (senha precisa reset — hash dummy na migration)
- **Usuário teste**: `s1656743` / `165674` (bcrypt já migrado)

---

## 4. OPERAÇÃO

### 4.1 Iniciar tudo
```bash
cd /home/deploy/Apps/base_2026_go
docker compose up -d
```

### 4.2 Rebuildar apps (após alterações)
```bash
docker compose build --no-cache sadm-app sercod-app
docker compose up -d sadm-app sercod-app
```

### 4.3 Reset completo (destrói volume DB — dados serão perdidos)
```bash
docker compose down -v
docker compose up -d
```

### 4.4 Ver logs
```bash
docker compose logs -f sadm-app sercod-app
```

### 4.5 Acessar banco
```bash
docker compose exec db mariadb -u root -p"cts@pmmgcgdoc" movedb_SAdm
```

### 4.6 Rodar testes unitários
```bash
cd /home/deploy/Apps/base_2026_go
go test ./internal/application/... -v
```

---

## 5. ENDPOINTS

### SAdm (http://100.64.117.78:5001)
| Rota | Método | Descrição | Observação |
|------|--------|-----------|------------|
| `/login` | GET/POST | Login | POST com form `username`+`password` |
| `/logout` | GET | Logout | |
| `/menu` | GET | Menu principal | |
| `/cadastro/list` | GET | Listar cadastros | `?page=1&limit=50` |
| `/cadastro/add` | GET/POST | Adicionar cadastro | |
| `/cadastro/edit` | GET/POST | Editar cadastro | `?controle=ID` |
| `/cadastro/view` | GET | Visualizar cadastro | `?controle=ID` |
| `/cadastro/search` | GET/POST | Buscar cadastro | Filtros: `nome`, `nrprotoc`, `assunto`, `emissor`, `destino`, `nat`, `tipodoc` |
| `/cadastro/delete` | GET | Excluir cadastro | `?controle=ID` |
| `/tramitacao/list` | GET | Listar tramitações | `?nrprotoc=PROT` (não usar `controle`) |
| `/tramitacao/add` | GET/POST | Adicionar tramitação | |
| `/moviment/list` | GET | Listar movimentações | `?nrprotoc=PROT` (não usar `controle`) |
| `/moviment/add` | GET/POST | Adicionar movimentação | |

### Sercod (http://100.64.117.78:5002)
Mesmas rotas, operando sobre `movedb_Sercod`.
> **Nota**: O login do Sercod é em `POST /login` (porta 5002), **não** `/sercod/login`.

---

## 6. BUGS CONHECIDOS

### 6.1 Rota `/cadastro` (sem subpath) retorna 404
**Impacto**: Baixo. A rota correta é `/cadastro/list`. Se necessário, adicionar redirect:
```go
r.Get("/cadastro", func(w http.ResponseWriter, r *http.Request) {
    http.Redirect(w, r, "/cadastro/list", http.StatusMovedPermanently)
})
```

### 6.2 Cookies de sessão entre SAdm e Sercod
**Impacto**: Baixo. Cada app (5001 e 5002) tem seu próprio cookie `CGDocSession`. É necessário logar separadamente em cada porta. Se houver necessidade de SSO, seria preciso um shared session store.

### 6.3 `version: '3.8'` no docker-compose.yml
**Impacto**: Mínimo. Docker Compose v2 emite warning. Remover a linha para silenciar.

### 6.4 Arquivos não versionados no .gitignore
**Impacto**: Baixo. Recomenda-se adicionar ao `.gitignore`:
```
*.bak
.agents/skills/
.claude/skills/
.clinerules
```

---

## 7. PRÓXIMOS PASSOS (priorizados)

### 🟡 Média Prioridade
1. **Testar paridade** — comparar telas ASP (legado em `cgdoc/`) vs Go
2. **Adicionar redirect** de `/cadastro` para `/cadastro/list`
3. **Limpar `.gitignore`** (arquivos .bak, skills reversa, .clinerules)

### 🟢 Baixa Prioridade
4. **Logging estruturado** (substituir `log.Println` por zerolog/slog)
5. **Health check endpoints** (`/health`, `/ready`)
6. **CI/CD** (GitHub Actions para testes ao fazer push)
7. **SSO entre SAdm e Sercod** (compartilhar sessão via Redis/banco)

---

## 8. DECISÕES ARQUITETURAIS

| Decisão | Motivo |
|---------|--------|
| `mysql.Config{}` + `FormatDSN()` | Senha contém `@` — DSN string falhava |
| `AllowNativePasswords: true` | MariaDB 10.11 requer native auth |
| `INSERT IGNORE` no ETL | Dados legados têm duplicatas (~0.6%) |
| `--force` no MariaDB import | Tabela `Orgaos` tem UNIQUE que gerava erro |
| `acesso` → `acesso_legado` | Colisão com tabela Go `acesso` |
| Prefixos em NrProtoc | Evitar conflito entre módulos (sadm- / sercod- / sercod_sadm-) |
| Tramitacao via JOIN | Enriquecer com emissor/assunto/tipodoc a partir de Cadastro |
| **bcrypt migration on login** | Senhas plain text migradas no primeiro login — sem break |

---

## 9. GLOSSÁRIO

| Termo | Significado |
|-------|-------------|
| SAdm | Secretaria Administrativa |
| Sercod | Secretaria de Códigos |
| NrProtoc | Número de Protocolo (identificador do documento) |
| CodMov | Código da Movimentação |
| Tramitação | Fluxo de movimentação entre unidades |
| CópiaPerfeita | Estratégia de migração: interface idêntica ao legado |
| Parallel Run | Ambos sistemas (legado + novo) rodam simultaneamente |
| Reversa | Framework de engenharia reversa usado para analisar o ASP |

---

## 10. CONTATO / HISTÓRICO

| Data | Evento |
|------|--------|
| **19/06/2026** | Todas as correções aplicadas. bcrypt, testes, search, view, push GitHub. Documentação finalizada. |
| **18/06/2026** | Migração concluída. Documentação inicial criada. Apps rodando em Docker. |
| **09/05/2026** | Início do projeto. Setup Reversa + análise do legado. |

---

## 11. COMMITS (GitHub: jogoshoc/base_2026_go)

```
1219f61 feat: implementa rota /cadastro/view e search dinamico
f39fa09 feat: implementa bcrypt para senhas e testes unitarios
daa7a73 fix: adiciona campo senha nas queries SELECT de usuarios
fcbef83 reversa: atualiza estado da engenharia reversa
647c110 fix: handlers, middleware e repositórios de tramitação
cdef5e8 chore: corrige .gitignore para excluir apenas binários
f51ba24 fix: driver MySQL e DSN com suporte a senha especial
6d220da feat: schema Go e script ETL de transformação
b868f8f infra: docker compose e pipeline de inicialização
1f03ecc docs: documentação do projeto e handoff para próxima equipe
```
