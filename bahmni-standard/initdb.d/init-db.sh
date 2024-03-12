#!/bin/bash

# Esperar a que MySQL esté listo
echo "Esperando a MySQL..."
while ! mysqladmin --silent ping; do
    sleep 1
done
echo "MySQL listo."

# Crear la base de datos y la tabla.
mysql --defaults-extra-file=/notificacionsql/my.cnf < "/notificacionsql/create_table_notificacion_ges.sql"

# Luego inicia MySQL u otro proceso principal si es necesario
exec "$@"

mysql --defaults-extra-file=/notificacionsql/my.cnf <<-EOSQL
    CREATE USER '${MYSQL_USER_NOTIFICACIONES}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_NOTIFICACIONES}';
    CREATE DATABASE IF NOT EXISTS \`${NOTIFICACIONES_DATABASE}\`;
    GRANT ALL PRIVILEGES ON \`${NOTIFICACIONES_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';
    FLUSH PRIVILEGES;
EOSQL