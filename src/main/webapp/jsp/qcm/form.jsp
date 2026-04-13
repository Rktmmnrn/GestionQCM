<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty question}">Modifier</c:when><c:otherwise>Ajouter</c:otherwise></c:choose> une question</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Sora', sans-serif;
            background: #0f172a;
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            padding: 40px 20px;
        }
        .form-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 20px;
            padding: 50px 45px;
            max-width: 620px; width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }
        h2 { color: #f1f5f9; font-weight: 800; font-size: 1.6rem; margin-bottom: 6px; }
        .subtitle { color: #64748b; font-size: 0.9rem; margin-bottom: 35px; }
        .section-title {
            color: #94a3b8; font-size: 0.78rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.05em;
            margin-bottom: 16px; margin-top: 28px;
            display: flex; align-items: center; gap: 8px;
        }
        .section-title::after { content:''; flex:1; height:1px; background:#334155; }

        label { color: #94a3b8; font-size: 0.85rem; font-weight: 600; margin-bottom: 7px; display: block; }
        .form-control, textarea.form-control {
            background: #0f172a; border: 1px solid #334155; border-radius: 10px;
            color: #f1f5f9; padding: 12px 16px;
            font-family: 'Sora', sans-serif; font-size: 0.9rem; width: 100%;
            transition: border-color 0.3s;
        }
        .form-control:focus, textarea.form-control:focus {
            outline: none; border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }
        textarea.form-control { resize: vertical; min-height: 90px; }
        .form-group { margin-bottom: 18px; }

        /* Answer rows */
        .answer-row {
            display: flex; align-items: center; gap: 12px;
            background: #0f172a; border: 1px solid #334155; border-radius: 10px;
            padding: 12px 16px; margin-bottom: 12px;
            transition: border-color 0.2s;
        }
        .answer-row:has(input[type="radio"]:checked) { border-color: #22c55e; background: rgba(34,197,94,0.04); }
        .letter-badge {
            width: 32px; height: 32px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 0.85rem; color: white; flex-shrink: 0;
        }
        .ltr-a { background: #6366f1; }
        .ltr-b { background: #8b5cf6; }
        .ltr-c { background: #06b6d4; }
        .ltr-d { background: #f59e0b; }
        .answer-input {
            flex: 1; background: transparent; border: none; outline: none;
            color: #e2e8f0; font-family: 'Sora', sans-serif; font-size: 0.9rem;
        }
        input[type="radio"] { accent-color: #22c55e; width: 18px; height: 18px; cursor: pointer; flex-shrink: 0; }
        .radio-label { color: #64748b; font-size: 0.78rem; white-space: nowrap; }

        .btn-submit {
            width: 100%; background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white; border: none; border-radius: 10px;
            padding: 14px; font-size: 1rem; font-weight: 700;
            font-family: 'Sora', sans-serif; cursor: pointer; transition: all 0.3s;
            margin-bottom: 12px; margin-top: 10px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(99,102,241,0.4); }
        .btn-back {
            width: 100%; background: transparent; border: 1px solid #334155; color: #64748b;
            border-radius: 10px; padding: 12px; font-size: 0.9rem; font-weight: 600;
            font-family: 'Sora', sans-serif; cursor: pointer; text-decoration: none;
            display: block; text-align: center; transition: all 0.2s;
        }
        .btn-back:hover { border-color: #6366f1; color: #6366f1; }
        .hint { color: #475569; font-size: 0.78rem; margin-top: 5px; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>
            <c:choose>
                <c:when test="${not empty question}">✏️ Modifier la question</c:when>
                <c:otherwise>➕ Nouvelle question QCM</c:otherwise>
            </c:choose>
        </h2>
        <p class="subtitle">
            <c:if test="${not empty question}">Question #${question.numQuest} — </c:if>
            Renseignez la question et ses quatre réponses
        </p>

        <form method="POST" action="${pageContext.request.contextPath}/qcm">
            <input type="hidden" name="action"
                   value="${not empty question ? 'update' : 'create'}">
            <c:if test="${not empty question}">
                <input type="hidden" name="numQuest" value="${question.numQuest}">
            </c:if>

            <div class="section-title">Énoncé</div>
            <div class="form-group">
                <label for="question">Question *</label>
                <textarea class="form-control" id="question" name="question"
                          placeholder="Entrez l'énoncé de la question..." required>${not empty question ? question.question : ''}</textarea>
            </div>

            <div class="section-title">Réponses — cochez la bonne</div>
            <div class="hint" style="margin-bottom:14px;">Cochez le bouton radio correspondant à la bonne réponse</div>

            <div class="answer-row">
                <span class="letter-badge ltr-a">A</span>
                <input type="text" class="answer-input" name="reponse1"
                       placeholder="Réponse A..."
                       value="${not empty question ? question.reponse1 : ''}" required>
                <input type="radio" name="bonneRep" value="1"
                       ${(not empty question && question.bonneRep == 1) ? 'checked' : ''} required>
                <span class="radio-label">Bonne</span>
            </div>

            <div class="answer-row">
                <span class="letter-badge ltr-b">B</span>
                <input type="text" class="answer-input" name="reponse2"
                       placeholder="Réponse B..."
                       value="${not empty question ? question.reponse2 : ''}" required>
                <input type="radio" name="bonneRep" value="2"
                       ${(not empty question && question.bonneRep == 2) ? 'checked' : ''}>
                <span class="radio-label">Bonne</span>
            </div>

            <div class="answer-row">
                <span class="letter-badge ltr-c">C</span>
                <input type="text" class="answer-input" name="reponse3"
                       placeholder="Réponse C..."
                       value="${not empty question ? question.reponse3 : ''}" required>
                <input type="radio" name="bonneRep" value="3"
                       ${(not empty question && question.bonneRep == 3) ? 'checked' : ''}>
                <span class="radio-label">Bonne</span>
            </div>

            <div class="answer-row">
                <span class="letter-badge ltr-d">D</span>
                <input type="text" class="answer-input" name="reponse4"
                       placeholder="Réponse D..."
                       value="${not empty question ? question.reponse4 : ''}" required>
                <input type="radio" name="bonneRep" value="4"
                       ${(not empty question && question.bonneRep == 4) ? 'checked' : ''}>
                <span class="radio-label">Bonne</span>
            </div>

            <button type="submit" class="btn-submit">
                ${not empty question ? '💾 Enregistrer les modifications' : '➕ Ajouter la question'}
            </button>
            <a href="${pageContext.request.contextPath}/qcm" class="btn-back">← Retour à la liste</a>
        </form>
    </div>
</body>
</html>
