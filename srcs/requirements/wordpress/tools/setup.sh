#!/bin/bash

# Attendre que MariaDB soit disponible
echo "🔄 Attente de MariaDB..."
while ! nc -z mariadb 3306; do
  sleep 1
done
echo "✅ MariaDB est disponible"

# Appliquer la config WordPress si pas déjà fait
if [ ! -f /var/www/html/wp-config.php ]; then
  cp wp-config-sample.php wp-config.php
  sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" wp-config.php
  sed -i "s/username_here/$WORDPRESS_DB_USER/" wp-config.php
  sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" wp-config.php
  sed -i "s/localhost/$WORDPRESS_DB_HOST/" wp-config.php
  echo "define('WP_DEBUG', true);" >> wp-config.php

  chown -R www-data:www-data /var/www/html
  chmod -R 755 /var/www/html
  echo "✅ Configuration WordPress appliquée"
fi

# Lancer PHP-FPM en mode foreground
echo "🔄 Démarrage de PHP-FPM..."
php-fpm8.2 -F