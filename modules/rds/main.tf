
# ignore all using keyword
# tflint-ignore: all

terraform {
  required_version = "1.15.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.58"
    }
  }
}


resource "aws_secretsmanager_secret" "rds_secrets" {
  name = "microservice/rds_credentials"
}

resource "aws_secretsmanager_secret_version" "rds_secrets" {
  secret_id = aws_secretsmanager_secret.rds_secrets.id
  secret_string = jsonencode({
    db_name  = var.rds_name
    username = var.rds_user
    password = var.rds_password

  })
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "default" {
  identifier     = var.identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_type

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.rds_name
  username = var.rds_user
  password = var.rds_password
  # manage_master_user_password = true  rds can manage password by itself

  parameter_group_name = aws_db_parameter_group.rds_postgres_group.name
  # manage_master_user_password = true  rds can manage password by

  # parameter_group_name = "default.postgres17"

  publicly_accessible = var.publicly_accessible
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.vpc_security_group_ids
}


resource "aws_db_parameter_group" "rds_postgres_group" {
  name        = "custom-postgres17"
  family      = "postgres"
  description = "Custom parameter group for MySQL 8.0 production workloads"

  parameter {
    name  = "log_statement" # log everything that db, do remove in prod stage
    value = "all"
  }

}
