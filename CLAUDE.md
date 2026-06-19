# CGDoc — Manual para Agentes de IA

> Projeto Go + MariaDB. Migração do ASP legado concluída.
> Containers Docker rodando em produção.

## Comandos Úteis

```bash
# Ver logs
docker compose logs -f sadm-app sercod-app

# Acessar banco
docker compose exec db mariadb -u root -p"$MYSQL_ROOT_PASSWORD" movedb_SAdm

# Rebuild de app específico
docker compose build --no-cache sadm-app && docker compose up -d sadm-app

# Reset completo (destrói volume de dados)
docker compose down -v && docker compose up -d

# Rodar testes unitários
go test ./internal/application/... -v

# Verificar lint
go vet ./...

# Status git
git log --oneline -5
```

## Regras

1. **Nunca modifique** arquivos em `cgdoc/` (código legado ASP)
2. **Nunca modifique** arquivos em `.reversa/` ou `_reversa_sdd/` (saídas do Reversa)
3. **Sempre use** `mysql.Config{}` para DSN (senha contém `@`)
4. **Sempre use** `INSERT IGNORE` em ETLs (dados legados podem ter duplicatas)
5. **Sempre use** `--force` em imports de SQLs legados
6. **Tabelas legadas** têm PascalCase (`Cadastro`, `Usuários`, `Moviment`)
7. **Tabelas Go** têm lowercase (`cadastro`, `usuarios`, `moviment`)
8. **Senhas**: sempre usar bcrypt (`golang.org/x/crypto/bcrypt`). Plain text legado é migrado no login.
9. **Queries de usuário**: SEMPRE incluir `senha` no SELECT (FindByNrUsuario, FindByID, ListAll)

## Estrutura de Pacotes

```
internal/
├── application/    # Services (casos de uso)
│   ├── auth/       # Auth service + bcrypt
│   ├── cadastro/   # Cadastro CRUD
│   ├── moviment/   # Movimentação
│   └── tramitacao/ # Tramitação
├── config/         # Config (DSN, ports, session)
├── domain/
│   ├── entities/   # Structs de domínio
│   └── valueobjects/  # NrProtoc com prefixos
├── infrastructure/
│   ├── database/   # Repositórios + interfaces
│   └── session/    # Session manager
└── interfaces/
    ├── http/       # Handlers (sadm/ + sercod/)
    └── middleware/  # Auth middleware
```

## Conexão com o Banco

Usar `mysql.Config{}` do pacote `github.com/go-sql-driver/mysql`:
```go
cfg := mysql.Config{
    User:                 d.User,
    Passwd:               d.Password,
    Net:                  "tcp",
    Addr:                 d.Host + ":" + strconv.Itoa(d.Port),
    DBName:               d.Database,
    ParseTime:            true,
    AllowNativePasswords: true,
}
return cfg.FormatDSN()
```

## Rotas Importantes

### SAdm (porta 5001)
| Rota | Parâmetros |
|------|------------|
| POST `/login` | `username`, `password` |
| GET `/cadastro/list` | `?page=1&limit=50` |
| GET `/cadastro/view` | `?controle=ID` |
| GET/POST `/cadastro/search` | `nome`, `nrprotoc`, `assunto`, `emissor`, `destino`, `nat`, `tipodoc` |
| GET `/moviment/list` | `?nrprotoc=PROT` (usar nrprotoc, NÃO controle) |
| GET `/tramitacao/list` | `?nrprotoc=PROT` (usar nrprotoc, NÃO controle) |

### Sercod (porta 5002)
- Login em `POST /login` (NÃO `/sercod/login`)
- Demais rotas idênticas ao SAdm

## Problemas Conhecidos

- `go-sql-driver/mysql` v1.10.0 requer `AllowNativePasswords: true` para MariaDB
- Senha `cts@pmmgcgdoc` contém `@` — usar `mysql.Config{}` para evitar parsing incorreto
- Sercod usa porta 8082 internamente (não 8080) — mapeamento Docker é `5002:8082`
- Rota `/cadastro` sem subpath retorna 404 — usar `/cadastro/list`
- SAdm e Sercod têm cookies de sessão independentes — logar separadamente em cada porta
