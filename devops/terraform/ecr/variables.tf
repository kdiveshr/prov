variable "region" {
  description = "(Default:us-east-1) AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "(Default:default) AWS profile to use"
  default     = "default"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "service_name" {
  description = "The exact name of the service to show on the dashboard"
  type        = string
}

variable "environment_name" {
  description = "Environment name i.e. dev/staging/prod"
  type        = string
  default     = "dev"
}

variable "ci_commit_sha" {
  description = "Commit Sha of the code that executed the pipeline that created these resources"
  type        = string
  default     = ""
}

variable "pipeline_url" {
  description = "Pipeline URL that created these resources"
  type        = string
  default     = ""
}