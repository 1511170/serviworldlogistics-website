import coreConfig from '../../core/tailwind.config.mjs';

/** @type {import('tailwindcss').Config} */
export default {
  ...coreConfig,
  content: [
    './src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}',
    // Skills activas añaden sus paths aquí
  ],
  theme: {
    extend: {
      // Colores de marca Serviworld Logistics
      colors: {
        brand: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
          900: '#0c4a6e',
        }
      }
    },
  },
}
