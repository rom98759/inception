FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Installer PHP, PHP-FPM et extensions nécessaires
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget tar curl netcat-traditional php8.2-redis && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurer PHP-FPM pour écouter sur 0.0.0.0:9000 au lieu d'un socket
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|^user = .*|user = www-data|' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|^group = .*|group = www-data|' /etc/php/8.2/fpm/pool.d/www.conf


# Créer le dossier de travail
WORKDIR /var/www/html

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


# Copier le script d'initialisation
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# PHP-FPM écoute sur le port 9000
EXPOSE 9000

# Lancer le script au démarrage
ENTRYPOINT ["/setup.sh"]
