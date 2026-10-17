# ---------------------------------------------------------
# Permissions for the EC2 server
# ---------------------------------------------------------

# A role the EC2 server can use
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"

  # Who can use this role? -> EC2 servers
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Let the server receive commands from AWS Systems Manager (SSM)
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Let the server read the React build files from the S3 bucket
resource "aws_iam_role_policy" "ec2_s3_read" {
  name = "read-deploy-bucket"
  role = aws_iam_role.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [aws_s3_bucket.deploy.arn, "${aws_s3_bucket.deploy.arn}/*"]
    }]
  })
}

# The "instance profile" is how a role gets attached to an EC2 server
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}
