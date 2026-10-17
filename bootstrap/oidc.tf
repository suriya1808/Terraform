# ---------------------------------------------------------
# Tell AWS to trust GitHub's login service (OIDC).
# This lets GitHub Actions log in with short-lived tokens,
# so no AWS access keys are stored in GitHub.
# ---------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}
