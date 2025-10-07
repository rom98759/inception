FROM debian:bookworm

# Mise à jour des paquets et installation des dépendances
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Installation de Node.js 18.x depuis NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Vérification des versions installées
RUN node --version && npm --version

# Création du répertoire de travail
WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances Node.js
RUN npm install --production

# Copie du code source
COPY src/ ./src/

# Exposition du port
EXPOSE 3000

# Démarrage de l'application
CMD ["node", "src/server.js"]