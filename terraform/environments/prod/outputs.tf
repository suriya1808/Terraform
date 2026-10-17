# Useful information printed after "terraform apply"

output "website_url" {
  description = "Open this in your browser"
  value       = module.app.website_url
}

output "github_role_arn" {
  description = "Add this to the GitHub 'prod' environment as the AWS_ROLE_ARN variable"
  value       = module.app.github_role_arn
}
