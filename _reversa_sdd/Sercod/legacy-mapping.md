# Sercod — Mapeamento do Legado

> Arquivos do legado que compõem o módulo Sercod.

## Estrutura de Arquivos

```
cgdoc/Sercod/
├── login.asp                    # Autenticação
├── menu.asp                     # Menu principal
├── changepwd.asp                # Alteração de senha
├── include/
│   ├── dbcommon.asp             # Conexão DB (compartilhado?)
│   ├── aspfunctions.asp         # Funções utilitárias
│   ├── commonfunctions.asp      # Funções comuns
│   └── Cadastro_variables.asp   # Definição de campos
├── libs/
│   └── smarty.asp               # Template engine
├── Cadastro_*.asp              # CRUD (~10 arquivos)
├── Tramitacao_*.asp            # CRUD (~10 arquivos)
├── Moviment_*.asp              # CRUD (~10 arquivos)
├── moviment_sec_*.asp          # CRUD (~10 arquivos)
├── Usu_rios_*.asp              # Gestão de usuários (~10 arquivos)
└── (outros)
```

## Comparação com SAdm

| Característica | SAdm | Sercod |
|----------------|------|--------|
| Estrutura de arquivos | Original | Clone |
| Banco de dados | SisprotWeb.mdb | SisprotWeb.mdb (mesmo?) |
| Autenticação | Sim | Sim (compartilhada?) |

## Cobertura de Specs

| Unit | Arquivos Cobertos | % Cobertura |
|------|------------------|-------------|
| Sercod | ~60 principais | ~60% |

> Cobertura menor que SAdm devido a ser clone e ter menos análise.

## Observações

- Estrutura idêntica ao SAdm — possível consolidação em um único módulo
- Funcionalidades específicas de codificação não identificadas
- Necessário acesso ao banco para confirmar diferenciação