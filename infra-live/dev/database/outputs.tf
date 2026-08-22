# -----------------------------------------------------------------------------
# RDS Instance
# -----------------------------------------------------------------------------

output "db_instance_id" {
  description = "ID of the development PostgreSQL RDS instance."
  value       = module.rds.db_instance_id
}

output "db_instance_arn" {
  description = "ARN of the development PostgreSQL RDS instance."
  value       = module.rds.db_instance_arn
}

output "db_endpoint" {
  description = "Connection endpoint of the development PostgreSQL RDS instance."
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "Port used by the development PostgreSQL RDS instance."
  value       = module.rds.db_port
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

output "database_security_group_id" {
  description = "Security group ID attached to the development PostgreSQL RDS instance."
  value       = module.rds.database_security_group_id
}

output "db_subnet_group_name" {
  description = "Name of the development RDS database subnet group."
  value       = module.rds.db_subnet_group_name
}

# -----------------------------------------------------------------------------
# Secrets Manager
# -----------------------------------------------------------------------------

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret managed by RDS for the master user."
  value       = module.rds.master_user_secret_arn
}
