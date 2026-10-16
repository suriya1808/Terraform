# =========================================================
# PART A: Permissions for the EC2 server
# =========================================================

# A role the EC2 server can use
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"

  # Who can use this role? -> EC2 servers
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Let the server receive commands from AWS Systems Manager (SSM)
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Let the server read the React build files from the S3 bucket
resource "aws_iam_role_policy" "ec2_s3_read" {
  name = "read-deploy-bucket"
  role = aws_iam_role.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [aws_s3_bucket.deploy.arn, "${aws_s3_bucket.deploy.arn}/*"]
    }]
  })
}

# The "instance profile" is how a role gets attached to an EC2 server
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# =========================================================
# PART B: Permissions for GitHub Actions
# GitHub logs in to AWS with OIDC (short-lived tokens),
# so no AWS access keys are stored in GitHub.
# =========================================================

# Tell AWS to trust GitHub's login service
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

# A role that GitHub Actions can use
resource "aws_iam_role" "github" {
  name = "${var.project_name}-github-deploy-role"

  # Who can use this role? -> Only YOUR repo, only from the main branch
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:ref:refs/heads/main"
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
        # Check whether the command finished
        Effect   = "Allow"
        Action   = "ssm:GetCommandInvocation"
        Resource = "*"
      }
    ]
  })
}
