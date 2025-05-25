output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.health_advice_handler.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.health_advice_handler.function_name
}

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

output "lex_bot_alias_id" {
  description = "ID of the Lex bot alias"
  value       = aws_lexv2models_bot_alias.health_advice_bot_alias.bot_alias_id
}

output "lex_bot_alias_name" {
  description = "Name of the Lex bot alias"
  value       = aws_lexv2models_bot_alias.health_advice_bot_alias.bot_alias_name
}

output "aws_region" {
  description = "AWS region used for deployment"
  value       = var.aws_region
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

# Frontend integration configuration
output "frontend_config" {
  description = "Configuration values for frontend .env file"
  value = {
    REACT_APP_AWS_REGION        = var.aws_region
    REACT_APP_LEX_BOT_ID        = aws_lexv2models_bot.health_advice_bot.id
    REACT_APP_LEX_BOT_ALIAS_ID  = aws_lexv2models_bot_alias.health_advice_bot_alias.bot_alias_id
    REACT_APP_LEX_LOCALE_ID     = var.locale_id
  }
}

# Deployment summary
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    bot_id           = aws_lexv2models_bot.health_advice_bot.id
    bot_alias_id     = aws_lexv2models_bot_alias.health_advice_bot_alias.bot_alias_id
    lambda_function  = aws_lambda_function.health_advice_handler.function_name
    region          = var.aws_region
    environment     = var.environment
    log_group       = aws_cloudwatch_log_group.lambda_logs.name
  }
}