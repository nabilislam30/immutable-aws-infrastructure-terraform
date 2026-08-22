resource "aws_s3_bucket" "terraform_state" {
  bucket = "fimatix-devops-starter-tfstate-442847318797"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "security_baseline" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//security-baseline?ref=v1.8.4"
}

module "guardrails" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//guardrails?ref=v1.8.9"

  developers_ro_role_name = "DevelopersRO"
}
module "iam_roles" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//iam-roles?ref=v1.8.13"

  dev_permission_boundary_policy_arn     = module.guardrails.dev_deployment_permission_boundary_policy_arn
  staging_permission_boundary_policy_arn = module.guardrails.staging_deployment_permission_boundary_policy_arn
  prod_permission_boundary_policy_arn    = module.guardrails.prod_deployment_permission_boundary_policy_arn

  deny_unapproved_regions_policy_arn   = module.guardrails.deny_unapproved_regions_policy_arn
  protect_security_services_policy_arn = module.guardrails.protect_security_services_policy_arn
  deny_iam_user_creation_policy_arn    = module.guardrails.deny_iam_user_creation_policy_arn
}

module "monitoring" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//monitoring?ref=v1.3.3"

  project_name              = "devops-starter"
  environment               = var.environment
  cloudtrail_log_group_name = module.security_baseline.cloudtrail_log_group_name
  alarm_email_endpoint      = var.alarm_email_endpoint
  common_tags               = var.tags
}

module "budgets" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//budgets?ref=v1.4.0"

  budget_name        = "monthly-global-budget"
  monthly_limit      = 100
  notification_email = var.alarm_email_endpoint
}

module "anomaly_detection" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//anomaly-detection?ref=v1.4.0"

  monitor_name       = "global-cost-monitor"
  subscription_name  = "daily-cost-anomalies"
  notification_email = var.alarm_email_endpoint
  threshold_usd      = 10
}
