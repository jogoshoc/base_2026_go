# Parity Specs — Projeto CGDoc

> Gerado pelo Reversa Inspector em 2026-05-07

## Estratégia de Validação

### Modos de Validação Selecionados

| Modo | Aplicável | Justificativa |
|------|-----------|---------------|
| **Shadow Mode** | ✅ | Parallel Run: Go e legado processando mesmas requisições simultaneamente |
| **Characterization Tests** | ✅ | Validar que fluxos do legado são reproduzidos no Go |
| **Contract Tests** | ✅ | APIs HTTP com mesma interface (URL, params, response) |
| **Data Parity** | ✅ | Comparar dados em MariaDB com backup do Access |

### Critério de Paridade Aceita

**Métrica primária:** Índice de divergência funcional < 0,5% em 30 dias

**Definição:** Divergência = (requisições com output diferente / total requisições) × 100

**Janela de observação:** 30 dias durante Parallel Run

**Critério de bloqueio do cutover:**
- Divergência < 0,5% por 7 dias consecutivos
- Zero bloqueios de usuário (500 errors)
- Dados sincronizados (checksum batch validates)

---

## Cobertura Adaptada ao Paradigma

### Transição: OO clássico → CSP/Go (similar ao legado)

| Dimensão | Status | Detalhe |
|----------|--------|----------|
| Equivalência funcional | ✅ Padrão | Mesma entrada → mesma saída |
| Sessão stateful | ✅ Requerido | 20min timeout, session ID persistente |
| Templates | ✅ Requerido | Go templates com sintaxe similar Smarty |
| Database queries | ✅ Requerido | Queries SQL idênticas (paridade dados) |

---

## Fluxos Críticos para Validação

### Identificados

| Fluxo | Arquivo .feature | Tags |
|-------|-----------------|------|
| Login | 01-login.feature | @paridade, @critico |
| Logout | 02-logout.feature | @paridade |
| Listar Cadastros | 03-list-cadastros.feature | @paridade, @critico |
| Busca Avançada | 04-busca.feature | @paridade |
| Criar Cadastro | 05-create-cadastro.feature | @paridade, @critico |
| Editar Cadastro | 06-edit-cadastro.feature | @paridade |
| Excluir Cadastro | 07-delete-cadastro.feature | @paridade |
| Tramitar Processo | 08-tramitar.feature | @paridade, @critico |
| Registrar Movimentação | 09-moviment.feature | @paridade |
| Exportar Dados | 10-export.feature | @paridade |
| Imprimir Relatório | 11-print.feature | @paridade |

---

## Critérios Específicos por Paradigma

### CSP/Go (similar ao legado)

- Sessão persiste entre requisições (mesmo comportamento ASP)
- Templates renderizam HTML idêntico
- Queries SQL retornam mesma estrutura de dados

---

## Rastreabilidade

| Spec | Origem | Alvo |
|------|--------|------|
| Login | code-analysis.md | target_architecture.md |
| CRUD Cadastro | domain.md | target_domain_model.md |
| Tramitação | domain.md | target_domain_model.md |
| NrProtoc | paradigm_decision.md | data_migration_plan.md |

---

## Parallel Run: Especificações

### Configuração

- Legado: ASP em porta 80 (original)
- Go: Go em porta 8081 (sadm) / 8082 (sercod)

### Comparação Online

1. Proxy ou load balancer distribui requisições para ambos
2. Go registra todas as requisições com timestamp
3. Comparação assíncrona após resposta

### Campos de Divergência Aceitável

| Campo | Tolerância |
|-------|------------|
| Tempo de resposta | < 500ms |
| HTML renderizado | whitespace difference allowed |
| Session ID | diferente (gerado por Go) |
| Timestamp | < 1s difference |

---

## Nota

Specs em arquivos `.feature` são especificações, não testes executáveis.
Traduzir para framework de teste chosen (Ginkgo, testify, etc.) durante implementação.