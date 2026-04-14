# Gestion Examens

Application web JSP/Servlet pour la gestion d'examens, QCM et étudiants.

## 📋 Vue d'ensemble

Cette application permet de gérer :
- **Étudiants** : création, modification, suppression et recherche
- **Examens** : inscription, passage et affichage des résultats
- **QCM** : création et gestion des questionnaires à choix multiples

## 🏗️ Structure du projet

```
src/main/
├── java/
│   └── com/examen/
│       ├── dao/              # Accès aux données (DAO)
│       ├── model/            # Modèles métier (Entités)
│       ├── servlet/          # Contrôleurs (Servlets)
│       └── util/             # Utilitaires (Connexion, Email)
├── resources/
│   └── config.properties     # Configuration email
└── webapp/
    ├── index.jsp             # Page d'accueil
    ├── diagnostic.jsp        # Test de connexion à la BD
    ├── css/                  # Feuilles de style
    ├── js/                   # Scripts JavaScript
    ├── jsp/                  # Pages JSP d'interface
    │   ├── etudiant/
    │   ├── examen/
    │   └── qcm/
    └── WEB-INF/
        └── web.xml
```

> Les pages JSP sont servies depuis `/jsp/...`. Il n'y a pas de structure active sous `WEB-INF/views/`.
>
> Tous les styles locaux sont centralisés dans `src/main/webapp/css/` et les scripts JavaScript peuvent être ajoutés sous `src/main/webapp/js/`.

## 🚀 Prérequis

- Java 11+
- Maven 3.6+
- MySQL ou MariaDB
- Tomcat 10+

## ⚙️ Installation

### 1. Initialiser la base de données

Ou via MySQL :

```bash
mysql -h localhost -u fenohery -padmin < init_db.sql
```

### 2. Compiler le projet

```bash
mvn clean package
```

### 3. Déployer

```bash
./dev.sh
```

### 4. Accéder à l'application

- Accueil : `http://localhost:8080/GestionExamens/`
- Diagnostic : `http://localhost:8080/GestionExamens/diagnostic.jsp`
- Étudiants : `http://localhost:8080/GestionExamens/etudiant`
- QCM : `http://localhost:8080/GestionExamens/qcm`
- Examens : `http://localhost:8080/GestionExamens/examen`

## 🔧 Configuration

### Base de données

Dans `src/main/java/com/examen/util/DBConnexion.java` :

```java
private static final String URL = "jdbc:mysql://localhost:3306/gestion_qcm";
private static final String USER = "fenohery";
private static final String PASSWORD = "admin";
```

Adaptez ces valeurs à votre environnement.

### Email (optionnel)

Dans `src/main/resources/config.properties` :

```properties
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.username=votre_email@gmail.com
mail.password=votre_mot_de_passe_appli
mail.from=votre_email@gmail.com
```

## 🔗 Points d'accès principaux

### Étudiants
- `GET /etudiant`
- `GET /etudiant?action=new`
- `GET /etudiant?action=edit&id=X`
- `GET /etudiant?action=delete&id=X`
- `GET /etudiant?action=search`
- `POST /etudiant`

### Examens
- `GET /examen`
- `GET /examen?action=start`
- `GET /examen?action=passage`
- `GET /examen?action=resultat`
- `POST /examen`

### QCM
- `GET /qcm`
- `GET /qcm?action=new`
- `GET /qcm?action=edit&id=X`
- `POST /qcm`

## 🐞 Résolution de problèmes

### Vérification de syntaxe
- Aucune erreur de syntaxe Java détectée dans l’analyse des fichiers.
- La compilation est bloquée par une erreur de copie de ressources (`config.properties`) liée aux permissions du système de fichiers.

### Erreur Maven sur `resources`
- Vérifiez les permissions du dossier `target/`
- Supprimez `target/` si nécessaire et relancez `mvn clean package`
- Assurez-vous d’avoir les droits d’écriture dans le répertoire du projet

### Erreur 404
- Vérifiez que l’application est déployée sur Tomcat
- Utilisez `diagnostic.jsp`

### Erreur 500
- Consultez les logs Tomcat
- Vérifiez la configuration de la base de données

## 📝 Licence

Projet ENI - L3

## 👥 Support

Pour toute question ou bug, consulter la documentation du projet.
