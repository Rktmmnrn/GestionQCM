package com.examen.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.InputStream;
import java.util.Properties;

/**
 * Utilitaire pour l'envoi d'emails via SMTP
 * Utilise JavaMail API pour envoyer des notifications d'examen aux étudiants
 */
public class EmailUtil {
    
    // Configuration chargée depuis le fichier properties
    private static Properties emailConfig;
    
    // Bloc static pour charger la configuration une seule fois
    static {
        emailConfig = new Properties();
        try {
            // Chargement du fichier de configuration depuis le classpath
            InputStream input = EmailUtil.class.getClassLoader()
                    .getResourceAsStream("config.properties");
            
            if (input != null) {
                emailConfig.load(input);
                input.close();
                System.out.println("Configuration email chargée avec succès");
            } else {
                System.err.println("Fichier config.properties non trouvé dans le classpath");
                // Configuration par défaut (à remplacer par vos valeurs)
                emailConfig.setProperty("mail.smtp.host", "smtp.gmail.com");
                emailConfig.setProperty("mail.smtp.port", "587");
                emailConfig.setProperty("mail.username", "votre.email@gmail.com");
                emailConfig.setProperty("mail.password", "votre-mot-de-passe");
                emailConfig.setProperty("mail.from", "votre.email@gmail.com");
            }
        } catch (Exception e) {
            System.err.println("Erreur lors du chargement de la configuration email: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Envoie un email récapitulatif de note à un étudiant
     * 
     * @param destinataire Adresse email de l'étudiant
     * @param nomEtudiant Nom complet de l'étudiant
     * @param note Note obtenue à l'examen (sur 10)
     * @param anneeUniv Année universitaire (ex: "2023-2024")
     * @throws MessagingException En cas d'erreur lors de l'envoi de l'email
     */
    public static void envoyerNote(String destinataire, String nomEtudiant, 
                                   int note, String anneeUniv) throws MessagingException {
        
        // Validation des paramètres
        if (destinataire == null || destinataire.trim().isEmpty()) {
            throw new MessagingException("L'adresse email du destinataire est vide");
        }
        
        if (nomEtudiant == null || nomEtudiant.trim().isEmpty()) {
            nomEtudiant = "Étudiant";
        }
        
        // 1. Configuration des propriétés SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", emailConfig.getProperty("mail.smtp.host"));
        props.put("mail.smtp.port", emailConfig.getProperty("mail.smtp.port"));
        props.put("mail.smtp.ssl.trust", emailConfig.getProperty("mail.smtp.host"));
        
        // 2. Création de la session avec authentification
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                    emailConfig.getProperty("mail.username"),
                    emailConfig.getProperty("mail.password")
                );
            }
        });
        
        // Pour le débogage (à désactiver en production)
        session.setDebug(true);
        
        // 3. Construction du message email
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(emailConfig.getProperty("mail.from")));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinataire));
        
        // Sujet de l'email
        message.setSubject("Résultat de votre examen QCM - " + anneeUniv);
        
        // 4. Construction du corps du message avec template personnalisé
        String contenu = construireMessage(nomEtudiant, note, anneeUniv);
        
        // Format HTML pour un meilleur rendu
        message.setContent(contenu, "text/html; charset=UTF-8");
        
        // 5. Envoi de l'email
        Transport.send(message);
        
        System.out.println("Email envoyé avec succès à " + destinataire);
    }
    
    /**
     * Construit le message HTML personnalisé selon la note obtenue
     * 
     * @param nomEtudiant Nom de l'étudiant
     * @param note Note obtenue (sur 10)
     * @param anneeUniv Année universitaire
     * @return Message HTML formaté
     */
    private static String construireMessage(String nomEtudiant, int note, String anneeUniv) {
        
        // Sélection du message d'encouragement/félicitations selon la note
        String messagePersonnalise;
        String emoji;
        
        if (note >= 8) {
            messagePersonnalise = "Félicitations ! C'est un excellent résultat qui démontre votre " +
                                 "maîtrise des concepts. Continuez sur cette lancée !";
            emoji = "🏆";
        } else if (note >= 6) {
            messagePersonnalise = "Bon travail ! Votre résultat est satisfaisant. " +
                                 "Avec un peu plus de révision, vous pouvez encore vous améliorer.";
            emoji = "👍";
        } else if (note >= 4) {
            messagePersonnalise = "Résultat moyen. Nous vous encourageons à revoir les cours " +
                                 "et à vous entraîner davantage pour progresser.";
            emoji = "📚";
        } else {
            messagePersonnalise = "Ce résultat est insuffisant. Nous vous recommandons de " +
                                 "reprendre les notions de base et de consulter vos professeurs " +
                                 "pour obtenir de l'aide supplémentaire.";
            emoji = "💪";
        }
        
        // Construction du template HTML
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "<meta charset='UTF-8'>" +
               "<style>" +
               "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
               ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
               ".header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px; }" +
               ".content { background-color: #f9f9f9; padding: 20px; border-radius: 5px; margin-top: 20px; }" +
               ".note { font-size: 48px; font-weight: bold; text-align: center; color: #4CAF50; margin: 20px 0; }" +
               ".message { background-color: #e8f5e9; padding: 15px; border-left: 4px solid #4CAF50; margin: 20px 0; }" +
               ".footer { font-size: 12px; text-align: center; margin-top: 20px; color: #999; }" +
               "</style>" +
               "</head>" +
               "<body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<h2>📝 Résultat d'examen QCM</h2>" +
               "</div>" +
               "<div class='content'>" +
               "<p>Bonjour <strong>" + nomEtudiant + "</strong>,</p>" +
               "<p>Nous vous informons des résultats de votre examen QCM pour l'année universitaire " +
               "<strong>" + anneeUniv + "</strong>.</p>" +
               "<div class='note'>" +
               note + " / 10" +
               "</div>" +
               "<div class='message'>" +
               emoji + " " + messagePersonnalise +
               "</div>" +
               "<p><strong>Détail :</strong></p>" +
               "<ul>" +
               "<li>Note obtenue : <strong>" + note + "/10</strong></li>" +
               "<li>Seuil de réussite : <strong>5/10</strong></li>" +
               "<li>Statut : <strong>" + (note >= 5 ? "✅ ADMIS" : "❌ NON ADMIS") + "</strong></li>" +
               "</ul>" +
               "<p>Consultez votre espace étudiant pour plus de détails et les corrections.</p>" +
               "<p>Cordialement,<br>" +
               "<strong>Administration de l'Établissement</strong></p>" +
               "</div>" +
               "<div class='footer'>" +
               "<p>Ce message est généré automatiquement, merci de ne pas y répondre.</p>" +
               "<p>&copy; 2024 - Système de Gestion d'Examens</p>" +
               "</div>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Méthode utilitaire pour tester la configuration email
     * @param testEmail Adresse email de test
     */
    public static void testerConfiguration(String testEmail) {
        try {
            envoyerNote(testEmail, "Test Utilisateur", 7, "2024-TEST");
            System.out.println("Email de test envoyé avec succès !");
        } catch (MessagingException e) {
            System.err.println("Échec de l'envoi de l'email de test : " + e.getMessage());
            e.printStackTrace();
        }
    }
}