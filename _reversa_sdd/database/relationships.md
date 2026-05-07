# Relacionamentos — Banco de Dados CGDoc

## Visão Geral

O sistema CGDoc utiliza 3 bancos de dados MariaDB que se comunicam para suportar tramitação entre módulos.

---

## Bancos e Suas Funções

| Banco | Função | Tabelas Principais |
|-------|--------|-------------------|
| SAdm | Gestão de processos administrativos | Cadastro, Moviment, Usuários |
| Sercod | Codificação de processos | Cadastro, Moviment, Usuários |
| Sercod_SAdm | Ponte para tramitação | Cadastro (comum), Moviment |

---

## Relacionamentos por Banco

### SAdm

```
Usuários (1) ──────< (N) Acesso
      │
      └────────────< (N) Moviment (CreatedBy)
            │
            └───────────────< (1) Cadastro (NrProtoc)

Cadastro (1) ──────< (N) Moviment
      │
      └───────────────< (N) _AudMoviment
```

### Sercod

Estrutura idêntica ao SAdm (mesmo schema).

### Sercod_SAdm

```
Usuários ────────< Moviment ───────< Cadastro
                        │
                        └───────────────< _AudMoviment
```

---

## Integridade Referencial

### NrProtoc como Chave de Negócio

O `NrProtoc` é a chave de negocio que permite tramitação entre bancos:

| Banco | NrProtoc Exemplo | Prefixo |
|-------|------------------|---------|
| SAdm | sadm-0000001 | `sadm-` |
| Sercod | sercod-0000001 | `sercod-` |
| Sercod_SAdm | sercod_sadm-0000001 | `sercod_sadm-` |

### Consulta Unificada

```sql
-- Listar todos os processos incluindo os tramitados
SELECT * FROM (
    SELECT NrProtoc, Nome, 'SAdm' as Origem FROM movedb_SAdm.Cadastro
    UNION ALL
    SELECT NrProtoc, Nome, 'Sercod' as Origem FROM movedb_Sercod.Cadastro
    UNION ALL
    SELECT NrProtoc, Nome, 'Sercod_SAdm' as Origem FROM movedb_Sercod_SAdm.Cadastro
) as processos
WHERE NrProtoc = 'sadm-0000001';
```

---

## Regras de Integridade

| Regra | Implementação |
|-------|---------------|
| NrProtoc único por banco | UNIQUE KEY em NrProtoc |
| FK implícita via NrProtoc | Aplicativo gerencia (sem FK física) |
| Auditoria | Tabela _AudMoviment com trigger |
| Cascade delete | Não configurado (aplicativo gerencia) |

---

## Observações Técnicas

1. **Sem FK física:** O Access não tinha Foreign Keys. O MariaDB mantém integridade via aplicação.

2. **Prefixos essenciais:** O prefixo permite distinguir processos de diferentes módulos mesmo com o mesmo ID.

3. **Auditoria automática:** Tabela `_AudMoviment` registra alterações com timestamp.