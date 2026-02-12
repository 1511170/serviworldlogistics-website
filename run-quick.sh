#!/bin/bash
# Cloudflare Quick Tunnel - SIN autenticación, SIN registro
# URL cambia cada vez pero funciona inmediatamente

PORT=${1:-3000}

echo "🚀 CLOUDFLARE QUICK TUNNEL"
echo "=========================="
echo ""
echo "Puerto local: $PORT"
echo ""
echo "⏳ Iniciando túnel (esperá 5 segundos para la URL)..."
echo ""

# Ejecutar y capturar la URL
./cloudflared tunnel --url "http://localhost:$PORT" 2>&1 | tee /tmp/quick-tunnel.log &
PID=$!

# Esperar a que aparezca la URL
sleep 6

# Extraer y mostrar la URL
URL=$(grep -oP 'https://[a-zA-Z0-9-]+\.trycloudflare\.com' /tmp/quick-tunnel.log | head -1)

if [ ! -z "$URL" ]; then
  echo ""
  echo "╔════════════════════════════════════════════════════════════╗"
  echo "║  ✅ TU SITIO ESTÁ EN LÍNEA                                 ║"
  echo "║                                                            ║"
  echo "║  $URL                                       ║"
  echo "║                                                            ║"
  echo "╚════════════════════════════════════════════════════════════╝"
  echo ""
  echo "⚠️  Esta URL es temporal y cambiará al reiniciar"
  echo "   Para URL fija usá: ./setup-dashboard.sh o ./setup-ngrok.sh"
  echo ""
  echo "Presiona Ctrl+C para detener"
else
  echo "⏳ Esperando URL..."
  tail -f /tmp/quick-tunnel.log | grep -m1 "trycloudflare.com"
fi

wait $PID 2>/dev/null
