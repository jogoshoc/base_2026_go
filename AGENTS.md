# CGDoc — Manual para Agentes de IA (AGENTS.md)

> **Propósito**: Instruções específicas para ferramentas de IA (Claude, Cursor, etc.)
> **Data**: 23/06/2026
> **Estado**: Funcional. Login e menu migrados para sistema de templates. 9 plugins OpenCode ativos.

---

## Contexto do Projeto

Este é o sistema CGDoc, migrado de ASP Clássico + Microsoft Access para Go + MariaDB.
São 3 containers Docker rodando no servidor Contabo (vmi2968998).

**Acessos:**
- SSH: `deploy@100.64.117.78` (Tailscale) ou `157.173.124.16` (público)
- SAdm: http://100.64.117.78:5001
- Sercod: http://100.64.117.78:5002
- MariaDB: porta 3307, root/cts@pmmgcgdoc
- GitHub: `git@github-jogoshoc:jogoshoc/base_2026_go.git` (chave: `~/.ssh/id_ed25519_jogoshoc`)

---

## Estado Atual (23/06/2026)

### ✅ Funcionalidades Implementadas e Testadas

| Funcionalidade | SAdm (5001) | Sercod (5002) |
|----------------|-------------|---------------|
| Login (bcrypt) | ✅ | ✅ |
| Listar cadastros | ✅ | ✅ |
| Ver cadastro | ✅ | ✅ |
| Adicionar cadastro | ✅ | ✅ |
| Editar cadastro | ✅ | ✅ |
| Excluir cadastro | ✅ | ✅ |
| Search (7 filtros) | ✅ | ✅ |
| Movimentação | ✅ | ✅ |
| Tramitação | ✅ | ✅ |
| Testes unitários | ✅ (17 testes) | — |

### ⏳ Pendentes (baixa prioridade)
- Rota `/cadastro` sem subpath → 404 (usar `/cadastro/list`)
- SSO entre SAdm e Sercod
- CI/CD (GitHub Actions)
- Logging estruturado

---

## Regras para Agentes

### Sempre Fazer
- Usar `mysql.Config{}` para construir DSN (senha contém `@`)
- Usar `AllowNativePasswords: true` nas configs MySQL
- Incluir `senha` nas queries SELECT de usuários (FindByNrUsuario, FindByID, ListAll)
- Usar `golang.org/x/crypto/bcrypt` para hash/verificação de senhas
- Usar `INSERT IGNORE` em ETLs (duplicatas legadas)
- Prefixar containers com `--no-cache` no build para garantir binários atualizados
- Verificar `go vet ./...` e `go test ./internal/application/... -v` após alterações

### Nunca Fazer
- Modificar arquivos em `cgdoc/` (código legado ASP)
- Modificar `.reversa/` ou `_reversa_sdd/` (saídas do Reversa)
- Dropar tabelas legadas (preservar para fallback)
- Usar `as any`, `@ts-ignore` ou equivalentes em Go
- Commitar sem verificar lint + testes

---

## Fluxo de Autenticação

```
1. POST /login → authHandler.Login
2. authService.Login(username, password)
3. usuarioRepo.FindByNrUsuario(username) → {senha_hash, ...}
4. auth.CheckPassword(plain_password, senha_hash)
   → Se hash bcrypt ($2a$...): bcrypt.CompareHashAndPassword
   → Se plain text: compara direto + migra para bcrypt (HashPassword + UPDATE)
5. sessionMgr.CreateSession(userID) → sessionID
6. set cookie CGDocSession → redirect /menu
```

---

## Conexão SSH com GitHub

```bash
# A chave id_ed25519_jogoshoc autentica como usuário "jogoshoc"
ssh -T github-jogoshoc
# Hi jogoshoc! You've successfully authenticated...

# Push
cd ~/Apps/base_2026_go
git push origin master
```

---

## Plugins OpenCode (9 ativos)

| Plugin | Ativação | Descrição |
|--------|----------|-----------|
| `opencode-matrixx` | 🔄 Auto | Sistema Morpheus de agentes multi-modelo |
| `opencode-auto-resume` | 🔄 Auto | Retomada automática de sessões |
| `opencode-runtime-fallback` | 🔄 Auto | Fallback em falhas de execução |
| `opencode-todo-reminder` | 🔄 Auto | Lembretes de progresso de TODOs |
| `oh-my-opencode` | 🔄 Auto | Produtividade no shell |
| `opencode-mysql` | 🛠️ Tool | MCP server para queries MySQL |
| `opencode-token-monitor` | 🔄 Auto | Monitoramento de tokens |
| `opencode-write-status` | 🔄 Auto | Progresso de escrita em tempo real |
| `opencode-auto-continue` | 🔄 Auto | Continuação automática em ociosidade |

---

## Testes

```bash
# Rodar todos os testes
cd ~/Apps/base_2026_go
go test ./internal/application/... -v

# Testes específicos
go test ./internal/application/auth/... -v
go test ./internal/application/cadastro/... -v
go test ./internal/application/moviment/... -v
```
