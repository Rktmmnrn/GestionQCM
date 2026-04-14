<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% request.setAttribute("currentPage", request.getAttribute("question") != null ? "qcm" : "qcm-new"); %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty question ? 'Modifier' : 'Ajouter'} question — GestionQuestionnaire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <style>
        .ans-row {
            display: flex; align-items: center; gap: 12px;
            background: var(--bg); border: 1px solid var(--border); border-radius: 8px;
            padding: 10px 14px; margin-bottom: 10px; transition: border-color 0.15s;
        }
        .ans-row:focus-within { border-color: var(--accent); }
        .ans-row.has-check { border-color: var(--accent); background: var(--accent-bg); }
        .let-badge { width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.78rem; color: white; flex-shrink: 0; }
        .la { background: #6366f1; } .lb { background: #8b5cf6; } .lc { background: #0891b2; } .ld { background: #d97706; }
        .ans-input { flex: 1; background: transparent; border: none; outline: none; font-family: 'DM Sans', sans-serif; font-size: 0.875rem; color: var(--text); }
        .radio-wrap { display: flex; align-items: center; gap: 5px; white-space: nowrap; flex-shrink: 0; }
        .radio-wrap input { accent-color: var(--accent); width: 16px; height: 16px; cursor: pointer; }
        .radio-wrap label { font-size: 0.75rem; color: var(--text3); cursor: pointer; }
    </style>
</head>
<body>
<div class="app-shell">
    <%@ include file="/jsp/common/sidebar.jspf" %>

    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">
                ❓ QCM <span class="topbar-breadcrumb">/ ${not empty question ? 'Modifier #'.concat(question.numQuest.toString()) : 'Nouvelle question'}</span>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/qcm" class="btn btn-ghost">← Liste</a>
            </div>
        </div>

        <div class="page-body">
            <div style="max-width:620px;">
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">${not empty question ? '✏️ Modifier la question' : '➕ Nouvelle question QCM'}</span>
                        <c:if test="${not empty question}">
                            <span class="badge badge-gray mono">#${question.numQuest}</span>
                        </c:if>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="${pageContext.request.contextPath}/qcm" id="qcmForm">
                            <input type="hidden" name="action" value="${not empty question ? 'update' : 'create'}">
                            <c:if test="${not empty question}">
                                <input type="hidden" name="numQuest" value="${question.numQuest}">
                            </c:if>

                            <div class="form-group">
                                <label class="form-label">Énoncé de la question <span class="required">*</span></label>
                                <textarea name="question" class="form-control" placeholder="Entrez la question…" required>${not empty question ? question.question : ''}</textarea>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Réponses <span class="required">*</span> — cochez la bonne réponse</label>

                                <div class="ans-row" id="row-a">
                                    <span class="let-badge la">A</span>
                                    <input type="text" class="ans-input" name="reponse1" placeholder="Réponse A…"
                                           value="${not empty question ? question.reponse1 : ''}" required
                                           oninput="updateRow(0)">
                                    <div class="radio-wrap">
                                        <input type="radio" name="bonneRep" value="1" id="r1"
                                               ${(not empty question && question.bonneRep == 1) ? 'checked' : ''}
                                               required onchange="updateRows()">
                                        <label for="r1">Bonne</label>
                                    </div>
                                </div>

                                <div class="ans-row" id="row-b">
                                    <span class="let-badge lb">B</span>
                                    <input type="text" class="ans-input" name="reponse2" placeholder="Réponse B…"
                                           value="${not empty question ? question.reponse2 : ''}" required
                                           oninput="updateRow(1)">
                                    <div class="radio-wrap">
                                        <input type="radio" name="bonneRep" value="2" id="r2"
                                               ${(not empty question && question.bonneRep == 2) ? 'checked' : ''}
                                               onchange="updateRows()">
                                        <label for="r2">Bonne</label>
                                    </div>
                                </div>

                                <div class="ans-row" id="row-c">
                                    <span class="let-badge lc">C</span>
                                    <input type="text" class="ans-input" name="reponse3" placeholder="Réponse C…"
                                           value="${not empty question ? question.reponse3 : ''}" required
                                           oninput="updateRow(2)">
                                    <div class="radio-wrap">
                                        <input type="radio" name="bonneRep" value="3" id="r3"
                                               ${(not empty question && question.bonneRep == 3) ? 'checked' : ''}
                                               onchange="updateRows()">
                                        <label for="r3">Bonne</label>
                                    </div>
                                </div>

                                <div class="ans-row" id="row-d">
                                    <span class="let-badge ld">D</span>
                                    <input type="text" class="ans-input" name="reponse4" placeholder="Réponse D…"
                                           value="${not empty question ? question.reponse4 : ''}" required
                                           oninput="updateRow(3)">
                                    <div class="radio-wrap">
                                        <input type="radio" name="bonneRep" value="4" id="r4"
                                               ${(not empty question && question.bonneRep == 4) ? 'checked' : ''}
                                               onchange="updateRows()">
                                        <label for="r4">Bonne</label>
                                    </div>
                                </div>
                                <div class="form-hint">⚠️ Sélectionnez obligatoirement la bonne réponse</div>
                            </div>

                            <div style="display:flex;gap:10px;margin-top:8px;">
                                <button type="submit" class="btn btn-primary" onclick="return validateForm()">
                                    ${not empty question ? '💾 Enregistrer' : '➕ Ajouter la question'}
                                </button>
                                <a href="${pageContext.request.contextPath}/qcm" class="btn btn-ghost">Annuler</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
const rows = ['row-a', 'row-b', 'row-c', 'row-d'];
function updateRows() {
    document.querySelectorAll('input[name="bonneRep"]').forEach((radio, i) => {
        document.getElementById(rows[i]).classList.toggle('has-check', radio.checked);
    });
}
function validateForm() {
    const checked = document.querySelector('input[name="bonneRep"]:checked');
    if (!checked) { alert('Veuillez sélectionner la bonne réponse.'); return false; }
    return true;
}
// Init
updateRows();
</script>
</body>
</html>
