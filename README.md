# 🤖 Simple Kimi AI on Cloudflare Workers

**Deploy your personal AI assistant in 2 minutes using affordable Kimi (Moonshot AI) API**

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/yksanjo/moltworker-simplified)

## 🚀 Quick Start

### Option 1: One-Click Deploy (Recommended)
Click the "Deploy to Cloudflare" button above, then:

1. **Get a Kimi API key** from [platform.moonshot.cn](https://platform.moonshot.cn)
2. **Set your API key** in Cloudflare dashboard: Workers → Your Worker → Settings → Variables → `KIMI_API_KEY`
3. **Access your AI** at the provided URL with your gateway token

### Option 2: Manual Deployment

```bash
# Clone the repository
git clone https://github.com/yksanjo/moltworker-simplified.git
cd moltworker-simplified

# Run the deployment script
./deploy-simple-kimi.sh

# Follow the prompts
# Save the gateway token that appears!
```

## 💰 Cost Comparison

| Provider | Cost/million tokens | Quality | Best For | Savings vs Opus |
|----------|-------------------|---------|----------|-----------------|
| **Kimi (Moonshot)** | $0.60 | ⭐⭐⭐⭐ | Chinese/English | **96% cheaper** |
| **Claude Haiku** | $0.25 | ⭐⭐⭐ | Fast responses | **98% cheaper** |
| **Claude Sonnet** | $3.00 | ⭐⭐⭐⭐ | Complex reasoning | **80% cheaper** |
| **Claude Opus** | $15.00 | ⭐⭐⭐⭐⭐ | Most complex tasks | Baseline |

**Example Monthly Savings:**
- **With Opus**: ~$150 for 10M tokens
- **With Kimi**: ~$6.00 for 10M tokens
- **Savings**: **$144.00/month** (96% reduction)

## ✨ Features

### 🤖 AI Models
- **Kimi 8K** - Fast and affordable (8,192 token context)
- **Kimi 32K** - Balanced capability (32,768 token context) 
- **Kimi 128K** - Large context support (128,000 token context)

### 🎯 Key Benefits
- **💰 Affordable** - $0.60 per million tokens vs $15.00 for Claude Opus
- **🌐 No Servers** - Runs on Cloudflare's edge network
- **⚡ Fast Setup** - Deploy in 2 minutes
- **🔒 Secure** - Token-based authentication
- **📱 Web Interface** - Built-in chat UI
- **🔧 Simple Code** - Easy to understand and modify

## 🛠️ Technical Details

### Architecture
```
User Browser → Cloudflare Worker → Kimi API → Response
```

### File Structure
```
moltworker-simplified/
├── simple-kimi-worker.js    # Main Worker code
├── deploy-simple-kimi.sh    # Deployment script
├── wrangler.toml           # Cloudflare configuration
└── README.md              # This file
```

### Worker Code
The worker is a single JavaScript file that:
1. Validates gateway tokens
2. Serves a web interface
3. Proxies requests to Kimi API
4. Handles errors gracefully

## 🔧 Customization

### Change Models
Edit `simple-kimi-worker.js` and update the models array:

```javascript
models: [
  { id: 'moonshot-v1-8k', name: 'Kimi 8K', context: 8192 },
  { id: 'moonshot-v1-32k', name: 'Kimi 32K', context: 32768 },
  { id: 'moonshot-v1-128k', name: 'Kimi 128K', context: 128000 }
]
```

### Modify UI
Edit the `htmlInterface` string in `simple-kimi-worker.js` to change:
- Colors and styling
- Layout and design
- Additional features

### Add New Endpoints
Extend the fetch handler:

```javascript
if (url.pathname === '/api/custom') {
  // Your custom endpoint logic
}
```

## 📊 Usage Examples

### Web Interface
1. Visit `https://your-worker.workers.dev/?token=YOUR_TOKEN`
2. Select a model from dropdown
3. Type your message and press Enter
4. Get AI responses instantly

### API Usage
```bash
# List available models
curl "https://your-worker.workers.dev/api/models?token=YOUR_TOKEN"

# Chat with Kimi
curl -X POST "https://your-worker.workers.dev/api/chat?token=YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "moonshot-v1-8k",
    "messages": [
      {"role": "user", "content": "Hello, how are you?"}
    ]
  }'
```

## 🔒 Security

### Authentication
- **Gateway Token** required for all access
- Tokens are validated on every request
- No token = No access

### Data Protection
- No data storage (stateless)
- HTTPS only
- API keys stored as Cloudflare secrets

### Best Practices
1. **Rotate tokens** periodically
2. **Use different tokens** for different users
3. **Monitor usage** via Cloudflare dashboard
4. **Set budget alerts** for API usage

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **"Unauthorized" error** | Check token in URL: `?token=YOUR_TOKEN` |
| **API not responding** | Verify Kimi API key is set as secret |
| **Worker won't deploy** | Check wrangler.toml syntax |
| **High latency** | First request has cold start (~100ms) |

### Debugging
```bash
# Check worker logs
npx wrangler tail

# Test endpoint
curl -v "https://your-worker.workers.dev/?token=YOUR_TOKEN"

# Update deployment
npx wrangler deploy
```

## 🔄 Updating

### Update Code
```bash
# Edit simple-kimi-worker.js
# Then redeploy
npx wrangler deploy
```

### Update Token
```bash
# Generate new token
NEW_TOKEN=$(openssl rand -base64 32 | tr -d '=+/' | head -c 32)

# Update wrangler.toml
sed -i '' "s/MOLTBOT_GATEWAY_TOKEN = \".*\"/MOLTBOT_GATEWAY_TOKEN = \"$NEW_TOKEN\"/" wrangler.toml

# Redeploy
npx wrangler deploy
```

## 🌟 Advanced Features

### Add Streaming
```javascript
// In handleChatRequest
const response = await fetch('https://api.moonshot.cn/v1/chat/completions', {
  method: 'POST',
  headers: { /* ... */ },
  body: JSON.stringify({
    // ... other options ...
    stream: true  // Enable streaming
  })
});

// Handle streaming response
```

### Add Rate Limiting
```javascript
// Use Cloudflare's rate limiting
const ip = request.headers.get('CF-Connecting-IP');
// Implement your rate limiting logic
```

### Add Caching
```javascript
// Cache responses
const cacheKey = `kimi:${JSON.stringify(body)}`;
const cached = await env.YOUR_KV.get(cacheKey);
if (cached) return new Response(cached);
```

## 📚 Resources

- [Kimi/Moonshot API Docs](https://platform.moonshot.cn/docs)
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI Docs](https://developers.cloudflare.com/workers/wrangler/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📜 License

MIT License - see [LICENSE](LICENSE) file.

## 🙏 Acknowledgments

- [Moonshot AI](https://www.moonshot.cn/) for the Kimi API
- [Cloudflare](https://cloudflare.com) for Workers platform
- All contributors and users

---

**⭐ Star this repo if you find it helpful! ⭐**

Made with ❤️ by [@yksanjo](https://github.com/yksanjo)

**Need help?** Open an issue or reach out on [Twitter/X](https://twitter.com/yksanjo)