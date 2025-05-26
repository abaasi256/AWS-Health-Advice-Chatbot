#!/bin/bash

# AWS CLI script to fix TestBotAlias Lambda integration
echo "🔧 Fixing TestBotAlias Lambda Integration"
echo "========================================"

BOT_ID="4GAALIZS5K"
LAMBDA_ARN="arn:aws:lambda:us-east-1:273354652032:function:health-advice-chatbot-handler"
REGION="us-east-1"

echo "📋 Configuration:"
echo "Bot ID: $BOT_ID"
echo "Lambda ARN: $LAMBDA_ARN"
echo "Region: $REGION"
echo ""

echo "🔍 Step 1: Finding TestBotAlias..."
# Get all aliases and find TestBotAlias
ALIASES=$(aws lexv2-models list-bot-aliases --bot-id $BOT_ID --region $REGION 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "❌ Error: Could not list bot aliases. Check your AWS credentials and permissions."
    exit 1
fi

# Extract TestBotAlias ID
ALIAS_ID=$(echo "$ALIASES" | jq -r '.botAliasSummaries[] | select(.botAliasName=="TestBotAlias") | .botAliasId')

if [ -z "$ALIAS_ID" ] || [ "$ALIAS_ID" = "null" ]; then
    echo "❌ TestBotAlias not found. Available aliases:"
    echo "$ALIASES" | jq -r '.botAliasSummaries[] | "\(.botAliasName) (ID: \(.botAliasId))"'
    echo ""
    echo "💡 You can create TestBotAlias with:"
    echo "aws lexv2-models create-bot-alias --bot-id $BOT_ID --bot-alias-name TestBotAlias --bot-version DRAFT --region $REGION"
    exit 1
fi

echo "✅ Found TestBotAlias: $ALIAS_ID"
echo ""

echo "🔍 Step 2: Checking current alias configuration..."
CURRENT_CONFIG=$(aws lexv2-models describe-bot-alias --bot-id $BOT_ID --bot-alias-id $ALIAS_ID --region $REGION 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "❌ Error: Could not describe bot alias."
    exit 1
fi

echo "Current alias version:" $(echo "$CURRENT_CONFIG" | jq -r '.botVersion // "unknown"')
echo ""

echo "🔧 Step 3: Updating TestBotAlias with Lambda integration..."

# Update the alias with Lambda configuration
UPDATE_RESULT=$(aws lexv2-models update-bot-alias \
  --bot-id $BOT_ID \
  --bot-alias-id $ALIAS_ID \
  --bot-alias-name "TestBotAlias" \
  --bot-version "DRAFT" \
  --bot-alias-locale-settings '{
    "en_US": {
      "enabled": true,
      "codeHookSpecification": {
        "lambdaCodeHook": {
          "lambdaArn": "'$LAMBDA_ARN'",
          "codeHookInterfaceVersion": "1.0"
        }
      }
    }
  }' \
  --region $REGION 2>&1)

if [ $? -eq 0 ]; then
    echo "✅ Successfully updated TestBotAlias with Lambda integration!"
    echo ""
    echo "🧪 Testing:"
    echo "1. Go to Lex Console and test with TestBotAlias"
    echo "2. Try: 'Give me exercise tips'"
    echo "3. You should now get Lambda responses!"
    echo ""
    echo "🎉 TestBotAlias is now configured with Lambda integration!"
else
    echo "❌ Error updating alias:"
    echo "$UPDATE_RESULT"
    echo ""
    echo "💡 Common fixes:"
    echo "1. Ensure Lambda function exists and has correct permissions"
    echo "2. Check if alias is in 'Available' status (not 'Building')"
    echo "3. Wait a few minutes and try again"
fi
