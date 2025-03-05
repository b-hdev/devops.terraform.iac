# ------------------------------------------------ START
# # ECR PROVIDER AWS
# ------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
}
# ------------------------------------------------ END

# ------------------------------------------------ START
# # ECR ROLE CONFIGURATION LINK
# ------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_permissions_policy.arn
}
# ------------------------------------------------ END

# ------------------------------------------------ START
# # TF ROLE CONFIGURATION LINK
# ------------------------------------------------
resource "aws_iam_role_policy_attachment" "tf_permissions_attachment" {
  role       = aws_iam_role.tf-role.name
  policy_arn = aws_iam_policy.tf_permissions_role.arn
}
# ------------------------------------------------ END

# ------------------------------------------------ START
# # PROVIDER AND PROFILE CONFIGURATION
# ------------------------------------------------
provider "aws" {
  region = "us-east-1"

  profile = var.is_github_actions ? null : "bhdev-sso"
}
# ------------------------------------------------ END