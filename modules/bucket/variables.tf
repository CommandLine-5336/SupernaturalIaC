variable "name" {
  type = string
}

variable "env" {
  type    = string
  default = "Dev"
}

variable "caller_identity" {
  type    = string
  default = "704427427594"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
