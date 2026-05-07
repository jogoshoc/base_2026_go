# SAdm — Contratos e Interfaces

> Definição de interfaces expostas pelo módulo SAdm.

## Interfaces HTTP

O módulo SAdm não expõe APIs REST formais. É um aplikasi web tradicional com páginas ASP. Abaixo, as "rotas"implícitas:

### Páginas Públicas

| Rota | Método | Descrição |
|------|--------|-----------|
| `/login.asp` | GET | Página de login |
| `/login.asp` | POST | Submissão de credenciais |

### Páginas Protegidas (requerem autenticação)

| Rota | Método | Descrição |
|------|--------|-----------|
| `/menu.asp` | GET | Menu principal |
| `/Cadastro_list.asp` | GET | Listagem de cadastros |
| `/Cadastro_add.asp` | GET | Formulário de adição |
| `/Cadastro_addnewitem.asp` | POST | Processa adição |
| `/Cadastro_edit.asp` | GET | Formulário de edição |
| `/Cadastro_search.asp` | GET/POST | Busca avançada |
| `/Cadastro_print.asp` | GET | Impressão |
| `/Tramitacao_list.asp` | GET | Listagem de tramitações |
| `/Tramitacao_addnewitem.asp` | POST | Nova tramitação |
| `/Moviment_list.asp` | GET | Listagem de movimentações |
| `/Moviment_addnewitem.asp` | POST | Nova movimentação |
| `/Usu_rios_list.asp` | GET | Gestão de usuários |

### Parâmetros Comuns

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `a` | string | Ação (search, showall, etc.) |
| `message` | string | Mensagem (ex: expired) |
| `btnSubmit` | string | Botão submitado |

### Cookies

| Cookie | Tipo | Expires | Descrição |
|--------|------|---------|-----------|
| `username` | string | 1 ano | Login.do usuário (se lembrar) |
| `password` | string | 1 ano | Senha (se lembrar) |

### Variáveis de Sessão

| Variável | Tipo | Descrição |
|----------|------|-----------|
| `UserID` | string | ID do usuário |
| `AccessLevel` | string | Nível (Admin/User/Guest) |
| `GroupID` | string | Grupo/Privilégio |
| `OwnerID` | string | ID do proprietário |
| `MyURL` | string | URL de retorno |

## Modelos de Dados

### Usuário (entrada/saída)

```typescript
interface Usuario {
  Usuario: string;      // Login
  Senha: string;        // Senha
  Privilegio: string;   // Nível de acesso
}
```

### Cadastro (entrada/saída)

```typescript
interface Cadastro {
  N_Processo: string;   // Número do processo (PK)
  Nome: string;         // Nome/interessado
  Data: DateTime;       // Data de cadastro
  Descricao?: string;   // Descrição detalhada
}
```

### Tramitação

```typescript
interface Tramitacao {
  id: number;           // ID interno
  Protocolo: string;    // Número de protocolo
  Data_Tramite: DateTime;
  Destino: string;      // Departamento destino
  Origem?: string;      // Departamento origem
  Processo: string;     // FK para Cadastro
  Usuario: string;      // FK para Usuário
}
```

### Movimentação

```typescript
interface Movimentacao {
  id: number;           // ID interno
  Processo: string;     // FK para Cadastro
  Data_Movto: DateTime;
  Tipo: string;         // Tipo (entrada/saída)
  Descricao?: string;
  Usuario: string;      // FK para Usuário
}
```

## Códigos de Status

| Código | Significado |
|--------|-------------|
| 200 | OK (página exibida) |
| 302 | Redirect |
| 400 | Erro de requisição |
| 401 | Não autenticado |
| 403 | Sem permissão |
| 500 | Erro interno |

## Integrações

| Sistema | Tipo | Protocolo | Descrição |
|---------|------|-----------|------------|
| SisprotWeb.mdb | Banco de dados | OLE DB/ADO | Persistência de dados |

> Não há APIs externas, webhooks ou integrações com sistemas terceiros.