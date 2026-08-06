data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

module "eks-cluster" {
  source                 = "../modules/eks_cluster"
  eks_name               = "supernatural-eks-cluster"
  cluster_role_arn       = module.eks_cluster_role.role_arn
  node_role_arn          = module.eks_node_role.role_arn
  vpc_private_subnet_ids = data.aws_subnets.default.ids
  vpc_public_subnet_ids  = data.aws_subnets.default.ids
  security_group_ids     = [data.aws_security_group.default.id]
  node_group_name        = "supernatural-node-group"
  instance_types         = ["t3.medium"]

}

module "frontend-pod-role" {
  source               = "../modules/pod_role"
  name                 = "frontend-pod-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "supernatural"
  service_account_name = "frontend"

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
}
module "general-pod-role" {
  source               = "../modules/pod_role"
  name                 = "general-pod-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "supernatural"
  service_account_name = "general"

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess",
  ]
}
module "mail-service-pod-role" {
  source               = "../modules/pod_role"
  name                 = "mail-service-pod-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "supernatural"
  service_account_name = "mail-service"

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess",
  ]
}
module "auth-pod-role" {
  source = "../modules/pod_role"
  name   = "auth-pod-role"

  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "supernatural"
  service_account_name = "auth"

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess",
  ]
}
module "cleanup-pod-role" {
  source = "../modules/pod_role"
  name   = "cleanup-pod-role"

  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "supernatural"
  service_account_name = "cleanup"

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSSecretsManagerClientReadOnlyAccess",
  ]
}
