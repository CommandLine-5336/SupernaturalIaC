terraform {
  required_version = "1.15.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.58"
    }
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "${var.vpc_name}-public-${count.index + 1}"
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }
}



resource "aws_subnet" "private_app" {
  count                   = length(var.private_app_subnets)
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.private_app_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name                                    = "${var.vpc_name}-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb"       = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}
resource "aws_subnet" "private_db" {
  count                   = length(var.private_db_subnets)
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.private_db_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public_route"
  }
}


resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}


resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnets)
  domain = "vpc"
  tags = {
    Name        = "${var.env}-nat-gw-eip-${count.index}"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "${var.env}-nat-gw-${count.index}"
    Environment = var.env
  }
}


resource "aws_route_table" "private_route" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name        = "${var.env}-route-table-private-${count.index}"
    Environment = var.env
  }
}

resource "aws_route_table_association" "private_app_routes" {
  count          = length(var.private_app_subnets)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_route[count.index % length(var.public_subnets)].id
}
resource "aws_route_table_association" "private_db_routes" {
  count          = length(var.private_db_subnets)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_route[count.index % length(var.public_subnets)].id
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.myvpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    [aws_route_table.public_route.id],
    aws_route_table.private_route[*].id
  )

  tags = {
    Name        = "${var.env}-vpc-s3"
    Environment = var.env
  }
}


resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id              = aws_vpc.myvpc.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [var.ecr_sg_id]
  subnet_ids          = aws_subnet.private_app[*].id

}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id              = aws_vpc.myvpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [var.ecr_sg_id]
  subnet_ids          = aws_subnet.private_app[*].id
}
