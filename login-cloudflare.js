#!/usr/bin/env node
/**
 * Script para autenticar cloudflared usando navegador headless
 * Esto evita necesitar hacer login desde tu PC local
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

const CONFIG_DIR = `${process.env.HOME}/.cloudflared`;
const CERT_PATH = `${CONFIG_DIR}/cert.pem`;

// Credenciales de Cloudflare (pide al usuario)
const CF_EMAIL = process.env.CF_EMAIL || '';
const CF_API_KEY = process.env.CF_API_KEY || ''; // Global API Key, no el token

async function loginCloudflare() {
  console.log('🚀 Iniciando autenticación automática de Cloudflare...\n');
  
  if (!fs.existsSync(CONFIG_DIR)) {
    fs.mkdirSync(CONFIG_DIR, { recursive: true });
  }
  
  // Verificar si ya está autenticado
  if (fs.existsSync(CERT_PATH)) {
    console.log('✅ Ya existe cert.pem, estás autenticado');
    return;
  }
  
  console.log('⚠️  Para autenticar necesito:');
  console.log('   - Email de tu cuenta Cloudflare');
  console.log('   - Global API Key (no el API Token)');
  console.log('');
  console.log('El Global API Key lo encontrás en:');
  console.log('   https://dash.cloudflare.com/profile/api-tokens');
  console.log('   (hacé click en "View" al lado de Global API Key)');
  console.log('');
  
  if (!CF_EMAIL || !CF_API_KEY) {
    console.log('❌ Seteá las variables de entorno:');
    console.log('   export CF_EMAIL="tu@email.com"');
    console.log('   export CF_API_KEY="tu-global-api-key"');
    console.log('');
    process.exit(1);
  }
  
  console.log('📧 Email:', CF_EMAIL);
  console.log('🔑 API Key: ****' + CF_API_KEY.slice(-4));
  console.log('');
  
  // Intentar login vía API (alternativa a browser)
  console.log('🔄 Intentando autenticación vía API...');
  
  try {
    // Obtener zones para verificar credenciales
    const response = await fetch('https://api.cloudflare.com/client/v4/zones', {
      headers: {
        'X-Auth-Email': CF_EMAIL,
        'X-Auth-Key': CF_API_KEY,
        'Content-Type': 'application/json'
      }
    });
    
    const data = await response.json();
    
    if (!data.success) {
      console.error('❌ Error de autenticación:', data.errors);
      process.exit(1);
    }
    
    console.log('✅ Credenciales válidas!');
    console.log('📋 Zonas disponibles:');
    data.result.forEach(zone => {
      console.log(`   - ${zone.name} (ID: ${zone.id})`);
    });
    
    // Crear certificado via API
    console.log('');
    console.log('📝 Para crear túneles sin browser, usá el siguiente método:');
    console.log('');
    console.log('1. Andá al dashboard de Cloudflare:');
    console.log('   https://one.dash.cloudflare.com/');
    console.log('');
    console.log('2. Creá los túneles manualmente y descargá los credentials');
    console.log('');
    console.log('O usá la OPCIÓN B (ngrok) que no requiere auth complicada');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

loginCloudflare();
