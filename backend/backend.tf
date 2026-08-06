terraform {
  backend "s3" {
    bucket       = "supernatural-s3-state"
    key          = "s3-backend/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
provider "aws" {
  region = var.aws_region
}
resource "aws_s3_bucket" "state_bucket" {
  bucket = "supernatural-s3-state"
  lifecycle {
    prevent_destroy = true
  }
}



resource "aws_s3_bucket_versioning" "Enabled" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encyption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
