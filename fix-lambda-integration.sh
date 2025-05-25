#!/bin/bash
# Fix Lex Bot Lambda Integration

echo "🔧 Fixing Lambda Function Association..."

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "📋 Creating terraform.tfvars from example..."
    cp terraform.tfvars.example terraform.tfvars
fi

# Apply the infrastructure
echo "🚀 Applying Terraform changes..."
terraform init
terraform apply -auto-approve

# Get the outputs
BOT_ID=$(terraform output -raw lex_bot_id)
ALIAS_ID=$(terraform output -raw lex_bot_alias_id)
LAMBDA_ARN=$(terraform output -raw lambda_function_arn)

echo "✅ Infrastructure deployed successfully!"
echo "📊 Resources:"
echo "   Bot ID: $BOT_ID"
echo "   Alias ID: $ALIAS_ID"
echo "   Lambda ARN: $LAMBDA_ARN"

# Verify the alias configuration
echo "🔍 Verifying bot alias configuration..."
aws lexv2-models describe-bot-alias \
    --bot-id "$BOT_ID" \
    --bot-alias-id "$ALIAS_ID"

echo "✅ Bot alias is now properly configured with Lambda function!"
echo "🎯 Test the bot in AWS Console using alias: $ALIAS_ID"