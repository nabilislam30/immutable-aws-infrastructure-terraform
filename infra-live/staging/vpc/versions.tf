terraform {
  required_version = "~> 1.14.0"

  backend "s3" {
    bucket         = "fimatix-devops-starter-tfstate-442847318797"
    key            = "staging/vpc/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
