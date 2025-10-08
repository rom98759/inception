FROM debian:bookworm

ARG DOMAIN_NAME
ENV DEBIAN_FRONTEND=noninteractive
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apt-get update && \
    apt-get install -y nginx openssl gettext-base curl iputils-ping netcat-traditional && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Création du certificat auto-signé
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
    -subj "/C=FR/ST=France/L=Paris/O=42/CN=${DOMAIN_NAME}" \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/self-signed.key \
    -out /etc/nginx/ssl/self-signed.crt

# Copier le template et générer le fichier final
COPY conf/default.conf.template /etc/nginx/templates/default.conf.template

RUN envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Activer le mode debug dans Nginx
RUN sed -i 's/#error_log/error_log/' /etc/nginx/nginx.conf && \
    sed -i 's/error_log.*/error_log stderr debug;/' /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
