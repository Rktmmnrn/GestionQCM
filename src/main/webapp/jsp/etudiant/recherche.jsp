<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche d'Étudiant</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        
        .search-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 40px;
            max-width: 700px;
            margin: 0 auto;
        }
        
        .search-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 15px;
        }
        
        .search-form {
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 12px 15px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }
        
        .search-buttons {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }
        
        .btn {
            border-radius: 8px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s;
            flex: 1;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border: none;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }
        
        .results-section {
            margin-top: 40px;
            display: none;
        }
        
        .results-section.show {
            display: block;
        }
        
        .results-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 20px;
            font-size: 1.3rem;
        }
        
        .result-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid var(--primary-color);
            margin-bottom: 15px;
        }
        
        .result-field {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .result-field:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        
        .field-label {
            font-weight: 600;
            color: #6c757d;
        }
        
        .field-value {
            color: #333;
            font-weight: 600;
        }
        
        .badge-large {
            padding: 6px 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .no-results {
            background: rgba(220, 53, 69, 0.1);
            border: 2px solid #dc3545;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            color: #dc3545;
        }
        
        .no-results-icon {
            font-size: 2rem;
            margin-bottom: 15px;
        }
        
        .form-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .tabs-search {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            border-bottom: 2px solid #dee2e6;
        }
        
        .tab-button {
            padding: 10px 0;
            border: none;
            background: none;
            color: #6c757d;
            font-weight: 600;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
            margin-bottom: -2px;
        }
        
        .tab-button.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }
        
        .tab-button:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <div class="search-container">
        <h1 class="search-title">🔍 Recherche d'Étudiant</h1>
        
        <!-- Onglets de recherche -->
        <div class="tabs-search">
            <button class="tab-button active" onclick="switchTab('numero')">Par Numéro</button>
            <button class="tab-button" onclick="switchTab('nom')">Par Nom</button>
            <button class="tab-button" onclick="switchTab('email')">Par Email</button>
        </div>

        <!-- Formulaire de recherche -->
        <div class="search-form">
            <!-- Recherche par Numéro -->
            <div id="tab-numero" class="tab-content">
                <div class="form-group">
                    <label for="numEtudiant" class="form-label">
                        Numéro d'étudiant
                    </label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="numEtudiant"
                        placeholder="Ex: E001234"
                    >
                    <div class="form-text">
                        Entrez le numéro unique de l'étudiant
                    </div>
                </div>
            </div>

            <!-- Recherche par Nom -->
            <div id="tab-nom" class="tab-content" style="display: none;">
                <div class="form-group">
                    <label for="nom" class="form-label">
                        Nom ou Prénoms
                    </label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="nom"
                        placeholder="Ex: Dupont ou Jean"
                    >
                    <div class="form-text">
                        Entrez le nom ou les prénoms de l'étudiant
                    </div>
                </div>
            </div>

            <!-- Recherche par Email -->
            <div id="tab-email" class="tab-content" style="display: none;">
                <div class="form-group">
                    <label for="email" class="form-label">
                        Adresse email
                    </label>
                    <input 
                        type="email" 
                        class="form-control" 
                        id="email"
                        placeholder="Ex: etudiant@exemple.fr"
                    >
                    <div class="form-text">
                        Entrez l'adresse email de l'étudiant
                    </div>
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="search-buttons">
                <button type="button" class="btn btn-primary" onclick="effectuerRecherche()">
                    🔍 Rechercher
                </button>
                <button type="button" class="btn btn-secondary" onclick="reinitialiser()">
                    🔄 Réinitialiser
                </button>
            </div>
        </div>

        <!-- Section des résultats -->
        <div class="results-section" id="resultsSection">
            <!-- Résultat trouvé -->
            <div id="resultFound" style="display: none;">
                <div class="results-title">✅ Résultat(s) trouvé(s)</div>
                
                <!-- Carte de résultat (exemple) -->
                <div class="result-card">
                    <div class="result-field">
                        <span class="field-label">📌 Numéro:</span>
                        <span class="field-value"><span class="badge badge-large bg-info">E001234</span></span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">👤 Nom:</span>
                        <span class="field-value">Dupont</span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">👤 Prénoms:</span>
                        <span class="field-value">Jean Marie</span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">📚 Niveau:</span>
                        <span class="field-value"><span class="badge badge-large bg-primary">L3</span></span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">📧 Email:</span>
                        <span class="field-value">jean.dupont@exemple.fr</span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">📅 Inscrit depuis:</span>
                        <span class="field-value">2024-09-15</span>
                    </div>
                </div>

                <!-- Autre résultat (exemple 2) -->
                <div class="result-card">
                    <div class="result-field">
                        <span class="field-label">📌 Numéro:</span>
                        <span class="field-value"><span class="badge badge-large bg-info">E001235</span></span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">👤 Nom:</span>
                        <span class="field-value">Dupont</span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">👤 Prénoms:</span>
                        <span class="field-value">Sophie</span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">📚 Niveau:</span>
                        <span class="field-value"><span class="badge badge-large bg-success">M1</span></span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">📧 Email:</span>
                        <span class="field-value">sophie.dupont@exemple.fr</span>
                    </div>
                    <div class="result-field">
                        <span class="field-label">📅 Inscrit depuis:</span>
                        <span class="field-value">2023-09-20</span>
                    </div>
                </div>
            </div>

            <!-- Aucun résultat -->
            <div id="noResults" style="display: none;">
                <div class="no-results">
                    <div class="no-results-icon">😕</div>
                    <h5>Aucun résultat trouvé</h5>
                    <p>Veuillez vérifier votre recherche et réessayer avec d'autres critères.</p>
                </div>
            </div>
        </div>

        <!-- Bouton de retour -->
        <div class="mt-4 text-center">
            <a href="liste.jsp" class="btn btn-outline-secondary w-100">
                ← Retour à la liste
            </a>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Scripts de gestion -->
    <script>
        // Changer les onglets
        function switchTab(tabName) {
            // Masquer tous les onglets
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.style.display = 'none';
            });
            
            // Afficher l'onglet sélectionné
            document.getElementById('tab-' + tabName).style.display = 'block';
            
            // Mettre à jour les boutons
            document.querySelectorAll('.tab-button').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        // Effectuer la recherche
        function effectuerRecherche() {
            let hasValue = false;
            
            // Vérifier les champs
            if (document.getElementById('numEtudiant').value.trim() ||
                document.getElementById('nom').value.trim() ||
                document.getElementById('email').value.trim()) {
                hasValue = true;
            }
            
            if (!hasValue) {
                alert('Veuillez entrer au moins un critère de recherche');
                return;
            }
            
            // Afficher les résultats (simulé)
            document.getElementById('resultsSection').classList.add('show');
            document.getElementById('resultFound').style.display = 'block';
            document.getElementById('noResults').style.display = 'none';
            
            // Scroll vers les résultats
            document.getElementById('resultsSection').scrollIntoView({ behavior: 'smooth' });
        }

        // Réinitialiser le formulaire
        function reinitialiser() {
            document.getElementById('numEtudiant').value = '';
            document.getElementById('nom').value = '';
            document.getElementById('email').value = '';
            document.getElementById('resultsSection').classList.remove('show');
            document.getElementById('resultFound').style.display = 'none';
            document.getElementById('noResults').style.display = 'none';
        }

        // Permettre la recherche avec Enter
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('numEtudiant').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') effectuerRecherche();
            });
            document.getElementById('nom').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') effectuerRecherche();
            });
            document.getElementById('email').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') effectuerRecherche();
            });
        });
    </script>
</body>
</html>
