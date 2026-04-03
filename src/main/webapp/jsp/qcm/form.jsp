<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulaire QCM</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 40px;
            max-width: 700px;
            margin: 0 auto;
        }
        
        .form-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 30px;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 15px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
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
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        
        .answer-group {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            position: relative;
            border-left: 4px solid #ddd;
        }
        
        .answer-group.answer-a {
            border-left-color: #0dcaf0;
        }
        
        .answer-group.answer-b {
            border-left-color: #6c757d;
        }
        
        .answer-group.answer-c {
            border-left-color: #ffc107;
        }
        
        .answer-group.answer-d {
            border-left-color: #fd7e14;
        }
        
        .answer-letter {
            display: inline-block;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            text-align: center;
            line-height: 30px;
            font-weight: 700;
            color: white;
            margin-right: 10px;
            font-size: 0.9rem;
        }
        
        .answer-group.answer-a .answer-letter {
            background-color: #0dcaf0;
        }
        
        .answer-group.answer-b .answer-letter {
            background-color: #6c757d;
        }
        
        .answer-group.answer-c .answer-letter {
            background-color: #ffc107;
        }
        
        .answer-group.answer-d .answer-letter {
            background-color: #fd7e14;
        }
        
        .radio-wrapper {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .form-check {
            margin: 0;
        }
        
        .form-check-input {
            width: 20px;
            height: 20px;
            cursor: pointer;
            margin-top: 3px;
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
                    ✏️ Modifier une question QCM
                </c:when>
                <c:otherwise>
                    ➕ Ajouter une nouvelle question
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
            <!-- Section Question -->
            <div class="form-section">
                <div class="form-section-title">📝 Question</div>
                
                <div class="form-group">
                    <label for="question" class="form-label required-field">
                        Énoncé de la question
                    </label>
                    <textarea 
                        class="form-control" 
                        id="question" 
                        name="question"
                        placeholder="Entrez l'énoncé de la question..."
                        required
                    >${param.question}</textarea>
                    <div class="form-text">
                        Soyez clair et précis dans la formulation
                    </div>
                </div>
            </div>

            <!-- Section Réponses -->
            <div class="form-section">
                <div class="form-section-title">🎯 Réponses</div>
                
                <!-- Réponse A -->
                <div class="answer-group answer-a">
                    <div class="radio-wrapper">
                        <span class="answer-letter">A</span>
                        <div class="form-check">
                            <input 
                                class="form-check-input" 
                                type="radio" 
                                name="bonneRep" 
                                id="rep_a" 
                                value="1"
                                <c:if test="${param.bonneRep == '1'}">checked</c:if>
                            >
                            <label class="form-check-label" for="rep_a">
                                Ceci est la bonne réponse
                            </label>
                        </div>
                    </div>
                    <input 
                        type="text" 
                        class="form-control mt-2" 
                        name="reponse1"
                        placeholder="Réponse A"
                        value="${param.reponse1}"
                        required
                    >
                </div>

                <!-- Réponse B -->
                <div class="answer-group answer-b">
                    <div class="radio-wrapper">
                        <span class="answer-letter">B</span>
                        <div class="form-check">
                            <input 
                                class="form-check-input" 
                                type="radio" 
                                name="bonneRep" 
                                id="rep_b" 
                                value="2"
                                <c:if test="${param.bonneRep == '2'}">checked</c:if>
                            >
                            <label class="form-check-label" for="rep_b">
                                Ceci est la bonne réponse
                            </label>
                        </div>
                    </div>
                    <input 
                        type="text" 
                        class="form-control mt-2" 
                        name="reponse2"
                        placeholder="Réponse B"
                        value="${param.reponse2}"
                        required
                    >
                </div>

                <!-- Réponse C -->
                <div class="answer-group answer-c">
                    <div class="radio-wrapper">
                        <span class="answer-letter">C</span>
                        <div class="form-check">
                            <input 
                                class="form-check-input" 
                                type="radio" 
                                name="bonneRep" 
                                id="rep_c" 
                                value="3"
                                <c:if test="${param.bonneRep == '3'}">checked</c:if>
                            >
                            <label class="form-check-label" for="rep_c">
                                Ceci est la bonne réponse
                            </label>
                        </div>
                    </div>
                    <input 
                        type="text" 
                        class="form-control mt-2" 
                        name="reponse3"
                        placeholder="Réponse C"
                        value="${param.reponse3}"
                        required
                    >
                </div>

                <!-- Réponse D -->
                <div class="answer-group answer-d">
                    <div class="radio-wrapper">
                        <span class="answer-letter">D</span>
                        <div class="form-check">
                            <input 
                                class="form-check-input" 
                                type="radio" 
                                name="bonneRep" 
                                id="rep_d" 
                                value="4"
                                <c:if test="${param.bonneRep == '4'}">checked</c:if>
                            >
                            <label class="form-check-label" for="rep_d">
                                Ceci est la bonne réponse
                            </label>
                        </div>
                    </div>
                    <input 
                        type="text" 
                        class="form-control mt-2" 
                        name="reponse4"
                        placeholder="Réponse D"
                        value="${param.reponse4}"
                        required
                    >
                </div>

                <div class="form-text mt-2">
                    ⚠️ Assurez-vous de sélectionner la bonne réponse
                </div>
            </div>

            <!-- Boutons d'action -->
            <div class="button-group">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${not empty param.id}">
                            💾 Enregistrer les modifications
                        </c:when>
                        <c:otherwise>
                            ➕ Ajouter la question
                        </c:otherwise>
                    </c:choose>
                </button>
                <button type="reset" class="btn btn-secondary">
                    🔄 Réinitialiser
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
