<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("currentPage", "etudiants"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Étudiants — GestionQuestionnaire</title>
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
            <button class="sidebar-toggle" id="menu-toggle" title="Afficher/masquer le menu">☰</button>
            <div class="topbar-title">
                👥 Étudiants <span class="topbar-breadcrumb">/ Liste</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/etudiant?action=new" class="btn btn-primary">➕ Ajouter</a>
            </div>
        </div>

        <div class="page-body">

            <!-- Alertes -->
            <c:if test="${param.success == 'created'}"><div class="alert alert-success">✅ Étudiant ajouté avec succès.</div></c:if>
            <c:if test="${param.success == 'updated'}"><div class="alert alert-success">✅ Étudiant modifié avec succès.</div></c:if>
            <c:if test="${param.success == 'deleted'}"><div class="alert alert-success">✅ Étudiant supprimé.</div></c:if>
            <c:if test="${param.error == 'createFailed'}"><div class="alert alert-error">❌ Erreur : le numéro étudiant ou l'email existe déjà.</div></c:if>
            <c:if test="${param.error == 'deleteFailed'}"><div class="alert alert-error">❌ Impossible de supprimer cet étudiant.</div></c:if>
            <c:if test="${param.error == 'notFound'}"><div class="alert alert-error">❌ Étudiant introuvable.</div></c:if>

            <!-- Recherche -->
            <div class="card mb-6">
                <div class="card-body" style="padding:16px 20px;">
                    <form method="GET" action="${pageContext.request.contextPath}/etudiant" style="display:flex;gap:10px;flex-wrap:wrap;align-items:flex-end;">
                        <input type="hidden" name="action" value="search">
                        <div style="flex:0 0 auto;">
                            <label class="form-label">Type</label>
                            <select name="searchType" class="form-control" style="width:140px;">
                                <option value="nom" ${searchType == 'nom' ? 'selected' : ''}>Par nom</option>
                                <option value="niveau" ${searchType == 'niveau' ? 'selected' : ''}>Par niveau</option>
                            </select>
                        </div>
                        <div style="flex:1;min-width:180px;">
                            <label class="form-label">Valeur</label>
                            <input type="text" name="searchValue" class="form-control"
                                   placeholder="Nom ou niveau (L1, L2…)"
                                   value="${searchValue}">
                        </div>
                        <div style="padding-bottom:1px;">
                            <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                            <a href="${pageContext.request.contextPath}/etudiant" class="btn btn-ghost" style="margin-left:6px;">✕ Reset</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Table -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">
                        Liste des étudiants
                        <c:if test="${not empty etudiants}">
                            <span class="badge badge-gray" style="margin-left:8px;">${etudiants.size()}</span>
                        </c:if>
                    </span>
                </div>

                <c:choose>
                    <c:when test="${empty etudiants}">
                        <div class="empty-state">
                            <div class="empty-icon">👥</div>
                            <h3>Aucun étudiant trouvé</h3>
                            <p>Ajoutez des étudiants ou modifiez votre recherche.</p>
                            <a href="${pageContext.request.contextPath}/etudiant?action=new" class="btn btn-primary">➕ Ajouter un étudiant</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x:auto;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Numéro</th>
                                        <th>Nom & Prénoms</th>
                                        <th>Niveau</th>
                                        <th>Email</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="e" items="${etudiants}" varStatus="s">
                                        <tr>
                                            <td class="text-muted mono">${s.index + 1}</td>
                                            <td><span class="badge badge-blue">${e.numEtudiant}</span></td>
                                            <td style="font-weight:600;">${e.nom} ${e.prenoms}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${e.niveau == 'M1' || e.niveau == 'M2'}">
                                                        <span class="badge badge-green">${e.niveau}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-blue">${e.niveau}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><a href="mailto:${e.adrEmail}" class="text-muted text-sm" style="text-decoration:none;">${e.adrEmail}</a></td>
                                            <td>
                                                <div class="flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/etudiant?action=edit&id=${e.numEtudiant}"
                                                       class="btn btn-ghost btn-sm">✏️ Modifier</a>
                                                    <button class="btn btn-danger btn-sm"
                                                            onclick="confirmDel('${e.numEtudiant}', '${e.nom}')">🗑️</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="card-footer text-muted text-sm">
                            ${etudiants.size()} étudiant(s) au total
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
function confirmDel(id, nom) {
    if (confirm('Supprimer l\'étudiant "' + nom + '" (' + id + ') ?\nCette action est irréversible.')) {
        window.location.href = '${pageContext.request.contextPath}/etudiant?action=delete&id=' + id;
    }
}
</script>
</body>
</html>
