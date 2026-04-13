package com.examen.servlet;

import com.examen.dao.EtudiantDAO;
import com.examen.dao.ExamenDAO;
import com.examen.dao.QCMDAO;
import com.examen.model.Etudiant;
import com.examen.model.Examen;
import com.examen.model.QCM;
import com.examen.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour le passage d'examen QCM
 */
@WebServlet("/examen")
public class ExamenServlet extends HttpServlet {

    private QCMDAO qcmDAO;
    private ExamenDAO examenDAO;
    private EtudiantDAO etudiantDAO;

    @Override
    public void init() throws ServletException {
        qcmDAO = new QCMDAO();
        examenDAO = new ExamenDAO();
        etudiantDAO = new EtudiantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("start".equals(action)) {
            request.getRequestDispatcher("/jsp/examen/inscription.jsp").forward(request, response);
        } else if ("resultat".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("note") != null) {
                request.getRequestDispatcher("/jsp/examen/resultat.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/examen");
            }
        } else if ("classement".equals(action)) {
            List<Examen> classement = examenDAO.getClassement();
            request.setAttribute("classement", classement);
            request.getRequestDispatcher("/jsp/examen/classement.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/jsp/examen/accueil.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("demarrer".equals(action)) {
            demarrerExamen(request, response);
        } else if ("corriger".equals(action)) {
            corrigerExamen(request, response);
        }
    }

    /**
     * Démarre un examen : récupère 10 questions aléatoires, stocke en session
     */
    private void demarrerExamen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String numEtudiant = request.getParameter("numEtudiant");
        String anneeUniv = request.getParameter("anneeUniv");

        if (numEtudiant == null || numEtudiant.trim().isEmpty() ||
            anneeUniv == null || anneeUniv.trim().isEmpty()) {
            request.setAttribute("erreur", "Veuillez renseigner votre numéro étudiant et l'année universitaire.");
            request.getRequestDispatcher("/jsp/examen/inscription.jsp").forward(request, response);
            return;
        }

        // Vérifier que l'étudiant existe
        Etudiant etudiant = etudiantDAO.findById(numEtudiant.trim());
        if (etudiant == null) {
            request.setAttribute("erreur", "Numéro étudiant introuvable : " + numEtudiant);
            request.getRequestDispatcher("/jsp/examen/inscription.jsp").forward(request, response);
            return;
        }

        // Vérifier qu'il y a assez de questions
        int nbQuestions = qcmDAO.count();
        if (nbQuestions < 10) {
            request.setAttribute("erreur", "Pas assez de questions dans la base (" + nbQuestions + "/10 minimum).");
            request.getRequestDispatcher("/jsp/examen/inscription.jsp").forward(request, response);
            return;
        }

        List<QCM> questions = qcmDAO.get10Random();

        HttpSession session = request.getSession();
        session.setAttribute("questions", questions);
        session.setAttribute("numEtudiant", numEtudiant.trim());
        session.setAttribute("anneeUniv", anneeUniv.trim());
        session.setAttribute("nomEtudiant", etudiant.getPrenoms() + " " + etudiant.getNom());
        session.setAttribute("emailEtudiant", etudiant.getAdrEmail());

        request.getRequestDispatcher("/jsp/examen/passage.jsp").forward(request, response);
    }

    /**
     * Corrige l'examen, calcule la note, sauvegarde en BD, envoie email
     */
    @SuppressWarnings("unchecked")
    private void corrigerExamen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("questions") == null) {
            response.sendRedirect(request.getContextPath() + "/examen?action=start");
            return;
        }

        List<QCM> questions = (List<QCM>) session.getAttribute("questions");
        String numEtudiant = (String) session.getAttribute("numEtudiant");
        String anneeUniv = (String) session.getAttribute("anneeUniv");
        String nomEtudiant = (String) session.getAttribute("nomEtudiant");
        String emailEtudiant = (String) session.getAttribute("emailEtudiant");

        int nbBonnes = 0;
        // détails[i] = {question, réponse donnée, statut, bonne réponse}
        String[][] details = new String[questions.size()][4];

        for (int i = 0; i < questions.size(); i++) {
            QCM q = questions.get(i);
            String param = request.getParameter("question_" + i);
            details[i][0] = q.getQuestion();

            if (param != null && !param.isEmpty()) {
                int rep = Integer.parseInt(param);
                details[i][1] = q.getReponseByNum(rep);
                details[i][3] = q.getReponseByNum(q.getBonneRep());
                if (rep == q.getBonneRep()) {
                    nbBonnes++;
                    details[i][2] = "correct";
                } else {
                    details[i][2] = "incorrect";
                }
            } else {
                details[i][1] = "Sans réponse";
                details[i][2] = "absent";
                details[i][3] = q.getReponseByNum(q.getBonneRep());
            }
        }

        // Note sur 10
        int note = (nbBonnes * 10) / questions.size();

        // Sauvegarder en BD
        Examen examen = new Examen();
        examen.setNumEtudiant(numEtudiant);
        examen.setAnneeUniv(anneeUniv);
        examen.setNote(note);
        boolean saved = examenDAO.create(examen);
        if (!saved) {
            System.err.println("Erreur sauvegarde examen pour " + numEtudiant);
        }

        // Envoyer email
        if (emailEtudiant != null && !emailEtudiant.isEmpty()) {
            try {
                EmailUtil.envoyerNote(emailEtudiant, nomEtudiant, note, anneeUniv);
            } catch (Exception e) {
                System.err.println("Erreur envoi email : " + e.getMessage());
            }
        }

        // Stocker résultats en session
        session.setAttribute("note", note);
        session.setAttribute("nbBonnes", nbBonnes);
        session.setAttribute("totalQuestions", questions.size());
        session.setAttribute("details", details);
        // Effacer les questions pour éviter de repasser
        session.removeAttribute("questions");

        response.sendRedirect(request.getContextPath() + "/examen?action=resultat");
    }
}
