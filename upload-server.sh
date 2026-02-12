#!/bin/bash
# Servidor temporal para subir archivos

PORT=8080
UPLOAD_DIR="$HOME/.cloudflared"

echo "🚀 SERVIDOR DE SUBIDA TEMPORAL"
echo "==============================="
echo ""
echo "📁 Directorio destino: $UPLOAD_DIR"
echo "🌐 URL: http://$(hostname -I | awk '{print $1}'):$PORT"
echo ""
echo "👉 Desde tu celular/computadora:"
echo "   1. Andá a: http://$(hostname -I | awk '{print $1}'):$PORT"
echo "   2. Seleccioná el archivo .json"
echo "   3. Click en Subir"
echo ""
echo "⚠️  El servidor se apaga solo después de 5 minutos"
echo ""

# Crear HTML de subida
mkdir -p /tmp/upload
cat > /tmp/upload/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Subir credenciales Cloudflare</title>
    <style>
        body { font-family: sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
        .box { border: 2px dashed #ccc; padding: 40px; text-align: center; border-radius: 10px; }
        .btn { background: #f48120; color: white; padding: 15px 30px; border: none; 
               border-radius: 5px; cursor: pointer; font-size: 16px; }
        .btn:hover { background: #e07010; }
    </style>
</head>
<body>
    <h1>📤 Subir credenciales Cloudflare</h1>
    <div class="box">
        <form action="/upload" method="post" enctype="multipart/form-data">
            <p>Seleccioná el archivo <code>&lt;TUNNEL-ID&gt;.json</code></p>
            <input type="file" name="file" accept=".json" required><br><br>
            <button type="submit" class="btn">📤 Subir archivo</button>
        </form>
    </div>
</body>
</html>
HTML

# Iniciar servidor Python para subir
cd /tmp/upload
python3 -c "
import http.server
import socketserver
import cgi
import os

UPLOAD_DIR = '$UPLOAD_DIR'
os.makedirs(UPLOAD_DIR, exist_ok=True)

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            with open('index.html', 'rb') as f:
                self.wfile.write(f.read())
        else:
            super().do_GET()
    
    def do_POST(self):
        if self.path == '/upload':
            content_type = self.headers['Content-Type']
            boundary = content_type.split('=')[1].encode()
            content_length = int(self.headers['Content-Length'])
            
            body = self.rfile.read(content_length)
            
            # Extraer archivo
            parts = body.split(boundary)
            for part in parts:
                if b'filename=' in part and b'.json' in part:
                    # Extraer nombre
                    filename = part.split(b'filename=')[1].split(b'\r\n')[0].strip(b'\"').decode()
                    # Extraer contenido
                    content = part.split(b'\r\n\r\n')[1].rsplit(b'\r\n', 1)[0]
                    
                    filepath = os.path.join(UPLOAD_DIR, filename)
                    with open(filepath, 'wb') as f:
                        f.write(content)
                    
                    self.send_response(200)
                    self.send_header('Content-type', 'text/html')
                    self.end_headers()
                    self.wfile.write(b'<h1>✅ Archivo subido correctamente!</h1>')
                    self.wfile.write(f'<p>Guardado en: {filepath}</p>'.encode())
                    self.wfile.write(b'<p>Podés cerrar esta página y volver al terminal.</p>')
                    return
            
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b'Error')

with socketserver.TCPServer(('', $PORT), Handler) as httpd:
    print('Servidor activo en el puerto', $PORT)
    httpd.timeout = 300  # 5 minutos timeout
    httpd.handle_request()
    httpd.handle_request()
    httpd.handle_request()
" 2>/dev/null &

PID=$!
sleep 2

echo "Servidor iniciado (PID: $PID)"
echo ""
echo "Esperando archivos... (5 minutos máximo)"

# Esperar archivos
for i in {1..30}; do
    if ls $UPLOAD_DIR/*.json 1>/dev/null 2>&1; then
        echo ""
        echo "✅ ARCHIVO RECIBIDO:"
        ls -la $UPLOAD_DIR/*.json
        echo ""
        kill $PID 2>/dev/null
        echo "Servidor detenido"
        exit 0
    fi
    sleep 10
    echo -n "."
done

echo ""
echo "⏰ Tiempo agotado, deteniendo servidor"
kill $PID 2>/dev/null
