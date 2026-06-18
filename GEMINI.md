# CGDoc — Manual para Agentes de IA

> Projeto Go + MariaDB. Migração do ASP legado concluída.

## Comandos Úteis

```bash
# Ver logs
docker compose logs -f sadm-app sercod-app

# Acessar banco
docker compose exec db mariadb -u root -p"$MYSQL_ROOT_PASSWORD" movedb_SAdm

# Rebuild de app específico
docker compose build sadm-app && docker compose up -d sadm-app

# Reset completo (destrói volume de dados)
docker compose down -v && docker compose up -d
```

## Regras

1. **Nunca modifique** arquivos em `cgdoc/` (código legado ASP)
2. **Nunca modifique** arquivos em `.reversa/` ou `_reversa_sdd/` (saídas do Reversa)
3. **Sempre use** `mysql.Config{}` para DSN (senha contém `@`)
4. **Sempre use** `INSERT IGNORE` em ETLs (dados legados podem ter duplicatas)
5. **Sempre use** `--force` em imports de SQLs legados
6. **Tabelas legadas** têm PascalCase (`Cadastro`, `Usuários`, `Moviment`)
7. **Tabelas Go** têm lowercase (`cadastro`, `usuarios`, `moviment`)

## Problemas Conhecidos

- `go-sql-driver/mysql` v1.10.0 requer `AllowNativePasswords: true` para MariaDB
- Senha `cts@pmmgcgdoc` contém `@` — usar `mysql.Config{}` para evitar parsing incorreto
- Sercod usa porta 8082 internamente (não 8080) — mapeamento Docker é `5002:8082`
- Repositórios usam `cumplido` (espanhol) em vez de `cumprido` (português) — corrigir
- Docker `version: '3.8'` obsoleto — remover na próxima atualização

## Handoff

Para continuar o trabalho, leia `HANDBOOK.md` na raiz do projeto — contém todo o contexto, próximos passos e estado atual do sistema.
