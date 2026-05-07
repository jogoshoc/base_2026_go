# Arquitetura — Projeto CGDoc

> Gerado pelo Reversa Architect em 2026-05-06
> Nível de Documentação: Completo

## Visão Geral do Sistema

Sistema web legado para gestão de processos e protocolos governamentais.
Duas secretarias: **SAdm** (Administrativa) e **Sercod** (Códigos).

### Stack Tecnológico

| Componente | Tecnologia |
|------------|------------|
| Frontend | ASP Clássico + Smarty Templates |
| Backend | ASP/VBScript (IIS) |
| Banco de Dados | Microsoft Access (.mdb) |
| Servidor Web | IIS (Windows) |

---

## Diagrama C4 — Contexto

```mermaid
C4Context
    title Diagrama de Contexto - CGDoc

    Person(funcionario, "Funcionário", "Usuário interno que manipula processos")
    Person(admin, "Administrador", "Gestor com acesso total ao sistema")

    System_Boundary(cgdoc, "Sistema CGDoc") {
        System(sadm, "SAdm", "Secretaria Administrativa - Gestão de processos")
        System(sercod, "Sercod", "Secretaria de Códigos - Numeração")
    }

    SystemDb(access, "SisprotWeb.mdb", "Banco de dados Access")

    Rel(funcionario, sadm, "Acessa", "HTTP")
    Rel(funcionario, sercod, "Acessa", "HTTP")
    Rel(admin, sadm, "Acessa (admin)", "HTTP")
    Rel(admin, sercod, "Acessa (admin)", "HTTP")
    Rel(sadm, access, "Lê/Escreve", "ADO")
    Rel(sercod, access, "Lê/Escreve", "ADO")
```

---

## Diagrama C4 — Containers

```mermaid
C4Container
    title Diagrama de Containers - CGDoc

    Container(spa_sadm, "Aplicação SAdm", "ASP/VBScript", "Secretaria Administrativa")
    Container(spa_sercod, "Aplicação Sercod", "ASP/VBScript", "Secretaria de Códigos")
    Container(smarty, "Template Engine", "Smarty", "Renderização de views")
    ContainerDb(access, "Banco de Dados", "Access", "SisprotWeb.mdb")

    Rel(spa_sadm, smarty, "Renderiza templates")
    Rel(spa_sercod, smarty, "Renderiza templates")
    Rel(spa_sadm, access, "Queries via ADO", "OLE DB")
    Rel(spa_sercod, access, "Queries via ADO", "OLE DB")
```

---

## Diagrama C4 — Componentes (SAdm)

```mermaid
C4Component
    title Diagrama de Componentes - Módulo SAdm

    ContainerDb(access, "Banco de Dados", "Access", "SisprotWeb.mdb")

    Component(auth, "Módulo Auth", "login.asp", "Autenticação de usuários")
    Component(security, "Segurança", "CheckSecurity()", "Controle de acesso RBAC")
    Component(crud_cadastro, "CRUD Cadastro", "Cadastro_*.asp", "Gestão de processos")
    Component(crud_tramitacao, "CRUD Tramitação", "Tramitacao_*.asp", "Tramitação")
    Component(crud_moviment, "CRUD Movimentação", "Moviment_*.asp", "Movimentações")
    Component(search, "Busca Avançada", "*_search.asp", "Filtros com AND/OR")
    Component(template, "Smarty", "libs/smarty.asp", "Template engine")

    Rel(auth, access, "Valida credenciais")
    Rel(security, access, "Verifica permissões")
    Rel(crud_cadastro, access, "CRUD operações")
    Rel(crud_tramitacao, access, "CRUD operações")
    Rel(crud_moviment, access, "CRUD operações")
    Rel(search, access, "Consulta filtros")
    Rel(crud_cadastro, template, "Renderiza")
    Rel(crud_tramitacao, template, "Renderiza")
    Rel(crud_moviment, template, "Renderiza")
```

---

## Entidades e Relacionamentos

| Entidade | Descrição |
|----------|-----------|
| **Usuários** | Autenticação e controle de acesso |
| **Cadastro** | Processos principais |
| **Tramitação** | Encaminhamentos entre departamentos |
| **Movimentação** | Histórico de ações em processos |
| **_AudMoviment** | Auditoria de movimentações |

### Relacionamentos Inferidos

```
Usuários 1:N Cadastro
Usuários 1:N Tramitação
Usuários 1:N Movimentação
Cadastro 1:N Tramitação
Cadastro 1:N Movimentação
```

---

## Integrações Externas

| Sistema | Tipo | Protocolo | Descrição |
|---------|------|-----------|------------|
| **SisprotWeb.mdb** | Banco de dados | OLE DB/ADO | Acesso via driver Access |

> Não há APIs REST, serviços externos ou webhooks. Sistema isolado.

---

## Dívidas Técnicas

| Item | Severidade | Descrição |
|------|------------|-----------|
| **ASP Clássico** | Alta | Tecnologia obsoleta, difícil manutenção |
| **Access como DB** | Alta | Não escala, problemas de concorrência |
| **Código duplicado** | Média | ~100 arquivos por módulo seguem mesmo padrão |
| **Sem testes** | Alta | Ausência completa de testes automatizados |
| **Sem versionamento** | Média | Não há histórico Git disponível |
| **Senha em texto** | Crítica | Segurança de credenciais desconhecida |

---

## Confiança

| Símbolo | Significado |
|---------|-------------|
| 🟢 CONFIRMADO | Extraído diretamente do código |
| 🟡 INFERIDO | Baseado em padrões e nomes |
| 🔴 LACUNA | Informação não disponível |