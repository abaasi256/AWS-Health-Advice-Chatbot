# 🎤 Frontend - Voice-Enhanced Health Advice Chatbot

> **Modern React application with voice capabilities powered by AWS Lex v2**

## 🚀 **New Voice Features**

### **✅ What's Working**
- 🔊 **Text-to-Speech** - All bot responses can be spoken aloud
- 🎛️ **Voice Controls** - Toggle voice on/off, individual message playback
- 🎤 **Microphone Ready** - Recording infrastructure in place
- 📱 **Mobile Friendly** - Voice features work on mobile browsers
- ♿ **Accessible** - Screen reader friendly with proper ARIA labels

### **🚀 Enhanced Features**
- **Auto-Play Responses** - Bot messages automatically spoken (configurable)
- **Per-Message Audio** - Click speaker icon on any bot message
- **Voice Indicators** - Visual feedback for speaking/recording states
- **Browser Support Detection** - Graceful fallback when voice unavailable
- **Configurable Speech** - Rate, pitch, volume, and language settings

---

## 🛠️ **Quick Setup**

### **1. Install Dependencies**
```bash
cd frontend
npm install
```

### **2. Configure Environment**
```bash
cp .env.example .env
# Edit .env with your Terraform outputs:
# - REACT_APP_LEX_BOT_ID (from terraform output)
# - REACT_APP_AWS_REGION (your deployment region)
```

### **3. Start Development**
```bash
npm start
# Opens http://localhost:3000
```

### **4. Test Voice Features**
1. Open in Chrome/Safari (best voice support)
2. Allow microphone permissions when prompted
3. Click "🔊 Voice On" to enable text-to-speech
4. Ask a health question and listen to the response
5. Click 🔊 icon on any bot message to replay

---

## 🎤 **Voice Configuration**

### **Environment Variables**
```bash
# Voice Feature Toggles
REACT_APP_VOICE_ENABLED=true
REACT_APP_VOICE_AUTO_PLAY=true

# Speech Settings
REACT_APP_VOICE_SPEECH_RATE=1.0    # 0.1-10 (speed)
REACT_APP_VOICE_SPEECH_PITCH=1.0   # 0-2 (tone)
REACT_APP_VOICE_SPEECH_VOLUME=1.0  # 0-1 (loudness)
REACT_APP_VOICE_LANGUAGE=en-US     # Language code
```

### **Supported Browsers**
| Browser | Text-to-Speech | Speech-to-Text | Recording |
|---------|----------------|----------------|-----------|
| **Chrome** | ✅ Excellent | 🚧 Planned | ✅ Ready |
| **Safari** | ✅ Good | 🚧 Planned | ✅ Ready |
| **Firefox** | ✅ Basic | ❌ Limited | ✅ Ready |
| **Edge** | ✅ Good | 🚧 Planned | ✅ Ready |

---

## 🎯 **Voice UI Components**

### **Voice Controls Header**
```jsx
<VoiceControls>
  <VoiceButton onClick={toggleVoice}>🔊 Voice On</VoiceButton>
  <VoiceButton>🎤 Mic Ready</VoiceButton>
</VoiceControls>
```

### **Message Speaker Buttons**
- 🔊 **Play** - Speak the message
- ⏹️ **Stop** - Stop current speech
- ✨ **Visual Feedback** - Glowing animation while speaking

### **Input Controls**
- 📤 **Send Button** - Submit text message
- 🎤 **Microphone Button** - Start voice recording (ready)
- 🟥 **Recording Indicator** - Visual feedback during recording

---

## 📱 **User Experience**

### **Voice Interaction Flow**
1. **Welcome** - Auto-speaks greeting when voice enabled
2. **Question** - User types or speaks health question
3. **Response** - Bot provides health advice
4. **Auto-Speech** - Response automatically spoken aloud
5. **Replay** - Click speaker icon to hear again
6. **Control** - Toggle voice on/off anytime

### **Visual Feedback**
- 🟢 **Green Glow** - Currently speaking
- 🔴 **Red Pulse** - Recording (when implemented)
- 🔊 **Speaker Icons** - Available on all bot messages
- 🎤 **Microphone Ready** - Recording infrastructure ready

---

## 🔧 **Technical Implementation**

### **Voice Service Architecture**
```javascript
voiceService.js
├── checkSupport()           // Browser capability detection
├── speak(text, options)     // Text-to-speech with Web Speech API
├── startRecording()         // MediaRecorder for voice input
├── stopRecording()          // Process recorded audio
├── getAvailableVoices()     // Available TTS voices
└── cleanup()                // Resource management
```

