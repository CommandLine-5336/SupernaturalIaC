terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}
provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket       = "supernatural-s3-state"
    key          = "s3-backend/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

resource "aws_ecr_repository" "services" {
  for_each             = var.ecr_services
  name                 = each.key
  image_tag_mutability = var.image_mutability
  encryption_configuration {
    encryption_type = var.encrypt_type
  }
  # image_scanning_configuration {
  #   scan_on_push = true # Automatically scan for vulnerabilities
  # }
  tags = {
    Service   = each.value
    ManagedBy = "terraform"
  }
}