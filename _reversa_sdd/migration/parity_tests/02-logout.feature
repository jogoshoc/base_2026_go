# spec-id: PAR-02
# processo: Logout
# target_architecture: internal/interfaces/http/sadm/auth.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Logout e destruição de sessão

  Como usuário autenticado
  Quero fazer logout
  Para invalidar sessão atual

  Cenário: Logout destrói sessão
    Dado que o usuário está autenticado
    Quando solicitar logout
    Então deve abandonar sessão
    E deve limpar cookies username e password
    E deve redirecionar para página de login