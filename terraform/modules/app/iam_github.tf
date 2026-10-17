# ---------------------------------------------------------
# Permissions for the app deploy pipeline (deploy.yml)
# GitHub logs in to AWS with OIDC (short-lived tokens),
# so no AWS access keys are stored in GitHub.
# ---------------------------------------------------------

# GitHub's login service (OIDC) is created in the bootstrap/ folder.
# This is its address in AWS.
locals {
  github_oidc_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

# A role that the deploy pipeline can use
resource "aws_iam_role" "github" {
  name = "${local.name}-github-deploy-role"

  # Who can use this role? -> Only YOUR repo, and only a pipeline job
  # running in the matching GitHub environment (dev, qa or prod).
  # So a "dev" deploy can never touch the "prod" server.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = local.github_oidc_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:environment:${var.environment}"
        }
      }
    }]
  })
}

# What GitHub Actions is allowed to do
resource "aws_iam_role_policy" "github_deploy" {
  name = "deploy-react-app"
  role = aws_iam_role.github.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Upload the build files to the S3 bucket
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [aws_s3_bucket.deploy.arn, "${aws_s3_bucket.deploy.arn}/*"]
      },
      {
        # Find the server by its Name tag
        Effect   = "Allow"
        Action   = "ec2:DescribeInstances"
        Resource = "*"
      },
      {
        # Send the "copy files" command to the server only
        Effect = "Allow"
        Action = "ssm:SendCommand"
        Resource = [
          aws_instance.web.arn,
          "arn:aws:ssm:${var.aws_region}::document/AWS-RunShellScript"
        ]
      },
      {
        # Check whether the server is ready, and whether the command finished
        Effect   = "Allow"
        Action   = ["ssm:DescribeInstanceInformation", "ssm:GetCommandInvocation"]
        Resource = "*"
      }
    ]
  })
}
