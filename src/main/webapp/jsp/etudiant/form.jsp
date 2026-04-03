<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulaire Étudiant</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 20px 0;
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .form-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 10px 15px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            border-radius: 8px;
            padding: 10px 30px;
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
        
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        
        .form-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <!-- Titre du formulaire -->
        <h2 class="form-title">
            <c:choose>
                <c:when test="${not empty param.id}">
                    ✏️ Modifier un étudiant
                </c:when>
                <c:otherwise>
                    ➕ Ajouter un nouvel étudiant
                </c:otherwise>
            </c:choose>
        </h2>

        <!-- Message d'erreur ou de succès -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Erreur !</strong> ${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Succès !</strong> ${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Formulaire -->
        <form method="POST" action="save.jsp" class="needs-validation" novalidate>
            <!-- Champ: Numéro d'étudiant -->
            <div class="form-group">
                <label for="numEtudiant" class="form-label required-field">
                    Numéro d'étudiant
                </label>
                <input 
                    type="text" 
                    class="form-control" 
                    id="numEtudiant" 
                    name="numEtudiant"
                    placeholder="Ex: E001234"
                    value="${param.numEtudiant}"
                    required
                    <c:if test="${not empty param.id}">readonly</c:if>
                >
                <div class="form-text">
                    Identifiant unique de l'étudiant (format: E + 6 chiffres)
                </div>
            </div>

            <!-- Champ: Nom -->
            <div class="form-group">
                <label for="nom" class="form-label required-field">
                    Nom
                </label>
                <input 
                    type="text" 
                    class="form-control" 
                    id="nom" 
                    name="nom"
                    placeholder="Ex: Dupont"
                    value="${param.nom}"
                    required
                >
            </div>

            <!-- Champ: Prénoms -->
            <div class="form-group">
                <label for="prenoms" class="form-label required-field">
                    Prénoms
                </label>
                <input 
                    type="text" 
                    class="form-control" 
                    id="prenoms" 
                    name="prenoms"
                    placeholder="Ex: Jean Marie"
                    value="${param.prenoms}"
                    required
                >
            </div>

            <!-- Champ: Email -->
            <div class="form-group">
                <label for="email" class="form-label required-field">
                    Adresse email
                </label>
                <input 
                    type="email" 
                    class="form-control" 
                    id="email" 
                    name="email"
                    placeholder="Ex: jean.dupont@exemple.fr"
                    value="${param.email}"
                    required
                >
                <div class="form-text">
                    L'email doit être valide et unique
                </div>
            </div>

            <!-- Champ: Niveau -->
            <div class="form-group">
                <label for="niveau" class="form-label required-field">
                    Niveau d'études
                </label>
                <select class="form-select" id="niveau" name="niveau" required>
                    <option value="">-- Sélectionnez un niveau --</option>
                    <option value="L1" <c:if test="${param.niveau == 'L1'}">selected</c:if>>
                        Licence 1ère année (L1)
                    </option>
                    <option value="L2" <c:if test="${param.niveau == 'L2'}">selected</c:if>>
                        Licence 2ème année (L2)
                    </option>
                    <option value="L3" <c:if test="${param.niveau == 'L3'}">selected</c:if>>
                        Licence 3ème année (L3)
                    </option>
                    <option value="M1" <c:if test="${param.niveau == 'M1'}">selected</c:if>>
                        Master 1ère année (M1)
                    </option>
                    <option value="M2" <c:if test="${param.niveau == 'M2'}">selected</c:if>>
                        Master 2ème année (M2)
                    </option>
                </select>
            </div>

            <!-- Boutons d'action -->
            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${not empty param.id}">
                            💾 Enregistrer les modifications
                        </c:when>
                        <c:otherwise>
                            ➕ Ajouter l'étudiant
                        </c:otherwise>
                    </c:choose>
                </button>
                <button type="reset" class="btn btn-secondary">
                    🔄 Annuler
                </button>
            </div>

            <!-- Retour -->
            <div class="mt-3 text-center">
                <a href="liste.jsp" class="btn btn-outline-secondary w-100">
                    ← Retour à la liste
                </a>
            </div>
        </form>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Validation du formulaire -->
    <script>
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>