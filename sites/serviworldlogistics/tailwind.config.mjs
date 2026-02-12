import coreConfig from '../../core/tailwind.config.mjs';

/** @type {import('tailwindcss').Config} */
export default {
  ...coreConfig,
  content: [
    './src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#1a365d',
          light: '#2c5282',
          dark: '#0f172a',
        },
        accent: {
          DEFAULT: '#e11d48',
          light: '#f43f5e',
          dark: '#be123c',
        },
      },
      fontFamily: {
        display: ['"Roboto Condensed"', 'sans-serif'],
        body: ['Roboto', 'sans-serif'],
      },
    },
  },
};
