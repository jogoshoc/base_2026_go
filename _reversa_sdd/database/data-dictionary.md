# Banco de Dados — CGDoc (Schema MariaDB)

> Analisado pelo Data Master em 2026-05-06
> Fonte: Arquivos .sql exportados do Access

---

## Bancos de Dados

| Banco | Arquivo | Uso |
|-------|---------|-----|
| **SAdm** | `cgdoc/SAdm/db/cgdoc_SAdm.sql` | Secretaria Administrativa |
| **Sercod** | `cgdoc/Sercod/db/cgdoc_sercod.sql` | Secretaria de Códigos |
| **Sercod_SAdm** | `cgdoc/Sercod/SAdm/db/cgdoc_sercod_SAdm.sql` | Tramitação entre módulos |

---

## Tabelas por Banco

### SAdm (cgdoc_SAdm.sql)

| Tabela | Descrição |
|--------|-----------|
| `_AudMoviment` | Auditoria de movimentações |
| `acesso` | Log de acessos |
| `Cadastro` | **Principal** — Processos/Cadastros |
| `Moviment` | Movimentações de processos |
| `moviment_sec` | Movimentações secretariais |
| `Orgaos` | Órgãos/departamentos |
| `Tipodoc` | Tipos de documento |
| `Usuários` | Usuários do sistema |

### Sercod (cgdoc_sercod.sql)

| Tabela | Descrição |
|--------|-----------|
| `acesso` | Log de acessos |
| `AudMoviment` | Auditoria |
| `Cadastro` | **Principal** — Processos/Cadastros |
| `Moviment` | Movimentações |
| `Moviment_Sec` | Movimentações secretariais |
| `Orgaos` | Órgãos |
| `Tipodoc` | Tipos de documento |
| `Usuário` / `Usuários` | Usuários |

### Sercod_SAdm (cgdoc_sercod_SAdm.sql)

| Tabela | Descrição |
|--------|-----------|
| `_AudMoviment` | Auditoria |
| `acesso` | Log de acessos |
| `Cadastro` | **Principal** — Processos para tramitação |
| `Moviment` | Movimentações |
| `moviment_sec` | Movimentações secretariais |
| `Orgaos` | Órgãos |
| `Tipodoc` | Tipos de documento |
| `Usuários` | Usuários |

---

## Entidades Principais

### Cadastro (todas as bases)

| Campo | Tipo | Observação |
|-------|------|-------------|
| ID | INTEGER AUTO_INCREMENT | PK |
| NrProtoc | VARCHAR(50) | **Índice principal** ⚠️ |
| N_Processo | VARCHAR(50) | Número do processo |
| Nome | VARCHAR(255) | Nome/interessado |
| Data | DATETIME | Data de cadastro |
| Descricao | LONGTEXT | Descrição |
| ... | ... | (outros campos) |

### Moviment (todas as bases)

| Campo | Tipo | Observação |
|-------|------|-------------|
| ID | INTEGER AUTO_INCREMENT | PK |
| NrProtoc | VARCHAR(50) | FK para Cadastro.NrProtoc |
| Data_Movto | DATETIME | Data movimentação |
| Tipo | VARCHAR(50) | Tipo (entrada/saída) |
| Origem | VARCHAR(255) | Local origem |
| Destino | VARCHAR(255) | Local destino |
| Obs | LONGTEXT | Observação |

### Usuários

| Campo | Tipo | Observação |
|-------|------|-------------|
| Código | INTEGER AUTO_INCREMENT | PK |
| NrUsuário | VARCHAR(7) | Login |
| Senha | VARCHAR(255) | Senha (atualmente texto) |
| Privilegio | VARCHAR(50) | Nível (Admin/User/Guest) |

---

## NrProtoc — Regra de Arquitetura

⚠️ **IMPORTANTÍSSIMO:** O campo `NrProtoc` é o índice principal que identifica processos em todas as 3 bases.

### Problema Identificado
- Sem prefixo, unificação futura causará colisão de IDs
- Ex: Processo #1 existe em SAdm E em Sercod

### Solução (da arquitetura)
- **SAdm:** prefixo `sadm-0000001`
- **Sercod:** prefixo `sercod-0000001`
- **Sercod_SAdm:** prefixo `sercod_sadm-0000001`

### Implementação em Go
```go
func GenerateNrProtoc(prefix string) string {
    // prefix: "sadm", "sercod", "sercod_sadm"
    return fmt.Sprintf("%s-%07d", prefix, nextSequence)
}
```

---

## Relacionamentos

```
Cadastro (1) ──────< (N) Moviment
     │
     └─────────────< (N) _AudMoviment

Usuários (1) ─────< (N) acesso
     │
     └────────────< (N) Moviment (CreatedBy)
```

---

## Regras de Negócio no Banco

| Regra | Tabela | Descrição |
|-------|--------|-----------|
| ID auto-increment | Todas | Chave primária automática |
| NrProtoc único | Cadastro | Cada processo tem número único |
| Timestamp automático | _AudMoviment | DataAlteracao com DEFAULT CURRENT_TIMESTAMP |
| FK implícita | Moviment | NrProtoc referencia Cadastro.NrProtoc |

---

## Campos com Acento (Encoding)

Os arquivos .sql mostram encoding UTF8. Algumas observações:
- `Usuários` → `Usu�rios` (encoding no dump)
- `Cadastro` → mantém acentos
- `NrProtoc` → formato correto

**Recomendação:** Ao importar para MariaDB, verificar charset = utf8mb4

---

## Resumo

| Métrica | Valor |
|---------|-------|
| Bancos | 3 |
| Tabelas por banco | ~10 |
| Total de tabelas | ~30 |
| Entidade principal | Cadastro |
| Índice principal | NrProtoc (com prefixo) |

---

## Próximos Passos

1. ✅ Schema identificado
2. ⏳ Criar banco MariaDB com prefixos NrProtoc
3. ⏳ Implementar generator Go com prefixos
4. ⏳ Validar integridade referencial entre bases