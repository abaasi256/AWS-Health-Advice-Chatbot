import React, { useState, useEffect, useRef } from 'react';
import styled from 'styled-components';
import lexService from '../services/lexService';
import voiceService from '../services/voiceService';
import { MESSAGE_TYPES, APP_CONFIG } from '../config';

// Styled components remain the same...
const ChatContainer = styled.div`
  display: flex;
  flex-direction: column;
  height: 500px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  overflow: hidden;
`;

const ChatHeader = styled.div`
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  color: white;
  padding: 1rem;
  text-align: center;
  
  h3 {
    margin: 0;
    font-size: 1.1rem;
    font-weight: 600;
  }
  
  p {
    margin: 0.25rem 0 0 0;
    font-size: 0.875rem;
    opacity: 0.9;
  }
`;

const VoiceControls = styled.div`
  display: flex;
  justify-content: center;
  gap: 0.5rem;
  margin-top: 0.5rem;
`;

const VoiceButton = styled.button`
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 20px;
  padding: 0.25rem 0.75rem;
  font-size: 0.75rem;
  cursor: pointer;
  transition: all 0.2s;
  
  &:hover:not(:disabled) {
    background: rgba(255, 255, 255, 0.3);
  }
  
  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
  &.active {
    background: #10b981;
    border-color: #10b981;
  }
`;

const MessagesContainer = styled.div`
  flex: 1;
  overflow-y: auto;
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
`;

const Message = styled.div`
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  animation: fadeIn 0.3s ease-out;
  
  ${props => props.type === MESSAGE_TYPES.USER && `
    flex-direction: row-reverse;
    
    .message-bubble {
      background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
      color: white;
      margin-left: 2rem;
    }
  `}
  
  ${props => props.type === MESSAGE_TYPES.BOT && `
    .message-bubble {
      background: #f3f4f6;
      color: #374151;
      margin-right: 2rem;
    }
  `}
  
  ${props => props.type === MESSAGE_TYPES.ERROR && `
    .message-bubble {
      background: #fee2e2;
      color: #dc2626;
      border: 1px solid #fecaca;
    }
  `}
`;

const MessageBubble = styled.div`
  padding: 0.75rem 1rem;
  border-radius: 18px;
  max-width: 100%;
  word-wrap: break-word;
  line-height: 1.5;
  font-size: 0.9rem;
  white-space: pre-wrap;
  position: relative;
`;

const SpeakerButton = styled.button`
  position: absolute;
  top: 0.5rem;
  right: 0.5rem;
  background: rgba(0, 0, 0, 0.1);
  border: none;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 0.75rem;
  transition: all 0.2s;
  
  &:hover {
    background: rgba(0, 0, 0, 0.2);
    transform: scale(1.1);
  }
  
  &.speaking {
    background: #10b981;
    color: white;
    animation: pulse 1s infinite;
  }
`;

const Avatar = styled.div`
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  flex-shrink: 0;
  
  ${props => props.type === MESSAGE_TYPES.USER && `
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: white;
  `}
  
  ${props => props.type === MESSAGE_TYPES.BOT && `
    background: #10b981;
    color: white;
  `}
`;

const InputContainer = styled.div`
  padding: 1rem;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
`;

const InputWrapper = styled.div`
  display: flex;
  gap: 0.5rem;
  align-items: center;
`;

const MessageInput = styled.input`
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1px solid #d1d5db;
  border-radius: 25px;
  outline: none;
  font-size: 0.9rem;
  
  &:focus {
    border-color: #4f46e5;
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
  }
  
  &:disabled {
    background: #f3f4f6;
    cursor: not-allowed;
  }
`;

const ActionButton = styled.button`
  width: 45px;
  height: 45px;
  border: none;
  border-radius: 50%;
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 1.2rem;
  
  &:hover:not(:disabled) {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
  }
  
  &:disabled {
    cursor: not-allowed;
    opacity: 0.5;
  }
  
  &.recording {
    background: #dc2626;
    animation: pulse 1s infinite;
  }
  
  &.microphone {
    background: #10b981;
  }
`;

const VoiceIndicator = styled.div`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #6b7280;
  margin-top: 0.5rem;
  
  &.listening {
    color: #10b981;
    font-weight: 500;
  }
  
  .listening-dot {
    width: 8px;
    height: 8px;
    background: #10b981;
    border-radius: 50%;
    animation: pulse 1s infinite;
  }
`;

const TypingIndicator = styled.div`
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0;
  
  .dots {
    display: flex;
    gap: 4px;
    
    span {
      width: 8px;
      height: 8px;
      background: #9ca3af;
      border-radius: 50%;
      animation: bounce 1.4s infinite;
      
      &:nth-child(2) { animation-delay: 0.2s; }
      &:nth-child(3) { animation-delay: 0.4s; }
    }
  }
`;

