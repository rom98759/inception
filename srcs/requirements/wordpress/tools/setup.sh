#!/bin/bash

# Attendre que MariaDB soit disponible
echo "🔄 Attente de MariaDB..."
while ! nc -z mariadb 3306; do
  sleep 1
done
echo "✅ MariaDB est disponible"

# Vérifier et créer le répertoire WordPress si nécessaire
mkdir -p /var/www/html

# Configuration WordPress si pas déjà fait
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "🔄 Configuration initiale de WordPress..."

  # Vérifier si WordPress est déjà téléchargé
  if [ ! -f /var/www/html/wp-includes/version.php ]; then
    echo "🔄 Téléchargement de WordPress..."
    wp core download --allow-root --path=/var/www/html
    echo "✅ WordPress téléchargé"
  else
    echo "✅ WordPress déjà présent"
  fi

  echo "🔄 Création de la configuration WordPress..."
  wp config create \
    --dbname=$WORDPRESS_DB_NAME \
    --dbuser=$WORDPRESS_DB_USER \
    --dbpass=$WORDPRESS_DB_PASSWORD \
    --dbhost=$WORDPRESS_DB_HOST \
    --path=/var/www/html \
    --allow-root

  # Vérifier si WordPress est déjà installé dans la base de données
  if ! wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    echo "🔄 Installation de WordPress..."
    wp core install \
      --url="https://$DOMAIN_NAME" \
      --title="Inception" \
      --admin_user=$WP_ADMIN_USER \
      --admin_password=$WP_ADMIN_PASSWORD \
      --admin_email=$WP_ADMIN_EMAIL \
      --skip-email \
      --path=/var/www/html \
      --allow-root

    echo "🔄 Création de l'utilisateur supplémentaire..."
    if ! wp user get $WP_USER --path=/var/www/html --allow-root 2>/dev/null; then
      wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --path=/var/www/html \
        --allow-root
    fi

    echo "✅ WordPress installé avec succès"
  else
    echo "✅ WordPress déjà installé dans la base de données"
  fi

  echo "🔄 Configuration des permissions..."
  chown -R www-data:www-data /var/www/html
  chmod -R 755 /var/www/html

  ####### BONUS PART ################

  ## Theme Bedrock ##
  echo "🎨 Installation du thème bedrock"
  if ! wp theme is-installed bedrock --path=/var/www/html --allow-root; then
    wp theme install bedrock --activate --allow-root
    echo "✅ Thème bedrock installé et activé"
  else
    wp theme activate twentytwentythree --allow-root
    echo "✅ Thème Twenty Twenty-Three activé"
  fi

  ## redis ##

  wp config set WP_REDIS_HOST redis --allow-root
  wp config set WP_REDIS_PORT 6379 --raw --allow-root
  wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
  wp config set WP_REDIS_CLIENT phpredis --allow-root
  wp plugin install redis-cache --activate --allow-root
  wp plugin update --all --allow-root
  wp redis enable --allow-root

  ###  end of redis part  ###

else
  echo "✅ WordPress déjà configuré"
  # S'assurer que les permissions sont correctes
  chown -R www-data:www-data /var/www/html
  chmod -R 755 /var/www/html
fi

# Lancer PHP-FPM en mode foreground
echo "🔄 Démarrage de PHP-FPM..."
exec php-fpm8.2 -F
