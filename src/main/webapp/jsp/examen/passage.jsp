<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    java.util.List<?> questions = (java.util.List<?>) session.getAttribute("questions");
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/examen?action=start");
        return;
    }
    request.setAttribute("currentPage", "examen");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Examen en cours — GestionExamens</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <style>
        /* Exam-specific styles — sidebar hidden during exam */
        .app-shell { display: block; }
        .sidebar { display: none; }
        .main-content { margin-left: 0; }

        .exam-topbar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 0 24px;
            height: 56px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .exam-info { font-size: 0.85rem; color: var(--text2); }
        .exam-info strong { color: var(--text); }

        .timer-wrap {
            display: flex; align-items: center; gap: 8px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 7px 16px;
        }
        .timer { font-family: 'DM Mono', monospace; font-size: 1.2rem; font-weight: 700; color: var(--text); }
        .timer.warn { color: var(--warn); }
        .timer.danger { color: var(--danger); animation: blink 1s infinite; }
        @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.5} }

        .exam-body { max-width: 760px; margin: 0 auto; padding: 24px 20px; }

        /* Progress */
        .progress-wrap { margin-bottom: 20px; }
        .progress-bar { background: var(--surface2); border-radius: 4px; height: 5px; margin-bottom: 6px; }
        .progress-fill { background: var(--accent); height: 5px; border-radius: 4px; transition: width 0.3s; }
        .progress-label { font-size: 0.75rem; color: var(--text3); }

        /* Question tabs */
        .q-nav { display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 20px; }
        .q-dot {
            width: 34px; height: 34px; border-radius: 50%;
            border: 1.5px solid var(--border);
            background: var(--surface);
            color: var(--text3);
            font-size: 0.78rem; font-weight: 700; font-family: 'DM Mono', monospace;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; transition: all 0.15s;
        }
        .q-dot:hover { border-color: var(--accent); color: var(--accent); }
        .q-dot.active { background: var(--text); border-color: var(--text); color: white; }
        .q-dot.answered { border-color: var(--accent); color: var(--accent); }
        .q-dot.answered.active { background: var(--accent); border-color: var(--accent); color: white; }

        /* Question card */
        .q-card { display: none; }
        .q-card.visible { display: block; }

        .q-card-inner {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 16px;
        }
        .q-head {
            padding: 14px 20px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 10px;
        }
        .q-num { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: var(--text3); }
        .q-body-inner { padding: 20px; }
        .q-text { font-size: 1rem; font-weight: 600; color: var(--text); line-height: 1.6; margin-bottom: 20px; }

        .answer-label {
            display: flex; align-items: center; gap: 12px;
            background: var(--bg); border: 1.5px solid var(--border);
            border-radius: 8px; padding: 12px 16px;
            margin-bottom: 10px; cursor: pointer; transition: all 0.15s;
        }
        .answer-label:hover { border-color: var(--accent); background: var(--accent-bg); }
        .answer-label:has(input:checked) { border-color: var(--accent); background: var(--accent-bg); }
        .answer-label input[type="radio"] { accent-color: var(--accent); width: 16px; height: 16px; cursor: pointer; flex-shrink: 0; }
        .ans-let { width: 24px; height: 24px; border-radius: 5px; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.72rem; color: white; flex-shrink: 0; }
        .al-a { background: #6366f1; } .al-b { background: #8b5cf6; } .al-c { background: #0891b2; } .al-d { background: #d97706; }
        .ans-txt { font-size: 0.875rem; color: var(--text2); }
        .answer-label:has(input:checked) .ans-txt { color: var(--accent2); font-weight: 600; }

        /* Nav buttons */
        .nav-btns { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }

        /* Submit */
        .submit-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 20px;
            text-align: center;
        }
        .submit-hint { font-size: 0.8rem; color: var(--text3); margin-bottom: 14px; min-height: 20px; }
        .btn-submit-exam {
            background: var(--accent); color: white;
            border: none; border-radius: 8px;
            padding: 12px 32px; font-size: 0.95rem; font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; transition: all 0.15s;
        }
        .btn-submit-exam:hover { background: var(--accent2); }
    </style>
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="exam-topbar">
            <div class="exam-info">
                ✏️ <strong>Examen QCM</strong>
                <span style="margin-left:12px;">Étudiant : <strong>${sessionScope.nomEtudiant}</strong></span>
                <span style="margin-left:8px;color:var(--text3);">— ${sessionScope.anneeUniv}</span>
            </div>
            <div class="timer-wrap">
                <span style="font-size:0.75rem;color:var(--text3);">⏱</span>
                <span class="timer" id="timer">15:00</span>
            </div>
        </div>

        <div class="exam-body">

            <!-- Progress -->
            <div class="progress-wrap">
                <div class="progress-bar">
                    <div class="progress-fill" id="progressFill" style="width:0%"></div>
                </div>
                <div class="progress-label">
                    <span id="answeredCount">0</span> / <c:out value="${fn:length(sessionScope.questions)}"/> répondues
                </div>
            </div>

            <!-- Question navigation dots -->
            <div class="q-nav" id="qNav">
                <c:forEach var="q" items="${sessionScope.questions}" varStatus="s">
                    <div class="q-dot ${s.index == 0 ? 'active' : ''}" id="dot${s.index}" onclick="goTo(${s.index})">${s.index + 1}</div>
                </c:forEach>
            </div>

            <!-- Form -->
            <form method="POST" action="${pageContext.request.contextPath}/examen" id="examForm">
                <input type="hidden" name="action" value="corriger">

                <c:forEach var="q" items="${sessionScope.questions}" varStatus="s">
                    <div class="q-card ${s.index == 0 ? 'visible' : ''}" id="qcard${s.index}">
                        <div class="q-card-inner">
                            <div class="q-head">
                                <span class="q-num">Question ${s.index + 1} sur <c:out value="${fn:length(sessionScope.questions)}"/></span>
                            </div>
                            <div class="q-body-inner">
                                <div class="q-text">${q.question}</div>
                                <label class="answer-label">
                                    <input type="radio" name="question_${s.index}" value="1" onchange="onAnswer(${s.index})">
                                    <span class="ans-let al-a">A</span>
                                    <span class="ans-txt">${q.reponse1}</span>
                                </label>
                                <label class="answer-label">
                                    <input type="radio" name="question_${s.index}" value="2" onchange="onAnswer(${s.index})">
                                    <span class="ans-let al-b">B</span>
                                    <span class="ans-txt">${q.reponse2}</span>
                                </label>
                                <label class="answer-label">
                                    <input type="radio" name="question_${s.index}" value="3" onchange="onAnswer(${s.index})">
                                    <span class="ans-let al-c">C</span>
                                    <span class="ans-txt">${q.reponse3}</span>
                                </label>
                                <label class="answer-label">
                                    <input type="radio" name="question_${s.index}" value="4" onchange="onAnswer(${s.index})">
                                    <span class="ans-let al-d">D</span>
                                    <span class="ans-txt">${q.reponse4}</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Navigation -->
                <div class="nav-btns">
                    <button type="button" class="btn btn-ghost" id="prevBtn" onclick="prev()" disabled>← Précédente</button>
                    <button type="button" class="btn btn-ghost" id="nextBtn" onclick="next()">Suivante →</button>
                </div>

                <!-- Submit -->
                <div class="submit-card">
                    <div class="submit-hint" id="submitHint">Répondez à toutes les questions avant de soumettre</div>
                    <button type="submit" class="btn-submit-exam" onclick="return confirmSubmit()">
                        ✅ Soumettre l'examen
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
const TOTAL = ${fn:length(sessionScope.questions)};
let current = 0;
let timeLeft = 15 * 60;
const answered = new Set();

