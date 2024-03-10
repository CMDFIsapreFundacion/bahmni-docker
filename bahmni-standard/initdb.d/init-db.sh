#!/bin/bash

# Esperar a que MySQL esté listo
echo "Esperando a MySQL..."
while ! mysqladmin -h"${OPENMMRS_MYSQL_HOST}" -u root -p"${MYSQL_ROOT_PASSWORD}" --silent ping; do
    sleep 1
done
echo "MySQL listo."

# Conectarse a MySQL y ejecutar comandos SQL
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -h "${OPENMMRS_MYSQL_HOST}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${NOTIFICACIONES_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER_NOTIFICACIONES}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_NOTIFICACIONES}';
        -- Otorgar todos los privilegios en la base de datos de notificaciones
    GRANT ALL PRIVILEGES ON \`${NOTIFICACIONES_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';
        -- Otorgar privilegios de lectura en openmsdb
    GRANT SELECT ON \`${MYSQL_OPENMRS_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';

    FLUSH PRIVILEGES;
EOSQL
