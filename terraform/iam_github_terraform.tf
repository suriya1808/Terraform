# ---------------------------------------------------------
# Permissions for the Terraform pipeline (terraform.yml)
# ---------------------------------------------------------

# A role that the Terraform pipeline can use
resource "aws_iam_role" "terraform_apply" {
  name = "${var.project_name}-terraform-apply-role"

  # Who can use this role? -> Only YOUR repo, from any branch
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        # "*" = any branch name
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:ref:refs/heads/*"
        }
      }
    }]
  })
}

# Terraform creates EC2, IAM, S3 etc., so it needs full access
resource "aws_iam_role_policy_attachment" "terraform_apply_admin" {
  role       = aws_iam_role.terraform_apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
