# This will be overridden at run time via -backend-config=config/${ENVIRONMENT}/ecr-backend.tfvars
terraform {
  backend "s3" {
    encrypt = true
  }
}
