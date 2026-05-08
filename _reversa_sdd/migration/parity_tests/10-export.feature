# spec-id: PAR-10
# processo: Exportar Dados
# target_architecture: internal/interfaces/http/sadm/export.go
# paradigma: CSP/Go (similar ao legado)

@paridade
Funcionalidade: Exportar dados para Excel/CSV

  Como usuário autenticado
  Quero exportar dados de cadastros
  Para uso externo

  Cenário: Exportar para Excel
    Given que tenho resultados de busca
    When solicitar exportação Excel
    Then deve gerar arquivo .xls com dados

  Cenário: Exportar para CSV
    Given que tenho resultados de busca
    When solicitar exportação CSV
    Then deve gerar arquivo .csv com dados