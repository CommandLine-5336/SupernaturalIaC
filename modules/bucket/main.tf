terraform {
  required_version = "1.15.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = format("%s-bucket-%s-%s-%s", var.name, var.env, var.caller_identity, var.region)
  tags = {
    Name        = var.name
    Environment = var.env
    Owner       = "CommandLine"
  }
  lifecycle {
    prevent_destroy = true
  }
}
