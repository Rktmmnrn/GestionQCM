<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Étudiants</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --danger-color: #dc3545;
            --info-color: #0dcaf0;
        }
        
        body {
            background-color: #f8f9fa;
        }
        
        .page-header {
            background-color: var(--primary-color);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table thead {
            background-color: var(--primary-color);
            color: white;
        }
        
        .table thead th {
            border: none;
            padding: 15px;
            font-weight: 600;
            vertical-align: middle;
        }
        
        .table tbody tr {
            border-bottom: 1px solid #dee2e6;
            transition: background-color 0.3s;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 0.875rem;
            margin: 0 2px;
        }
        
        .badge {
            padding: 6px 12px;
            font-weight: 600;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        .btn-ajouter {
            margin-bottom: 20px;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- En-tête -->
    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-1">👥 Liste des Étudiants</h1>
                    <p class="mb-0">Gestion complète des profils étudiants</p>
                </div>
                <a href="form.jsp" class="btn btn-light btn-ajouter">
                    <i class="bi bi-plus-circle"></i> Ajouter un étudiant
                </a>
            </div>
        </div>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <!-- Formulaire de recherche -->
        <div class="search-box">
            <form method="GET" action="liste.jsp" class="row g-3">
                <div class="col-md-5">
                    <label for="searchNom" class="form-label">
                        <strong>Recherche par nom ou prénoms</strong>
                    </label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="searchNom" 
                        name="searchNom"
                        placeholder="Entrez un nom ou des prénoms"
                        value="${param.searchNom}"
                    >
                </div>
                <div class="col-md-5">
                    <label for="searchNum" class="form-label">
                        <strong>Recherche par numéro</strong>
                    </label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="searchNum" 
                        name="searchNum"
                        placeholder="Entrez le numéro d'étudiant"
                        value="${param.searchNum}"
                    >
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        🔍 Rechercher
                    </button>
                </div>
            </form>
        </div>

        <!-- Tableau des étudiants -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty etudiants}">
                    <!-- État vide -->
                    <div class="empty-state">
                        <div class="empty-state-icon">📭</div>
                        <h4>Aucun étudiant trouvé</h4>
                        <p>Commencez par ajouter des étudiants à la base de données.</p>
                        <a href="form.jsp" class="btn btn-primary">
                            Ajouter le premier étudiant
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Tableau -->
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th style="width: 10%;">N°</th>
                                <th style="width: 15%;">Numéro d'étudiant</th>
                                <th style="width: 20%;">Nom</th>
                                <th style="width: 20%;">Prénoms</th>
                                <th style="width: 10%;">Niveau</th>
                                <th style="width: 20%;">Email</th>
                                <th style="width: 15%;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Itération sur la liste des étudiants -->
                            <c:set var="count" value="0" />
                            <c:forEach var="etudiant" items="${etudiants}">
                                <c:set var="count" value="${count + 1}" />
                                <tr>
                                    <td>${count}</td>
                                    <td>
                                        <span class="badge bg-info">${etudiant.numEtudiant}</span>
                                    </td>
                                    <td>${etudiant.nom}</td>
                                    <td>${etudiant.prenoms}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${etudiant.niveau == 'L1'}">
                                                <span class="badge bg-primary">L1</span>
                                            </c:when>
                                            <c:when test="${etudiant.niveau == 'L2'}">
                                                <span class="badge bg-primary">L2</span>
                                            </c:when>
                                            <c:when test="${etudiant.niveau == 'L3'}">
                                                <span class="badge bg-primary">L3</span>
                                            </c:when>
                                            <c:when test="${etudiant.niveau == 'M1'}">
                                                <span class="badge bg-success">M1</span>
                                            </c:when>
                                            <c:when test="${etudiant.niveau == 'M2'}">
                                                <span class="badge bg-success">M2</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${etudiant.niveau}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="mailto:${etudiant.adrEmail}" class="text-decoration-none">
                                            ${etudiant.adrEmail}
                                        </a>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a 
                                                href="form.jsp?id=${etudiant.numEtudiant}" 
                                                class="btn btn-sm btn-primary"
                                                title="Modifier"
                                            >
                                                ✏️ Modifier
                                            </a>
                                            <button 
                                                type="button" 
                                                class="btn btn-sm btn-danger"
                                                onclick="confirmerSuppression('${etudiant.numEtudiant}', '${etudiant.nom}')"
                                                title="Supprimer"
                                            >
                                                🗑️ Supprimer
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Résumé -->
                    <div class="p-3 bg-light border-top">
                        <strong>Total : ${etudiants.size()} étudiant(s)</strong>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Lien de retour -->
        <div class="mt-4 mb-4">
            <a href="../../index.jsp" class="btn btn-outline-secondary">
                ← Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script de confirmation de suppression -->
    <script>
        function confirmerSuppression(numEtudiant, nom) {
            if (confirm(`Êtes-vous sûr de vouloir supprimer l'étudiant "${nom}" (${numEtudiant}) ?\n\nCette action est irréversible.`)) {
                // Simuler l'envoi du formulaire de suppression
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.jsp';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = numEtudiant;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>