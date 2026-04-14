<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.examen.dao.QCMDAO" %>
<% 
    request.setAttribute("currentPage", "examen");
    QCMDAO qDAO = new QCMDAO();
    int nbQ = qDAO.count();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Examen QCM — GestionExamens</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                ✏️ Examen QCM <span class="topbar-breadcrumb">/ Accueil</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn btn-ghost">🏆 Classement</a>
            </div>
        </div>

        <div class="page-body">
            <div style="max-width:640px;margin:0 auto;">

                <% if (nbQ < 10) { %>
                <div class="alert alert-warn" style="margin-bottom:20px;">
                    ⚠️ Seulement <%= nbQ %> question(s) dans la banque. Il en faut au moins <strong>10</strong> pour passer un examen.
                    <a href="<%= request.getContextPath() %>/qcm?action=new" style="color:var(--warn);font-weight:600;margin-left:8px;">Ajouter des questions →</a>
                </div>
                <% } %>

                <div class="card mb-6">
                    <div class="card-header">
                        <span class="card-title">📋 Informations sur l'examen</span>
                    </div>
                    <div class="card-body">
                        <div class="stats-row" style="margin-bottom:0;">
                            <div class="stat-card blue">
                                <div class="stat-label">Questions</div>
                                <div class="stat-value">10</div>
                                <div class="stat-sub">tirées au sort</div>
                            </div>
                            <div class="stat-card amber">
                                <div class="stat-label">Durée</div>
                                <div class="stat-value">15</div>
                                <div class="stat-sub">minutes</div>
                            </div>
                            <div class="stat-card green">
                                <div class="stat-label">Note max</div>
                                <div class="stat-value">10</div>
                                <div class="stat-sub">seuil : 5/10</div>
                            </div>
                            <div class="stat-card <%= nbQ >= 10 ? "green" : "red" %>">
                                <div class="stat-label">Disponibles</div>
                                <div class="stat-value"><%= nbQ %></div>
                                <div class="stat-sub"><%= nbQ >= 10 ? "✓ OK" : "✗ Insuffisant" %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <span class="card-title">🚀 Commencer un examen</span>
                    </div>
                    <div class="card-body">
                        <% if (nbQ < 10) { %>
                            <p class="text-muted text-sm" style="margin-bottom:16px;">
                                L'examen ne peut pas démarrer — il manque des questions dans la banque.
                            </p>
                            <a href="<%= request.getContextPath() %>/qcm?action=new" class="btn btn-primary">➕ Ajouter des questions</a>
                        <% } else { %>
                            <p class="text-muted text-sm" style="margin-bottom:16px;">
                                Entrez votre numéro étudiant et l'année universitaire pour démarrer l'examen.
                                Vous recevrez vos résultats par email à la fin.
                            </p>
                            <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary" style="font-size:1rem;padding:12px 28px;">
                                ✏️ Démarrer l'examen
                            </a>
                        <% } %>
                    </div>
                </div>

                <div style="margin-top:14px;">
                    <div class="card">
                        <div class="card-body" style="padding:14px 18px;">
                            <div class="text-muted text-sm" style="font-weight:600;margin-bottom:8px;">📌 Règles de l'examen</div>
                            <ul style="margin:0;padding-left:18px;color:var(--text3);font-size:0.82rem;line-height:2;">
                                <li>Une seule réponse correcte par question</li>
                                <li>Le timer démarre immédiatement après le début</li>
                                <li>La soumission est automatique à la fin du temps</li>
                                <li>Vos résultats sont envoyés par email à votre adresse enregistrée</li>
                                <li>Votre note est enregistrée dans le classement général</li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
</body>
</html>
