# Sercod — Decisões de Design

> Decisões arquiteturais identificadas no módulo Sercod.

## Decisões de Arquitetura

| Decisão | Alternativas | Justificativa |
|---------|--------------|---------------|
| Clone do SAdm | Módulo independente | Reutilização de código |
| Mesmo banco de dados | Banco separado | Compartilhamento de dados |
| Mesma autenticação | Autenticação separada | Consistência |

## Incertezas e Questões Abertas

| Item | Status | Ação Necessária |
|------|--------|-----------------|
| Diferenciação funcional | 🔴 | Requer análise do banco |
| Entidades específicas | 🔴 | Acessar .mdb |
| Fluxo de codificação | 🔴 | Não mapeado |

## Observações

- Este módulo precisa de análise adicional para identificar funcionalidades específicas de codificação
- Pode ser um código duplicado desnecessário (refatorar para único módulo com permissões)
- Ver `SAdm/decisions.md` para decisões base