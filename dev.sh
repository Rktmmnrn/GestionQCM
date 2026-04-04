#!/bin/bash

TOMCAT_HOME="/opt/tomcat"
PROJECT_NAME="GestionExamens"

echo "🔧 Mode développement..."

# Compilation initiale
mvn clean package
cp target/${PROJECT_NAME}.war ${TOMCAT_HOME}/webapps/

# Démarrage de Tomcat
${TOMCAT_HOME}/bin/startup.sh

echo "✅ Tomcat démarré"
echo "📝 Surveillez les changements dans src/main/java/"

# Surveillez les changements Java et recompilez automatiquement
while inotifywait -r -e modify src/main/java/; do
    echo "🔄 Changement détecté ! Recompilation..."
    mvn compile
    # Copie uniquement les classes compilées (plus rapide)
    cp -r target/classes/* ${TOMCAT_HOME}/webapps/${PROJECT_NAME}/WEB-INF/classes/ 2>/dev/null
    echo "✅ Rechargé !"
done
