<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Integer note = (Integer) session.getAttribute("note");
    if (note == null) { response.sendRedirect(request.getContextPath() + "/examen"); return; }
    request.setAttribute("currentPage", "examen");
    int noteVal = note;
    int nbBonnes = session.getAttribute("nbBonnes") != null ? (Integer) session.getAttribute("nbBonnes") : 0;
    int total = session.getAttribute("totalQuestions") != null ? (Integer) session.getAttribute("totalQuestions") : 10;
    boolean admis = noteVal >= 5;
    String[][] details = (String[][]) session.getAttribute("details");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats — GestionExamens</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <style>
        .score-hero { text-align:center; padding: 30px 20px 20px; border-bottom: 1px solid var(--border); }
        .score-num { font-family:'DM Mono',monospace; font-size: 4rem; font-weight: 700; line-height: 1; }
        .score-num.ok { color: var(--accent); }
        .score-num.ko { color: var(--danger); }
        .detail-item { display:flex; align-items:flex-start; gap:12px; padding:12px 14px; border-radius:7px; margin-bottom:8px; }
        .detail-item.ok { background: var(--accent-bg); }
        .detail-item.ko { background: var(--danger-bg); }
        .detail-item.absent { background: var(--warn-bg); }
        .det-icon { width:24px;height:24px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0;margin-top:1px; }
        .det-icon.ok { background:var(--accent);color:white; }
        .det-icon.ko { background:var(--danger);color:white; }
        .det-icon.absent { background:var(--warn);color:white; }
        .det-q { font-size:0.85rem;font-weight:600;color:var(--text);margin-bottom:3px; }
        .det-a { font-size:0.78rem; }
        .det-a .ok-txt { color:var(--accent2);font-weight:600; }
        .det-a .ko-txt { color:var(--danger); }
        .det-a .exp-txt { color:var(--accent2); }
        .det-a .muted { color:var(--text3); }
    </style>
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                📊 Résultats <span class="topbar-breadcrumb">/ Examen QCM</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">🔄 Repasser</a>
                <a href="${pageContext.request.contextPath}/examen?action=classement" class="btn btn-ghost">🏆 Classement</a>
            </div>
        </div>

        <div class="page-body">
            <div style="max-width:700px;margin:0 auto;">

                <!-- Score hero -->
                <div class="card mb-6">
                    <div class="score-hero">
                        <div class="score-num <%= admis ? "ok" : "ko" %>"><%= noteVal %>/10</div>
                        <div style="margin-top:10px;">
                            <span class="badge <%= admis ? "badge-green" : "badge-red" %>" style="font-size:0.85rem;padding:5px 14px;">
                                <%= admis ? "✅ ADMIS" : "❌ NON ADMIS" %>
                            </span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="stats-row" style="margin-bottom:0;">
                            <div class="stat-card green">
                                <div class="stat-label">Bonnes réponses</div>
                                <div class="stat-value"><%= nbBonnes %></div>
                                <div class="stat-sub">sur <%= total %></div>
                            </div>
                            <div class="stat-card red">
                                <div class="stat-label">Fausses / Absentes</div>
                                <div class="stat-value"><%= total - nbBonnes %></div>
                                <div class="stat-sub">sur <%= total %></div>
                            </div>
                            <div class="stat-card <%= admis ? "green" : "red" %>">
                                <div class="stat-label">Pourcentage</div>
                                <div class="stat-value"><%= noteVal * 10 %>%</div>
                                <div class="stat-sub">seuil : 50%</div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="alert alert-info" style="margin-bottom:0;">
                            📧 Un récapitulatif a été envoyé à votre adresse email enregistrée.
                        </div>
                    </div>
                </div>

                <!-- Détail -->
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">📋 Détail des réponses</span>
                    </div>
                    <div class="card-body">
                        <% if (details != null) {
                            for (int i = 0; i < details.length; i++) {
                                String statut = details[i][2];
                                String cssClass = "correct".equals(statut) ? "ok" : ("absent".equals(statut) ? "absent" : "ko");
                                String icon = "correct".equals(statut) ? "✓" : ("absent".equals(statut) ? "?" : "✗");
                        %>
                        <div class="detail-item <%= cssClass %>">
                            <div class="det-icon <%= cssClass %>"><%= icon %></div>
                            <div style="flex:1;">
                                <div class="det-q"><%= (i+1) %>. <%= details[i][0] != null ? details[i][0] : "" %></div>
                                <div class="det-a">
                                    <% if ("correct".equals(statut)) { %>
                                        <span class="ok-txt">✓ <%= details[i][1] %></span>
                                    <% } else if ("absent".equals(statut)) { %>
                                        <span class="muted">Sans réponse</span>
                                        <span class="exp-txt"> — Bonne réponse : <%= details[i][3] %></span>
                                    <% } else { %>
                                        <span class="ko-txt">✗ <%= details[i][1] %></span>
                                        <span class="exp-txt"> — Bonne réponse : <%= details[i][3] %></span>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
</body>
</html>
