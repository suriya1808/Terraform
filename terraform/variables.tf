# Values you can change easily in one place

variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "eu-west-1" # Ireland
}

variable "instance_type" {
  description = "Size of the EC2 server"
  type        = string
  default     = "t3.micro" # Free tier eligible
}

variable "project_name" {
  description = "Name used to tag all resources"
  type        = string
  default     = "react-app"
}

variable "github_repo" {
  description = "GitHub repository allowed to deploy"
  type        = string
  # Format GitHub uses in its login token: owner@ownerID/repo@repoID
  # The IDs never change, even if the repo is renamed.
  default = "suriya1808@81013423/Terraform@1422403913"
}
