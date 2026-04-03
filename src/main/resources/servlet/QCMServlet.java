package com.examen.servlet;

import com.examen.dao.QCMDAO;
import com.examen.model.QCM;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour la gestion des questions QCM
 */
@WebServlet("/qcm")
public class QCMServlet extends HttpServlet {
    
    private QCMDAO qcmDAO;
    
    @Override
    public void init() {
        qcmDAO = new QCMDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteQuestion(request, response);
                break;
            default:
                listQuestions(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createQuestion(request, response);
        } else if ("update".equals(action)) {
            updateQuestion(request, response);
        }
    }
    
    /**
     * Affiche la liste de toutes les questions
     */
    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<QCM> questions = qcmDAO.findAll();
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/WEB-INF/views/qcm/list.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de création de question
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/qcm/form.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire d'édition de question
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        List<QCM> questions = qcmDAO.findAll();
        QCM question = questions.stream()
                .filter(q -> q.getNumQuest() == numQuest)
                .findFirst()
                .orElse(null);
        request.setAttribute("question", question);
        request.getRequestDispatcher("/WEB-INF/views/qcm/form.jsp").forward(request, response);
    }
    
    /**
     * Crée une nouvelle question
     */
    private void createQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int numQuest = Integer.parseInt(request.getParameter("numQuest"));
        String question = request.getParameter("question");
        String reponse1 = request.getParameter("reponse1");
        String reponse2 = request.getParameter("reponse2");
        String reponse3 = request.getParameter("reponse3");
        String reponse4 = request.getParameter("reponse4");
        int bonneRep = Integer.parseInt(request.getParameter("bonneRep"));
        
        QCM qcm = new QCM(numQuest, question, reponse1, reponse2, reponse3, reponse4, bonneRep);
        
        if (qcmDAO.create(qcm)) {
            response.sendRedirect("qcm?action=list&success=created");
        } else {
            response.sendRedirect("qcm?action=list&error=createFailed");
        }
    }
    
    /**
     * Met à jour une question existante
     */
    private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int numQuest = Integer.parseInt(request.getParameter("numQuest"));
        String question = request.getParameter("question");
        String reponse1 = request.getParameter("reponse1");
        String reponse2 = request.getParameter("reponse2");
        String reponse3 = request.getParameter("reponse3");
        String reponse4 = request.getParameter("reponse4");
        int bonneRep = Integer.parseInt(request.getParameter("bonneRep"));
        
        QCM qcm = new QCM(numQuest, question, reponse1, reponse2, reponse3, reponse4, bonneRep);
        
        if (qcmDAO.update(qcm)) {
            response.sendRedirect("qcm?action=list&success=updated");
        } else {
            response.sendRedirect("qcm?action=list&error=updateFailed");
        }
    }
    
    /**
     * Supprime une question
     */
    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        
        if (qcmDAO.delete(numQuest)) {
            response.sendRedirect("qcm?action=list&success=deleted");
        } else {
            response.sendRedirect("qcm?action=list&error=deleteFailed");
        }
    }
}