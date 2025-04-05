terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = merge(var.tags, {CI_COMMIT_SHA=var.ci_commit_sha, PIPELINE_URL=var.pipeline_url})
  }
}

