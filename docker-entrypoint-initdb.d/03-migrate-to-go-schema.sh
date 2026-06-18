#!/bin/bash
set -e

MIGRATION_FILE="/migrations/001_initial_schema.sql"
ETL_FILE="/migrations/etl-legado-to-go.sql"

echo "============================================"
echo " Fase 3: Criando schema Go + ETL"
echo "============================================"

echo "Renomeando tabelas legadas com conflito de nome..."
for DB in movedb_SAdm movedb_Sercod movedb_Sercod_SAdm; do
    echo "  $DB: renomeando acesso para acesso_legado..."
    mariadb -u root -p"$MYSQL_ROOT_PASSWORD" "$DB" -e "DROP TABLE IF EXISTS \`acesso_legado\`; RENAME TABLE \`acesso\` TO \`acesso_legado\`;" 2>/dev/null || true
done
echo "  OK"

for DB in movedb_SAdm movedb_Sercod movedb_Sercod_SAdm; do
    echo ""
    echo "--- Processando banco: $DB ---"
    echo "  [1/2] Criando tabelas Go em $DB..."
    mariadb -u root -p"$MYSQL_ROOT_PASSWORD" "$DB" < "$MIGRATION_FILE"
    echo "    OK"
    echo "  [2/2] Executando ETL em $DB..."
    mariadb -u root -p"$MYSQL_ROOT_PASSWORD" "$DB" < "$ETL_FILE"
    echo "    OK"
done

echo ""
echo "============================================"
echo " Fase 3 concluida! Schema Go populado."
echo "============================================"

echo ""
echo "Resumo de registros migrados:"
for DB in movedb_SAdm movedb_Sercod movedb_Sercod_SAdm; do
    echo "--- $DB ---"
    SQL="SELECT CONCAT('  cadastro: ', COUNT(*)) FROM cadastro"
    SQL="$SQL UNION ALL SELECT CONCAT('  usuarios: ', COUNT(*)) FROM usuarios"
    SQL="$SQL UNION ALL SELECT CONCAT('  moviment: ', COUNT(*)) FROM moviment"
    SQL="$SQL UNION ALL SELECT CONCAT('  tramitacao: ', COUNT(*)) FROM tramitacao"
    SQL="$SQL UNION ALL SELECT CONCAT('  orgaos: ', COUNT(*)) FROM orgaos"
    SQL="$SQL UNION ALL SELECT CONCAT('  tipodoc: ', COUNT(*)) FROM tipodoc"
    SQL="$SQL UNION ALL SELECT CONCAT('  acesso: ', COUNT(*)) FROM acesso"
    mariadb -u root -p"$MYSQL_ROOT_PASSWORD" "$DB" -N -e "$SQL" 2>/dev/null || echo "  (tabelas vazias ou erro)"
done
