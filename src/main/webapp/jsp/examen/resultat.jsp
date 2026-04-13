<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Integer note = (Integer) session.getAttribute("note");
    if (note == null) {
        response.sendRedirect(request.getContextPath() + "/examen");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats de l'examen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sora', sans-serif; background: #0f172a; min-height: 100vh; padding: 40px 20px; }
        .results-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 24px;
            padding: 50px 45px;
            max-width: 700px;
            margin: 0 auto;
            box-shadow: 0 25px 60px rgba(0,0,0,0.4);
        }
        .score-big {
            font-size: 5rem; font-weight: 800;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            line-height: 1; margin-bottom: 5px;
        }
        .score-big.success { background: linear-gradient(135deg, #22c55e, #16a34a); -webkit-background-clip: text; }
        .score-big.fail { background: linear-gradient(135deg, #ef4444, #dc2626); -webkit-background-clip: text; }
        h1 { color: #f1f5f9; font-size: 1.6rem; font-weight: 800; margin-bottom: 6px; text-align: center; }
        .status-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 700; font-size: 0.9rem;
            margin-bottom: 30px;
        }
        .status-badge.admis { background: rgba(34,197,94,0.15); color: #22c55e; border: 1px solid rgba(34,197,94,0.3); }
        .status-badge.refuse { background: rgba(239,68,68,0.15); color: #ef4444; border: 1px solid rgba(239,68,68,0.3); }

        .stats-row { display: grid; grid-template-columns: repeat(3,1fr); gap: 15px; margin-bottom: 30px; }
        .stat-box {
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 12px;
            padding: 18px;
            text-align: center;
        }
        .stat-val { font-size: 1.8rem; font-weight: 800; }
        .stat-val.ok { color: #22c55e; }
        .stat-val.ko { color: #ef4444; }
        .stat-val.neutral { color: #6366f1; }
        .stat-lbl { color: #64748b; font-size: 0.8rem; margin-top: 5px; }

        .detail-title { color: #94a3b8; font-size: 0.9rem; font-weight: 700; margin-bottom: 15px; text-transform: uppercase; letter-spacing: 0.05em; }
        .detail-item {
            background: #0f172a;
            border-left: 3px solid #334155;
            border-radius: 0 10px 10px 0;
            padding: 14px 18px;
            margin-bottom: 10px;
            display: flex; align-items: flex-start; gap: 14px;
        }
        .detail-item.ok { border-left-color: #22c55e; }
        .detail-item.ko { border-left-color: #ef4444; }
        .detail-item.absent { border-left-color: #f59e0b; }
        .num-badge {
            width: 30px; height: 30px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 0.8rem;
            flex-shrink: 0;
        }
        .num-badge.ok { background: rgba(34,197,94,0.15); color: #22c55e; }
        .num-badge.ko { background: rgba(239,68,68,0.15); color: #ef4444; }
        .num-badge.absent { background: rgba(245,158,11,0.15); color: #f59e0b; }
        .detail-q { color: #cbd5e1; font-size: 0.9rem; font-weight: 600; margin-bottom: 4px; }
        .detail-ans { font-size: 0.82rem; }
        .detail-ans .given { color: #64748b; }
        .detail-ans .correct { color: #22c55e; font-weight: 600; }
        .detail-ans .wrong { color: #ef4444; }
        .detail-ans .expected { color: #22c55e; }

        .actions { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 30px; }
        .btn-action {
            flex: 1; min-width: 160px;
            border-radius: 10px;
            padding: 13px 20px;
            font-weight: 700; font-size: 0.9rem;
            font-family: 'Sora', sans-serif;
            text-decoration: none;
            text-align: center;
            transition: all 0.2s;
            border: none; cursor: pointer;
        }
        .btn-primary-act {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
        }
        .btn-primary-act:hover { transform: translateY(-2px); color: white; box-shadow: 0 8px 20px rgba(99,102,241,0.3); }
        .btn-outline-act {
            background: transparent;
            border: 1px solid #334155;
            color: #94a3b8;
        }
        .btn-outline-act:hover { border-color: #6366f1; color: #6366f1; }

        .email-notice {
            background: rgba(99,102,241,0.08);
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 10px;
            padding: 14px 18px;
            color: #94a3b8;
            font-size: 0.85rem;
            margin-bottom: 25px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="results-card">
        <div style="text-align:center; margin-bottom: 30px;">
            <%
                int noteVal = (Integer) session.getAttribute("note");
                int nbBonnes = session.getAttribute("nbBonnes") != null ? (Integer) session.getAttribute("nbBonnes") : 0;
                int total = session.getAttribute("totalQuestions") != null ? (Integer) session.getAttribute("totalQuestions") : 10;
                boolean admis = noteVal >= 5;
            %>
            <div class="score-big <%= admis ? "success" : "fail" %>">
                <%= noteVal %>/10
            </div>
            <h1>Résultats de votre examen</h1>
            <div class="status-badge <%= admis ? "admis" : "refuse" %>">
                <%= admis ? "✅ ADMIS" : "❌ NON ADMIS" %>
            </div>
        </div>

        <div class="stats-row">
            <div class="stat-box">
                <div class="stat-val ok"><%= nbBonnes %></div>
                <div class="stat-lbl">Bonnes réponses</div>
            </div>
            <div class="stat-box">
                <div class="stat-val ko"><%= total - nbBonnes %></div>
                <div class="stat-lbl">Mauvaises / Absentes</div>
            </div>
            <div class="stat-box">
                <div class="stat-val neutral"><%= Math.round(noteVal * 10.0) %>%</div>
                <div class="stat-lbl">Pourcentage</div>
            </div>
        </div>

        <div class="email-notice">
            📧 Un récapitulatif de vos résultats a été envoyé à votre adresse email.
        </div>

        <!-- Détail des réponses -->
        <div class="detail-title">📋 Détail des réponses</div>
        <%
            String[][] details = (String[][]) session.getAttribute("details");
            if (details != null) {
                for (int i = 0; i < details.length; i++) {
                    String statut = details[i][2]; // "correct", "incorrect", "absent"
                    String cssClass = "correct".equals(statut) ? "ok" : ("absent".equals(statut) ? "absent" : "ko");
                    String icon = "correct".equals(statut) ? "✓" : ("absent".equals(statut) ? "?" : "✗");
        %>
        <div class="detail-item <%= cssClass %>">
            <div class="num-badge <%= cssClass %>"><%= icon %></div>
            <div style="flex:1">
                <div class="detail-q"><%= (i+1) %>. <%= details[i][0] != null ? details[i][0] : "" %></div>
                <div class="detail-ans">
                    <%if ("correct".equals(statut)) {%>
                        <span class="correct">✓ <%= details[i][1] %></span>
                    <%} else if ("absent".equals(statut)) {%>
                        <span class="given">Sans réponse</span>
                        <span class="expected"> — Bonne : <%= details[i][3] %></span>
                    <%} else {%>
                        <span class="wrong">✗ Votre réponse : <%= details[i][1] %></span>
                        <span class="expected"> — Bonne : <%= details[i][3] %></span>
                    <%}%>
                </div>
            </div>
        </div>
        <%
                }
            }
        %>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/examen?action=start" class="btn-action btn-primary-act">
                🔄 Repasser l'examen
            </a>
            <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn-action btn-outline-act">
                🏆 Classement
            </a>
            <a href="${pageContext.request.contextPath}/" class="btn-action btn-outline-act">
                🏠 Accueil
            </a>
        </div>
    </div>
</body>
</html>
