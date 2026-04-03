<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <!-- Total étudiants -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">47</div>
                    <div class="stat-label">Total d'étudiants</div>
                </div>
            </div>
            <!-- Licence -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">28</div>
                    <div class="stat-label">Étudiants en Licence</div>
                </div>
            </div>
            <!-- Masters -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">19</div>
                    <div class="stat-label">Étudiants en Master</div>
                </div>
            </div>
            <!-- Moyenne -->
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number">5.4</div>
                    <div class="stat-label">Moyenne des notes</div>
                </div>
            </div>
        </div>

        <!-- Tableau Licence 1 -->
        <h3 class="section-title">
            Licence 1ère année (L1) - 8 étudiants
        </h3>
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
                    <c:set var="count" value="0" />
                    <c:forEach var="i" begin="1" end="8">
                        <c:set var="count" value="${count + 1}" />
                        <tr>
                            <td>${count}</td>
                            <td><span class="badge bg-info">E00012${i}</span></td>
                            <td>Durant</td>
                            <td>Élève ${i}</td>
                            <td>eleve${i}@univ.fr</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Tableau Licence 2 -->
        <h3 class="section-title">
            Licence 2ème année (L2) - 10 étudiants
        </h3>
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
                    <c:set var="count" value="0" />
                    <c:forEach var="i" begin="1" end="10">
                        <c:set var="count" value="${count + 1}" />
                        <tr>
                            <td>${count}</td>
                            <td><span class="badge bg-info">E00022${i}</span></td>
                            <td>Moreau</td>
                            <td>Étudiant ${i+8}</td>
                            <td>etudiant${i+8}@univ.fr</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Tableau Licence 3 -->
        <h3 class="section-title">
            Licence 3ème année (L3) - 10 étudiants
        </h3>
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
                    <c:set var="count" value="0" />
                    <c:forEach var="i" begin="1" end="10">
                        <c:set var="count" value="${count + 1}" />
                        <tr>
                            <td>${count}</td>
                            <td><span class="badge bg-info">E00032${i}</span></td>
                            <td>Martin</td>
                            <td>Apprenant ${i+18}</td>
                            <td>apprenant${i+18}@univ.fr</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Tableau Master 1 -->
        <h3 class="section-title">
            Master 1ère année (M1) - 10 étudiants
        </h3>
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
                    <c:set var="count" value="0" />
                    <c:forEach var="i" begin="1" end="10">
                        <c:set var="count" value="${count + 1}" />
                        <tr>
                            <td>${count}</td>
                            <td><span class="badge bg-success">E00041${i}</span></td>
                            <td>Bernard</td>
                            <td>Master ${i}</td>
                            <td>master${i}@univ.fr</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Tableau Master 2 -->
        <h3 class="section-title">
            Master 2ème année (M2) - 9 étudiants
        </h3>
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
                    <c:set var="count" value="0" />
                    <c:forEach var="i" begin="1" end="9">
                        <c:set var="count" value="${count + 1}" />
                        <tr>
                            <td>${count}</td>
                            <td><span class="badge bg-success">E00052${i}</span></td>
                            <td>Durand</td>
                            <td>Master2 ${i}</td>
                            <td>master2_${i}@univ.fr</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Boutons de retour -->
        <div class="mt-4 mb-4">
            <a href="liste.jsp" class="btn btn-outline-secondary me-2">
                ← Retour à la liste
            </a>
            <a href="../../index.jsp" class="btn btn-outline-secondary">
                ← Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
