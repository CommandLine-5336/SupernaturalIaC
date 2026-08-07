output "id" {
  description = "VPC id"
  value       = aws_vpc.myvpc.id
}

output "vpc_cidr" {
  description = "VPC cidr"
  value       = aws_vpc.myvpc.cidr_block
}

output "public_subnets" {
  description = "VPC public subnets"
  value       = aws_subnet.public[*].id
}

output "private_app" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_app[*].id
}
output "private_db" {
  description = "VPC ptivate subnets"
  value       = aws_subnet.private_db[*].id
}
