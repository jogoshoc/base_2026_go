# Migration Brief — Projeto CGDoc

> Gerado pelo Reversa Migrate em 2026-05-06

## Objetivo da Migração

Modernizar a stack tecnológica do sistema CGDoc, substituindo o ASP Clássico e Access por Go + MariaDB, mantendo "cópia perfeita" parazero aprendizado dos usuários.

## Métricas de Sucesso

- **CópiaPerfeita** — Sistema novo idêntico ao legado em funcionalidade e interface
- **Zero aprendizado** — Usuários não percebem mudança (UI/UX idênticos)
- **Transição transparente** — Funcionamento exatamente igual ao original

## Restrições

- **CópiaPerfeita:** Interface e funcionalidade devem ser idênticas ao legado
- **Banco MariaDB:** Schemas disponíveis em arquivos .sql

## Stakeholders

- Equipe de TI interna
- Desenvolvedores externos (híbrido)

## Stack Alvo

- **Linguagem:** Go (Golang)
- **Framework:** Go standard library / Gin / Echo
- **Banco de dados:** MariaDB (schema em arquivos .sql)
- **Infraestrutura:** Cloud-ready

## Escopo

- **Incluídos:** Módulos SAdm (Secretaria Administrativa) e Sercod (Secretaria de Códigos)
- **Excluídos:** Nenhum — migração completa

---

## Notas

- Sistema legado: ASP Clássico + Access + Smarty
- Schema disponível em: `cgdoc/SAdm/db/cgdoc_SAdm.sql`, `cgdoc/Sercod/db/cgdoc_sercod.sql`
- Confiança da extração: ~69%
- Estratégia: **CópiaPerfeita** — preservar tudo, zero mudanças para o usuário