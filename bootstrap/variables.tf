# Values you can change easily in one place
# (keep them the same as in terraform/variables.tf)

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1" # Ireland
}

variable "project_name" {
  description = "Name used in all resource names"
  type        = string
  default     = "react-app"
}

variable "github_repo" {
  description = "GitHub repository allowed to log in"
  type        = string
  # Format GitHub uses in its login token: owner@ownerID/repo@repoID
  default = "suriya1808@81013423/Terraform@1422403913"
}
