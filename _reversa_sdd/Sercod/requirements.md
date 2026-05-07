# Sercod — Secretaria de Códigos

> Módulo de codificação e numeração de processos.

## Visão Geral
Módulo clone do SAdm focado em codificação e numeração de processos.
Compartilha estrutura e funcionalidades com SAdm, com adaptações específicas para numeração.

**Observação:** Estrutura idêntica ao SAdm (padrão de arquivos clone).

## Responsabilidades
- Autenticação e controle de sessão (compartilhado com SAdm)
- CRUD de cadastros específicos de codificação
- Controle de numeração de processos
- Busca e consulta de processos codificados

## Regras de Negócio

| ID | Regra | Confiança |
|----|-------|-----------|
| RB-01 | Usuário deve estar autenticado para qualquer operação | 🟢 |
| RB-02 | Usa mesmo sistema de autenticação do SAdm | 🟢 |
| RB-03 | Verificação de permissão via CheckSecurity(ownerId, operacao) | 🟢 |
| RB-04 | Busca avançada com múltiplos critérios | 🟢 |

> Regras idênticas ao SAdm — ver `SAdm/requirements.md` para detalhes.

## Requisitos Funcionais

| ID | Requisito | Prioridade | Critério de Aceite |
|----|-----------|-----------|-------------------|
| RF-01 | Login com usuário e senha | Must | Redireciona para menu se válido |
| RF-02 | Logout com destruição de sessão | Must | Session.Abandon, redireciona |
| RF-03 | Listar cadastros com paginação | Must | Exibe registros com navegação |
| RF-04 | Busca por qualquer campo | Must | Filtro funciona para todos os campos |
| RF-05 | Busca avançada com múltiplos critérios | Must | Suporta AND/OR entre critérios |
| RF-06 | Adicionar novo registro | Must | Insere no banco |
| RF-07 | Editar registro existente | Must | Atualiza registro |
| RF-08 | Excluir registro | Must | Remove registro |

## Requisitos Não Funcionais

| Tipo | Requisito inferido | Evidência no código | Confiança |
|------|--------------------|---------------------|-----------|
| Segurança | Autemtação obrigatória | Same as SAdm | 🟢 |
| Segurança | Autorização via RBAC | Same as SAdm | 🟢 |

> Ver `SAdm/requirements.md` para detalhes completos.

## Critérios de Aceitação

```gherkin
Dado usuário logado com credenciais válidas
Quando acessa página de listagem
Then exibe lista de registros com paginação

Dado usuário logado com credenciais válidas
Quando submete busca avançada
Then retorna registros que satisfazem critérios
```

## Prioridade (MoSCoW)

| Requisito | MoSCoW | Justificativa |
|-----------|--------|---------------|
| Login e autenticação | Must | Caminho crítico |
| Listagem e busca | Must | Funcionalidade principal |
| CRUD Cadastro | Must | Core business |

## Rastreabilidade de Código

| Arquivo | Função / Classe | Cobertura |
|---------|-----------------|-----------|
| `cgdoc/Sercod/login.asp` | Autenticação | 🟢 |
| `cgdoc/Sercod/Cadastro_list.asp` | Listagem | 🟢 |
| `cgdoc/Sercod/include/dbcommon.asp` | Conexão DB | 🟢 |
| `cgdoc/Sercod/include/aspfunctions.asp` | CheckSecurity | 🟢 |

## Observações

- 🔴 Este módulo é um clone do SAdm — spec completa em `SAdm/`
- 🟡 Funcionalidades específicas de codificação não mapeadas
- 🟢 Estrutura de arquivos idêntica ao SAdm