### **State Management**
```javascript
// Voice States in ChatInterface
const [voiceEnabled, setVoiceEnabled] = useState(true);
const [isSpeaking, setIsSpeaking] = useState(false);
const [isRecording, setIsRecording] = useState(false);
const [speakingMessageId, setSpeakingMessageId] = useState(null);
```

### **Integration Points**
- ✅ **AWS Lex v2** - Static responses work perfectly with TTS
- ✅ **Web Speech API** - Browser-native text-to-speech
- 🚧 **MediaRecorder** - Voice recording infrastructure ready
- 🚧 **Speech Recognition** - Planned for future implementation

---

## 🧪 **Testing Voice Features**

### **Manual Testing Checklist**
```bash
# Voice Feature Tests
□ Voice toggle on/off works
□ Auto-play speaks bot responses
□ Speaker icons appear on bot messages
□ Individual message playback works
□ Voice stops when toggled off
□ Visual indicators show speaking state
□ Mobile browser compatibility
□ Microphone permissions handled gracefully
```

### **Test Commands**
```bash
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run voice:test         # Start with voice testing focus
```

---

## 🚀 **Performance Optimizations**

### **Voice Optimizations**
- **Lazy Loading** - Voice service loads only when needed
- **Resource Cleanup** - Proper disposal of audio resources
- **Efficient Caching** - Voice objects reused across messages
- **Graceful Degradation** - Works without voice support

### **Bundle Size**
- **No External Libraries** - Uses browser-native APIs only
- **Tree Shaking** - Voice service conditionally loaded
- **Optimized Build** - Production build removes debug code

---

## 🔮 **Future Voice Enhancements**

### **Planned Features**
1. **🎤 Speech-to-Text** - Voice input for questions
2. **🗣️ Voice Commands** - "Ask about diet", "Stop speaking"
3. **👂 Wake Words** - "Hey Health Bot"
4. **🎵 Voice Personalities** - Different voice options
5. **🌍 Multi-Language** - Support for other languages
6. **📊 Voice Analytics** - Usage metrics and optimization

### **Integration Roadmap**
- **AWS Polly** - Higher quality text-to-speech
- **AWS Transcribe** - Professional speech-to-text
- **Amazon Lex Audio** - Direct audio streaming to Lex
- **WebRTC** - Real-time voice processing

---

## 🎨 **Customization**

### **Voice Personality Settings**
```javascript
// Custom voice configuration
const voiceOptions = {
  rate: 1.2,        // Faster speech
  pitch: 1.1,       // Slightly higher pitch
  volume: 0.8,      // Quieter volume
  voice: 'Google US English Female'
};
```

### **UI Customization**
```css
/* Custom voice button styling */
.voice-button {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  border-radius: 25px;
  transition: all 0.3s ease;
}

.voice-button.speaking {
  animation: pulse 1s infinite;
}
```

---

## 🏆 **Portfolio Value**

### **Technical Skills Demonstrated**
- ✅ **Modern React** - Hooks, state management, effects
- ✅ **Web APIs** - Speech Synthesis, MediaRecorder, Permissions
- ✅ **User Experience** - Accessibility, mobile-first, feedback
- ✅ **Performance** - Lazy loading, resource management
- ✅ **Testing** - Unit tests, integration testing
- ✅ **AWS Integration** - Lex v2, SDK, real-time communication

### **Innovation Points**
- **Voice-First Design** - Optimized for voice interaction
- **Progressive Enhancement** - Works with and without voice
- **Accessibility Focus** - Screen reader and voice navigation
- **Mobile Excellence** - Touch and voice on mobile devices

---

## 📞 **Support & Development**

### **Voice Issues?**
1. **Check Browser Support** - Chrome/Safari recommended
2. **Enable Microphone** - Allow permissions when prompted
3. **Test Text-to-Speech** - Click speaker icons first
4. **Check Console** - Look for voice service errors
5. **Fallback Mode** - App works without voice features

### **Development Tips**
- **Use HTTPS** - Required for microphone access
- **Test Multiple Browsers** - Voice APIs vary by browser
- **Handle Permissions** - Graceful microphone permission flow
- **Debug Voice** - Console logs show voice service status

---

<div align="center">

**🎤 Voice-enhanced health advice at your fingertips!**

*Experience the future of conversational health assistance*

</div>
