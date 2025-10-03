#!/bin/bash

# Créer les répertoires nécessaires
mkdir -p /run/php
mkdir -p /var/log/php

sudo cat /etc/php/8.2/fpm/php-fpm.conf

# Démarrer PHP-FPM en mode non-daemonisé
echo "Démarrage de PHP-FPM pour Adminer..."
php-fpm8.2 --nodaemonize --fpm-config /etc/php/8.2/fpm/php-fpm.conf