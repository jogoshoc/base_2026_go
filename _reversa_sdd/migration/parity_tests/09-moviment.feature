# spec-id: PAR-09
# processo: Registrar Movimentação
# target_architecture: internal/application/moviment/service.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Registrar movimentação de processo

  Como usuário autenticado
  Quero registrar movimentação de processo
  Para registrar ações sobre o documento

  Cenário: Registrar movimentação
    Dado que existe cadastro no sistema
    When registrar movimentação com dados
    Then deve criar registro em moviment
    And deve referenciar NrProtoc