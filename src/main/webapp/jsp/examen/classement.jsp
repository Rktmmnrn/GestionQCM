<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Classement Général</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --gold: #FFD700;
            --silver: #C0C0C0;
            --bronze: #CD7F32;
            --success-color: #198754;
        }
        
        body {
            background-color: #f8f9fa;
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--primary-color), #0b5ed7);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .podium {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .podium-place {
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .podium-place.first {
            background: linear-gradient(135deg, var(--gold), #FFC700);
            padding: 40px 20px;
            order: 2;
        }
        
        .podium-place.second {
            background: linear-gradient(135deg, var(--silver), #A8A9AD);
            padding: 30px 20px;
            order: 1;
            align-self: flex-end;
        }
        
        .podium-place.third {
            background: linear-gradient(135deg, var(--bronze), #B87333);
            padding: 20px 20px;
            order: 3;
            align-self: flex-end;
        }
        
        .medal {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        .rank-number {
            display: inline-block;
            font-size: 1.2rem;
            font-weight: 700;
            color: white;
            background: rgba(0, 0, 0, 0.2);
            padding: 5px 10px;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        
        .rank-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: white;
            margin-bottom: 8px;
        }
        
        .rank-score {
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 5px;
        }
        
        .rank-info {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.9);
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
        
        .rank-col {
            font-weight: 700;
            color: var(--primary-color);
            font-size: 1.1rem;
        }
        
        .medal-col {
            font-size: 1.5rem;
        }
        
        .badge-large {
            padding: 8px 12px;
            font-weight: 600;
        }
        
        .score-good {
            background-color: var(--success-color);
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
            font-weight: 600;
        }
        
        .score-poor {
            background-color: #dc3545;
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
            font-weight: 600;
        }
        
        .filters {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .filters h5 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .filter-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .filter-group select {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 8px 12px;
        }
        
        .stats-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .stat-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            color: #6c757d;
            font-weight: 600;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <!-- En-tête -->
    <div class="page-header">
        <div class="container">
            <h1>🏆 Classement Général</h1>
            <p>Résultats des examens par niveau d'études</p>
        </div>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <!-- Filtres -->
        <div class="filters">
            <h5>🔍 Filtrer par :</h5>
            <div class="filter-group">
                <select class="form-select" style="max-width: 200px;">
                    <option value="">Tous les niveaux</option>
                    <option value="L1">Licence 1</option>
                    <option value="L2">Licence 2</option>
                    <option value="L3">Licence 3</option>
                    <option value="M1">Master 1</option>
                    <option value="M2">Master 2</option>
                </select>
                <select class="form-select" style="max-width: 200px;">
                    <option value="">Année universitaire</option>
                    <option value="2023">2024-2025</option>
                    <option value="2022">2023-2024</option>
                </select>
            </div>
        </div>

        <!-- Statistiques globales -->
        <div class="stats-section">
            <h5 class="mb-3">📊 Statistiques Globales</h5>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-value">47</div>
                    <div class="stat-label">Participants</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">7.2</div>
                    <div class="stat-label">Moyenne générale</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">9.5</div>
                    <div class="stat-label">Meilleure note</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">3.1</div>
                    <div class="stat-label">Pire note</div>
                </div>
            </div>
        </div>

        <!-- Podium -->
        <h3 class="mb-4" style="color: var(--primary-color); font-weight: 700;">🥇 Podium des Trois Premiers</h3>
        <div class="podium">
            <!-- Deuxième place -->
            <div class="podium-place second">
                <div class="medal">🥈</div>
                <div class="rank-number">2ème</div>
                <div class="rank-name">Sophie Martin</div>
                <div class="rank-score">9.0/10</div>
                <div class="rank-info">
                    Master 1 | 2024-2025
                </div>
            </div>

            <!-- Première place -->
            <div class="podium-place first">
                <div class="medal">🥇</div>
                <div class="rank-number">1ère</div>
                <div class="rank-name">Alexandre Dupont</div>
                <div class="rank-score">9.5/10</div>
                <div class="rank-info">
                    Master 1 | 2024-2025
                </div>
            </div>

            <!-- Troisième place -->
            <div class="podium-place third">
                <div class="medal">🥉</div>
                <div class="rank-number">3ème</div>
                <div class="rank-name">Marie Leblanc</div>
                <div class="rank-score">8.5/10</div>
                <div class="rank-info">
                    Licence 3 | 2024-2025
                </div>
            </div>
        </div>

        <!-- Tableau complet du classement -->
        <h3 class="mb-4 mt-5" style="color: var(--primary-color); font-weight: 700;">📋 Classement Complet</h3>
        <div class="table-container">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th style="width: 8%;">Rang</th>
                        <th style="width: 5%;"></th>
                        <th style="width: 20%;">Nom et Prénoms</th>
                        <th style="width: 12%;">Niveau</th>
                        <th style="width: 15%;">Note</th>
                        <th style="width: 15%;">Année</th>
                        <th style="width: 15%;">Détails</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="i" begin="1" end="20">
                        <tr>
                            <td>
                                <span class="rank-col">#${i}</span>
                            </td>
                            <td class="medal-col">
                                <c:choose>
                                    <c:when test="${i == 1}">🥇</c:when>
                                    <c:when test="${i == 2}">🥈</c:when>
                                    <c:when test="${i == 3}">🥉</c:when>
                                    <c:otherwise></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${i % 3 == 0}">Alice Bernard</c:when>
                                    <c:when test="${i % 3 == 1}">Thomas Moreau</c:when>
                                    <c:otherwise>Véronique Petit</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${i <= 4}">
                                        <span class="badge badge-large bg-success">M1</span>
                                    </c:when>
                                    <c:when test="${i <= 8}">
                                        <span class="badge badge-large bg-primary">L3</span>
                                    </c:when>
                                    <c:when test="${i <= 12}">
                                        <span class="badge badge-large bg-info">L2</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-large bg-secondary">L1</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:set var="score" value="${9.5 - (i * 0.15)}" />
                                <c:set var="scoreInt" value="${score > 5 ? 'score-good' : 'score-poor'}" />
                                <span class="${scoreInt}">${score > 0 ? score : 0}/10</span>
                            </td>
                            <td>2024-2025</td>
                            <td>
                                <a href="resultat.jsp" class="btn btn-sm btn-outline-primary">
                                    Voir
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Légende des couleurs -->
        <div class="alert alert-info mt-4">
            <strong>📌 Légende :</strong>
            <ul class="mb-0 mt-2">
                <li><span class="score-good">Vert (≥ 5)</span> = Réussi</li>
                <li><span class="score-poor">Rouge (&lt; 5)</span> = Non réussi</li>
                <li>🥇 🥈 🥉 = Trois meilleurs classements</li>
            </ul>
        </div>

        <!-- Bouton de retour -->
        <div class="mt-4 mb-4 text-center">
            <a href="../../index.jsp" class="btn btn-outline-secondary">
                ← Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
