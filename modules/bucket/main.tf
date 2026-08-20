terraform {
  required_version = "1.15.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.58"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = format("%s-bucket-%s-%s-%s", var.env, var.name, var.caller_identity, var.region)
  tags = {
    Name        = var.name
    Environment = var.env
    Owner       = "CommandLine"
  }
  lifecycle {
    prevent_destroy = false
  }
}
