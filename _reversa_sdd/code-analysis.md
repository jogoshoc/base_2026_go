# Análise de Código — Projeto CGDoc

> Gerado pelo Reversa Archaeologist em 2026-05-06
> Nível de Documentação: Completo

## Visão Geral

Sistema legado em ASP Clássico para gestão de processos e protocolos.
Dois módulos principais: **SAdm** (Secretaria Administrativa) e **Sercod** (Secretaria de Códigos).

## Arquitetura detecteda

### Stack
- **Linguagem:** ASP Clássico (VBScript)
- **Template Engine:** Smarty
- **Banco de Dados:** Microsoft Access (`.mdb`)
- **Autenticação:** Baseada em sessão + cookies

### Padrão de Estrutura de Arquivos

Cada entidade segue o mesmo padrão de arquivos (CRUD):
- `{Entidade}_list.asp` — Lista/Busca
- `{Entidade}_add.asp` — Inclusão
- `{Entidade}_edit.asp` — Edição
- `{Entidade}_search.asp` — Busca avançada
- `{Entidade}_print.asp` — Impressão
- `{Entidade}_imager.asp` — Visualização de imagem
- `{Entidade}_download.asp` — Download de arquivo

### Componentes Compartilhados

| Arquivo | Função |
|---------|--------|
| `include/dbcommon.asp` | Conexão e operações de banco de dados |
| `libs/smarty.asp` | Integração com motor de templates Smarty |
| `include/{Entidade}_variables.asp` | Definição de campos e metadados |

---

## Módulo: SAdm (Secretaria Administrativa)

### Propósito
Gestão de processos administrativos, cadastros, tramitações e movimentações.

### Entidades Principais

1. **Usuários** (`Usuários`)
   - Autenticação de usuários
   - Campos: Usuário, Senha, Privilégio

2. **Cadastro**
   - Cadastro geral de processos
   - Campos inferidos: N_Processo, Nome, Data

3. **Tramitação**
   - Controle de tramitação de processos
   - Campos inferidos: Protocolo, Data_Tramite, Destino

4. **Movimentação**
   - Registro de movimentações
   - Campos inferidos: Processo, Data_Movto, Tipo

### Fluxo de Autenticação

```
1. Usuário acessa login.asp
2. Credenciais submetidas via POST
3. Consulta tabela [Usuários] no banco Access
4. Se válido: cria sessão (UserID, AccessLevel, GroupID)
5. Redireciona para menu.asp
```

**Referências:** `cgdoc/SAdm/login.asp:30-98`

### Controle de Acesso

Implementado via função `CheckSecurity(Session("OwnerID"), "Operacao")`:
- Verifica se sessão está ativa
- Verifica permissão para operação (Search, Add, Edit, Delete)

**Referências:** `cgdoc/SAdm/Cadastro_list.asp:5-13`

### Busca Avançada (Filtros)

Sistema de filtros complexos com:
- Múltiplos campos de busca
- Operadores (equals, contains, starts with, etc.)
- Lógica AND/OR entre critérios
- Negação (NOT)

**Referências:** `cgdoc/SAdm/Cadastro_list.asp:63-100`

---

## Módulo: Sercod (Secretaria de Códigos)

### Propósito
Gestão de códigos e numeração de processos.
Estrutura idêntica ao SAdm (padrão clone).

### Semelhanças com SAdm
- Mesma estrutura de arquivos
- Mesma autenticação
- Mesmo banco de dados (SisprotWeb.mdb)
- Mesmas entidades

### Diferenças
- Funcionalidades específicas de codificação de processos
- Acesso diferenciado via perfil de usuário

---

## Algoritmos Não-Triviais

### Busca Avançada
Implementa lógica de filtros com múltiplos critérios e combinações (and/or).

**Localização:** `cgdoc/SAdm/Cadastro_list.asp`

### Gestão de Sessão
Controle de expiração e redirecionamento para login.

**Localização:** `cgdoc/SAdm/Cadastro_list.asp:5-9`

---

## Dicionário de Dados Resumido

| Entidade | Campos Principais | Origem |
|----------|------------------|--------|
| Usuários | Usuário, Senha, Privilégio | Tabela DB |
| Cadastro | N_Processo, Nome, Data | Inferido |
| Tramitação | Protocolo, Data_Tramite, Destino | Inferido |
| Movimentação | Processo, Data_Movto, Tipo | Inferido |

> Ver `data-dictionary.md` para versão completa.

---

## Confiança da Análise

- 🟢 **CONFIRMADO:** Extraído diretamente do código (login, estrutura de arquivos, dependências)
- 🟡 **INFERIDO:** Entidades e campos baseados em nomes de arquivos e padrões
- 🔴 **LACUNA:** Detalhes de banco de dados (requer acesso ao .mdb)
