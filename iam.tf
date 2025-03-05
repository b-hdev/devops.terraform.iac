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
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
              ],
            "token.actions.githubusercontent.com:sub" : [
              "repo:b-hdev/devops.docker.containers:ref:refs/heads/master"
              ]
          }
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::741448934450:oidc-provider/token.actions.githubusercontent.com"
          Service = "ecs.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })

    tags = {
    Iac = "True"
  }
}


resource "aws_iam_policy" "ecr_permissions_policy" {
  name        = "app-permissions-policy"
  description = "policy permissions role"

  policy = jsonencode({
    Statement = [
      {
          Sid = "Statement1"
          Action ="apprunner:*"
          Effect = "Allow"
          Resource = "*"

        },
        {
          Sid = "Statement2"
            Action = [
              "iam:PassRole",
              "iam:CreateServiceLinkedRole"
        ]
          Effect = "Allow"
          Resource = "*"
        },
        {
          Sid = "Statement3"
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



