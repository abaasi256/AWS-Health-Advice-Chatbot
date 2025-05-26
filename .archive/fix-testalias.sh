#!/bin/bash

# AWS Health Advice Chatbot - Fix TestBotAlias Lambda Integration
# This script provides the manual steps to fix the TestBotAlias issue

echo "🔧 AWS Health Advice Chatbot - TestBotAlias Fix"
echo "==============================================="

# Get values from Terraform state
BOT_ID="4GAALIZS5K"
LAMBDA_ARN="arn:aws:lambda:us-east-1:273354652032:function:health-advice-chatbot-handler"
REGION="us-east-1"

echo "📋 Current Status:"
echo "- Bot ID: $BOT_ID"
echo "- Lambda Function: $LAMBDA_ARN"
echo "- Region: $REGION"
echo ""

echo "❌ Problem:"
echo "TestBotAlias exists but doesn't have Lambda integration configured."
echo "Error: Cannot call FulfillmentCodeHook for Intent ExerciseTips."
echo ""

echo "✅ Solution Options:"
echo ""

echo "🚀 OPTION 1: Use DRAFT Version (Immediate Fix)"
echo "=============================================="
echo "1. Go to Lex Console: https://$REGION.console.aws.amazon.com/lexv2/home?region=$REGION#bot/$BOT_ID"
echo "2. Click 'Test' in the left sidebar"
echo "3. Make sure you're testing the DRAFT version (not TestBotAlias)"
echo "4. Try: 'Give me exercise tips'"
echo "5. You should get Lambda responses with health disclaimers"
echo ""

echo "🔧 OPTION 2: Fix TestBotAlias (Proper Fix)"
echo "=========================================="
echo "1. Go to Lex Console: https://$REGION.console.aws.amazon.com/lexv2/home?region=$REGION#bot/$BOT_ID"
echo "2. Click 'Deployment' in the left sidebar"
echo "3. Click on 'TestBotAlias'"
echo "4. Click 'Edit alias'"
echo "5. Under 'Lambda function', select: health-advice-chatbot-handler"
echo "6. Lambda ARN should be: $LAMBDA_ARN"
echo "7. Click 'Save alias'"
echo "8. Now test with TestBotAlias"
echo ""

echo "🧪 Testing Commands:"
echo "==================="
echo "Try these phrases after fixing:"
echo "- 'Give me exercise tips'"
echo "- 'How can I sleep better'"
echo "- 'What should I eat?'"
echo "- 'I need mental wellness advice'"
echo "- 'How much water should I drink?'"
echo ""

echo "📊 Expected Response Format:"
echo "============================"
echo "Include strength training exercises 2-3 times per week targeting all major muscle groups for optimal fitness."
echo ""
echo "⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance."
echo ""

echo "🔍 Troubleshooting:"
echo "=================="
echo "If still having issues:"
echo "- Check CloudWatch logs: https://$REGION.console.aws.amazon.com/cloudwatch/home?region=$REGION#logsV2:log-groups/log-group/\$252Faws\$252Flambda\$252Fhealth-advice-chatbot-handler"
echo "- Verify Lambda function is responding"
echo "- Ensure TestBotAlias is pointing to the correct Lambda ARN"
echo ""

echo "✅ The Lambda integration is working - just need to configure the alias properly!"
