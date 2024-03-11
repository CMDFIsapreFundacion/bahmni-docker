#!/bin/bash

# Esperar a que MySQL esté listo
#echo "Esperando a MySQL..."
#while ! mysqladmin -h"${OPENMMRS_MYSQL_HOST}" -u root -p"${MYSQL_ROOT_PASSWORD}" --silent ping; do
 #   sleep 1
#done
#echo "MySQL listo."

# Esperar a que MySQL esté listo
echo "Esperando a MySQL..."
while ! mysqladmin --silent ping; do
    sleep 1
done
echo "MySQL listo."

# Genera my.cnf usando variables de entorno
cat << EOF > /etc/mysql/my.cnf
[client]
user=root
password=${MYSQL_ROOT_PASSWORD}
host=localhost
EOF

# Luego inicia MySQL u otro proceso principal si es necesario
exec "$@"


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

#crear la tabla.
mysql ${NOTIFICACIONES_DATABASE} < "/notificacionsql/create_table_notificacion_ges.sql"

