package com.examen.servlet;

import com.examen.dao.ExamenDAO;
import com.examen.dao.QCMDAO;
import com.examen.model.Examen;
import com.examen.model.QCM;
import com.examen.util.EmailUtil;
import com.examen.util.DBConnexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Servlet pour le passage d'examen QCM
 * Gère le déroulement complet d'un examen : 
 * - sélection aléatoire des questions
 * - stockage en session
 * - correction automatique
 * - calcul de note
 * - sauvegarde en base de données
 * - envoi d'email récapitulatif
 */
@WebServlet("/examen")
public class ExamenServlet extends HttpServlet {
    
    private QCMDAO qcmDAO;
    private ExamenDAO examenDAO;
    
    @Override
    public void init() throws ServletException {
        // Initialisation des DAO
        qcmDAO = new QCMDAO();
        examenDAO = new ExamenDAO();
    }
    
    /**
     * Méthode GET - Affiche le formulaire de démarrage d'examen
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Si c'est une demande de démarrage d'examen
        if ("start".equals(action)) {
            // Affiche le formulaire de saisie des informations étudiant
            request.getRequestDispatcher("/jsp/examen/inscription.jsp")
                   .forward(request, response);
        } 
        // Si c'est une demande de résultat après examen
        else if ("resultat".equals(action)) {
            // Affiche le résultat de l'examen (récupéré depuis la session)
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("note") != null) {
                request.setAttribute("note", session.getAttribute("note"));
                request.setAttribute("total", session.getAttribute("total"));
                request.setAttribute("details", session.getAttribute("details"));
                request.getRequestDispatcher("/jsp/examen/resultat.jsp")
                       .forward(request, response);
            } else {
                // Pas de résultat en session, retour à l'accueil
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
        else {
            // Par défaut, affiche la page d'accueil de l'examen
            request.getRequestDispatcher("/jsp/examen/accueil.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * Méthode POST - Traite les soumissions d'examen
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // ÉTAPE 1 : Démarrer un nouvel examen (générer les questions)
        if ("demarrer".equals(action)) {
            demarrerExamen(request, response);
        } 
        // ÉTAPE 2 : Soumettre les réponses et corriger l'examen
        else if ("corriger".equals(action)) {
            corrigerExamen(request, response);
        }
    }
    
    /**
     * Démarre un nouvel examen
     * 1. Récupère 10 questions aléatoires
     * 2. Stocke les informations en session
     * 3. Redirige vers la page de passage d'examen
     */
    private void demarrerExamen(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération des informations de l'étudiant depuis le formulaire
        String numEtudiant = request.getParameter("numEtudiant");
        String anneeUniv = request.getParameter("anneeUniv");
        
        // Validation des données d'entrée
        if (numEtudiant == null || numEtudiant.trim().isEmpty() ||
            anneeUniv == null || anneeUniv.trim().isEmpty()) {
            request.setAttribute("erreur", "Veuillez fournir votre numéro étudiant et l'année universitaire");
            request.getRequestDispatcher("/jsp/examen/inscription.jsp")
                   .forward(request, response);
            return;
        }
        
        // 1. Récupération de 10 questions aléatoires depuis la base de données
        List<QCM> questions = qcmDAO.get10Random();
        
        // Vérification qu'il y a assez de questions dans la base
        if (questions == null || questions.size() < 10) {
            request.setAttribute("erreur", "Pas assez de questions disponibles dans la base de données. " +
                                          "Veuillez ajouter au moins 10 questions QCM.");
            request.getRequestDispatcher("/jsp/examen/inscription.jsp")
                   .forward(request, response);
            return;
        }
        
        // 2. Stockage des informations dans la session HttpSession
        HttpSession session = request.getSession();
        session.setAttribute("questions", questions);          // Liste des questions
        session.setAttribute("numEtudiant", numEtudiant);      // Numéro étudiant
        session.setAttribute("anneeUniv", anneeUniv);          // Année universitaire
        session.setAttribute("reponses", new Integer[10]);     // Tableau pour stocker les réponses (initialisé à null)
        session.setAttribute("indexCourant", 0);               // Index de la question en cours
        
        // Redirection vers la première question
        request.getRequestDispatcher("/jsp/examen/passage.jsp")
               .forward(request, response);
    }
    
