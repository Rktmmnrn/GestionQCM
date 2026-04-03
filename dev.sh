#!/bin/bash

TOMCAT_HOME="${TOMCAT_HOME:-/opt/tomcat}"
PROJECT_NAME="GestionExamens"
WEBAPPS_DIR="${TOMCAT_HOME}/webapps"
CONTEXT="${WEBAPPS_DIR}/${PROJECT_NAME}"

echo "🔧 Mode développement GestionExamens"
echo "📦 TOMCAT_HOME: ${TOMCAT_HOME}"

# Arrêt de Tomcat s'il est en cours d'exécution
if [ -d "$CONTEXT" ]; then
    echo "🛑 Arrêt de Tomcat..."
    ${TOMCAT_HOME}/bin/shutdown.sh 2>/dev/null
    sleep 3
fi

# Nettoyage des anciennes versions
echo "🧹 Nettoyage des anciens fichiers..."
rm -rf "${CONTEXT}" "${WEBAPPS_DIR}/${PROJECT_NAME}.war" "${TOMCAT_HOME}/work/Catalina/localhost/${PROJECT_NAME}"

# Compilation et packaging
echo "🔨 Compilation du projet Maven..."
mvn clean package -q
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la compilation Maven"
    exit 1
fi

# Déploiement du WAR
echo "📤 Déploiement du WAR..."
cp target/${PROJECT_NAME}.war ${WEBAPPS_DIR}/

# Démarrage de Tomcat
echo "🚀 Démarrage de Tomcat..."
${TOMCAT_HOME}/bin/startup.sh
sleep 3

echo "✅ Tomcat démarré sur http://localhost:8080/${PROJECT_NAME}/"
echo "📝 L'application est disponible à: http://localhost:8080/${PROJECT_NAME}/"
echo ""
echo "ℹ️  Pour voir les logs en temps réel:"
echo "   tail -f ${TOMCAT_HOME}/logs/catalina.out"
echo ""
echo "💡 Pour arrêter Tomcat:"
echo "   ${TOMCAT_HOME}/bin/shutdown.sh"

