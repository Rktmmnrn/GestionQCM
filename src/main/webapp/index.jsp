<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Examens - Accueil</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        
        .navbar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: #fff !important;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.8) !important;
            transition: color 0.3s;
        }
        
        .nav-link:hover {
            color: #fff !important;
        }
        
        .hero-section {
            text-align: center;
            color: white;
            margin-bottom: 50px;
        }
        
        .hero-section h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 20px;
        }
        
        .hero-section p {
            font-size: 1.25rem;
            opacity: 0.9;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 48px rgba(0, 0, 0, 0.15);
        }
        
        .card-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .card-title {
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .card-text {
            color: #6c757d;
            font-size: 0.95rem;
        }
        
        .btn-card {
            border-radius: 10px;
            padding: 10px 30px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-card:hover {
            transform: scale(1.05);
        }
        
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .footer {
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            padding: 20px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark mb-5">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">
                📚 Gestion des Examens
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">Accueil</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/etudiant">Étudiants</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/qcm">Questions QCM</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="jsp/examen/classement.jsp">Classement</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Section Héro -->
    <div class="hero-section">
        <h1>Bienvenue</h1>
        <p>Plateforme de gestion des examens en ligne</p>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <!-- Grille des modules -->
        <div class="modules-grid">
            <!-- Carte Étudiants -->
            <div class="card">
                <div class="card-body text-center p-4">
                    <div class="card-icon">👥</div>
                    <h5 class="card-title">Gestion des Étudiants</h5>
                    <p class="card-text">
                        Gérez les profils des étudiants, consultez les niveaux d'études
                        et les coordonnées de contact.
                    </p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/etudiant" class="btn btn-primary btn-card me-2">
                            Consulter
                        </a>
                        <a href="${pageContext.request.contextPath}/etudiant?action=new" class="btn btn-outline-primary btn-card">
                            Ajouter
                        </a>
                    </div>
                </div>
            </div>

            <!-- Carte Questions QCM -->
            <div class="card">
                <div class="card-body text-center p-4">
                    <div class="card-icon">❓</div>
                    <h5 class="card-title">Questions QCM</h5>
                    <p class="card-text">
                        Créez et gérez les questions à choix multiples avec vos réponses
                        et les bonnes réponses.
                    </p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/qcm" class="btn btn-primary btn-card me-2">
                            Consulter
                        </a>
                        <a href="${pageContext.request.contextPath}/qcm?action=new" class="btn btn-outline-primary btn-card">
                            Ajouter
                        </a>
                    </div>
                </div>
            </div>

            <!-- Carte Examens -->
            <div class="card">
                <div class="card-body text-center p-4">
                    <div class="card-icon">✏️</div>
                    <h5 class="card-title">Passage d'Examen</h5>
                    <p class="card-text">
                        Permettez aux étudiants de passer les examens en ligne
                        avec un minuteur et sauvegarde automatique.
                    </p>
                    <div class="mt-4">
                        <a href="jsp/examen/passage.jsp" class="btn btn-primary btn-card me-2">
                            Démarrer
                        </a>
                        <a href="jsp/examen/resultat.jsp" class="btn btn-outline-primary btn-card">
                            Résultats
                        </a>
                    </div>
                </div>
            </div>

            <!-- Carte Classement -->
            <div class="card">
                <div class="card-body text-center p-4">
                    <div class="card-icon">🏆</div>
                    <h5 class="card-title">Classement</h5>
                    <p class="card-text">
                        Consultez le classement général des étudiants par niveau
                        et année universitaire.
                    </p>
                    <div class="mt-4">
                        <a href="jsp/examen/classement.jsp" class="btn btn-primary btn-card">
                            Voir le classement
                        </a>
                    </div>
                </div>
            </div>

            <!-- Carte Statistiques Étudiants -->
            <div class="card">
                <div class="card-body text-center p-4">
                    <div class="card-icon">📊</div>
                    <h5 class="card-title">Étudiants par Niveau</h5>
                    <p class="card-text">
                        Consultez la répartition des étudiants par niveau d'études
                        et les statistiques globales.
                    </p>
                    <div class="mt-4">
                        <a href="jsp/etudiant/par_niveau.jsp" class="btn btn-primary btn-card">
                            Consulter
                        </a>
                    </div>
                </div>
            </div>

            <!-- Carte Recherche -->
            <div class="card">
                <div class="card-body text-center p-4">
                    <div class="card-icon">🔍</div>
                    <h5 class="card-title">Recherche Étudiants</h5>
                    <p class="card-text">
                        Recherchez rapidement un étudiant par son numéro
                        ou son nom dans la base de données.
                    </p>
                    <div class="mt-4">
                        <a href="jsp/etudiant/recherche.jsp" class="btn btn-primary btn-card">
                            Rechercher
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Pied de page -->
    <footer class="footer container-fluid mt-5">
        <p>&copy; 2026 Plateforme de Gestion des Examens - Tous droits réservés</p>
        <small>Développé avec Bootstrap 5 et JSP</small>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
