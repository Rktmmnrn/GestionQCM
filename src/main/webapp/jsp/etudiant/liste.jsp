<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Étudiants</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Sora', sans-serif; background: #0f172a; min-height: 100vh; padding: 30px 20px; }
        .page-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 20px;
            max-width: 1050px;
            margin: 0 auto;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }
        .page-header {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            padding: 30px 35px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .page-header h1 { color: white; font-size: 1.5rem; font-weight: 800; margin: 0; }
        .page-header p { color: rgba(255,255,255,0.75); margin: 4px 0 0; font-size: 0.88rem; }
        .btn-add {
            background: white;
            color: #6366f1;
            border: none;
            border-radius: 10px;
            padding: 11px 22px;
            font-weight: 700; font-size: 0.9rem;
            font-family: 'Sora', sans-serif;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.15); color: #6366f1; }

        /* Alerts */
        .alert-section { padding: 0 35px; }
        .alert-ok { background: rgba(34,197,94,0.1); border: 1px solid rgba(34,197,94,0.3); border-radius: 10px; color: #86efac; padding: 12px 16px; margin-top: 20px; font-size: 0.88rem; }
        .alert-err { background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); border-radius: 10px; color: #fca5a5; padding: 12px 16px; margin-top: 20px; font-size: 0.88rem; }

        /* Search */
        .search-section { padding: 25px 35px; border-bottom: 1px solid #334155; }
        .search-row { display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end; }
        .search-group { flex: 1; min-width: 180px; }
        .search-label { color: #64748b; font-size: 0.8rem; font-weight: 600; margin-bottom: 6px; display: block; }
        .search-select, .search-input {
            background: #0f172a; border: 1px solid #334155; border-radius: 8px;
            color: #f1f5f9; padding: 10px 14px;
            font-family: 'Sora', sans-serif; font-size: 0.88rem; width: 100%;
        }
        .search-select:focus, .search-input:focus { outline: none; border-color: #6366f1; }
        .search-select option { background: #1e293b; }
        .btn-search {
            background: #6366f1; color: white; border: none;
            border-radius: 8px; padding: 10px 20px;
            font-weight: 700; font-size: 0.88rem; font-family: 'Sora', sans-serif;
            cursor: pointer; white-space: nowrap; transition: all 0.2s;
        }
        .btn-search:hover { background: #5558e8; }
        .btn-reset {
            background: transparent; border: 1px solid #334155; color: #64748b;
            border-radius: 8px; padding: 10px 16px;
            font-weight: 600; font-size: 0.88rem; font-family: 'Sora', sans-serif;
            cursor: pointer; text-decoration: none; white-space: nowrap; transition: all 0.2s;
        }
        .btn-reset:hover { border-color: #6366f1; color: #6366f1; }

        /* Table */
        .table-section { padding: 25px 35px 35px; }
        .total-badge {
            background: #0f172a; border: 1px solid #334155;
            border-radius: 8px; padding: 6px 14px;
            color: #64748b; font-size: 0.8rem; font-weight: 600;
            display: inline-block; margin-bottom: 18px;
        }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            background: #0f172a; color: #64748b;
            font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em;
            padding: 11px 14px; text-align: left;
        }
        tbody td { padding: 13px 14px; border-bottom: 1px solid #1e293b; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: rgba(99,102,241,0.04); }
        .student-name { color: #e2e8f0; font-weight: 600; font-size: 0.92rem; }
        .student-id {
            display: inline-block; background: rgba(99,102,241,0.12); border: 1px solid rgba(99,102,241,0.25);
            border-radius: 6px; padding: 3px 10px; color: #818cf8; font-size: 0.78rem; font-weight: 700;
        }
        .niveau-badge {
            display: inline-block; padding: 4px 10px; border-radius: 6px;
            font-size: 0.78rem; font-weight: 700;
        }
        .niv-L1,.niv-L2,.niv-L3 { background: rgba(99,102,241,0.15); color: #818cf8; }
        .niv-M1,.niv-M2 { background: rgba(34,197,94,0.12); color: #4ade80; }
        .email-link { color: #64748b; font-size: 0.85rem; text-decoration: none; }
        .email-link:hover { color: #6366f1; }
        .btn-edit {
            background: rgba(99,102,241,0.1); border: 1px solid rgba(99,102,241,0.25);
            color: #818cf8; border-radius: 7px; padding: 6px 14px;
            font-size: 0.8rem; font-weight: 700; font-family: 'Sora', sans-serif;
            text-decoration: none; margin-right: 6px; transition: all 0.2s;
        }
        .btn-edit:hover { background: rgba(99,102,241,0.2); color: #818cf8; }
        .btn-del {
            background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.2);
            color: #f87171; border-radius: 7px; padding: 6px 14px;
            font-size: 0.8rem; font-weight: 700; font-family: 'Sora', sans-serif;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-del:hover { background: rgba(239,68,68,0.15); }
        .empty-state { text-align: center; padding: 50px; color: #475569; }
        .empty-state .icon { font-size: 3rem; margin-bottom: 15px; }
        .footer-links { padding: 20px 35px; border-top: 1px solid #334155; }
        .footer-links a { color: #475569; text-decoration: none; font-size: 0.85rem; font-weight: 600; }
        .footer-links a:hover { color: #94a3b8; }
    </style>
</head>
<body>
    <div class="page-card">
        <div class="page-header">
            <div>
                <h1>👥 Étudiants</h1>
                <p>Gestion de la liste des étudiants inscrits</p>
            </div>
            <a href="${pageContext.request.contextPath}/etudiant?action=new" class="btn-add">➕ Ajouter</a>
        </div>

        <!-- Alertes -->
        <div class="alert-section">
            <c:if test="${param.success == 'created'}"><div class="alert-ok">✅ Étudiant ajouté avec succès.</div></c:if>
            <c:if test="${param.success == 'updated'}"><div class="alert-ok">✅ Étudiant modifié avec succès.</div></c:if>
            <c:if test="${param.success == 'deleted'}"><div class="alert-ok">✅ Étudiant supprimé.</div></c:if>
            <c:if test="${param.error == 'createFailed'}"><div class="alert-err">❌ Erreur : vérifiez que le numéro et l'email sont uniques.</div></c:if>
            <c:if test="${param.error == 'deleteFailed'}"><div class="alert-err">❌ Impossible de supprimer cet étudiant.</div></c:if>
        </div>

        <!-- Recherche -->
        <div class="search-section">
            <form method="GET" action="${pageContext.request.contextPath}/etudiant">
                <input type="hidden" name="action" value="search">
                <div class="search-row">
                    <div class="search-group">
                        <label class="search-label">Type de recherche</label>
                        <select class="search-select" name="searchType">
                            <option value="nom" ${searchType == 'nom' ? 'selected' : ''}>Par nom</option>
                            <option value="niveau" ${searchType == 'niveau' ? 'selected' : ''}>Par niveau</option>
                        </select>
                    </div>
                    <div class="search-group" style="flex:2">
                        <label class="search-label">Valeur recherchée</label>
                        <input type="text" class="search-input" name="searchValue"
                               placeholder="Nom, ou niveau (L1, L2...)"
                               value="${searchValue}">
                    </div>
                    <button type="submit" class="btn-search">🔍 Chercher</button>
                    <a href="${pageContext.request.contextPath}/etudiant" class="btn-reset">✕ Reset</a>
                </div>
            </form>
        </div>

        <!-- Tableau -->
        <div class="table-section">
            <c:choose>
                <c:when test="${empty etudiants}">
                    <div class="empty-state">
                        <div class="icon">📭</div>
                        <h4 style="color:#94a3b8;">Aucun étudiant trouvé</h4>
                        <p>Ajoutez des étudiants ou modifiez votre recherche.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="total-badge">Total : ${etudiants.size()} étudiant(s)</div>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Numéro</th>
                                <th>Nom &amp; Prénoms</th>
                                <th>Niveau</th>
                                <th>Email</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${etudiants}" varStatus="s">
                                <tr>
                                    <td style="color:#475569; font-size:0.82rem;">${s.index + 1}</td>
                                    <td><span class="student-id">${e.numEtudiant}</span></td>
                                    <td><div class="student-name">${e.nom} ${e.prenoms}</div></td>
                                    <td>
                                        <span class="niveau-badge niv-${e.niveau}">${e.niveau}</span>
                                    </td>
                                    <td>
                                        <a href="mailto:${e.adrEmail}" class="email-link">${e.adrEmail}</a>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/etudiant?action=edit&id=${e.numEtudiant}"
                                           class="btn-edit">✏️ Modifier</a>
                                        <button class="btn-del"
                                                onclick="confirmDel('${e.numEtudiant}', '${e.nom}')">
                                            🗑️
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/">← Accueil</a>
        </div>
    </div>

    <script>
        function confirmDel(id, nom) {
            if (confirm('Supprimer l\'étudiant "' + nom + '" (' + id + ') ?\nCette action est irréversible.')) {
                window.location.href = '${pageContext.request.contextPath}/etudiant?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>
