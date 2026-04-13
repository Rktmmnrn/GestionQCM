package com.examen.servlet;

import com.examen.dao.EtudiantDAO;
import com.examen.model.Etudiant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet pour la gestion des étudiants (CRUD + recherche)
 */
@WebServlet("/etudiant")
public class EtudiantServlet extends HttpServlet {

    private EtudiantDAO etudiantDAO;

    @Override
    public void init() {
        etudiantDAO = new EtudiantDAO();
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
                deleteEtudiant(request, response);
                break;
            case "search":
                searchEtudiants(request, response);
                break;
            default:
                listEtudiants(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createEtudiant(request, response);
        } else if ("update".equals(action)) {
            updateEtudiant(request, response);
        }
    }

    private void listEtudiants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Etudiant> etudiants = etudiantDAO.findAll();
        request.setAttribute("etudiants", etudiants);
        request.getRequestDispatcher("/jsp/etudiant/liste.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/etudiant/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String numEtudiant = request.getParameter("id");
        if (numEtudiant == null) {
            response.sendRedirect("etudiant");
            return;
        }
        Etudiant etudiant = etudiantDAO.findById(numEtudiant);
        if (etudiant == null) {
            response.sendRedirect("etudiant?error=notFound");
            return;
        }
        request.setAttribute("etudiant", etudiant);
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/jsp/etudiant/form.jsp").forward(request, response);
    }

    private void createEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String numEtudiant = request.getParameter("numEtudiant");
        String nom = request.getParameter("nom");
        String prenoms = request.getParameter("prenoms");
        String niveau = request.getParameter("niveau");
        String email = request.getParameter("email");

        Etudiant etudiant = new Etudiant(numEtudiant, nom, prenoms, niveau, email);

        if (etudiantDAO.create(etudiant)) {
            response.sendRedirect("etudiant?success=created");
        } else {
            response.sendRedirect("etudiant?error=createFailed");
        }
    }

    private void updateEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String numEtudiant = request.getParameter("numEtudiant");
        String nom = request.getParameter("nom");
        String prenoms = request.getParameter("prenoms");
        String niveau = request.getParameter("niveau");
        String email = request.getParameter("email");

        Etudiant etudiant = new Etudiant(numEtudiant, nom, prenoms, niveau, email);

        if (etudiantDAO.update(etudiant)) {
            response.sendRedirect("etudiant?success=updated");
        } else {
            response.sendRedirect("etudiant?error=updateFailed");
        }
    }

    private void deleteEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String numEtudiant = request.getParameter("id");
        if (etudiantDAO.delete(numEtudiant)) {
            response.sendRedirect("etudiant?success=deleted");
        } else {
            response.sendRedirect("etudiant?error=deleteFailed");
        }
    }

    private void searchEtudiants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchType = request.getParameter("searchType");
        String searchValue = request.getParameter("searchValue");
        List<Etudiant> etudiants;

        if ("nom".equals(searchType)) {
            etudiants = etudiantDAO.findByNom(searchValue != null ? searchValue : "");
        } else if ("niveau".equals(searchType)) {
            etudiants = etudiantDAO.findByNiveau(searchValue != null ? searchValue : "");
        } else {
            etudiants = etudiantDAO.findAll();
        }

        request.setAttribute("etudiants", etudiants);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchValue", searchValue);
        request.getRequestDispatcher("/jsp/etudiant/liste.jsp").forward(request, response);
    }
}
