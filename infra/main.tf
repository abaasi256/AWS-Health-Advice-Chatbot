# AWS Health Advice Chatbot Infrastructure
# Production-ready Terraform configuration for Lex v2 Bot, Lambda, and supporting AWS resources

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
  excludes    = ["__pycache__", "*.pyc", "test_*.py"]
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

# Enhanced IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_name}-*:*"
      }
    ]
  })
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-handler"
  retention_in_days = 14

  tags = {
    Component = "Lambda"
    Security  = "Logging"
  }
}

# Lambda function with optimized configuration
resource "aws_lambda_function" "health_advice_handler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-handler"
  role            = aws_iam_role.lambda_role.arn
  handler         = "healthAdviceHandler.lambda_handler"
  runtime         = "python3.11"
  timeout         = 15
  memory_size     = 256
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      LOG_LEVEL    = var.log_level
      ENVIRONMENT  = var.environment
      PROJECT_NAME = var.project_name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_policy,
    aws_cloudwatch_log_group.lambda_logs
  ]

  tags = {
    Component = "Lambda"
    Runtime   = "Python3.11"
  }
}

# Lambda permission for Lex
resource "aws_lambda_permission" "lex_invoke_lambda" {
  statement_id  = "AllowExecutionFromLex"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_advice_handler.function_name
  principal     = "lexv2.amazonaws.com"
  source_arn    = "${aws_lexv2models_bot.health_advice_bot.arn}/*"
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

# IAM Policy for Lex
resource "aws_iam_role_policy" "lex_policy" {
  name = "${var.project_name}-lex-policy"
  role = aws_iam_role.lex_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = aws_lambda_function.health_advice_handler.arn
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

  depends_on = [aws_iam_role_policy.lex_policy]

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

# Health Intent Definitions
resource "aws_lexv2models_intent" "healthy_diet_tips" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "HealthyDietTips"

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
  sample_utterance {
    utterance = "I need help with healthy eating habits"
  }

  fulfillment_code_hook {
    enabled = true
  }
}

resource "aws_lexv2models_intent" "exercise_recommendations" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "ExerciseRecommendations"

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

  fulfillment_code_hook {
    enabled = true
  }
}

resource "aws_lexv2models_intent" "mental_wellness_advice" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "MentalWellnessAdvice"

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

  fulfillment_code_hook {
    enabled = true
  }
}

resource "aws_lexv2models_intent" "sleep_tips" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "SleepTips"

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

  fulfillment_code_hook {
    enabled = true
  }
}

resource "aws_lexv2models_intent" "hydration_info" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
  name        = "HydrationInfo"

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

  fulfillment_code_hook {
    enabled = true
  }
}

# Bot Version
resource "aws_lexv2models_bot_version" "health_advice_bot_version" {
  bot_id      = aws_lexv2models_bot.health_advice_bot.id
  locale_specification = {
    (aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id) = {
      source_bot_version = "DRAFT"
    }
  }
  
  depends_on = [
    aws_lexv2models_intent.healthy_diet_tips,
    aws_lexv2models_intent.exercise_recommendations,
    aws_lexv2models_intent.mental_wellness_advice,
    aws_lexv2models_intent.sleep_tips,
    aws_lexv2models_intent.hydration_info
  ]
}

# Bot Alias with Lambda Integration
resource "aws_lexv2models_bot_alias" "health_advice_bot_alias" {
  bot_alias_name = var.bot_alias_name
  bot_id         = aws_lexv2models_bot.health_advice_bot.id
  bot_version    = aws_lexv2models_bot_version.health_advice_bot_version.bot_version

  bot_alias_locale_settings {
    locale_id = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
    
    code_hook_specification {
      lambda_code_hook {
        lambda_arn                = aws_lambda_function.health_advice_handler.arn
        code_hook_interface_version = "1.0"
      }
    }
  }

  depends_on = [
    aws_lexv2models_bot_version.health_advice_bot_version,
    aws_lambda_permission.lex_invoke_lambda
  ]
}