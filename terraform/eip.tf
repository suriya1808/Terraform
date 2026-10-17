# ---------------------------------------------------------
# Elastic IP = a fixed public IP that never changes
# (even if the server is stopped and started again)
# ---------------------------------------------------------
resource "aws_eip" "web" {
  instance = aws_instance.web.id # From ec2.tf
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}
