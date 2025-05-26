variable "aws_region" {
  description = "AWS region for deploying resources"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "health-advice-chatbot"
  
  validation {
    condition = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "bot_name" {
  description = "Name of the Lex bot"
  type        = string
  default     = "HealthAdviceBot"
  
  validation {
    condition = length(var.bot_name) >= 2 && length(var.bot_name) <= 100
    error_message = "Bot name must be between 2 and 100 characters."
  }
}

variable "locale_id" {
  description = "Locale ID for the bot"
  type        = string
  default     = "en_US"
  
  validation {
    condition = contains(["en_US", "en_GB", "es_ES", "fr_FR", "de_DE"], var.locale_id)
    error_message = "Locale must be one of: en_US, en_GB, es_ES, fr_FR, de_DE."
  }
}
