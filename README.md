# Supernatural

This repository contains Terraform infrasructure (RDS,VPC,EKS,S3) and Consul service mesh

Our folder structure:
```text
.
├── backend         # Contains our tfstate bucket creation
├── consul          # Contains consul service mesh and TLS certification
├── infrastructure  # Contains all of our IaC
└── modules         # Contains all reusable terraform resources
    ├── bucket
    ├── ecr
    ├── eks_cluster
    ├── iam_for_ecr
    ├── iam_for_eks
    ├── pod_role
    └── rds
```

## Prerequisites

* [Terraform](https://developer.hashicorp.com/terraform/install) v1.15.8
* [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) v2.31.35
* [kubernetes](https://kubernetes.io/docs/tasks/tools/):
  * Client v1.36.3
  * Kustomize v5.8.1
  * Server v.1.36.2
* [Helm](https://helm.sh/docs/intro/install/) v4.2.3

## Steps to Run

1. Configure AWS credentials `aws config`
1. Run Terraform code:
    1. Go into backend folder `cd ./backend`
    1. Initialize terraform `terraform init` and create remote tfstate bucket `terrafrom apply`
    1. Go into infrastructure folder `cd ../infrastructure`
    1. Initialize terraform backend `terraform init` and deploy the infrastructure `terraform apply`
1. Configure kubectl to work with your EKS cluster `aws eks update-kubeconfig --region <region-code> --name  <my-cluster>`
1. Deploy consul service mesh and api gateway:
    1. Reference [README](https://github.com/CommandLine-5336/SupernaturalIaC/blob/main/consul/README.md) in consul folder.
1. Deploy application in [Supernatural](https://github.com/CommandLine-5336/Supernatural)
