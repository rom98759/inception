FROM node:18-alpine

WORKDIR /app

# Installation de nodemailer pour l'envoi d'emails
COPY package*.json ./
RUN npm install

# Copie du code source
COPY src/ ./src/

EXPOSE 3000

CMD ["node", "src/server.js"]