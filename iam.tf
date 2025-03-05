resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "d89e3bd43d5d909b47a18977aa9d5ce36cee184c"
  ]

  tags = {
    Iac = "True"
  }
}
resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })

    tags = {
    Iac = "True"
  }
}


resource "aws_iam_policy" "ecr_permissions_policy" {
  name        = "app-permissions-policy"
  description = "policy permissions role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

    tags = {
      Iac = "True"
  }
}

