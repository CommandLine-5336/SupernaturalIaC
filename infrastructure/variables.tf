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


variable "environment" {
  type    = string
  default = "developer"
}

variable "caller_id" {
  type    = string
  default = 704427427594
}

variable "ecr_services" {
  description = "The list of names in ecr registry"
  type        = set(string)
  default = [
    "frontend",
    "general",
    "auth",
    "cleanup",
    "mail_sending",
  "password_generator"]
}
