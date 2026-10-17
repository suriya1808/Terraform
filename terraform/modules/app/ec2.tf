# ---------------------------------------------------------
# The EC2 server
# ---------------------------------------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.ubuntu.insecure_value # From ami.tf
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]       # From security_group.tf
  iam_instance_profile   = aws_iam_instance_profile.ec2.name # From iam_ec2.tf

  # This script runs once when the server starts for the first time.
  # It installs nginx and the AWS CLI.
  user_data = file("${path.module}/install_nginx.sh")

  # If the script changes, build a fresh server so the new script runs
  user_data_replace_on_change = true

  # GitHub Actions finds the server using this Name tag
  tags = {
    Name = "${local.name}-server"
  }
}
