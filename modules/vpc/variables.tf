variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}
variable "private_app_subnets" {
  description = "List of private subnet CIDR blocks for application in EKS"
  type        = list(string)
}
variable "private_db_subnets" {
  description = "List of private subnet CIDR blocks for RDS database"
  type        = list(string)
}
