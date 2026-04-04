#!/bin/bash

# Script d'initialisation de la base de données Gestion Examens

echo "📦 Initialisation de la base de données..."

# Vérifier si mysql est disponible
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL n'est pas installé ou n'est pas dans le PATH"
    echo "Installez MySQL Client: sudo apt-get install mysql-client"
    exit 1
fi

# Paramètres de connexion
DB_HOST="localhost"
DB_USER="fenohery"
DB_PASSWORD="admin"

# Exécuter le script SQL
echo "⏳ Exécution du script init_db.sql..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" < init_db.sql

if [ $? -eq 0 ]; then
    echo "✅ Base de données initialisée avec succès!"
    echo ""
    echo "📊 Vérification des données:"
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "USE gestion_qcm; SELECT 'Étudiants:' AS type, COUNT(*) AS count FROM ETUDIANT UNION SELECT 'Questions QCM:' AS type, COUNT(*) AS count FROM QCM;"
else
    echo "❌ Erreur lors de l'initialisation de la base de données"
    exit 1
fi
