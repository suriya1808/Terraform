# ---------------------------------------------------------
# S3 bucket = storage where GitHub Actions uploads the React build.
# The server then copies the files from here.
# ---------------------------------------------------------

# Get your AWS account ID (used to make the bucket name unique)
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "deploy" {
  # Example: react-app-deploy-123456789012
  bucket = "${local.name}-deploy-${data.aws_caller_identity.current.account_id}"

  # Allow "terraform destroy" to delete the bucket even if it has files
  force_destroy = true
}


#cicd test 2
