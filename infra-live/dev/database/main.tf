# -----------------------------------------------------------------------------
# Global Remote State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "fimatix-devops-starter-tfstate-442847318797"
    key    = "global/terraform.tfstate"
    region = "eu-west-2"
  }
}

# -----------------------------------------------------------------------------
# VPC Remote State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "fimatix-devops-starter-tfstate-442847318797"
    key    = "dev/vpc/terraform.tfstate"
    region = "eu-west-2"
  }
}

# -----------------------------------------------------------------------------
# Compute Remote State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket = "fimatix-devops-starter-tfstate-442847318797"
    key    = "dev/compute/terraform.tfstate"
    region = "eu-west-2"
  }
}

# -----------------------------------------------------------------------------
# RDS PostgreSQL
# -----------------------------------------------------------------------------

module "rds" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//rds?ref=v1.8.3"

  name = "dev"

  common_tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "DevOps-Starter"
  }

  vpc_id                    = data.terraform_remote_state.vpc.outputs.vpc_id
  database_subnet_ids       = data.terraform_remote_state.vpc.outputs.database_subnet_ids
  compute_security_group_id = data.terraform_remote_state.compute.outputs.compute_security_group_id

  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  database_name   = var.database_name
  master_username = var.master_username

  backup_retention_period = var.backup_retention_period

  deletion_protection = true
  multi_az            = false

  performance_insights_kms_key_id = data.terraform_remote_state.global.outputs.logs_kms_key_arn
}
