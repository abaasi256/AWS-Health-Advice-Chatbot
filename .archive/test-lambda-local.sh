#!/bin/bash

# Test Lambda function locally before deployment
echo "🧪 Testing Lambda Handler Locally"
echo "=================================="

cd lambda

# Test different intents
echo "🔍 Testing DietTips intent..."
python3 -c "
import healthAdviceHandler
import json

event = {
    'sessionState': {
        'intent': {
            'name': 'DietTips'
        }
    },
    'sessionAttributes': {}
}

class MockContext:
    aws_request_id = 'test-diet-tips'

result = healthAdviceHandler.lambda_handler(event, MockContext())
print('Response:', json.dumps(result, indent=2))
print('Content:', result['messages'][0]['content'])
print()
"

echo "🔍 Testing SleepAdvice intent..."
python3 -c "
import healthAdviceHandler
import json

event = {
    'sessionState': {
        'intent': {
            'name': 'SleepAdvice'
        }
    },
    'sessionAttributes': {}
}

class MockContext:
    aws_request_id = 'test-sleep-advice'

result = healthAdviceHandler.lambda_handler(event, MockContext())
print('Response:', json.dumps(result, indent=2))
print('Content:', result['messages'][0]['content'])
print()
"

echo "🔍 Testing unknown intent (fallback)..."
python3 -c "
import healthAdviceHandler
import json

event = {
    'sessionState': {
        'intent': {
            'name': 'UnknownIntent'
        }
    },
    'sessionAttributes': {}
}

class MockContext:
    aws_request_id = 'test-unknown'

result = healthAdviceHandler.lambda_handler(event, MockContext())
print('Response:', json.dumps(result, indent=2))
print('Content:', result['messages'][0]['content'])
print()
"

echo "✅ Local testing completed!"
echo ""
echo "If all tests passed, the Lambda function is ready for deployment."
echo "Run './deploy-lambda-integration.sh' to deploy to AWS."
