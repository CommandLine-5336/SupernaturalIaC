module "ecr_repositories" {
  source = "../modules/ecr"

}
moved {
  from = aws_ecr_repository.services
  to   = module.ecr_repositories.aws_ecr_repository.services
}

moved {
  from = aws_ecr_lifecycle_policy.services
  to   = module.ecr_repositories.aws_ecr_lifecycle_policy.services
}
