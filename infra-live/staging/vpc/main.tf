data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket  = "fimatix-devops-starter-tfstate-442847318797"
    key     = "global/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

module "vpc" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//vpc?ref=v1.5.1"

  name       = "staging-vpc"
  aws_region = "eu-west-2"

  vpc_cidr = "10.20.0.0/16"

  availability_zones = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c"
  ]

  public_subnet_cidrs = [
    "10.20.1.0/24",
    "10.20.2.0/24",
    "10.20.3.0/24"
  ]

  private_subnet_cidrs = [
    "10.20.11.0/24",
    "10.20.12.0/24",
    "10.20.13.0/24"
  ]

  database_subnet_cidrs = [
    "10.20.21.0/24",
    "10.20.22.0/24",
    "10.20.23.0/24"
  ]

  nat_gateway_strategy = "single"

  flow_log_destination_arn = data.terraform_remote_state.global.outputs.cloudtrail_logs_bucket_arn

  common_tags = {
    Environment = "staging"
    ManagedBy   = "Terraform"
    Project     = "DevOps-Starter"
  }
}
