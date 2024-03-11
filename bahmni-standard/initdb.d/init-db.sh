#!/bin/bash

# Esperar a que MySQL esté listo
echo "Esperando a MySQL..."
while ! mysqladmin --silent ping; do
    sleep 1
done
echo "MySQL listo."

# Luego inicia MySQL u otro proceso principal si es necesario
exec "$@"

# Conectarse a MySQL y ejecutar comandos SQL utilizando el archivo de configuración personalizado
USER_EXISTS=$(mysql --defaults-extra-file=/notificacionsql/my.cnf -Bse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${MYSQL_USER_NOTIFICACIONES}' AND host = '%')")
if [ "$USER_EXISTS" -eq 0 ]; then
    mysql --defaults-extra-file=/notificacionsql/my.cnf <<-EOSQL
        CREATE USER '${MYSQL_USER_NOTIFICACIONES}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_NOTIFICACIONES}';
EOSQL
fi

mysql --defaults-extra-file=/notificacionsql/my.cnf <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${NOTIFICACIONES_DATABASE}\`;
    GRANT ALL PRIVILEGES ON \`${NOTIFICACIONES_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';
    GRANT SELECT ON \`${MYSQL_OPENMRS_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';
    FLUSH PRIVILEGES;
EOSQL

#crear la tabla.
mysql --defaults-extra-file=/notificacionsql/my.cnf ${NOTIFICACIONES_DATABASE} < "./notificacionsql/create_table_notificacion_ges.sql"

#borrar el archivo /notificacionsql/my.cnf
#rm /notificacionmy/my.cnf