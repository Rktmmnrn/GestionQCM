package com.examen.servlet;

import com.examen.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet de test pour l'envoi d'emails
 * Permet de tester la configuration SMTP avant l'intégration complète
 */
@WebServlet("/email")
public class EmailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("test".equals(action)) {
            // Affiche le formulaire de test
            afficherFormulaireTest(request, response);
        } else if ("envoyer".equals(action)) {
            // Envoie un email de test
            envoyerEmailTest(request, response);
        } else {
            // Page d'accueil par défaut
            response.sendRedirect(request.getContextPath() + "/email?action=test");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("envoyerTest".equals(action)) {
            envoyerEmailTest(request, response);
        } else if ("envoyerResultat".equals(action)) {
            envoyerResultatExamen(request, response);
        }
    }
    
    /**
     * Affiche le formulaire de test d'envoi d'email
     */
    private void afficherFormulaireTest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Test d'envoi d'emails</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }");
        out.println(".container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #667eea; text-align: center; }");
        out.println(".form-group { margin-bottom: 20px; }");
        out.println("label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }");
        out.println("input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }");
        out.println("button { background: #667eea; color: white; padding: 12px 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; width: 100%; }");
        out.println("button:hover { background: #764ba2; }");
        out.println(".info { background: #e8f5e9; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #4CAF50; }");
        out.println(".error { background: #ffebee; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #f44336; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>📧 Test d'envoi d'emails</h1>");
        
        // Message de succès ou d'erreur
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        if (success != null) {
            out.println("<div class='info'>✅ " + success + "</div>");
        }
        if (error != null) {
            out.println("<div class='error'>❌ " + error + "</div>");
        }
        
        out.println("<form action='email' method='post'>");
        out.println("<input type='hidden' name='action' value='envoyerTest'>");
        
        out.println("<div class='form-group'>");
        out.println("<label for='email'>Email du destinataire :</label>");
        out.println("<input type='email' id='email' name='email' required placeholder='exemple@email.com'>");
        out.println("</div>");
        
        out.println("<div class='form-group'>");
        out.println("<label for='nom'>Nom de l'étudiant :</label>");
        out.println("<input type='text' id='nom' name='nom' required placeholder='Jean Dupont'>");
        out.println("</div>");
        
        out.println("<div class='form-group'>");
        out.println("<label for='note'>Note :</label>");
        out.println("<select id='note' name='note'>");
        for (int i = 0; i <= 10; i++) {
            out.println("<option value='" + i + "'>" + i + "/10</option>");
        }
        out.println("</select>");
        out.println("</div>");
        
        out.println("<div class='form-group'>");
        out.println("<label for='annee'>Année universitaire :</label>");
        out.println("<input type='text' id='annee' name='annee' value='2024-2025' required>");
        out.println("</div>");
        
        out.println("<button type='submit'>📨 Envoyer l'email de test</button>");
        out.println("</form>");
        
        out.println("<br><hr><br>");
        
        out.println("<h3>ℹ️ Configuration requise pour Gmail :</h3>");
        out.println("<ul>");
        out.println("<li>Activez l'authentification à deux facteurs sur votre compte Gmail</li>");
        out.println("<li>Créez un mot de passe d'application : https://myaccount.google.com/apppasswords</li>");
        out.println("<li>Utilisez ce mot de passe dans le fichier config.properties</li>");
        out.println("</ul>");
        
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    /**
     * Envoie un email de test
     */
    private void envoyerEmailTest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String email = request.getParameter("email");
        String nom = request.getParameter("nom");
        int note = Integer.parseInt(request.getParameter("note"));
        String annee = request.getParameter("annee");
        
        try {
            // Envoi de l'email
            EmailUtil.envoyerNote(email, nom, note, annee);
            
            // Redirection avec message de succès
            response.sendRedirect(request.getContextPath() + 
                "/email?action=test&success=Email envoyé avec succès à " + email);
                
        } catch (Exception e) {
            // Redirection avec message d'erreur
            response.sendRedirect(request.getContextPath() + 
                "/email?action=test&error=Erreur: " + e.getMessage());
        }
    }
    
    /**
     * Envoie le résultat d'un examen (intégration avec ExamenServlet)
     */
    private void envoyerResultatExamen(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String email = request.getParameter("email");
        String nom = request.getParameter("nom");
        int note = Integer.parseInt(request.getParameter("note"));
        String annee = request.getParameter("annee");
        
        try {
            EmailUtil.envoyerNote(email, nom, note, annee);
            
            // Réponse JSON pour AJAX
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": true, \"message\": \"Email envoyé avec succès\"}");
            
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}