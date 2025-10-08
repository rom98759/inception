FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Autoriser connexions externes
RUN sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Activer les logs de requêtes et erreurs
RUN sed -i 's/#general_log/general_log/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i 's/general_log.*/general_log = 1/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i 's/#general_log_file/general_log_file/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i 's/general_log_file.*/general_log_file = \/var\/log\/mysql\/general.log/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i 's/#log_error/log_error/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i 's/log_error.*/log_error = \/var\/log\/mysql\/error.log/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    mkdir -p /var/log/mysql && \
    touch /var/log/mysql/general.log /var/log/mysql/error.log && \
    chown -R mysql:mysql /var/log/mysql

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["bash", "/entrypoint.sh"]
