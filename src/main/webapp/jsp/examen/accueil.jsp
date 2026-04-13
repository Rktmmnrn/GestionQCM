<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Examens QCM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Sora', sans-serif;
            background: #0f172a;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .hero-card {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border: 1px solid #334155;
            border-radius: 24px;
            padding: 60px 50px;
            max-width: 680px;
            width: 100%;
            text-align: center;
            box-shadow: 0 25px 60px rgba(0,0,0,0.5);
        }
        .icon-circle {
            width: 90px; height: 90px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 30px;
            box-shadow: 0 8px 30px rgba(99,102,241,0.4);
        }
        h1 { color: #f1f5f9; font-size: 2rem; font-weight: 800; margin-bottom: 12px; }
        .subtitle { color: #94a3b8; font-size: 1.05rem; margin-bottom: 40px; }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 40px;
        }
        .info-box {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 12px;
            padding: 18px 12px;
        }
        .info-box .val { color: #6366f1; font-size: 1.6rem; font-weight: 800; }
        .info-box .lbl { color: #64748b; font-size: 0.8rem; margin-top: 4px; }
        .btn-start {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 16px 50px;
            font-size: 1.1rem;
            font-weight: 700;
            font-family: 'Sora', sans-serif;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            box-shadow: 0 8px 25px rgba(99,102,241,0.4);
        }
        .btn-start:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(99,102,241,0.5);
            color: white;
        }
        .btn-classement {
            background: transparent;
            color: #94a3b8;
            border: 1px solid #334155;
            border-radius: 12px;
            padding: 14px 30px;
            font-size: 0.95rem;
            font-weight: 600;
            font-family: 'Sora', sans-serif;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            margin-left: 15px;
        }
        .btn-classement:hover {
            border-color: #6366f1;
            color: #6366f1;
        }
        .rules {
            background: rgba(99,102,241,0.08);
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 12px;
            padding: 20px;
            text-align: left;
            margin-bottom: 35px;
        }
        .rules li { color: #94a3b8; font-size: 0.9rem; margin-bottom: 6px; }
        .back-link { margin-top: 30px; }
        .back-link a { color: #64748b; text-decoration: none; font-size: 0.9rem; }
        .back-link a:hover { color: #94a3b8; }
    </style>
</head>
<body>
    <div class="hero-card">
        <div class="icon-circle">✏️</div>
        <h1>Examen QCM en ligne</h1>
        <p class="subtitle">Testez vos connaissances avec 10 questions choisies aléatoirement</p>

        <div class="info-grid">
            <div class="info-box">
                <div class="val">10</div>
                <div class="lbl">Questions</div>
            </div>
            <div class="info-box">
                <div class="val">15 min</div>
                <div class="lbl">Durée</div>
            </div>
            <div class="info-box">
                <div class="val">/10</div>
                <div class="lbl">Note sur</div>
            </div>
        </div>

        <div class="rules">
            <ul style="margin:0; padding-left: 20px;">
                <li>Une seule réponse correcte par question</li>
                <li>Le timer démarre dès le début du QCM</li>
                <li>La soumission est automatique à la fin du temps</li>
                <li>Le résultat vous est envoyé par email</li>
                <li>Seuil de réussite : 5/10</li>
            </ul>
        </div>

        <div>
            <a href="${pageContext.request.contextPath}/examen?action=start" class="btn-start">
                🚀 Commencer l'examen
            </a>
            <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn-classement">
                🏆 Classement
            </a>
        </div>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/">← Retour à l'accueil</a>
        </div>
    </div>
</body>
</html>
