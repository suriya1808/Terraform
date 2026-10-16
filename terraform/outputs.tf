# Useful information printed after "terraform apply"

output "website_url" {
  description = "Open this in your browser"
  value       = "http://${aws_eip.web.public_ip}"
}

output "github_role_arn" {
  description = "Add this to GitHub as the AWS_ROLE_ARN variable"
  value       = aws_iam_role.github.arn
}
