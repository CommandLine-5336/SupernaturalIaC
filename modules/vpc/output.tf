output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.myvpc.id
}

output "vpc_cidr" {
  description = "VPC cidr"
  value       = aws_vpc.myvpc.cidr_block
}

output "public_subnets_cidr_block" {
  description = "VPC public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_app_subnets_cidr_block" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_app[*].cidr_block
}
output "private_db_subnets_cidr_block" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_db[*].cidr_block
}

output "public_subnets_id" {
  description = "VPC public subnets"
  value       = aws_subnet.public[*].id
}

output "private_app_subnets_id" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_app[*].id
}
output "private_db_subnets_id" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_db[*].id
}
