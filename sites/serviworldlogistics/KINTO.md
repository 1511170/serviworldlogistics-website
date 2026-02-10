# 🚛 Serviworld Logistics - Guía del Proyecto

> **Cliente:** Serviworld Logistics  
> **Industria:** Logística y transporte internacional  
> **Sitio:** serviworldlogistics.com  
> **CMS:** swl.kinto.info (oculto)  

---

## ⚡ Comandos Rápidos (Trabajas desde aquí)

```bash
# Estás en: kinto-cms/sites/serviworldlogistics/

# Ver skills instaladas
cat skills-active.json

# Instalar skills disponibles
node scripts/skill-add.js cms-sveltia
node scripts/skill-add.js testimonials

# Crear skill específica para este proyecto
node scripts/skill-create.js tracking-widget

# Dev server
npm install
npm run dev        # http://localhost:4321

# Build
npm run build      # Salida: ./dist/
```

---

## 🎯 Brief del Cliente

**Serviworld Logistics** es una empresa de logística internacional que necesita:

### Páginas Requeridas
- [ ] **Home** - Hero impactante, servicios destacados, CTA
- [ ] **Servicios** - Transporte aéreo, marítimo, terrestre, almacenamiento
- [ ] **Nosotros** - Historia, equipo, valores
- [ ] **Blog/Noticias** - Artículos de logística (CMS-editable)
- [ ] **Contacto** - Formulario + mapa + info

### Funcionalidades
- [ ] CMS para que editen contenido sin código
- [ ] Testimonios de clientes
- [ ] Formulario de cotización
- [ ] Optimización SEO (schema.org)

### Identidad Visual
- **Colores:** Azul corporativo (brand), blanco, grises
- **Estilo:** Profesional, moderno, confiable
- **Imágenes:** Contenedores, camiones, aviones, almacenes

---

## 📁 Estructura de este Sitio

```
sites/serviworldlogistics/
├── src/
│   ├── pages/           # Rutas del sitio
│   │   ├── index.astro      # Home
│   │   ├── servicios.astro  # Página de servicios
│   │   ├── nosotros.astro   # About
│   │   ├── blog/            # Blog (rutas dinámicas)
│   │   └── contacto.astro   # Contacto
│   ├── layouts/         # Layouts
│   │   └── Layout.astro
│   └── components/      # Componentes locales
├── public/              # Assets estáticos
│   ├── images/          # Imágenes del sitio
│   ├── logo.svg
│   └── favicon.ico
├── config/
│   ├── site.config.ts   # Config principal
│   └── cms.config.yml   # Config del CMS
├── scripts/             # Utilidades
│   ├── skill-add.js
│   ├── skill-create.js
│   └── skill-list.js
└── skills-active.json   # Skills instaladas
```

---

## 🔧 Configuración Específica

### Site Config (`config/site.config.ts`)
```typescript
{
  site: {
    domain: 'serviworldlogistics.com',
    name: 'Serviworld Logistics',
    description: 'Soluciones logísticas globales',
    language: 'es'
  },
  cms: {
    enabled: true,
    subdomain: 'swl.kinto.info',  // ← Oculto, no enlaces públicos
    hidden: true
  }
}
```

### Skills Activas (`skills-active.json`)
```json
{
  "site": "serviworldlogistics",
  "skills": [
    // Aquí se listan las skills instaladas
  ]
}
```

---

## 🎨 Sistema de Diseño (Tailwind)

### Colores (definidos en `tailwind.config.mjs`)
```javascript
colors: {
  brand: {
    50: '#eff6ff',
    100: '#dbeafe',
    500: '#3b82f6',
    600: '#2563eb',  // ← Primario
    700: '#1d4ed8',
    900: '#1e3a8a',
  }
}
```

### Tipografía
- **Headings:** Inter, bold
- **Body:** Inter, regular
- **Tamaños:** text-4xl (hero), text-2xl (secciones), text-base (body)

---

## 🧩 Skills Recomendadas para este Proyecto

Basado en el brief, estas skills serían útiles:

| Skill | Propósito | Estado |
|-------|-----------|--------|
| `cms-sveltia` | Panel admin para cliente | ⬜ Pendiente |
| `testimonials` | Testimonios con schema.org | ⬜ Pendiente |
| `contact-form` | Formulario de contacto | ⬜ Crear |
| `seo-ai-citations` | SEO avanzado | ⬜ Crear |
| `blog` | Sistema de blog | ⬜ Crear |

