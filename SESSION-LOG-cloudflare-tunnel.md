# Registro de Sesión: Configuración Cloudflare Tunnels

**Fecha:** 2026-02-10  
**Proyecto:** serviworldlogistics  
**Objetivo:** Configurar túneles permanentes de Cloudflare para producción y desarrollo

---

## 📋 Resumen Ejecutivo

Se configuraron exitosamente dos túneles permanentes de Cloudflare:
- **Producción:** https://serviworldlogistics.com ✅
- **Desarrollo:** https://swl.1511170.xyz ✅

Además, se creó un skill completo y documentado para futuras configuraciones.

---

## 🎯 Problemas Encontrados y Soluciones

### 1. Token JWT No Válido
**Problema:** El archivo de configuración tenía un token que cloudflared no reconocía.

**Error:**
```
Provided Tunnel token is not valid
```

**Solución:** 
- Decodificar el token JWT (base64) para extraer AccountTag, TunnelID y TunnelSecret
- Crear manualmente el archivo de credenciales JSON en `~/.cloudflared/TUNNEL_ID.json`

```bash
# Decodificar token
echo "TOKEN_JWT" | base64 -d | jq .

# Crear archivo de credenciales
cat > ~/.cloudflared/7484180f-3d93-4e02-b828-fdfa5d94449a.json << 'EOF'
{
    "AccountTag": "948994a95e4d7d23badec650fa303120",
    "TunnelSecret": "MDYwYmI4NGMtZTllZS00YmRmLTg2Y2UtYWVlYzRlOGIwNjIy",
    "TunnelID": "7484180f-3d93-4e02-b828-fdfa5d94449a"
}
EOF
```

### 2. Puerto Incorrecto
**Problema:** Las configuraciones existentes apuntaban al puerto 3000, pero el servidor Astro corre en 4321.

**Solución:** Actualizar todos los archivos de configuración:
```yaml
# Antes
service: http://localhost:3000

# Después  
service: http://localhost:4321
```

### 3. Error 502 - HTTPS vs HTTP
**Problema:** El túnel de desarrollo intentaba usar HTTPS pero el servidor local es HTTP.

**Error:**
```
tls: first record does not look like a TLS handshake
dest=https://swl.1511170.xyz/ event=0 type=http
```

**Soluciones intentadas:**
1. Crear proxy SSL local en puerto 8443 (funcionó técnicamente)
2. **Solución final:** El usuario configuró manualmente en Cloudflare Dashboard cambiando el service de `https://` a `http://`

---

## 🔧 Configuración Final

### Archivos de Configuración

#### Producción (`~/.cloudflared/config-prod.yml`)
```yaml
tunnel: 29523b53-e53c-41a1-bd6a-a29352a861b7
credentials-file: /home/5toai/.cloudflared/29523b53-e53c-41a1-bd6a-a29352a861b7.json

ingress:
  - hostname: serviworldlogistics.com
    service: http://localhost:4321
  - hostname: www.serviworldlogistics.com
    service: http://localhost:4321
  - service: http_status:404
```

#### Desarrollo (`~/.cloudflared/config-dev.yml`)
```yaml
tunnel: 7484180f-3d93-4e02-b828-fdfa5d94449a
credentials-file: /home/5toai/.cloudflared/7484180f-3d93-4e02-b828-fdfa5d94449a.json

ingress:
  - hostname: swl.1511170.xyz
    service: http://localhost:4321
  - service: http_status:404
```

### Procesos Activos
- **Producción:** PID 889848 - Tunnel ID: 29523b53-e53c-41a1-bd6a-a29352a861b7
- **Desarrollo:** PID 891014 - Tunnel ID: 7484180f-3d93-4e02-b828-fdfa5d94449a

### Logs
- Producción: `/tmp/tunnel-prod.log`
- Desarrollo: `/tmp/tunnel-dev.log`

---

## 📦 Skill Creado: cloudflare-tunnel

Se desarrolló un skill completo para automatizar configuraciones futuras.

### Ubicación
`serviworldlogistics/skills/community/cloudflare-tunnel/`

### Archivos del Skill

