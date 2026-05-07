# ADR-002: Modelo RBAC Simples com Admin Bypass

## Status
Aceito

## Contexto
O sistema precisa controlar acesso a funcionalidades de CRUD em diferentes entidades (Cadastro, Tramitação, Movimentação, etc).

## Decisão
Implementar RBAC simples com três níveis e função `CheckSecurity` centralizada.

### Detalhes Técnicos
- Níveis: `ACCESS_LEVEL_ADMIN`, `ACCESS_LEVEL_USER`, `ACCESS_LEVEL_GUEST`
- Função `CheckSecurity(ownerId, operacao)` verifica permissão
- Administrador tem bypass completo — ignora verificações de owner

## Consequências

### Positivas
- Simples de entender e manter
- Admin pode gerenciar qualquer registro
- Separação clara de papéis

### Negativas
- Sem granularidade por entidade
- Sem permissões específicas por功能
- Usuário não-admin só acessa seus próprios registros

## Referências
- `include/dbcommon.asp:79-81` (constantes de nível)
- `include/aspfunctions.asp:1534-1561` (CheckSecurity)

---

## Metadata

| Campo | Valor |
|-------|-------|
| **Autor** | Reversa (retroativo) |
| **Data** | 2026-05-06 |
| **Confidence** | 🟢 CONFIRMADO |