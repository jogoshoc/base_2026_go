# Discard Log — Projeto CGDoc

> Gerado pelo Reversa Curator em 2026-05-06

## Regras Descartadas

Nenhuma regra de negócio foi descartada nesta migração.

---

## Itens Vinculados a Paradigma (Mecanismos)

Os seguintes itens são **mecanismos do paradigma legado** que serão **reimplementados** no novo paradigma:

| Item Legado | Novo Paradigma (Go) | Status |
|-------------|---------------------|--------|
| ASP Session (Session object) | sync.Map ou cookie | → REIMPLEMENTAR |
| ADO/OLE DB (Active Record) | database/sql + Repository | → REIMPLEMENTAR |
| Smarty templates | html/template | → REIMPLEMENTAR |
| CheckSecurity() função | Middleware Go | → REIMPLEMENTAR |
| Cookies de autenticação | Same (ou JWT) | → REIMPLEMENTAR |

> **Importante:** Estas não são regras descartadas — são implementações técnicas que mudam de paradigma, mas as regras de negócio subjacentes (autenticação, autorização, CRUD) permanecem e são migradas.

---

## Decisões Humanas Pendentes

| ID | Regra | Status |
|----|-------|--------|
| BR-HUMANA-001 | Tempo de expiração de sessão | PENDENTE |
| BR-HUMANA-002 | Hash de senhas | PENDENTE |
| BR-HUMANA-003 | Schema exato do banco | PENDENTE |
| BR-HUMANA-004 | Diferenciação SAdm vs Sercod | PENDENTE |

---

## Ações Necessárias

1. Validar tempo de expiração de sessão com equipe de operações
2. Definir política de hash de senhas (BCrypt recomendado)
3. Consultar arquivos .sql para confirmar schema
4. Investigar diferença funcional entre SAdm e Sercod