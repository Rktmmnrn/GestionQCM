<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Résultat de l'examen QCM</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 900px;
            margin: 20px auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideUp 0.5s ease-out;
        }
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }
        .header h1 {
            color: #667eea;
            margin: 0;
            font-size: 32px;
        }
        .score-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
        }
        .score-number {
            font-size: 72px;
            font-weight: bold;
            margin: 20px 0;
        }
        .score-label {
            font-size: 18px;
            opacity: 0.9;
        }
        .message {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        .message p {
            margin: 0;
            font-size: 16px;
            color: #333;
        }
        .details {
            margin-top: 30px;
        }
        .details h3 {
            color: #667eea;
            margin-bottom: 20px;
        }
        .question-detail {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            border-left: 4px solid;
            transition: transform 0.3s;
        }
        .question-detail:hover {
            transform: translateX(5px);
        }
        .question-detail.correct {
            border-left-color: #4CAF50;
            background: #e8f5e9;
        }
        .question-detail.incorrect {
            border-left-color: #f44336;
            background: #ffebee;
        }
        .question-text {
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        .answer {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        .answer strong {
            color: #333;
        }
        .status {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            margin-top: 10px;
        }
        .status.correct {
            background: #4CAF50;
            color: white;
        }
        .status.incorrect {
            background: #f44336;
            color: white;
        }
        .actions {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            text-decoration: none;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .confetti {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1000;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
            color: #999;
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        .celebrate {
            animation: bounce 0.5s ease-in-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Résultat de l'examen QCM</h1>
            <p>Félicitations pour avoir complété l'examen !</p>
        </div>
        
        <div class="score-card">
            <div class="score-label">Votre note</div>
            <div class="score-number">
                ${note} / ${total}
            </div>
            <div class="score-label">
                ${nbBonnesReponses} bonnes réponses sur ${totalQuestions} questions
            </div>
        </div>
        
        <div class="message">
            <p>
                <c:choose>
                    <c:when test="${note >= 8}">
                        🏆 <strong>Excellent travail !</strong> Votre maîtrise du sujet est remarquable. 
                        Continuez sur cette lancée !
                    </c:when>
                    <c:when test="${note >= 6}">
                        👍 <strong>Bon résultat !</strong> Vous avez bien compris les concepts essentiels.
                        Avec un peu plus de révision, vous pourrez atteindre l'excellence.
                    </c:when>
                    <c:when test="${note >= 4}">
                        📚 <strong>Résultat moyen</strong>. Nous vous encourageons à revoir les cours
                        et à vous entraîner davantage pour progresser.
                    </c:when>
                    <c:otherwise>
                        💪 <strong>À améliorer</strong>. N'abandonnez pas ! Avec plus de travail et
                        de persévérance, vous réussirez la prochaine fois.
                    </c:otherwise>
                </c:choose>
            </p>
            <p style="margin-top: 10px; font-size: 14px;">
                📧 Un email récapitulatif a été envoyé à votre adresse institutionnelle.
            </p>
        </div>
        
        <c:if test="${not empty details}">
            <div class="details">
                <h3>📝 Détail des réponses :</h3>
                <c:forEach items="${details}" var="detail" varStatus="status">
                    <div class="question-detail ${detail[2] == 'Correcte' ? 'correct' : 'incorrect'}">
                        <div class="question-text">
                            Question ${status.index + 1}: ${detail[0]}
                        </div>
                        <div class="answer">
                            <strong>Votre réponse :</strong> ${detail[1]}
                        </div>
                        <div class="answer">
                            <strong>Résultat :</strong> ${detail[2]}
                        </div>
                        <span class="status ${detail[2] == 'Correcte' ? 'correct' : 'incorrect'}">
                            ${detail[2] == 'Correcte' ? '✓ Correct' : '✗ Incorrect'}
                        </span>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                🏠 Retour à l'accueil
            </a>
            <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">
                📝 Nouvel examen
            </a>
            <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn btn-primary">
                🏆 Voir le classement
            </a>
        </div>
        
        <div class="footer">
            <p>⚠️ Conservez ce résultat pour vos archives</p>
            <p>📧 Si vous n'avez pas reçu l'email, vérifiez vos spams</p>
        </div>
    </div>
    
    <!-- Animation de confettis si note >= 8 -->
    <c:if test="${note >= 8}">
    <div class="confetti" id="confetti"></div>
    <script>
        function createConfetti() {
            const colors = ['#667eea', '#764ba2', '#4CAF50', '#FFC107', '#F44336', '#2196F3'];
            for (let i = 0; i < 100; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = Math.random() * window.innerWidth + 'px';
                confetti.style.top = '-10px';
                confetti.style.opacity = '0.8';
                confetti.style.pointerEvents = 'none';
                confetti.style.zIndex = '9999';
                confetti.style.animation = `fall ${Math.random() * 3 + 2}s linear forwards`;
                document.body.appendChild(confetti);
                
                setTimeout(() => {
                    confetti.remove();
                }, 5000);
            }
        }
        
        // Ajout de l'animation CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fall {
                0% {
                    transform: translateY(0) rotate(0deg);
                    opacity: 1;
                }
                100% {
                    transform: translateY(100vh) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
        
        // Déclencher les confettis
        createConfetti();
        
        // Animation du score
        const scoreNumber = document.querySelector('.score-number');
        scoreNumber.classList.add('celebrate');
    </script>
    </c:if>
    
    <script>
        // Animation d'entrée des détails
        const details = document.querySelectorAll('.question-detail');
        details.forEach((detail, index) => {
            detail.style.opacity = '0';
            detail.style.transform = 'translateX(-20px)';
            setTimeout(() => {
                detail.style.transition = 'all 0.3s ease-out';
                detail.style.opacity = '1';
                detail.style.transform = 'translateX(0)';
            }, index * 100);
        });
        
        // Effet de surbrillance sur le score
        const scoreCard = document.querySelector('.score-card');
        scoreCard.addEventListener('mouseenter', () => {
            scoreCard.style.transform = 'scale(1.02)';
            scoreCard.style.transition = 'transform 0.3s';
        });
        scoreCard.addEventListener('mouseleave', () => {
            scoreCard.style.transform = 'scale(1)';
        });
    </script>
</body>
</html>