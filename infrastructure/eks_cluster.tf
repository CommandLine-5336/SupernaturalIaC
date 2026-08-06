module "eks-cluster" {
  source                 = "../modules/eks_cluster"
  eks_name               = "supernatural-eks-cluster"
  cluster_role_arn       = module.eks_cluster_role.role_arn
  node_role_arn          = module.eks_node_role.role_arn
  vpc_private_subnet_ids = []
  vpc_public_subnet_ids  = []
  security_group_ids     = []
  node_group_name        = "supernatural-node-group"
  instance_types         = ["t3.medium"]

}

module "frontend-pod-role" {
  source           = "../modules/pod_role"
  name             = "frontend-pod-role"
  trusted_services = ["eks.amazonaws.com"]
  cluster_name     = module.eks-cluster.cluster_name
  namespace        = "supernatural"
  service_name     = "frontend"

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
}
