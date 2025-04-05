data "terraform_remote_state" "remote_common" {
  backend = "s3"
  config  = var.shared-resource-data-config
}

data "aws_ecr_image" "main" {
  repository_name = "${var.environment_name}-${var.service_name}"
  image_tag       = "${var.image_tag}"
}
