<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passage de l'examen QCM</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .header {
            text-align: center;
            border-bottom: 2px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .header h1 {
            color: #667eea;
            margin: 0;
        }
        .question-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        .question-text {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        .options {
            margin-left: 20px;
        }
        .option {
            margin: 15px 0;
            padding: 10px;
            background: white;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .option:hover {
            background: #e8eaf6;
            transform: translateX(5px);
        }
        .option input {
            margin-right: 10px;
            cursor: pointer;
        }
        .option label {
            cursor: pointer;
            font-size: 16px;
        }
        .progress {
            text-align: center;
            margin-bottom: 20px;
            color: #667eea;
            font-weight: bold;
        }
        .navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-primary:hover {
            background: #764ba2;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .info {
            background: #d1ecf1;
            color: #0c5460;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📝 Examen QCM</h1>
            <p>Répondez aux 10 questions suivantes</p>
        </div>
        
        <c:if test="${not empty sessionScope.questions}">
            <div class="progress">
                Question ${sessionScope.indexCourant + 1} / ${sessionScope.questions.size()}
            </div>
            
            <form action="${pageContext.request.contextPath}/examen" method="post" id="examForm">
                <input type="hidden" name="action" value="corriger">
                
                <c:set var="questions" value="${sessionScope.questions}" />
                <c:set var="currentIndex" value="${sessionScope.indexCourant}" />
                
                <div class="question-card">
                    <div class="question-text">
                        ${currentIndex + 1}. ${questions[currentIndex].question}
                    </div>
                    
                    <div class="options">
                        <div class="option">
                            <input type="radio" name="question_${currentIndex}" 
                                   id="q${currentIndex}_1" value="1" required>
                            <label for="q${currentIndex}_1">A. ${questions[currentIndex].reponse1}</label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" name="question_${currentIndex}" 
                                   id="q${currentIndex}_2" value="2">
                            <label for="q${currentIndex}_2">B. ${questions[currentIndex].reponse2}</label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" name="question_${currentIndex}" 
                                   id="q${currentIndex}_3" value="3">
                            <label for="q${currentIndex}_3">C. ${questions[currentIndex].reponse3}</label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" name="question_${currentIndex}" 
                                   id="q${currentIndex}_4" value="4">
                            <label for="q${currentIndex}_4">D. ${questions[currentIndex].reponse4}</label>
                        </div>
                    </div>
                </div>
                
                <div class="navigation">
                    <c:if test="${sessionScope.indexCourant > 0}">
                        <button type="button" class="btn btn-secondary" onclick="previousQuestion()">
                            ← Précédent
                        </button>
                    </c:if>
                    
                    <c:if test="${sessionScope.indexCourant < sessionScope.questions.size() - 1}">
                        <button type="button" class="btn btn-primary" onclick="nextQuestion()">
                            Suivant →
                        </button>
                    </c:if>
                    
                    <c:if test="${sessionScope.indexCourant == sessionScope.questions.size() - 1}">
                        <button type="submit" class="btn btn-primary" onclick="return confirm('Êtes-vous sûr de vouloir terminer l\'examen ?')">
                            Terminer l'examen
                        </button>
                    </c:if>
                </div>
            </form>
        </c:if>
        
        <c:if test="${empty sessionScope.questions}">
            <div class="error">
                Aucune question disponible. Veuillez recommencer.
            </div>
            <div class="navigation">
                <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">
                    Retour au début
                </a>
            </div>
        </c:if>
    </div>
    
    <script>
        // Fonction pour sauvegarder la réponse en session avant de changer de question
        function saveAndNavigate(action) {
            var form = document.getElementById('examForm');
            var currentQuestion = ${sessionScope.indexCourant};
            var selectedAnswer = document.querySelector('input[name="question_' + currentQuestion + '"]:checked');
            
            if (selectedAnswer) {
                // Sauvegarder la réponse via AJAX (optionnel)
                var xhr = new XMLHttpRequest();
                xhr.open('POST', '${pageContext.request.contextPath}/examen?action=sauvegarderReponse', false);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.send('index=' + currentQuestion + '&reponse=' + selectedAnswer.value);
            }
            
            if (action === 'next') {
                window.location.href = '${pageContext.request.contextPath}/examen?action=questionSuivante';
            } else if (action === 'prev') {
                window.location.href = '${pageContext.request.contextPath}/examen?action=questionPrecedente';
            }
        }
        
        function nextQuestion() {
            saveAndNavigate('next');
        }
        
        function previousQuestion() {
            saveAndNavigate('prev');
        }
        
        // Restaurer la réponse précédente si elle existe
        window.onload = function() {
            var currentIndex = ${sessionScope.indexCourant};
            var reponses = ${sessionScope.reponses != null ? sessionScope.reponses : '[]'};
            
            if (reponses[currentIndex] != null) {
                var radioButton = document.querySelector('input[name="question_' + currentIndex + '"][value="' + reponses[currentIndex] + '"]');
                if (radioButton) {
                    radioButton.checked = true;
                }
            }
        };
    </script>
</body>
</html>