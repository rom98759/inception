FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Installer vsftpd et les dépendances nécessaires
RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer les répertoires nécessaires directement
RUN mkdir -p /var/run/vsftpd/empty && \
    mkdir -p /var/log && \
    mkdir -p /var/www/html

# Copier les fichiers de configuration et scripts
COPY ./tools/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/setup.sh /setup.sh

# Définir les permissions
RUN chmod 644 /etc/vsftpd.conf && \
    chmod +x /setup.sh

# Exposer les ports FTP
EXPOSE 20 21 21100-21110

# Utiliser le script de setup comme entrypoint
ENTRYPOINT ["bash", "/setup.sh"]
