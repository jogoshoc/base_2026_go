# Ambiguity Log — Reversa Migration

> Gerado pelo Curator em 2026-05-06

## Itens Pendentes (requerem decisão humana)

| ID | Item | Status | Decisão |
|----|------|--------|---------|
| BR-HUMANA-001 | Tempo de expiração de sessão | **RESOLVIDO** | 30 minutos |
| BR-HUMANA-002 | Hash de senhas | **RESOLVIDO** | BCrypt |
| BR-HUMANA-003 | Schema exato do banco | **RESOLVIDO** | Usar arquivos .sql |
| BR-HUMANA-004 | Diferenciação SAdm vs Sercod | **RESOLVIDO** | São módulos diferentes |

## Itens Resolvidos com Decisão Humana

| ID | Decisão | Justificativa |
|----|---------|---------------|
| BR-HUMANA-001 | 30 minutos | Padrão para sistemas web corporativos |
| BR-HUMANA-002 | BCrypt | Segurança mandatory (legado usa texto plano) |
| BR-HUMANA-003 | Usar arquivos .sql | Schema disponível em cgdoc/*/db/*.sql |
| BR-HUMANA-004 | Módulos diferentes | SAdm = Gestão processos, Sercod = Codificação |

## Itens Referidos à Codificação

Nenhum item referido à codificação nesta sessão.

---

## Histórico

- **2026-05-06 13:20:** Curator criou log com 4 pendentes
- **2026-05-06 13:25:** Usuário respondeu todas as 4 decisões