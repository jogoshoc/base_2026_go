# ADR-001: Autenticação via Banco de Dados Access

## Status
Aceito

## Contexto
O sistema precisa de autenticação de usuários para proteger o acesso às funcionalidades de gestão de processos e tramitações.

## Decisão
Utilizar autenticação baseada em banco de dados Access (tabela `Usuários`).

### Detalhes Técnicos
- Credenciais (usuário/senha) armazenadas na tabela `[Usuários]`
- Autenticação via consulta SQL com usuário e senha
- Sessão mantida via ASP Session + cookies opcionais

## Consequências

### Positivas
- Sistema autônomo sem dependência de LDAP/AD
- Simples de implementar e manter
- Funciona em ambiente Windows sem AD

### Negativas
- Senhas armazenadas com segurança desconhecida
- Gerenciamento de usuários manual via interface administrativa
- Não suporta autenticação federada

## Referências
- `cgdoc/SAdm/login.asp`
- `include/dbcommon.asp`

---

## Metadata

| Campo | Valor |
|-------|-------|
| **Autor** | Reversa (retroativo) |
| **Data** | 2026-05-06 |
| **Confidence** | 🟢 CONFIRMADO |