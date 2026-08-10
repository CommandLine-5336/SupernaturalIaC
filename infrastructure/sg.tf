resource "aws_security_group" "private_app_sg" {
  name        = "private_app_sg"
  description = "Security group for EKS worker nodes and Consul"
  vpc_id      = module.castom_vpc.vpc_id


  ingress {
    description = "Allow 8080 from Public Subnets"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = module.castom_vpc.public_subnets
  }
  ingress {
    description = "Allow Consul Web UI and API from Public Subnets"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = module.castom_vpc.public_subnets
  }

  ingress {
    description = "Allow all internal traffic (8300, 8301, 8600, 8302)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound trafic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "private_db_sg" {
  name        = "private_db_sg"
  description = "Security group for Database"
  vpc_id      = module.castom_vpc.vpc_id

  ingress {
    description     = "Allow PostgreSQL traffic from app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_app_sg.id] # DB avalible only for private_app_sg
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
