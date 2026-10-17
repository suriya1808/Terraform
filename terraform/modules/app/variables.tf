# ---------------------------------------------------------
# Inputs for this module.
# Each environment (dev, qa, prod) passes its own values
# from terraform/environments/<env>/main.tf
# ---------------------------------------------------------

variable "environment" {
  description = "Environment name: dev, qa or prod"
  type        = string
}

variable "instance_type" {
  description = "Size of the EC2 server"
  type        = string
  default     = "t3.micro" # Free tier eligible
}

variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "eu-west-1" # Ireland
}

variable "project_name" {
  description = "Name used in all resource names"
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

# Every resource name starts with this, e.g. "react-app-dev"
# so dev, qa and prod never clash.
locals {
  name = "${var.project_name}-${var.environment}"
}