| Archivo | Tamaño | Descripción |
|---------|--------|-------------|
| `SKILL.md` | 8.5 KB | Documentación para usuarios |
| `README-ASSISTANT.md` | 9.9 KB | Guía para asistentes de IA |
| `setup-tunnel.js` | 11.8 KB | Script de automatización Node.js |
| `setup.sh` | 2.8 KB | Script interactivo Bash |

### Características del Skill

1. **Agnóstico a la IA:** Funciona con Claude Code, Kimi, o cualquier asistente
2. **Automatización completa:** Decodifica JWT, crea credenciales, configura DNS, inicia túneles
3. **Manejo de errores:** Documenta soluciones para problemas comunes
4. **Verificación automática:** Prueba que las URLs respondan HTTP 200

### Uso del Skill

```bash
# Automatizado
node skills/community/cloudflare-tunnel/setup-tunnel.js \
  --token="eyJ..." \
  --domain="serviworldlogistics.com" \
  --dev-domain="swl.1511170.xyz" \
  --port=4321
```

---

## 🌐 Estado Final de los Túneles

| Entorno | URL | Estado HTTP | Tunnel ID |
|---------|-----|-------------|-----------|
| Producción | https://serviworldlogistics.com | 200 ✅ | 29523b53-e53c-41a1-bd6a-a29352a861b7 |
| Desarrollo | https://swl.1511170.xyz | 200 ✅ | 7484180f-3d93-4e02-b828-fdfa5d94449a |

### Comandos de Verificación
```bash
# Verificar procesos
ps aux | grep cloudflared | grep -v grep

# Verificar URLs
curl -s -o /dev/null -w "%{http_code}" https://serviworldlogistics.com/
curl -s -o /dev/null -w "%{http_code}" https://swl.1511170.xyz/

# Ver logs
tail -f /tmp/tunnel-prod.log
tail -f /tmp/tunnel-dev.log
```

---

## 📝 Comandos Útiles para el Usuario

### Iniciar túneles
```bash
cd /home/5toai/websites/serviworldlogistics
./cloudflared tunnel --config ~/.cloudflared/config-prod.yml run > /tmp/tunnel-prod.log 2>&1 &
sleep 3
./cloudflared tunnel --config ~/.cloudflared/config-dev.yml run > /tmp/tunnel-dev.log 2>&1 &
```

### Detener túneles
```bash
pkill -f "cloudflared.*29523b53"
pkill -f "cloudflared.*7484180f"
```

### O usar el script generado
```bash
./start-tunnels.sh
```

---

## 🔍 Aprendizajes Clave

1. **Token JWT != Simple ID:** El token contiene credenciales completas (AccountTag, TunnelID, TunnelSecret)
2. **Decodificación:** `echo "TOKEN" | base64 -d | jq .` revela los componentes
3. **Archivo de credenciales:** Debe estar en `~/.cloudflared/TUNNEL_ID.json` con formato específico
4. **Configuración remota vs local:** Cloudflare puede tener configuración de ingress en la nube que sobrescribe la local
5. **HTTPS vs HTTP:** Para servidores locales sin SSL, usar `http://localhost:PORT`, no `https://`

---

## 📚 Recursos Creados

### Script de Proxy SSL (alternativa temporal)
```javascript
// /tmp/ssl-proxy/proxy.js
// Usado como workaround cuando cloudflared requería HTTPS
// Redirige HTTPS:8443 -> HTTP:4321
```

### Script de inicio automático
```bash
# ./start-tunnels.sh
# Generado automáticamente, inicia ambos túneles
```

---

## ✅ Checklist Completado

- [x] Configurar túnel de producción (serviworldlogistics.com)
- [x] Configurar túnel de desarrollo (swl.1511170.xyz)
- [x] Crear archivos de credenciales JSON
- [x] Configurar DNS en Cloudflare
- [x] Iniciar túneles en segundo plano
- [x] Verificar funcionamiento (HTTP 200)
- [x] Crear skill documentado
- [x] Crear script de automatización
- [x] Documentar soluciones a problemas comunes

---

## 🔄 Próximos Pasos (Opcionales)

1. **Systemd service:** Para iniciar túneles automáticamente al boot
2. **Monitoreo:** Script que verifique periódicamente el estado
3. **Backup:** Guardar tokens y configuraciones en lugar seguro
4. **CI/CD:** Integrar configuración de túneles en despliegues

---

**Fin del Registro**
