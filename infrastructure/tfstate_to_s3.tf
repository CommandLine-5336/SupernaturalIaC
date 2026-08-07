terraform {
  backend "s3" {
    bucket       = "supernatural-s3-state"
    key          = "s3-backend/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
