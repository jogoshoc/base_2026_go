# Data Migration Plan — Projeto CGDoc

> Gerado pelo Reversa Designer em 2026-05-07 (Fase 2)

## Visão Geral

Este documento detalha a estratégia de migração de dados dos 3 bancos Access para 1 banco MariaDB unificado.

---

## Fontes de Dados

| Banco Legado | Arquivo .sql | Tabelas |
|--------------|--------------|---------|
| SAdm | `cgdoc_SAdm.sql` | ~10 (Cadastro, Moviment, Usuários, etc.) |
| Sercod | `cgdoc_sercod.sql` | ~10 |
| Sercod_SAdm | `cgdoc_sercod_SAdm.sql` | ~10 (tramitação) |

---

## Mapeamento Legado → Novo

### Usuários

| Campo Legado | Campo Novo | Regra de Transformação |
|--------------|------------|------------------------|
| Código | código | AUTO_INCREMENT (ignorar) |
| NúmeroDoUsuário | nr_usuário | Trim, converter para minúsculo |
| PG | pg | Manter |
| Nome | nome | Manter |
| Ramal | ramal | Manter |
| Unidade | unidade | Manter |
| Seção | seção | Manter |
| Fotografia | fotografia | Manter (NULL na maioria) |
| Senha | senha | **Texto claro** (compatibilidade inicial) |
| Privilegio | privilegio | Manter ('adm' ou 'vis') |

**Tratamento de inválidos:**
- Username vazio → rejecting record
- Senha vazio → rejecting record
- Privilegio inválido → default 'user'

### Cadastro

| Campo Legado | Campo Novo | Regra de Transformação |
|--------------|------------|------------------------|
| Controle | controle | AUTO_INCREMENT (ignorar) |
| NrProtoc | nrprotoc | Adicionar prefixo: `sadm-` ou `sercod-` |
| DtEntr | dtentr | Converter para DATETIME |
| Descr | descr | Manter |
| Emissor | emissor | Manter |
| Nome | nome | Manter |
| Assunto | assunto | Manter |
| TipoDoc | tipodoc | Manter |
| Nat | nat | Manter |
| Destino | destino | Manter |
| Obs | obs | Manter |
| Usuario | usuario | Manter |
| PastaArquiv | pastaarquiv | Manter (NULL na maioria) |
| CPF | cpf | Manter |
| MASP | masp | Manter |

**Tratamento de inválidos:**
- NrProtoc duplicado → reject ou renumerar
- DtEntr futura → usar NOW()
- Campos obrigatórios vazios → reject

### Tramitação

| Campo Legado | Campo Novo | Regra de Transformação |
|--------------|------------|------------------------|
| CodMov | codmov | Manter (pode ter prefixo) |
| NrProtoc | nrprotoc | Adicionar prefixo `sercod_sadm-` |
| DtMovim | dtmovim | Converter para DATETIME |
| OrigNome | orignome | Manter |
| DestNome | destnome | Manter |
| Obs | obs | Manter |
| Prazo | prazo | Manter |
| Emissor | emissor | Manter |
| Assunto | assunto | Manter |
| TipoDoc | tipodoc | Manter |
| Descr | descr | Manter |
| Nome | nome | Manter |
| DtEntr | dtentr | Converter para DATETIME |

**Tratamento de inválidos:**
- NrProtoc não existe em Cadastro → reject ou criar skeleton
- DestNome vazio → reject

### Moviment

| Campo Legado | Campo Novo | Regra de Transformação |
|--------------|------------|------------------------|
| CodMov | codmov | Manter |
| NrProtoc | nrprotoc | Manter prefixo |
| DtMovim | dtmovim | Converter para DATETIME |
| OrigNome | orignome | Manter |
| DestNome | destnome | Manter |
| Obs | obs | Manter |
| Prazo | prazo | Manter |
| UsuaMov | usua_mov | Renomear |
| Cumprido | cumprido | Manter |

**Tratamento de inválidos:**
- NrProtoc não existe → reject

---

## Estratégia de ETL

### Ferramenta

**Recomendada:** Scripts Go com `database/sql` ou Python com `pandas`.

**Justificativa:**
- Paridade de schema (mesmos tipos de dados)
- Logging detalhado para troubleshooting
- Reutilização do código do projeto

### Fluxo

```
1. export_access.py
   └── Lê arquivos .sql exportados do Access
   └── Valida estrutura
   └── Normaliza dados

2. import_maria.py
   └── Conecta MariaDB
   └── Cria schema (CREATE TABLE)
   └── Importa dados em batches (1000-5000 por transação)
   └── Valida contagens

3. verify.py
   └── Verifica integridade referencial
   └── Verifica contagens
   └── Checksum aleatório
```

### Idempotência

- Scripts devem ser reexecutáveis
- Usar `INSERT IGNORE` ou `ON DUPLICATE KEY UPDATE`
- Log de registros ignorados

### Throughput Estimado

- ~50.000 registros totais (estimativa)
- Tempo estimado: 30s - 2min

---

## Backfill e Delta

### Backfill (histórico)

1. **Exportar** todos os dados dos 3 bancos .sql
2. **Transformar** (prefixos, conversões)
3. **Importar** para MariaDB unificado
4. **Verificar** contagens

### Delta (novos dados durante parallel run)

Durante o parallel run, novos dados são criados tanto no legado quanto no Go.

**Estratégia:** Nenhuma (Parallel Run é leitura-only inicial)

- Fase 1: Go é apenas leitura (lê do banco importado)
- Usuário continua usando legado para escrita
- Após validação de paridade → cutover

---

## Cutover de Dados

### Sequência

1. **Backup** MariaDB antes do cutover
2. **Parar** escrita no legado
3. **Exportar** delta desde último import (se houver)
4. **Importar** delta no Go
5. **Validar** contagens
6. **Ativar** Go para escrita
7. **Desativar** legado

### Verificação Pós-Corte

| Verificação | Query |
|-------------|-------|
| Contagem cadastros | `SELECT COUNT(*) FROM cadastro` |
| Contagem tramitações | `SELECT COUNT(*) FROM tramitacao` |
| Contagem movimentações | `SELECT COUNT(*) FROM moviment` |
| Usuários admin | `SELECT * FROM usuarios WHERE privilegio = 'adm'` |
| FK integrity | `SELECT nrprotoc FROM tramitacao WHERE nrprotoc NOT IN (SELECT nrprotoc FROM cadastro)` |

---

## Validação de Qualidade

### Contagens

| Tabela | Esperado (legado) | Validar |
|--------|------------------|---------|
| usuarios | ~20 | ✅ |
| cadastro | ~40.000 | ✅ |
| tramitacao | ~10.000 | ✅ |
| moviment | ~30.000 | ✅ |

### Checksums

- Gerar MD5/SHA256 de exportações
- Comparar com import

### Integridade Referencial

- Verificar FKs após import
- Listar órfãos

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| NrProtoc duplicado | Validar prefixos antes de import |
| Dados inválidos | Log detalhado, reject com justificativa |
| Performance | Batch inserts, índices após import |
| Perda de dados | Backup antes de cutover, roll-forward plan |