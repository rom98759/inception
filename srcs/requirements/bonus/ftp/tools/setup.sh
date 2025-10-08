#!/bin/bash

echo "🔄 Démarrage du serveur FTP vsftpd..."

# Attendre que WordPress soit prêt et que le répertoire soit disponible
echo "🔄 Attente de la disponibilité du répertoire WordPress..."
while [ ! -d "/var/www/html" ]; do
    sleep 1
done

# S'assurer que le répertoire existe et a les bonnes permissions
mkdir -p /var/www/html
chmod 755 /var/www/html

# Vérifier si l'utilisateur FTP existe déjà
if ! id "$FTP_USER" &>/dev/null; then
    echo "🔧 Création de l'utilisateur FTP: $FTP_USER"

    # Créer l'utilisateur FTP avec le répertoire home pointant vers /var/www/html
    useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"

    # Définir le mot de passe
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

    echo "✅ Utilisateur FTP '$FTP_USER' créé avec succès"
else
    echo "✅ L'utilisateur FTP '$FTP_USER' existe déjà"
    # Mettre à jour le mot de passe au cas où
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Ajouter l'utilisateur FTP au groupe www-data
usermod -a -G www-data "$FTP_USER"

# Donner la propriété complète du répertoire WordPress à l'utilisateur FTP
# L'utilisateur FTP devient propriétaire, www-data reste dans le groupe
chown -R "$FTP_USER:www-data" /var/www/html

# Permissions complètes pour le propriétaire (FTP_USER), lecture/écriture pour le groupe (www-data)
chmod -R 775 /var/www/html

# S'assurer que tous les nouveaux fichiers hériteront du groupe www-data
find /var/www/html -type d -exec chmod 2775 {} \;
find /var/www/html -type f -exec chmod 664 {} \;

# Créer le répertoire de logs si nécessaire
mkdir -p /var/log
touch /var/log/vsftpd.log
chmod 644 /var/log/vsftpd.log

echo "🔧 Configuration des permissions terminée"
echo "📁 Répertoire FTP: /var/www/html"
echo "👤 Utilisateur FTP: $FTP_USER"
echo "🔐 Mot de passe: [MASQUÉ]"

# Vérifier que le fichier de configuration existe
if [ ! -f /etc/vsftpd.conf ]; then
    echo "❌ Erreur: fichier de configuration vsftpd.conf manquant"
    exit 1
fi

echo "🚀 Démarrage du serveur vsftpd..."

# Démarrer vsftpd en mode foreground
exec vsftpd /etc/vsftpd.conf