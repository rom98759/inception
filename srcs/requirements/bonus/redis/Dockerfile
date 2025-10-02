FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Installer redis
RUN apt-get update && \
    apt-get install -y redis && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


COPY ./tools/entrypoint_redis.sh /tmp/redis.sh
RUN chmod +x /tmp/redis.sh

EXPOSE 6379

# Lancer le script au démarrage
CMD ["sh", "/tmp/redis.sh"]
