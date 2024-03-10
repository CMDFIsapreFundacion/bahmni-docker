#!/bin/bash

# Esperar a que MySQL esté listo
echo "Esperando a MySQL..."
while ! mysqladmin ping -h"${MYSQL_HOST}" --silent; do
    sleep 1
done
echo "MySQL listo."

# Conectarse a MySQL y ejecutar comandos SQL
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -h "${MYSQL_HOST}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${NOTIFICACIONES_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER_NOTIFICACIONES}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_NOTIFICACIONES}';
    GRANT ALL PRIVILEGES ON \`${NOTIFICACIONES_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';
    FLUSH PRIVILEGES;
EOSQL
