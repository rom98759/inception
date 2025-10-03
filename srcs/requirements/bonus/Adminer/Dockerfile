FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Installer PHP, PHP-FPM et extensions nécessaires
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql php-mysqli curl mariadb-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurer PHP-FPM pour écouter sur 0.0.0.0:9000
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|^user = .*|user = www-data|' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|^group = .*|group = www-data|' /etc/php/8.2/fpm/pool.d/www.conf

# Créer le dossier de travail
WORKDIR /var/www/html

# Télécharger Adminer et le placer comme index.php
RUN curl -L -O https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mv ./adminer-4.8.1.php /var/www/html/index.php && \
    chown -R www-data:www-data /var/www/html

# Copier le script d'initialisation
COPY tools/entrypoint_adminer.sh /entrypoint_adminer.sh
RUN chmod +x /entrypoint_adminer.sh

# PHP-FPM écoute sur le port 9000
EXPOSE 9000

# Lancer le script au démarrage
CMD ["/entrypoint_adminer.sh"]