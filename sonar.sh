#!/bin/bash

if [ -z "$1" ]; then
    echo "❌ Erro: Você precisa passar o Token do SonarQube como argumento."
    echo "Uso: ./sonar.sh SEU_TOKEN_AQUI"
    exit 1
fi

TOKEN=$1

echo "🚀 Iniciando análise do SonarQube..."
# Mudamos de /k: para -k: e de /d: para -d:
dotnet sonarscanner begin -k:"sonarqube_example" -d:sonar.host.url="http://localhost:9000" -d:sonar.token="$TOKEN"

echo "📦 Compilando o projeto C#..."
dotnet build

echo "📤 Finalizando e enviando relatório para o servidor..."
# Mudamos de /d: para -d:
dotnet sonarscanner end -d:sonar.token="$TOKEN"

echo "✅ Processo concluído! Verifique o painel em http://localhost:9000"