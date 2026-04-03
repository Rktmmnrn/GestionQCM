package com.examen.servlet;

import com.examen.dao.ExamenDAO;
import com.examen.dao.QCMDAO;
import com.examen.model.Examen;
import com.examen.model.QCM;
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
 * Servlet pour la gestion des examens (passage d'examen et calcul de note)
 */
@WebServlet("/examen")
public class ExamenServlet extends HttpServlet {
    
    private QCMDAO qcmDAO;
    private ExamenDAO examenDAO;
    
    @Override
    public void init() {
        qcmDAO = new QCMDAO();
        examenDAO = new ExamenDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "start";
        }
        
        switch (action) {
            case "start":
                startExamen(request, response);
                break;
            case "question":
                showQuestion(request, response);
                break;
            case "result":
                showResult(request, response);
                break;
            case "classement":
                showClassement(request, response);
                break;
            default:
                request.getRequestDispatcher("/WEB-INF/views/examen/start.jsp").forward(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("submitAnswer".equals(action)) {
            submitAnswer(request, response);
        } else if ("finish".equals(action)) {
            finishExamen(request, response);
        }
    }
    
    /**
     * Démarre un nouvel examen
     */
    private void startExamen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Récupère 10 questions aléatoires
        List<QCM> questions = qcmDAO.get10Random();
        
        // Initialise la session pour l'examen
        session.setAttribute("questions", questions);
        session.setAttribute("currentIndex", 0);
        session.setAttribute("reponses", new int[questions.size()]);
        session.setAttribute("numEtudiant", request.getParameter("numEtudiant"));
        session.setAttribute("anneeUniv", request.getParameter("anneeUniv"));
        
        response.sendRedirect("examen?action=question");
    }
    
    /**
     * Affiche la question courante
     */
    private void showQuestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Integer currentIndex = (Integer) session.getAttribute("currentIndex");
        List<QCM> questions = (List<QCM>) session.getAttribute("questions");
        
        if (currentIndex == null || questions == null || currentIndex >= questions.size()) {
            response.sendRedirect("examen?action=start");
            return;
        }
        
        QCM question = questions.get(currentIndex);
        request.setAttribute("question", question);
        request.setAttribute("currentIndex", currentIndex + 1);
        request.setAttribute("total", questions.size());
        
        request.getRequestDispatcher("/WEB-INF/views/examen/question.jsp").forward(request, response);
    }
    
    /**
     * Enregistre la réponse de l'étudiant
     */
    private void submitAnswer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        
        Integer currentIndex = (Integer) session.getAttribute("currentIndex");
        int[] reponses = (int[]) session.getAttribute("reponses");
        int reponse = Integer.parseInt(request.getParameter("reponse"));
        
        // Enregistre la réponse
        reponses[currentIndex] = reponse;
        session.setAttribute("reponses", reponses);
        
        // Passe à la question suivante
        currentIndex++;
        session.setAttribute("currentIndex", currentIndex);
        
        List<QCM> questions = (List<QCM>) session.getAttribute("questions");
        
        if (currentIndex < questions.size()) {
            response.sendRedirect("examen?action=question");
        } else {
            response.sendRedirect("examen?action=result");
        }
    }
    
    /**
     * Calcule et affiche le résultat de l'examen
     */
    private void showResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        List<QCM> questions = (List<QCM>) session.getAttribute("questions");
        int[] reponses = (int[]) session.getAttribute("reponses");
        
        // Calcule la note
        int note = 0;
        for (int i = 0; i < questions.size(); i++) {
            if (reponses[i] == questions.get(i).getBonneRep()) {
                note++;
            }
        }
        
        // Note sur 20
        note = note * 2;
        
        request.setAttribute("note", note);
        request.setAttribute("total", questions.size() * 2);
        request.setAttribute("details", calculateDetails(questions, reponses));
        
        request.getRequestDispatcher("/WEB-INF/views/examen/result.jsp").forward(request, response);
    }
    
    /**
     * Termine l'examen et sauvegarde dans la base de données
     */
    private void finishExamen(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        
        String numEtudiant = (String) session.getAttribute("numEtudiant");
        String anneeUniv = (String) session.getAttribute("anneeUniv");
        int note = Integer.parseInt(request.getParameter("note"));
        
        Examen examen = new Examen();
        examen.setNumEtudiant(numEtudiant);
        examen.setAnneeUniv(anneeUniv);
        examen.setNote(note);
        examen.setDateExamen(LocalDateTime.now());
        
        if (examenDAO.create(examen)) {
            session.invalidate();
            response.sendRedirect("examen?action=classement&success=examCompleted");
        } else {
            response.sendRedirect("examen?action=result&error=saveFailed");
        }
    }
    
    /**
     * Affiche le classement des étudiants
     */
    private void showClassement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Examen> classement = examenDAO.getClassement();
        request.setAttribute("classement", classement);
        request.getRequestDispatcher("/WEB-INF/views/examen/classement.jsp").forward(request, response);
    }
    
    /**
     * Calcule les détails des réponses pour l'affichage
     */
    private String[][] calculateDetails(List<QCM> questions, int[] reponses) {
        String[][] details = new String[questions.size()][3];
        
        for (int i = 0; i < questions.size(); i++) {
            QCM q = questions.get(i);
            details[i][0] = q.getQuestion();
            details[i][1] = q.getReponseByNum(reponses[i]);
            details[i][2] = (reponses[i] == q.getBonneRep()) ? "Correct" : "Incorrect";
        }
        
        return details;
    }
}