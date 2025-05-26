# AWS Health Advice Chatbot Infrastructure
# Minimal Terraform configuration for Lex v2 Bot with static responses only

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repository  = "aws-health-advice-chatbot"
    }
  }
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IAM Role for Lex
resource "aws_iam_role" "lex_role" {
  name = "${var.project_name}-lex-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lexv2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Component = "Lex"
    Security  = "IAM"
  }
}

# Lex v2 Bot
resource "aws_lexv2models_bot" "health_advice_bot" {
  name     = var.bot_name
  role_arn = aws_iam_role.lex_role.arn

  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = false
  }

  tags = {
    Component = "Lex"
    AI        = "NLU"
  }
}

# Lex Bot Locale
resource "aws_lexv2models_bot_locale" "health_advice_bot_locale" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = var.locale_id

  n_lu_intent_confidence_threshold = 0.40
  
  voice_settings {
    voice_id = "Joanna"
    engine   = "neural"
  }
}

# Health Intent Definitions - All using minimal static configuration
resource "aws_lexv2models_intent" "diet_tips" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "DietTips"

  sample_utterance {
    utterance = "Give me healthy diet tips"
  }
  sample_utterance {
    utterance = "What should I eat to stay healthy"
  }
  sample_utterance {
    utterance = "I need nutrition advice"
  }
  sample_utterance {
    utterance = "Tell me about healthy eating"
  }
  sample_utterance {
    utterance = "What foods are good for me"
  }

  closing_setting {
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Here are some healthy diet tips: Focus on whole foods like fruits, vegetables, lean proteins, and whole grains. Practice portion control and stay hydrated. Include healthy fats from sources like avocados, nuts, and olive oil. Limit processed foods and added sugars for better health outcomes."
          }
        }
      }
    }
  }
}

resource "aws_lexv2models_intent" "water_info" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "WaterInfo"

  sample_utterance {
    utterance = "How much water should I drink"
  }
  sample_utterance {
    utterance = "Tell me about hydration"
  }
  sample_utterance {
    utterance = "Water intake recommendations"
  }
  sample_utterance {
    utterance = "Am I drinking enough water"
  }
  sample_utterance {
    utterance = "Benefits of staying hydrated"
  }

  closing_setting {
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Aim for about 8 glasses (64 oz) of water daily. Increase intake during exercise and hot weather. Include water-rich foods like fruits and vegetables. Choose water over sugary drinks for better health and energy levels."
          }
        }
      }
    }
  }
}

resource "aws_lexv2models_intent" "exercise_tips" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "ExerciseTips"

  sample_utterance {
    utterance = "What exercises should I do"
  }
  sample_utterance {
    utterance = "Give me workout recommendations"
  }
  sample_utterance {
    utterance = "I need fitness advice"
  }
  sample_utterance {
    utterance = "How should I exercise"
  }
  sample_utterance {
    utterance = "What's a good workout routine"
  }

  closing_setting {
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Here are some exercise recommendations: Aim for at least 150 minutes of moderate aerobic activity per week. Include strength training 2-3 times per week targeting all major muscle groups. Try compound exercises like squats, deadlifts, and push-ups. Start slowly and gradually increase intensity to prevent injury."
          }
        }
      }
    }
  }
}

resource "aws_lexv2models_intent" "mental_wellness" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "MentalWellness"

  sample_utterance {
    utterance = "Give me mental wellness tips"
  }
  sample_utterance {
    utterance = "How can I improve my mental health"
  }
  sample_utterance {
    utterance = "I need stress management advice"
  }
  sample_utterance {
    utterance = "Help me with anxiety"
  }
  sample_utterance {
    utterance = "What can I do for my mental wellbeing"
  }

  closing_setting {
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Here are some mental wellness tips: Practice mindfulness and meditation for 10-15 minutes daily. Maintain strong social connections with family and friends. Keep a gratitude journal to focus on positive aspects of life. Engage in regular physical activity to boost mood naturally. Prioritize quality sleep for emotional regulation."
          }
        }
      }
    }
  }
}

resource "aws_lexv2models_intent" "sleep_advice" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "SleepAdvice"

  sample_utterance {
    utterance = "How can I sleep better"
  }
  sample_utterance {
    utterance = "Give me sleep advice"
  }
  sample_utterance {
    utterance = "I have trouble sleeping"
  }
  sample_utterance {
    utterance = "What helps with insomnia"
  }
  sample_utterance {
    utterance = "Sleep hygiene tips"
  }

  closing_setting {
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Here are some sleep tips: Maintain a consistent sleep schedule, going to bed and waking up at the same time daily. Create a relaxing bedtime routine and avoid screens 1 hour before bed. Keep your bedroom cool (65-68°F), dark, and quiet. Avoid caffeine after 2 PM and aim for 7-9 hours of sleep per night."
          }
        }
      }
    }
  }
}
