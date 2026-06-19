# CGDoc — Convenções de Código

## Stack
- **Linguagem**: Go 1.25+
- **Router**: chi v5
- **Database**: MariaDB 10.11 (driver: go-sql-driver/mysql v1.10)
- **Container**: Docker Compose
- **Bcrypt**: golang.org/x/crypto v0.31.0

## Convenções Go
- Pacotes em lowercase, sem underlines
- Interfaces no pacote `database/` (repository.go)
- Implementações no mesmo pacote (mariadb.go)
- Handlers em `interfaces/http/{sadm,sercod}/`
- Services em `application/{auth,cadastro,moviment,tramitacao}/`

## Nomenclatura de Tabelas
- **Legado**: PascalCase com acentos (`Usuários`, `Cadastro`, `Moviment`, `Orgaos`, `Tipodoc`)
- **Go**: lowercase sem acentos (`usuarios`, `cadastro`, `moviment`, `tramitacao`, `orgaos`, `tipodoc`, `acesso`, `sessoes`)

## Prefixos NrProtoc
- SAdm: `sadm-`
- Sercod: `sercod-`
- Sercod_SAdm: `sercod_sadm-`

## Geração de CodMov
- Moviment: `"MV" + time.Now().Format("20060102150405")` (legacy: `MV-{id}`)
- Tramitacao: `"TM" + time.Now().Format("20060102150405")` (legacy: `TM-{id}`)

## ETL
- Usar `INSERT IGNORE` para tolerar duplicatas
- Usar `COALESCE` para campos nulos
- Nunca dropar tabelas legadas (preservar para fallback)
- Renomear tabelas conflitantes (ex: `acesso` → `acesso_legado`)

## Autenticação
- Sessão via cookie (`CGDocSession`)
- Timeout: 20 minutos
- Admin padrão: `1088608`
- **Senhas**: bcrypt via `golang.org/x/crypto/bcrypt`
  - `internal/application/auth/password.go`: `HashPassword`, `CheckPassword`, `IsBcryptHash`
  - Migração automática: senhas plain text são convertidas para bcrypt no primeiro login bem-sucedido
  - Migration: `migrations/002_hash_passwords.sql`

## Busca (Search)
- Implementado em `internal/infrastructure/database/mariadb.go`
- Filtros dinâmicos: nome, nrprotoc, assunto, emissor, destino, nat, tipodoc
- Query builder com WHERE condicional (só adiciona cláusulas para campos preenchidos)

## Testes
- Localização: `internal/application/*/service_test.go`
- 17 testes unitários (auth, cadastro, moviment)
- Rodar com: `go test ./internal/application/... -v`

## Git
- Commits em português
- Prefixo `feat:` para novas features, `fix:` para correções, `docs:` para documentação
- Binários compilados (`sadm`, `sercod`) não versionar
- `.env` não versionar
