terraform {
  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.56.0"
    }
  }

  backend "s3" {
    bucket         = "fimatix-devops-starter-tfstate-442847318797"
    key            = "dev/compute/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
