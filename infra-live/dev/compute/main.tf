# -----------------------------------------------------------------------------
# Terraform Remote State
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
# Database Remote State
# -----------------------------------------------------------------------------

data "terraform_remote_state" "database" {
  backend = "s3"

  config = {
    bucket = "fimatix-devops-starter-tfstate-442847318797"
    key    = "dev/database/terraform.tfstate"
    region = "eu-west-2"
  }
}

# -----------------------------------------------------------------------------
# Golden AMI
# -----------------------------------------------------------------------------

data "aws_ami" "golden_ami" {
  most_recent = true

  owners = [
    "self"
  ]

  filter {
    name = "name"

    values = [
      "dev-golden-ami-*"
    ]
  }

  filter {
    name = "state"

    values = [
      "available"
    ]
  }
}

# -----------------------------------------------------------------------------
# Local Values
# -----------------------------------------------------------------------------

locals {
  common_tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "DevOps-Starter"
  }
}

# -----------------------------------------------------------------------------
# Image Builder Security Group
# -----------------------------------------------------------------------------

# Image Builder requires outbound HTTPS for package updates and AWS service access.
# Egress is restricted to TCP/443; no ingress is permitted.
# trivy:ignore:AWS-0104

resource "aws_security_group" "image_builder" {
  name        = "dev-golden-ami-image-builder"
  description = "Security group for EC2 Image Builder build instances."
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = local.common_tags
}

# trivy:ignore:AWS-0104
resource "aws_vpc_security_group_egress_rule" "image_builder" {
  security_group_id = aws_security_group.image_builder.id

  description = "Allow HTTPS egress for Image Builder package updates and AWS service access."

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Golden AMI Pipeline
# -----------------------------------------------------------------------------

module "ami_pipeline" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//ami-pipeline?ref=v1.8.11"

  name = "dev"

  parent_image = "ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  recipe_version    = "1.0.0"
  component_version = "1.0.1"

  component_document = <<-YAML
  name: DevGoldenAMI
  description: Build and harden the development Golden AMI.
  schemaVersion: 1.0

  phases:
    - name: build
      steps:
        - name: UpdateOperatingSystem
          action: ExecuteBash
          inputs:
            commands:
              - dnf upgrade -y

        - name: InstallApplicationPackages
          action: ExecuteBash
          inputs:
            commands:
              - dnf install -y httpd postgresql15
              - echo "healthy" > /var/www/html/health

        - name: EnableWebServer
          action: ExecuteBash
          inputs:
            commands:
              - systemctl enable httpd
              - systemctl start httpd

        - name: EnableSSMAgent
          action: ExecuteBash
          inputs:
            commands:
              - systemctl enable amazon-ssm-agent
              - systemctl start amazon-ssm-agent
YAML

  instance_type = "t3.micro"

  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet_ids[0]

  security_group_ids = [
    aws_security_group.image_builder.id
  ]

  distribution_region = "eu-west-2"

  common_tags = local.common_tags
}

# -----------------------------------------------------------------------------
# Immutable Compute - ASG + ALB
# -----------------------------------------------------------------------------

module "compute_asg" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//compute-asg?ref=v1.8.7"

  name = "dev"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  public_subnet_ids           = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  compute_subnet_ids          = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  database_security_group_id  = data.terraform_remote_state.database.outputs.database_security_group_id
  database_secret_arn         = data.terraform_remote_state.database.outputs.master_user_secret_arn
  database_secret_kms_key_arn = "arn:aws:kms:eu-west-2:442847318797:key/fa6d6768-bf0d-4af6-85b7-82aeda12f969"

  associate_public_ip_address = true

  ami_id = data.aws_ami.golden_ami.id

  instance_type = "t3.micro"

  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  application_port  = 80
  health_check_path = "/health"

  enable_ssh = true
  key_name   = var.key_name
  my_ip      = var.my_ip

  common_tags = local.common_tags
}
