#!/bin/bash

# Démarrer MariaDB en arrière-plan
mysqld_safe --skip-networking &
sleep 5

# Vérifie si la DB est déjà initialisée
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
  echo "🔧 Initialisation de la base de données..."

  cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

  mysql -u root < /tmp/init.sql
  echo "✅ Base de données initialisée."
fi

# Arrête MariaDB temporairement
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Redémarre proprement en mode foreground
exec mysqld_safe
