# ---------------------------------------------------------
# Where Terraform keeps the state file for THIS folder.
# Same S3 bucket as terraform/, but a different file (key),
# so the two folders never mix up their resources.
# ---------------------------------------------------------
terraform {
  backend "s3" {
    bucket       = "react-app-tfstate-047194654624"
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
