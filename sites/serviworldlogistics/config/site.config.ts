/**
 * Configuración del sitio: Serviworld Logistics
 * 
 * Domains:
 * - Public: serviworldlogistics.com
 * - CMS (oculto): swl.kinto.info
 */

export interface SiteConfig {
  site: {
    domain: string;
    name: string;
    description: string;
    language: string;
    logo?: string;
    favicon?: string;
  };
  cms: {
    enabled: boolean;
    subdomain: string;
    hidden: boolean;  // true = no enlaces públicos al CMS
    githubRepo: string;
    authEndpoint?: string;
  };
  build: {
    output: 'static';
    compressHTML: boolean;
    inlineStylesheets: 'auto' | 'always' | 'never';
  };
  skills: {
    // Skills activas se leen de skills-active.json
    // Esta config permite overrides por skill
  };
}

export default {
  site: {
    domain: 'serviworldlogistics.com',
    name: 'Serviworld Logistics',
    description: 'Soluciones logísticas globales para tu negocio',
    language: 'es',
    logo: '/logo.svg',
    favicon: '/favicon.ico'
  },
  cms: {
    enabled: true,
    subdomain: 'swl.kinto.info',
    hidden: true,  // CMS accesible solo por URL directa
    githubRepo: '1511170/serviworldlogistics.com',
    authEndpoint: 'https://swl-auth.camilocuadros.workers.dev'
  },
  build: {
    output: 'static',
    compressHTML: true,
    inlineStylesheets: 'auto'
  },
  skills: {}
} satisfies SiteConfig;
