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
  trusted_services = ["eks.amazonaws.com"]

  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly",
  ]
}