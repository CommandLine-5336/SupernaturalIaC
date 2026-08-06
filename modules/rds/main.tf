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
  # manage_master_user_password = true  rds can manage password by

  parameter_group_name = "default.postgres17"

  publicly_accessible = var.publicly_accessible
  skip_final_snapshot = true


}
