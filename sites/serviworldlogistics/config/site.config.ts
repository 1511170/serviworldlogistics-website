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
  contact: {
    phoneDisplay: string;
    phoneE164: string;
    whatsappUrl: string;
    /** Mensaje opcional URL-encoded para wa.me */
    whatsappDefaultMessage?: string;
  };
  offices: {
    lines: string[];
  };
  seo: {
    googleSiteVerification?: string;
  };
  forms: {
    /**
     * FormSubmit.co — compatible con `output: 'static'`: el navegador hace POST directo a
     * formsubmit.co; no hace falta API routes ni servidor Node en producción.
     */
    formSubmitEmail: string;
    /** Copia (CC) — segundo destinatario (_cc) */
    formSubmitCc: string;
    /** URL absoluta de agradecimiento (_next), p. ej. `/gracias/` */
    formSubmitNextUrl: string;
  };
  cms: {
    enabled: boolean;
    subdomain: string;
    hidden: boolean;
    githubRepo: string;
    authEndpoint?: string;
  };
  build: {
    output: 'static';
    compressHTML: boolean;
    inlineStylesheets: 'auto' | 'always' | 'never';
  };
  skills: Record<string, unknown>;
}

const whatsappMessage =
  'Hola%2C%20me%20interesa%20cotizar%20un%20servicio%20de%20log%C3%ADstica';

const siteDomain = 'serviworldlogistics.com';

export default {
  site: {
    domain: siteDomain,
    name: 'Serviworld Logistics',
    description: 'Soluciones logísticas globales para tu negocio',
    language: 'es',
    logo: '/logo.svg',
    favicon: '/favicon.ico',
  },
  contact: {
    phoneDisplay: '+57 311 401 4547',
    phoneE164: '+573114014547',
    whatsappUrl: 'https://wa.me/573114014547',
    whatsappDefaultMessage: whatsappMessage,
  },
  offices: {
    lines: [
      'CALLE 25 No 99 – 34 BOGOTA D.C.',
      'CALLE 2A No 1 - 32 oficina 201 BUENAVENTURA',
      'CARRERA 25 No 25A - 32 piso 2 oficina 04 CARTAGENA',
    ],
  },
  seo: {
    googleSiteVerification: '93b78zDBhuVppuIPIhWEfwKNio07A5nT8TV6g9W_zt4',
  },
  forms: {
    formSubmitEmail: 'andres.garcia@serviworldlogistics.com',
    formSubmitCc: 'comercial@serviworldlogistics.com',
    formSubmitNextUrl: `https://${siteDomain}/gracias/`,
  },
  cms: {
    enabled: true,
    subdomain: 'swl.kinto.info',
    hidden: true,
    githubRepo: '1511170/serviworldlogistics.com',
    authEndpoint: 'https://swl-auth.camilocuadros.workers.dev',
  },
  build: {
    output: 'static',
    compressHTML: true,
    inlineStylesheets: 'auto',
  },
  skills: {},
} satisfies SiteConfig;
