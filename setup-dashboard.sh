#!/bin/bash
# Setup usando archivos de configuración descargados del Dashboard

echo "🌐 SETUP VIA CLOUDFLARE DASHBOARD"
echo "=================================="
echo ""
echo "👉 Seguí estos pasos en tu navegador:"
echo ""
echo "1️⃣  Andá a https://one.dash.cloudflare.com/"
echo "    (Login con tu cuenta de Cloudflare)"
echo ""
echo "2️⃣  Andá a: Networks → Tunnels"
echo ""
echo "3️⃣  Creá un nuevo túnel:"
echo "    - Click 'Create a tunnel'"
echo "    - Nombre: 'serviworld-prod'"
echo "    - Click 'Save tunnel'"
echo ""
echo "4️⃣  En 'Choose your environment' seleccioná 'Docker'"
echo "    (esto te da el token, pero vos vas a usar cloudflared directo)"
echo ""
echo "5️⃣  IMPORTANTE: En lugar de copiar el comando docker,"
echo "    buscá el archivo de credenciales que se generó en:"
echo "    ~/.cloudflared/<TUNNEL-ID>.json"
echo ""
echo "6️⃣  Copiá ese archivo al servidor. Desde el dashboard podés"
echo "    descargarlo o copiar el contenido."
echo ""
echo "7️⃣  También necesitás crear el config.yml:"
echo ""
cat << 'EOF'

# Guardar como ~/.cloudflared/config-prod.yml
tunnel: <TUNNEL-ID-AQUÍ>
credentials-file: ~/.cloudflared/<TUNNEL-ID-AQUÍ>.json

ingress:
  - hostname: serviworldlogistics.com
    service: http://localhost:3000
  - hostname: www.serviworldlogistics.com
    service: http://localhost:3000
  - service: http_status:404
EOF

echo ""
echo "8️⃣  Para correr:"
echo "    ./cloudflared tunnel --config ~/.cloudflared/config-prod.yml run"
echo ""
echo "💡 O si querés que lo prepare todo automáticamente cuando"
echo "   tengas los archivos, ejecutá:"
echo "   ./setup-from-files.sh"
echo ""
