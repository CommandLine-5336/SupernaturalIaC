terraform {
  required_version = "1.15.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.58"
    }
  }
}



resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_name
  role_arn = var.cluster_role_arn
  version  = var.eks_version
  access_config {
    authentication_mode = "API"
  }
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids         = flatten([var.vpc_public_subnet_ids, var.vpc_private_subnet_ids])
    security_group_ids = var.security_group_ids
  }
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]


  tags = {
    "Name" = var.eks_name
  }

}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url            = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
}


resource "aws_launch_template" "this" {
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2 # <---------------- HERE!!!
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "ec2-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.vpc_private_subnet_ids
  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }

  launch_template { # <---------------------------- HERE!!!
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
  update_config {
    max_unavailable = 1
  }
  instance_types = var.instance_types
  tags = {
    "Name"    = var.node_group_name
    "Cluster" = aws_eks_cluster.eks-cluster.name
  }
  depends_on = [aws_eks_cluster.eks-cluster]
}

data "aws_eks_addon_version" "eks_addons" {
  for_each = var.addons

  addon_name         = each.value.name
  kubernetes_version = aws_eks_cluster.eks-cluster.version
  most_recent        = coalesce(each.value.most_recent, true)
}
resource "aws_eks_addon" "addons" {
  for_each = var.addons

  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = each.value.name
  addon_version               = data.aws_eks_addon_version.eks_addons[each.key].version
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [aws_eks_node_group.ec2-node-group]
  tags = {
    Name = each.value.name
  }
}


resource "aws_eks_access_entry" "access_entry_for_team" {
  for_each      = toset(var.caller_identity_arn)
  cluster_name  = aws_eks_cluster.eks-cluster.name
  principal_arn = each.value
}
resource "aws_eks_access_policy_association" "policy_for_team" {
  for_each      = toset(var.caller_identity_arn)
  cluster_name  = aws_eks_cluster.eks-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.access_entry_for_team]
}
