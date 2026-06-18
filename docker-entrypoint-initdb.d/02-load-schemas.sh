#!/bin/bash
set -e

echo "Carregando schemas legados e corrigindo o nome do banco de 'movedb' para os corretos..."
echo "Usando --force para ignorar duplicatas conhecidas nos dados legados."

# cgdoc_SAdm.sql -> movedb_SAdm
if [ -f /legacy_dumps/cgdoc_SAdm.sql ]; then
    echo "Importando cgdoc_SAdm.sql para movedb_SAdm..."
    sed "s/\`movedb\`/\`movedb_SAdm\`/g" /legacy_dumps/cgdoc_SAdm.sql | mariadb --force -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "  OK"
else
    echo "AVISO: /legacy_dumps/cgdoc_SAdm.sql nao encontrado."
fi

# cgdoc_sercod.sql -> movedb_Sercod
if [ -f /legacy_dumps/cgdoc_sercod.sql ]; then
    echo "Importando cgdoc_sercod.sql para movedb_Sercod..."
    sed "s/\`movedb\`/\`movedb_Sercod\`/g" /legacy_dumps/cgdoc_sercod.sql | mariadb --force -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "  OK"
else
    echo "AVISO: /legacy_dumps/cgdoc_sercod.sql nao encontrado."
fi

# cgdoc_sercod_SAdm.sql -> movedb_Sercod_SAdm
if [ -f /legacy_dumps/cgdoc_sercod_SAdm.sql ]; then
    echo "Importando cgdoc_sercod_SAdm.sql para movedb_Sercod_SAdm..."
    sed "s/\`movedb\`/\`movedb_Sercod_SAdm\`/g" /legacy_dumps/cgdoc_sercod_SAdm.sql | mariadb --force -u root -p"$MYSQL_ROOT_PASSWORD"
    echo "  OK"
else
    echo "AVISO: /legacy_dumps/cgdoc_sercod_SAdm.sql nao encontrado."
fi

echo "Schemas importados e adaptados com sucesso."
