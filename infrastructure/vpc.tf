module "custom_vpc" {
  source              = "../modules/vpc"
  vpc_name            = "myvpc"
  azs                 = ["us-east-1a", "us-east-1b"]
  vpc_cidr            = "10.0.0.0/16"
  private_app_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  private_db_subnets  = ["10.0.20.0/24", "10.0.21.0/24"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
}
