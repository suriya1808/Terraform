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
  description = "GitHub repository allowed to deploy (owner/repo)"
  type        = string
  default     = "suriya1808/Terraform"
}
