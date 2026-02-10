#!/usr/bin/env node
/**
 * Script: skill-create.js
 * Crea una nueva skill (usado por IA)
 * 
 * Uso: node scripts/skill-create.js [skill-name] [--category=community]
 */

import { mkdirSync, writeFileSync, existsSync } from 'fs';
import { join, resolve } from 'path';

const skillName = process.argv[2];
const categoryArg = process.argv.find(a => a.startsWith('--category='));
const category = categoryArg ? categoryArg.split('=')[1] : 'community';

if (!skillName) {
  console.error('❌ Error: Debes especificar el nombre de la skill');
  console.log('Uso: node scripts/skill-create.js [skill-name]');
  process.exit(1);
}

const skillsRoot = resolve(process.cwd(), '../../skills');
const skillPath = join(skillsRoot, category, skillName);

if (existsSync(skillPath)) {
  console.error(`❌ Skill "${skillName}" ya existe en skills/${category}/`);
  process.exit(1);
}

// Crear estructura de skill
const dirs = ['components', 'config', 'example'];
dirs.forEach(dir => mkdirSync(join(skillPath, dir), { recursive: true }));

// Crear SKILL.md template
const skillMd = `# Skill: ${skillName}

Descripción de qué hace esta skill.

## Qué hace

- Funcionalidad 1
- Funcionalidad 2

## Instalación

\`\`\`bash
kinto skill add ${skillName} --site=[nombre-sitio]
\`\`\`

## Uso

\`\`\`astro
---
import MiComponente from '@skills/${category}/${skillName}/components/MiComponente.astro';
---

<MiComponente />
\`\`\`

## Creó esta skill

- **Fecha**: ${new Date().toISOString().split('T')[0]}
- **Proyecto**: [nombre-del-proyecto]
- **IA**: [Kimi Code | Claude Code | Otro]
- **Reutilizable**: Sí
`;

writeFileSync(join(skillPath, 'SKILL.md'), skillMd);

// Crear index.ts template
const indexTs = `/**
 * Skill: ${skillName}
 * Creada por IA
 * Reutilizable para cualquier sitio
 */

export const config = {
  name: '${skillName}',
  version: '1.0.0',
  description: 'Descripción de la skill',
  category: '${category}',
  author: 'AI',
  createdFor: '[nombre-proyecto]',
  reusable: true
};

export function install(context) {
  // Añade componentes
  // context.addComponent('MiComponente', './components/MiComponente.astro');
  
  // Añade CMS collection
  // context.addCMSCollection({...});
  
  // Añade rutas
  // context.addRoute('/mi-ruta', './pages/MiPagina.astro');
  
  console.log('✅ Skill ${skillName} instalada');
}
`;

writeFileSync(join(skillPath, 'index.ts'), indexTs);

console.log(`✅ Skill "${skillName}" creada`);
console.log(`   Ubicación: skills/${category}/${skillName}/`);
console.log(`   Archivos creados:`);
console.log(`   - SKILL.md (documentación)`);
console.log(`   - index.ts (entry point)`);
console.log(`   - components/ (componentes Astro)`);
console.log(`   - config/ (configuración)`);
console.log(`   - example/ (ejemplos de uso)`);
console.log(`\n📝 Para completar la skill:`);
console.log(`   1. Edita SKILL.md con la documentación`);
console.log(`   2. Implementa los componentes en components/`);
console.log(`   3. Define la lógica en index.ts`);
console.log(`\n🚀 Para usarla:`);
console.log(`   node scripts/skill-add.js ${skillName}`);
