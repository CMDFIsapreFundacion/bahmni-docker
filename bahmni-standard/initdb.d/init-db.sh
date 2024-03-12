#!/bin/bash

# Esperar a que MySQL esté listo
echo "Esperando a MySQL..."
while ! mysqladmin --defaults-extra-file=/script/my.cnf ping --silent; do
    sleep 1
done
echo "MySQL listo."

# Crear la base de datos y la tabla.
mysql --defaults-extra-file=/script/my.cnf < "/script/create_table_notificacion_ges.sql"

# Crear usuario y base de datos para notificaciones
mysql --defaults-extra-file=/script/my.cnf -e "CREATE USER '${MYSQL_USER_NOTIFICACIONES}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_NOTIFICACIONES}';"
mysql --defaults-extra-file=/script/my.cnf -e "CREATE DATABASE IF NOT EXISTS \`${NOTIFICACIONES_DATABASE}\`;"
mysql --defaults-extra-file=/script/my.cnf -e "GRANT ALL PRIVILEGES ON \`${NOTIFICACIONES_DATABASE}\`.* TO '${MYSQL_USER_NOTIFICACIONES}'@'%';"
mysql --defaults-extra-file=/script/my.cnf -e "FLUSH PRIVILEGES;"
