# spec-id: PAR-05
# processo: Criar Cadastro
# target_architecture: internal/application/cadastro/service.go
# paradigma: CSP/Go (similar ao legado)

@paridade @critico
Funcionalidade: Criar novo registro de cadastro

  Como usuário autenticado
  Quero adicionar novo cadastro de processo
  Para registrar documento no sistema

  Cenário: Criar cadastro com campos obrigatórios
    Dado que estou na página de adição
    Quando preencher NrProtoc, DtEntr, Descr, Nome, Assunto, TipoDoc, Nat, Destino
    E submeter formulário
    Then deve criar novo registro em banco
    E deve gerar NrProtoc com prefixo sadm-

  Cenário: Criar cadastro com campos opcionais
    Given que tenho dados com CPF, MASP, PastaArquiv, Obs
    When submeter com campos opcionais
    Then deve persistir todos os campos

  Cenário: Criar cadastro sem campos obrigatórios
    Given queformulário com campos obrigatórios vazios
    When submeter
    Then deve exibir erro de validação