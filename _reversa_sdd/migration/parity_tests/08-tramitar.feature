# spec-id: PAR-08
# processo: Tramitar Processo
# target_architecture: internal/application/tramitacao/service.go
# paradigma: CSP/Go (similar ao legado)

@paridade @critico
Funcionalidade: Tramitar processo para outro departamento

  Como usuário autenticado
  Quero tramitas processo para outro departamento
  Para registrar encaminhamento

  Cenário: Tramitar processo com destino obrigatório
    Dado que existe cadastro no sistema
    When submeter tramitação com Destino preenchido
    Then deve criar registro em tramitacao
    And deve manter referência ao NrProtoc original
    And deve registrar DtMovim

  Cenário: Tramitar sem destino
    Given que Destino está vazio
    When submeter tramitação
    Then deve rejeitar com erro de validação