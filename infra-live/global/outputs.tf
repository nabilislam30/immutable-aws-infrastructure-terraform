output "cloudtrail_logs_bucket_arn" {
  description = "ARN of the central S3 bucket used for CloudTrail and VPC Flow Logs."
  value       = module.security_baseline.cloudtrail_logs_bucket_arn
}

# -----------------------------------------------------------------------------
# KMS
# -----------------------------------------------------------------------------
output "logs_kms_key_arn" {
  description = "ARN of the customer-managed KMS key from the global security baseline."
  value       = module.security_baseline.logs_kms_key_arn
}
