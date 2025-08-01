FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Installer PHP, PHP-FPM et extensions nécessaires
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget tar curl netcat-traditional && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurer PHP-FPM pour écouter sur 0.0.0.0:9000 au lieu d'un socket
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|^user = .*|user = www-data|' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|^group = .*|group = www-data|' /etc/php/8.2/fpm/pool.d/www.conf


# Créer le dossier de travail
WORKDIR /var/www/html

# Télécharger WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Copier le script d'initialisation
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# PHP-FPM écoute sur le port 9000
EXPOSE 9000

# Lancer le script au démarrage
CMD ["/setup.sh"]
