<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Questions QCM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sora', sans-serif; background: #0f172a; min-height: 100vh; padding: 30px 20px; }
        .page-wrap { max-width: 900px; margin: 0 auto; }
        .page-header {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 16px 16px 0 0;
            padding: 30px 35px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .page-header h1 { color: white; font-size: 1.5rem; font-weight: 800; margin: 0; }
        .page-header p { color: rgba(255,255,255,0.75); margin: 4px 0 0; font-size: 0.88rem; }
        .btn-add {
            background: white; color: #6366f1;
            border: none; border-radius: 10px;
            padding: 10px 20px; font-weight: 700; font-size: 0.88rem;
            font-family: 'Sora', sans-serif; text-decoration: none; transition: all 0.2s;
        }
        .btn-add:hover { transform: translateY(-2px); color: #6366f1; }

        .alert-section { background: #1e293b; padding: 0 35px; border: 1px solid #334155; border-top: none; }
        .alert-ok { background: rgba(34,197,94,0.1); border: 1px solid rgba(34,197,94,0.3); border-radius: 10px; color: #86efac; padding: 11px 16px; margin-top: 18px; font-size: 0.88rem; }
        .alert-err { background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); border-radius: 10px; color: #fca5a5; padding: 11px 16px; margin-top: 18px; font-size: 0.88rem; }

        .questions-list {
            background: #1e293b;
            border: 1px solid #334155;
            border-top: none;
            border-radius: 0 0 16px 16px;
            padding: 25px 30px 35px;
        }
        .total-badge {
            background: #0f172a; border: 1px solid #334155; border-radius: 8px;
            padding: 5px 14px; color: #64748b; font-size: 0.8rem; font-weight: 600;
            display: inline-block; margin-bottom: 20px;
        }

        .q-card {
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 14px;
            margin-bottom: 18px;
            overflow: hidden;
            transition: border-color 0.2s;
        }
        .q-card:hover { border-color: #475569; }
        .q-card-header {
            background: #161f2f;
            padding: 14px 22px;
            display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid #334155;
        }
        .q-id {
            background: rgba(99,102,241,0.15); border: 1px solid rgba(99,102,241,0.25);
            color: #818cf8; border-radius: 6px; padding: 3px 10px;
            font-size: 0.78rem; font-weight: 700;
        }
        .q-actions { display: flex; gap: 8px; }
        .btn-edit {
            background: rgba(99,102,241,0.1); border: 1px solid rgba(99,102,241,0.25);
            color: #818cf8; border-radius: 7px; padding: 6px 14px;
            font-size: 0.78rem; font-weight: 700; font-family: 'Sora', sans-serif;
            text-decoration: none; transition: all 0.2s;
        }
        .btn-edit:hover { background: rgba(99,102,241,0.2); color: #818cf8; }
        .btn-del {
            background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.2);
            color: #f87171; border-radius: 7px; padding: 6px 14px;
            font-size: 0.78rem; font-weight: 700; font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-del:hover { background: rgba(239,68,68,0.15); }

        .q-body { padding: 20px 22px; }
        .q-text { color: #e2e8f0; font-weight: 600; font-size: 0.95rem; margin-bottom: 18px; line-height: 1.5; }
        .answers-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .ans-item {
            display: flex; align-items: center; gap: 10px;
            background: #1e293b; border: 1px solid #334155;
            border-radius: 8px; padding: 10px 14px;
        }
        .ans-item.correct { border-color: #22c55e; background: rgba(34,197,94,0.06); }
        .ans-letter {
            width: 26px; height: 26px; border-radius: 6px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 0.8rem; color: white; flex-shrink: 0;
        }
        .al-1 { background: #6366f1; }
        .al-2 { background: #8b5cf6; }
        .al-3 { background: #06b6d4; }
        .al-4 { background: #f59e0b; }
        .ans-text { color: #94a3b8; font-size: 0.85rem; flex: 1; }
        .ans-item.correct .ans-text { color: #4ade80; }
        .correct-tag {
            background: rgba(34,197,94,0.15); color: #22c55e;
            border-radius: 5px; padding: 2px 8px; font-size: 0.72rem; font-weight: 700;
        }

        .empty-state { text-align: center; padding: 50px; color: #475569; }
        .empty-state .icon { font-size: 3rem; margin-bottom: 15px; }
        .footer-links { margin-top: 20px; }
        .footer-links a { color: #475569; text-decoration: none; font-size: 0.85rem; font-weight: 600; }
        .footer-links a:hover { color: #94a3b8; }
    </style>
</head>
<body>
<div class="page-wrap">
    <div class="page-header">
        <div>
            <h1>❓ Questions QCM</h1>
            <p>Banque de questions à choix multiples</p>
        </div>
        <a href="${pageContext.request.contextPath}/qcm?action=new" class="btn-add">➕ Ajouter</a>
    </div>

    <div class="alert-section">
        <c:if test="${param.success == 'created'}"><div class="alert-ok">✅ Question ajoutée avec succès.</div></c:if>
        <c:if test="${param.success == 'updated'}"><div class="alert-ok">✅ Question modifiée.</div></c:if>
        <c:if test="${param.success == 'deleted'}"><div class="alert-ok">✅ Question supprimée.</div></c:if>
        <c:if test="${param.error == 'createFailed'}"><div class="alert-err">❌ Erreur lors de l'ajout de la question.</div></c:if>
    </div>

    <div class="questions-list">
        <c:choose>
            <c:when test="${empty questions}">
                <div class="empty-state">
                    <div class="icon">📭</div>
                    <h4 style="color:#94a3b8;">Aucune question</h4>
                    <p>Ajoutez des questions QCM pour commencer.</p>
                    <a href="${pageContext.request.contextPath}/qcm?action=new"
                       style="background:#6366f1;color:white;border-radius:8px;padding:10px 22px;text-decoration:none;font-weight:700;font-size:0.9rem;">
                        ➕ Première question
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="total-badge">${questions.size()} question(s)</div>

                <c:forEach var="q" items="${questions}">
                    <div class="q-card">
                        <div class="q-card-header">
                            <span class="q-id">#${q.numQuest}</span>
                            <div class="q-actions">
                                <a href="${pageContext.request.contextPath}/qcm?action=edit&id=${q.numQuest}"
                                   class="btn-edit">✏️ Modifier</a>
                                <button class="btn-del" onclick="confirmDel(${q.numQuest})">🗑️ Suppr.</button>
                            </div>
                        </div>
                        <div class="q-body">
                            <div class="q-text">${q.question}</div>
                            <div class="answers-grid">
                                <div class="ans-item ${q.bonneRep == 1 ? 'correct' : ''}">
                                    <span class="ans-letter al-1">A</span>
                                    <span class="ans-text">${q.reponse1}</span>
                                    <c:if test="${q.bonneRep == 1}"><span class="correct-tag">✓</span></c:if>
                                </div>
                                <div class="ans-item ${q.bonneRep == 2 ? 'correct' : ''}">
                                    <span class="ans-letter al-2">B</span>
                                    <span class="ans-text">${q.reponse2}</span>
                                    <c:if test="${q.bonneRep == 2}"><span class="correct-tag">✓</span></c:if>
                                </div>
                                <div class="ans-item ${q.bonneRep == 3 ? 'correct' : ''}">
                                    <span class="ans-letter al-3">C</span>
                                    <span class="ans-text">${q.reponse3}</span>
                                    <c:if test="${q.bonneRep == 3}"><span class="correct-tag">✓</span></c:if>
                                </div>
                                <div class="ans-item ${q.bonneRep == 4 ? 'correct' : ''}">
                                    <span class="ans-letter al-4">D</span>
                                    <span class="ans-text">${q.reponse4}</span>
                                    <c:if test="${q.bonneRep == 4}"><span class="correct-tag">✓</span></c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/">← Accueil</a>
        </div>
    </div>
</div>

<script>
    function confirmDel(id) {
        if (confirm('Supprimer la question #' + id + ' ?\nCette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/qcm?action=delete&id=' + id;
        }
    }
</script>
</body>
</html>