**Instalar:**
```bash
node scripts/skill-add.js cms-sveltia
node scripts/skill-add.js testimonials
```

**Crear si no existen:**
```bash
node scripts/skill-create.js contact-form
node scripts/skill-create.js blog
```

---

## 📝 Contenido Sugerido (Home)

### Hero Section
```
Headline: "Conectamos tu negocio con el mundo"
Subheadline: "Soluciones logísticas integrales: transporte aéreo, 
              marítimo y terrestre con cobertura global"
CTA Primario: "Cotizar ahora"
CTA Secundario: "Conocer servicios"
Imagen: Avión de carga/contenedores
```

### Servicios Section
```
Título: "Nuestros Servicios"

1. Transporte Aéreo
   - Envíos urgentes internacionales
   - Cobertura 200+ países

2. Transporte Marítimo
   - FCL y LCL
   - Consolidación de carga

3. Transporte Terrestre
   - Nacional e internacional
   - Full truckload y LTL

4. Almacenamiento
   - Centros de distribución
   - Gestión de inventario
```

### Testimonios Section
```
Título: "Lo que dicen nuestros clientes"

"Serviworld redujo nuestros tiempos de entrega en 40%"
- Juan Pérez, CEO de Importadora XYZ

"El mejor aliado logístico para nuestra expansión internacional"
- María García, Directora de Operaciones, ABC Corp
```

---

## 🔐 CMS - Configuración para el Cliente

El CMS está en `swl.kinto.info` (oculto del sitio público).

### Colecciones a Crear:
1. **Blog Posts**
   - Título, slug, fecha, autor, imagen, contenido
   
2. **Testimonios**
   - Nombre, empresa, cargo, foto, testimonio, categoría
   
3. **Servicios**
   - Título, descripción, icono, detalles

4. **Páginas**
   - Home, Nosotros, Contacto (contenido editable)

---

## ✅ Checklist de Entrega

### Contenido
- [ ] Home completa con Hero, Servicios, Testimonios, CTA
- [ ] Página de Servicios detallada
- [ ] Página Nosotros (historia, equipo, valores)
- [ ] Blog funcional con posts de ejemplo
- [ ] Página de Contacto con formulario

### Funcionalidad
- [ ] CMS instalado y configurado
- [ ] Formulario de contacto funcional
- [ ] Testimonios dinámicos desde CMS
- [ ] Blog con posts editables

### SEO & Performance
- [ ] Schema.org en servicios (LocalBusiness)
- [ ] Meta tags en todas las páginas
- [ ] Imágenes optimizadas (WebP)
- [ ] Lazy loading en imágenes
- [ ] Sitemap.xml

### CMS
- [ ] Configurado en swl.kinto.info
- [ ] Colecciones creadas (blog, testimonios, servicios)
- [ ] Usuario de admin creado
- [ ] Guía de uso para el cliente

### Deploy
- [ ] Build exitoso
- [ ] Preview funciona correctamente
- [ ] Cloudflare Pages configurado

---

## 🆘 Ayuda y Referencias

### Ver skills disponibles del sistema:
```bash
ls ../../skills/official/
ls ../../skills/community/
```

### Documentación completa:
- [KINTO CMS - Guía Principal](../../KINTO.md)
- [AI Generation Guide](../../docs/AI_GENERATION.md)
- [Arquitectura del Sistema](../../STRUCTURE.md)

### Comandos útiles:
```bash
# Reset (volver a empezar)
rm -rf node_modules dist .astro
npm install

# Ver errores detallados
npm run dev -- --verbose

# Build con debugging
DEBUG=* npm run build
```

---

## 🚀 Estado Actual

**Última actualización:** 2025-02-10

**Skills instaladas:** 
```json
{
  "site": "serviworldlogistics",
  "skills": []
}
```

**Próximo paso:** Instalar skills necesarias y generar contenido.

```bash
node scripts/skill-add.js cms-sveltia
node scripts/skill-add.js testimonials
```

---

**¿Listo para empezar?** Revisa el brief arriba, instala las skills necesarias, y comienza a generar las páginas. 🚛✨
