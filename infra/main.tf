# AWS Health Advice Chatbot Infrastructure
# Fixed Terraform configuration for Lex v2 Bot with proper Lambda fulfillment permissions

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
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

# Lambda deployment package
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/lambda_function.zip"
  excludes    = ["__pycache__", "*.pyc"]
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Component = "Lambda"
    Security  = "IAM"
  }
}

# Lambda basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Lambda Function
resource "aws_lambda_function" "health_advice_handler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-handler"
  role            = aws_iam_role.lambda_role.arn
  handler         = "healthAdviceHandler.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      LOG_LEVEL    = "INFO"
      ENVIRONMENT  = var.environment
      PROJECT_NAME = var.project_name
    }
  }

  tags = {
    Component = "Lambda"
    Purpose   = "LexFulfillment"
  }
}

# Lambda permission for Lex to invoke the function - Bot level
resource "aws_lambda_permission" "allow_lex_bot" {
  statement_id  = "AllowExecutionFromLexBot"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_advice_handler.function_name
  principal     = "lexv2.amazonaws.com"
  source_arn    = "${aws_lexv2models_bot.health_advice_bot.arn}/*"
}

# Lambda permission for Lex to invoke the function - Bot Alias level
resource "aws_lambda_permission" "allow_lex_bot_alias" {
  statement_id  = "AllowExecutionFromLexBotAlias"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_advice_handler.function_name
  principal     = "lexv2.amazonaws.com"
  source_arn    = "arn:aws:lex:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:bot-alias/${aws_lexv2models_bot.health_advice_bot.id}/*"
}

# Lambda permission for Lex to invoke the function - Wildcard for any alias
resource "aws_lambda_permission" "allow_lex_wildcard" {
  statement_id  = "AllowExecutionFromLexWildcard"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_advice_handler.function_name
  principal     = "lexv2.amazonaws.com"
  source_arn    = "arn:aws:lex:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:bot/${aws_lexv2models_bot.health_advice_bot.id}/*"
}

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

# Enhanced Policy for Lex to invoke Lambda
resource "aws_iam_role_policy" "lex_lambda_policy" {
  name = "${var.project_name}-lex-lambda-policy"
  role = aws_iam_role.lex_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.health_advice_handler.arn,
          "${aws_lambda_function.health_advice_handler.arn}:*"
        ]
      }
    ]
  })
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

# Health Intent Definitions with Lambda fulfillment
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

  # Enable Lambda fulfillment
  fulfillment_code_hook {
    enabled = true
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

  # Enable Lambda fulfillment
  fulfillment_code_hook {
    enabled = true
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

  # Enable Lambda fulfillment
  fulfillment_code_hook {
    enabled = true
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

  # Enable Lambda fulfillment
  fulfillment_code_hook {
    enabled = true
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

  # Enable Lambda fulfillment
  fulfillment_code_hook {
    enabled = true
  }
}
