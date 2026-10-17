# ---------------------------------------------------------
# QA environment
# Builds all the resources from modules/app with the values below.
# ---------------------------------------------------------
module "app" {
  source = "../../modules/app"

  environment   = "qa"
  instance_type = "t3.micro" # Small and cheap for testing
}
