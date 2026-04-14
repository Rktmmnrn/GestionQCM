<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("currentPage", "classement"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Classement — GestionExamens</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <style>
        .podium { display: flex; align-items: flex-end; gap: 16px; justify-content: center; padding: 24px 20px; }
        .pod-item { text-align: center; border-radius: 10px; padding: 20px 24px; min-width: 160px; }
        .pod-1 { background: #fef3c7; border: 1px solid #fde68a; padding-top: 30px; }
        .pod-2 { background: var(--surface2); border: 1px solid var(--border); }
        .pod-3 { background: #fdf2e9; border: 1px solid #fcd9a0; }
        .pod-medal { font-size: 2rem; display: block; margin-bottom: 8px; }
        .pod-name { font-weight: 700; font-size: 0.9rem; color: var(--text); margin-bottom: 4px; }
        .pod-id { font-family:'DM Mono',monospace; font-size: 0.72rem; color: var(--text3); margin-bottom: 8px; }
        .pod-score { font-family:'DM Mono',monospace; font-size: 1.4rem; font-weight: 700; }
        .pod-1 .pod-score { color: #92400e; }
        .pod-2 .pod-score { color: #374151; }
        .pod-3 .pod-score { color: #9a3412; }
    </style>
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                🏆 Classement <span class="topbar-breadcrumb">/ Général</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">✏️ Passer l'examen</a>
            </div>
        </div>

        <div class="page-body">
            <c:choose>
                <c:when test="${empty classement}">
                    <div class="card">
                        <div class="empty-state">
                            <div class="empty-icon">🏆</div>
                            <h3>Aucun résultat</h3>
                            <p>Le classement apparaîtra après le premier examen.</p>
                            <a href="${pageContext.request.contextPath}/examen?action=start" class="btn btn-primary">✏️ Passer le premier examen</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>

                    <!-- Podium top 3 -->
                    <c:if test="${classement.size() >= 1}">
                        <div class="card mb-6">
                            <div class="card-header">
                                <span class="card-title">🥇 Podium</span>
                                <span class="badge badge-gray">${classement.size()} participant(s)</span>
                            </div>
                            <div class="podium">
                                <!-- 2e -->
                                <c:if test="${classement.size() >= 2}">
                                    <div class="pod-item pod-2">
                                        <span class="pod-medal">🥈</span>
                                        <div class="pod-name">${classement[1].nomComplet}</div>
                                        <div class="pod-id">${classement[1].numEtudiant}</div>
                                        <div class="pod-score">${classement[1].note}/10</div>
                                    </div>
                                </c:if>
                                <!-- 1er -->
                                <div class="pod-item pod-1">
                                    <span class="pod-medal">🥇</span>
                                    <div class="pod-name">${classement[0].nomComplet}</div>
                                    <div class="pod-id">${classement[0].numEtudiant}</div>
                                    <div class="pod-score">${classement[0].note}/10</div>
                                </div>
                                <!-- 3e -->
                                <c:if test="${classement.size() >= 3}">
                                    <div class="pod-item pod-3">
                                        <span class="pod-medal">🥉</span>
                                        <div class="pod-name">${classement[2].nomComplet}</div>
                                        <div class="pod-id">${classement[2].numEtudiant}</div>
                                        <div class="pod-score">${classement[2].note}/10</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <!-- Tableau complet -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">📋 Classement complet</span>
                        </div>
                        <div style="overflow-x:auto;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Rang</th>
                                        <th>Étudiant</th>
                                        <th>Numéro</th>
                                        <th>Année univ.</th>
                                        <th>Note</th>
                                        <th>Statut</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="exam" items="${classement}" varStatus="s">
                                        <tr>
                                            <td class="mono">
                                                <c:choose>
                                                    <c:when test="${s.index == 0}">🥇</c:when>
                                                    <c:when test="${s.index == 1}">🥈</c:when>
                                                    <c:when test="${s.index == 2}">🥉</c:when>
                                                    <c:otherwise><span class="text-muted">#${s.index + 1}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-weight:600;">${exam.nomComplet}</td>
                                            <td><span class="badge badge-blue">${exam.numEtudiant}</span></td>
                                            <td class="text-muted">${exam.anneeUniv}</td>
                                            <td style="font-weight:700;font-family:'DM Mono',monospace;">${exam.note}/10</td>
                                            <td>
                                                <span class="badge ${exam.note >= 5 ? 'badge-green' : 'badge-red'}">
                                                    ${exam.note >= 5 ? 'Admis' : 'Refusé'}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="card-footer text-muted text-sm">
                            ${classement.size()} résultat(s) au total
                        </div>
                    </div>

                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
