<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription à l'examen</title>
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
        .card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 20px;
            padding: 50px 45px;
            max-width: 480px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }
        h2 { color: #f1f5f9; font-weight: 800; font-size: 1.7rem; margin-bottom: 8px; }
        .subtitle { color: #64748b; font-size: 0.95rem; margin-bottom: 35px; }
        label { color: #94a3b8; font-size: 0.9rem; font-weight: 600; margin-bottom: 8px; display: block; }
        .form-control {
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 10px;
            color: #f1f5f9;
            padding: 12px 16px;
            font-family: 'Sora', sans-serif;
            font-size: 0.95rem;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            background: #0f172a;
            border-color: #6366f1;
            color: #f1f5f9;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }
        .form-group { margin-bottom: 22px; }
        .hint { color: #475569; font-size: 0.8rem; margin-top: 5px; }
        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
            font-family: 'Sora', sans-serif;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(99,102,241,0.4); }
        .alert-error {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.3);
            border-radius: 10px;
            color: #fca5a5;
            padding: 14px 18px;
            margin-bottom: 25px;
            font-size: 0.9rem;
        }
        .back-link { text-align: center; margin-top: 20px; }
        .back-link a { color: #475569; text-decoration: none; font-size: 0.85rem; }
        .back-link a:hover { color: #94a3b8; }
    </style>
</head>
<body>
    <div class="card">
        <h2>📋 Inscription</h2>
        <p class="subtitle">Renseignez vos informations pour démarrer l'examen</p>

        <c:if test="${not empty erreur}">
            <div class="alert-error">⚠️ ${erreur}</div>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/examen">
            <input type="hidden" name="action" value="demarrer">

            <div class="form-group">
                <label for="numEtudiant">Numéro étudiant</label>
                <input type="text" class="form-control" id="numEtudiant" name="numEtudiant"
                       placeholder="Ex: E001001" required
                       value="${param.numEtudiant}">
                <div class="hint">Votre identifiant unique d'étudiant</div>
            </div>

            <div class="form-group">
                <label for="anneeUniv">Année universitaire</label>
                <input type="text" class="form-control" id="anneeUniv" name="anneeUniv"
                       placeholder="Ex: 2024-2025" required
                       pattern="\d{4}-\d{4}"
                       value="${not empty param.anneeUniv ? param.anneeUniv : '2024-2025'}">
                <div class="hint">Format : AAAA-AAAA</div>
            </div>

            <button type="submit" class="btn-submit">🚀 Démarrer l'examen</button>
        </form>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/examen">← Retour</a>
        </div>
    </div>
</body>
</html>
