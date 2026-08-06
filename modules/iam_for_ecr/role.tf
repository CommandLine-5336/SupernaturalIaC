resource "aws_iam_user" "github_action_user" {
  name = var.name
  tags = var.tags
}

resource "aws_iam_policy" "github_action_policy" {
  name = "AllowPushPullPolicyEcr"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "GetAuthorizationToken",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetAuthorizationToken"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:GetDownloadUrlForLayer",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
          ],
          "Resource" : [
            "arn:aws:ecr:us-east-1:704427427594:repository/*"
          ]
        }
      ]
    }
  )
}


resource "aws_iam_user_policy_attachment" "github_action_access" {
  user       = aws_iam_user.github_action_user.name
  policy_arn = aws_iam_policy.github_action_policy.arn

}
