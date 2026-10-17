# ---------------------------------------------------------
# Where Terraform keeps the state file for the DEV environment.
# Each environment has its OWN state file, so changing one
# environment can never affect another.
# ---------------------------------------------------------
terraform {
  backend "s3" {
    bucket       = "react-app-tfstate-047194654624"
    key          = "react-app/dev/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true # Stops two pipelines changing things at the same time
  }
}
