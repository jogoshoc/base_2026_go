# HANDBOOK — CGDoc Go

> **Propósito**: Documento de handoff para a próxima equipe.
> **Data**: 18/06/2026
> **Estado**: Migração concluída, apps rodando, testes de paridade pendentes.

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
│   ├── application/{auth,cadastro,moviment,tramitacao}/
│   ├── config/
│   ├── domain/{entities,valueobjects}/
│   ├── infrastructure/{database,session}/
│   └── interfaces/http/{sadm,sercod}/ + middleware/
├── migrations/
│   ├── 001_initial_schema.sql
│   └── etl-legado-to-go.sql
├── docker-entrypoint-initdb.d/
│   ├── 01-create-databases.sql
│   ├── 02-load-schemas.sh
│   └── 03-migrate-to-go-schema.sh
├── docker-compose.yml
├── Dockerfile
└── .env
```

### 1.3 Dados Migrados

| Banco | Cadastro | Moviment | Tramitacao | Usuarios | Orgaos | Tipodoc |
|-------|----------|----------|------------|----------|--------|---------|
| movedb_SAdm | 51.503 | 27.966 | 27.966 | 22 | 628 | 74 |
| movedb_Sercod | 101.212 | 323 | 323 | 25 | 513 | 189 |
| movedb_Sercod_SAdm | 25.336 | 25.208 | 25.208 | 8 | 451 | — |

**Total: ~279k registros**

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
interfaces/ (handlers, middleware)
    ↓ chama
application/ (services, casos de uso)
    ↓ usa
domain/ (entities, value objects)
    ↓ implementa
infrastructure/ (database, session)
```

---

## 3. AMBIENTE

### 3.1 Servidor
- **Hostname**: contabo-tailscale (100.64.117.78)
- **Usuário**: deploy
- **Projeto**: `/home/deploy/Apps/base_2026_go/`

### 3.2 Stack
- **Go**: 1.25.0
- **MariaDB**: 10.11.18 (Docker)
- **Docker Compose**: v2.40.3
- **chi router**: v1.5.4
- **go-sql-driver/mysql**: v1.10.0

### 3.3 Credenciais
- **Root DB**: root / cts@pmmgcgdoc (porta 3307)
- **App DB**: cgdoc_user / cts@pmmgcgdoc
- **Admin app**: 1088608 (senha precisa reset — hash dummy na migration)

---

## 4. OPERAÇÃO

### 4.1 Iniciar tudo
```bash
cd /home/deploy/Apps/base_2026_go
docker compose up -d
```

### 4.2 Rebuildar apps
```bash
docker compose build sadm-app sercod-app
docker compose up -d sadm-app sercod-app
```

### 4.3 Reset completo (destrói volume DB)
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

---

## 5. ENDPOINTS

### SAdm (http://100.64.117.78:5001)
| Rota | Método | Descrição |
|------|--------|-----------|
| `/login` | GET/POST | Login |
| `/logout` | GET | Logout |
| `/menu` | GET | Menu principal |
| `/cadastro/list` | GET | Listar cadastros |
| `/cadastro/add` | GET/POST | Adicionar cadastro |
| `/cadastro/edit` | GET/POST | Editar cadastro |
| `/cadastro/search` | GET/POST | Buscar cadastro |
| `/cadastro/delete` | GET | Excluir cadastro |
| `/cadastro/view` | GET | Visualizar cadastro |
| `/tramitacao/list` | GET | Listar tramitações |
| `/tramitacao/add` | GET/POST | Adicionar tramitação |
| `/moviment/list` | GET | Listar movimentações |
| `/moviment/add` | GET/POST | Adicionar movimentação |

### Sercod (http://100.64.117.78:5002)
Mesmas rotas, operando sobre `movedb_Sercod`.

---

## 6. BUGS CONHECIDOS

### 6.1 `cumplido` em vez de `cumprido` (ALTA PRIORIDADE)

**Arquivo**: `internal/infrastructure/database/mariadb.go`

**Problema**: Os repositórios de Moviment e Tramitacao usam `cumplido` (espanhol) nas queries SQL. A coluna no banco se chama `cumprido` (português). LINHAS AFETADAS:

```
mariadb.go:298  - FindByID (moviment): SELECT ... cumplido ...
mariadb.go:312  - Create (moviment):   INSERT ... cumplido ...
mariadb.go:320  - Update (moviment):   UPDATE ... cumplido ...
```

**Impacto**: Queries de movimentação/tramitação que usam `cumplido` falham com "Unknown column".

**Correção**: Substituir `cumplido` por `cumprido` nas 3 ocorrências. ~5 min.

### 6.2 Docker `version: '3.8'` obsoleto

**Arquivo**: `docker-compose.yml`, linha 1

**Warning**: `version` attribute é obsoleto no Docker Compose v2. Remover a linha.

### 6.3 Senhas em plain text

As senhas vieram do Access em texto claro. A migration preservou. Precisa implementar bcrypt.

---

## 7. PRÓXIMOS PASSOS (priorizados)

### 🔴 Alta Prioridade
1. **Corrigir bug `cumplido` → `cumprido`** (3 ocorrências em `mariadb.go`)
2. **Testar login com usuário legado** (ex: `s1656743`, senha `1656743`)
3. **Testar CRUD completo** (listar, criar, editar, excluir cadastro/moviment/tramitacao)

### 🟡 Média Prioridade
4. **Testar paridade** — comparar telas ASP vs Go
5. **Remover `version: '3.8'`** do docker-compose.yml
6. **Escrever testes unitários** para services e repositórios

### 🟢 Baixa Prioridade
7. **Implementar bcrypt** para senhas
8. **Logging estruturado** (substituir `log.Println` por zerolog/logrus)
9. **CI/CD** (GitHub Actions para testes ao fazer push)
10. **Health check endpoints** (`/health`, `/ready`)

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

- **18/06/2026** — Migração concluída. Documentação atualizada. Apps rodando em Docker.
- **09/05/2026** — Início do projeto. Setup Reversa + análise do legado.
