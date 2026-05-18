<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Étudiants par Niveau</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
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
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            color: #6c757d;
            font-weight: 600;
            margin-top: 10px;
        }
        
        .badge-large {
            padding: 10px 20px;
            font-size: 1rem;
        }
        
        .section-title {
            font-weight: 700;
            color: var(--primary-color);
            margin-top: 30px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--primary-color);
        }
        
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
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
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .table tbody td {
            padding: 12px 15px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <!-- En-tête -->
    <div class="page-header">
        <div class="container">
            <h1 class="mb-1">📊 Étudiants par Niveau</h1>
            <p class="mb-0">Vue statistique et détaillée par niveau d'études</p>
        </div>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <!-- Statistiques globales -->
        <h3 class="section-title">Statistiques Générales</h3>
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-number">${totalEtudiants}</div>
                    <div class="stat-label">Total d'étudiants</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-number">${fn:length(niveaux)}</div>
                    <div class="stat-label">Niveaux enregistrés</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-number">${fn:length(niveaux)}</div>
                    <div class="stat-label">Groupes de niveaux</div>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty niveaux}">
                <div class="alert alert-info">Aucun étudiant trouvé. Ajoutez des étudiants pour voir les effectifs par niveau.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="niveau" items="${niveaux}">
                    <c:set var="etudiantsNiveau" value="${etudiantsByNiveau[niveau]}" />
                    <h3 class="section-title">${niveau} — ${fn:length(etudiantsNiveau)} étudiant(s)</h3>
                    <div class="table-container">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">N°</th>
                                    <th style="width: 20%;">Numéro</th>
                                    <th style="width: 25%;">Nom</th>
                                    <th style="width: 25%;">Prénoms</th>
                                    <th style="width: 20%;">Email</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="etudiant" items="${etudiantsNiveau}" varStatus="status">
                                    <tr>
                                        <td>${status.index + 1}</td>
                                        <td><span class="badge bg-info">${etudiant.numEtudiant}</span></td>
                                        <td>${etudiant.nom}</td>
                                        <td>${etudiant.prenoms}</td>
                                        <td>${etudiant.adrEmail}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <!-- Boutons de retour -->
        <div class="mt-4 mb-4">
            <a href="${pageContext.request.contextPath}/etudiant" class="btn btn-outline-secondary me-2">
                ← Retour à la liste
            </a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
                ← Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
