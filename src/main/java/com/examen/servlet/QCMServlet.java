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
        if (action == null) action = "list";

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

    private void listQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<QCM> questions = qcmDAO.findAll();
        request.setAttribute("questions", questions);  // "questions" pour liste.jsp
        request.getRequestDispatcher("/jsp/qcm/liste.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/qcm/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("qcm");
            return;
        }
        int numQuest = Integer.parseInt(idParam);
        QCM question = qcmDAO.findById(numQuest);
        request.setAttribute("question", question);
        request.getRequestDispatcher("/jsp/qcm/form.jsp").forward(request, response);
    }

    private void createQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String question = request.getParameter("question");
        String reponse1 = request.getParameter("reponse1");
        String reponse2 = request.getParameter("reponse2");
        String reponse3 = request.getParameter("reponse3");
        String reponse4 = request.getParameter("reponse4");
        int bonneRep = Integer.parseInt(request.getParameter("bonneRep"));

        // num_quest est AUTO_INCREMENT, on ne le passe pas
        QCM qcm = new QCM(0, question, reponse1, reponse2, reponse3, reponse4, bonneRep);

        if (qcmDAO.create(qcm)) {
            response.sendRedirect("qcm?success=created");
        } else {
            response.sendRedirect("qcm?error=createFailed");
        }
    }

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
            response.sendRedirect("qcm?success=updated");
        } else {
            response.sendRedirect("qcm?error=updateFailed");
        }
    }

    private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int numQuest = Integer.parseInt(request.getParameter("id"));
        if (qcmDAO.delete(numQuest)) {
            response.sendRedirect("qcm?success=deleted");
        } else {
            response.sendRedirect("qcm?error=deleteFailed");
        }
    }
}
