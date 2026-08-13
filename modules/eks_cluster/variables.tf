variable "eks_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.36"
}

variable "eks_name" {
  description = "EKS cluster name"
  type        = string
  default     = "our-eks-cluster"
}

variable "cluster_role_arn" {
  description = "EKS cluster role arn"
  type        = string
}

variable "node_role_arn" {
  description = "EKS node role arn"
  type        = string
}

variable "vpc_public_subnet_ids" {
  description = "VPC public subnet id list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_ids" {
  description = "VPC private subnet id list"
  type        = list(string)
  default     = []
}
variable "security_group_ids" {
  description = "Security group id list"
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
  default     = "ec2-node-group"
}
variable "instance_types" {
  description = "List of instance type for node group"
  type        = list(string)
  default     = ["t3.medium"]
}
variable "addons" {
  description = "List of EKS addons to be installed"
  type = map(object({
    name        = string
    most_recent = optional(bool, true)
  }))
  default = {
    coredns = {
      name        = "coredns"
      most_recent = true
    }
    vpc-cni = {
      name        = "vpc-cni"
      most_recent = true
    }
    kube-proxy = {
      name        = "kube-proxy"
      most_recent = true
    }
    eks-pod-identity-agent = {
      name        = "eks-pod-identity-agent"
      most_recent = true
    }
    metrics-server = {
      name        = "metrics-server"
      most_recent = true
    }

  }
}
variable "caller_identity_arn" {
  description = "Caller identity arn for EKS access entry"
  type        = list(string)
  default = ["arn:aws:iam::704427427594:user/BohdanHolovchak",
    "arn:aws:iam::704427427594:user/BozhenaOliinyk",
    "arn:aws:iam::704427427594:user/DenysFolyush",
    "arn:aws:iam::704427427594:user/MaksymSemehen",
  "arn:aws:iam::704427427594:user/MartaKozak"]
}
