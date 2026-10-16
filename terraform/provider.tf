# Tell Terraform which plugins (providers) we need
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Connect to AWS.
# Your access key and secret key are NOT written here.
# Terraform reads them from environment variables or "aws configure".
provider "aws" {
  region = var.aws_region
}
