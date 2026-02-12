/**
 * Cloudflare Worker - GitHub OAuth proxy for Sveltia/Decap CMS
 *
 * Handles the OAuth flow:
 *   /auth     → redirects to GitHub authorization
 *   /callback → exchanges code for token, sends to CMS via postMessage
 */

const GITHUB_AUTH_URL = 'https://github.com/login/oauth/authorize';
const GITHUB_TOKEN_URL = 'https://github.com/login/oauth/access_token';

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: corsHeaders()
      });
    }

    try {
      if (url.pathname === '/auth' || url.pathname === '/auth/') {
        return handleAuth(env);
      }

      if (url.pathname === '/callback' || url.pathname === '/callback/') {
        return handleCallback(url, env);
      }

      return new Response('OAuth endpoint. Use /auth to start.', {
        status: 200,
        headers: { 'Content-Type': 'text/plain' }
      });
    } catch (err) {
      return new Response(`Error: ${err.message}`, { status: 500 });
    }
  }
};

function handleAuth(env) {
  const params = new URLSearchParams({
    client_id: env.GITHUB_CLIENT_ID,
    redirect_uri: `https://swl-auth.camilocuadros.workers.dev/callback`,
    scope: 'public_repo',
    state: crypto.randomUUID()
  });

  return Response.redirect(`${GITHUB_AUTH_URL}?${params}`, 302);
}

async function handleCallback(url, env) {
  const code = url.searchParams.get('code');

  if (!code) {
    return new Response('Missing code parameter', { status: 400 });
  }

  // Exchange code for access token
  const tokenResponse = await fetch(GITHUB_TOKEN_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    },
    body: JSON.stringify({
      client_id: env.GITHUB_CLIENT_ID,
      client_secret: env.GITHUB_CLIENT_SECRET,
      code: code
    })
  });

  const data = await tokenResponse.json();

  if (data.error) {
    return new Response(`GitHub error: ${data.error_description || data.error}`, { status: 401 });
  }

  // Return HTML that sends the token to the CMS via postMessage
  const html = `<!DOCTYPE html>
<html>
<head><title>Authenticating...</title></head>
<body>
<script>
(function() {
  function sendMessage(provider, token) {
    const msg = 'authorization:' + provider + ':success:' + JSON.stringify({ token: token });
    window.opener
      ? window.opener.postMessage(msg, '*')
      : window.parent.postMessage(msg, '*');
    setTimeout(function() { window.close(); }, 1000);
  }
  sendMessage('github', '${data.access_token}');
})();
</script>
<p>Authenticated. This window will close automatically.</p>
</body>
</html>`;

  return new Response(html, {
    status: 200,
    headers: { 'Content-Type': 'text/html;charset=UTF-8' }
  });
}

function corsHeaders() {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  };
}
