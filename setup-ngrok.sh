#!/bin/bash
# Setup ngrok con dominios fijos

echo "🚀 SETUP NGROK"
echo "=============="
echo ""

# Verificar si ya tiene config
if [ -f "$HOME/.ngrok2/ngrok.yml" ] || [ -f "$HOME/.config/ngrok/ngrok.yml" ]; then
  echo "✅ ngrok ya configurado"
else
  read -p "Introducí tu token de ngrok: " TOKEN
  
  if [ -z "$TOKEN" ]; then
    echo "❌ Token requerido"
    echo "   Conseguilo en: https://dashboard.ngrok.com/get-started/your-authtoken"
    exit 1
  fi
  
  ./ngrok config add-authtoken "$TOKEN"
  echo "✅ Token guardado"
fi

echo ""
echo "📝 Creando configuración de túneles..."

mkdir -p "$HOME/.ngrok2"

cat > "$HOME/.ngrok2/ngrok.yml" << CONFIG
version: "2"
authtoken: $(grep authtoken "$HOME/.ngrok2/ngrok.yml" 2>/dev/null | awk '{print $2}' || echo "YOUR_TOKEN")

# Túneles persistentes
tunnels:
  serviworld-prod:
    addr: 3000
    proto: http
    subdomain: serviworld-prod
    
  serviworld-dev:
    addr: 3000
    proto: http
    subdomain: serviworld-dev
CONFIG

echo "✅ Configuración guardada"
echo ""
echo "Para iniciar:"
echo "  ./ngrok start --config=$HOME/.ngrok2/ngrok.yml serviworld-prod"
echo "  ./ngrok start --config=$HOME/.ngrok2/ngrok.yml serviworld-dev"
echo ""
echo "URLs:"
echo "  🌍 Producción: https://serviworld-prod.ngrok.io"
echo "  🔧 Desarrollo: https://serviworld-dev.ngrok.io"
