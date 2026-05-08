# Reconstruction Plan — Projeto CGDoc

> Gerado pelo Reversa Reconstructor em 2026-05-07
> Usuário: oliveira
> Stack alvo: Go + MariaDB

---

## Resumo

| Métrica | Valor |
|---------|-------|
| Units identificadas | 2 (SAdm, Sercod) |
| Confiança geral | ~69% |
| Tasks totais | 8 |

---

## Stack Alvo

| Componente | Tecnologia |
|------------|------------|
| Linguagem | Go 1.21+ |
| Router | chi |
| Database | MariaDB |
| ORM | sqlx |
| Templates | html/template |
| Session | sync.Map ou cookie |

---

## Alertas de Pré-Voo

| ID | Alerta | Severidade | Task associada |
|----|--------|------------|----------------|
| GAP-01 | Session timeout inferido (20min) | 🟡 | Task 2 |
| GAP-02 | Campos exatos de tabelas (Tramitação, Movimentação) | 🔴 | Task 1 |
| GAP-03 | Sercod é clone do SAdm — cobertura parcial | 🟡 | Task 7, 8 |

---

## Tasks

### Task 1: Schema MariaDB (Database)

**Lê:**
- `cgdoc/SAdm/db/cgdoc_SAdm.sql` (campos das tabelas)
- `_reversa_sdd/traceability/code-spec-matrix.md`

**Pronto quando:**
- DDL criado para 4 tabelas (usuarios, cadastro, tramitacao, moviment)
- Índices criados
- FKs definidas

**Ordem na árvore:** 1/8 (infraestrutura)

---

### Task 2: Entidades de Domínio (Domain)

**Lê:**
- `_reversa_sdd/domain.md`
- `_reversa_sdd/migration/target_domain_model.md`

**Pronto quando:**
- Structs Go para cada entidade
- Validações implementadas
- Session com 20min timeout

**Ordem na árvore:** 2/8 (após database)

---

### Task 3: Repositories (Infraestrutura)

**Lê:**
- `_reversa_sdd/migration/target_data_model.md`
- `_reversa_sdd/migration/target_architecture.md`

**Pronto quando:**
- Interfaces de repository definidas
- Implementações sqlx para CRUD

**Ordem na árvore:** 3/8 (após domain)

---

### Task 4: Auth Service (SAdm)

**Lê:**
- `cgdoc/SAdm/login.asp`
- `_reversa_sdd/SAdm/requirements.md`
- `_reversa_sdd/SAdm/design.md`

**Pronto quando:**
- Login/logout funcionando
- Admin ID via config (1088608)
- RBAC implementado

**Ordem na árvore:** 4/8 (folha)

---

### Task 5: Cadastro CRUD (SAdm)

**Lê:**
- `cgdoc/SAdm/Cadastro_list.asp`
- `cgdoc/SAdm/Cadastro_add.asp`
- `cgdoc/SAdm/Cadastro_edit.asp`
- `_reversa_sdd/SAdm/requirements.md`
- `_reversa_sdd/SAdm/tasks.md`

**Pronto quando:**
- List, Add, Edit, Delete funcionando
- Busca avançada implementada
- NrProtoc com prefixo sadm-

**Ordem na árvore:** 5/8 (folha)

---

### Task 6: Tramitação e Movimentação (SAdm)

**Lê:**
- `cgdoc/SAdm/Tramitacao_list.asp`
- `cgdoc/SAdm/Moviment_list.asp`
- `_reversa_sdd/SAdm/tasks.md`

**Pronto quando:**
- Tramitação com destino obrigatório
- Movimentação registrada

**Ordem na árvore:** 6/8 (folha)

---

### Task 7: Sercod (clone SAdm)

**Lê:**
- `_reversa_sdd/Sercod/requirements.md`
- `_reversa_sdd/Sercod/design.md`
- `cgdoc/Sercod/login.asp` (diff vs SAdm)

**Pronto quando:**
- Same as Task 4-6, mas com prefixo sercod-
- Adjustments para diferenciação Sercod

**Ordem na árvore:** 7/8 (após SAdm)

---

### Task 8: Integração e Tests

**Lê:**
- `_reversa_sdd/migration/parity_specs.md`
- `_reversa_sdd/migration/parity_tests/*.feature`

**Pronto quando:**
- Tests de paridade traduzidos
- Validação parallel run

**Ordem na árvore:** 8/8 (final)

---

## Status

| Task | Status |
|------|--------|
| 1. Schema MariaDB | done |
| 2. Entidades Domain | done |
| 3. Repositories | done |
| 4. Auth Service | done |
| 5. Cadastro CRUD | done |
| 6. Tramitação/Movimentação | done |
| 7. Sercod | done |
| 8. Integração/Tests | done |

---

## Como executar

1. Digite **INICIAR** para começar da Task 1
2. Digite **execute tarefa N** para executar tarefa específica
3. Após cada tarefa, digite **CONTINUAR** para próxima