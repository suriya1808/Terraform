# ---------------------------------------------------------
# The role the Terraform pipeline (terraform.yml) logs in with
# ---------------------------------------------------------
resource "aws_iam_role" "terraform_apply" {
  name = "${var.project_name}-terraform-apply-role"

  # Who can use this role? -> Only YOUR repo:
  #   - a job on any branch                          (sub = ...:ref:refs/heads/<branch>)
  #   - a job running in a GitHub environment (dev/qa/prod) (sub = ...:environment:<name>)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn } # From oidc.tf
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        # "*" = any name
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_repo}:ref:refs/heads/*",
            "repo:${var.github_repo}:environment:*"
          ]
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
