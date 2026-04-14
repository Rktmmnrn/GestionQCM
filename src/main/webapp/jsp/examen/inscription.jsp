<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("currentPage", "examen"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription examen — GestionExamens</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                ✏️ Examen <span class="topbar-breadcrumb">/ Inscription</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/examen" class="btn btn-ghost">← Retour</a>
            </div>
        </div>

        <div class="page-body">
            <div style="max-width:440px;margin:0 auto;">

                <c:if test="${not empty erreur}">
                    <div class="alert alert-error">⚠️ ${erreur}</div>
                </c:if>

                <div class="card">
                    <div class="card-header">
                        <span class="card-title">📋 Vos informations</span>
                    </div>
                    <div class="card-body">
                        <p class="text-muted text-sm" style="margin-bottom:20px;">
                            Renseignez votre numéro étudiant pour démarrer l'examen. 
                            Vos résultats seront envoyés à l'email associé à votre compte.
                        </p>

                        <form method="POST" action="${pageContext.request.contextPath}/examen">
                            <input type="hidden" name="action" value="demarrer">

                            <div class="form-group">
                                <label class="form-label">Numéro étudiant <span class="required">*</span></label>
                                <input type="text" name="numEtudiant" class="form-control"
                                       placeholder="Ex: E001001" required
                                       value="${param.numEtudiant}"
                                       autofocus>
                                <div class="form-hint">Votre identifiant unique — doit exister dans la base</div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Année universitaire <span class="required">*</span></label>
                                <input type="text" name="anneeUniv" class="form-control"
                                       placeholder="Ex: 2024-2025" required
                                       pattern="\d{4}-\d{4}"
                                       value="${not empty param.anneeUniv ? param.anneeUniv : '2024-2025'}">
                                <div class="form-hint">Format : AAAA-AAAA</div>
                            </div>

                            <div class="alert alert-info" style="margin-bottom:18px;">
                                ℹ️ 10 questions seront sélectionnées aléatoirement. Durée : <strong>15 minutes</strong>.
                            </div>

                            <button type="submit" class="btn btn-primary w-full" style="justify-content:center;padding:11px;">
                                🚀 Démarrer l'examen
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
