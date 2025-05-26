# outputs.tf - AWS Health Advice Chatbot Outputs (Lambda Integration)

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

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.health_advice_handler.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.health_advice_handler.arn
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
    REACT_APP_AWS_REGION    = var.aws_region
    REACT_APP_LEX_BOT_ID    = aws_lexv2models_bot.health_advice_bot.id
    REACT_APP_LEX_LOCALE_ID = var.locale_id
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

output "lambda_iam_role_arn" {
  description = "ARN of the IAM role used by Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_iam_role_name" {
  description = "Name of the IAM role used by Lambda"
  value       = aws_iam_role.lambda_role.name
}

# Deployment summary
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    bot_id           = aws_lexv2models_bot.health_advice_bot.id
    bot_name         = aws_lexv2models_bot.health_advice_bot.name
    lambda_function  = aws_lambda_function.health_advice_handler.function_name
    locale_id        = aws_lexv2models_bot_locale.health_advice_bot_locale.locale_id
    region           = var.aws_region
    environment      = var.environment
    project_name     = var.project_name
    intent_count     = 5
    architecture     = "lambda-fulfillment-draft"
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
    note = "Bot uses Lambda fulfillment with DRAFT version (aliases not supported in Terraform yet)"
    lambda_logs = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups/log-group/$252Faws$252Flambda$252F${aws_lambda_function.health_advice_handler.function_name}"
  }
}

# Manual alias creation instructions
output "manual_alias_instructions" {
  description = "Instructions to manually create bot alias with Lambda integration"
  value = {
    note = "Bot aliases are not yet supported in Terraform. To create an alias manually:"
    steps = [
      "1. Go to the Lex console",
      "2. Open your bot: ${aws_lexv2models_bot.health_advice_bot.name}",
      "3. Create a bot version from DRAFT",
      "4. Create an alias pointing to that version", 
      "5. In alias settings, configure Lambda: ${aws_lambda_function.health_advice_handler.arn}"
    ]
    lambda_arn = aws_lambda_function.health_advice_handler.arn
  }
}
