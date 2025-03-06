# ------------------------------------------------ START
# # OIDC PROVIDER CONFIGURATION
# ------------------------------------------------
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
# ------------------------------------------------ END


# ------------------------------------------------ START
# # TF ROLE CONFIGURATION GITHUB ACTIONS
# ------------------------------------------------
resource "aws_iam_role" "tf-role" {
  name = "tf-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRoleWithWebIdentity",
        Condition : {
          StringEquals : {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:b-hdev/devops.terraform.iac:ref:refs/heads/master"
          }
        },
        Effect : "Allow",
        Principal : {
          Federated : "arn:aws:iam::741448934450:oidc-provider/token.actions.githubusercontent.com",
        }
      }
    ]
  })
  tags = {
    Iac = "True"
  }
}
# ------------------------------------------------ END

# ------------------------------------------------ START
# # TF ROLE CONFIGURATION PERMISSIONS
# ------------------------------------------------
resource "aws_iam_policy" "tf_permissions_role" {
  name        = "tf-permissions-role"
  description = "GitHub actions permissions role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowECRManagement"
        Effect = "Allow"
        Action = [
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:PutLifecyclePolicy",
          "ecr:GetAuthorizationToken",
          "ecr:TagResource"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowIAMManagement"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRole",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:TagRole",
          "iam:TagPolicy",
          "iam:TagOpenIDConnectProvider"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowS3Management"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketVersioning",
          "s3:GetBucketVersioning"
        ]
        Resource = "*"
      }
    ]
  })
}
# ------------------------------------------------ END

# ------------------------------------------------ START
# # APP RUNNER ROLE CONFIGURATION
# ------------------------------------------------
resource "aws_iam_role" "app-runner-role" {
  name = "app-runner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    IAC = "True"
  }
}
# ------------------------------------------------ END


# ------------------------------------------------ START
# # fix deprecated solutions in terraform
# # APP RUNNER ROLE CONFIGURATION LINK
# ------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.app-runner-role.name
}
# ------------------------------------------------ END


# ------------------------------------------------ START
# # fix deprecated solutions in terraform
# # ECR ROLE CONFIGURATION
# ------------------------------------------------
resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:b-hdev/devops.docker.containers:ref:refs/heads/master"
          }
        }
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::741448934450:oidc-provider/token.actions.githubusercontent.com"
          Service   = "ecs.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Iac = "True"
  }
}
# ------------------------------------------------ END


# ------------------------------------------------ START
# # fix deprecated solutions in terraform
# # ECR ROLE CONFIGURATION PERMISSIONS
# ------------------------------------------------
resource "aws_iam_policy" "ecr_permissions_policy" {
  name        = "app-permissions-policy"
  description = "policy permissions role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Statement1"
        Action   = "apprunner:*"
        Effect   = "Allow"
        Resource = "*"

      },
      {
        Sid = "Statement2"
        Action = [
          "iam:PassRole",
          "iam:CreateServiceLinkedRole"
        ]
        Effect   = "Allow"
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
# ------------------------------------------------ END