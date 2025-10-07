FROM mailhog/mailhog:latest

# Configuration MailHog
# Port 1025 pour SMTP
# Port 8025 pour l'interface web
# MH_UI_WEB_PATH pour servir sur un sous-chemin

# Configurer MailHog pour servir sur /mail
ENV MH_UI_WEB_PATH=/mail

EXPOSE 1025 8025

CMD ["MailHog"]