<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passage d'Examen - QCM</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --danger-color: #dc3545;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .exam-header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .timer-container {
            background: white;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .timer {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .timer.warning {
            color: #ffc107;
        }
        
        .timer.danger {
            color: var(--danger-color);
        }
        
        .timer-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .progress-section {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .progress-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .question-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .question-number {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .question-text {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .answer-option {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .answer-option:hover {
            border-color: var(--primary-color);
            background-color: #f0f3ff;
        }
        
        .answer-option.selected {
            border-color: var(--primary-color);
            background-color: #dbeafe;
        }
        
        .answer-radio {
            width: 20px;
            height: 20px;
            cursor: pointer;
            margin-right: 12px;
        }
        
        .answer-text {
            display: inline-block;
            vertical-align: middle;
        }
        
        .navigation-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            justify-content: space-between;
        }
        
        .btn {
            border-radius: 8px;
            padding: 12px 25px;
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
        
        .btn-submit {
            padding: 12px 40px;
            font-size: 1.1rem;
        }
        
        .tab-nav {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .question-tab {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: 2px solid #dee2e6;
            background: white;
            cursor: pointer;
            font-weight: 700;
            color: #333;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .question-tab:hover {
            border-color: var(--primary-color);
        }
        
        .question-tab.active {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }
        
        .question-tab.answered {
            border-color: #198754;
            color: #198754;
        }
        
        .view-toggle {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            display: flex;
            gap: 10px;
        }
        
        .info-alert {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border-left: 4px solid var(--primary-color);
        }
    </style>
</head>
<body>
    <!-- En-tête fixe -->
    <div class="exam-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h2 class="mb-0">✏️ Passage d'Examen QCM</h2>
                </div>
                <div class="col-md-6 text-end">
                    <div class="timer-container d-inline-block" style="min-width: 200px;">
                        <div class="timer" id="timer">15:00</div>
                        <div class="timer-label">⏱️ Temps restant</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <!-- Message d'information -->
        <div class="info-alert">
            <strong>📢 Important :</strong> Vous avez 15 minutes pour répondre à 10 questions. Une seule réponse est possible par question.
        </div>

        <form method="POST" action="verifier.jsp" id="examForm">
            <!-- Barre de progression -->
            <div class="progress-section">
                <div class="progress-label">
                    Progression : <span id="answered">0</span>/10 questions répondues
                </div>
                <div class="progress">
                    <div class="progress-bar" id="progressBar" role="progressbar" style="width: 0%" 
                         aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
            </div>

            <!-- Boutons de vue -->
            <div class="view-toggle">
                <button type="button" class="btn btn-outline-primary" id="toggleView">
                    👁️ Voir les questions une par une
                </button>
            </div>

            <!-- Navigation par questions (tabs) -->
            <div class="tab-nav" id="questionTabs">
                <c:forEach var="i" begin="1" end="10">
                    <div class="question-tab" onclick="goToQuestion(${i})" data-question="${i}">
                        ${i}
                    </div>
                </c:forEach>
            </div>

            <!-- Conteneur des questions -->
            <div id="questionsContainer">
                <!-- Question 1 -->
                <div class="question-container question" id="question1" style="display: none;">
                    <div class="question-number">Question 1 / 10</div>
                    <div class="question-text">
                        Quel est le port par défaut utilisé par un serveur Apache ?
                    </div>
                    
                    <div class="answers">
                        <label class="answer-option">
                            <input type="radio" name="q1" value="A" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Port 21 (FTP)</span>
                        </label>
                        <label class="answer-option">
                            <input type="radio" name="q1" value="B" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Port 80 (HTTP)</span>
                        </label>
                        <label class="answer-option">
                            <input type="radio" name="q1" value="C" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Port 25 (SMTP)</span>
                        </label>
                        <label class="answer-option">
                            <input type="radio" name="q1" value="D" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Port 3306 (MySQL)</span>
                        </label>
                    </div>
                </div>

                <!-- Question 2 -->
                <div class="question-container question" id="question2" style="display: none;">
                    <div class="question-number">Question 2 / 10</div>
                    <div class="question-text">
                        Qu'est-ce que JSP signifie ?
                    </div>
                    
                    <div class="answers">
                        <label class="answer-option">
                            <input type="radio" name="q2" value="A" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Java Server Pages</span>
                        </label>
                        <label class="answer-option">
                            <input type="radio" name="q2" value="B" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Java Script Protocol</span>
                        </label>
                        <label class="answer-option">
                            <input type="radio" name="q2" value="C" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Java Secure Protocol</span>
                        </label>
                        <label class="answer-option">
                            <input type="radio" name="q2" value="D" class="answer-radio" onchange="updateProgress()">
                            <span class="answer-text">Java Servlet Platform</span>
                        </label>
                    </div>
                </div>

                <!-- Questions supplémentaires (3-10) -->
                <c:forEach var="i" begin="3" end="10">
                    <div class="question-container question" id="question${i}" style="display: none;">
                        <div class="question-number">Question ${i} / 10</div>
                        <div class="question-text">
                            Ceci est une question d'exemple numéro ${i} pour le QCM.
                        </div>
                        
                        <div class="answers">
                            <label class="answer-option">
                                <input type="radio" name="q${i}" value="A" class="answer-radio" onchange="updateProgress()">
                                <span class="answer-text">Réponse A</span>
                            </label>
                            <label class="answer-option">
                                <input type="radio" name="q${i}" value="B" class="answer-radio" onchange="updateProgress()">
                                <span class="answer-text">Réponse B</span>
                            </label>
                            <label class="answer-option">
                                <input type="radio" name="q${i}" value="C" class="answer-radio" onchange="updateProgress()">
                                <span class="answer-text">Réponse C</span>
                            </label>
                            <label class="answer-option">
                                <input type="radio" name="q${i}" value="D" class="answer-radio" onchange="updateProgress()">
                                <span class="answer-text">Réponse D</span>
                            </label>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Boutons de navigation -->
            <div class="navigation-buttons">
                <button type="button" class="btn btn-outline-secondary" id="prevBtn" onclick="previousQuestion()">
                    ← Question précédente
                </button>
                <button type="button" class="btn btn-primary" id="nextBtn" onclick="nextQuestion()">
                    Question suivante →
                </button>
            </div>

            <!-- Bouton de soumission -->
            <div class="text-center mt-4 mb-4">
                <button type="submit" class="btn btn-success btn-submit" 
                        onclick="return confirm('Êtes-vous sûr de vouloir soumettre votre examen ?')">
                    ✓ Soumettre l'examen
                </button>
            </div>
        </form>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script de gestion de l'examen -->
    <script>
        let currentQuestion = 1;
        let totalQuestions = 10;
        let timeRemaining = 15 * 60; // 15 minutes en secondes
        let viewMode = 'one'; // 'one' ou 'all'

        // Initialiser l'affichage
        document.addEventListener('DOMContentLoaded', function() {
            showQuestion(1);
            startTimer();
        });

        // Minuteur (countdown)
        function startTimer() {
            setInterval(function() {
                timeRemaining--;
                
                if (timeRemaining < 0) {
                    // Soumettre automatiquement
                    document.getElementById('examForm').submit();
                    return;
                }
                
                let minutes = Math.floor(timeRemaining / 60);
                let seconds = timeRemaining % 60;
                let display = (minutes < 10 ? '0' : '') + minutes + ':' + 
                             (seconds < 10 ? '0' : '') + seconds;
                
                let timerElement = document.getElementById('timer');
                timerElement.textContent = display;
                
                // Changer la couleur du timer
                timerElement.className = 'timer';
                if (timeRemaining < 300) { // Moins de 5 minutes
                    timerElement.classList.add('danger');
                } else if (timeRemaining < 600) { // Moins de 10 minutes
                    timerElement.classList.add('warning');
                }
            }, 1000);
        }

        // Afficher une question spécifique
        function showQuestion(number) {
            if (number < 1 || number > totalQuestions) return;
            
            currentQuestion = number;
            
            // Masquer toutes les questions
            document.querySelectorAll('.question').forEach(q => q.style.display = 'none');
            
            // Afficher la question actuelle
            document.getElementById('question' + number).style.display = 'block';
            
            // Mettre à jour les tabs
            document.querySelectorAll('.question-tab').forEach((tab, idx) => {
                tab.classList.remove('active');
                if (idx + 1 === number) {
                    tab.classList.add('active');
                }
            });
            
            // Mettre à jour les boutons de navigation
            document.getElementById('prevBtn').disabled = (number === 1);
            document.getElementById('nextBtn').disabled = (number === totalQuestions);
            document.getElementById('nextBtn').textContent = 
                (number === totalQuestions) ? '✓ Terminer' : 'Question suivante →';
        }

        // Aller à la question précédente
        function previousQuestion() {
            if (currentQuestion > 1) {
                showQuestion(currentQuestion - 1);
            }
        }

        // Aller à la question suivante
        function nextQuestion() {
            if (currentQuestion < totalQuestions) {
                showQuestion(currentQuestion + 1);
            }
        }

        // Aller à une question spécifique
        function goToQuestion(number) {
            showQuestion(number);
        }

        // Mettre à jour la progression
        function updateProgress() {
            let answered = 0;
            for (let i = 1; i <= totalQuestions; i++) {
                let radios = document.querySelectorAll(`input[name="q${i}"]:checked`);
                if (radios.length > 0) {
                    answered++;
                    document.querySelector(`[data-question="${i}"]`).classList.add('answered');
                } else {
                    document.querySelector(`[data-question="${i}"]`).classList.remove('answered');
                }
            }
            
            // Mettre à jour la barre de progression
            let percentage = (answered / totalQuestions) * 100;
            document.getElementById('progressBar').style.width = percentage + '%';
            document.getElementById('answered').textContent = answered;
        }

        // Basculer la vue
        document.getElementById('toggleView').addEventListener('click', function() {
            if (viewMode === 'one') {
                viewMode = 'all';
                document.querySelectorAll('.question').forEach(q => q.style.display = 'block');
                document.getElementById('questionTabs').style.display = 'none';
                document.getElementById('prevBtn').style.display = 'none';
                document.getElementById('nextBtn').style.display = 'none';
                this.textContent = '👁️ Voir une question à la fois';
            } else {
                viewMode = 'one';
                document.querySelectorAll('.question').forEach(q => q.style.display = 'none');
                document.getElementById('questionTabs').style.display = 'flex';
                document.getElementById('prevBtn').style.display = 'inline-block';
                document.getElementById('nextBtn').style.display = 'inline-block';
                this.textContent = '👁️ Voir toutes les questions';
                showQuestion(1);
            }
        });
    </script>
</body>
</html>
