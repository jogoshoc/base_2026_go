# spec-id: PAR-01
# processo: Login
# target_architecture: internal/interfaces/http/sadm/auth.go
# paradigma: CSP/Go (similar ao legado)

@paridade @critico
Funcionalidade: Login de usuário no sistema

  Como usuário do sistema
  Quero autenticar com usuário e senha
  Para acessar as funcionalidades restritas

  Cenário: Login bem-sucedido com credenciais válidas
    Dado que o usuário existe na base de dados
    Quando submeter credenciais válidas
    Então deve criar sessão com UserID
    E deve definir nível de acesso

  Cenário: Login com usuário admin (1088608)
    Dado que o usuário admin está configurado
    Quando fazer login com ID 1088608
    Então deve receber ACCESS_LEVEL_ADMIN
    E deve ignorar verificações de owner

  Cenário: Login com credenciais inválidas
    Dado que o usuário não existe ou senha incorreta
    Quando submeter credenciais inválidas
    Então deve exibir mensagem de erro
    E não deve criar sessão

  Cenário: Lembrar senha por 1 ano
    Dado que o usuário marcado "remember password"
    Quando fazer login com sucesso
    Então deve criar cookies com validade de 1 ano