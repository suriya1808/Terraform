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
# default_tags are added to EVERY resource, so in the AWS Console
# you can easily see which environment a resource belongs to.
provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      Project     = "react-app"
      Environment = "qa"
      ManagedBy   = "terraform"
    }
  }
}
