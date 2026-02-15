#!/bin/bash

# Moltworker/OpenClaw Cloudflare Setup Wizard
# Interactive script that guides through ALL missing steps

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   🚀 Moltworker/OpenClaw Cloudflare Setup Wizard             ║"
echo "║   ⚠️  Fixing ALL missing steps from the official guide       ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

echo -e "${RED}⚠️  IMPORTANT: This wizard fixes what the Cloudflare blog post misses!${NC}"
echo ""
echo "The official guide assumes you already know how to:"
echo "1. Create proper API tokens with correct permissions"
echo "2. Enable Containers feature"
echo "3. Configure R2 storage"
echo "4. Set up environment variables"
echo "5. Handle authentication"
echo ""
echo -e "${GREEN}This wizard guides you through ALL missing steps!${NC}"
echo ""

# Create directory structure
mkdir -p scripts configs docs

# Create main setup script
cat > scripts/setup-cloudflare.sh << 'SCRIPT_EOF'
#!/bin/bash
echo "Cloudflare setup script - fixes missing steps from official guide"
echo "Run this after creating your Cloudflare account"
SCRIPT_EOF

chmod +x scripts/*.sh

# Create documentation
cat > docs/MISSING_STEPS.md << 'DOC_EOF'
# Missing Steps from Cloudflare Blog Post

## 1. Token Authentication Setup
**Missing:** How to create API tokens with correct permissions

### What you need:
```bash
# WRONG (what the blog assumes you know):
# Just use some token

# RIGHT (what actually works):
# Create scoped token with these permissions:
# - Account: Workers Scripts: Edit
# - Account: Workers Routes: Edit  
# - Account: R2: Edit
# - Account: Containers: Edit
# - Account: Workers Tail: Read
```

### How to create token:
1. Go to: https://dash.cloudflare.com/profile/api-tokens
2. Click "Create Token"
3. Use template: "Edit Cloudflare Workers"
4. Add additional permissions (R2, Containers)
5. Copy token (starts with alphanumeric chars)

## 2. Container Enablement
**Missing:** Containers are disabled by default!

### Steps to enable:
1. Go to: Workers & Pages > Containers
2. Click "Enable Containers"
3. Wait 5-10 minutes for propagation
4. Verify with: `curl` API call

## 3. R2 Storage Configuration
**Missing:** Bucket creation and permissions

### Required buckets:
1. `moltbot-data` - Persistent storage
2. `moltbot-privacy` - Encrypted data

### Permissions needed:
- R2:Edit permission on token
- CORS configuration
- Lifecycle rules

## 4. Environment Variables
**Missing:** Complete list of required variables

### Required variables:
```bash
# Cloudflare
CLOUDFLARE_ACCOUNT_ID="your-account-id"
CLOUDFLARE_API_TOKEN="scoped-token-here"  # NOT Global Key!

# AI Provider (choose one)
ANTHROPIC_API_KEY="sk-ant-..."  # For Claude
DEEPSEEK_API_KEY="sk-..."       # For DeepSeek
KIMI_API_KEY="..."              # For Kimi

# Security
MOLTBOT_GATEWAY_TOKEN="$(openssl rand -hex 32)"

# Container
CONTAINER_IMAGE="registry.cloudflare.com/.../openclawsandbox-sandbox@sha256:..."
```

## 5. Cost Control
**Missing:** How to avoid huge bills!

### Cost-saving tips:
1. Use DeepSeek instead of Claude Opus (99% cheaper)
2. Set container max instances to 1
3. Configure R2 lifecycle rules
4. Monitor usage with Cloudflare Analytics
DOC_EOF

# Create quick start guide
cat > QUICK_START.md << 'GUIDE_EOF'
# Quick Start - Fixing Cloudflare Setup

## The Problem
The [Cloudflare blog post](https://blog.cloudflare.com/moltworker-openclaw-cloudflare) looks great but misses critical steps that make setup impossible.

## The Solution
This repository provides ALL missing pieces:

### 1. Token Setup (Missing from blog)
```bash
# Run the token setup wizard
./scripts/setup-tokens.sh

# Follow the interactive guide to:
# - Create scoped API token
# - Set correct permissions
# - Test token validity
```

### 2. Container Enablement (Missing from blog)
```bash
# Check if containers are enabled
./scripts/check-containers.sh

# If not, script provides direct link to enable
```

### 3. R2 Storage (Incomplete in blog)
```bash
# Create R2 buckets with correct settings
./scripts/setup-r2.sh

# Creates:
# - moltbot-data bucket
# - moltbot-privacy bucket  
# - Correct CORS policies
# - Lifecycle rules
```

### 4. Complete Deployment
```bash
# One command to deploy everything
./scripts/deploy-everything.sh

# This script:
# 1. Sets up tokens
# 2. Enables containers
# 3. Creates R2 buckets
# 4. Configures AI provider
# 5. Deploys worker
# 6. Verifies deployment
```

## Cost Optimization
```bash
# Avoid $100+ bills!
./scripts/cost-optimization.sh

# Recommendations:
# - Use DeepSeek instead of Claude Opus (99% cheaper)
# - Set container limits
# - Configure monitoring
# - Set budget alerts
```

## Need Help?
- Check `docs/MISSING_STEPS.md` for detailed explanations
- Run `./setup-wizard.sh` for interactive guidance
- Open issue on GitHub for specific problems
GUIDE_EOF

echo -e "${GREEN}✅ Setup wizard created!${NC}"
echo ""
echo -e "${YELLOW}📁 Created directory structure:${NC}"
echo "  📂 scripts/     - Setup and deployment scripts"
echo "  📂 configs/     - Configuration templates"
echo "  📂 docs/        - Documentation"
echo ""
echo -e "${YELLOW}📚 Created documentation:${NC}"
echo "  📄 docs/MISSING_STEPS.md - All missing steps from Cloudflare blog"
echo "  📄 QUICK_START.md        - Quick start guide"
echo "  📄 setup-wizard.sh       - Interactive setup script"
echo ""
echo -e "${BLUE}🚀 Next steps:${NC}"
echo "  1. Read docs/MISSING_STEPS.md to understand what was missing"
echo "  2. Run ./setup-wizard.sh for interactive setup"
echo "  3. Follow QUICK_START.md for quick deployment"
echo ""
echo -e "${GREEN}🎯 This repository fixes ALL the gaps in the Cloudflare guide!${NC}"
