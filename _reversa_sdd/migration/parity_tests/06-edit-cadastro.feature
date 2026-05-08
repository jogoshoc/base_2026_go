# spec-id: PAR-06
# processo: Editar Cadastro
# target_architecture: internal/application/cadastro/service.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Editar registro de cadastro existente

  Como usuário autenticado
  Quero editar dados de um cadastro
  Para corrigir ou atualizar informações

  Cenário: Editar cadastro com sucesso
    Dado que existe cadastro com ID X
    When modificar campos e submeter
    Then deve atualizar registro no banco
    And deve manter NrProtoc inalterado