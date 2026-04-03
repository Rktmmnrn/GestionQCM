<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats de l'Examen</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --success-color: #198754;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        
        .results-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 50px;
            max-width: 700px;
            margin: 0 auto;
            text-align: center;
        }
        
        .score-display {
            font-size: 4rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .score-display.excellent {
            color: var(--success-color);
        }
        
        .score-display.good {
            color: #0dcaf0;
        }
        
        .score-display.poor {
            color: var(--danger-color);
        }
        
        .message-section {
            margin: 30px 0;
            padding: 30px;
            border-radius: 15px;
            background: #f8f9fa;
        }
        
        .message-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .message-text {
            font-size: 1.1rem;
            color: #6c757d;
            line-height: 1.6;
        }
        
        .excellent-message {
            background: linear-gradient(135deg, rgba(25, 135, 84, 0.1), rgba(13, 202, 240, 0.1));
            border: 2px solid var(--success-color);
        }
        
        .excellent-message .message-title {
            color: var(--success-color);
        }
        
        .good-message {
            background: linear-gradient(135deg, rgba(13, 202, 240, 0.1), rgba(25, 135, 84, 0.1));
            border: 2px solid #0dcaf0;
        }
        
        .good-message .message-title {
            color: #0dcaf0;
        }
        
        .poor-message {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.1), rgba(255, 193, 7, 0.1));
            border: 2px solid var(--danger-color);
        }
        
        .poor-message .message-title {
            color: var(--danger-color);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin: 30px 0;
        }
        
        .stat-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border: 2px solid #dee2e6;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 8px;
        }
        
        .stat-box.correct {
            background: rgba(25, 135, 84, 0.05);
            border-color: var(--success-color);
        }
        
        .stat-box.correct .stat-number {
            color: var(--success-color);
        }
        
        .stat-box.incorrect {
            background: rgba(220, 53, 69, 0.05);
            border-color: var(--danger-color);
        }
        
        .stat-box.incorrect .stat-number {
            color: var(--danger-color);
        }
        
        .results-detail {
            text-align: left;
            margin: 30px 0;
        }
        
        .result-item {
            padding: 15px;
            margin-bottom: 12px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 15px;
            background: #f8f9fa;
        }
        
        .result-item.correct {
            background: rgba(25, 135, 84, 0.1);
            border-left: 4px solid var(--success-color);
        }
        
        .result-item.incorrect {
            background: rgba(220, 53, 69, 0.1);
            border-left: 4px solid var(--danger-color);
        }
        
        .result-number {
            display: inline-block;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            text-align: center;
            line-height: 35px;
            font-weight: 700;
            color: white;
            background: var(--primary-color);
            flex-shrink: 0;
        }
        
        .result-correct {
            background: var(--success-color);
        }
        
        .result-incorrect {
            background: var(--danger-color);
        }
        
        .result-text {
            flex: 1;
        }
        
        .result-question {
            font-weight: 600;
            color: #333;
        }
        
        .result-answer {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border: none;
        }
        
        .btn-primary:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
        }
        
        .medal {
            font-size: 3rem;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="results-container">
        <%-- Simulation: Note de 7/10 --%>
        <div class="medal">🎓</div>
        <h1>Vos Résultats</h1>
        
        <!-- Affichage de la note -->
        <div class="score-display excellent">7/10</div>
        <p style="color: #6c757d; margin-bottom: 30px;">Pourcentage de réussite: <strong>70%</strong></p>
        
        <!-- Message de félicitation/encouragement -->
        <div class="message-section excellent-message">
            <div class="medal">🎉</div>
            <div class="message-title">Bravo !</div>
            <div class="message-text">
                Vous avez obtenu une très bonne note ! Votre compréhension du sujet est confirmée.
                Continuez ainsi pour renforcer vos connaissances.
            </div>
        </div>
        
        <!-- Statistiques -->
        <div class="stats-grid">
            <div class="stat-box correct">
                <div class="stat-number">7</div>
                <div class="stat-label">Bonnes réponses</div>
            </div>
            <div class="stat-box incorrect">
                <div class="stat-number">3</div>
                <div class="stat-label">Mauvaises réponses</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">14m 32s</div>
                <div class="stat-label">Temps utilisé</div>
            </div>
        </div>
        
        <!-- Détail des résultats -->
        <div class="results-detail">
            <h5 class="mb-3">📋 Récapitulatif détaillé</h5>
            
            <!-- Question 1 -->
            <div class="result-item correct">
                <span class="result-number result-correct">1</span>
                <div class="result-text">
                    <div class="result-question">Quel est le port par défaut d'Apache ?</div>
                    <div class="result-answer">✓ Votre réponse: <strong>Port 80 (HTTP)</strong> - Correcte</div>
                </div>
            </div>
            
            <!-- Question 2 -->
            <div class="result-item incorrect">
                <span class="result-number result-incorrect">2</span>
                <div class="result-text">
                    <div class="result-question">Qu'est-ce que JSP signifie ?</div>
                    <div class="result-answer">✗ Votre réponse: JavaScript Protocol | Bonne réponse: <strong>Java Server Pages</strong></div>
                </div>
            </div>
            
            <!-- Question 3 -->
            <div class="result-item correct">
                <span class="result-number result-correct">3</span>
                <div class="result-text">
                    <div class="result-question">Définition de JSTL</div>
                    <div class="result-answer">✓ Votre réponse: <strong>JavaServer Pages Standard Tag Library</strong> - Correcte</div>
                </div>
            </div>
            
            <!-- Question 4 -->
            <div class="result-item incorrect">
                <span class="result-number result-incorrect">4</span>
                <div class="result-text">
                    <div class="result-question">Port MySQL par défaut</div>
                    <div class="result-answer">✗ Votre réponse: 3305 | Bonne réponse: <strong>3306</strong></div>
                </div>
            </div>
            
            <!-- Question 5 -->
            <div class="result-item correct">
                <span class="result-number result-correct">5</span>
                <div class="result-text">
                    <div class="result-question">Qu'est-ce que Bootstrap ?</div>
                    <div class="result-answer">✓ Votre réponse: <strong>Framework CSS responsive</strong> - Correcte</div>
                </div>
            </div>
            
            <!-- Questions supplémentaires -->
            <c:forEach var="i" begin="6" end="10">
                <c:choose>
                    <c:when test="${i % 2 == 0}">
                        <div class="result-item correct">
                            <span class="result-number result-correct">${i}</span>
                            <div class="result-text">
                                <div class="result-question">Question ${i}</div>
                                <div class="result-answer">✓ Réponse correcte</div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="result-item incorrect">
                            <span class="result-number result-incorrect">${i}</span>
                            <div class="result-text">
                                <div class="result-question">Question ${i}</div>
                                <div class="result-answer">✗ Réponse incorrecte</div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
        
        <!-- Boutons d'action -->
        <div class="button-group">
            <a href="passage.jsp" class="btn btn-primary">
                🔄 Repasser l'examen
            </a>
            <a href="classement.jsp" class="btn btn-outline-primary">
                📊 Voir le classement
            </a>
            <a href="../../index.jsp" class="btn btn-outline-secondary">
                🏠 Retour à l'accueil
            </a>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
