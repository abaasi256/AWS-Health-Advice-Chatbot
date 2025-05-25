import React, { useState, useEffect, useRef } from 'react';
import styled from 'styled-components';
import lexService from '../services/lexService';
import voiceService from '../services/voiceService';
import { MESSAGE_TYPES, APP_CONFIG } from '../config';

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

const SendButton = styled.button`
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
  
  &:hover:not(:disabled) {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
  }
  
  &:disabled {
    cursor: not-allowed;
    opacity: 0.5;
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
  const messagesEndRef = useRef(null);

  // Initialize Lex service
  useEffect(() => {
    const initializeLex = async () => {
      try {
        await lexService.initialize();
        setIsLexReady(true);
        
        // Add welcome message
        addMessage('🤖 Hi! I\'m your Health Advice Assistant. I can help you with nutrition, exercise, mental wellness, sleep, and hydration tips. What would you like to know?', MESSAGE_TYPES.BOT);
      } catch (error) {
        console.error('Failed to initialize Lex:', error);
        setError('Failed to connect to the chatbot service. Please refresh the page and try again.');
      }
    };

    initializeLex();
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
        addMessage(response.message, MESSAGE_TYPES.BOT, {
          intent: response.intent,
          fulfillmentState: response.fulfillmentState
        });
        setIsLoading(false);
      }, APP_CONFIG.chat.typingDelay);
      
    } catch (error) {
      console.error('Error sending message:', error);
      setError(error.message);
      addMessage('Sorry, I encountered an error. Please try again.', MESSAGE_TYPES.ERROR);
      setIsLoading(false);
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
      </ChatHeader>

      <MessagesContainer>
        {messages.map((message) => (
          <Message key={message.id} type={message.type}>
            <Avatar type={message.type}>
              {message.type === MESSAGE_TYPES.USER ? '👤' : '🤖'}
            </Avatar>
            <MessageBubble className="message-bubble">
              {message.content}
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
            placeholder="Type your health question here..."
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            onKeyPress={handleKeyPress}
            disabled={isLoading || !isLexReady}
          />
          
          <SendButton
            onClick={() => sendMessage()}
            disabled={!inputValue.trim() || isLoading || !isLexReady}
            title="Send message"
          >
            📤
          </SendButton>
        </InputWrapper>
      </InputContainer>
    </ChatContainer>
  );
};

export default ChatInterface;