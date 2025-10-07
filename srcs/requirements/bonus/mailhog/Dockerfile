FROM debian:bookworm

# Mise à jour et installation des dépendances
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Téléchargement du binaire MailHog pré-compilé
RUN wget -O /usr/local/bin/MailHog https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64 \
    && chmod +x /usr/local/bin/MailHog

# Création d'un utilisateur non-root pour MailHog
RUN useradd -m -s /bin/bash mailhog

# Configuration MailHog
# Port 1025 pour SMTP
# Port 8025 pour l'interface web
# MH_UI_WEB_PATH pour servir sur un sous-chemin
ENV MH_UI_WEB_PATH=/mail

# Exposition des ports
EXPOSE 1025 8025

# Basculer vers l'utilisateur mailhog
USER mailhog

# Démarrage de MailHog
CMD ["MailHog"]