const ErrorMessage = styled.div`
  background: #fee2e2;
  color: #dc2626;
  padding: 0.75rem;
  border-radius: 8px;
  border: 1px solid #fecaca;
  margin: 0.5rem 0;
  font-size: 0.875rem;
`;

const ChatInterface = ({ onMessageSent, initialMessage }) => {
  const [messages, setMessages] = useState([]);
  const [inputValue, setInputValue] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  const [isLexReady, setIsLexReady] = useState(false);
  
  // Voice states
  const [isListening, setIsListening] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [voiceEnabled, setVoiceEnabled] = useState(false);
  const [speakingMessageId, setSpeakingMessageId] = useState(null);
  const [voiceSupport, setVoiceSupport] = useState(null);
  const [speechRecognition, setSpeechRecognition] = useState(null);
  const [voiceTestPassed, setVoiceTestPassed] = useState(false);
  
  const messagesEndRef = useRef(null);

  // Initialize services
  useEffect(() => {
    const initializeServices = async () => {
      try {
        await lexService.initialize();
        setIsLexReady(true);
        
        // Check voice support
        const support = voiceService.getSupportStatus();
        setVoiceSupport(support);
        
        // Test speech synthesis if supported
        if (support.synthesis) {
          try {
            // Simple test without actual audio
            const voices = voiceService.getAvailableVoices();
            setVoiceTestPassed(voices.length > 0);
            setVoiceEnabled(voices.length > 0 && APP_CONFIG.voice.enabled);
          } catch (error) {
            console.warn('Voice test failed:', error);
            setVoiceTestPassed(false);
          }
        }
        
        // Initialize Speech Recognition
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (SpeechRecognition) {
          const recognition = new SpeechRecognition();
          recognition.continuous = false;
          recognition.interimResults = false;
          recognition.lang = APP_CONFIG.voice.language;
          
          recognition.onresult = (event) => {
            const transcript = event.results[0][0].transcript;
            setInputValue(transcript);
            setIsListening(false);
          };
          
          recognition.onerror = (event) => {
            console.error('Speech recognition error:', event.error);
            setError(`Voice recognition failed: ${event.error}. Please try again or use text input.`);
            setIsListening(false);
          };
          
          recognition.onend = () => {
            setIsListening(false);
          };
          
          setSpeechRecognition(recognition);
        }
        
        // Add welcome message
        const welcomeMessage = '🤖 Hi! I\'m your Health Advice Assistant. I can help you with nutrition, exercise, mental wellness, sleep, and hydration tips. What would you like to know?';
        addMessage(welcomeMessage, MESSAGE_TYPES.BOT);
        
      } catch (error) {
        console.error('Failed to initialize services:', error);
        setError('Failed to connect to the chatbot service. Please refresh the page and try again.');
      }
    };

    initializeServices();
  }, []);

  // Handle initial message
  useEffect(() => {
    if (initialMessage && isLexReady) {
      sendMessage(initialMessage);
    }
  }, [initialMessage, isLexReady]);

  // Auto-scroll to bottom
  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const addMessage = (content, type, metadata = {}) => {
    const message = {
      id: Date.now() + Math.random(),
      content,
      type,
      timestamp: new Date(),
      ...metadata
    };

    setMessages(prev => [...prev.slice(-APP_CONFIG.chat.maxMessages + 1), message]);
    
    if (onMessageSent) {
      onMessageSent(message);
    }
    
    return message;
  };

  const sendMessage = async (text = inputValue.trim()) => {
    if (!text || isLoading || !isLexReady) return;

    setError(null);
    setInputValue('');
    addMessage(text, MESSAGE_TYPES.USER);
    setIsLoading(true);

    try {
      const response = await lexService.sendTextMessage(text);
      
      setTimeout(() => {
        const botMessage = addMessage(response.message, MESSAGE_TYPES.BOT, {
          intent: response.intent,
          fulfillmentState: response.fulfillmentState
        });
        
        setIsLoading(false);
        
        // Auto-speak bot response if voice is enabled
        if (voiceEnabled && voiceTestPassed && APP_CONFIG.voice.autoPlay) {
          setTimeout(() => {
            handleSpeak(response.message, botMessage.id);
          }, 500);
        }
      }, APP_CONFIG.chat.typingDelay);
      
    } catch (error) {
      console.error('Error sending message:', error);
      setError(error.message);
      addMessage('Sorry, I encountered an error. Please try again.', MESSAGE_TYPES.ERROR);
      setIsLoading(false);
    }
  };

  const handleStartListening = () => {
    if (!speechRecognition) {
      setError('Speech recognition is not supported in this browser. Please use Chrome, Safari, or Edge.');
      return;
    }

    try {
      setError(null);
      setIsListening(true);
      speechRecognition.start();
    } catch (error) {
      console.error('Error starting speech recognition:', error);
      setError('Failed to start voice recognition. Please try again.');
      setIsListening(false);
    }
  };

  const handleStopListening = () => {
    if (speechRecognition && isListening) {
      speechRecognition.stop();
      setIsListening(false);
    }
  };

  const handleSpeak = async (text, messageId = null) => {
    if (!voiceSupport?.synthesis || !voiceTestPassed) {
      console.warn('Text-to-speech not available');
      return;
    }

    try {
      setIsSpeaking(true);
      setSpeakingMessageId(messageId);
      
      await voiceService.speak(text);
      
      setIsSpeaking(false);
      setSpeakingMessageId(null);
    } catch (error) {
      console.error('Error speaking:', error);
      setIsSpeaking(false);
      setSpeakingMessageId(null);
    }
  };

  const handleStopSpeaking = () => {
    voiceService.stopSpeaking();
    setIsSpeaking(false);
    setSpeakingMessageId(null);
  };

  const toggleVoice = () => {
    if (!voiceTestPassed) {
      setError('Voice features are not fully supported in this browser. Try using Chrome, Safari, or Edge for the best experience.');
      return;
    }
    
    setVoiceEnabled(prev => !prev);
    if (isSpeaking) {
      handleStopSpeaking();
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  return (
    <ChatContainer>
      <ChatHeader>
        <h3>Health Advice Assistant</h3>
        <p>Ask me about nutrition, exercise, mental wellness, sleep, and hydration</p>
        
        <VoiceControls>
          <VoiceButton
            onClick={toggleVoice}
            className={voiceEnabled ? 'active' : ''}
            disabled={!voiceTestPassed}
          >
            {voiceEnabled ? '🔊 Voice On' : '🔇 Voice Off'}
          </VoiceButton>
          
          {speechRecognition ? (
            <VoiceButton>
              🎤 Voice Input Ready
            </VoiceButton>
          ) : (
            <VoiceButton disabled>
              🎤 Voice Input Unavailable
            </VoiceButton>
          )}
        </VoiceControls>
      </ChatHeader>

      <MessagesContainer>
        {messages.map((message) => (
          <Message key={message.id} type={message.type}>
            <Avatar type={message.type}>
              {message.type === MESSAGE_TYPES.USER ? '👤' : '🤖'}
            </Avatar>
            <MessageBubble className="message-bubble">
              {message.content}
              
              {message.type === MESSAGE_TYPES.BOT && voiceTestPassed && (
                <SpeakerButton
                  onClick={() => 
                    speakingMessageId === message.id 
                      ? handleStopSpeaking() 
                      : handleSpeak(message.content, message.id)
                  }
                  className={speakingMessageId === message.id ? 'speaking' : ''}
                  title={speakingMessageId === message.id ? 'Stop speaking' : 'Read aloud'}
                >
                  {speakingMessageId === message.id ? '⏹️' : '🔊'}
                </SpeakerButton>
              )}
            </MessageBubble>
          </Message>
        ))}

        {isLoading && (
          <TypingIndicator>
            <Avatar type={MESSAGE_TYPES.BOT}>🤖</Avatar>
            <div>
              <div style={{ fontSize: '0.875rem', color: '#6b7280', marginBottom: '0.25rem' }}>
                Assistant is typing...
              </div>
              <div className="dots">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
          </TypingIndicator>
        )}

        <div ref={messagesEndRef} />
      </MessagesContainer>

      {error && <ErrorMessage>{error}</ErrorMessage>}

      <InputContainer>
        <InputWrapper>
          <MessageInput
            type="text"
            placeholder={isListening ? "Listening..." : "Type your health question here..."}
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            onKeyPress={handleKeyPress}
            disabled={isLoading || !isLexReady || isListening}
          />
          
          {speechRecognition && (
            <ActionButton
              onClick={isListening ? handleStopListening : handleStartListening}
              className={isListening ? 'recording' : 'microphone'}
              disabled={isLoading || !isLexReady}
              title={isListening ? 'Stop listening' : 'Start voice input'}
            >
              {isListening ? '⏹️' : '🎤'}
            </ActionButton>
          )}
          
          <ActionButton
            onClick={() => sendMessage()}
            disabled={!inputValue.trim() || isLoading || !isLexReady || isListening}
            title="Send message"
          >
            📤
          </ActionButton>
        </InputWrapper>
        
        {isListening && (
          <VoiceIndicator className="listening">
            <div className="listening-dot"></div>
            Listening... Speak your health question now
          </VoiceIndicator>
        )}
        
        {isSpeaking && (
          <VoiceIndicator>
            🔊 Speaking...
          </VoiceIndicator>
        )}
      </InputContainer>
    </ChatContainer>
  );
};

export default ChatInterface;
