# C4 - Containers

> Diagrama C4 Nível 2: Containers

```mermaid
C4Container
    title Diagrama de Containers - CGDoc

    Person(funcionario, "Funcionário", "Usuário interno")
    Person(admin, "Administrador", "Gestor")

    Container(spa_sadm, "Aplicação SAdm", "ASP/VBScript", "Secretaria Administrativa")
    Container(spa_sercod, "Aplicação Sercod", "ASP/VBScript", "Secretaria de Códigos")
    Container(smarty, "Template Engine", "Smarty", "Renderização de views")
    Container(ado, "Data Access", "ADO/OLE DB", "Camada de acesso a dados")
    ContainerDb(access, "Banco de Dados", "Access", "SisprotWeb.mdb")

    Rel(funcionario, spa_sadm, "HTTP", "Acessa")
    Rel(funcionario, spa_sercod, "HTTP", "Acessa")
    Rel(admin, spa_sadm, "HTTP", "Acessa (admin)")
    Rel(admin, spa_sercod, "HTTP", "Acessa (admin)")

    Rel(spa_sadm, smarty, "Renderiza templates")
    Rel(spa_sercod, smarty, "Renderiza templates")

    Rel(spa_sadm, ado, "Executa queries")
    Rel(spa_sercod, ado, "Executa queries")

    Rel(ado, access, "Lê/Escreve", "OLE DB")
```

## Tecnologias por Container

| Container | Tecnologia | Responsabilidade |
|-----------|------------|------------------|
| Aplicação SAdm | ASP/VBScript | Lógica de negócio - Secretaria Administrativa |
| Aplicação Sercod | ASP/VBScript | Lógica de negócio - Secretaria de Códigos |
| Template Engine | Smarty | Separação view/controller |
| Data Access | ADO/OLE DB | Abstração de banco de dados |
| Banco de Dados | Access | Persistência |

## Comunicações

| De | Para | Protocolo |
|----|------|-----------|
| Navegador | ASP | HTTP/HTTPS |
| ASP | Smarty | Chamada interna |
| ASP | ADO | COM Interface |
| ADO | Access | OLE DB Provider |