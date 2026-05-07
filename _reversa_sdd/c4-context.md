# C4 - Contexto

> Diagrama C4 Nível 1: Contexto do Sistema

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

## Legenda

| Elemento | Significado |
|----------|-------------|
| Person | Usuário do sistema |
| System | Aplicação CGDoc |
| SystemDb | Banco de dados |
| Rel | Relacionamento com protocolo |

## Descrição

- **Funcionários** acessam o sistema via HTTP para gerenciar processos
- **Administradores** têm acesso irrestrito (bypass de permissões)
- **SAdm** e **Sercod** compartilham o mesmo banco de dados Access
- Comunicação interna via ADO/OLE DB