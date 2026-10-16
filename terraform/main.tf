# ---------------------------------------------------------
# 1. Find the latest Ubuntu 24.04 image (AMI)
#    Canonical (the Ubuntu company) publishes the latest image ID
#    in this public AWS parameter, so we just read it.
# ---------------------------------------------------------
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# ---------------------------------------------------------
# 2. Security group = firewall for the server
#    Only port 80 (website) is open. No SSH (port 22).
# ---------------------------------------------------------
resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP only"

  # Allow website traffic (HTTP)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow the server to reach the internet
  # (to install packages, talk to SSM and download files from S3)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# ---------------------------------------------------------
# 3. The EC2 server
# ---------------------------------------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.ubuntu.insecure_value
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name # Permissions (see iam.tf)

  # This script runs once when the server starts for the first time.
  # It installs nginx and the AWS CLI.
  user_data = file("${path.module}/install_nginx.sh")

  # If the script changes, build a fresh server so the new script runs
  user_data_replace_on_change = true

  # GitHub Actions finds the server using this Name tag
  tags = {
    Name = "${var.project_name}-server"
  }
}

# ---------------------------------------------------------
# 4. Elastic IP = a fixed public IP that never changes
#    (even if the server is stopped and started again)
# ---------------------------------------------------------
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}