// Timer
const timerEl = document.getElementById('timer');
const iv = setInterval(() => {
    if (--timeLeft <= 0) { clearInterval(iv); document.getElementById('examForm').submit(); return; }
    const m = Math.floor(timeLeft / 60), s = timeLeft % 60;
    timerEl.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    timerEl.className = 'timer' + (timeLeft < 120 ? ' danger' : timeLeft < 300 ? ' warn' : '');
}, 1000);

function goTo(idx) {
    document.querySelectorAll('.q-card').forEach(c => c.classList.remove('visible'));
    document.querySelectorAll('.q-dot').forEach(d => d.classList.remove('active'));
    document.getElementById('qcard' + idx).classList.add('visible');
    document.getElementById('dot' + idx).classList.add('active');
    current = idx;
    document.getElementById('prevBtn').disabled = idx === 0;
    document.getElementById('nextBtn').disabled = idx === TOTAL - 1;
}
function prev() { if (current > 0) goTo(current - 1); }
function next() { if (current < TOTAL - 1) goTo(current + 1); }

function onAnswer(idx) {
    answered.add(idx);
    document.getElementById('dot' + idx).classList.add('answered');
    document.getElementById('answeredCount').textContent = answered.size;
    document.getElementById('progressFill').style.width = (answered.size / TOTAL * 100) + '%';
    const rem = TOTAL - answered.size;
    const hint = document.getElementById('submitHint');
    if (rem === 0) { hint.textContent = '✓ Toutes les questions répondues'; hint.style.color = 'var(--accent)'; }
    else { hint.textContent = rem + ' question(s) sans réponse'; hint.style.color = 'var(--text3)'; }
}

function confirmSubmit() {
    const unanswered = TOTAL - answered.size;
    if (unanswered > 0) return confirm(unanswered + ' question(s) sans réponse. Soumettre quand même ?');
    return confirm('Soumettre votre examen ?');
}
</script>
</body>
</html>
