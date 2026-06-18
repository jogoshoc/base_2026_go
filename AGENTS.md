# CGDoc — Sistema de Tramitação de Documentos

> Migração concluída: ASP Clássico + Access → Go + MariaDB
> Estratégia: "CópiaPerfeita" — interface e funcionalidade idênticas ao legado

## Arquitetura

```
┌──────────────┐    ┌──────────────┐
│  sadm-app    │    │ sercod-app   │
│  Go + chi    │    │  Go + chi    │
│  porta 5001  │    │  porta 5002  │
└──────┬───────┘    └──────┬───────┘
       │                   │
       └────────┬──────────┘
                │ TCP :3306
        ┌───────┴────────┐
        │   MariaDB 10.11│
        │   cgdoc_db     │
        │   porta 3307   │
        └────────────────┘
```

## Bancos de Dados

| Banco | Origem | Registros | Finalidade |
|-------|--------|-----------|------------|
| `movedb_SAdm` | `cgdoc_SAdm.sql` | ~80k | Secretaria Administrativa |
| `movedb_Sercod` | `cgdoc_sercod.sql` | ~102k | Secretaria de Códigos |
| `movedb_Sercod_SAdm` | `cgdoc_sercod_SAdm.sql` | ~51k | Tramitação entre módulos |

Cada banco contém **tabelas legadas** (PascalCase: `Cadastro`, `Usuários`, `Moviment`) e **tabelas Go** (lowercase: `cadastro`, `usuarios`, `moviment`, `tramitacao`, `orgaos`, `tipodoc`, `acesso`, `sessoes`).

## Transformações Aplicadas

| Campo Legado | Campo Go | Transformação |
|-------------|----------|---------------|
| `NrProtoc` (INT) | `nrprotoc` (VARCHAR) | Prefixo `sadm-`/`sercod-`/`sercod_sadm-` + número |
| `CodMov` (INT AUTO_INCREMENT) | `codmov` (VARCHAR) | `MV-{id}` (moviment), `TM-{id}` (tramitacao) |
| `Prazo` (DATETIME) | `prazo` (VARCHAR) | Formatado como `YYYY-MM-DD` |
| `Usuários`.`NúmeroDoUsuário` | `nr_usuario` | Sem alteração |

## Como Rodar

```bash
cd /home/deploy/Apps/base_2026_go
docker compose up -d
```

Isso inicia:
1. **MariaDB** (`cgdoc_db`) com dados legados + schema Go populado
2. **SAdm app** (`cgdoc_sadm_app`) na porta 5001
3. **Sercod app** (`cgdoc_sercod_app`) na porta 5002

Para rebuildar os apps após alterações no código:
```bash
docker compose build sadm-app sercod-app
docker compose up -d sadm-app sercod-app
```

## Endpoints

### SAdm (http://localhost:5001)
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
| `/tramitacao/list` | GET | Listar tramitações |
| `/tramitacao/add` | GET/POST | Adicionar tramitação |
| `/moviment/list` | GET | Listar movimentações |
| `/moviment/add` | GET/POST | Adicionar movimentação |

### Sercod (http://localhost:5002)
Mesmas rotas do SAdm, operando sobre `movedb_Sercod`.

## Pipeline de Inicialização (Docker)

A ordem de execução no `docker-entrypoint-initdb.d/` é:

1. **`01-create-databases.sql`** — Cria os 3 bancos + usuário `cgdoc_user`
2. **`02-load-schemas.sh`** — Importa os 3 SQLs legados (com `--force` para duplicatas)
3. **`03-migrate-to-go-schema.sh`** — Cria schema Go + executa ETL de transformação

Os arquivos de migração estão em `migrations/`:
- `001_initial_schema.sql` — Cria as tabelas Go
- `etl-legado-to-go.sql` — Transforma dados legados → schema Go

## Estrutura do Projeto

```
/
├── cmd/
│   ├── sadm/main.go      # Entry point SAdm (porta 8080)
│   └── sercod/main.go    # Entry point Sercod (porta 8082)
├── internal/
│   ├── application/      # Casos de uso (services)
│   │   ├── auth/         # Autenticação
│   │   ├── cadastro/     # Cadastro de documentos
│   │   ├── moviment/     # Movimentação
│   │   └── tramitacao/   # Tramitação
│   ├── config/           # Config (DSN com mysql.Config)
│   ├── domain/
│   │   ├── entities/     # Entidades (Usuario, Cadastro, Moviment, Tramitacao)
│   │   └── valueobjects/ # NrProtoc com prefixos
│   ├── infrastructure/
│   │   ├── database/     # Repositórios MariaDB
│   │   └── session/      # Gerenciamento de sessão
│   └── interfaces/
│       ├── http/
│       │   ├── sadm/     # Handlers SAdm
│       │   └── sercod/   # Handlers Sercod
│       └── middleware/   # Auth middleware
├── migrations/           # Schema SQL + ETL
├── docker-entrypoint-initdb.d/  # Scripts de init do DB
├── cgdoc/               # Código legado ASP (NÃO MODIFICAR)
├── docker-compose.yml
├── Dockerfile
├── .env                 # Credenciais do banco
└── go.mod
```

## Credenciais

- **DB Root**: `root` / `cts@pmmgcgdoc` (porta 3307)
- **DB User**: `cgdoc_user` / `cts@pmmgcgdoc`
- **Admin App**: `1088608` (senha precisa ser resetada — hash dummy na migration)

## Pontos de Atenção

1. **Senhas em plain text** — O legado armazenava senhas em texto claro. A migration preservou esse formato. Recomenda-se implementar bcrypt.
2. **`moviment`.`cumprido`** — O repositório usa `cumprido` (português). Verificar se olegado usava `Cumprido` ou `Cumprido`.
3. **NrProtoc duplicados** — ~0.6% dos registros no SAdm foram deduplicados (UNIQUE constraint). Revisar se é aceitável.
4. **`acesso` legado vazio** — As tabelas de log de acesso estavam vazias nos 3 bancos. 0 registros migrados é esperado.
5. **`version: '3.8'` obsoleto** — O docker-compose.yml tem warning sobre atributo `version` obsoleto. Remover na próxima atualização.

## Testes de Paridade Pendentes

- [ ] Login com usuário legado (ex: `s1656743`)
- [ ] Listagem de cadastro com filtros
- [ ] Criação de novo cadastro
- [ ] Edição de cadastro existente
- [ ] Movimentação de documento
- [ ] Tramitação entre módulos
- [ ] Exclusão de registro
