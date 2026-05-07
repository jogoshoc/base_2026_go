# Domínio — Projeto CGDoc

> Gerado pelo Reversa Detective em 2026-05-06
> Nível de Documentação: Completo

## Glossário de Entidades

| Termo | Definição | Confiança |
|-------|-----------|------------|
| **Processo** | Documento oficial protocolado no sistema | 🟡 INFERIDO |
| **Protocolo** | Número único de registro de entrada | 🟢 CONFIRMADO |
| **Tramitação** | Ato de encaminhamento de processo entre departamentos | 🟢 CONFIRMADO |
| **Movimentação** | Registro de qualquer ação sobre um processo | 🟡 INFERIDO |
| **Usuário** | Pessoa com acesso ao sistema | 🟢 CONFIRMADO |
| **Cadastro** | Registro principal de processos | 🟡 INFERIDO |

---

## Glossário de Operações

| Operação | Descrição |
|----------|------------|
| **Search** | Buscar/listar registros |
| **Add** | Adicionar novo registro |
| **Edit** | Editar registro existente |
| **Delete** | Excluir registro |
| **Export** | Exportar dados |
| **Print** | Imprimir relatório |

---

## Regras de Negócio Identificadas

### Autenticação e Sessão

1. **RB-01:** Usuário deve estar autenticado para acessar qualquer funcionalidade
   - Verifica `Session("UserID")` em todas as páginas
   - Redirect para `login.asp?message=expired` se sessão expirar
   - 🟢 CONFIRMADO

2. **RB-02:** Senha pode ser "lembrada" por 1 ano via cookies
   - `Response.Cookies("password").Expires = DateAdd("yyyy", 1, Now())`
   - 🟢 CONFIRMADO

3. **RB-03:** Usuário admin é identificado por ID específico
   - `cAdminUserID = "1088608"`
   - Concede `ACCESS_LEVEL_ADMIN`
   - 🟢 CONFIRMADO

### Controle de Acesso (RBAC)

4. **RB-04:** Sistema usa modelo RBAC simples
   - Níveis: `ACCESS_LEVEL_ADMIN`, `ACCESS_LEVEL_USER`, `ACCESS_LEVEL_GUEST`
   - Verificação via `CheckSecurity(Session("OwnerID"), "Operacao")`
   - 🟢 CONFIRMADO

5. **RB-05:** Permissão de admin ignora verificações de owner
   - Se `Session("AccessLevel") = ACCESS_LEVEL_ADMIN`, `CheckSecurity` retorna `True` imediatamente
   - 🟢 CONFIRMADO

### Validação de Dados

6. **RB-06:** Campos podem requerer nomes de estados brasileiros
   - Validação JavaScript: "Os seguintes campos precisam ser nomes de Estados"
   - 🟢 CONFIRMADO

7. **RB-07:** Busca avançada suporta múltiplos critérios com lógica AND/OR
   - Campos: asearchfield, asearchopt, asearchfor, asearchnot
   - Suporta operador "Empty" para busca por valores nulos
   - 🟢 CONFIRMADO

### Processos

8. **RB-08:** Processo deve ter número único (N_Processo)
   - Campo obrigatório inferido da estrutura
   - 🟡 INFERIDO

9. **RB-09:** Tramitação registra destino obrigatório
   - Campo `Destino` é obrigatório na entidade Tramitação
   - 🟡 INFERIDO

---

## Regras de Validação

| Regra | Descrição | Localização |
|-------|-----------|-------------|
| V01 | Sessão ativa obrigatória | `*_list.asp:5-9` |
| V02 | Verificação de permissão por operação | `*_list.asp:10-13` |
| V03 | Busca com múltiplos critérios | `*_list.asp:63-100` |
| V04 | Campos de estado devem ser nomes válidos | `*_add.asp`, `*_edit.asp` |

---

## Observações

- **Sem Git:** Histórico não disponível para考古ologia de commits
- **Lacunas:** Regras de transição de status não encontradas (sistema não tem máquina de estados formal)
- **Banco:** Acesso ao arquivo `.mdb` permitiria confirmar cardinalidades e constraints

---

## Confiança

| Símbolo | Significado |
|---------|-------------|
| 🟢 CONFIRMADO | Extraído diretamente do código |
| 🟡 INFERIDO | Baseado em padrões e nomes |
| 🔴 LACUNA | Informação não disponível |