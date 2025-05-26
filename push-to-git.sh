#!/bin/bash

# Git Push Script for AWS Health Advice Chatbot
echo "🚀 Pushing AWS Health Advice Chatbot Changes to Git"
echo "=================================================="

cd /Users/abaasi/Desktop/AWS-Health-Advice-Chatbot

# Check git status
echo "📋 Current Git Status:"
git status

echo ""
echo "📝 Recent Changes Made:"
echo "- ✅ Lambda integration restored and working"
echo "- ✅ TestBotAlias configured with Lambda fulfillment"
echo "- ✅ Frontend voice service fixed"
echo "- ✅ README.md updated with Lambda functionality"
echo "- ✅ Screenshots added as proof of working bot"
echo "- ✅ Cleaned up non-working scripts"
echo ""

# Add all changes
echo "📦 Adding all changes..."
git add .

# Check what will be committed
echo "🔍 Changes to be committed:"
git diff --cached --name-status

echo ""
read -p "✅ Do you want to commit these changes? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "💾 Committing changes..."
    git commit -m "🎉 Complete Lambda Integration & Voice Fix

✅ Lambda Fulfillment Working:
- health-advice-chatbot-handler deployed and functional
- TestBotAlias configured with Lambda integration
- Dynamic health advice responses with disclaimers
- CloudWatch logging and monitoring enabled

✅ Frontend Voice Service Fixed:
- Resolved 'text-to-speech not supported' error
- Enhanced voice service with better browser compatibility
- Graceful error handling and user feedback
- Voice features work across different browsers

✅ Documentation Updated:
- README.md completely rewritten with Lambda functionality
- Added Screenshots/ folder with proof of working bot
- Removed all non-working scripts and documentation
- Professional portfolio presentation

✅ Architecture Improvements:
- User Input → Lex (TestBotAlias) → Lambda → Dynamic Responses
- Full voice integration (speech-to-text & text-to-speech)
- Cost-optimized serverless architecture
- Infrastructure as Code with Terraform

🎯 Result: Production-ready health advice chatbot with:
- Lambda-powered dynamic responses
- Full voice capabilities
- Professional documentation
- Visual proof of functionality"

    echo ""
    echo "🌐 Pushing to remote repository..."
    git push

    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 Successfully pushed changes to git!"
        echo ""
        echo "📊 Summary of what was pushed:"
        echo "- Lambda function: health-advice-chatbot-handler"
        echo "- Updated Terraform configuration"
        echo "- Fixed frontend voice service"
        echo "- Updated README.md with Lambda integration"
        echo "- Screenshots proving working bot"
        echo "- Clean project structure"
        echo ""
        echo "🔗 Repository is now up to date with:"
        echo "- Working Lambda fulfillment"
        echo "- Voice-enabled frontend"
        echo "- Professional documentation"
        echo "- Visual evidence of functionality"
        echo ""
        echo "✅ Your AWS Health Advice Chatbot portfolio project is ready!"
    else
        echo "❌ Failed to push changes. Please check your git configuration."
    fi
else
    echo "❌ Commit cancelled. Changes are staged and ready when you're ready to commit."
fi
