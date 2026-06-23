# CGDoc — Controle de Gestão Documental

> **Status:** 🟢 Funcional — Login e Menu migrados para sistema de templates
> **Última atualização:** 23/06/2026
> **Próxima sessão:** Migrar ChangePassword + redirect `/cadastro`
> **Stack:** Go + MariaDB + Chi Router
> **OpenCode:** 9 plugins ativos (matrixx, auto-resume, runtime-fallback, todo-reminder, oh-my-opencode, mysql, token-monitor, write-status, auto-continue)

---

## Sumário

1. [Status do Projeto](#1-status-do-projeto)
2. [Objetivo Atual](#2-objetivo-atual)
3. [Stack Tecnológica](#3-stack-tecnológica)
4. [Arquitetura](#4-arquitetura)
5. [Funcionalidades Implementadas](#5-funcionalidades-implementadas)
6. [Funcionalidades a Implementar e Testar](#6-funcionalidades-a-implementar-e-testar)
7. [Erros Atuais e Soluções](#7-erros-atuais-e-soluções)
8. [Arquivos Modificados Recentemente](#8-arquivos-modificados-recentemente)
9. [Próximos Passos Imediatos](#9-próximos-passos-imediatos)
10. [Checkpoint: Onde Paramos](#10-checkpoint-onde-paramos)
11. [Referência de UI — Telas do Projeto](#11-referência-de-ui--telas-do-projeto)
12. [Plano de Migração — Progresso](#12-plano-de-migração--progresso)

---

## 1. Status do Projeto

Migração do sistema **CGDoc** de ASP Clássico + Microsoft Access para **Go + MariaDB**, seguindo a estratégia **CópiaPerfeita** (zero aprendizado para usuários finais).

| Subsistema | Porta | Status |
|------------|-------|--------|
| SAdm (Secretaria Administrativa) | 5001 | 🟢 Funcional |
| Sercod (Secretaria de Códigos) | 5002 | 🟢 Funcional |
| MariaDB | 3307 | 🟢 Online |
| Docker Compose | — | 🟢 Operacional |
| Testes unitários | — | 🟢 17/17 passando |

**Ambiente de produção:** Servidor Contabo (vmi2968998) — Tailscale + IP público.

---

## 2. Objetivo Atual

Completar a migração com **CópiaPerfeita**:

- ✅ Funcionalidades core implementadas (Login, CRUD, Busca, Tramitação, Movimentação)
- ✅ Bcrypt + migração automática de senhas legadas
- ✅ Testes unitários (17 testes)
- ✅ Docker Compose com 3 containers
- ✅ Dados migrados (~279k registros)
- ✅ Templates base com identidade visual PMMG (dark + dourado)
- ✅ Entidades de domínio mapeadas (aud_moviment, moviment_sec)
- ⏳ Pendente: Paridade de interface (telas ASP vs Go), CI/CD, SSO, logging

---

## 3. Stack Tecnológica

### Produção (Servidor Contabo)

| Componente | Tecnologia | Versão |
|------------|------------|--------|
| Linguagem | Go | 1.25+ |
| Router | chi | v1.5.4 |
| Database | MariaDB (Docker) | 10.11.18 |
| Driver DB | go-sql-driver/mysql | v1.10.0 |
| Bcrypt | golang.org/x/crypto | v0.31.0 |
| Container | Docker Compose | v2.40.3 |
| SO | Ubuntu (servidor) | — |
| Sessão | sync.Map | 20min timeout |

### Desenvolvimento

| Componente | Tecnologia |
|------------|------------|
| SO | Windows (local) |
| Editor | OpenCode / VS Code |
| Git | GitHub (jogoshoc/base_2026_go) |
| Template | Go html/template |

---

## 4. Arquitetura

### Clean Architecture

```
cmd/sadm/main.go          # Entrypoint SAdm (:8081 → host 5001)
cmd/sercod/main.go        # Entrypoint Sercod (:8082 → host 5002)
internal/
├── application/           # Services (casos de uso)
│   ├── auth/              # Auth service + bcrypt
│   ├── cadastro/          # Cadastro CRUD
│   ├── moviment/          # Movimentação
│   └── tramitacao/        # Tramitação
├── config/                # Config (DSN, ports, session)
├── domain/
│   ├── entities/          # Structs de domínio
│   └── valueobjects/      # NrProtoc com prefixos
├── infrastructure/
│   ├── database/          # Repositórios + interfaces
│   └── session/           # Session manager
└── interfaces/
    ├── http/              # Handlers (sadm/ + sercod/)
    │   └── templates/     # Sistema de templates HTML
    └── middleware/         # Auth middleware
migrations/                # SQL migrations + ETL
docker-compose.yml         # Orquestração 3 containers
```

### Infraestrutura (Produção)

```
                       Internet
                           │
                    ┌──────┴──────┐
                    │   Servidor   │
                    │ Contabo      │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         porta 5001   porta 5002   porta 3307
              │            │            │
        ┌─────┴─────┐ ┌───┴────┐  ┌────┴──────┐
        │ sadm-app  │ │sercod-  │  │ MariaDB   │
        │ Go + chi  │ │  app    │  │ 10.11     │
        └─────┬─────┘ └───┬────┘  └────┬──────┘
              │            │            │
              └────────────┼────────────┘
                           │
                    ┌──────┴──────┐
                    │  3 bancos   │
                    │ movedb_*    │
                    └─────────────┘
```

### Fluxo de Autenticação

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

## 5. Funcionalidades Implementadas

### Core (SAdm + Sercod)

| Funcionalidade | SAdm (5001) | Sercod (5002) | Testes |
|----------------|:-----------:|:-------------:|:------:|
| Login (bcrypt) | ✅ | ✅ | ✅ |
| Logout | ✅ | ✅ | — |
| Menu principal | ✅ | ✅ | — |
| Listar cadastros | ✅ | ✅ | ✅ |
| Ver cadastro (/view) | ✅ | ✅ | — |
| Adicionar cadastro | ✅ | ✅ | — |
| Editar cadastro | ✅ | ✅ | — |
| Excluir cadastro | ✅ | ✅ | — |
| Search (7 filtros) | ✅ | ✅ | — |
| Tramitação (CRUD) | ✅ | ✅ | — |
| Movimentação (CRUD) | ✅ | ✅ | ✅ |
| Paginação | ✅ | ✅ | — |
| Lembrar senha (cookie) | ✅ | ✅ | — |

### Infraestrutura

| Item | Status |
|------|--------|
| Docker Compose | ✅ 3 containers |
| Dockerfile multi-stage | ✅ |
| ETL (Access → MariaDB) | ✅ ~279k registros |
| Migração bcrypt (on login) | ✅ |
| Schema MariaDB inicial | ✅ |
| Migração hash senhas | ✅ |
| .gitignore | ✅ |

### Design System (novo)

| Item | Status |
|------|--------|
| Sistema de templates (renderer.go) | ✅ |
| base.html (layout responsivo dark + dourado) | ✅ |
| Tela de login | ✅ |
| Tela de menu | ✅ |
| Tela de troca de senha | ✅ |
| Paleta de cores institucionais PMMG | ✅ Referência em `images/` |
| Screenshots do legado como referência | ✅ `images/` |

### Entidades de Domínio

| Entidade | Arquivo | Status |
|----------|---------|--------|
| Cadastro | `internal/domain/entities/cadastro.go` | ✅ |
| Tramitacao | `internal/domain/entities/tramitacao.go` | ✅ |
| Usuario | `internal/domain/entities/usuario.go` | ✅ |
| Moviment | `internal/domain/entities/moviment.go` | ✅ |
| AudMoviment | `internal/domain/entities/aud_moviment.go` | ✅ Novo |
| MovimentSec | `internal/domain/entities/moviment_sec.go` | ✅ Novo |
| NrProtoc (VO) | `internal/domain/valueobjects/nrprotoc.go` | ✅ |

---

## 6. Funcionalidades a Implementar e Testar

### Pendentes (Média Prioridade)

| Item | Descrição | Esforço |
|------|-----------|---------|
| Rota `/cadastro` sem subpath → redirect | 404 atualmente, redirecionar para `/cadastro/list` | 🔵 Baixo |
| Paridade de interface | Comparar telas ASP (cgdoc/) vs Go, ajustar CSS | 🟡 Médio |
| Migrar handler **ChangePassword** para `templates.Render()` | Último handler com HTML inline | 🔵 Baixo |
| Schema local incompatível (colunas legado vs Go) | `NumeroDoUsuario` → `nr_usuario` e outras colunas | 🟡 Médio |
| Testes para Tramitação | `internal/application/tramitacao/service_test.go` | 🟡 Médio |

### Pendentes (Baixa Prioridade)

| Item | Descrição |
|------|-----------|
| SSO entre SAdm e Sercod | Compartilhar sessão via Redis/banco |
| CI/CD (GitHub Actions) | Rodar testes ao fazer push |
| Logging estruturado | Substituir `log.Println` por zerolog/slog |
| Health check endpoints | `/health`, `/ready` |
| Remover `version: '3.8'` do docker-compose | Warning do Docker Compose v2 |

### Testes a Implementar

| Teste | Status |
|-------|--------|
| Auth (login, logout, bcrypt) | ✅ 17 testes |
| Cadastro (CRUD) | ✅ Incluído nos 17 |
| Moviment (CRUD) | ✅ Incluído nos 17 |
| Tramitação | ❌ Pendente |
| Templates (renderização) | ✅ Testado manualmente (login + menu) |
| Integration (handler → DB) | ❌ Pendente |

---

## 7. Erros Atuais e Soluções

### Erros Conhecidos

| ID | Erro | Status | Solução |
|----|------|--------|---------|
| E-01 | Rota `/cadastro` sem subpath → 404 | 🔴 Aberto | Adicionar redirect: `r.Get("/cadastro", redirectTo("/cadastro/list"))` |
| E-02 | Cookies independentes SAdm/Sercod | 🟡 Contornado | Logar separadamente em cada porta. SSO futuro. |
| E-03 | `version: '3.8'` obsoleto no docker-compose | 🟡 Warning | Remover a linha. Docker Compose v2 ignora. |
| E-04 | Dados legados com encoding misto (acentos) | ✅ Resolvido | ETL com `INSERT IGNORE` + `COALESCE` |
| E-05 | Senha com `@` quebrava DSN string | ✅ Resolvido | `mysql.Config{}` + `FormatDSN()` |
| E-06 | Campo `senha` ausente nas queries SELECT | ✅ Resolvido | Commit daa7a73 |
| E-07 | `cumplido` → `cumprido` (espanhol) | ✅ Resolvido | Commit 647c110 |
| E-08 | NULL values no banco | ✅ Resolvido | UPDATE NULL → "" em todas as tabelas |
| E-09 | Rebase abortado (conflitos local vs remote) | ✅ Resolvido | `git reset --hard origin/master` + cherry-pick dos arquivos únicos |
| E-10 | Schema local (MariaDB Windows) tem colunas legado | 🔴 Aberto | `NumeroDoUsuario` em vez de `nr_usuario` — rodar migrations ou adaptar queries |

### Erros não Executados (Documentados)

| ID | Problema | Motivo |
|----|----------|--------|
| NE-01 | Schema local usava `nr_protoc`, remote usa `nrprotoc` | Remote mais avançado (bcrypt, search, view) — adotamos schema do remote |
| NE-02 | Normalização snake_case completa nas queries | Remote já tinha schema funcional com nomes diferentes (ex: `nr_usuario` vs `numero_usuario`) |

---

## 8. Arquivos Modificados Recentemente

### Últimos Commits

| Commit | Data | Descrição |
|--------|------|-----------|
| `1e0d3f0` | 23/06 | `docs: atualiza README.md e AGENTS.md com progresso dos plugins OpenCode` |
| `e153ccb` | 23/06 | `feat: migra login e menu para sistema de templates com base.html` |
| `51ff961` | 22/06 | `feat: adiciona screenshots de referencia do sistema legado como guia de UI` |
| `e2550bd` | 22/06 | `docs: adiciona README.md completo com status, stack, funcionalidades e roadmap` |
| `d0b4480` | 22/06 | `chore: atualiza .gitignore com binarios e arquivos temporarios` |
| `f984504` | 22/06 | `feat: implementa sistema de templates com base.html e renderer` |
| `4ea351e` | 22/06 | `feat: adiciona entidades aud_moviment e moviment_sec para tabelas do Access` |

### Arquivos Novos

```
internal/domain/entities/aud_moviment.go     # Entidade de auditoria (tabela Access unificada)
internal/domain/entities/moviment_sec.go      # Entidade de movimentação secundária
internal/interfaces/http/templates/renderer.go # Sistema de templates (ParseTemplates + Render)
internal/interfaces/http/templates/base.html   # Layout base dark + dourado (315 linhas CSS)
internal/interfaces/http/templates/login.html  # Tela de login com identidade PMMG
internal/interfaces/http/templates/menu.html   # Menu principal com cards
internal/interfaces/http/templates/change-password.html # Troca de senha
README.md                                      # Este arquivo
```

### Pasta images/ (adicionada ao projeto)

Screenshots de referência do sistema legado ASP e do layout institucional PMMG:

| Imagem | Descrição |
|--------|-----------|
| `images/coresinstitucionais.png` | Paleta de cores institucionais PMMG |
| `images/logopmmg.png` | Brasão/logotipo PMMG |
| `images/nav_index_login_sadm_1776869322636.png` | Tela de login SAdm (legado, tema escuro) |
| `images/fix_nav_Index_Principal_1776869423416.png` | Homepage/índice do sistema |
| `images/fix_nav_Menu_SAdm_1776869424861.png` | Menu SAdm com botões dourados |
| `images/fix_nav_Menu_Sercod_1776869425535.png` | Menu Sercod |
| `images/2026-04-04_SAdm_Cadastro_list_listagem_*.png` | Listagem de cadastro (tabela, filtros, paginação) |
| `images/2026-04-04_SAdm_Tramitacao_list_listagem_*.png` | Listagem de tramitação |
| `images/2026-04-04_SAdm_Impr_recibo_list_listagem_*.png` | Impressão de recibo |
| `images/2026-04-04_menu_SAdm_login_sucesso_*.png` | Menu pós-login |
| `images/2026-04-04_changepwd_*.png` | Troca de senha |
| `images/check_*.png` | Verificações de módulos funcionais |

> **Nota:** As imagens com fundo escuro e elementos dourados representam o **design alvo** do novo sistema Go, seguindo a identidade visual institucional da PMMG. O sistema de templates (`base.html`) já implementa essa paleta (`#0D0D0D` + `#C8A96E`).

---

## 9. Próximos Passos Imediatos

### ✅ CONCLUÍDO — 23/06: Migrar Login e Menu para Sistema de Templates

**Checklist executado:** `e153ccb`

```
[x] git pull (confirmar synced com origin/master)
[x] go vet ./... (baseline antes de começar)
[x] cmd/sadm/main.go — adicionar templates.ParseTemplates() no startup
[x] internal/interfaces/http/sadm/auth.go — substituir w.Write([]byte(`...`)) do Login e Menu por templates.Render()
[x] Ajustar login.html para receber dados do handler (subsystem, errorMsg, remember)
[x] go vet ./... + go build ./cmd/sadm/
[x] cmd/sercod/main.go — adicionar templates.ParseTemplates() no startup
[x] internal/interfaces/http/sercod/auth.go — mesmo replace no Login e Menu
[x] go vet ./... + go build ./cmd/sercod/
[x] go test ./internal/application/... -v (17/17 passando)
[x] Commit: "feat: migra tela de login do SAdm e Sercod para sistema de templates"
[x] git push
```

**Arquivos modificados:**
- `cmd/sadm/main.go` — + `templates.ParseTemplates()`
- `internal/interfaces/http/sadm/auth.go` — Login e Menu via `templates.Render()`
- `cmd/sercod/main.go` — + `templates.ParseTemplates()`
- `internal/interfaces/http/sercod/auth.go` — Login e Menu via `templates.Render()`
- `internal/interfaces/http/templates/renderer.go` — `ParseTemplates` + `Render` + `includeTemplate`
- `internal/interfaces/http/templates/base.html` — Layout com `{{include .ContentTemplate .}}`
- `internal/interfaces/http/templates/login.html` — Tela com `{{define "login-content"}}`
- `internal/interfaces/http/templates/menu.html` — Tela com `{{define "menu-content"}}`

**Resultado:** Telas de login e menu com tema dark + dourado (identidade PMMG) nos dois subsistemas ✅

---

### Prioridade 2 — Paridade e Consistência
- [x] Migrar handler Login (`sadm/auth.go`, `sercod/auth.go`) para `templates.Render()`
- [x] Migrar handler Menu (`sadm/auth.go`, `sercod/auth.go`) para `templates.Render()`
- [ ] Migrar handler ChangePassword para `templates.Render()`
- [ ] Ajustar CSS da listagem de cadastro (faltam colunas e filtros)
- [ ] Comparar telas ASP legadas com telas Go atuais
- [ ] Adicionar redirect `/cadastro` → `/cadastro/list`
- [ ] Corrigir schema local (colunas legado vs Go no MariaDB local)

### Prioridade 3 — Testes
- [ ] Implementar testes unitários para Tramitação
- [ ] Implementar testes para o sistema de templates
- [ ] Expandir cobertura de testes de integração

### Prioridade 4 — Infraestrutura
- [ ] CI/CD com GitHub Actions (rodar `go vet` + `go test` no push)
- [ ] Limpar `.gitignore` (adicionar `.bak`, `.agents/skills/`, `.claude/skills/`)
- [ ] Remover `version: '3.8'` do docker-compose.yml

### Prioridade 5 — Evolução
- [ ] Logging estruturado (zerolog/slog)
- [ ] Health checks (`/health`, `/ready`)
- [ ] SSO entre SAdm e Sercod

---

## 10. Checkpoint: Onde Paramos

### Checkpoint 23/06/2026 — 16 commits no total

**Estado atual:** `origin/master` syncado. Migração de login e menu para templates concluída. 9 plugins OpenCode instalados.

**O que foi feito na sessão de 23/06:**

1. ✅ Retomada dos serviços (SAdm `:8081`, Sercod `:8082`, MariaDB)
2. ✅ `go vet ./...` + `go build ./cmd/sadm/` + `go build ./cmd/sercod/` — limpo
3. ✅ `go test ./internal/application/... -v` — 17/17 passando
4. ✅ SAdm `auth.go` — Login e Menu migrados para `templates.Render()`
5. ✅ Sercod `auth.go` — Login e Menu migrados para `templates.Render()`
6. ✅ Ambos `main.go` — `templates.ParseTemplates()` no startup
7. ✅ Sistema de templates funcional (base.html + login.html + menu.html)
8. ✅ Commit `e153ccb` + push para `origin/master`
9. ✅ `.gitignore` atualizado (`.log`, `*~`)
10. ✅ **9 plugins OpenCode instalados e registrados** (matrixx, auto-resume, runtime-fallback, todo-reminder, oh-my-opencode, mysql, token-monitor, write-status, auto-continue)
11. ✅ `opencode.json` do projeto criado com model `opencode/deepseek-v4-flash-free`

**O que NÃO foi feito (adiado):**

| Item | Motivo |
|------|--------|
| Migrar handler ChangePassword | Pendente — próximo passo |
| Redirect `/cadastro` → `/cadastro/list` | Pendente |
| Schema local (colunas legado vs Go) | Necessário rodar migrations ou adaptar queries |
| Testes de Tramitação | Pendente na lista de próximos passos |

### Plano Original (Reversa — 8 Tasks)

| Task | Descrição | Status |
|------|-----------|--------|
| 1 | Schema MariaDB | ✅ Completo |
| 2 | Entidades de Domínio | ✅ Completo (+ novas entidades) |
| 3 | Repositories | ✅ Completo |
| 4 | Auth Service | ✅ Completo (+ bcrypt) |
| 5 | Cadastro CRUD | ✅ Completo (+ search, view) |
| 6 | Tramitação/Movimentação | ✅ Completo |
| 7 | Sercod (clone SAdm) | ✅ Completo |
| 8 | Integração e Testes | ✅ 17 testes (parcial — pendente tramitação) |

> Confiança geral da engenharia reversa: ~69% (62% confirmado, 31% inferido, 7% lacuna)

---

## 11. Referência de UI — Telas do Projeto

O diretório `images/` contém screenshots do sistema legado ASP que servem como **referência de design** para o novo sistema Go. As imagens com fundo escuro (`#0D0D0D` / `#1E1E1E`) e elementos dourados (`#C8A96E`) representam o **design alvo**.

### Paleta de Cores Institucional (PMMG)

| Cor | Uso | Hex |
|-----|-----|-----|
| ⬛ Fundo escuro | Background principal | `#0D0D0D` |
| ⬛ Card/cinza escuro | Cards, sidebar, tabelas | `#2C2C2C` |
| ⬛ Input/cinza médio | Campos de formulário | `#3A3A3A` |
| 🟫 Dourado institucional | Títulos, links, botões, bordas | `#C8A96E` |
| 🟫 Dourado escuro | Hover/ativo | `#A89060` |
| ⬜ Branco | Texto principal | `#FFFFFF` |
| ⬜ Cinza claro | Texto secundário | `#AAAAAA` |
| 🔴 Vermelho | Erro, danger | `#CC0000` |
| 🟢 Verde | Sucesso | `#00CC00` |

### Telas de Referência

| Tela | Arquivo | Sistema |
|------|---------|---------|
| Login | `images/nav_index_login_sadm_*.png` | Legado ASP |
| Login | `images/2026-04-04_login_SAdm_carregamento_*.png` | Legado ASP |
| Menu principal | `images/fix_nav_Menu_SAdm_*.png` | Legado ASP |
| Homepage | `images/fix_nav_Index_Principal_*.png` | Legado ASP |
| Listagem cadastro | `images/2026-04-04_SAdm_Cadastro_list_listagem_*.png` | Legado ASP |
| Listagem tramitação | `images/2026-04-04_SAdm_Tramitacao_list_listagem_*.png` | Legado ASP |
| Impressão recibo | `images/2026-04-04_SAdm_Impr_recibo_list_listagem_*.png` | Legado ASP |
| Troca senha | `images/2026-04-04_SAdm_changepwd_listagem_*.png` | Legado ASP |
| Cores institucionais | `images/coresinstitucionais.png` | Guia de cores |
| Auditoria | `images/check_AUDITORIA_200.png` | Verificação funcional |

---

## 12. Plano de Migração — Progresso

Baseado no `PLANO_COPIA_PERFEITA.md` (6 fases de Parallel Run):

| Fase | Descrição | Status |
|------|-----------|--------|
| 1 | Setup e Análise | ✅ Completo |
| 2 | Migração de Dados | ✅ Completo |
| 3 | Implementação Core | ✅ Completo (CRUD, Auth, Search) |
| 4 | Parallel Run | 🟡 Parcial (apps rodando, paridade de interface pendente) |
| 5 | Cutover | ⏳ Não iniciado |
| 6 | Estabilização | ⏳ Não iniciado |

---

## 13. Plugins OpenCode

### Instalados (9 plugins ativos)

| Plugin | Versão | Ativação | Descrição |
|--------|--------|----------|-----------|
| `opencode-matrixx` | — | 🔄 Auto | Sistema Morpheus de agentes multi-modelo com orquestração |
| `opencode-auto-resume` | — | 🔄 Auto | Pergunta automaticamente se deseja retomar sessão anterior |
| `opencode-runtime-fallback` | — | 🔄 Auto | Fallback automático quando tarefas falham |
| `opencode-todo-reminder` | — | 🔄 Auto | Lembretes do sistema de TODOs |
| `oh-my-opencode` | — | 🔄 Auto | Temas, prompts e produtividade no shell |
| `opencode-mysql` | 0.1.1 | 🛠️ Tool/MCP | Executa queries MySQL via MCP server |
| `opencode-token-monitor` | — | 🔄 Auto | Monitora uso de tokens e custo em background |
| `opencode-write-status` | 0.5.0 | 🔄 Auto | Progresso de escrita/edição com detecção de stall |
| `opencode-auto-continue` | 0.1.1 | 🔄 Auto | Continuação automática em sessões ociosas |

### Registro

Plugins registrados em `C:\.opencode\opencode.json` (global) e projeto em `opencode.json`.

---

## Documentação Relacionada

| Arquivo | Descrição |
|---------|-----------|
| `AGENTS.md` | Manual para agentes de IA |
| `CONVENTIONS.md` | Convenções de código |
| `HANDBOOK.md` | Documento de handoff completo |
| `CLAUDE.md` | Comandos úteis e regras |
| `GEMINI.md` | Comandos úteis e regras (resumido) |
| `_reversa_sdd/` | Engenharia reversa completa (arquitetura, specs, tasks) |
| `.github/copilot-instructions.md` | Instruções para GitHub Copilot |
