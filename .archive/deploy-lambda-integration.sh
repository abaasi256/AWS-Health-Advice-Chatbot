#!/bin/bash

# AWS Health Advice Chatbot - Lambda Integration Deployment Script
# This script deploys the complete Lambda integration for the Lex chatbot

set -e  # Exit on any error

echo "🚀 AWS Health Advice Chatbot - Lambda Integration Deployment"
echo "============================================================="

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check if AWS CLI is installed and configured
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install it first."
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Navigate to infrastructure directory
cd infra

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creating terraform.tfvars from example..."
    if [ -f "terraform.tfvars.example" ]; then
        cp terraform.tfvars.example terraform.tfvars
        echo "⚠️  Please edit terraform.tfvars with your desired configuration"
        echo "   Current defaults should work for most cases"
    else
        echo "📝 Creating default terraform.tfvars..."
        cat > terraform.tfvars << EOF
aws_region   = "us-east-1"
environment  = "dev"
project_name = "health-advice-chatbot"
bot_name     = "HealthAdviceBot"
locale_id    = "en_US"
EOF
    fi
fi

echo "🔧 Initializing Terraform..."
terraform init

echo "📋 Validating Terraform configuration..."
terraform validate

echo "📊 Planning Terraform deployment..."
terraform plan

echo ""
echo "🚀 Ready to deploy Lambda integration!"
echo ""
read -p "Do you want to proceed with deployment? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Deploying infrastructure..."
    terraform apply -auto-approve
    
    echo ""
    echo "✅ Deployment completed successfully!"
    echo ""
    
    # Get output values
    BOT_ID=$(terraform output -raw lex_bot_id)
    ALIAS_ID=$(terraform output -raw lex_bot_alias_id)
    LAMBDA_NAME=$(terraform output -raw lambda_function_name)
    REGION=$(terraform output -raw aws_region)
    
    echo "📋 Deployment Summary:"
    echo "======================"
    echo "🤖 Bot ID: $BOT_ID"
    echo "🏷️  Alias ID: $ALIAS_ID"
    echo "⚡ Lambda Function: $LAMBDA_NAME"
    echo "🌍 Region: $REGION"
    echo ""
    
    echo "🧪 Testing Lambda function..."
    cd ..
    
    # Test Lambda function locally first
    echo "🔧 Testing Lambda handler locally..."
    python3 lambda/healthAdviceHandler.py
    
    echo ""
    echo "🎯 Next Steps:"
    echo "=============="
    echo "1. Test the bot in AWS Console:"
    echo "   https://$REGION.console.aws.amazon.com/lexv2/home?region=$REGION#bot/$BOT_ID"
    echo ""
    echo "2. Use the TestBotAlias for testing with Lambda fulfillment"
    echo ""
    echo "3. Monitor Lambda logs:"
    echo "   https://$REGION.console.aws.amazon.com/cloudwatch/home?region=$REGION#logsV2:log-groups/log-group/\$252Faws\$252Flambda\$252F$LAMBDA_NAME"
    echo ""
    echo "4. Update frontend configuration:"
    echo "   Copy these values to frontend/.env:"
    echo ""
    terraform output frontend_config
    echo ""
    echo "🎉 Lambda integration deployment completed!"
    
else
    echo "❌ Deployment cancelled"
    exit 1
fi
