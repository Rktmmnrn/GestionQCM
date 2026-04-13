<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // Vérifier que la session contient les questions
    java.util.List<?> questions = (java.util.List<?>) session.getAttribute("questions");
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/examen?action=start");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passage d'Examen QCM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --accent: #6366f1; --accent2: #8b5cf6; }
        * { font-family: 'Sora', sans-serif; }
        body { background: #0f172a; min-height: 100vh; color: #f1f5f9; }

        .exam-bar {
            background: #1e293b;
            border-bottom: 1px solid #334155;
            padding: 14px 30px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .exam-title { font-weight: 800; font-size: 1.1rem; color: #f1f5f9; }
        .exam-student { color: #64748b; font-size: 0.85rem; }

        .timer-box {
            background: #0f172a;
            border: 2px solid #334155;
            border-radius: 10px;
            padding: 8px 20px;
            text-align: center;
            min-width: 120px;
        }
        .timer { font-size: 1.5rem; font-weight: 800; color: var(--accent); }
        .timer.warn { color: #f59e0b; }
        .timer.danger { color: #ef4444; animation: pulse 1s infinite; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.6} }
        .timer-lbl { font-size: 0.7rem; color: #475569; }

        .container-exam { max-width: 780px; margin: 0 auto; padding: 30px 20px; }

        .progress-bar-wrap {
            background: #1e293b;
            border-radius: 10px;
            height: 8px;
            margin-bottom: 8px;
        }
        .progress-fill {
            height: 8px;
            border-radius: 10px;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
            transition: width 0.4s;
        }
        .progress-label { color: #64748b; font-size: 0.82rem; margin-bottom: 25px; }

        /* Question tabs */
        .q-tabs { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 25px; }
        .q-tab {
            width: 38px; height: 38px;
            border-radius: 50%;
            border: 2px solid #334155;
            background: #1e293b;
            color: #94a3b8;
            font-weight: 700; font-size: 0.85rem;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; transition: all 0.2s;
        }
        .q-tab.active { border-color: var(--accent); background: var(--accent); color: white; }
        .q-tab.answered { border-color: #22c55e; color: #22c55e; }
        .q-tab.answered.active { background: #22c55e; color: white; border-color: #22c55e; }

        /* Question card */
        .q-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
            padding: 35px;
            margin-bottom: 25px;
            display: none;
        }
        .q-card.visible { display: block; }
        .q-num {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: white;
            border-radius: 8px;
            padding: 5px 14px;
            font-size: 0.82rem;
            font-weight: 700;
            display: inline-block;
            margin-bottom: 18px;
        }
        .q-text { font-size: 1.15rem; font-weight: 600; color: #e2e8f0; margin-bottom: 28px; line-height: 1.6; }

        .answer-opt {
            background: #0f172a;
            border: 2px solid #334155;
            border-radius: 10px;
            padding: 14px 18px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex; align-items: center; gap: 14px;
        }
        .answer-opt:hover { border-color: var(--accent); background: rgba(99,102,241,0.05); }
        .answer-opt input[type="radio"] { accent-color: var(--accent); width: 18px; height: 18px; cursor: pointer; flex-shrink: 0; }
        .answer-opt.selected { border-color: var(--accent); background: rgba(99,102,241,0.1); }
        .opt-letter {
            width: 28px; height: 28px;
            border-radius: 6px;
            background: #1e293b;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.85rem; color: #64748b;
            flex-shrink: 0;
        }
        .opt-text { color: #cbd5e1; font-size: 0.95rem; }

        /* Navigation */
        .nav-row {
            display: flex; gap: 12px; justify-content: space-between; align-items: center;
            margin-bottom: 25px;
        }
        .btn-nav {
            background: #1e293b;
            border: 1px solid #334155;
            color: #94a3b8;
            border-radius: 10px;
            padding: 11px 24px;
            font-weight: 600; font-size: 0.9rem;
            font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-nav:hover:not(:disabled) { border-color: var(--accent); color: var(--accent); }
        .btn-nav:disabled { opacity: 0.4; cursor: not-allowed; }

        .btn-submit {
            background: linear-gradient(135deg, #22c55e, #16a34a);
            border: none;
            color: white;
            border-radius: 10px;
            padding: 14px 35px;
            font-weight: 700; font-size: 1rem;
            font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.3s;
            width: 100%;
            box-shadow: 0 6px 20px rgba(34,197,94,0.3);
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(34,197,94,0.4); }

        .submit-section {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
            padding: 25px 30px;
            text-align: center;
        }
        .submit-hint { color: #64748b; font-size: 0.85rem; margin-bottom: 18px; }

        /* All mode */
        .q-card.all-mode { display: block !important; margin-bottom: 20px; }
        .toggle-view-btn {
            background: #1e293b;
            border: 1px solid #334155;
            color: #94a3b8;
            border-radius: 8px;
            padding: 8px 18px;
            font-size: 0.85rem; font-weight: 600;
            font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.2s;
            margin-bottom: 20px;
        }
        .toggle-view-btn:hover { border-color: var(--accent); color: var(--accent); }
    </style>
</head>
<body>
    <!-- Barre d'examen -->
    <div class="exam-bar">
        <div>
            <div class="exam-title">✏️ Examen QCM</div>
            <div class="exam-student">Étudiant : ${sessionScope.nomEtudiant} | ${sessionScope.anneeUniv}</div>
        </div>
        <div class="timer-box">
            <div class="timer" id="timer">15:00</div>
            <div class="timer-lbl">⏱ Temps restant</div>
        </div>
    </div>

    <div class="container-exam">
        <!-- Progression -->
        <div class="progress-bar-wrap">
            <div class="progress-fill" id="progressFill" style="width:0%"></div>
        </div>
        <div class="progress-label">
            <span id="answeredCount">0</span> / <c:out value="${fn:length(sessionScope.questions)}"/> questions répondues
        </div>

        <!-- Tabs questions -->
        <div class="q-tabs" id="qTabs">
            <c:forEach var="q" items="${sessionScope.questions}" varStatus="s">
                <div class="q-tab <c:if test="${s.index == 0}">active</c:if>"
                     id="tab${s.index}"
                     onclick="goTo(${s.index})">
                    ${s.index + 1}
                </div>
            </c:forEach>
        </div>

        <!-- Toggle vue -->
        <button class="toggle-view-btn" id="toggleBtn" onclick="toggleView()">
            👁 Voir toutes les questions
        </button>

        <!-- Formulaire -->
        <form method="POST" action="${pageContext.request.contextPath}/examen" id="examForm">
            <input type="hidden" name="action" value="corriger">

            <!-- Questions -->
            <c:forEach var="q" items="${sessionScope.questions}" varStatus="s">
                <div class="q-card <c:if test="${s.index == 0}">visible</c:if>"
                     id="qcard${s.index}">
                    <div class="q-num">Question ${s.index + 1} / <c:out value="${fn:length(sessionScope.questions)}"/></div>
                    <div class="q-text">${q.question}</div>

                    <div class="answers">
                        <label class="answer-opt" id="opt${s.index}_1">
                            <input type="radio" name="question_${s.index}" value="1"
                                   onchange="onAnswer(${s.index})">
                            <span class="opt-letter">A</span>
                            <span class="opt-text">${q.reponse1}</span>
                        </label>
                        <label class="answer-opt" id="opt${s.index}_2">
                            <input type="radio" name="question_${s.index}" value="2"
                                   onchange="onAnswer(${s.index})">
                            <span class="opt-letter">B</span>
                            <span class="opt-text">${q.reponse2}</span>
                        </label>
                        <label class="answer-opt" id="opt${s.index}_3">
                            <input type="radio" name="question_${s.index}" value="3"
                                   onchange="onAnswer(${s.index})">
                            <span class="opt-letter">C</span>
                            <span class="opt-text">${q.reponse3}</span>
                        </label>
                        <label class="answer-opt" id="opt${s.index}_4">
                            <input type="radio" name="question_${s.index}" value="4"
                                   onchange="onAnswer(${s.index})">
                            <span class="opt-letter">D</span>
                            <span class="opt-text">${q.reponse4}</span>
                        </label>
                    </div>
                </div>
            </c:forEach>

            <!-- Navigation -->
            <div class="nav-row" id="navRow">
                <button type="button" class="btn-nav" id="prevBtn" onclick="prev()" disabled>
                    ← Précédente
                </button>
                <button type="button" class="btn-nav" id="nextBtn" onclick="next()">
                    Suivante →
                </button>
            </div>

            <!-- Soumission -->
            <div class="submit-section">
                <div class="submit-hint">
                    Vérifiez vos réponses avant de soumettre.<br>
                    <strong id="submitHint" style="color:#f59e0b;"></strong>
                </div>
                <button type="submit" class="btn-submit"
                        onclick="return confirmSubmit()">
                    ✅ Soumettre l'examen
                </button>
            </div>
        </form>
    </div>

    <script>
        const TOTAL = ${fn:length(sessionScope.questions)};
        let current = 0;
        let timeLeft = 15 * 60;
        let allMode = false;
        const answered = new Set();

        // Timer
        const timerEl = document.getElementById('timer');
        const interval = setInterval(() => {
            timeLeft--;
            if (timeLeft <= 0) {
                clearInterval(interval);
                document.getElementById('examForm').submit();
                return;
            }
            const m = Math.floor(timeLeft / 60);
            const s = timeLeft % 60;
            timerEl.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
            timerEl.className = 'timer';
            if (timeLeft < 120) timerEl.classList.add('danger');
            else if (timeLeft < 300) timerEl.classList.add('warn');
        }, 1000);

        function goTo(idx) {
            if (allMode) return;
            document.querySelectorAll('.q-card').forEach(c => c.classList.remove('visible'));
            document.querySelectorAll('.q-tab').forEach(t => t.classList.remove('active'));
            document.getElementById('qcard' + idx).classList.add('visible');
            document.getElementById('tab' + idx).classList.add('active');
            current = idx;
            document.getElementById('prevBtn').disabled = (idx === 0);
            document.getElementById('nextBtn').disabled = (idx === TOTAL - 1);
            document.getElementById('nextBtn').textContent = (idx === TOTAL - 1) ? '— Fin —' : 'Suivante →';
        }

        function prev() { if (current > 0) goTo(current - 1); }
        function next() { if (current < TOTAL - 1) goTo(current + 1); }

        function onAnswer(idx) {
            answered.add(idx);
            document.getElementById('tab' + idx).classList.add('answered');
            // Update progress
            document.getElementById('answeredCount').textContent = answered.size;
            document.getElementById('progressFill').style.width = (answered.size / TOTAL * 100) + '%';
            // Update submit hint
            const remaining = TOTAL - answered.size;
            const hint = document.getElementById('submitHint');
            hint.textContent = remaining > 0 ? remaining + ' question(s) sans réponse' : '✓ Toutes les questions répondues !';
            hint.style.color = remaining > 0 ? '#f59e0b' : '#22c55e';
        }

        function toggleView() {
            allMode = !allMode;
            const cards = document.querySelectorAll('.q-card');
            const btn = document.getElementById('toggleBtn');
            const nav = document.getElementById('navRow');
            const tabs = document.getElementById('qTabs');
            if (allMode) {
                cards.forEach(c => { c.classList.add('all-mode'); c.classList.remove('visible'); });
                btn.textContent = '👁 Voir une question à la fois';
                nav.style.display = 'none';
                tabs.style.display = 'none';
            } else {
                cards.forEach(c => c.classList.remove('all-mode'));
                btn.textContent = '👁 Voir toutes les questions';
                nav.style.display = 'flex';
                tabs.style.display = 'flex';
                goTo(current);
            }
        }

        function confirmSubmit() {
            const unanswered = TOTAL - answered.size;
            if (unanswered > 0) {
                return confirm(unanswered + ' question(s) sans réponse. Soumettre quand même ?');
            }
            return confirm('Confirmer la soumission de votre examen ?');
        }
    </script>
</body>
</html>
