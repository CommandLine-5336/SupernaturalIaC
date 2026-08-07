variable "region" {
  type    = string
  default = "us-east-1"
}


variable "rds_name" {
  description = "Name of the rds "
  type        = string
}
variable "rds_user" {
  description = "Database user"
  type        = string
}
variable "rds_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
