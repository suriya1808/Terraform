output "terraform_apply_role_arn" {
  description = "Add this to GitHub as the TF_APPLY_ROLE_ARN variable"
  value       = aws_iam_role.terraform_apply.arn
}
