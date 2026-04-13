<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${editMode}">Modifier</c:when><c:otherwise>Ajouter</c:otherwise></c:choose> un étudiant</title>
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
            max-width: 520px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }
        h2 { color: #f1f5f9; font-weight: 800; font-size: 1.6rem; margin-bottom: 6px; }
        .subtitle { color: #64748b; font-size: 0.9rem; margin-bottom: 35px; }
        label { color: #94a3b8; font-size: 0.88rem; font-weight: 600; margin-bottom: 7px; display: block; }
        .form-control, .form-select {
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 10px;
            color: #f1f5f9;
            padding: 12px 16px;
            font-family: 'Sora', sans-serif;
            font-size: 0.92rem;
            transition: border-color 0.3s;
            width: 100%;
        }
        .form-control:focus, .form-select:focus {
            outline: none;
            background: #0f172a;
            border-color: #6366f1;
            color: #f1f5f9;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }
        .form-select option { background: #1e293b; color: #f1f5f9; }
        .form-group { margin-bottom: 22px; }
        .hint { color: #475569; font-size: 0.78rem; margin-top: 5px; }
        .readonly-field { opacity: 0.6; cursor: not-allowed; }

        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white; border: none;
            border-radius: 10px;
            padding: 14px;
            font-size: 1rem; font-weight: 700;
            font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.3s;
            margin-bottom: 12px;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(99,102,241,0.4); }
        .btn-back {
            width: 100%;
            background: transparent;
            border: 1px solid #334155;
            color: #64748b;
            border-radius: 10px;
            padding: 12px;
            font-size: 0.9rem; font-weight: 600;
            font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.2s;
            text-decoration: none; display: block; text-align: center;
        }
        .btn-back:hover { border-color: #6366f1; color: #6366f1; }
        .alert-err {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.3);
            border-radius: 10px;
            color: #fca5a5;
            padding: 12px 16px;
            margin-bottom: 22px;
            font-size: 0.88rem;
        }
        .alert-ok {
            background: rgba(34,197,94,0.1);
            border: 1px solid rgba(34,197,94,0.3);
            border-radius: 10px;
            color: #86efac;
            padding: 12px 16px;
            margin-bottom: 22px;
            font-size: 0.88rem;
        }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>
            <c:choose>
                <c:when test="${editMode}">✏️ Modifier l'étudiant</c:when>
                <c:otherwise>➕ Nouvel étudiant</c:otherwise>
            </c:choose>
        </h2>
        <p class="subtitle">
            <c:choose>
                <c:when test="${editMode}">Modifiez les informations de l'étudiant</c:when>
                <c:otherwise>Renseignez les informations du nouvel étudiant</c:otherwise>
            </c:choose>
        </p>

        <c:if test="${not empty param.error}">
            <div class="alert-err">
                <c:choose>
                    <c:when test="${param.error == 'createFailed'}">❌ Erreur : l'email existe peut-être déjà, ou le numéro étudiant est invalide.</c:when>
                    <c:otherwise>❌ Une erreur est survenue.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/etudiant">
            <input type="hidden" name="action" value="${editMode ? 'update' : 'create'}">

            <div class="form-group">
                <label for="numEtudiant">Numéro étudiant *</label>
                <input type="text" class="form-control ${editMode ? 'readonly-field' : ''}"
                       id="numEtudiant" name="numEtudiant"
                       placeholder="Ex: E001001"
                       value="${editMode ? etudiant.numEtudiant : ''}"
                       ${editMode ? 'readonly' : ''} required>
                <div class="hint">Format recommandé : E + 6 chiffres</div>
            </div>

            <div class="form-group">
                <label for="nom">Nom *</label>
                <input type="text" class="form-control" id="nom" name="nom"
                       placeholder="Ex: Dupont"
                       value="${editMode ? etudiant.nom : ''}" required>
            </div>

            <div class="form-group">
                <label for="prenoms">Prénoms *</label>
                <input type="text" class="form-control" id="prenoms" name="prenoms"
                       placeholder="Ex: Jean Marie"
                       value="${editMode ? etudiant.prenoms : ''}" required>
            </div>

            <div class="form-group">
                <label for="email">Email *</label>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="Ex: jean.dupont@example.com"
                       value="${editMode ? etudiant.adrEmail : ''}" required>
                <div class="hint">Doit être unique dans le système</div>
            </div>

            <div class="form-group">
                <label for="niveau">Niveau *</label>
                <select class="form-select" id="niveau" name="niveau" required>
                    <option value="">— Sélectionnez —</option>
                    <c:forEach var="niv" items="${['L1','L2','L3','M1','M2']}">
                        <option value="${niv}"
                            ${(editMode && etudiant.niveau == niv) ? 'selected' : ''}>
                            ${niv}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="btn-submit">
                ${editMode ? '💾 Enregistrer les modifications' : '➕ Ajouter l\'étudiant'}
            </button>
            <a href="${pageContext.request.contextPath}/etudiant" class="btn-back">← Retour à la liste</a>
        </form>
    </div>
</body>
</html>
