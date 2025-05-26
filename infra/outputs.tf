# outputs.tf - AWS Health Advice Chatbot V2 Outputs (Static Responses Only)

output "lex_bot_id" {
  description = "ID of the Lex bot"
  value       = aws_lexv2models_bot.health_advice_bot.id
}

output "lex_bot_arn" {
  description = "ARN of the Lex bot"
  value       = aws_lexv2models_bot.health_advice_bot.arn
}

output "lex_bot_name" {
  description = "Name of the Lex bot"
  value       = aws_lexv2models_bot.health_advice_bot.name
}

output "lex_bot_locale_id" {
  description = "Locale ID of the Lex bot"
  value       = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
}

output "aws_region" {
  description = "AWS region used for deployment"
  value       = var.aws_region
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "project_name" {
  description = "Name of the project"
  value       = var.project_name
}

# Frontend integration configuration
output "frontend_config" {
  description = "Configuration values for frontend .env file"
  value = {
    REACT_APP_AWS_REGION        = var.aws_region
    REACT_APP_LEX_BOT_ID        = aws_lexv2models_bot.health_advice_bot.id
    REACT_APP_LEX_LOCALE_ID     = var.locale_id
  }
}

# Intent information
output "bot_intents" {
  description = "List of configured bot intents"
  value = {
    diet_tips       = aws_lexv2models_intent.diet_tips.name
    water_info      = aws_lexv2models_intent.water_info.name
    exercise_tips   = aws_lexv2models_intent.exercise_tips.name
    mental_wellness = aws_lexv2models_intent.mental_wellness.name
    sleep_advice    = aws_lexv2models_intent.sleep_advice.name
  }
}

# IAM role information
output "lex_iam_role_arn" {
  description = "ARN of the IAM role used by Lex"
  value       = aws_iam_role.lex_role.arn
}

output "lex_iam_role_name" {
  description = "Name of the IAM role used by Lex"
  value       = aws_iam_role.lex_role.name
}

# Deployment summary
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    bot_id         = aws_lexv2models_bot.health_advice_bot.id
    bot_name       = aws_lexv2models_bot.health_advice_bot.name
    locale_id      = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
    region         = var.aws_region
    environment    = var.environment
    project_name   = var.project_name
    intent_count   = 5
    architecture   = "static-responses-only"
  }
}

# Testing information
output "test_bot_instructions" {
  description = "Instructions for testing the bot"
  value = {
    console_url = "https://${var.aws_region}.console.aws.amazon.com/lexv2/home?region=${var.aws_region}#bot/${aws_lexv2models_bot.health_advice_bot.id}"
    test_phrases = [
      "Give me healthy diet tips",
      "How much water should I drink",
      "What exercises should I do",
      "Give me mental wellness tips",
      "How can I sleep better"
    ]
    note = "Bot uses static responses only - no Lambda integration required"
  }
}
