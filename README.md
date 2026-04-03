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
├── resources/
│   ├── dao/              # Couche d'accès aux données (DAO)
│   ├── modele/           # Modèles métier (Entités)
│   ├── servlet/          # Contrôleurs (Servlets)
│   └── util/             # Utilitaires (Connexion DB, Email)
└── webapp/
    ├── index.jsp         # Page d'accueil
    ├── css/              # Feuilles de style
    ├── js/               # Scripts JavaScript
    ├── jsp/              # Pages JSP (vues)
    │   ├── etudiant/     # Gestion des étudiants
    │   ├── examen/       # Gestion des examens
    │   └── qcm/          # Gestion des QCM
    └── WEB-INF/
        └── web.xml       # Configuration web
```

## 🔧 Configuration

### Base de données

La connexion à la base de données se fait via la classe `DBConnexion` :
```java
// src/main/resources/util/DBConnexion.java
```

Assurez-vous que les identifiants de connexion sont correctement configurés.

### Dépendances Maven

Le projet utilise Maven. Dépendances principales :
- **Jakarta Servlet API** (v5.0+)
- **MySQL/MariaDB Connector**
- **JavaMail API** (pour les notifications email)

## 🚀 Démarrage

### Prérequis
- Java 11+
- Maven 3.6+
- Base de données MySQL/MariaDB

### Installation

1. Cloner le projet
2. Configurer la base de données dans `DBConnexion.java`
3. Compiler :
   ```bash
   mvn clean package
   ```
4. Déployer le WAR sur un serveur Tomcat 10+

### Développement

Pour exécuter en mode développement :
```bash
./dev.sh
```

## 📦 Modules

### DAO (Accès aux données)
- `EtudiantDAO.java` - Opérations CRUD sur les étudiants
- `ExamenDAO.java` - Gestion des examens
- `QCMDAO.java` - Gestion des QCM

### Modèles
- `Etudiant.java` - Représentation d'un étudiant
- `Examen.java` - Représentation d'un examen
- `QCM.java` - Représentation d'un QCM

### Servlets
- `EtudiantServlet.java` - Endpoint `/etudiant`
- `ExamenServlet.java` - Endpoint `/examen`
- `QCMServlet.java` - Endpoint `/qcm`
- `EmailServlet.java` - Gestion des notifications

### Utilitaires
- `DBConnexion.java` - Gestion de la connexion à la BD
- `EmailUtil.java` - Utilitaire d'envoi d'emails

## 🔗 Endpoints

### Étudiants
- `GET /etudiant` - Liste tous les étudiants
- `GET /etudiant?action=new` - Affiche le formulaire de création
- `GET /etudiant?action=edit&id=X` - Édite un étudiant
- `GET /etudiant?action=delete&id=X` - Supprime un étudiant
- `GET /etudiant?action=search` - Recherche les étudiants
- `POST /etudiant` - Crée/met à jour un étudiant

### Examens
- `GET /examen` - Liste les examens
- `GET /examen?action=passage` - Passage d'examen
- `GET /examen?action=resultat` - Résultats
- `GET /examen?action=classement` - Classement

### QCM
- `GET /qcm` - Liste les QCM
- `GET /qcm?action=new` - Crée un QCM
- `POST /qcm` - Sauvegarde un QCM

## 🐛 Troubleshooting

### Erreur 500
- Vérifier les logs Tomcat
- Vérifier la connexion à la base de données
- Vérifier les chemins des JSP (dossier `WEB-INF/views/`)

### Problèmes de classe non trouvée
```bash
mvn clean compile
```

### Rebuild complet
```bash
mvn clean install
```

## 📝 Licence

Projet ENI - L3

## 👥 Support

Pour toute question ou bug, consulter la documentation du projet.
