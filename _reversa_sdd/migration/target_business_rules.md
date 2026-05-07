# Target Business Rules — Projeto CGDoc

> Gerado pelo Reversa Curator em 2026-05-06

## Regras a Migrar (BR-MIGRAR)

### Autenticação e Sessão

| ID | Regra | Origem | Confiança |
|----|-------|--------|-----------|
| BR-MIGRAR-001 | Usuário deve estar autenticado para qualquer operação | `domain.md:36-39` | 🟢 |
| BR-MIGRAR-002 | Senha pode ser lembrada por 1 ano via cookies | `domain.md:41-43` | 🟢 |
| BR-MIGRAR-003 | Usuário admin (ID 1088608) tem acesso irrestrito | `domain.md:45-48` | 🟢 |
| BR-MIGRAR-004 | Sessão expira após inatividade | `SAdm/requirements.md:55` | 🟡 |

### Controle de Acesso

| ID | Regra | Origem | Confiança |
|----|-------|--------|-----------|
| BR-MIGRAR-005 | Sistema usa modelo RBAC (Admin/User/Guest) | `domain.md:52-55` | 🟢 |
| BR-MIGRAR-006 | Verificação de permissão via CheckSecurity | `domain.md:54` | 🟢 |
| BR-MIGRAR-007 | Admin ignora verificações de owner | `domain.md:57-59` | 🟢 |

### Processos e Dados

| ID | Regra | Origem | Confiança |
|----|-------|--------|-----------|
| BR-MIGRAR-008 | NrProtoc usa prefixo único por banco (sadm-/sercod-) | `paradigm_decision.md` (regra arquitetura) | 🟢 |
| BR-MIGRAR-009 | Processo deve ter número único (N_Processo) | `domain.md:74-76` | 🟡 |
| BR-MIGRAR-010 | Tramitação registra destino obrigatório | `domain.md:78-80` | 🟡 |

### Busca e Operações

| ID | Regra | Origem | Confiança |
|----|-------|--------|-----------|
| BR-MIGRAR-011 | Busca avançada suporta múltiplos critérios AND/OR | `domain.md:67-70` | 🟢 |
| BR-MIGRAR-012 | Campos podem validar nomes de estados brasileiros | `domain.md:63-65` | 🟢 |
| BR-MIGRAR-013 | CRUD completo de Cadastro, Tramitação, Movimentação | `SAdm/requirements.md:32-46` | 🟢 |

### Requisitos Funcionais

| ID | Regra | Origem | Confiança |
|----|-------|--------|-----------|
| BR-MIGRAR-014 | Login com usuário e senha | `SAdm/requirements.md:RF-01` | 🟢 |
| BR-MIGRAR-015 | Logout com destruição de sessão | `SAdm/requirements.md:RF-02` | 🟢 |
| BR-MIGRAR-016 | Listar cadastros com paginação | `SAdm/requirements.md:RF-03` | 🟢 |
| BR-MIGRAR-017 | Busca por qualquer campo | `SAdm/requirements.md:RF-04` | 🟢 |
| BR-MIGRAR-018 | Adicionar/Editar/Excluir cadastro | `SAdm/requirements.md:RF-06-08` | 🟢 |
| BR-MIGRAR-019 | Tramitar processo para outro departamento | `SAdm/requirements.md:RF-09` | 🟢 |
| BR-MIGRAR-020 | Registrar movimentação de processo | `SAdm/requirements.md:RF-10` | 🟢 |
| BR-MIGRAR-021 | Imprimir relatório | `SAdm/requirements.md:RF-11` | 🟢 |
| BR-MIGRAR-022 | Exportar dados (Excel/CSV) | `SAdm/requirements.md:RF-12` | 🟢 |
| BR-MIGRAR-023 | Alterar senha de usuário | `SAdm/requirements.md:RF-13` | 🟡 |

---

## Regras Descartadas (BR-DESCARTAR)

### Vinculadas a Paradigma Legado

| ID | Regra | Origem | Paradigma Novo Absorve |
|----|-------|--------|------------------------|
| BR-DESCARTAR-001 | ASP Session stateful (Session object) | `architecture.md` | Go usará `sync.Map` ou cookies — mecanismo diferente, regra de negócio migra |
| BR-DESCARTAR-002 | Active Record via ADO/OLE DB | `code-analysis.md` | Go usará `database/sql` — mecanismo diferente, regra migra |
| BR-DESCARTAR-003 | Smarty templates | `architecture.md` | Go usará `html/template` — mecanismo diferente, regra migra |

> **Nota:** As regras acima são mecanismos do paradigma legado que serão reimplementados no novo paradigma. As regras de negócio (autenticação, autorização, CRUD) permanecem.

---

## Decisões Humanas (BR-HUMANA)

| ID | Regra | Recomendação | Justificativa |
|----|-------|--------------|---------------|
| BR-HUMANA-001 | Tempo exato de expiração de sessão | Definir 30min padrão | Legado não especifica; validar com ops |
| BR-HUMANA-002 | Hash de senhas (texto/BCrypt) | BCrypt mandatory | Segurança crítica; legado armazenamento inseguro |
| BR-HUMANA-003 | Schema exato do banco | Validar com arquivos .sql | Confiança ~69%; arquivos .sql disponíveis em `cgdoc/*/db/` |
| BR-HUMANA-004 | Diferenciação funcional SAdm vs Sercod | Investigar | Sercod parece clone; validar se há diferença real |

---

## Regras de Arquitetura (CópiaPerfeita)

As seguintes regras são específicas para manter CópiaPerfeita:

| ID | Regra | Implementação |
|----|-------|---------------|
| BR-ARQ-001 | Prefixo NrProtoc: `sadb-0000001` para SAdm | Generator Go gera prefixo |
| BR-ARQ-002 | Prefixo NrProtoc: `sercod-0000001` para Sercod | Generator Go gera prefixo |
| BR-ARQ-003 | Prefixo NrProtoc: `sercod_sadm-0000001` para tramitação | Generator Go gera prefixo |
| BR-ARQ-004 | Sessão stateful | Go: memória (sync.Map) ou cookie |
| BR-ARQ-005 | Template idêntico ao Smarty | Go html/template com mesma estrutura |
| BR-ARQ-006 | Schema MariaDB de 3 bancos | Usar arquivos .sql (SAdm, Sercod, Sercod_SAdm) |

---

## Schema do Banco (Data Master)

| Banco | Arquivo .sql | Tabelas | Entidade Principal |
|-------|--------------|---------|-------------------|
| SAdm | `cgdoc_SAdm.sql` | ~10 | Cadastro, Moviment, Usuários |
| Sercod | `cgdoc_sercod.sql` | ~10 | Cadastro, Moviment, Usuários |
| Sercod_SAdm | `cgdoc_sercod_SAdm.sql` | ~10 | Cadastro (tramitação) |

### Campos Principais

**Cadastro:**
- ID (PK, auto_increment)
- NrProtoc (UK, índice de negócio)
- N_Processo, Nome, Data, Descricao

**Moviment:**
- ID (PK)
- NrProtoc (FK para Cadastro)
- Data_Movto, Tipo, Origem, Destino, Obs

**Usuários:**
- Código (PK)
- NrUsuário, Senha, Privilegio

---

## Resumo

| Categoria | Quantidade |
|-----------|------------|
| MIGRAR | 23 |
| DESCARTAR | 0 (mecanismos migram) |
| DECISÃO HUMANA | 4 |
| **Total** | **27** |