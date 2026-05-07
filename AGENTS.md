# CGDoc — Projeto de Engenharia Reversa

> Legado ASP Clássico em análise. Não é um projeto de desenvolvimento ativo.

## Estrutura do Projeto

```
cgdoc/
├── SAdm/    # Secretaria Administrativa (882 arquivos ASP)
├── Sercod/  # Secretaria de Códigos
├── libs/    # Smarty, FPDF
└── db/      # SisprotWeb.mdb + schemas .sql
```

## Entry Points

- `cgdoc/SAdm/login.asp` — Login SAdm
- `cgdoc/Sercod/login.asp` — Login Sercod

## Reversa (engenharia reversa)

- Comando: digite `reversa` para ativar
- Skills: `.claude/skills/` e `.agents/skills/`
- Saídas em: `.reversa/` (análise bruta) e `_reversa_sdd/` (specs processadas)
- **Regra**: nunca modifique arquivos em `cgdoc/` (legado)

## Migração em andamento

- Stack alvo: **Go + MariaDB**
- Estratégia: "CópiaPerfeita" — interface idêntica ao legado
- Brief completo em `_reversa_sdd/migration/migration_brief.md`
