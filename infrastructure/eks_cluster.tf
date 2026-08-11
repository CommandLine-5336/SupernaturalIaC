# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
#   filter {
#     name   = "availability-zone"
#     values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
#   }
# }
# data "aws_security_group" "default" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "default"
# }

module "eks-cluster" {
  # private are required for EKS but public are optional
  source = "../modules/eks_cluster"


  eks_name               = "supernatural-eks-cluster"
  cluster_role_arn       = module.eks_cluster_role.role_arn
  node_role_arn          = module.eks_node_role.role_arn
  vpc_private_subnet_ids = module.custom_vpc.private_app_subnets_id
  vpc_public_subnet_ids  = []
  security_group_ids     = [aws_security_group.private_app_sg.id]
  node_group_name        = "supernatural-node-group"
  instance_types         = ["t3.medium"]
  depends_on = [
    module.eks_cluster_role,
    module.eks_node_role,
  ]

}

module "consul-role" {
  source               = "../modules/pod_role"
  name                 = "consul-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"
  aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
  ]
}

module "frontend-pod-role" {
  source               = "../modules/pod_role"
  name                 = "frontend-pod-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "app"
  service_account_name = "frontend"

  inline_policies = {
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "S3",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObject"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })
  }
}
module "general-pod-role" {
  source               = "../modules/pod_role"
  name                 = "general-pod-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "app"
  service_account_name = "general"

  inline_policies = {
    policy = jsonencode({

      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SecretManagerRead",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "RDS",
          "Effect" : "Allow",
          "Action" : [
            "rds-data:BatchExecuteStatement",
            "rds-data:ExecuteSql",
            "rds-data:ExecuteStatement",
            "rds-data:RollbackTransaction",
            "rds-data:BeginTransaction",
            "rds-data:CommitTransaction",
            "rds-db:connect"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "S3",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObject"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]

    })
  }
}
module "mail-service-pod-role" {
  source               = "../modules/pod_role"
  name                 = "mail-service-pod-role"
  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "app"
  service_account_name = "mail-service"
  inline_policies = {
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SecretManagerRead",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "RDS",
          "Effect" : "Allow",
          "Action" : [
            "rds-data:BatchExecuteStatement",
            "rds-data:ExecuteSql",
            "rds-data:ExecuteStatement",
            "rds-data:RollbackTransaction",
            "rds-data:BeginTransaction",
            "rds-data:CommitTransaction",
            "rds-db:connect"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })

  }

}
module "auth-pod-role" {
  source = "../modules/pod_role"
  name   = "auth-pod-role"

  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "app"
  service_account_name = "auth"
  inline_policies = {
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SecretManagerRead",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "RDS",
          "Effect" : "Allow",
          "Action" : [
            "rds-data:BatchExecuteStatement",
            "rds-data:ExecuteSql",
            "rds-data:ExecuteStatement",
            "rds-data:RollbackTransaction",
            "rds-data:BeginTransaction",
            "rds-data:CommitTransaction",
            "rds-db:connect"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })

  }

}
module "cleanup-pod-role" {
  source = "../modules/pod_role"
  name   = "cleanup-pod-role"

  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "app"
  service_account_name = "cleanup"
  inline_policies = {
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SecretManagerRead",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "RDS",
          "Effect" : "Allow",
          "Action" : [
            "rds-data:BatchExecuteStatement",
            "rds-data:ExecuteSql",
            "rds-data:ExecuteStatement",
            "rds-data:RollbackTransaction",
            "rds-data:BeginTransaction",
            "rds-data:CommitTransaction",
            "rds-db:connect"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })

  }

}
module "password-protection-pod-role" {
  source = "../modules/pod_role"
  name   = "password-protection-pod-role"

  cluster_name         = module.eks-cluster.cluster_name
  namespace            = "app"
  service_account_name = "password-protection"
  inline_policies = {
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SecretManagerRead",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:DescribeSecret",
            "secretsmanager:GetSecretValue",
            "secretsmanager:BatchGetSecretValue"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "RDS",
          "Effect" : "Allow",
          "Action" : [
            "rds-data:BatchExecuteStatement",
            "rds-data:ExecuteSql",
            "rds-data:ExecuteStatement",
            "rds-data:RollbackTransaction",
            "rds-data:BeginTransaction",
            "rds-data:CommitTransaction",
            "rds-db:connect"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })

  }

}
