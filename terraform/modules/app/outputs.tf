# Information this module gives back to the environment folder

output "website_url" {
  description = "Open this in your browser"
  value       = "http://${aws_eip.web.public_ip}"
}

output "github_role_arn" {
  description = "Add this to the GitHub environment as the AWS_ROLE_ARN variable"
  value       = aws_iam_role.github.arn
}
