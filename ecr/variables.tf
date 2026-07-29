variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "ecr_services" {
  description = "The list of names in ecr registry"
  type        = set(string)
  default     = ["frontend", "general", "auth", "cleanup", "mail_sending"]
}

variable "image_mutability" {
  description = "Provide image mutability"
  type        = string
  default     = "IMMUTABLE"
}
variable "encrypt_type" {
  description = "Provide encryption type"
  type        = string
  default     = "AES256"
}
