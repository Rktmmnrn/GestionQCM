<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Questions QCM</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --success-color: #198754;
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
        
        .qcm-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .qcm-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }
        
        .qcm-header {
            background: linear-gradient(135deg, var(--primary-color), #0b5ed7);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .qcm-number {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .qcm-body {
            padding: 20px;
        }
        
        .question-text {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }
        
        .answer-item {
            padding: 10px 15px;
            margin-bottom: 8px;
            border-radius: 5px;
            border-left: 4px solid #ddd;
            transition: background-color 0.3s;
        }
        
        .answer-item.answer-a {
            border-left-color: #0dcaf0;
        }
        
        .answer-item.answer-b {
            border-left-color: #6c757d;
        }
        
        .answer-item.answer-c {
            border-left-color: #ffc107;
        }
        
        .answer-item.answer-d {
            border-left-color: #fd7e14;
        }
        
        .answer-letter {
            display: inline-block;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            text-align: center;
            line-height: 25px;
            font-weight: 700;
            color: white;
            margin-right: 10px;
            font-size: 0.85rem;
        }
        
        .answer-item.answer-a .answer-letter {
            background-color: #0dcaf0;
        }
        
        .answer-item.answer-b .answer-letter {
            background-color: #6c757d;
        }
        
        .answer-item.answer-c .answer-letter {
            background-color: #ffc107;
        }
        
        .answer-item.answer-d .answer-letter {
            background-color: #fd7e14;
        }
        
        .correct-answer {
            background-color: #d4edda !important;
            border-left: 4px solid var(--success-color) !important;
        }
        
        .correct-indicator {
            display: inline-block;
            margin-left: 10px;
            padding: 4px 8px;
            background-color: var(--success-color);
            color: white;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .answer-text {
            display: inline-block;
            vertical-align: middle;
        }
        
        .qcm-footer {
            padding: 15px 20px;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
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
                    <h1 class="mb-1">❓ Questions QCM</h1>
                    <p class="mb-0">Banque de questions à choix multiples</p>
                </div>
                <a href="form.jsp" class="btn btn-light">
                    ➕ Ajouter une question
                </a>
            </div>
        </div>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <c:choose>
            <c:when test="${empty qcms}">
                <!-- État vide -->
                <div class="qcm-card">
                    <div class="empty-state">
                        <div class="empty-state-icon">📭</div>
                        <h4>Aucune question trouvée</h4>
                        <p>Commencez par ajouter des questions QCM à la base de données.</p>
                        <a href="form.jsp" class="btn btn-primary">
                            Ajouter la première question
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Affichage des questions -->
                <c:forEach var="qcm" items="${qcms}">
                    <div class="qcm-card">
                        <!-- En-tête de la question -->
                        <div class="qcm-header">
                            <div class="qcm-number">Question #${qcm.numQuest}</div>
                            <div>
                                <span class="badge bg-light text-dark">
                                    Difficulté: Moyen
                                </span>
                            </div>
                        </div>

                        <!-- Corps de la question -->
                        <div class="qcm-body">
                            <div class="question-text">
                                ${qcm.question}
                            </div>

                            <!-- Réponses -->
                            <div class="answers-container">
                                <!-- Réponse A -->
                                <div class="answer-item answer-a <c:if test="${qcm.bonneRep == 1}">correct-answer</c:if>">
                                    <span class="answer-letter">A</span>
                                    <span class="answer-text">${qcm.reponse1}</span>
                                    <c:if test="${qcm.bonneRep == 1}">
                                        <span class="correct-indicator">✓ Correcte</span>
                                    </c:if>
                                </div>

                                <!-- Réponse B -->
                                <div class="answer-item answer-b <c:if test="${qcm.bonneRep == 2}">correct-answer</c:if>">
                                    <span class="answer-letter">B</span>
                                    <span class="answer-text">${qcm.reponse2}</span>
                                    <c:if test="${qcm.bonneRep == 2}">
                                        <span class="correct-indicator">✓ Correcte</span>
                                    </c:if>
                                </div>

                                <!-- Réponse C -->
                                <div class="answer-item answer-c <c:if test="${qcm.bonneRep == 3}">correct-answer</c:if>">
                                    <span class="answer-letter">C</span>
                                    <span class="answer-text">${qcm.reponse3}</span>
                                    <c:if test="${qcm.bonneRep == 3}">
                                        <span class="correct-indicator">✓ Correcte</span>
                                    </c:if>
                                </div>

                                <!-- Réponse D -->
                                <div class="answer-item answer-d <c:if test="${qcm.bonneRep == 4}">correct-answer</c:if>">
                                    <span class="answer-letter">D</span>
                                    <span class="answer-text">${qcm.reponse4}</span>
                                    <c:if test="${qcm.bonneRep == 4}">
                                        <span class="correct-indicator">✓ Correcte</span>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Pied de la question -->
                        <div class="qcm-footer">
                            <a 
                                href="form.jsp?id=${qcm.numQuest}" 
                                class="btn btn-primary btn-sm"
                            >
                                ✏️ Modifier
                            </a>
                            <button 
                                type="button" 
                                class="btn btn-danger btn-sm"
                                onclick="confirmerSuppression(${qcm.numQuest})"
                            >
                                🗑️ Supprimer
                            </button>
                            <a 
                                href="../../jsp/examen/passage.jsp?qid=${qcm.numQuest}" 
                                class="btn btn-outline-success btn-sm"
                            >
                                ▶️ Aperçu en examen
                            </a>
                        </div>
                    </div>
                </c:forEach>

                <!-- Résumé -->
                <div class="alert alert-info mt-4">
                    <strong>📊 Résumé :</strong> ${qcms.size()} question(s) disponible(s)
                </div>
            </c:otherwise>
        </c:choose>

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
        function confirmerSuppression(idQCM) {
            if (confirm(`Êtes-vous sûr de vouloir supprimer la question #${idQCM} ?\n\nCette action est irréversible.`)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.jsp';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = idQCM;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
