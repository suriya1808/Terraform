# Tell Terraform which plugins (providers) we need
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Connect to AWS (uses your laptop's AWS login)
provider "aws" {
  region = var.aws_region
}
