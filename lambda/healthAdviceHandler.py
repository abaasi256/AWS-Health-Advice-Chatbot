"""
AWS Health Advice Chatbot Lambda Handler
Simplified Lambda function for Lex v2 fulfillment
"""

import json
import logging
import random

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Health advice database - simplified for reliable fulfillment
HEALTH_ADVICE = {
    'DietTips': [
        "Focus on whole foods like fruits, vegetables, lean proteins, and whole grains. Practice portion control and stay hydrated throughout the day.",
        "Include healthy fats from sources like avocados, nuts, and olive oil. Limit processed foods and added sugars for better health outcomes.",
        "Eat the rainbow - different colored fruits and vegetables provide various vitamins and antioxidants your body needs daily."
    ],
    
    'ExerciseTips': [
        "Aim for at least 150 minutes of moderate aerobic activity or 75 minutes of vigorous activity per week.",
        "Include strength training exercises 2-3 times per week targeting all major muscle groups for optimal fitness.",
        "Try compound exercises like squats, deadlifts, and push-ups for maximum efficiency. Start slowly and gradually increase intensity."
    ],
    
    'MentalWellness': [
        "Practice mindfulness and meditation for 10-15 minutes daily to reduce stress and improve focus.",
        "Maintain strong social connections with family and friends. Keep a gratitude journal to focus on positive aspects of life.",
        "Engage in regular physical activity, which naturally boosts mood and reduces anxiety. Prioritize quality sleep for emotional regulation."
    ],
    
    'SleepAdvice': [
        "Maintain a consistent sleep schedule, going to bed and waking up at the same time daily, even on weekends.",
        "Create a relaxing bedtime routine and avoid screens 1 hour before bed. Keep your bedroom cool (65-68°F), dark, and quiet.",
        "Avoid caffeine after 2 PM and large meals close to bedtime. Aim for 7-9 hours of sleep per night for optimal health."
    ],
    
    'WaterInfo': [
        "Aim for about 8 glasses (64 oz) of water daily, but needs vary based on activity level and climate conditions.",
        "Increase water intake during exercise, hot weather, or when feeling unwell. Monitor urine color - pale yellow indicates good hydration.",
        "Include water-rich foods like fruits and vegetables to support hydration goals. Choose water over sugary drinks for better health."
    ]
}

def lambda_handler(event, context):
    """
    Main Lambda handler for Lex v2 fulfillment
    """
    
    logger.info(f"Received event: {json.dumps(event)}")
    
    try:
        # Extract intent information from Lex v2 event
        intent_name = get_intent_name(event)
        session_attributes = event.get('sessionAttributes', {})
        
        logger.info(f"Processing intent: {intent_name}")
        
        # Generate health advice
        advice = get_health_advice(intent_name)
        
        # Create Lex v2 fulfillment response
        response = {
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
                    "content": advice
                }
            ]
        }
        
        logger.info(f"Returning response for intent: {intent_name}")
        return response
        
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        
        return {
            "sessionState": {
                "dialogAction": {
                    "type": "Close"
                },
                "intent": {
                    "name": "FallbackIntent",
                    "state": "Failed"
                },
                "sessionAttributes": {}
            },
            "messages": [
                {
                    "contentType": "PlainText",
                    "content": "I apologize, but I'm experiencing technical difficulties. Please try again in a moment."
                }
            ]
        }

def get_intent_name(event):
    """
    Extract intent name from Lex v2 event
    """
    # Try different event structures
    if 'sessionState' in event and 'intent' in event['sessionState']:
        return event['sessionState']['intent']['name']
    
    if 'currentIntent' in event:
        return event['currentIntent']['name']
        
    if 'interpretations' in event and event['interpretations']:
        return event['interpretations'][0]['intent']['name']
    
    return 'FallbackIntent'

def get_health_advice(intent_name):
    """
    Get health advice for the specified intent
    """
    if intent_name not in HEALTH_ADVICE:
        return get_fallback_advice()
    
    # Select random advice from the pool
    advice_pool = HEALTH_ADVICE[intent_name]
    selected_advice = random.choice(advice_pool)
    
    # Add health disclaimer
    disclaimer = ("\n\n⚠️ Important: This is general health information for educational purposes only. "
                 "Always consult with qualified healthcare providers for personalized medical guidance.")
    
    return f"{selected_advice}{disclaimer}"

def get_fallback_advice():
    """
    Provide fallback advice for unrecognized intents
    """
    return ("Hello! I'm your Health Advice Assistant. I can provide guidance on healthy eating, "
            "exercise, mental wellness, sleep, and hydration. What would you like to learn about today?")

# Test function for local testing
if __name__ == "__main__":
    # Test event
    test_event = {
        "sessionState": {
            "intent": {
                "name": "DietTips"
            }
        },
        "sessionAttributes": {}
    }
    
    class MockContext:
        aws_request_id = "test-12345"
    
    result = lambda_handler(test_event, MockContext())
    print(json.dumps(result, indent=2))
