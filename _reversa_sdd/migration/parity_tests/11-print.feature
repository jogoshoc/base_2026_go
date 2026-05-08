# spec-id: PAR-11
# processo: Imprimir Relatório
# target_architecture: internal/interfaces/http/sadm/print.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Imprimir relatório de cadastros

  Como usuário autenticado
  Quero imprimir relatório de processos
  Para gerar versão para impressão

  Cenário: Imprimir relatório
    Given que tenho resultados de busca
    When solicitar impressão
    Then deve gerar HTML formatado para impressão