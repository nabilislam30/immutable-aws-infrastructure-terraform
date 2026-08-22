variable "aws_region" {
  description = "AWS region for global resources."
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "global"
}

variable "tags" {
  description = "Common tags for global resources."
  type        = map(string)

  default = {
    Environment = "global"
    ManagedBy   = "Terraform"
    Project     = "DevOps-Starter"
  }
}

variable "alarm_email_endpoint" {
  description = "Email address used for monitoring alerts."
  type        = string
}
