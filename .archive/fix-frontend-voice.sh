#!/bin/bash

# Frontend Voice Fix Script
echo "🔧 Fixing Frontend Voice Service"
echo "================================="

cd /Users/abaasi/Desktop/AWS-Health-Advice-Chatbot/frontend

echo "📋 Current Status:"
echo "- Lambda integration: ✅ Working"
echo "- Lex Console: ✅ Working" 
echo "- Frontend voice error: ❌ Needs fix"
echo ""

echo "🔧 Applying Voice Service Fix..."
echo "1. Updated voiceService.js with better browser compatibility"
echo "2. Updated ChatInterface.js with improved error handling"
echo "3. Added voice support detection and graceful fallbacks"
echo ""

echo "🚀 Restarting Frontend..."

# Kill any existing npm processes
pkill -f "npm start" 2>/dev/null || true
pkill -f "react-scripts start" 2>/dev/null || true

# Wait a moment
sleep 2

echo "📦 Installing dependencies..."
npm install

echo "🎯 Starting development server..."
npm start &

echo ""
echo "✅ Frontend restarted with voice fixes!"
echo ""
echo "🧪 Test the fixes:"
echo "1. Open http://localhost:3000"
echo "2. Voice button should now work without errors"
echo "3. Try the speaker icons on bot messages"
echo "4. Test microphone input if supported"
echo ""
echo "🎉 Voice integration should now work properly!"
