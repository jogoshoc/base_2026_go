# Dependências — projeto_cgdoc

## Dependências de Runtime

| Dependência | Tipo | Versão | Observações |
|-------------|------|--------|-------------|
| IIS | Servidor Web | Moderno | Requerido para executar ASP |
| Microsoft Access | Banco de Dados | 2003+ | Backend legacy |
| VBScript | Linguagem | N/A | Interpreter nativo IIS |

## Ferramentas de Desenvolvimento (Legado)

- Microsoft FrontPage — Extensões de servidor
- ASPRunnerPro — Geração de telas (evidenciado nos SQLs)

## Migrations/Schema

- `cgdoc/Sercod/db/cgdoc_sercod.sql` — Schema Sercod
- `cgdoc/SAdm/db/cgdoc_SAdm.sql` — Schema SAdm
- `cgdoc/SAdm/db/cgdoc_sercod_SAdm.sql` — Schema cruzado

## Observações

- Sistema legacy sem gerenciador de pacotes moderno (npm, pip, etc.)
- Todas dependências são runtime do IIS/Windows
- Não há arquivo requirements.txt, package.json ou equivalente