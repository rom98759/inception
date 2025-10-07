# 🐳 Inception - Docker Infrastructure

Infrastructure complète avec Nginx, WordPress, MariaDB et services bonus (Redis, MailHog, Portfolio, FTP, Adminer).

---

## 📋 Table des matières

- [Architecture](#architecture)
- [Services](#services)
- [Commandes Docker](#commandes-docker)
- [Gestion des containers](#gestion-des-containers)
- [Debugging](#debugging)
- [URLs d'accès](#urls-daccès)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Nginx (Reverse Proxy)                     │
│                   https://rcaillie.42.fr                      │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
    ┌───▼───┐           ┌─────▼─────┐        ┌─────▼─────┐
    │  WP   │◄──────────┤  MariaDB  │        │ Portfolio │
    │ :9000 │           │   :3306   │        │   :3000   │
    └───┬───┘           └───────────┘        └───────────┘
        │
    ┌───▼───┐           ┌───────────┐        ┌───────────┐
    │ Redis │           │  MailHog  │        │  Adminer  │
    │ :6379 │           │ :8025/1025│        │   :9000   │
    └───────┘           └───────────┘        └───────────┘
```

---

## 🔧 Services

### Services Principaux

| Service | Port(s) | Description | Image |
|---------|---------|-------------|-------|
| **Nginx** | 443 | Reverse proxy HTTPS avec SSL | `debian:bookworm` |
| **WordPress** | 9000 | CMS PHP avec PHP-FPM | `debian:bookworm` |
| **MariaDB** | 3306 | Base de données MySQL | `debian:bookworm` |

### Services Bonus

| Service | Port(s) | Description | Image |
|---------|---------|-------------|-------|
| **Redis** | 6379 | Cache pour WordPress | `debian:bookworm` |
| **MailHog** | 8025/1025 | Serveur mail de test | `debian:bookworm` |
| **Portfolio** | 3000 | CV/Portfolio Node.js | `debian:bookworm` |
| **Adminer** | 9000 | Interface de gestion BDD | `debian:bookworm` |
| **FTP** | 21 | Serveur FTP (vsftpd) | `debian:bookworm` |

---

## 🚀 Commandes Docker

### Commandes de base

```bash
# Démarrer tous les services
make

# Redémarrer (rebuild + clean)
make re

# Arrêter tous les services
make down

# Nettoyer complètement (containers + volumes + images)
make fclean

# Voir les logs de tous les services
docker compose -f srcs/docker-compose.yml logs -f

# Voir les logs d'un service spécifique
docker compose -f srcs/docker-compose.yml logs -f nginx
```

### Build et images

```bash
# Reconstruire une image spécifique
docker compose -f srcs/docker-compose.yml build nginx

# Reconstruire sans cache
docker compose -f srcs/docker-compose.yml build --no-cache

# Lister toutes les images
docker images

# Supprimer une image
docker rmi srcs-nginx

# Nettoyer les images inutilisées
docker image prune -a
```

### Volumes

```bash
# Lister les volumes
docker volume ls

# Inspecter un volume
docker volume inspect srcs_wordpress_data

# Supprimer un volume
docker volume rm srcs_wordpress_data

# Nettoyer les volumes inutilisés
docker volume prune
```

### Réseaux

```bash
# Lister les réseaux
docker network ls

# Inspecter le réseau inception
docker network inspect srcs_inception

# Voir les containers connectés
docker network inspect srcs_inception | grep Name
```

---

## 📦 Gestion des containers

### Commandes générales

```bash
# Lister les containers actifs
docker ps

# Lister tous les containers (actifs + arrêtés)
docker ps -a

# Statistiques en temps réel
docker stats

# Inspecter un container
docker inspect nginx

# Voir les processus d'un container
docker top nginx
```

### Exécution de commandes

```bash
# Ouvrir un shell dans un container
docker exec -it nginx bash

# Exécuter une commande ponctuelle
docker exec nginx ls -la /var/www/html

# Exécuter en tant que root
docker exec -u root wordpress whoami
```

### Logs et debugging

```bash
# Voir les logs d'un container
docker logs nginx

# Suivre les logs en temps réel
docker logs -f nginx

# Voir les 50 dernières lignes
docker logs --tail 50 nginx

# Logs avec timestamps
docker logs -t nginx
```

### Redémarrage et arrêt

```bash
# Redémarrer un container
docker restart nginx

# Arrêter un container
docker stop nginx

# Arrêter avec timeout
docker stop -t 30 nginx

# Démarrer un container arrêté
docker start nginx

# Tuer un container (force)
docker kill nginx
```

---

## 🔍 Debugging par service

### 🌐 Nginx

```bash
# Vérifier la configuration
docker exec nginx nginx -t

# Recharger la configuration
docker exec nginx nginx -s reload

# Voir les logs d'accès
docker exec nginx tail -f /var/log/nginx/access.log

# Voir les logs d'erreur
docker exec nginx tail -f /var/log/nginx/error.log

# Tester la connectivité vers WordPress
docker exec nginx curl -I http://wordpress:9000

# Vérifier le certificat SSL
docker exec nginx openssl x509 -in /etc/nginx/ssl/self-signed.crt -text -noout
```

### 📝 WordPress

```bash
# Accéder au shell WordPress
docker exec -it wordpress bash

# Vérifier la configuration PHP-FPM
docker exec wordpress cat /etc/php/8.2/fpm/pool.d/www.conf

# Lister les plugins installés
docker exec wordpress wp plugin list --allow-root

# Vérifier la connexion Redis
docker exec wordpress wp redis info --allow-root

# Afficher la configuration Redis dans wp-config.php
docker exec wordpress cat /var/www/html/wp-config.php | grep REDIS

# Installer un nouveau plugin
docker exec wordpress wp plugin install contact-form-7 --activate --allow-root

# Mettre à jour WordPress
docker exec wordpress wp core update --allow-root
```

### 🗄️ MariaDB

```bash
# Accéder à MySQL
docker exec -it mariadb mysql -u root -p

# Lister les bases de données
docker exec mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SHOW DATABASES;"

# Voir les utilisateurs
docker exec mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT user,host FROM mysql.user;"

# Backup de la base
docker exec mariadb mysqldump -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} > backup.sql

# Restaurer une base
docker exec -i mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < backup.sql

# Vérifier les connexions actives
docker exec mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SHOW PROCESSLIST;"
```

### 🔴 Redis

```bash
# Accéder au CLI Redis
docker exec -it redis redis-cli

# Vérifier la connexion
docker exec redis redis-cli ping

# Voir les statistiques
docker exec redis redis-cli INFO

# Voir toutes les clés
docker exec redis redis-cli KEYS '*'

# Vider le cache
docker exec redis redis-cli FLUSHALL

# Monitorer les commandes en temps réel
docker exec redis redis-cli MONITOR
```

### 📧 MailHog

```bash
# Vérifier que MailHog fonctionne
docker exec mailhog ps aux | grep MailHog

# Tester l'envoi d'un email
docker exec nginx curl -X POST http://mailhog:1025 \
  --data-binary @- <<EOF
HELO localhost
MAIL FROM: test@example.com
RCPT TO: dest@example.com
DATA
Subject: Test
Test message
.
QUIT
EOF

# Vérifier les logs
docker logs mailhog
```

### 💼 Portfolio (Node.js)

```bash
# Vérifier la version de Node.js
docker exec portfolio node --version

# Voir les dépendances installées
docker exec portfolio npm list

# Tester l'API d'envoi d'email
docker exec nginx curl -s -X POST http://portfolio:3000/api/send-email \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@test.com","subject":"Test","message":"Test message"}'

# Voir les logs de l'application
docker logs -f portfolio

# Redémarrer le serveur Node.js
docker restart portfolio
```

### 🎯 Adminer

```bash
# Vérifier PHP-FPM
docker exec adminer php-fpm8.2 -t

# Tester la connexion à MariaDB
docker exec adminer mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;"

# Voir les logs PHP
docker logs adminer
```

### 📁 FTP

```bash
# Vérifier le serveur FTP
docker exec ftp ps aux | grep vsftpd

# Voir la configuration
docker exec ftp cat /etc/vsftpd.conf

# Tester la connexion FTP
ftp rcaillie.42.fr 21

# Lister les utilisateurs FTP
docker exec ftp cat /etc/passwd | grep ftp
```

---

## 🌍 URLs d'accès

| Service | URL | Credentials |
|---------|-----|-------------|
| **WordPress** | https://rcaillie.42.fr/ | Admin depuis .env |
| **Portfolio/CV** | https://rcaillie.42.fr/cv | - |
| **MailHog** | https://rcaillie.42.fr/mail | - |
| **Adminer** | https://rcaillie.42.fr/adminer | User/Pass depuis .env |

---

## 🔧 Commandes utiles combinées

### Vérification complète du système

```bash
# Vérifier tous les services
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Voir l'utilisation des ressources
docker stats --no-stream

# Vérifier les volumes
docker volume ls | grep srcs

# Tester toutes les connexions
docker exec nginx curl -I http://wordpress:9000
docker exec nginx curl -I http://portfolio:3000
docker exec nginx curl -I http://mailhog:8025
docker exec wordpress mysql -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;"
docker exec wordpress redis-cli -h redis ping
```

### Nettoyage complet

```bash
# Tout arrêter et nettoyer
make fclean

# Nettoyer Docker complètement
docker system prune -a --volumes -f

# Supprimer les données persistantes
sudo rm -rf /home/inception/data/*
```

### Backup et restauration

```bash
# Backup WordPress
docker exec mariadb mysqldump -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} > wp_backup.sql
tar -czf wordpress_files.tar.gz /home/inception/data/wordpress/

# Restauration WordPress
tar -xzf wordpress_files.tar.gz -C /home/inception/data/
docker exec -i mariadb mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < wp_backup.sql
```

---

## 📊 Variables d'environnement (.env)

```bash
# MariaDB
MYSQL_ROOT_PASSWORD=xxx
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=xxx

# WordPress
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=xxx
WORDPRESS_ADMIN_EMAIL=xxx

# Domaine
DOMAIN_NAME=rcaillie.42.fr

# Portfolio
CONTACT_EMAIL=contact@rcaillie.42.fr

# FTP
FTP_USER=ftpuser
FTP_PASSWORD=xxx
```

---

## 🐛 Troubleshooting

### Service ne démarre pas
```bash
# Voir les logs détaillés
docker logs <container_name>

# Vérifier les dépendances
docker compose -f srcs/docker-compose.yml ps

# Reconstruire sans cache
docker compose -f srcs/docker-compose.yml build --no-cache <service>
```

### Problème de connexion réseau
```bash
# Vérifier le réseau
docker network inspect srcs_inception

# Tester la connexion depuis nginx
docker exec nginx ping wordpress
docker exec nginx ping mariadb
```

### Erreur 502 Bad Gateway
```bash
# Vérifier que PHP-FPM écoute
docker exec wordpress netstat -tlnp | grep 9000

# Vérifier la config Nginx
docker exec nginx nginx -t
```

---

## 📚 Ressources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [WordPress CLI](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)

---

**Made with ❤️ for 42 Inception project**