<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("currentPage", "qcm"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Questions QCM — GestionQuestionnaire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <style>
        .qcm-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-bottom: 14px; overflow: hidden; transition: box-shadow 0.15s; }
        .qcm-card:hover { box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
        .qcm-card-head { padding: 12px 18px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: var(--bg); }
        .qcm-body { padding: 16px 18px; }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggle = document.getElementById('menu-toggle');
            const sidebar = document.getElementById('sidebar');
            if (toggle && sidebar) {
                toggle.addEventListener('click', function() {
                    sidebar.classList.toggle('open');
                    if (sidebar.classList.contains('open')) {
                        document.body.classList.add('sidebar-open');
                    } else {
                        document.body.classList.remove('sidebar-open');
                    }
                });
                document.addEventListener('click', function(e) {
                    if (!sidebar.contains(e.target) && !toggle.contains(e.target) && sidebar.classList.contains('open')) {
                        sidebar.classList.remove('open');
                        document.body.classList.remove('sidebar-open');
                    }
                });
            }
        });
    </script>
        .qcm-question { font-weight: 600; font-size: 0.9rem; color: var(--text); margin-bottom: 14px; line-height: 1.5; }
        .answers-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .ans { display: flex; align-items: center; gap: 8px; padding: 8px 12px; border-radius: 6px; background: var(--bg); border: 1px solid var(--border); font-size: 0.82rem; }
        .ans.correct { background: var(--accent-bg); border-color: #bbf7d0; }
        .ans .let { width: 22px; height: 22px; border-radius: 5px; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.72rem; color: white; flex-shrink: 0; }
        .la { background: #6366f1; }
        .lb { background: #8b5cf6; }
        .lc { background: #0891b2; }
        .ld { background: #d97706; }
        .ans.correct .ans-text { color: var(--accent2); font-weight: 600; }
        .ans-text { color: var(--text2); }
        .correct-tag { margin-left: auto; font-size: 0.65rem; font-weight: 700; color: var(--accent2); }
    </style>
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <button class="sidebar-toggle" id="menu-toggle" title="Afficher/masquer le menu">☰</button>
            <div class="topbar-title">
                ❓ Questions QCM <span class="topbar-breadcrumb">/ Liste</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/qcm?action=new" class="btn btn-primary">➕ Ajouter</a>
            </div>
        </div>

        <div class="page-body">

            <c:if test="${param.success == 'created'}"><div class="alert alert-success">✅ Question ajoutée.</div></c:if>
            <c:if test="${param.success == 'updated'}"><div class="alert alert-success">✅ Question modifiée.</div></c:if>
            <c:if test="${param.success == 'deleted'}"><div class="alert alert-success">✅ Question supprimée.</div></c:if>
            <c:if test="${param.error == 'createFailed'}"><div class="alert alert-error">❌ Erreur lors de l'ajout.</div></c:if>

            <div class="flex-between mb-4">
                <div class="text-muted text-sm">
                    <c:choose>
                        <c:when test="${not empty questions}">${questions.size()} question(s) dans la banque</c:when>
                        <c:otherwise>Aucune question</c:otherwise>
                    </c:choose>
                    <c:if test="${not empty questions}">
                        —
                        <c:choose>
                            <c:when test="${questions.size() >= 10}"><span style="color:var(--accent);font-weight:600;">✓ Assez pour un examen</span></c:when>
                            <c:otherwise><span style="color:var(--danger);font-weight:600;">⚠ Moins de 10 questions (minimum requis)</span></c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty questions}">
                    <div class="card">
                        <div class="empty-state">
                            <div class="empty-icon">❓</div>
                            <h3>Aucune question QCM</h3>
                            <p>Ajoutez au moins 10 questions pour pouvoir faire passer des examens.</p>
                            <a href="${pageContext.request.contextPath}/qcm?action=new" class="btn btn-primary">➕ Première question</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="q" items="${questions}">
                        <div class="qcm-card">
                            <div class="qcm-card-head">
                                <span class="badge badge-gray mono">#${q.numQuest}</span>
                                <div class="flex gap-2">
                                    <a href="${pageContext.request.contextPath}/qcm?action=edit&id=${q.numQuest}" class="btn btn-ghost btn-sm">✏️ Modifier</a>
                                    <button class="btn btn-danger btn-sm" onclick="confirmDel(${q.numQuest})">🗑️</button>
                                </div>
                            </div>
                            <div class="qcm-body">
                                <div class="qcm-question">${q.question}</div>
                                <div class="answers-grid">
                                    <div class="ans ${q.bonneRep == 1 ? 'correct' : ''}">
                                        <span class="let la">A</span>
                                        <span class="ans-text">${q.reponse1}</span>
                                        <c:if test="${q.bonneRep == 1}"><span class="correct-tag">✓ Bonne</span></c:if>
                                    </div>
                                    <div class="ans ${q.bonneRep == 2 ? 'correct' : ''}">
                                        <span class="let lb">B</span>
                                        <span class="ans-text">${q.reponse2}</span>
                                        <c:if test="${q.bonneRep == 2}"><span class="correct-tag">✓ Bonne</span></c:if>
                                    </div>
                                    <div class="ans ${q.bonneRep == 3 ? 'correct' : ''}">
                                        <span class="let lc">C</span>
                                        <span class="ans-text">${q.reponse3}</span>
                                        <c:if test="${q.bonneRep == 3}"><span class="correct-tag">✓ Bonne</span></c:if>
                                    </div>
                                    <div class="ans ${q.bonneRep == 4 ? 'correct' : ''}">
                                        <span class="let ld">D</span>
                                        <span class="ans-text">${q.reponse4}</span>
                                        <c:if test="${q.bonneRep == 4}"><span class="correct-tag">✓ Bonne</span></c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
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
