<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.examen.util.DBConnexion" %>
<%@ page import="com.examen.dao.EtudiantDAO" %>
<%@ page import="com.examen.model.Etudiant" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnostic - Gestion Examens</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .diagnostic-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 30px;
            max-width: 900px;
            margin: 0 auto;
        }
        .test-item {
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            border-left: 5px solid #ddd;
        }
        .test-item.success {
            background-color: #d4edda;
            border-left-color: #198754;
        }
        .test-item.error {
            background-color: #f8d7da;
            border-left-color: #dc3545;
        }
        .test-item.warning {
            background-color: #fff3cd;
            border-left-color: #ffc107;
        }
        .test-title {
            font-weight: 600;
            margin-bottom: 8px;
        }
        .test-message {
            font-size: 0.9rem;
        }
        h1 {
            color: #0d6efd;
            margin-bottom: 30px;
            font-weight: 700;
        }
        .summary {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 30px;
        }
        table {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #0d6efd;
            color: white;
        }
    </style>
</head>
<body>
    <div class="diagnostic-container">
        <h1>🔍 Diagnostic - Gestion Examens</h1>

        <%
            int successCount = 0;
            int errorCount = 0;
            String testResult = "";

            try {
                // Test 1: Connexion DB
                out.println("<div class='test-item success'>");
                out.println("<div class='test-title'>✅ Connexion à la base de données</div>");
                DBConnexion dbConn = DBConnexion.getInstance();
                Connection conn = dbConn.getConnection();
                if (conn != null && !conn.isClosed()) {
                    out.println("<div class='test-message'>Connecté avec succès à la base de données gestion_examens</div>");
                    successCount++;
                } else {
                    out.println("<div class='test-item error'><div class='test-title'>❌ Connexion échouée</div>");
                    errorCount++;
                }
                out.println("</div>");

                // Test 2: Vérifier les tables
                DatabaseMetaData metaData = conn.getMetaData();
                ResultSet tables = metaData.getTables(null, null, "ETUDIANT", new String[]{"TABLE"});
                
                if (tables.next()) {
                    out.println("<div class='test-item success'>");
                    out.println("<div class='test-title'>✅ Table 'etudiants' existe</div>");
                    out.println("<div class='test-message'>La table est présente dans la base de données</div>");
                    successCount++;
                    out.println("</div>");
                } else {
                    out.println("<div class='test-item error'>");
                    out.println("<div class='test-title'>❌ Table 'etudiants' manquante</div>");
                    out.println("<div class='test-message'>Exécutez le script init_db.sql Pour créer les tables</div>");
                    errorCount++;
                    out.println("</div>");
                }

                // Test 3: Récupérer les étudiants
                EtudiantDAO etudiantDAO = new EtudiantDAO();
                List<Etudiant> etudiants = etudiantDAO.findAll();

                out.println("<div class='test-item " + (etudiants.size() > 0 ? "success" : "warning") + "'>");
                out.println("<div class='test-title'>" + (etudiants.size() > 0 ? "✅" : "⚠️") + " Étudiants en base</div>");
                out.println("<div class='test-message'><strong>" + etudiants.size() + " étudiant(s) trouvé(s)</strong></div>");
                out.println("</div>");

                if (etudiants.size() > 0) {
                    out.println("<table>");
                    out.println("<thead><tr><th>Numéro</th><th>Nom</th><th>Prénoms</th><th>Niveau</th><th>Email</th></tr></thead>");
                    out.println("<tbody>");
                    for (Etudiant etudiant : etudiants) {
                        out.println("<tr>");
                        out.println("<td>" + etudiant.getNumEtudiant() + "</td>");
                        out.println("<td>" + etudiant.getNom() + "</td>");
                        out.println("<td>" + etudiant.getPrenoms() + "</td>");
                        out.println("<td>" + etudiant.getNiveau() + "</td>");
                        out.println("<td>" + etudiant.getAdrEmail() + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</tbody>");
                    out.println("</table>");
                    successCount++;
                } else {
                    out.println("<p class='alert alert-warning mt-3'>💡 Conseil: Exécutez <code>bash init_db.sh</code> pour initialiser les données de test</p>");
                    errorCount++;
                }

                // Résumé
                out.println("<div class='summary'>");
                out.println("<h5>📋 Résumé du diagnostic</h5>");
                out.println("<p>✅ Tests réussis: <strong>" + successCount + "</strong></p>");
                out.println("<p>❌ Tests échoués: <strong>" + errorCount + "</strong></p>");
                if (errorCount == 0) {
                    out.println("<p class='alert alert-success mt-3'>🎉 Tout fonctionne correctement!</p>");
                } else {
                    out.println("<p class='alert alert-warning mt-3'>⚠️ Des problèmes ont été détectés. Consultez les détails ci-dessus.</p>");
                }
                out.println("</div>");

            } catch (Exception e) {
                out.println("<div class='test-item error'>");
                out.println("<div class='test-title'>❌ Erreur lors du diagnostic</div>");
                out.println("<div class='test-message'><strong>Erreur:</strong> " + e.getMessage() + "</div>");
                out.println("<pre>" + e.getClass().getName() + "</pre>");
                out.println("</div>");
                e.printStackTrace(response.getWriter());
            }
        %>

        <hr>
        <p class='text-muted'><small>Page de diagnostic générée le: <%= new java.util.Date() %></small></p>
        <a href="index.jsp" class="btn btn-primary mt-3">← Retour à l'accueil</a>
    </div>
</body>
</html>
