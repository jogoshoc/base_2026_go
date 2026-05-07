# Risk Register — Projeto CGDoc

> Gerado pelo Reversa Strategist em 2026-05-06

## Riscos de Migração

| ID | Risco | Probabilidade | Impacto | Mitigação | Contingência | Owner |
|----|-------|---------------|---------|-----------|--------------|-------|
| R-01 | UI não idêntica ao legado | Alta | Alto | Parallel Run valida cada tela | Reverter para template original | Dev Lead |
| R-02 | NrProtoc colisão entre bancos | Média | Crítico | Implementar prefixo obrigatório | Regenerar IDs com prefixo | DBA |
| R-03 | Performance Go inferior ao ASP | Média | Médio | Benchmark antes do Parallel Run | Otimizar queries, cache | Dev |
| R-04 | Perda de dados na migração | Baixa | Alto | Validação MD5 antes/depois | Script de recovery | DBA |
| R-05 | Autenticação não funciona | Alta | Alto | Teste manual + automação | Manter fallback | Dev |
| R-06 | Timeout de sessão difere | Média | Médio | Implementar 30min conforme decisão | Ajustar config | Dev |
| R-07 | Codificação caracteres (acentos) | Média | Médio | Usar utf8mb4 em MariaDB | Conversão de charset | DBA |
| R-08 | Integração entre SAdm/Sercod falha | Média | Alto | Testar tramitação em paralelo | Debug logs | Dev |

---

## Riscos Derivados da Mudança de Paradigma

| ID | Risco | Probabilidade | Impacto | Mitigação | Contingência | Owner |
|----|-------|---------------|---------|-----------|--------------|-------|
| R-09 | Sessão stateful não funciona | Alta | Alto | Implementar sync.Map ou cookie | Rollback para session file | Dev |
| R-10 | Template Smarty não reproduzido | Alta | Alto | Parallel Run valida UI | Ajustar templates | Dev |
| R-11 | Repository pattern não cobre queries | Média | Médio | Mapear todas queries do .sql | Adicionar queries faltantes | Dev |
| R-12 | BCrypt não compativel | Baixa | Médio | Testar auth com dados reais | Usar MD5 fallback | Dev |

---

## Riscos de Dados

| ID | Risco | Probabilidade | Impacto | Mitigação | Contingência | Owner |
|----|-------|---------------|---------|-----------|--------------|-------|
| R-13 | Schema .sql incompleto | Média | Alto | Verificar todas tabelas | Adicionar tabelas faltantes | DBA |
| R-14 | Dados com encoding errado | Média | Médio | Validar charset | Reconverter dados | DBA |
| R-15 | FK implícita causa孤儿 | Média | Médio | Validar integridade | Criar FKs explícitas | DBA |

---

## Riscos Operacionais

| ID | Risco | Probabilidade | Impacto | Mitigação | Contingência | Owner |
|----|-------|---------------|---------|-----------|--------------|-------|
| R-16 | Janela de downtime necessária | Alta | Médio | Planejar janela noturna | Downtime acceptable | Ops |
| R-17 | Integração com sistema externo | Baixa | Alto | Mapear dependências | Mockear se necessário | Dev |
| R-18 | Time sem experiência em Go | Alta | Alto | Treinamento + pair programming | Alocar tempo extra | Tech Lead |

---

## Resumo

| Categoria | Quantidade |
|-----------|------------|
| **Críticos** (Alto impacto) | 4 |
| **Médios** | 11 |
| **Baixos** | 3 |
| **Total** | **18** |

---

## Ações Críticas Antes do Parallel Run

1. ✅ Implementar prefixo NrProtoc
2. ✅ Implementar sessão stateful
3. ✅ Validar templates Go = Smarty
4. ✅ Testar autenticação BCrypt
5. ✅ Verificar charset utf8mb4