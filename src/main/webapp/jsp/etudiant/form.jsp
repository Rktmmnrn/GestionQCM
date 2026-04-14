<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("currentPage", Boolean.TRUE.equals(request.getAttribute("editMode")) ? "etudiants" : "etudiant-new"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${editMode ? 'Modifier' : 'Ajouter'} étudiant — GestionQuestionnaire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggle = document.getElementById('menu-toggle');
            const sidebar = document.getElementById('sidebar');
            if (toggle && sidebar) {
                toggle.addEventListener('click', function() {
                    sidebar.classList.toggle('open');
                    if (sidebar.classList.contains('open')) {
                        document.body.classList.add('sidebar-open');
                    } else {
                        document.body.classList.remove('sidebar-open');
                    }
                });
                document.addEventListener('click', function(e) {
                    if (!sidebar.contains(e.target) && !toggle.contains(e.target) && sidebar.classList.contains('open')) {
                        sidebar.classList.remove('open');
                        document.body.classList.remove('sidebar-open');
                    }
                });
            }
        });
    </script>
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                👥 Étudiants
                <span class="topbar-breadcrumb">/ ${editMode ? 'Modifier' : 'Ajouter'}</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/etudiant" class="btn btn-ghost">← Liste</a>
            </div>
        </div>

        <div class="page-body">
            <c:if test="${not empty param.error}">
                <div class="alert alert-error">
                    ❌
                    <c:choose>
                        <c:when test="${param.error == 'createFailed'}">Erreur : le numéro étudiant ou l'email existe peut-être déjà.</c:when>
                        <c:otherwise>Une erreur est survenue.</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div style="max-width:560px;">
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">${editMode ? '✏️ Modifier l\'étudiant' : '➕ Nouvel étudiant'}</span>
                        <c:if test="${editMode}">
                            <span class="badge badge-blue">${etudiant.numEtudiant}</span>
                        </c:if>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="${pageContext.request.contextPath}/etudiant">
                            <input type="hidden" name="action" value="${editMode ? 'update' : 'create'}">

                            <div class="form-group">
                                <label class="form-label">Numéro étudiant <span class="required">*</span></label>
                                <input type="text" name="numEtudiant" class="form-control"
                                       placeholder="Ex: E001001"
                                       value="${editMode ? etudiant.numEtudiant : ''}"
                                       ${editMode ? 'readonly style="opacity:0.6;cursor:not-allowed;"' : ''}
                                       required>
                                <div class="form-hint">Format recommandé : E + 6 chiffres</div>
                            </div>

                            <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">
                                <div class="form-group">
                                    <label class="form-label">Nom <span class="required">*</span></label>
                                    <input type="text" name="nom" class="form-control"
                                           placeholder="Ex: Dupont"
                                           value="${editMode ? etudiant.nom : ''}" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Prénoms <span class="required">*</span></label>
                                    <input type="text" name="prenoms" class="form-control"
                                           placeholder="Ex: Jean Marie"
                                           value="${editMode ? etudiant.prenoms : ''}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email <span class="required">*</span></label>
                                <input type="email" name="email" class="form-control"
                                       placeholder="Ex: jean.dupont@example.com"
                                       value="${editMode ? etudiant.adrEmail : ''}" required>
                                <div class="form-hint">Doit être unique dans le système — utilisé pour recevoir les résultats d'examen</div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Niveau <span class="required">*</span></label>
                                <select name="niveau" class="form-control" required>
                                    <option value="">— Sélectionnez —</option>
                                    <c:forEach var="niv" items="${['L1','L2','L3','M1','M2']}">
                                        <option value="${niv}" ${(editMode && etudiant.niveau == niv) ? 'selected' : ''}>${niv}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div style="display:flex;gap:10px;margin-top:8px;">
                                <button type="submit" class="btn btn-primary">
                                    ${editMode ? '💾 Enregistrer' : '➕ Ajouter'}
                                </button>
                                <a href="${pageContext.request.contextPath}/etudiant" class="btn btn-ghost">Annuler</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
