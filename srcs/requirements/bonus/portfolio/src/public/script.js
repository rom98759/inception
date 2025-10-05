document.addEventListener('DOMContentLoaded', function() {
    // Navigation fluide
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Gestion du formulaire de contact
    const contactForm = document.getElementById('contact-form');
    if (contactForm) {
        contactForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const data = Object.fromEntries(formData);

            // Désactiver le bouton pendant l'envoi
            const submitButton = this.querySelector('button[type="submit"]');
            const originalText = submitButton.textContent;
            submitButton.textContent = 'Envoi en cours...';
            submitButton.disabled = true;

            // Supprimer les anciens messages
            const existingMessages = document.querySelectorAll('.message');
            existingMessages.forEach(msg => msg.remove());

            try {
                const response = await fetch('/api/send-email', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data)
                });

                const result = await response.json();

                if (result.success) {
                    showMessage('Message envoyé avec succès ! Je vous répondrai bientôt.', 'success');
                    this.reset();
                } else {
                    showMessage(result.error || 'Erreur lors de l\'envoi du message', 'error');
                }

            } catch (error) {
                console.error('Erreur:', error);
                showMessage('Erreur de connexion. Veuillez réessayer.', 'error');
            } finally {
                // Réactiver le bouton
                submitButton.textContent = originalText;
                submitButton.disabled = false;
            }
        });
    }

    function showMessage(text, type) {
        const message = document.createElement('div');
        message.className = `message ${type}`;
        message.textContent = text;
        message.style.display = 'block';

        const form = document.getElementById('contact-form');
        form.insertBefore(message, form.firstChild);

        // Faire disparaître le message après 5 secondes
        setTimeout(() => {
            message.style.display = 'none';
            message.remove();
        }, 5000);
    }

    // Animation au scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observer les cartes de compétences et projets
    document.querySelectorAll('.skill-card, .project-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
});