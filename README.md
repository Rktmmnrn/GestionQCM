# Gestion Examens

Application web JSP/Servlet pour la gestion d'examens et de QCM.

## 📋 Vue d'ensemble

Cette application permet de gérer :
- **Étudiants** : création, modification, suppression et recherche
- **Examens** : suivi des passages et résultats
- **QCM** : gestion de questionnaires à choix multiples with passages et classements

## 🏗️ Architecture

```
src/main/
├── java/
│   └── com/examen/
│       ├── dao/              # Accès aux données (DAO)
│       ├── modele/           # Modèles métier (Entités)
│       ├── servlet/          # Contrôleurs (Servlets)
│       └── util/             # Utilitaires (Connexion, Email)
├── resources/
│   └── config.properties     # Configuration SMTP
└── webapp/
    ├── index.jsp             # Page d'accueil
    ├── diagnostic.jsp        # Test connexion BD
    ├── css/                  # Feuilles de style
    ├── js/                   # Scripts JavaScript
    ├── jsp/                  # Pages JSP (Vues) ✅ ACTUEL
    │   ├── etudiant/
    │   ├── examen/
    │   └── qcm/
    └── WEB-INF/
        └── web.xml
```

### ⚠️ Nettoyage des doublons (Structure ancienne)

**Fichiers à SUPPRIMER** - restes de structure ancienne non utilisée :

```
❌ INUTILISÉS :
src/main/webapp/WEB-INF/views/examen/
    ├── inscription.jsp
    ├── passage.jsp
    └── resultat.jsp
```

**Pour nettoyer :**

```bash
# Automatique
bash cleanup.sh

# Manuel
rm -rf src/main/webapp/WEB-INF/views/
```

Tous les servlets pointent vers `/jsp/examen/`, pas vers `/WEB-INF/views/examen/`

## � Démarrage

### Prérequis
- Java 11+
- Maven 3.6+
- Base de données MySQL/MariaDB
- Tomcat 10+

### Installation

#### 1. Initialiser la base de données

Exécutez le script d'initialisation pour créer la BD et les tables :

```bash
# Sur Linux/Mac
chmod +x init_db.sh
./init_db.sh

# Sur Windows (avec MySQL client)
mysql -h localhost -u fenohery -padmin < init_db.sql
```

Ou manuellement via phpMyAdmin/MySQL Workbench en exécutant le fichier `init_db.sql`

#### 2. Compiler et déployer

```bash
# Compilation
mvn clean package

# Déploiement automatique
./dev.sh
```

#### 3. Accéder à l'application

- **Accueil** : http://localhost:8080/GestionExamens/
- **Diagnostic** : http://localhost:8080/GestionExamens/diagnostic.jsp (teste la connexion BD)
- **Gestion des étudiants** : http://localhost:8080/GestionExamens/etudiant
- **Gestion des QCM** : http://localhost:8080/GestionExamens/qcm
- **Passages d'examens** : http://localhost:8080/GestionExamens/examen

## ⚙️ Configuration

### Base de données

**Fichier** : `src/main/java/com/examen/util/DBConnexion.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/gestion_qcm";
private static final String USER = "fenohery";
private static final String PASSWORD = "admin";
```

À adapter selon votre environnement MySQL.

### Email (Facultatif)

**Fichier** : `src/main/resources/config.properties`

```properties
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.username=votre_email@gmail.com
mail.password=votre_mot_de_passe_appli
mail.from=votre_email@gmail.com
```

Nécessaire pour envoyer les récapitulatifs de notes par email.

## 🔗 Endpoints

### Étudiants
- `GET /etudiant` - Liste tous les étudiants (→ `/jsp/etudiant/liste.jsp`)
- `GET /etudiant?action=new` - Formulaire d'ajout (→ `/jsp/etudiant/form.jsp`)
- `GET /etudiant?action=edit&id=X` - Édition (→ `/jsp/etudiant/form.jsp`)
- `GET /etudiant?action=delete&id=X` - Suppression (→ servlet)
- `GET /etudiant?action=search` - Recherche (→ `/jsp/etudiant/liste.jsp`)
- `POST /etudiant` - Créer/modifier (créé en BD, redirection)

### Examens
- `GET /examen` - Accueil (→ `/jsp/examen/accueil.jsp`)
- `GET /examen?action=start` - Inscription (→ `/jsp/examen/inscription.jsp`)
- `GET /examen?action=passage` - Passage de l'examen (→ `/jsp/examen/passage.jsp`)
- `GET /examen?action=resultat` - Résultats (→ `/jsp/examen/resultat.jsp`)
- `POST /examen` - Démarrer/corriger examen (en session)

### QCM
- `GET /qcm` - Liste les questions (→ `/jsp/qcm/liste.jsp`)
- `GET /qcm?action=new` - Formulaire création (→ `/jsp/qcm/form.jsp`)
- `GET /qcm?action=edit&id=X` - Édition (→ `/jsp/qcm/form.jsp`)
- `POST /qcm` - Créer/modifier question (créée en BD, redirection)

## 🐛 Troubleshooting

### Erreur 404 - Page non trouvée
- Vérifiez que l'application est bien déployée : http://localhost:8080/GestionExamens/
- Utilisez la page de diagnostic pour tester
- Vérifiez les logs Tomcat

### Erreur 500 - Erreur serveur
- Consultez les logs Tomcat : `tail -f /opt/tomcat/logs/catalina.out`
- Vérifiez la connexion à la base de données via `/diagnostic.jsp`

### Aucun étudiant n'apparaît
1. Vérifiez via le diagnostic: http://localhost:8080/GestionExamens/diagnostic.jsp
2. Si la table est vide, initialisez la BD : `bash init_db.sh`
3. Vérifiez les paramètres de connexion dans `DBConnexion.java`
4. Consultez les erreurs MySQL dans les logs

### Impossible d'ajouter un étudiant
- Vérifiez que la table `ETUDIANT` existe (majuscule)
- Vérifiez que l'email n'existe pas déjà (contrainte UNIQUE)
- Consultez les logs Tomcat pour l'erreur SQL
- Vérifiez les permissions de l'utilisateur MySQL (`fenohery`)

### Problèmes de classe non trouvée
```bash
mvn clean compile
mvn package
```

### Rebuild complet
```bash
mvn clean install
./dev.sh
```

### Base de données
- Vérifier les tables: `mysql -h localhost -u fenohery -padmin -e "USE gestion_qcm; SHOW TABLES;"`
- Afficher les étudiants: `mysql -h localhost -u fenohery -padmin -e "USE gestion_qcm; SELECT * FROM ETUDIANT;"`
- Réinitialiser complètement: `bash init_db.sh`
- Supprimer les anciens fichiers: `rm -rf src/main/webapp/WEB-INF/views/`

## 📝 Licence

Projet ENI - L3

## 👥 Support

Pour toute question ou bug, consulter la documentation du projet.
