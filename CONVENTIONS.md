# CGDoc — Convenções de Código

## Stack
- **Linguagem**: Go 1.25+
- **Router**: chi v5
- **Database**: MariaDB 10.11 (driver: go-sql-driver/mysql v1.10)
- **Container**: Docker Compose

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
- Senhas em plain text (legado) — migrar para bcrypt eventualmente

## Git
- Commits em português
- Prefixo `feat:` para novas features, `fix:` para correções, `docs:` para documentação
- Binários compilados (`sadm`, `sercod`) não versionar
- `.env` não versionar