    /**
     * Corrige l'examen et calcule la note
     * 1. Récupère les réponses du formulaire
     * 2. Compare chaque réponse avec la bonne réponse
     * 3. Calcule la note
     * 4. Sauvegarde dans la base de données
     * 5. Envoie l'email récapitulatif
     * 6. Stocke le résultat en session
     */
    private void corrigerExamen(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupération de la session
        HttpSession session = request.getSession(false);
        
        // Vérification que la session existe et contient les questions
        if (session == null || session.getAttribute("questions") == null) {
            response.sendRedirect(request.getContextPath() + "/examen?action=start");
            return;
        }
        
        // Récupération des données de la session
        @SuppressWarnings("unchecked")
        List<QCM> questions = (List<QCM>) session.getAttribute("questions");
        String numEtudiant = (String) session.getAttribute("numEtudiant");
        String anneeUniv = (String) session.getAttribute("anneeUniv");
        
        // Variable pour compter le nombre de bonnes réponses
        int nbBonnesReponses = 0;
        
        // Tableau pour stocker les détails des réponses (pour affichage)
        String[][] detailsReponses = new String[questions.size()][3];
        
        // 1. Parcours de toutes les questions pour comparer les réponses
        for (int i = 0; i < questions.size(); i++) {
            QCM question = questions.get(i);
            
            // Récupération de la réponse soumise par l'étudiant
            String reponseParam = request.getParameter("question_" + i);
            
            // Si l'étudiant a répondu à la question
            if (reponseParam != null && !reponseParam.isEmpty()) {
                int reponseEtudiant = Integer.parseInt(reponseParam);
                
                // 2. Comparaison avec la bonne réponse (bonne_rep)
                if (reponseEtudiant == question.getBonneRep()) {
                    nbBonnesReponses++;
                    detailsReponses[i][2] = "Correcte";
                } else {
                    detailsReponses[i][2] = "Incorrecte (Bonne réponse: " + 
                                            question.getReponseByNum(question.getBonneRep()) + ")";
                }
                
                // Stockage des détails pour l'affichage
                detailsReponses[i][0] = question.getQuestion();
                detailsReponses[i][1] = question.getReponseByNum(reponseEtudiant);
            } else {
                // L'étudiant n'a pas répondu à cette question
                detailsReponses[i][2] = "Non répondue";
                detailsReponses[i][0] = question.getQuestion();
                detailsReponses[i][1] = "Aucune réponse";
            }
        }
        
        // 3. Calcul de la note : (nombre bonnes réponses / 10) * 10
        // Note sur 10 (peut être ajustée sur 20 en multipliant par 2)
        int note = (nbBonnesReponses * 10) / questions.size();
        
        // 4. Sauvegarde de l'examen dans la table EXAMEN via ExamenDAO
        Examen examen = new Examen();
        examen.setNumEtudiant(numEtudiant);
        examen.setAnneeUniv(anneeUniv);
        examen.setNote(note);
        examen.setDateExamen(LocalDateTime.now());
        
        boolean sauvegardeReussie = examenDAO.create(examen);
        
        if (!sauvegardeReussie) {
            System.err.println("Erreur lors de la sauvegarde de l'examen pour l'étudiant: " + numEtudiant);
        }
        
        // 5. Envoi de l'email récapitulatif
        // Récupération de l'email de l'étudiant (à adapter selon votre logique métier)
        String emailEtudiant = recupererEmailEtudiant(numEtudiant);
        String nomEtudiant = recupererNomEtudiant(numEtudiant);
        
        if (emailEtudiant != null && !emailEtudiant.isEmpty()) {
            try {
                EmailUtil.envoyerNote(emailEtudiant, nomEtudiant, note, anneeUniv);
                System.out.println("Email envoyé avec succès à: " + emailEtudiant);
            } catch (Exception e) {
                System.err.println("Erreur lors de l'envoi de l'email: " + e.getMessage());
                e.printStackTrace();
                // L'échec de l'email n'empêche pas l'examen de se terminer
            }
        } else {
            System.err.println("Impossible d'envoyer l'email: adresse email non trouvée pour l'étudiant " + numEtudiant);
        }
        
        // 6. Stockage du résultat en session pour affichage
        session.setAttribute("note", note);
        session.setAttribute("total", questions.size() * 10 / questions.size()); // Note maximale
        session.setAttribute("details", detailsReponses);
        session.setAttribute("nbBonnesReponses", nbBonnesReponses);
        session.setAttribute("totalQuestions", questions.size());
        
        // Redirection vers la page des résultats
        response.sendRedirect(request.getContextPath() + "/examen?action=resultat");
    }
    
    /**
     * Récupère l'adresse email d'un étudiant à partir de son numéro
     * @param numEtudiant Numéro de l'étudiant
     * @return Adresse email ou null si non trouvée
     */
    private String recupererEmailEtudiant(String numEtudiant) {
        // À implémenter selon votre structure - vous pouvez utiliser EtudiantDAO
        // Exemple temporaire - à remplacer par votre vraie implémentation
        try {
            // Utilisation de EtudiantDAO pour récupérer l'étudiant
            com.examen.dao.EtudiantDAO etudiantDAO = new com.examen.dao.EtudiantDAO();
            com.examen.model.Etudiant etudiant = etudiantDAO.findById(numEtudiant);
            if (etudiant != null) {
                return etudiant.getAdrEmail();
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération de l'email: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Récupère le nom complet d'un étudiant
     * @param numEtudiant Numéro de l'étudiant
     * @return Nom complet ou "Étudiant" si non trouvé
     */
    private String recupererNomEtudiant(String numEtudiant) {
        // À implémenter selon votre structure
        try {
            com.examen.dao.EtudiantDAO etudiantDAO = new com.examen.dao.EtudiantDAO();
            com.examen.model.Etudiant etudiant = etudiantDAO.findById(numEtudiant);
            if (etudiant != null) {
                return etudiant.getPrenoms() + " " + etudiant.getNom();
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération du nom: " + e.getMessage());
        }
        return "Cher étudiant";
    }
}