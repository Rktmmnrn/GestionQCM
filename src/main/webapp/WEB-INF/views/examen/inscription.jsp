<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription à l'examen QCM</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideIn 0.5s ease-out;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .header h1 {
            color: #667eea;
            margin: 0;
            font-size: 28px;
        }
        .header p {
            color: #666;
            margin-top: 10px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }
        label i {
            color: #667eea;
            margin-right: 5px;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
        }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .btn:active {
            transform: translateY(0);
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #f44336;
            font-size: 14px;
        }
        .info {
            background: #d1ecf1;
            color: #0c5460;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #17a2b8;
            font-size: 14px;
        }
        .rules {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 13px;
            color: #666;
        }
        .rules h4 {
            margin: 0 0 10px 0;
            color: #667eea;
        }
        .rules ul {
            margin: 0;
            padding-left: 20px;
        }
        .rules li {
            margin: 5px 0;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
            color: #999;
        }
        .demo-btn {
            background: #6c757d;
            margin-top: 10px;
            font-size: 14px;
        }
        .demo-btn:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📝 Inscription à l'examen QCM</h1>
            <p>Veuillez renseigner vos informations</p>
        </div>
        
        <!-- Affichage des messages d'erreur -->
        <c:if test="${not empty erreur}">
            <div class="error">
                <strong>❌ Erreur :</strong> ${erreur}
            </div>
        </c:if>
        
        <!-- Affichage des messages d'information -->
        <c:if test="${not empty info}">
            <div class="info">
                <strong>ℹ️ Information :</strong> ${info}
            </div>
        </c:if>
        
        <!-- Règles de l'examen -->
        <div class="rules">
            <h4>📋 Règles de l'examen :</h4>
            <ul>
                <li>L'examen contient <strong>10 questions</strong> à choix multiples</li>
                <li>Chaque question vaut <strong>1 point</strong> (note sur 10)</li>
                <li>Vous avez <strong>20 minutes</strong> pour compléter l'examen</li>
                <li>Une seule réponse est correcte par question</li>
                <li>Le résultat vous sera envoyé par <strong>email</strong></li>
                <li>Vous ne pouvez passer l'examen qu'une seule fois</li>
            </ul>
        </div>
        
        <!-- Formulaire d'inscription -->
        <form action="${pageContext.request.contextPath}/examen" method="post" id="inscriptionForm">
            <input type="hidden" name="action" value="demarrer">
            
            <div class="form-group">
                <label for="numEtudiant">
                    <i>👨‍🎓</i> Numéro étudiant :
                </label>
                <input type="text" 
                       id="numEtudiant" 
                       name="numEtudiant" 
                       required 
                       placeholder="Ex: E001, 2024001, ..."
                       pattern="[A-Za-z0-9]+"
                       title="Alphanumérique uniquement"
                       value="${param.numEtudiant}">
            </div>
            
            <div class="form-group">
                <label for="anneeUniv">
                    <i>📅</i> Année universitaire :
                </label>
                <select id="anneeUniv" name="anneeUniv" required>
                    <option value="">Sélectionnez l'année</option>
                    <option value="2022-2023" ${param.anneeUniv == '2022-2023' ? 'selected' : ''}>2022-2023</option>
                    <option value="2023-2024" ${param.anneeUniv == '2023-2024' ? 'selected' : ''}>2023-2024</option>
                    <option value="2024-2025" ${param.anneeUniv == '2024-2025' ? 'selected' : ''}>2024-2025</option>
                    <option value="2025-2026" ${param.anneeUniv == '2025-2026' ? 'selected' : ''}>2025-2026</option>
                </select>
            </div>
            
            <button type="submit" class="btn">
                🚀 Commencer l'examen
            </button>
        </form>
        
        <!-- Bouton de démonstration (optionnel) -->
        <button type="button" class="btn demo-btn" onclick="remplirDemo()">
            📋 Remplir avec des données de démonstration
        </button>
        
        <div class="footer">
            <p>⚠️ Assurez-vous d'avoir une connexion internet stable</p>
            <p>📧 Les résultats vous seront envoyés automatiquement par email</p>
        </div>
    </div>
    
    <script>
        // Fonction pour remplir automatiquement avec des données de démo
        function remplirDemo() {
            document.getElementById('numEtudiant').value = 'E001';
            document.getElementById('anneeUniv').value = '2024-2025';
            
            // Animation de confirmation
            const btn = document.querySelector('.demo-btn');
            const originalText = btn.innerHTML;
            btn.innerHTML = '✅ Données de démo insérées !';
            btn.style.background = '#28a745';
            
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.style.background = '#6c757d';
            }, 2000);
        }
        
        // Validation du formulaire avant soumission
        document.getElementById('inscriptionForm').addEventListener('submit', function(e) {
            const numEtudiant = document.getElementById('numEtudiant').value.trim();
            const anneeUniv = document.getElementById('anneeUniv').value;
            
            if (numEtudiant === '') {
                e.preventDefault();
                alert('Veuillez entrer votre numéro étudiant');
                return false;
            }
            
            if (anneeUniv === '') {
                e.preventDefault();
                alert('Veuillez sélectionner l\'année universitaire');
                return false;
            }
            
            // Confirmation avant de commencer
            return confirm('Êtes-vous prêt à commencer l\'examen ?\n\n' +
                          'Vous aurez 20 minutes pour répondre aux 10 questions.\n' +
                          'Une fois commencé, vous ne pourrez pas revenir en arrière.');
        });
        
        // Animation au chargement
        window.addEventListener('load', function() {
            const container = document.querySelector('.container');
            container.style.opacity = '0';
            setTimeout(() => {
                container.style.opacity = '1';
            }, 100);
        });
    </script>
</body>
</html>