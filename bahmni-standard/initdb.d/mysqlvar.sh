#!/bin/bash

# Genera my.cnf usando variables de entorno
cat << EOF > /etc/mysql/my.cnf
[client]
user=${MYSQL_USER}
password=${MYSQL_PASSWORD}
host=localhost
EOF

# Luego inicia MySQL
exec "$@"
