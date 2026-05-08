# spec-id: PAR-07
# processo: Excluir Cadastro
# target_architecture: internal/application/cadastro/service.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Excluir registro de cadastro

  Como usuário autenticado
  Quero excluir um cadastro
  Para remover registro do sistema

  Cenário: Excluir cadastro
    Dado que existe cadastro com ID X
    When solicitar exclusão
    Then deve remover registro do banco