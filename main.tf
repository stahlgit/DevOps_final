provider "aws" {
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "public_repo" {
  repository_name = "public-repo"
  catalog_data {
    description = "My public repository"
  }

  tags = {
    Name = "public-repo"
  }
}

output "repository_url" {
  value = aws_ecrpublic_repository.public_repo.repository_uri
}

resource "aws_iam_user" "ci_cd_user" {
  name = "ci-cd-user"
}

resource "aws_iam_access_key" "ci_cd_access_key" {
  user = aws_iam_user.ci_cd_user.name
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-policy"
  description = "Policy for accessing ECR"
  policy      = data.aws_iam_policy_document.ecr_policy_document.json
}

data "aws_iam_policy_document" "ecr_policy_document" {
  statement {
    actions   = ["ecr-public:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "ecr_policy_attachment" {
  user       = aws_iam_user.ci_cd_user.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

output "ci_cd_access_key_id" {
  value = aws_iam_access_key.ci_cd_access_key.id
}

output "ci_cd_secret_access_key" {
  value     = aws_iam_access_key.ci_cd_access_key.secret
  sensitive = true
}
