#!/bin/bash

# AWS Health Advice Chatbot - Complete Deployment Script
# This script handles the full deployment including Terraform and bot alias creation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 AWS Health Advice Chatbot - Complete Deployment${NC}"
echo "====================================================="

# Step 1: Terraform deployment
echo -e "${YELLOW}🏗️  Step 1: Deploying infrastructure with Terraform...${NC}"
cd "$(dirname "$0")/infra"

# Initialize Terraform if needed
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Plan and apply
echo "Planning Terraform deployment..."
terraform plan

echo "Applying Terraform configuration..."
terraform apply -auto-approve

echo -e "${GREEN}✅ Terraform deployment complete${NC}"

# Step 2: Create bot alias
echo -e "${YELLOW}🤖 Step 2: Creating bot alias with Lambda integration...${NC}"
cd ..

# Make the script executable
chmod +x create_bot_alias.sh

# Run the bot alias creation
./create_bot_alias.sh

echo -e "${GREEN}🎉 Complete deployment finished!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Update your frontend .env with the bot alias ID"
echo "2. Test the bot in the AWS Lex console"
echo "3. Deploy your frontend application"
echo ""
echo -e "${YELLOW}💡 To redeploy infrastructure only:${NC} cd infra && terraform apply"
echo -e "${YELLOW}💡 To recreate bot alias only:${NC} ./create_bot_alias.sh"
