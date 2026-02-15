#!/bin/bash

echo "🚀 Deploying Simple Kimi AI Worker..."

# Generate gateway token
MOLTBOT_GATEWAY_TOKEN=$(openssl rand -base64 32 | tr -d '=+/' | head -c 32)
echo "📝 Your Gateway Token: $MOLTBOT_GATEWAY_TOKEN"
echo "💾 SAVE THIS TOKEN! You'll need it to access your agent."

# Read Kimi API key
if [ ! -f ~/.env.kimi ]; then
    echo "❌ Error: ~/.env.kimi not found!"
    echo "Please create ~/.env.kimi with: KIMI_API_KEY=your-key"
    exit 1
fi

source ~/.env.kimi

if [ -z "$KIMI_API_KEY" ]; then
    echo "❌ Error: KIMI_API_KEY not found in ~/.env.kimi"
    exit 1
fi

echo "✅ Using Kimi API key from ~/.env.kimi"

# Create wrangler.toml
cat > wrangler.toml << EOF
name = "simple-kimi-ai"
main = "simple-kimi-worker.js"
compatibility_date = "2025-05-06"

[env.production]
vars = { MOLTBOT_GATEWAY_TOKEN = "$MOLTBOT_GATEWAY_TOKEN" }
EOF

# Deploy
echo "☁️  Deploying..."
npx wrangler deploy

# Set Kimi API key as secret
echo "🔑 Setting Kimi API key as secret..."
echo "$KIMI_API_KEY" | npx wrangler secret put KIMI_API_KEY

# Redeploy with secret
echo "🔄 Redeploying with secret..."
npx wrangler deploy

echo ""
echo "🎉 Simple Kimi AI Worker deployed!"
echo "🔗 Access your agent at: https://simple-kimi-ai.yksanjo.workers.dev/?token=$MOLTBOT_GATEWAY_TOKEN"
echo ""
echo "💰 Cost Savings:"
echo "   - Kimi: ~$0.60 per million tokens"
echo "   - Claude Sonnet: ~$3.00 per million tokens (5x more expensive!)"
echo "   - Claude Opus: ~$15.00 per million tokens (25x more expensive!)"
echo ""
echo "✨ Features:"
echo "   - Simple web interface"
echo "   - Direct Kimi API access"
echo "   - No containers, no complex setup"
echo "   - Multiple model options (8K, 32K, 128K context)"
echo ""
echo "📱 Usage:"
echo "   1. Bookmark the URL above"
echo "   2. Type your message and press Enter"
echo "   3. Choose different models from the dropdown"
echo ""
echo "🔧 Tech Stack:"
echo "   - Cloudflare Workers (serverless)"
echo "   - Kimi/Moonshot AI API"
echo "   - Simple HTML/JS frontend"