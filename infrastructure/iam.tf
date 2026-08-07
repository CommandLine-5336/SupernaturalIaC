module "eks_cluster_role" {
  source           = "../modules/iam_for_eks"
  name             = "eks-cluster-role"
  trusted_services = ["eks.amazonaws.com"]

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicyV2",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy",
  ]
}
module "eks_node_role" {
  source           = "../modules/iam_for_eks"
  name             = "eks-node-role"
  trusted_services = ["ec2.amazonaws.com"]

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
}

module "ecr_github_action" {
  source = "../modules/iam_for_ecr"
  name   = "github_action_ecr"
}

moved {
  from = aws_iam_policy.github_action_policy
  to   = module.ecr_github_action.aws_iam_policy.github_action_policy
}

moved {
  from = aws_iam_user.github_action_user
  to   = module.ecr_github_action.aws_iam_user.github_action_user
}

moved {
  from = aws_iam_user_policy_attachment.github_action_access
  to   = module.ecr_github_action.aws_iam_user_policy_attachment.github_action_access
}
