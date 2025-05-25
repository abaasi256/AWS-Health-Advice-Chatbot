// AWS Health Advice Chatbot Configuration
// Production-ready configuration with environment variable support

export const AWS_CONFIG = {
  region: process.env.REACT_APP_AWS_REGION || 'us-east-1',
  
  // Lex Bot Configuration
  lex: {
    botId: process.env.REACT_APP_LEX_BOT_ID || 'YOUR_BOT_ID',
    botAliasId: process.env.REACT_APP_LEX_BOT_ALIAS_ID || 'TSTALIASID',
    localeId: process.env.REACT_APP_LEX_LOCALE_ID || 'en_US',
    region: process.env.REACT_APP_AWS_REGION || 'us-east-1'
  },
  
  // Cognito Identity Pool for secure access
  cognito: {
    identityPoolId: process.env.REACT_APP_COGNITO_IDENTITY_POOL_ID || 'YOUR_IDENTITY_POOL_ID',
    region: process.env.REACT_APP_AWS_REGION || 'us-east-1'
  }
};

// Application Configuration
export const APP_CONFIG = {
  name: 'AWS Health Advice Chatbot',
  version: process.env.REACT_APP_VERSION || '1.0.0',
  description: 'Get personalized health advice powered by AWS Lex v2',
  environment: process.env.REACT_APP_ENV || 'development',
  
  // Chat Configuration
  chat: {
    maxMessages: 50,
    typingDelay: 1000,
    autoScroll: true,
    showTimestamps: true
  },
  
  // Voice Configuration
  voice: {
    enabled: process.env.REACT_APP_VOICE_ENABLED !== 'false',
    autoPlay: true,
    speechRate: 1.0,
    speechPitch: 1.0,
    speechVolume: 1.0,
    language: 'en-US'
  },
  
  // UI Configuration
  ui: {
    theme: 'modern',
    animations: true,
    compactMode: false
  }
};

// Health Topics for quick suggestions
export const HEALTH_TOPICS = [
  {
    id: 'diet',
    title: 'Healthy Diet Tips',
    icon: '🥗',
    description: 'Get personalized nutrition advice',
    sampleQuestions: [
      'Give me healthy diet tips',
      'What should I eat to stay healthy?',
      'I need nutrition advice'
    ]
  },
  {
    id: 'exercise',
    title: 'Exercise Recommendations',
    icon: '🏃‍♀️',
    description: 'Find the right workout for you',
    sampleQuestions: [
      'What exercises should I do?',
      'Give me workout recommendations',
      'I need fitness advice'
    ]
  },
  {
    id: 'mental',
    title: 'Mental Wellness',
    icon: '🧘‍♀️',
    description: 'Support your mental health',
    sampleQuestions: [
      'Give me mental wellness tips',
      'How can I manage stress?',
      'Help me with anxiety'
    ]
  },
  {
    id: 'sleep',
    title: 'Sleep Tips',
    icon: '😴',
    description: 'Improve your sleep quality',
    sampleQuestions: [
      'How can I sleep better?',
      'Give me sleep advice',
      'I have trouble sleeping'
    ]
  },
  {
    id: 'hydration',
    title: 'Hydration Info',
    icon: '💧',
    description: 'Learn about proper hydration',
    sampleQuestions: [
      'How much water should I drink?',
      'Tell me about hydration',
      'Benefits of staying hydrated'
    ]
  }
];

// Message types
export const MESSAGE_TYPES = {
  USER: 'user',
  BOT: 'bot',
  SYSTEM: 'system',
  ERROR: 'error'
};

// Error messages
export const ERROR_MESSAGES = {
  NETWORK: 'Network connection error. Please check your internet connection.',
  SERVICE: 'Service temporarily unavailable. Please try again later.',
  VALIDATION: 'Please check your input and try again.',
  GENERIC: 'Something went wrong. Please try again.'
};