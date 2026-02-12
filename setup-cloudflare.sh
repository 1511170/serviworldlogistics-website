#!/bin/bash
# Setup Cloudflare Tunnel - Siguiendo la guía exacta
# https://developers.cloudflare.com/cloudflare-one/connections/connect-apps

set -e

CLOUDFLARED="./cloudflared"
CONFIG_DIR="$HOME/.cloudflared"

echo "🚀 CLOUDFLARE TUNNEL SETUP"
echo "=========================="
echo ""

# =====================================
# PASO 1: Verificar cloudflared
# =====================================
echo "📦 Paso 1: Verificando cloudflared..."
if [ ! -f "$CLOUDFLARED" ]; then
    echo "⬇️  Descargando cloudflared..."
    curl -L --progress-bar https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
    chmod +x cloudflared
fi
$CLOUDFLARED version
echo ""

# =====================================
# PASO 2: Verificar autenticación
# =====================================
echo "🔐 Paso 2: Verificando autenticación..."

if [ ! -f "$CONFIG_DIR/cert.pem" ]; then
    echo ""
    echo "⚠️  NO ESTÁS AUTENTICADO"
    echo ""
    echo "👉 HACÉ ESTO EN TU PC LOCAL (donde tenés navegador):"
    echo ""
    echo "    1. Descargá cloudflared en tu PC:"
    echo "       Mac:     brew install cloudflared"
    echo "       Linux:   curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared"
    echo "       Windows: https://github.com/cloudflare/cloudflared/releases"
    echo ""
    echo "    2. Autenticate (esto abre el navegador):"
    echo "       cloudflared tunnel login"
    echo ""
    echo "    3. Seleccioná tu dominio: serviworldlogistics.com"
    echo ""
    echo "    4. Copiá el cert.pem a este servidor:"
    echo "       scp ~/.cloudflared/cert.pem root@$HOSTNAME:$CONFIG_DIR/"
    echo ""
    echo "    5. Volvé a ejecutar este script"
    echo ""
    exit 1
fi

echo "✅ Autenticado correctamente"
echo ""

# =====================================
# PASO 3: Crear túneles
# =====================================
echo "🚇 Paso 3: Creando túneles..."
echo ""

# Función para crear túnel si no existe
create_tunnel() {
    local name=$1
    local subdomain=$2
    local domain=$3
    
    echo "📌 Túnel: $name ($subdomain.$domain)"
    
    # Verificar si ya existe
    if $CLOUDFLARED tunnel list | grep -q "$name"; then
        echo "   ℹ️  El túnel '$name' ya existe"
        TUNNEL_ID=$($CLOUDFLARED tunnel list | grep "$name" | awk '{print $1}')
    else
        echo "   🆕 Creando túnel..."
        OUTPUT=$($CLOUDFLARED tunnel create "$name" 2>&1)
        TUNNEL_ID=$(echo "$OUTPUT" | grep -oP 'Created tunnel \K[a-f0-9-]+')
        echo "   ✅ Creado: $TUNNEL_ID"
    fi
    
    echo "   💾 ID: $TUNNEL_ID"
    echo ""
    
    # Retornar el ID
    echo "$TUNNEL_ID"
}

# Crear túnel de producción
PROD_NAME="serviworld-prod"
PROD_DOMAIN="serviworldlogistics.com"
PROD_WWW="www.serviworldlogistics.com"

echo "----------------------------------------"
PROD_ID=$(create_tunnel "$PROD_NAME" "@" "$PROD_DOMAIN")

# Crear túnel de desarrollo
DEV_NAME="serviworld-dev"
DEV_DOMAIN="swl.1511170.xyz"

echo "----------------------------------------"
DEV_ID=$(create_tunnel "$DEV_NAME" "@" "$DEV_DOMAIN")

echo "----------------------------------------"
echo ""

# =====================================
# PASO 4: Configurar DNS (CNAME)
# =====================================
echo "🌐 Paso 4: Configurando DNS (CNAME)..."
echo ""

# Producción
echo "📌 Producción:"
$CLOUDFLARED tunnel route dns "$PROD_NAME" "$PROD_DOMAIN" 2>/dev/null && echo "   ✅ $PROD_DOMAIN" || echo "   ℹ️  $PROD_DOMAIN (ya existe)"
$CLOUDFLARED tunnel route dns "$PROD_NAME" "$PROD_WWW" 2>/dev/null && echo "   ✅ $PROD_WWW" || echo "   ℹ️  $PROD_WWW (ya existe)"
echo ""

# Desarrollo
echo "📌 Desarrollo:"
$CLOUDFLARED tunnel route dns "$DEV_NAME" "$DEV_DOMAIN" 2>/dev/null && echo "   ✅ $DEV_DOMAIN" || echo "   ℹ️  $DEV_DOMAIN (ya existe)"
echo ""

# =====================================
# PASO 5: Crear archivos de configuración
# =====================================
echo "⚙️  Paso 5: Creando config.yml..."
echo ""

# Config de producción
cat > "$CONFIG_DIR/config-prod.yml" << EOF
# Túnel de Producción - $PROD_DOMAIN
# Creado: $(date)

tunnel: $PROD_ID
credentials-file: $CONFIG_DIR/$PROD_ID.json

ingress:
  - hostname: $PROD_DOMAIN
    service: http://localhost:3000
  - hostname: $PROD_WWW
    service: http://localhost:3000
  - service: http_status:404
EOF

echo "   ✅ $CONFIG_DIR/config-prod.yml"

# Config de desarrollo
cat > "$CONFIG_DIR/config-dev.yml" << EOF
# Túnel de Desarrollo - $DEV_DOMAIN
# Creado: $(date)

tunnel: $DEV_ID
credentials-file: $CONFIG_DIR/$DEV_ID.json

ingress:
  - hostname: $DEV_DOMAIN
    service: http://localhost:3000
  - service: http_status:404
EOF

echo "   ✅ $CONFIG_DIR/config-dev.yml"
echo ""

# =====================================
# RESUMEN
# =====================================
echo "========================================"
echo "✅ SETUP COMPLETADO"
echo "========================================"
echo ""
echo "📁 Archivos generados:"
echo ""
ls -la "$CONFIG_DIR/" | grep -E "(config|json)" | awk '{print "   " $9 " (" $5 " bytes)"}'
echo ""
echo "🚀 PARA CORRER LOS TÚNELES (Paso 6):"
echo ""
echo "   Terminal 1 (Producción):"
echo "   ./cloudflared tunnel --config ~/.cloudflared/config-prod.yml run"
echo ""
echo "   Terminal 2 (Desarrollo):"
echo "   ./cloudflared tunnel --config ~/.cloudflared/config-dev.yml run"
echo ""
echo "🌐 URLs:"
echo "   Producción: https://$PROD_DOMAIN"
echo "              https://$PROD_WWW"
echo "   Desarrollo: https://$DEV_DOMAIN"
echo ""
echo "💡 Tips:"
echo "   - Los archivos .json son los credentials, NO los borres"
echo "   - Podés copiar el .json y config.yml a otra máquina para"
echo "     correr el mismo túnel desde diferentes lugares"
echo ""
