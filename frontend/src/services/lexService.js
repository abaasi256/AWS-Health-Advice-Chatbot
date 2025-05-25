import { AWS_CONFIG, ERROR_MESSAGES } from '../config';

class LexService {
  constructor() {
    this.sessionId = this.generateSessionId();
    this.isInitialized = false;
  }

  async initialize() {
    try {
      this.isInitialized = true;
      console.log('Lex service initialized in demo mode');
      
      if (!AWS_CONFIG.lex.botId || AWS_CONFIG.lex.botId === 'YOUR_BOT_ID') {
        console.warn('Bot ID not configured. Running in demo mode.');
      }
      
    } catch (error) {
      console.error('Failed to initialize Lex service:', error);
      throw new Error(ERROR_MESSAGES.SERVICE);
    }
  }

  generateSessionId() {
    return `session-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  async sendTextMessage(message, sessionAttributes = {}) {
    if (!this.isInitialized) {
      throw new Error('Lex service not initialized. Call initialize() first.');
    }

    try {
      console.log('Processing message:', message);
      
      const mockResponse = this.getMockResponse(message);
      
      // Simulate API delay
      await new Promise(resolve => setTimeout(resolve, 800));
      
      return {
        message: mockResponse,
        intent: this.detectIntent(message),
        sessionAttributes: sessionAttributes,
        fulfillmentState: 'Fulfilled',
        audioStream: null
      };
      
    } catch (error) {
      console.error('Error processing message:', error);
      throw new Error(ERROR_MESSAGES.SERVICE);
    }
  }

  detectIntent(message) {
    const lowerMessage = message.toLowerCase();
    
    if (lowerMessage.includes('diet') || lowerMessage.includes('nutrition') || lowerMessage.includes('eat')) {
      return 'HealthyDietTips';
    } else if (lowerMessage.includes('exercise') || lowerMessage.includes('workout') || lowerMessage.includes('fitness')) {
      return 'ExerciseRecommendations';
    } else if (lowerMessage.includes('mental') || lowerMessage.includes('stress') || lowerMessage.includes('anxiety')) {
      return 'MentalWellnessAdvice';
    } else if (lowerMessage.includes('sleep') || lowerMessage.includes('insomnia')) {
      return 'SleepTips';
    } else if (lowerMessage.includes('water') || lowerMessage.includes('hydration')) {
      return 'HydrationInfo';
    } else {
      return 'FallbackIntent';
    }
  }

  getMockResponse(message) {
    const intent = this.detectIntent(message);
    
    const responses = {
      'HealthyDietTips': `Here's some excellent nutrition guidance:

🥗 Focus on whole foods - fruits, vegetables, lean proteins, and whole grains provide essential nutrients.

🍽️ Practice portion control using the plate method: half vegetables, quarter protein, quarter whole grains.

💧 Stay hydrated with 8-10 glasses of water daily to support all bodily functions.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance.`,

      'ExerciseRecommendations': `Here are some effective exercise strategies:

🏃‍♀️ Aim for at least 150 minutes of moderate aerobic activity or 75 minutes of vigorous activity per week.

💪 Include strength training exercises 2-3 times per week targeting all major muscle groups.

🧘‍♀️ Incorporate flexibility and balance exercises like yoga or tai chi into your routine.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance.`,

      'MentalWellnessAdvice': `Here are some mental wellness approaches:

🧘‍♀️ Practice mindfulness and meditation for 10-15 minutes daily to reduce stress and improve focus.

🌱 Maintain strong social connections - spend quality time with family and friends regularly.

📝 Keep a gratitude journal to focus on positive aspects of life and improve mental outlook.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance.`,

      'SleepTips': `Here are some sleep optimization tips:

😴 Maintain a consistent sleep schedule, going to bed and waking up at the same time daily.

📱 Create a relaxing bedtime routine - dim lights, avoid screens 1 hour before bed.

🌡️ Keep your bedroom cool (65-68°F), dark, and quiet for optimal sleep conditions.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance.`,

      'HydrationInfo': `Here's what you should know about proper hydration:

💧 Aim for about 8 glasses (64 oz) of water daily, but needs vary based on activity and climate.

🏃‍♀️ Increase water intake during exercise, hot weather, or when feeling unwell.

🍉 Include water-rich foods like fruits and vegetables to support hydration goals.

⚠️ Important: This is general health information for educational purposes only. Always consult with qualified healthcare providers for personalized medical guidance.`,

      'FallbackIntent': `Hello! I'm your Health Advice Assistant. I can provide guidance on:

🥗 Healthy nutrition and diet tips
🏃‍♀️ Exercise and fitness recommendations  
🧘‍♀️ Mental wellness and stress management
😴 Sleep improvement strategies
💧 Hydration and water intake guidance

What would you like to learn about today?`
    };

    return responses[intent] || responses['FallbackIntent'];
  }

  async sendVoiceMessage(audioBlob, sessionAttributes = {}) {
    return {
      message: "Voice features are available in the full AWS-integrated version. Please type your question for now.",
      intent: 'FallbackIntent',
      sessionAttributes: sessionAttributes,
      fulfillmentState: 'Fulfilled',
      audioStream: null,
      inputTranscript: 'Voice input (demo mode)'
    };
  }

  resetSession() {
    this.sessionId = this.generateSessionId();
    console.log('Session reset. New session ID:', this.sessionId);
  }

  getSessionId() {
    return this.sessionId;
  }

  isReady() {
    return this.isInitialized;
  }
}

const lexService = new LexService();
export default lexService;