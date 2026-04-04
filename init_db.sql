-- Initialisation de la base de données Gestion Examens

-- Créer la base de données
CREATE DATABASE IF NOT EXISTS gestion_qcm
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Utiliser la base de données
USE gestion_qcm;

-- Table des étudiants
CREATE TABLE IF NOT EXISTS ETUDIANT (
    num_etudiant VARCHAR(10) PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenoms VARCHAR(100) NOT NULL,
    niveau VARCHAR(10) NOT NULL,
    adr_email VARCHAR(150) NOT NULL UNIQUE,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des questions QCM
CREATE TABLE IF NOT EXISTS QCM (
    num_quest INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    reponse1 VARCHAR(255) NOT NULL,
    reponse2 VARCHAR(255) NOT NULL,
    reponse3 VARCHAR(255) NOT NULL,
    reponse4 VARCHAR(255) NOT NULL,
    bonne_rep INT NOT NULL CHECK (bonne_rep BETWEEN 1 AND 4),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des examens
CREATE TABLE IF NOT EXISTS EXAMEN (
    num_examen INT AUTO_INCREMENT PRIMARY KEY,
    num_etudiant VARCHAR(10) NOT NULL,
    annee_univ VARCHAR(9) NOT NULL,
    note INT,
    date_examen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (num_etudiant) REFERENCES ETUDIANT(num_etudiant) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Données de test - Étudiants
INSERT INTO ETUDIANT (num_etudiant, nom, prenoms, niveau, adr_email) VALUES
('E001001', 'Dupont', 'Jean', 'L1', 'jean.dupont@example.com'),
('E001002', 'Martin', 'Marie', 'L1', 'marie.martin@example.com'),
('E001003', 'Bernard', 'Pierre', 'L2', 'pierre.bernard@example.com'),
('E001004', 'Thomas', 'Sophie', 'L3', 'sophie.thomas@example.com'),
('E001005', 'Robert', 'Luc', 'M1', 'luc.robert@example.com'),
('E001006', 'Richard', 'Anne', 'M2', 'anne.richard@example.com')
ON DUPLICATE KEY UPDATE num_etudiant=num_etudiant;

-- Données de test - Questions QCM
INSERT INTO QCM (question, reponse1, reponse2, reponse3, reponse4, bonne_rep) VALUES
('Qu\'est-ce que Java ?', 'Un langage de programmation', 'Un café', 'Une île', 'Un virus', 1),
('Qu\'est-ce qu\'un servlet ?', 'Un petit service web', 'Composant côté serveur', 'Une classe Java', 'Tout ce qui précède', 4),
('Quel est le port par défaut de Tomcat ?', '8080', '3306', '5432', '22', 1),
('Qu\'est-ce que JSP ?', 'Java Server Pages', 'Java Standard Pages', 'Java Service Protocol', 'Rien', 1),
('Quel est le bon mot-clé pour hériter en Java ?', 'extends', 'inherits', 'implements', 'subclass', 1),
('Qu\'est-ce qu\'une base de données relationnelle ?', 'Une BD avec des relations', 'Une BD avec des tables', 'Une BD SQL', 'Tout ce qui précède', 4),
('Quel est le langage de requête pour les BD ?', 'SQL', 'HTML', 'CSS', 'JavaScript', 1),
('Qu\'est-ce que Maven ?', 'Un gestionnaire de projet', 'Un IDE', 'Un serveur web', 'Un framework', 1),
('Qu\'est-ce qu\'une API REST ?', 'Representational State Transfer', 'Remote External Service Transfer', 'Really Easy Simple Tool', 'Rien', 1),
('Quel est le bon format pour une adresse email ?', 'utilisateur@domaine.com', 'utilisateur@domaine', 'utilisateur domaine com', '@utilisateur@domaine', 1);

COMMIT;

-- Afficher le contenu
SELECT COUNT(*) AS 'Nombre d\'étudiants' FROM ETUDIANT;
SELECT COUNT(*) AS 'Nombre de questions' FROM QCM;
