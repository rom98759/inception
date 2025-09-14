#!/bin/bash

# Script pour configurer le DNS local
# Utilisation: ./setup_dns.sh <domain_name>

DOMAIN_NAME=${1:-"rcaillie.42.fr"}

# Vérifier si le domaine existe déjà dans /etc/hosts
if grep -q "$DOMAIN_NAME" /etc/hosts; then
    echo "Le domaine $DOMAIN_NAME est déjà configuré dans /etc/hosts"
    grep "$DOMAIN_NAME" /etc/hosts
else
    # Ajouter l'entrée DNS
    echo "127.0.0.1    $DOMAIN_NAME" | sudo tee -a /etc/hosts
    echo "DNS configuré: $DOMAIN_NAME pointe maintenant vers 127.0.0.1"
fi

# Vérifier la configuration
echo "Configuration actuelle pour $DOMAIN_NAME:"
grep "$DOMAIN_NAME" /etc/hosts || echo "Aucune entrée trouvée"

# Test de résolution DNS
echo "Test de résolution DNS:"
nslookup $DOMAIN_NAME 2>/dev/null || echo "nslookup non disponible, utilisez 'ping $DOMAIN_NAME' pour tester"
