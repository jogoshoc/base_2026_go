# Dicionário de Dados — Projeto CGDoc

> Gerado pelo Reversa Archaeologist em 2026-05-06

## Visão Geral

Este documento lista as entidades e campos do banco de dados do sistema CGDoc.
**Fonte primária:** Código ASP (arquivos `.asp` em `cgdoc/SAdm/` e `cgdoc/Sercod/`).

---

## Módulo: SAdm (Secretaria Administrativa)

### 1. Usuários (`Usuários`)

Tabela de autenticação e controle de acesso.

| Campo | Tipo | Obrigatório | Descrição | Confiança |
|-------|------|--------------|-----------|------------|
| Usuário | String | Sim | Login do usuário | 🟢 CONFIRMADO |
| Senha | String | Sim | Senha (armazenada em texto ou hash) | 🟢 CONFIRMADO |
| Privilégio | String | Não | Nível de acesso/permissão | 🟢 CONFIRMADO |

**Referências:** `cgdoc/SAdm/login.asp`, `cgdoc/SAdm/Usu_rios_list.asp`

---

### 2. Cadastro (`Cadastro`)

Entidade principal para cadastro de processos.

| Campo | Tipo | Obrigatório | Descrição | Confiança |
|-------|------|--------------|-----------|------------|
| N_Processo | String | Sim | Número único do processo | 🟡 INFERIDO |
| Nome | String | Sim | Nome do processo/interessado | 🟡 INFERIDO |
| Data | DateTime | Não | Data de cadastro | 🟡 INFERIDO |

**Referências:** `cgdoc/SAdm/Cadastro_list.asp`, `cgdoc/SAdm/Cadastro_add.asp`

---

### 3. Tramitação (`Tramitação`)

Controle de tramitação de processos entre departamentos.

| Campo | Tipo | Obrigatório | Descrição | Confiança |
|-------|------|--------------|-----------|------------|
| Protocolo | String | Sim | Número de protocolo | 🟡 INFERIDO |
| Data_Tramite | DateTime | Sim | Data da tramitação | 🟡 INFERIDO |
| Destino | String | Sim | Local/Departamento de destino | 🟡 INFERIDO |
| Origem | String | Não | Local/Departamento de origem | 🔴 LACUNA |

**Referências:** `cgdoc/SAdm/Tramitacao_list.asp`

---

### 4. Movimentação (`Movimentação`)

Registro de movimentações de processos.

| Campo | Tipo | Obrigatório | Descrição | Confiança |
|-------|------|--------------|-----------|------------|
| Processo | String | Sim | Referência ao processo | 🟡 INFERIDO |
| Data_Movto | DateTime | Sim | Data da movimentação | 🟡 INFERIDO |
| Tipo | String | Não | Tipo de movimentação (entrada/saída) | 🟡 INFERIDO |
| Descrição | String | Não | Descrição detalhada | 🔴 LACUNA |

**Referências:** `cgdoc/SAdm/Moviment_list.asp`, `cgdoc/SAdm/Moviment_add.asp`

---

## Módulo: Sercod (Secretaria de Códigos)

> As entidades são muito similares ao SAdm. O Sercod utiliza as mesmas tabelas ou réplicas.

### 1. Usuários

_idêntico ao SAdm_

---

## Observações

1. **Banco de Dados:** Microsoft Access (`SisprotWeb.mdb`). O acesso direto ao arquivo `.mdb` permitiria confirmar os tipos de dados e campos exactos.

2. **Nomenclatura:** Nomes de tabelas/campos no código podem conter caracteres especiais (ex: `Usuários`, `Cadastro`) devido à codificação do Access.

3. **Entidades Auditáveis:**
   - `_AudMoviment_*` — Tabelas de auditoria de movimentação

---

## Legenda de Confiança

| Símbolo | Significado |
|---------|-------------|
| 🟢 CONFIRMADO | Extraído diretamente do código fonte |
| 🟡 INFERIDO | Baseado em padrões e nomes de arquivos |
| 🔴 LACUNA | Informação não disponível no código analisado |
