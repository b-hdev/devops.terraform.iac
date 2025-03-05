terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.89.0"
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_permissions_policy.arn
}

provider "aws" {
  region = "us-east-1"
  profile = "bhdev-sso"
}