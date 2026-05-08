# spec-id: PAR-03
# processo: Listar Cadastros
# target_architecture: internal/interfaces/http/sadm/cadastro.go
# paradigma: CSP/Go (similar ao legado)

@paridade @critico
Funcionalidade: Listar cadastros com paginação

  Como usuário autenticado
  Quero listar cadastros de processos
  Para visualizar registros existentes

  Cenário: Listar cadastros com paginação padrão
    Dado que existem cadastros cadastrados
    Quando acessar página de listagem
    Então deve exibir registros paginados
    E deve mostrar navigation controls

  Cenário: Listar cadastros ordered by NrProtoc DESC
    Dado que existem cadastros
    Quando listar cadastros
    Then deve ordernar por NrProtoc decrescente