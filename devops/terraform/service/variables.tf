variable "region" {
  description = "(Default:us-east-1) AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "(Default:default) AWS profile to use"
  default     = "default"
}

variable "shared-resource-data-config" {
  description = "backend configuration for the shared service data"
  type        = map(string)
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "environment_name" {
  description = "Environment name i.e. dev/staging/prod"
  type        = string
}

variable "container_image" {
  description = "The docker image URL/ARN from the docker repo eg 772986870918.dkr.ecr.us-east-1.amazonaws.com/springboot-hello-world"
  type        = string
}

variable "image_tag" {
  description = "The docker image tag. Used in data.tf to identify the container to pull from ECR."
  type        = string
  default     = "latest"
}


variable "dashboard_name" {
  description = "The name you want to use for this CloudWatch dashboard"
  type        = string
}

variable "service_name" {
  description = "The exact name of the service to show on the dashboard"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
  description = "ECS Task Execution Role ARN."
  type        = string
}

variable "task_role_arn" {
  description = " ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
  default     = null
}

variable "health_path" {
  description = "path to healh check"
  type        = string
  default     = "/"
}

variable "desired_task_count" {
  description = "Desired number of tasks running"
  type        = number
  default     = 1
}
variable "max_task_count" {
  description = "Max number of tasks running"
  type        = number
  default     = 1
}

variable "deployment_minimum_healthy_percent" {
  description = "Sets the minimum healthy containers. Set to 100% to reduce downtime during redeploy"
  type        = number
  default     = 100
}

variable "application_paths" {
  description = "Application paths to map behind the ALB"
  type        = list(string)
}

variable "alb_priority" {
  description = "Priority of the path behind the ALB"
  type        = number
  default     = 1
}

variable "run_internal" {
  description = "Whether to run this service on the internal load balancer"
  type        = bool
  default     = true
}

variable "run_public" {
  description = "Whether to run this service on the public load balancer"
  type        = bool
  default     = false
}

variable "lb_target_group_protocol" {
  description = "Set to HTTPS if TLS sidecar has been enabled on the ECS Task Definition."
  type        = string
  default     = "HTTP"
}

variable "bg_updater_role" {
  description = "ARN of the IAM role for the blue/green updater Lambda to assume"
  type        = string
  default     = ""
}

variable "use_blue_green" {
  description = "Set to true if using B/G deployments. Default is FALSE."
  type        = bool
  default     = false
}

variable "service_container_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps. map_environment overrides environment"
  default     = []
}

variable "service_container_env_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "The secret ARNs to be passed into the container as environment variables. List of maps e.g. [{name='NAME', valueFrom='SECRET'}]"
  default     = []
}

variable "force_new_deployment" {
  type        = bool
  description = "Whether to force a new deployment every time"
}

variable "service_container_port" {
  description = "The port on which to send the service traffic"
  type        = number
  default     = 8080
}

variable "service_container_name" {
  description = "The name of the container for the load balancer to direct traffic to"
  type        = string
  default     = ""
}

variable "container_definitions_file_name" {
  description = "The name of the file with the container definitions"
  type        = string
  default     = "container_definitions_default.json"
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

variable "otel_cloudwatch_agent_image" {
  description = "OTEL CloudWatch Agent to sent telemetry information to AWS Application Signals"
  type        = string
  default     = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent:latest"
}