# Sercod — Contratos e Interfaces

> Definição de interfaces expostas pelo módulo Sercod.

## Interfaces HTTP

Idêntico ao SAdm. Ver `SAdm/contracts.md` para detalhes.

### Públicas

| Rota | Método | Descrição |
|------|--------|-----------|
| `/login.asp` | GET/POST | Login |

### Protegidas

| Rota | Método | Descrição |
|------|--------|-----------|
| `/menu.asp` | GET | Menu principal |
| `/Cadastro_list.asp` | GET | Listagem |
| `/Cadastro_add.asp` | GET | Formulário adição |
| `/Cadastro_addnewitem.asp` | POST | Processa adição |
| `/Cadastro_edit.asp` | GET | Formulário edição |
| `/Cadastro_search.asp` | GET/POST | Busca avançada |
| `/Tramitacao_list.asp` | GET | Tramitações |
| `/Moviment_list.asp` | GET | Movimentações |
| `/Usu_rios_list.asp` | GET | Usuários |

## Modelos de Dados

Idênticos ao SAdm. Ver `SAdm/contracts.md`.

##Cookies e Sessão

Idênticos ao SAdm. Ver `SAdm/contracts.md`.

## Integrações

| Sistema | Tipo | Protocolo |
|---------|------|-----------|
| SisprotWeb.mdb | Banco | OLE DB/ADO |

> Mesmo banco do SAdm — possível compartilhamento de dados.