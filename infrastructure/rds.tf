module "rds_instance" {
  source            = "../modules/rds"
  identifier        = "microservice-db"
  instance_type     = "db.t4g.micro"
  storage_type      = "gp3"
  engine            = "postgres"
  allocated_storage = 20

  rds_name            = var.rds_name
  rds_user            = var.rds_user
  rds_password        = var.rds_password
  publicly_accessible = true # test for  maksym


  subnet_ids             = module.custom_vpc.public_subnets_id # test for  maksym
  vpc_security_group_ids = [aws_security_group.public_db_sg.id]
}
