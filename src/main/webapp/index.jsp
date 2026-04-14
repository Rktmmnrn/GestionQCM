<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.examen.dao.EtudiantDAO, com.examen.dao.QCMDAO, com.examen.dao.ExamenDAO" %>
<%@ page import="com.examen.model.Examen" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setAttribute("currentPage", "home");
    EtudiantDAO eDAO = new EtudiantDAO();
    QCMDAO qDAO = new QCMDAO();
    ExamenDAO exDAO = new ExamenDAO();

    int nbEtudiants = eDAO.findAll().size();
    int nbQuestions = qDAO.count();
    List<Examen> tousExamens = exDAO.findAll();
    int nbExamens = tousExamens.size();
    double moyenne = 0;
    if (nbExamens > 0) {
        int sum = 0;
        for (Examen e : tousExamens) sum += e.getNote();
        moyenne = Math.round((sum * 10.0 / nbExamens)) / 10.0;
    }
    List<Examen> classement = exDAO.getClassement();
    // Top 5
    int top = Math.min(5, classement.size());
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil — GestionExamens</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                🏠 <span class="topbar-breadcrumb">Tableau de bord</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">✏️ Démarrer un examen</a>
            </div>
        </div>

        <div class="page-body">

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card blue">
                    <div class="stat-label">Étudiants inscrits</div>
                    <div class="stat-value"><%= nbEtudiants %></div>
                    <div class="stat-sub"><a href="${pageContext.request.contextPath}/etudiant" style="color:var(--info);text-decoration:none;font-size:0.75rem;">Voir la liste →</a></div>
                </div>
                <div class="stat-card green">
                    <div class="stat-label">Questions QCM</div>
                    <div class="stat-value"><%= nbQuestions %></div>
                    <div class="stat-sub"><a href="${pageContext.request.contextPath}/qcm" style="color:var(--accent);text-decoration:none;font-size:0.75rem;">Gérer →</a></div>
                </div>
                <div class="stat-card amber">
                    <div class="stat-label">Examens passés</div>
                    <div class="stat-value"><%= nbExamens %></div>
                    <div class="stat-sub"><a href="${pageContext.request.contextPath}/examen?action=classement" style="color:var(--warn);text-decoration:none;font-size:0.75rem;">Classement →</a></div>
                </div>
                <div class="stat-card <%= moyenne >= 5 ? "green" : "red" %>">
                    <div class="stat-label">Moyenne générale</div>
                    <div class="stat-value"><%= nbExamens > 0 ? moyenne : "—" %></div>
                    <div class="stat-sub">Note sur 10</div>
                </div>
            </div>

            <!-- Grille principale -->
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;">

                <!-- Actions rapides -->
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">⚡ Actions rapides</span>
                    </div>
                    <div class="card-body" style="display:flex;flex-direction:column;gap:10px;">
                        <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary w-full" style="justify-content:center;">
                            ✏️ Passer un examen QCM
                        </a>
                        <a href="${pageContext.request.contextPath}/etudiant?action=new" class="btn btn-ghost w-full" style="justify-content:center;">
                            👤 Ajouter un étudiant
                        </a>
                        <a href="${pageContext.request.contextPath}/qcm?action=new" class="btn btn-ghost w-full" style="justify-content:center;">
                            ❓ Ajouter une question QCM
                        </a>
                        <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn btn-ghost w-full" style="justify-content:center;">
                            🏆 Voir le classement
                        </a>
                    </div>
                </div>

                <!-- Infos système -->
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">ℹ️ État du système</span>
                    </div>
                    <div class="card-body">
                        <table class="data-table">
                            <tr>
                                <td class="text-muted text-sm">Base de données</td>
                                <td><span class="badge badge-green">✓ Connectée</span></td>
                            </tr>
                            <tr>
                                <td class="text-muted text-sm">Questions disponibles</td>
                                <td>
                                    <% if (nbQuestions >= 10) { %>
                                        <span class="badge badge-green"><%= nbQuestions %> / 10 min ✓</span>
                                    <% } else { %>
                                        <span class="badge badge-red"><%= nbQuestions %> / 10 min ✗</span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted text-sm">Email SMTP</td>
                                <td><span class="badge badge-blue">Gmail TLS</span></td>
                            </tr>
                            <tr>
                                <td class="text-muted text-sm">Durée examen</td>
                                <td><span class="badge badge-gray">15 minutes</span></td>
                            </tr>
                            <tr>
                                <td class="text-muted text-sm">Seuil de réussite</td>
                                <td><span class="badge badge-gray">5 / 10</span></td>
                            </tr>
                        </table>
                        <div style="margin-top:14px;">
                            <a href="${pageContext.request.contextPath}/diagnostic.jsp" class="btn btn-ghost btn-sm">🔧 Diagnostic complet</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Derniers résultats -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">📊 Derniers résultats</span>
                    <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn btn-ghost btn-sm">Voir tout</a>
                </div>
                <% if (top == 0) { %>
                <div class="empty-state">
                    <div class="empty-icon">📋</div>
                    <h3>Aucun examen passé</h3>
                    <p>Les résultats apparaîtront ici après le premier examen.</p>
                    <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">Passer le premier examen</a>
                </div>
                <% } else { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Rang</th>
                            <th>Étudiant</th>
                            <th>Numéro</th>
                            <th>Année univ.</th>
                            <th>Note</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < top; i++) {
                            Examen ex = classement.get(i);
                            boolean admis = ex.getNote() >= 5;
                        %>
                        <tr>
                            <td class="mono text-muted">#<%= i+1 %></td>
                            <td style="font-weight:600;"><%= ex.getNomComplet() %></td>
                            <td class="mono"><span class="badge badge-blue"><%= ex.getNumEtudiant() %></span></td>
                            <td class="text-muted"><%= ex.getAnneeUniv() %></td>
                            <td style="font-weight:700;font-family:'DM Mono',monospace;"><%= ex.getNote() %>/10</td>
                            <td><span class="badge <%= admis ? "badge-green" : "badge-red" %>"><%= admis ? "Admis" : "Refusé" %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>

        </div>
    </div>
</div>

<script>
// Mobile sidebar toggle
document.addEventListener('DOMContentLoaded', () => {
    const toggle = document.querySelector('.sidebar-toggle');
    if (toggle) {
        toggle.addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('open');
        });
    }
});
</script>
</body>
</html>
