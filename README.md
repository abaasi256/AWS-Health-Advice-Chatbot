# 🏥 AWS Health Advice Chatbot

> **Production-ready serverless health advice application powered by AWS Lex v2 with Lambda fulfillment and full voice support**

[![AWS](https://img.shields.io/badge/AWS-FF9900?style=flat-square&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://terraform.io/)
[![React](https://img.shields.io/badge/React%2018-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://reactjs.org/)
[![Lambda](https://img.shields.io/badge/AWS%20Lambda-FF9900?style=flat-square&logo=aws-lambda&logoColor=white)](https://aws.amazon.com/lambda/)
[![Voice](https://img.shields.io/badge/Voice%20Enabled-4CAF50?style=flat-square&logo=google-assistant&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

## 📋 **Overview**

The AWS Health Advice Chatbot is a comprehensive **portfolio project** that demonstrates advanced cloud engineering and modern frontend development skills. Built with AWS Lex v2 for natural language understanding, **Lambda fulfillment for dynamic responses**, and complete voice integration for an immersive user experience.

### **🎯 Key Features**

- **⚡ Lambda Fulfillment** - Dynamic health advice generation with personalized responses
- **🎤 Full Voice Support** - Complete speech-to-text and text-to-speech capabilities
- **🤖 Intelligent Conversations** - Natural language processing with AWS Lex v2
- **🏗️ Infrastructure as Code** - Complete Terraform automation
- **🔒 Enterprise Security** - IAM least-privilege and proper Lambda permissions
- **📱 Modern Frontend** - Responsive React application with voice controls
- **💰 Cost Optimized** - Efficient Lambda execution with minimal AWS resource usage

---

## 🎤 **Voice Features**

### **✅ Complete Voice Experience**
- **🔊 Text-to-Speech** - All bot responses spoken aloud with auto-play
- **🎤 Speech-to-Text** - Speak your health questions directly
- **🔇 Voice Controls** - Toggle voice on/off, individual message replay
- **👂 Smart Listening** - Visual feedback during voice input
- **📱 Mobile Voice** - Full voice support on mobile browsers
- **♿ Accessible** - Screen reader compatible with ARIA labels

### **🎯 Voice Interaction Demo**
```
👤 User: [Clicks microphone] "How much water should I drink?"
🎤 App: [Converts speech to text in input field]
👤 User: [Presses Enter to send]
🤖 Bot: [Lambda generates dynamic health advice]
🔊 App: [Automatically speaks response aloud]
```

### **🌍 Browser Voice Support**
| Browser | Speech Recognition | Text-to-Speech | Overall |
|---------|-------------------|----------------|---------|
| **Chrome** | ✅ Excellent | ✅ Excellent | ⭐⭐⭐⭐⭐ |
| **Safari** | ✅ Good | ✅ Good | ⭐⭐⭐⭐ |
| **Edge** | ✅ Good | ✅ Good | ⭐⭐⭐⭐ |
| **Firefox** | ❌ Limited | ✅ Basic | ⭐⭐ |

---

### **📊 Architecture Flow**
![AWS Health Advice Chatbot Architecture](Screenshots/aws-architecture-diagram.png)
*AWS architecture diagram showing the complete serverless flow from React frontend through Lex v2, Lambda fulfillment, and infrastructure components.*

---

## 🚀 **Quick Start**

### **Prerequisites**

```bash
# Required tools
aws --version        # AWS CLI v2+
terraform --version  # Terraform v1.0+
node --version       # Node.js v16+
```

### **1. Deploy Infrastructure with Lambda**

```bash
# Clone repository
git clone <repository-url>
cd aws-health-advice-chatbot

# Deploy AWS infrastructure with Lambda fulfillment
cd infra
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your preferences

terraform init
terraform plan
terraform apply
```

### **2. Setup Frontend with Voice**

```bash
cd ../frontend
cp .env.example .env
# Update .env with Terraform output values

npm install
npm start
# Opens http://localhost:3000
```

### **3. Test Lambda Integration**

1. **Test in AWS Console**: Use TestBotAlias in Lex Console
2. **Test Frontend**: Open http://localhost:3000
3. **Try Voice Features**: Click microphone and speaker buttons
4. **Monitor Lambda**: Check CloudWatch logs for function execution

---

## 💬 **Health Topics & Lambda Responses**

The chatbot provides **dynamic, AI-generated** health advice through Lambda fulfillment:

| Topic | Voice Commands | Lambda Response Features |
|-------|---------------|-------------------------|
| **🥗 Diet Tips** | *"Give me healthy diet tips"* | Random selection from nutrition database + health disclaimer |
| **💧 Hydration** | *"How much water should I drink?"* | Personalized hydration advice with intake calculations |
| **🏃‍♀️ Exercise** | *"What exercises should I do?"* | Dynamic workout recommendations with intensity levels |
| **🧘‍♀️ Mental Wellness** | *"Give me mental wellness tips"* | Randomized mindfulness and stress management advice |
| **😴 Sleep** | *"How can I sleep better?"* | Sleep hygiene tips with personalized recommendations |

### **Sample Lambda-Generated Response**

```
👤 User: "I need mental wellness advice"

🤖 Lambda Response:
"Maintain strong social connections with family and friends. Keep a gratitude journal to focus on positive aspects of life.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance."
```

---

## 🔧 **Lambda Integration Details**

### **Lambda Function Architecture**
- **Function Name**: `health-advice-chatbot-handler`
- **Runtime**: Python 3.9
- **Handler**: `healthAdviceHandler.lambda_handler`
- **Timeout**: 30 seconds
- **Memory**: 128 MB

### **Health Advice Database**
```python
HEALTH_ADVICE = {
    'DietTips': [
        "Focus on whole foods like fruits, vegetables, lean proteins...",
        "Include healthy fats from sources like avocados, nuts...",
        "Eat the rainbow - different colored fruits and vegetables..."
    ],
    'ExerciseTips': [...],
    'MentalWellness': [...],
    'SleepAdvice': [...],
    'WaterInfo': [...]
}
```

### **Dynamic Response Generation**
- **Random Selection**: Varies advice on each interaction
- **Health Disclaimers**: Automatically appended to all responses
- **Error Handling**: Graceful fallbacks for unknown intents
- **Logging**: CloudWatch integration for monitoring

---

## 🎯 **Proof of Working Implementation**

### **🏗️ Architecture Evidence**
![AWS Architecture Diagram](Screenshots/aws-architecture-diagram.png)
*Professional AWS architecture diagram using official AWS icons, showing the complete serverless infrastructure.*

### **📸 Screenshot Evidence**

#### **1. AWS Lex Console - TestBotAlias Working**
![Lex Console](Screenshots/lex-console.png)
*Lambda integration successfully configured with TestBotAlias. Shows dynamic mental wellness advice generated by Lambda function.*

#### **2. Frontend Voice-Enabled Chat**
![Frontend Chat](Screenshots/Frontend-chat-bot.png)
*Complete voice-enabled frontend with working text-to-speech, speech recognition, and Lambda-generated responses with health disclaimers.*

### **✅ Verification Checklist**
- ✅ **Lambda Function**: `health-advice-chatbot-handler` deployed and working
- ✅ **Lex Integration**: TestBotAlias configured with Lambda fulfillment
- ✅ **Dynamic Responses**: Variable health advice generated per interaction
- ✅ **Voice Features**: Full speech-to-text and text-to-speech functionality
- ✅ **Frontend Integration**: React app successfully connects to Lex
- ✅ **Health Disclaimers**: Automatically included in all Lambda responses
- ✅ **Error Handling**: Graceful fallbacks and user-friendly error messages
- ✅ **Architecture Documentation**: Professional AWS diagram with official icons

---

## 🛠️ **Technology Stack**

### **Backend & Infrastructure**
- **Amazon Lex v2** - Natural language understanding with intent recognition
- **AWS Lambda** - Serverless compute for dynamic response generation
- **Python 3.9** - Lambda runtime with health advice logic
- **Terraform** - Infrastructure as Code with Lambda deployment
- **CloudWatch** - Logging and monitoring for Lambda functions
- **IAM** - Fine-grained access control and Lambda permissions

### **Frontend & Voice**
- **React 18** - Modern functional components with hooks
- **Web Speech API** - Browser-native speech recognition and synthesis
- **AWS SDK v3** - Modular cloud service integration for Lex
- **Styled Components** - CSS-in-JS with dynamic theming

### **Lambda Integration**
- **Lex v2 Events** - Proper event handling and response formatting
- **Dynamic Content** - Randomized health advice selection
- **Error Handling** - Robust exception management
- **Health Compliance** - Medical disclaimers and educational focus

---

## 📁 **Project Structure**

```
aws-health-advice-chatbot/
├── 📂 infra/                     # Terraform Infrastructure ⭐
│   ├── main.tf                   # Lambda + Lex integration (WORKING)
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Infrastructure outputs
│   ├── terraform.tfvars.example   # Configuration template
│   └── lambda_function.zip        # Auto-generated Lambda package
├── 📂 lambda/                     # Lambda Function ⭐
│   ├── healthAdviceHandler.py     # Main Lambda handler (WORKING)
│   └── requirements.txt           # Python dependencies
├── 📂 frontend/                   # Voice-Enhanced React App ⭐
│   ├── src/
│   │   ├── components/            # UI components with voice
│   │   │   └── ChatInterface.js   # Main chat with voice features
│   │   ├── services/              # AWS & Voice services
│   │   │   ├── lexService.js      # AWS Lex integration
│   │   │   └── voiceService.js    # Voice capabilities (FIXED)
│   │   ├── config.js              # Voice configuration
│   │   └── App.js                 # Main application
│   ├── __tests__/                 # Voice feature tests
│   ├── package.json               # Dependencies with voice libs
│   └── README.md                  # Frontend voice guide
├── 📂 Screenshots/                # Working Bot Evidence ⭐
│   ├── aws-architecture-diagram.png          # Official AWS architecture diagram
│   ├── Screenshot 2025-05-26 at 9.39.04 PM.png  # Lex Console
│   └── Screenshot 2025-05-26 at 9.44.24 PM.png  # Frontend
└── 📄 README.md                   # This documentation
```

---

## ⚙️ **Configuration**

### **Infrastructure (infra/terraform.tfvars)**

```hcl
# Core Configuration
aws_region   = "us-east-1"
environment  = "dev"
project_name = "health-advice-chatbot"  
bot_name     = "HealthAdviceBot"
locale_id    = "en_US"
```

### **Voice Frontend (frontend/.env)**

```bash
# AWS Lex Configuration (from Terraform outputs)
REACT_APP_AWS_REGION=us-east-1
REACT_APP_LEX_BOT_ID=your_bot_id_here
REACT_APP_LEX_LOCALE_ID=en_US

# Voice Configuration
REACT_APP_VOICE_ENABLED=true
REACT_APP_VOICE_AUTO_PLAY=true
REACT_APP_VOICE_SPEECH_RATE=1.0
REACT_APP_VOICE_SPEECH_PITCH=1.0
REACT_APP_VOICE_SPEECH_VOLUME=1.0
REACT_APP_VOICE_LANGUAGE=en-US
```

---

## 🧪 **Testing**

### **Lambda Function Testing**

```bash
# Test Lambda locally
cd lambda
python3 healthAdviceHandler.py

# Expected output: JSON response with health advice
```

### **Voice Feature Testing**

```bash
# Frontend Testing
cd frontend
npm test                    # Run all tests including voice
npm start                   # Test voice features manually
```

### **Integration Testing Checklist**
```bash
✅ Lambda function responds to Lex events
✅ Voice toggle on/off works
✅ Auto-play speaks bot responses  
✅ Microphone captures speech correctly
✅ Speech-to-text accuracy
✅ Speaker icons appear on bot messages
✅ Individual message playback works
✅ TestBotAlias uses Lambda fulfillment
✅ Dynamic responses vary between interactions
✅ Health disclaimers included in all responses
✅ CloudWatch logs show Lambda execution
```

### **Infrastructure Validation**

```bash
cd infra
terraform validate
terraform plan
terraform fmt
```

---

## 💰 **Cost Analysis**

### **Estimated Monthly Costs (Lambda + Voice Architecture)**

| Usage Level | Lambda | Lex v2 | CloudWatch | Voice APIs | Total |
|-------------|--------|--------|------------|------------|-------|
| **Development** | $0.20 | $1-2 | $0.50 | Free* | **~$2.70** |
| **Light Production** | $0.60 | $3-5 | $1 | Free* | **~$6.60** |
| **Medium Production** | $2.00 | $8-12 | $2 | Free* | **~$14** |

*Voice APIs are browser-native and free

### **Lambda Cost Breakdown**
- **Requests**: $0.20 per 1M requests
- **Duration**: $0.0000166667 per GB-second
- **Memory**: 128 MB (cost-optimized)
- **Execution Time**: ~100ms average

### **Cost Benefits of Lambda Architecture**
- **Dynamic Responses**: More engaging user experience
- **Scalable**: Automatic scaling with usage
- **Educational Disclaimers**: Proper health guidance compliance
- **Monitoring**: Built-in CloudWatch logging
- **Maintainable**: Easy to update health advice content

---

## 🔒 **Security**

### **Security Implementation**
- **IAM Least Privilege** - Separate roles for Lambda and Lex
- **Lambda Permissions** - Specific ARN-based invocation permissions
- **No Data Storage** - Stateless conversations, no PII retention  
- **Voice Privacy** - All voice processing happens locally in browser
- **Health Compliance** - Educational disclaimers on all medical advice
- **Encryption** - TLS 1.2+ for all data in transit
- **Monitoring** - CloudWatch logging for Lambda execution and errors

### **Lambda Security**
- **Execution Role** - Minimal CloudWatch Logs permissions only
- **Source ARN** - Restricted to specific Lex bot and alias
- **Environment Variables** - Non-sensitive configuration only
- **Error Handling** - No sensitive information in error messages

---

## 📈 **Monitoring & Observability**

### **Application Metrics**
- Lambda function duration and memory usage
- Lex conversation success rates
- Intent recognition accuracy  
- User interaction patterns
- Voice feature usage analytics

### **Lambda Monitoring**
- **CloudWatch Logs**: `/aws/lambda/health-advice-chatbot-handler`
- **Metrics**: Invocations, Duration, Errors, Throttles
- **Alarms**: Error rate and duration thresholds
- **X-Ray**: Optional distributed tracing

### **Voice Analytics**
- Speech recognition success rates
- Text-to-speech usage patterns
- Voice vs text input preferences
- Browser compatibility statistics

---

## 🎯 **Professional Portfolio Value**

### **Skills Demonstrated**
- ✅ **AWS Cloud Architecture** - Lex v2, Lambda, IAM, CloudWatch
- ✅ **Serverless Development** - Python Lambda functions with proper error handling
- ✅ **Infrastructure as Code** - Advanced Terraform patterns with Lambda deployment
- ✅ **Modern Frontend Development** - React 18, hooks, state management
- ✅ **Voice Technology Integration** - Web Speech API, audio processing
- ✅ **User Experience Design** - Accessibility, mobile-first, voice UX
- ✅ **Performance Optimization** - Cost-effective Lambda architecture
- ✅ **DevOps Practices** - Automated deployment, testing, monitoring
- ✅ **Problem Solving** - Complex integration challenges and solutions
- ✅ **Documentation Excellence** - Professional diagrams and comprehensive guides

### **Innovation Highlights**
- **Lambda-Powered Health Assistant** - Dynamic, educational health advice
- **Voice-First Architecture** - Complete speech integration with minimal cloud costs
- **Progressive Enhancement** - Works perfectly with and without voice
- **Accessibility Excellence** - Voice navigation for diverse user needs
- **Healthcare Compliance** - Proper medical disclaimers and educational focus

---

## 🔧 **Troubleshooting Lambda Integration**

### **🚨 Common Lambda Permission Issues**

#### **Issue 1: "Access denied while invoking lambda function" Error**

**Error Message:**
```
Invalid Bot Configuration: Access denied while invoking lambda function 
arn:aws:lambda:us-east-1:ACCOUNT:function:health-advice-chatbot-handler 
from arn:aws:lex:us-east-1:ACCOUNT:bot-alias/BOTID/ALIASID. 
Please check the policy on this function.
```

**Root Cause:** Lambda function lacks permission for Lex bot alias to invoke it.

**✅ Solution:**

1. **Add Bot Alias Lambda Permission:**
```bash
# Get your bot ID and Lambda function name from Terraform outputs
BOT_ID=$(cd infra && terraform output -raw lex_bot_id)
LAMBDA_FUNCTION=$(cd infra && terraform output -raw lambda_function_name)
AWS_REGION=$(cd infra && terraform output -raw aws_region)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Add permission for bot alias to invoke Lambda
aws lambda add-permission \
  --function-name $LAMBDA_FUNCTION \
  --statement-id "AllowLexBotAlias" \
  --action "lambda:InvokeFunction" \
  --principal "lexv2.amazonaws.com" \
  --source-arn "arn:aws:lex:$AWS_REGION:$ACCOUNT_ID:bot-alias/$BOT_ID/*" \
  --region $AWS_REGION
```

2. **Verify Permission:**
```bash
aws lambda get-policy --function-name $LAMBDA_FUNCTION --region $AWS_REGION
```

---

#### **Issue 2: "Cannot call FulfillmentCodeHook" Error**

**Error Message:**
```
Cannot call FulfillmentCodeHook for Intent ExerciseTips. 
BotAlias/LocaleId TestBotAlias/en_US doesn't have an associated Lambda Function.
```

**Root Cause:** Bot alias not properly configured with Lambda function association.

**✅ Solution - Create Bot Alias with Lambda Integration:**

1. **Build Bot Locale:**
```bash
BOT_ID=$(cd infra && terraform output -raw lex_bot_id)
LOCALE_ID=$(cd infra && terraform output -raw lex_bot_locale_id)
AWS_REGION=$(cd infra && terraform output -raw aws_region)

# Build the bot locale
aws lexv2-models build-bot-locale \
  --bot-id $BOT_ID \
  --bot-version "DRAFT" \
  --locale-id $LOCALE_ID \
  --region $AWS_REGION

# Wait for build to complete (check status)
aws lexv2-models describe-bot-locale \
  --bot-id $BOT_ID \
  --bot-version "DRAFT" \
  --locale-id $LOCALE_ID \
  --region $AWS_REGION \
  --query 'botLocaleStatus'
```

2. **Create Bot Version:**
```bash
# Create bot version after locale is built
VERSION_RESPONSE=$(aws lexv2-models create-bot-version \
  --bot-id $BOT_ID \
  --description "Production version with Lambda" \
  --bot-version-locale-specification "$LOCALE_ID={sourceBotVersion=DRAFT}" \
  --region $AWS_REGION \
  --output json)

# Extract version number
BOT_VERSION=$(echo $VERSION_RESPONSE | jq -r '.botVersion')
echo "Created bot version: $BOT_VERSION"
```

3. **Create Bot Alias with Lambda Association:**
```bash
LAMBDA_ARN=$(cd infra && terraform output -raw lambda_function_arn)

# Create alias with Lambda function
aws lexv2-models create-bot-alias \
  --bot-alias-name "TestBotAlias" \
  --description "Test alias with Lambda fulfillment" \
  --bot-version $BOT_VERSION \
  --bot-id $BOT_ID \
  --bot-alias-locale-settings "$LOCALE_ID={enabled=true,codeHookSpecification={lambdaCodeHook={lambdaArn=$LAMBDA_ARN,codeHookInterfaceVersion=1.0}}}" \
  --region $AWS_REGION
```

4. **Verify Alias Configuration:**
```bash
# Get alias ID
ALIAS_ID=$(aws lexv2-models list-bot-aliases \
  --bot-id $BOT_ID \
  --region $AWS_REGION \
  --query 'botAliasSummaries[?botAliasName==`TestBotAlias`].botAliasId' \
  --output text)

# Check alias configuration
aws lexv2-models describe-bot-alias \
  --bot-id $BOT_ID \
  --bot-alias-id $ALIAS_ID \
  --region $AWS_REGION
```

---

### **🛠️ Complete Lambda Permission Fix Script**

Create this script to fix both issues automatically:

```bash
#!/bin/bash
# fix-lambda-permissions.sh

set -e

echo "🔧 Fixing Lambda permissions for Lex bot..."

# Get Terraform outputs
cd infra
BOT_ID=$(terraform output -raw lex_bot_id)
BOT_NAME=$(terraform output -raw lex_bot_name)
LAMBDA_FUNCTION=$(terraform output -raw lambda_function_name)
LAMBDA_ARN=$(terraform output -raw lambda_function_arn)
LOCALE_ID=$(terraform output -raw lex_bot_locale_id)
AWS_REGION=$(terraform output -raw aws_region)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
cd ..

echo "📋 Configuration:"
echo "  Bot ID: $BOT_ID"
echo "  Lambda: $LAMBDA_FUNCTION"
echo "  Region: $AWS_REGION"

# Step 1: Add Lambda permissions
echo "🔐 Adding Lambda permissions..."

# Permission for bot
aws lambda add-permission \
  --function-name $LAMBDA_FUNCTION \
  --statement-id "AllowLexBot" \
  --action "lambda:InvokeFunction" \
  --principal "lexv2.amazonaws.com" \
  --source-arn "arn:aws:lex:$AWS_REGION:$ACCOUNT_ID:bot/$BOT_ID/*" \
  --region $AWS_REGION || echo "Bot permission already exists"

# Permission for bot alias
aws lambda add-permission \
  --function-name $LAMBDA_FUNCTION \
  --statement-id "AllowLexBotAlias" \
  --action "lambda:InvokeFunction" \
  --principal "lexv2.amazonaws.com" \
  --source-arn "arn:aws:lex:$AWS_REGION:$ACCOUNT_ID:bot-alias/$BOT_ID/*" \
  --region $AWS_REGION || echo "Bot alias permission already exists"

echo "✅ Lambda permissions configured"

# Step 2: Build bot locale
echo "🔨 Building bot locale..."
aws lexv2-models build-bot-locale \
  --bot-id $BOT_ID \
  --bot-version "DRAFT" \
  --locale-id $LOCALE_ID \
  --region $AWS_REGION

# Wait for build
echo "⏳ Waiting for bot locale build..."
while true; do
  STATUS=$(aws lexv2-models describe-bot-locale \
    --bot-id $BOT_ID \
    --bot-version "DRAFT" \
    --locale-id $LOCALE_ID \
    --region $AWS_REGION \
    --query 'botLocaleStatus' \
    --output text)
  
  echo "  Build status: $STATUS"
  
  if [ "$STATUS" = "Built" ]; then
    break
  elif [ "$STATUS" = "Failed" ]; then
    echo "❌ Bot locale build failed"
    exit 1
  fi
  
  sleep 10
done

echo "✅ Bot locale built successfully"

# Step 3: Create bot version
echo "📦 Creating bot version..."
VERSION_RESPONSE=$(aws lexv2-models create-bot-version \
  --bot-id $BOT_ID \
  --description "Version with Lambda fulfillment" \
  --bot-version-locale-specification "$LOCALE_ID={sourceBotVersion=DRAFT}" \
  --region $AWS_REGION \
  --output json)

BOT_VERSION=$(echo $VERSION_RESPONSE | jq -r '.botVersion')
echo "✅ Created bot version: $BOT_VERSION"

# Wait for version
echo "⏳ Waiting for bot version..."
while true; do
  STATUS=$(aws lexv2-models describe-bot-version \
    --bot-id $BOT_ID \
    --bot-version $BOT_VERSION \
    --region $AWS_REGION \
    --query 'botStatus' \
    --output text)
  
  echo "  Version status: $STATUS"
  
  if [ "$STATUS" = "Available" ]; then
    break
  elif [ "$STATUS" = "Failed" ]; then
    echo "❌ Bot version creation failed"
    exit 1
  fi
  
  sleep 5
done

# Step 4: Create/update bot alias with Lambda
echo "🔗 Creating bot alias with Lambda association..."

# Delete existing alias if it exists
aws lexv2-models delete-bot-alias \
  --bot-id $BOT_ID \
  --bot-alias-id TSTALIASID \
  --region $AWS_REGION 2>/dev/null || echo "No existing alias to delete"

# Create new alias
aws lexv2-models create-bot-alias \
  --bot-alias-name "TestBotAlias" \
  --description "Test alias with Lambda fulfillment" \
  --bot-version $BOT_VERSION \
  --bot-id $BOT_ID \
  --bot-alias-locale-settings "$LOCALE_ID={enabled=true,codeHookSpecification={lambdaCodeHook={lambdaArn=$LAMBDA_ARN,codeHookInterfaceVersion=1.0}}}" \
  --region $AWS_REGION

echo "🎉 Lambda integration fixed!"
echo ""
echo "✅ Next steps:"
echo "  1. Test in Lex console with TestBotAlias"
echo "  2. Try: 'Give me healthy diet tips'"
echo "  3. Check CloudWatch logs: /aws/lambda/$LAMBDA_FUNCTION"
echo "  4. Update frontend .env if needed"
```

**Usage:**
```bash
chmod +x fix-lambda-permissions.sh
./fix-lambda-permissions.sh
```

---

### **🧪 Testing Lambda Integration**

#### **Test in AWS Console:**
1. Go to [Lex Console](https://console.aws.amazon.com/lexv2/)
2. Open your `HealthAdviceBot`
3. Use **TestBotAlias** for testing
4. Try: *"Give me healthy diet tips"*
5. Verify Lambda function is called in CloudWatch logs

#### **Test via CLI:**
```bash
# Test bot alias directly
aws lexv2-runtime recognize-text \
  --bot-id $BOT_ID \
  --bot-alias-id "TSTALIASID" \
  --locale-id $LOCALE_ID \
  --session-id "test-session" \
  --text "Give me healthy diet tips" \
  --region $AWS_REGION
```

#### **Monitor Lambda Execution:**
```bash
# Watch Lambda logs in real-time
aws logs tail /aws/lambda/health-advice-chatbot-handler --follow --region $AWS_REGION
```

---

### **🔍 Verification Checklist**

**Lambda Permissions:**
- [ ] Bot-level permission exists
- [ ] Bot-alias level permission exists
- [ ] Lambda policy shows both permissions

**Bot Configuration:**
- [ ] Bot locale is "Built" status
- [ ] Bot version is "Available"
- [ ] Bot alias exists with Lambda ARN
- [ ] TestBotAlias shows Lambda configuration

**Testing:**
- [ ] Lex console test works with TestBotAlias
- [ ] Lambda function executes (check CloudWatch)
- [ ] Dynamic responses vary between tests
- [ ] Health disclaimers appear in responses
- [ ] Frontend connects to bot alias

**Common Issues:**
- 🚫 **"No alias found"** → Run alias creation step
- 🚫 **"Access denied"** → Add Lambda permissions
- 🚫 **"Bot not found"** → Check Terraform deployment
- 🚫 **"Function timeout"** → Check Lambda logs

---

### **🆘 Emergency Reset**

If everything breaks:

```bash
# 1. Destroy and recreate infrastructure
cd infra
terraform destroy -auto-approve
terraform apply -auto-approve

# 2. Run fix script
cd ..
./fix-lambda-permissions.sh

# 3. Test immediately
echo "Testing bot alias..."
BOT_ID=$(cd infra && terraform output -raw lex_bot_id)
aws lexv2-runtime recognize-text \
  --bot-id $BOT_ID \
  --bot-alias-id "TSTALIASID" \
  --locale-id "en_US" \
  --session-id "emergency-test" \
  --text "Give me diet tips" \
  --region us-east-1
```

**Result:** Complete Lambda integration with proper permissions and bot alias configuration.

---

## 🔧 **Development & Customization**

### **Adding New Health Topics**

1. **Update Lambda Function** (lambda/healthAdviceHandler.py):
```python
HEALTH_ADVICE = {
    'NewHealthTopic': [
        "Your new health advice content here...",
        "Additional advice for variety...",
        "More educational content..."
    ]
}
```

2. **Add Intent to Terraform** (infra/main.tf):
```hcl
resource "aws_lexv2models_intent" "new_health_topic" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "NewHealthTopic"

  sample_utterance {
    utterance = "Tell me about new health topic"
  }

  fulfillment_code_hook {
    enabled = true
  }
}
```

3. **Deploy Changes**:
```bash
cd infra
terraform apply
```

4. **Test** with voice commands and Lambda responses

### **Voice Customization**

```javascript
// Customize voice settings in config.js
voice: {
  enabled: true,
  autoPlay: true,
  speechRate: 1.2,      // Faster speech
  speechPitch: 1.1,     // Higher pitch
  speechVolume: 0.9,    // Slightly quieter
  language: 'en-US'
}
```

---

## 🏆 **Architecture Decision: Lambda + Voice Integration**

### **Why This Architecture?**
- ✅ **Dynamic Content Generation** - Varied responses prevent repetition
- ✅ **Educational Compliance** - Automatic health disclaimers
- ✅ **Superior User Experience** - Voice + intelligent responses
- ✅ **Scalable Architecture** - Lambda scales automatically with usage
- ✅ **Cost Effective** - Pay-per-use Lambda model
- ✅ **Maintainable** - Easy to update health advice content
- ✅ **Monitorable** - Built-in CloudWatch logging and metrics

### **Technical Innovation**
- **Browser-Native Voice** - No cloud audio processing required
- **Lambda Fulfillment** - Dynamic health advice generation
- **Local Privacy** - All voice processing happens on user's device
- **Progressive Enhancement** - Graceful fallback for any browser

**Result**: A production-ready, voice-enabled health assistant that demonstrates cutting-edge serverless and frontend skills while maintaining optimal cloud architecture and user experience.

---

## 🔮 **Future Enhancements**

### **Lambda Roadmap**
- **🔍 Personalization** - User context and preference tracking
- **📊 Analytics** - Health advice effectiveness metrics
- **🌍 Multi-Language** - Internationalization support
- **🔗 Integration** - External health APIs and databases

### **Voice Roadmap**
- **🎵 Voice Personalities** - Multiple voice options and tones
- **🌍 Multi-Language Voice** - Support for Spanish, French, German
- **👂 Wake Words** - "Hey Health Assistant" activation
- **🗣️ Conversation Memory** - Context-aware voice interactions

### **Technical Roadmap**
- **AWS Polly Integration** - Professional voice quality option
- **Lambda Layers** - Shared health advice libraries
- **Step Functions** - Complex health advice workflows
- **API Gateway** - RESTful health advice endpoints

---

## 🤝 **Contributing**

This is a portfolio project demonstrating modern cloud and voice development skills. For feedback or collaboration:

1. Fork the repository
2. Create a feature branch  
3. Implement Lambda or voice improvements
4. Submit a pull request

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🏆 **Portfolio Contact**

**Ready to discuss this Lambda-powered, voice-enabled cloud solution?**

- 💼 **LinkedIn**: [Abaasi Kisuule](https://www.linkedin.com/in/abaasi-k-b79420340)
- 📧 **Email**: kisuulemaliq@gmail.com
- 🐙 **GitHub**: [abaasi256](https://github.com/abaasi256)

---

<div align="center">

**⭐ Star this repository if it demonstrates the modern serverless and voice technology skills you're looking for!**

*🎤⚡ Built with ❤️ to showcase cutting-edge AWS Lambda integration and voice technology*

**Try the voice features live - ask about your health and listen to the intelligent Lambda-generated responses!**

**🎯 Lambda Function: `health-advice-chatbot-handler` | 🤖 Bot Alias: `TestBotAlias` | 🎤 Voice: Enabled**

</div>
