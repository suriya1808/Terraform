# ---------------------------------------------------------
# PROD environment
# Builds all the resources from modules/app with the values below.
# ---------------------------------------------------------
module "app" {
  source = "../../modules/app"

  environment   = "prod"
  instance_type = "t3.micro" # In a real project prod is often bigger, e.g. "t3.small"
}
