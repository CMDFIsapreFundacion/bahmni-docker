#!/bin/bash

# Genera my.cnf usando variables de entorno
cat << EOF > /etc/mysql/my.cnf
[client]
user=root
password=${MYSQL_ROOT_PASSWORD}
host=localhost
EOF

# Luego inicia MySQL u otro proceso principal si es necesario
exec "$@"
