/**
 * Simple Kimi AI Worker
 * 
 * A minimal Cloudflare Worker that connects to Kimi (Moonshot AI) API
 * No containers, no complex setup - just a simple proxy
 */

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    
    // Debug: log environment
    console.log('URL:', url.toString());
    console.log('Token from URL:', url.searchParams.get('token'));
    console.log('Expected token:', env.MOLTBOT_GATEWAY_TOKEN);
    console.log('KIMI_API_KEY exists:', !!env.KIMI_API_KEY);
    
    // Check for gateway token (except for root path which shows HTML)
    const token = url.searchParams.get('token');
    const expectedToken = env.MOLTBOT_GATEWAY_TOKEN;
    
    // For root path, show HTML interface
    if (url.pathname === '/' || url.pathname === '') {
      if (!token || token !== expectedToken) {
        return new Response('Unauthorized: Invalid or missing token. Add ?token=YOUR_TOKEN to the URL. Got: ' + token + ', Expected: ' + expectedToken, { status: 401 });
      }
      // Return simple HTML interface
      return new Response(htmlInterface, {
        headers: { 'Content-Type': 'text/html' }
      });
    }
    
    // For API routes, check token
    if (!token || token !== expectedToken) {
      return new Response('Unauthorized: Invalid or missing token. Got: ' + token + ', Expected: ' + expectedToken, { status: 401 });
    }
    
    // Handle different paths
    if (url.pathname === '/' || url.pathname === '') {
      // Return simple HTML interface
      return new Response(htmlInterface, {
        headers: { 'Content-Type': 'text/html' }
      });
    }
    
    if (url.pathname === '/api/chat') {
      // Proxy to Kimi API
      return handleChatRequest(request, env);
    }
    
    if (url.pathname === '/api/models') {
      // Return available models
      return new Response(JSON.stringify({
        models: [
          { id: 'moonshot-v1-8k', name: 'Kimi 8K', context: 8192 },
          { id: 'moonshot-v1-32k', name: 'Kimi 32K', context: 32768 },
          { id: 'moonshot-v1-128k', name: 'Kimi 128K', context: 128000 }
        ]
      }), {
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    return new Response('Not Found', { status: 404 });
  }
};

async function handleChatRequest(request, env) {
  try {
    const body = await request.json();
    
    // Call Kimi API
    const response = await fetch('https://api.moonshot.cn/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${env.KIMI_API_KEY}`
      },
      body: JSON.stringify({
        model: body.model || 'moonshot-v1-8k',
        messages: body.messages || [],
        temperature: body.temperature || 0.7,
        max_tokens: body.max_tokens || 1000,
        stream: body.stream || false
      })
    });
    
    if (!response.ok) {
      const error = await response.text();
      return new Response(JSON.stringify({ error }), {
        status: response.status,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    const data = await response.json();
    return new Response(JSON.stringify(data), {
      headers: { 'Content-Type': 'application/json' }
    });
    
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}

const htmlInterface = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Simple Kimi AI</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
      background: #f5f5f5;
    }
    .container {
      background: white;
      border-radius: 10px;
      padding: 30px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    h1 {
      color: #333;
      margin-bottom: 20px;
    }
    .cost-info {
      background: #e8f5e9;
      border-left: 4px solid #4caf50;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 4px;
    }
    .chat-container {
      display: flex;
      flex-direction: column;
      gap: 15px;
    }
    #messages {
      height: 400px;
      overflow-y: auto;
      border: 1px solid #ddd;
      padding: 15px;
      border-radius: 5px;
      background: #fafafa;
    }
    .message {
      margin-bottom: 10px;
      padding: 10px;
      border-radius: 5px;
    }
    .user {
      background: #e3f2fd;
      text-align: right;
    }
    .assistant {
      background: #f1f8e9;
    }
    #input {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 16px;
    }
    button {
      background: #2196f3;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
    }
    button:hover {
      background: #1976d2;
    }
    .model-selector {
      margin-bottom: 15px;
    }
    select {
      padding: 8px;
      border-radius: 4px;
      border: 1px solid #ddd;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🤖 Simple Kimi AI</h1>
    
    <div class="cost-info">
      <strong>💰 Cost Effective:</strong> Using Kimi (Moonshot AI) at ~$0.60 per million tokens
      <br><small>Compared to Claude Opus at $15.00 per million tokens (25x more expensive!)</small>
    </div>
    
    <div class="model-selector">
      <label for="model">Model: </label>
      <select id="model">
        <option value="moonshot-v1-8k">Kimi 8K (Fast & Affordable)</option>
        <option value="moonshot-v1-32k">Kimi 32K (Balanced)</option>
        <option value="moonshot-v1-128k">Kimi 128K (Large Context)</option>
      </select>
    </div>
    
    <div class="chat-container">
      <div id="messages"></div>
      <div>
        <input type="text" id="input" placeholder="Type your message here..." />
        <button onclick="sendMessage()">Send</button>
      </div>
    </div>
  </div>

  <script>
    const messagesDiv = document.getElementById('messages');
    const input = document.getElementById('input');
    const modelSelect = document.getElementById('model');
    
    // Add welcome message
    addMessage('assistant', 'Hello! I\'m your Kimi AI assistant. How can I help you today?');
    
    async function sendMessage() {
      const text = input.value.trim();
      if (!text) return;
      
      // Add user message
      addMessage('user', text);
      input.value = '';
      
      // Show typing indicator
      const typingId = addMessage('assistant', 'Thinking...');
      
      try {
        const response = await fetch('/api/chat?token=' + new URLSearchParams(window.location.search).get('token'), {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            model: modelSelect.value,
            messages: [{ role: 'user', content: text }],
            temperature: 0.7
          })
        });
        
        const data = await response.json();
        
        // Remove typing indicator
        document.getElementById(typingId).remove();
        
        if (data.choices && data.choices[0]) {
          addMessage('assistant', data.choices[0].message.content);
        } else {
          addMessage('assistant', 'Error: ' + (data.error || 'Unknown error'));
        }
      } catch (error) {
        document.getElementById(typingId).remove();
        addMessage('assistant', 'Error: ' + error.message);
      }
    }
    
    function addMessage(role, text) {
      const id = 'msg-' + Date.now();
      const div = document.createElement('div');
      div.id = id;
      div.className = 'message ' + role;
      div.textContent = text;
      messagesDiv.appendChild(div);
      messagesDiv.scrollTop = messagesDiv.scrollHeight;
      return id;
    }
    
    // Allow Enter key to send
    input.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') sendMessage();
    });
  </script>
</body>
</html>
`;