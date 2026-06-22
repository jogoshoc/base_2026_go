---
name: readme-updater
description: Verifica e atualiza o arquivo README.md do projeto CGDoc na raiz. Deve ser executado sempre que houver mudanças significativas no projeto (novos commits, novas funcionalidades, mudanças de status, erros resolvidos, etc.). Use quando o usuário disser "atualiza readme", "readme", "update readme" ou após concluir tarefas marcadas no TODO.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, OpenCode e demais agentes compatíveis com Agent Skills.
metadata:
  author: morpheus
  version: "1.0.0"
  framework: cgdoc
  role: maintenance
---

# README Updater — CGDoc

Você é o Readme Updater do projeto CGDoc. Sua função é **verificar e atualizar** o `README.md` na raiz do projeto sempre que houver mudanças.

## Gatilhos de Ativação

Execute este skill quando:
1. O usuário disser "atualiza o readme" ou "update readme"
2. Após concluir tarefas registradas no TODO
3. Após commits no Git
4. Quando novas funcionalidades forem implementadas
5. Quando erros forem resolvidos ou novos surgirem
6. Quando o status do projeto mudar

## Procedimento

### Fase 1: Coleta de Informações

Execute em paralelo para obter o estado atual:

```bash
# Estado do Git
git log --oneline -10
git status --porcelain
git diff --stat

# Estado dos builds
go vet ./...
go test ./internal/application/... -v 2>&1 | tail -5

# Listar arquivos novos/modificados
git diff --name-status HEAD~3..HEAD
```

### Fase 2: Verificação de Consistência

Compare o README.md atual com o estado real do projeto:

| Seção do README | Verificar |
|-----------------|-----------|
| Status do projeto | Última atualização, número de commits, tarefas concluídas |
| Funcionalidades implementadas | Commits recentes adicionaram/removeram features? |
| Erros atuais e soluções | Bugs foram resolvidos? Novos bugs identificados? |
| Arquivos modificados recentemente | Novos arquivos foram criados? |
| Próximos passos imediatos | Itens foram concluídos? Novos itens surgiram? |
| Checkpoint: Onde paramos | Novo checkpoint criado? |

### Fase 3: Atualização

Para cada seção desatualizada:

1. **Status do projeto**: Atualizar data, versão, contagem de tarefas
2. **Funcionalidades implementadas**: Adicionar novas features com ✅
3. **Funcionalidades a implementar**: Mover de pendente para implementado, adicionar novas pendências
4. **Erros atuais e soluções**: Mover resolvidos para "✅ Resolvido", adicionar novos
5. **Arquivos modificados recentemente**: Adicionar commits novos, remover antigos se necessário
6. **Próximos passos**: Marcar concluídos como [x], adicionar novos
7. **Checkpoint**: Atualizar data e descrição do último checkpoint

### Fase 4: Verificação Pós-Atualização

```bash
# Confirmar que o README está coerente
git diff README.md --stat

# Se houver mudanças significativas, recomendar commit:
# git add README.md
# git commit -m "docs: atualiza README.md com status [descricao]"
```

## Regras Importantes

1. **Nunca remova** seções existentes do README sem necessidade comprovada
2. **Nunca adicione** informações não verificadas — sempre confirme no código/git
3. **Atualize a data** no cabeçalho do README para a data atual
4. **Use emojis consistentemente** (✅ concluído, ❌ pendente, 🟡 em progresso, 🔴 bloqueado)
5. **Commits novos** devem aparecer na seção "Arquivos Modificados Recentemente"
6. **A seção de checkpoint** deve ser atualizada ao final de cada sessão de trabalho
7. **Links para imagens** em `images/` devem usar caminhos relativos

## Exemplo de Atualização

Quando um novo commit adiciona uma funcionalidade:

```
ANTES:
| Login (bcrypt) | ✅ | ✅ | ✅ |

DEPOIS:
| Login (bcrypt) | ✅ | ✅ | ✅ |
| Troca de senha | ✅ | ✅ | — |
```

Quando um erro é resolvido:

```
ANTES:
| E-05 | Campo `senha` ausente | 🔴 Aberto |

DEPOIS:
| E-05 | Campo `senha` ausente | ✅ | Commit daa7a73 |
```
