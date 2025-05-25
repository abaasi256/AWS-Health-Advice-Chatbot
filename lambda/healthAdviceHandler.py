"""
AWS Health Advice Chatbot Lambda Handler
Production-ready Lambda function providing health advice through Amazon Lex v2
"""

import json
import logging
import os
from typing import Dict, Any, List
import random

# Configure structured logging
log_level = os.environ.get('LOG_LEVEL', 'INFO')
environment = os.environ.get('ENVIRONMENT', 'dev')
project_name = os.environ.get('PROJECT_NAME', 'health-advice-chatbot')

logging.basicConfig(
    level=getattr(logging, log_level),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Comprehensive health advice database
HEALTH_ADVICE = {
    'HealthyDietTips': [
        "Focus on whole foods - fruits, vegetables, lean proteins, and whole grains provide essential nutrients.",
        "Practice portion control using the plate method: half vegetables, quarter protein, quarter whole grains.",
        "Stay hydrated with 8-10 glasses of water daily to support all bodily functions.",
        "Include healthy fats from sources like avocados, nuts, seeds, and olive oil.",
        "Limit processed foods, added sugars, and excessive sodium for better health outcomes.",
        "Eat the rainbow - different colored fruits and vegetables provide various vitamins and antioxidants.",
        "Include omega-3 rich foods like salmon, walnuts, and flaxseeds for brain and heart health."
    ],
    
    'ExerciseRecommendations': [
        "Aim for at least 150 minutes of moderate aerobic activity or 75 minutes of vigorous activity per week.",
        "Include strength training exercises 2-3 times per week targeting all major muscle groups.",
        "Incorporate flexibility and balance exercises like yoga or tai chi into your routine.",
        "Start slowly and gradually increase intensity to prevent injury and build sustainable habits.",
        "Find activities you enjoy - dancing, hiking, swimming, or sports make exercise more enjoyable.",
        "Try the 10,000 steps challenge - use a pedometer or smartphone to track daily movement.",
        "Include compound exercises like squats, deadlifts, and push-ups for maximum efficiency."
    ],
    
    'MentalWellnessAdvice': [
        "Practice mindfulness and meditation for 10-15 minutes daily to reduce stress and improve focus.",
        "Maintain strong social connections - spend quality time with family and friends regularly.",
        "Keep a gratitude journal to focus on positive aspects of life and improve mental outlook.",
        "Engage in regular physical activity, which naturally boosts mood and reduces anxiety.",
        "Prioritize quality sleep - it's fundamental for emotional regulation and mental clarity.",
        "Try the 4-7-8 breathing technique: inhale for 4, hold for 7, exhale for 8 counts.",
        "Practice the 5-4-3-2-1 grounding technique when feeling anxious or overwhelmed."
    ],
    
    'SleepTips': [
        "Maintain a consistent sleep schedule, going to bed and waking up at the same time daily.",
        "Create a relaxing bedtime routine - dim lights, avoid screens 1 hour before bed.",
        "Keep your bedroom cool (65-68°F), dark, and quiet for optimal sleep conditions.",
        "Avoid caffeine after 2 PM and large meals close to bedtime.",
        "Aim for 7-9 hours of sleep per night for optimal health and cognitive function.",
        "Try the 10-3-2-1-0 rule: 10h no caffeine, 3h no food, 2h no work, 1h no screens, 0 snoozes.",
        "Use blackout curtains or a sleep mask to block disruptive light."
    ],
    
    'HydrationInfo': [
        "Aim for about 8 glasses (64 oz) of water daily, but needs vary based on activity and climate.",
        "Increase water intake during exercise, hot weather, or when feeling unwell.",
        "Include water-rich foods like fruits and vegetables to support hydration goals.",
        "Choose water over sugary drinks to avoid empty calories and maintain energy levels.",
        "Monitor urine color - pale yellow indicates good hydration status.",
        "Start each day with a glass of water to kickstart hydration after overnight fasting.",
        "Add natural flavors like lemon, cucumber, or mint to make water more appealing."
    ]
}

def lambda_handler(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Main Lambda handler for Amazon Lex v2 events
    
    Args:
        event: Lex v2 event data containing user input and session information
        context: Lambda runtime context object
        
    Returns:
        Lex v2 response format with health advice
    """
    
    # Extract request information
    request_id = getattr(context, 'aws_request_id', 'local-test')
    input_transcript = event.get('inputTranscript', '')
    
    logger.info(f"Processing health advice request", extra={
        'request_id': request_id,
        'environment': environment,
        'input_length': len(input_transcript)
    })
    
    try:
        # Extract session attributes and intent information
        session_attributes = event.get('sessionAttributes', {})
        intent_name = extract_intent_name(event)
        
        logger.info(f"Identified intent: {intent_name}", extra={
            'request_id': request_id,
            'intent': intent_name
        })
        
        # Generate personalized health advice
        advice = get_health_advice(intent_name, session_attributes)
        
        # Create successful Lex v2 response
        response = create_success_response(intent_name, advice, session_attributes)
        
        logger.info(f"Successfully generated health advice", extra={
            'request_id': request_id,
            'intent': intent_name,
            'advice_length': len(advice)
        })
        
        return response
        
    except Exception as e:
        logger.error(f"Error processing health advice request: {str(e)}", extra={
            'request_id': request_id,
            'error_type': type(e).__name__
        }, exc_info=True)
        
        # Return error response in Lex v2 format
        return create_error_response(
            intent_name if 'intent_name' in locals() else 'FallbackIntent',
            "I apologize, but I'm experiencing technical difficulties. Please try again in a moment.",
            event.get('sessionAttributes', {})
        )

def extract_intent_name(event: Dict[str, Any]) -> str:
    """
    Extract intent name from various Lex v2 event formats
    
    Args:
        event: Lex v2 event data
        
    Returns:
        Intent name string
    """
    
    # Try different event structures for intent extraction
    if 'currentIntent' in event:
        return event['currentIntent'].get('name', 'FallbackIntent')
    
    if 'interpretations' in event and event['interpretations']:
        return event['interpretations'][0].get('intent', {}).get('name', 'FallbackIntent')
    
    if 'sessionState' in event and 'intent' in event['sessionState']:
        return event['sessionState']['intent'].get('name', 'FallbackIntent')
    
    return 'FallbackIntent'

def get_health_advice(intent_name: str, session_attributes: Dict[str, Any] = None) -> str:
    """
    Generate contextual health advice based on intent and session data
    
    Args:
        intent_name: Name of the Lex intent
        session_attributes: Session context for personalization
        
    Returns:
        Formatted health advice message
    """
    
    logger.info(f"Generating advice for intent: {intent_name}")
    
    if intent_name not in HEALTH_ADVICE:
        return get_fallback_advice()
    
    # Select contextual advice pieces
    advice_pool = HEALTH_ADVICE[intent_name]
    selected_advice = select_advice_items(advice_pool, session_attributes)
    
    # Build formatted response
    intro = get_intent_introduction(intent_name)
    advice_text = f"{intro}\n\n" + "\n\n".join(selected_advice)
    
    # Add health disclaimer
    disclaimer = get_health_disclaimer()
    
    return f"{advice_text}\n\n{disclaimer}"

def select_advice_items(advice_pool: List[str], session_attributes: Dict[str, Any] = None) -> List[str]:
    """
    Select relevant advice items from the pool
    
    Args:
        advice_pool: List of available advice items
        session_attributes: Session context for selection
        
    Returns:
        List of selected advice items
    """
    
    # For production: implement context-aware selection based on session_attributes
    # For now: return 2-3 random items for variety
    num_items = min(3, len(advice_pool))
    return random.sample(advice_pool, num_items)

def get_intent_introduction(intent_name: str) -> str:
    """
    Get personalized introduction based on intent
    
    Args:
        intent_name: Name of the intent
        
    Returns:
        Introduction message
    """
    
    introductions = {
        'HealthyDietTips': "Here's some excellent nutrition guidance:",
        'ExerciseRecommendations': "Here are some effective exercise strategies:",
        'MentalWellnessAdvice': "Here are some mental wellness approaches:",
        'SleepTips': "Here are some sleep optimization tips:",
        'HydrationInfo': "Here's what you should know about proper hydration:"
    }
    
    return introductions.get(intent_name, "Here's some health advice:")

def get_health_disclaimer() -> str:
    """
    Get standardized health disclaimer for all responses
    
    Returns:
        Health disclaimer text
    """
    
    return ("⚠️ Important: This is general health information for educational purposes only. "
            "It is not a substitute for professional medical advice, diagnosis, or treatment. "
            "Always consult with qualified healthcare providers for personalized medical guidance.")

def get_fallback_advice() -> str:
    """
    Provide fallback advice for unrecognized intents
    
    Returns:
        Fallback message with available topics
    """
    
    return ("Hello! I'm your Health Advice Assistant. I can provide guidance on:\n\n"
            "🥗 Healthy nutrition and diet tips\n"
            "🏃‍♀️ Exercise and fitness recommendations\n"
            "🧘‍♀️ Mental wellness and stress management\n"
            "😴 Sleep improvement strategies\n"
            "💧 Hydration and water intake guidance\n\n"
            "What would you like to learn about today?")

def create_success_response(intent_name: str, message: str, session_attributes: Dict[str, Any]) -> Dict[str, Any]:
    """
    Create successful Lex v2 response format
    
    Args:
        intent_name: Name of the intent
        message: Response message
        session_attributes: Session attributes to maintain
        
    Returns:
        Lex v2 formatted response
    """
    
    return {
        "sessionState": {
            "dialogAction": {
                "type": "Close"
            },
            "intent": {
                "name": intent_name,
                "state": "Fulfilled"
            },
            "sessionAttributes": session_attributes
        },
        "messages": [
            {
                "contentType": "PlainText",
                "content": message
            }
        ]
    }

def create_error_response(intent_name: str, message: str, session_attributes: Dict[str, Any]) -> Dict[str, Any]:
    """
    Create error Lex v2 response format
    
    Args:
        intent_name: Name of the intent
        message: Error message
        session_attributes: Session attributes to maintain
        
    Returns:
        Lex v2 formatted error response
    """
    
    return {
        "sessionState": {
            "dialogAction": {
                "type": "Close"
            },
            "intent": {
                "name": intent_name,
                "state": "Failed"
            },
            "sessionAttributes": session_attributes
        },
        "messages": [
            {
                "contentType": "PlainText",
                "content": message
            }
        ]
    }

# Local testing capability
if __name__ == "__main__":
    # Test with sample Lex v2 event
    test_events = [
        {
            "sessionAttributes": {},
            "currentIntent": {"name": "HealthyDietTips"},
            "inputTranscript": "Give me healthy diet tips",
            "bot": {"id": "test", "name": "HealthAdviceBot"}
        },
        {
            "sessionAttributes": {},
            "currentIntent": {"name": "ExerciseRecommendations"},
            "inputTranscript": "What exercises should I do",
            "bot": {"id": "test", "name": "HealthAdviceBot"}
        }
    ]
    
    class MockContext:
        aws_request_id = "test-12345"
    
    print("Testing Lambda handler locally:")
    for i, event in enumerate(test_events, 1):
        print(f"\n--- Test {i}: {event['currentIntent']['name']} ---")
        result = lambda_handler(event, MockContext())
        print(f"Response: {result['messages'][0]['content'][:200]}...")
