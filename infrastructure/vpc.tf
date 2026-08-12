module "custom_vpc" {
  source              = "../modules/vpc"
  vpc_name            = "myvpc"
  azs                 = ["us-east-1a", "us-east-1b"]
  vpc_cidr            = "10.0.0.0/16"
  private_app_subnets = ["10.0.40.0/24", "10.0.41.0/24"]
  private_db_subnets  = ["10.0.30.0/24", "10.0.31.0/24"]
  public_subnets      = ["10.0.55.0/24", "10.0.56.0/24"]
  ecr_sg_id           = aws_security_group.ecr_endpoint_sg.id
}
