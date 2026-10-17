# ---------------------------------------------------------
# Find the latest Ubuntu 24.04 image (AMI)
# Canonical (the Ubuntu company) publishes the latest image ID
# in this public AWS parameter, so we just read it.
# ---------------------------------------------------------
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}
