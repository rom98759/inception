const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');
const path = require('path');

const app = express();

// Form fields are user input rendered into an HTML email.
const escapeHtml = (value) => String(value).replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
}[c]));
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('src/public'));

// Configuration du transporteur email (MailHog)
const transporter = nodemailer.createTransport({
    host: 'mailhog',
    port: 1025,
    secure: false,
    ignoreTLS: true,
    requireTLS: false,
    auth: false // Pas d'auth pour MailHog
});

// Route principale - Portfolio/CV
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Route alternative pour /cv (si accédé via proxy Nginx)
app.get('/cv', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Route API pour envoyer un email
app.post('/api/send-email', async (req, res) => {
    const { name, email, subject, message } = req.body;

    // Validation basique
    if (!name || !email || !subject || !message) {
        return res.status(400).json({
            success: false,
            error: 'Tous les champs sont requis'
        });
    }

    try {
        // Configuration de l'email
        // Fixed sender: letting the visitor set "From" enables address spoofing.
        const mailOptions = {
            from: `"Portfolio" <${process.env.PORTFOLIO_FROM || 'portfolio@rcaillie.42.fr'}>`,
            replyTo: { name: String(name), address: String(email) },
            to: process.env.CONTACT_EMAIL || 'contact@rcaillie.42.fr',
            subject: `[Portfolio] ${String(subject)}`,
            html: `
                <h3>Nouveau message depuis votre portfolio</h3>
                <p><strong>Nom:</strong> ${escapeHtml(name)}</p>
                <p><strong>Email:</strong> ${escapeHtml(email)}</p>
                <p><strong>Sujet:</strong> ${escapeHtml(subject)}</p>
                <p><strong>Message:</strong></p>
                <p>${escapeHtml(message).replace(/\n/g, '<br>')}</p>
            `
        };

        // Envoi de l'email
        await transporter.sendMail(mailOptions);

        res.json({
            success: true,
            message: 'Email envoyé avec succès!'
        });

    } catch (error) {
        console.error('Erreur envoi email:', error);
        res.status(500).json({
            success: false,
            error: 'Erreur lors de l\'envoi de l\'email'
        });
    }
});

// Route de santé
app.get('/health', (req, res) => {
    res.json({ status: 'OK', service: 'Portfolio' });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Portfolio server running on http://0.0.0.0:${PORT}`);
});