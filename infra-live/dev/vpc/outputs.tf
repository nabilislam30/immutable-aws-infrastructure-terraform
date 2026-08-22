# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the development VPC."
  value       = module.vpc.vpc_id
}

# -----------------------------------------------------------------------------
# Public Subnets
# -----------------------------------------------------------------------------

output "public_subnet_ids" {
  description = "IDs of the development public subnets."
  value       = module.vpc.public_subnet_ids
}

# -----------------------------------------------------------------------------
# Private Subnets
# -----------------------------------------------------------------------------

output "private_subnet_ids" {
  description = "IDs of the development private subnets."
  value       = module.vpc.private_subnet_ids
}

# -----------------------------------------------------------------------------
# Database Subnets
# -----------------------------------------------------------------------------

output "database_subnet_ids" {
  description = "IDs of the development database subnets."
  value       = module.vpc.database_subnet_ids
}
