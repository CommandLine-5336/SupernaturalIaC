resource "aws_security_group" "private_app_sg" {
  name        = "private_app_sg"
  description = "Security group for EKS worker nodes and Consul"
  vpc_id      = module.custom_vpc.vpc_id


  ingress {
    description = "Allow 8080 from Public Subnets"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = module.custom_vpc.public_subnets_cidr_block
  }
  ingress {
    description = "Allow Consul Web UI and API from Public Subnets"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = module.custom_vpc.public_subnets_cidr_block
  }

  ingress {
    description = "Allow all internal traffic (8300, 8301, 8600, 8302)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "private_db_sg" {
  name        = "private_db_sg"
  description = "Security group for Database"
  vpc_id      = module.custom_vpc.vpc_id

  ingress {
    description     = "Allow PostgreSQL traffic from app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_app_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "public_db_sg" { # test for  maksym
  name        = "public_db_sg"
  description = "Security group for Database"
  vpc_id      = module.custom_vpc.vpc_id

  ingress {
    description = "Allow PostgreSQL traffic from anywhere"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecr_endpoint_sg" { # test for  maksym
  name        = "ecr_endpoint_sg"
  description = "Security group for ECR endpoint"
  vpc_id      = module.custom_vpc.vpc_id

  ingress {
    description     = "Allow HTTPS traffic from EKS nodes to ECR"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.private_app_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
