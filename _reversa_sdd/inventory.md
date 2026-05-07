# Inventário do Projeto — projeto_cgdoc

## Estrutura de Pastas

```
projeto_cgdoc/
├── .agents/              # Configurações do Reversa
├── .claude/              # Configurações do Claude
├── .github/              # Configurações GitHub
├── .reversa/             # Estado e contexto do Reversa
├── cgdoc/                # Código principal da aplicação
│   ├── SAdm/             # Módulo Administração
│   ├── Sercod/           # Módulo Secretária de Códigos
│   └── db/               # Bancos de dados Access
├── images/               # Imagens estáticas
├── index_arquivos/       # Arquivos de índice
├── _private/             # Arquivos privados
└── _vti_*                # Metadata SharePoint/FrontPage
```

## Tecnologias Identificadas

| Categoria | Tecnologia | Versão/Detalhes |
|-----------|------------|-----------------|
| **Linguagem** | ASP Clássico | 882 arquivos .asp |
| **Banco de Dados** | Microsoft Access | 3 arquivos .mdb |
| **Servidor** | IIS/SharePoint | Extensões FrontPage |
| **Scripts** | VBScript | Linguagem server-side |

## Módulos Identificados

### 1. SAdm (Secretaria Administrativa)
- Cadastro de documentos
- Movimentação de protocolos
- Controle de usuários
- Impressão de recibos
- Menu administrativo

### 2. Sercod (Secretaria de Códigos)
- Cadastro
- Movimentação (Protocolo)
- Tramitação
- Auditoria de movimentações
- Impressão de recibos

## Pontos de Entrada

- `cgdoc/SAdm/login.asp` — Login administrativo
- `cgdoc/Sercod/login.asp` — Login sercod
- `cgdoc/SAdm/menu.asp` — Menu SAdm
- `cgdoc/Sercod/menu.asp` — Menu Sercod

## Banco de Dados

Arquivos SQL convertidos disponíveis em:
- `cgdoc/Sercod/db/cgdoc_sercod.sql`
- `cgdoc/SAdm/db/cgdoc_sercod_SAdm.sql`
- `cgdoc/SAdm/db/cgdoc_SAdm.sql`

### Tabelas Principais

- `Cadastro` — Registro de protocolos
- `Moviment` — Movimentação de processos
- `Tramitacao` — Tramitação entre unidades
- `AudMoviment` — Auditoria de movimentações
- `acesso` — Controle de acesso

## Características do Sistema

- ** Tipo: Sistema de Gerenciamento de Documentos (Protocolo)
- **Público-alvo**: Secretaria de Polícia Militar
- **Arquitetura**: Monolítica ASP/Access
- **Sem testes automatizados** detectados
- **Sem CI/CD** detectado