# Perguntas para Validação — Projeto CGDoc

> Perguntas收集 do Reviewer que precisam de validação humana.

---

## Autenticação e Segurança

**P-01:** O ID de admin hardcoded (1088608) está correto?
- Requirements: `SAdm/requirements.md` — RB-03
- Resposta: _Preencha aqui_

**P-02:** Qual é o tempo de expiração de sessão?
- Requirements: `SAdm/requirements.md` — RNF Performance (marcado como 🟡 inferido)
- Resposta: _Preencha aqui_

**P-03:** As senhas são armazenadas em texto claro ou com hash?
- Design: `SAdm/design.md` — Decisões de Design
- Resposta: texto claro.

---

## Banco de Dados

**P-04:** Quais são os campos exatos da tabela Cadastro?
- Tasks: `SAdm/tasks.md` — TM-02 (marcado 🔴)
- Resposta: Controle, NrProtoc, DtEntr, Descr, Emissor, Nome, Assunto, TipoDoc, Nat, Destino, Obs, Usuario, PastaArquv, CPF,MASP.

**P-05:** Quais são os campos exatos da tabela Tramitação?
- Tasks: `SAdm/tasks.md` — TM-03 (marcado 🔴)
- Resposta: NrProtoc, CodMov, DtMovim, OrigNome, DestNome, Obs, Prazo, Emissor, Assunto, TipoDoc, Descr, Nome, DtEntr. 

**P-06:** Quais são os campos exatos da tabela Movimentação?
- Tasks: `SAdm/tasks.md` — TM-04 (marcado 🔴)
- Resposta: CodMov, NrProtoc, DtMovim, OrigNome, DestNome, Obs, Prazo, UsuaMov, Cumprido.

---

## Funcionalidades

**P-07:** Qual é a diferença funcional entre SAdm e Sercod?
- Specs: `Sercod/requirements.md`, `Sercod/decisions.md`
- Resposta: SAdm é o sistema de cadastro, por onde os documetnos são cadastrados pela proimeira vez. posteriormetne são encaminhados para o Sercod, onde é realizado auditoria, conferencia,inclusão de dados de armazenamento, dados de possiveis devolução para correçoes ou documetnos imcompletos e dados de envio para microfilmagem e envio para o arquivo permanente, dados de local de armazenamento que são lancados em campos cmo Obs.

**P-08:** O Sercod usa o mesmo banco de dados do SAdm?
- Specs: `Sercod/contracts.md` — Integrações
- Resposta: os bancos de dados são parecidos, o Sercod deveria utilizar os dados do cadastro da SAdm, mas na pratica os dados são lancados novamente juntamente com as tramitações.

---

## Campos e Entidades

**P-09:** Existem outras entidades além de Cadastro, Tramitação e Movimentação?
- Code Analysis: `_reversa_sdd/code-analysis.md`
- Resposta: _Preencha aqui_

**P-10:** Qual é a lógica de numeração de processos no Sercod?
- Specs: `Sercod/tasks.md` — T-06 (marcado 🔴)
- Resposta: o NrProtoc deverá ter acrescentado o profeixo do banco de dados de origem para uma futua unificação dos bancos de dados. o NrProtoc é o unico indice que não pode se repetir e é criado automaticamente pelo banco de dados

---

## Observações

- 🔴 Itens críticos que bloqueiam reimplementação
- 🟡 Itens inferidos que precisam de validação
- Todas as respostas serão incorporadas nas specs

---

> Preencha cada resposta e digite `/reversa` quando terminar para processar as validações.