#!/bin/bash
# Configura túneles cuando tenés los archivos JSON del dashboard

CONFIG_DIR="$HOME/.cloudflared"

echo "📦 SETUP DESDE ARCHIVOS EXISTENTES"
echo "==================================="
echo ""

# Verificar que existen archivos JSON
JSON_FILES=$(ls $CONFIG_DIR/*.json 2>/dev/null | wc -l)

if [ "$JSON_FILES" -eq 0 ]; then
  echo "❌ No se encontraron archivos .json en $CONFIG_DIR"
  echo ""
  echo "📋 Deberías tener archivos como:"
  echo "   $CONFIG_DIR/<tunnel-id>.json"
  echo ""
  echo "👉 Para obtenerlos:"
  echo "   1. Andá a https://one.dash.cloudflare.com/"
  echo "   2. Networks → Tunnels → Create tunnel"
  echo "   3. Seleccioná 'Debian' como ambiente"
  echo "   4. Descargá el archivo de credenciales"
  echo "   5. Subilo a este servidor en $CONFIG_DIR/"
  echo ""
  exit 1
fi

echo "✅ Encontrados $JSON_FILES archivo(s) de credenciales"
echo ""

# Procesar cada archivo JSON
for JSON_FILE in $CONFIG_DIR/*.json; do
  echo "Procesando: $(basename $JSON_FILE)"
  
  # Extraer TunnelID del nombre del archivo
  TUNNEL_ID=$(basename $JSON_FILE .json)
  
  # Verificar que el JSON tiene el formato correcto
  if ! grep -q "AccountTag" "$JSON_FILE" 2>/dev/null; then
    echo "   ⚠️  Parece que no es un credentials file válido"
    continue
  fi
  
  echo "   ✅ Tunnel ID: $TUNNEL_ID"
  
  # Preguntar dominio
  echo ""
  read -p "   Dominio para este túnel (ej: serviworldlogistics.com): " DOMAIN
  
  if [ -z "$DOMAIN" ]; then
    echo "   ❌ Dominio requerido, saltando..."
    continue
  fi
  
  # Crear config
  CONFIG_FILE="$CONFIG_DIR/config-${DOMAIN%%.*}.yml"
  
  cat > "$CONFIG_FILE" << EOF
# Tunnel: $TUNNEL_ID
# Dominio: $DOMAIN
# Creado: $(date)

tunnel: $TUNNEL_ID
credentials-file: $JSON_FILE

ingress:
  - hostname: $DOMAIN
    service: http://localhost:3000
  - service: http_status:404
EOF
  
  echo "   ✅ Config guardado: $CONFIG_FILE"
  echo ""
done

echo "==================================="
echo "✅ CONFIGURACIÓN COMPLETADA"
echo "==================================="
echo ""
echo "Para iniciar los túneles:"
echo ""
ls $CONFIG_DIR/config-*.yml 2>/dev/null | while read config; do
  name=$(basename $config .yml)
  echo "   ./cloudflared tunnel --config $config run"
done
echo ""
