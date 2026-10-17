# ---------------------------------------------------------
# Where Terraform keeps its "state" file (its memory of what it created).
# It is stored in S3 so that both your laptop and GitHub Actions
# use the same state.
#
# This bucket is created ONCE by hand (not by this Terraform code),
# so "terraform destroy" can never delete Terraform's own memory.
# ---------------------------------------------------------
terraform {
  backend "s3" {
    bucket       = "react-app-tfstate-047194654624"
    key          = "react-app/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true # Stops two people/pipelines changing things at the same time
  }
}
