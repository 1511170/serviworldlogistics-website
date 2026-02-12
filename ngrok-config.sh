#!/bin/bash
# Configurar ngrok con dominios fijos

read -p "Introduce tu token de ngrok: " NGROK_TOKEN

# Crear config de ngrok
cat > ngrok.yml << CONFIG
version: "2"
authtoken: $NGROK_TOKEN

# Túnel de producción
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

echo "✅ Configuración guardada en ngrok.yml"
echo ""
echo "Para iniciar:"
echo "  ngrok start --config=ngrok.yml serviworld-prod"
echo "  ngrok start --config=ngrok.yml serviworld-dev"
