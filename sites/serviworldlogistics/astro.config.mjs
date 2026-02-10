import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import siteConfig from './config/site.config.ts';

// Cargar skills activas
const activeSkills = JSON.parse(
  require('fs').readFileSync('./skills-active.json', 'utf-8')
).skills;

console.log('Skills activas:', activeSkills.length ? activeSkills : 'Ninguna (core limpio)');

export default defineConfig({
  output: siteConfig.build.output,
  site: `https://${siteConfig.site.domain}`,
  integrations: [
    tailwind({
      // Skills pueden añadir sus propios content paths
      configFile: './tailwind.config.mjs'
    })
  ],
  build: {
    format: 'directory',
    compressHTML: siteConfig.build.compressHTML
  },
  vite: {
    // Alias para skills
    resolve: {
      alias: {
        '@skills': '../../skills',
        '@site': './src'
      }
    }
  }
});
