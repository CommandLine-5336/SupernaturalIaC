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

variable "storage_type" {
  description = "Database user"
  type        = string
  default     = "gp3"
}
variable "allocated_storage" {
  description = "Allocate storage in db"
  type        = number
  default     = 20
}

variable "identifier" {
  description = "Unique name of db in aws"
  type        = string
}

variable "engine" {
  description = "engine of db"
  type        = string
  default     = "postgres"
}
variable "engine_version" {
  description = "DB engine version"
  type        = string
  default     = "17"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "db.t4g.micro"
}

variable "publicly_accessible" {
  type    = bool
  default = false
}


variable "vpc_security_group_ids" {
  description = "List of SG IDs for RDS"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of Subnet IDs for RDS SG"
  type        = list(string)
}
