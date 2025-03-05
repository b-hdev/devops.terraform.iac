# ------------------------------------------------ START
# # ECR REPOSITORY CONFIGURATION
# ------------------------------------------------
resource "aws_ecr_repository" "devops-aic-ci-api" {
  name                 = "devops-ecr-ci"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Iac = "True"
  }
}
# ------------------------------------------------ END