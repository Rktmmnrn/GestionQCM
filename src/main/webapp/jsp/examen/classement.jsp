<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Classement Général</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sora', sans-serif; background: #0f172a; min-height: 100vh; padding: 40px 20px; }
        .page-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 20px;
            max-width: 900px;
            margin: 0 auto;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }
        .page-header {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            padding: 35px 40px;
        }
        .page-header h1 { color: white; font-size: 1.8rem; font-weight: 800; margin: 0; }
        .page-header p { color: rgba(255,255,255,0.75); margin: 5px 0 0; font-size: 0.95rem; }

        /* Podium */
        .podium-section { padding: 35px 40px; border-bottom: 1px solid #334155; }
        .podium { display: flex; align-items: flex-end; justify-content: center; gap: 20px; }
        .podium-item { text-align: center; border-radius: 12px; padding: 20px 18px; width: 180px; }
        .podium-1 { background: linear-gradient(135deg, rgba(251,191,36,0.15), rgba(245,158,11,0.1)); border: 1px solid rgba(251,191,36,0.3); padding-bottom: 28px; }
        .podium-2 { background: rgba(99,102,241,0.08); border: 1px solid rgba(99,102,241,0.2); }
        .podium-3 { background: rgba(161,98,7,0.1); border: 1px solid rgba(161,98,7,0.2); }
        .medal { font-size: 2.5rem; display: block; margin-bottom: 10px; }
        .podium-name { color: #e2e8f0; font-weight: 700; font-size: 0.95rem; margin-bottom: 5px; }
        .podium-num { color: #64748b; font-size: 0.8rem; margin-bottom: 8px; }
        .podium-score { font-size: 1.5rem; font-weight: 800; }
        .score-1 { color: #fbbf24; }
        .score-2 { color: #6366f1; }
        .score-3 { color: #b45309; }

        /* Table */
        .table-section { padding: 30px 40px; }
        .section-title { color: #94a3b8; font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 18px; }
        .rank-table { width: 100%; border-collapse: collapse; }
        .rank-table th {
            background: #0f172a;
            color: #64748b;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 12px 16px;
            text-align: left;
        }
        .rank-table td { padding: 13px 16px; border-bottom: 1px solid #1e3a5f20; }
        .rank-table tr:last-child td { border-bottom: none; }
        .rank-table tr:hover td { background: rgba(99,102,241,0.04); }
        .rank-num { font-weight: 800; color: #64748b; font-size: 0.9rem; }
        .rank-num.top3 { color: #fbbf24; }
        .etudiant-name { color: #e2e8f0; font-weight: 600; font-size: 0.95rem; }
        .etudiant-id { color: #475569; font-size: 0.78rem; margin-top: 2px; }
        .annee-tag {
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 6px;
            padding: 3px 10px;
            color: #64748b;
            font-size: 0.78rem;
        }
        .note-badge {
            display: inline-block;
            padding: 5px 14px;
            border-radius: 20px;
            font-weight: 800; font-size: 0.95rem;
        }
        .note-badge.admis { background: rgba(34,197,94,0.15); color: #22c55e; }
        .note-badge.refuse { background: rgba(239,68,68,0.15); color: #ef4444; }

        .empty-state { text-align: center; padding: 50px; color: #475569; }
        .empty-state .icon { font-size: 3rem; margin-bottom: 15px; }

        .back-link { padding: 20px 40px; border-top: 1px solid #334155; }
        .back-link a { color: #475569; text-decoration: none; font-size: 0.85rem; font-weight: 600; }
        .back-link a:hover { color: #94a3b8; }
    </style>
</head>
<body>
    <div class="page-card">
        <div class="page-header">
            <h1>🏆 Classement Général</h1>
            <p>Résultats de tous les examens, triés par note</p>
        </div>

        <c:choose>
            <c:when test="${empty classement}">
                <div class="empty-state">
                    <div class="icon">📊</div>
                    <h4 style="color:#94a3b8;">Aucun résultat disponible</h4>
                    <p>Les résultats apparaîtront ici après les premiers examens.</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Podium -->
                <div class="podium-section">
                    <div class="podium">
                        <!-- 2ème -->
                        <c:if test="${classement.size() >= 2}">
                            <div class="podium-item podium-2">
                                <span class="medal">🥈</span>
                                <div class="podium-name">${classement[1].nomComplet}</div>
                                <div class="podium-num">${classement[1].numEtudiant}</div>
                                <div class="podium-score score-2">${classement[1].note}/10</div>
                            </div>
                        </c:if>
                        <!-- 1er -->
                        <div class="podium-item podium-1">
                            <span class="medal">🥇</span>
                            <div class="podium-name">${classement[0].nomComplet}</div>
                            <div class="podium-num">${classement[0].numEtudiant}</div>
                            <div class="podium-score score-1">${classement[0].note}/10</div>
                        </div>
                        <!-- 3ème -->
                        <c:if test="${classement.size() >= 3}">
                            <div class="podium-item podium-3">
                                <span class="medal">🥉</span>
                                <div class="podium-name">${classement[2].nomComplet}</div>
                                <div class="podium-num">${classement[2].numEtudiant}</div>
                                <div class="podium-score score-3">${classement[2].note}/10</div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Tableau complet -->
                <div class="table-section">
                    <div class="section-title">📋 Classement complet</div>
                    <table class="rank-table">
                        <thead>
                            <tr>
                                <th>Rang</th>
                                <th>Étudiant</th>
                                <th>Année univ.</th>
                                <th>Note</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="exam" items="${classement}" varStatus="s">
                                <tr>
                                    <td>
                                        <span class="rank-num ${s.index < 3 ? 'top3' : ''}">
                                            <c:choose>
                                                <c:when test="${s.index == 0}">🥇</c:when>
                                                <c:when test="${s.index == 1}">🥈</c:when>
                                                <c:when test="${s.index == 2}">🥉</c:when>
                                                <c:otherwise>#${s.index + 1}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="etudiant-name">${exam.nomComplet}</div>
                                        <div class="etudiant-id">${exam.numEtudiant}</div>
                                    </td>
                                    <td><span class="annee-tag">${exam.anneeUniv}</span></td>
                                    <td>
                                        <span class="note-badge ${exam.note >= 5 ? 'admis' : 'refuse'}">
                                            ${exam.note}/10
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/examen">← Retour à l'accueil des examens</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="${pageContext.request.contextPath}/">🏠 Accueil</a>
        </div>
    </div>
</body>
</html>
