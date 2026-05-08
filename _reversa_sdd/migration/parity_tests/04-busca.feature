# spec-id: PAR-04
# processo: Busca Avançada
# target_architecture: internal/interfaces/http/sadm/cadastro.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Busca avançada com múltiplos critérios

  Como usuário autenticado
  Quero buscar cadastros com múltiplos critérios
  Para localizar registros específicos

  Cenário: Busca com critérios AND/OR
    Dado que existem cadastros no sistema
    When buscar com múltiplos campos preenchidos
    Then deve aplicar lógica AND/OR entre critérios
    And deve retornar registros que atendem condições

  Cenário: Busca por campo vazio (Empty)
    Given que critério está marcado como "Empty"
    Then deve buscar registros com valor nulo no campo