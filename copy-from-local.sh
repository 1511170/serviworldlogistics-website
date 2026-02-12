#!/bin/bash
# Script para ejecutar en TU PC LOCAL
# Copia los archivos de Cloudflare al servidor

echo "💻 SCRIPT PARA TU PC LOCAL"
echo "=========================="
echo ""
echo "👉 Copiá y pegá estos comandos en tu terminal local:"
echo ""
echo "--------------------------------------------------------------"
echo ""

# Detectar IP del servidor
SERVER_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
    SERVER_IP="TU_IP_DEL_SERVIDOR"
fi

echo "# 1. Verificar que tenés el cert.pem"
echo "ls -la ~/.cloudflared/cert.pem"
echo ""

if command -v scp &> /dev/null; then
    echo "# 2. Copiar al servidor (usando scp):"
    echo "scp ~/.cloudflared/cert.pem root@$SERVER_IP:~/.cloudflared/"
    echo ""
    echo "# O si tu usuario es diferente:"
    echo "scp ~/.cloudflared/cert.pem usuario@$SERVER_IP:~/.cloudflared/"
else
    echo "# 2. Copiar al servidor (alternativa sin scp):"
    echo "# En tu PC, abrí el archivo:"
    echo "cat ~/.cloudflared/cert.pem"
    echo ""
    echo "# Copiá el contenido y en el servidor ejecutá:"
    echo "nano ~/.cloudflared/cert.pem"
    echo "# Pegá el contenido y guardá (Ctrl+O, Enter, Ctrl+X)"
fi

echo ""
echo "--------------------------------------------------------------"
echo ""
echo "📋 RESUMEN DE PASOS:"
echo ""
echo "1️⃣  En tu PC local:"
echo "    brew install cloudflared          # Mac"
echo "    cloudflared tunnel login          # Seleccioná tu dominio"
echo ""
echo "2️⃣  Copiá cert.pem al servidor (comando de arriba)"
echo ""
echo "3️⃣  En el servidor, ejecutá:"
echo "    ./setup-cloudflare.sh"
echo ""
echo "4️⃣  Listo! El script creará automáticamente:"
echo "    - Túnel 'serviworld-prod' → serviworldlogistics.com"
echo "    - Túnel 'serviworld-dev'  → swl.1511170.xyz"
echo "    - configs en ~/.cloudflared/"
echo ""
