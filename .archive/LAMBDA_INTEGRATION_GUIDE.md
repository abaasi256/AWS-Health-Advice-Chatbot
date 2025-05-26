# 🔧 Lambda Integration Deployment Guide

This guide will restore Lambda integration to the AWS Health Advice Chatbot, fixing the `FulfillmentCodeHook` errors.

## ⚡ Quick Fix Deployment

### Step 1: Deploy Infrastructure
```bash
cd infra
terraform init
terraform plan
terraform apply
```

### Step 2: Test the Integration
The deployment creates:
- ✅ Lambda function with health advice logic
- ✅ Lex bot with fulfillment code hooks enabled  
- ✅ Bot alias (`TestBotAlias`) with Lambda integration
- ✅ Proper IAM permissions

## 🎯 What This Fixes

**Before (Error):**
```
Cannot call FulfillmentCodeHook for Intent SleepAdvice. 
BotAlias/LocaleId TestBotAlias/en_US doesn't have an associated Lambda Function.
```

**After (Working):**
- All intents (`DietTips`, `SleepAdvice`, `ExerciseTips`, `MentalWellness`, `WaterInfo`) use Lambda fulfillment
- Dynamic responses with health disclaimers
- Proper bot alias with Lambda integration
- CloudWatch logging for debugging

## 🏗️ Architecture Changes

### Lambda Function
- **Name**: `health-advice-chatbot-handler`
- **Runtime**: Python 3.9
- **Handler**: `healthAdviceHandler.lambda_handler`
- **Timeout**: 30 seconds

### Intents Configuration
Each intent now includes:
```hcl
fulfillment_code_hook {
  enabled = true
}
```

### Bot Alias with Lambda
```hcl
bot_alias_locale_setting {
  locale_id = "en_US"
  enabled   = true
  
  code_hook_specification {
    lambda_code_hook {
      lambda_arn = aws_lambda_function.health_advice_handler.arn
      code_hook_interface_version = "1.0"
    }
  }
}
```

## 🧪 Testing

### AWS Console Testing
1. Go to Lex console: `https://us-east-1.console.aws.amazon.com/lexv2/`
2. Open your bot
3. Use **TestBotAlias** (not DRAFT version)
4. Test phrases:
   - "Give me sleep advice"
   - "What should I eat?"
   - "How much water should I drink?"

### Expected Response Format
```
Focus on whole foods like fruits, vegetables, lean proteins, and whole grains. Practice portion control and stay hydrated throughout the day.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance.
```

## 🔍 Troubleshooting

### Lambda Logs
Monitor CloudWatch logs:
```
/aws/lambda/health-advice-chatbot-handler
```

### Common Issues
1. **Permission denied**: Check IAM roles
2. **Function not found**: Verify Lambda ARN in bot alias
3. **Timeout**: Increase Lambda timeout (currently 30s)

## 📊 Deployment Output

After successful deployment, you'll see:
```
Outputs:
deployment_summary = {
  "architecture" = "lambda-fulfillment"
  "bot_alias_id" = "TSTALIASID"
  "bot_alias_name" = "TestBotAlias"
  "bot_id" = "4GAALIZS5K"
  "lambda_function" = "health-advice-chatbot-handler"
}
```

## 🎉 Success Criteria

✅ No more `FulfillmentCodeHook` errors  
✅ Dynamic responses from Lambda  
✅ Health disclaimers included  
✅ All 5 intents working  
✅ CloudWatch logs showing Lambda invocations  

The integration is now complete and ready for testing!
