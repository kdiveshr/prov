locals {
  base_environment = [
    {
      "name" : "ENVIRONMENT",
      "value" : var.environment_name
    }
  ]

  # OTEL Sidecar configuration. Needed for AWS Signals
   # OTEL Sidecar configuration. Needed for AWS Signals
  otel_container_env_vars  = [  
    {
        "name": "OTEL_RESOURCE_ATTRIBUTES",
        "value": "service.name=${var.environment_name}-${var.service_name}"
      },
      {
        "name": "OTEL_LOGS_EXPORTER",
        "value": "none"
      },
      {
        "name": "OTEL_METRICS_EXPORTER",
        "value": "none"
      },
      {
        "name": "OTEL_EXPORTER_OTLP_PROTOCOL",
        "value": "http/protobuf"
      },
      {
        "name": "OTEL_AWS_APPLICATION_SIGNALS_ENABLED",
        "value": "true"
      },
      {
        "name": "JAVA_TOOL_OPTIONS",
        "value": " -javaagent:/otel-auto-instrumentation/javaagent.jar -XX:+UseZGC -XX:+ZGenerational -Xmx6144m -Xlog:gc"
      },
      {
        "name": "OTEL_AWS_APPLICATION_SIGNALS_EXPORTER_ENDPOINT",
        "value": "http://localhost:4316/v1/metrics"
      },
      {
        "name": "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT",
        "value": "http://localhost:4316/v1/traces"
      },
      {
        "name": "OTEL_TRACES_SAMPLER",
        "value": "xray"
      },
      {
        "name": "OTEL_PROPAGATORS",
        "value": "tracecontext,baggage,b3,xray"
      }
  ] 

service_container_map = {
    service_name                  = var.service_name,
    container_image               = format("%s@%s", var.container_image, data.aws_ecr_image.main.image_digest)
    service_container_env_vars    = concat(local.base_environment, var.service_container_env_vars),
    service_container_env_secrets = var.service_container_env_secrets
    region                        = var.region,
    environment_name              = var.environment_name
    otel_cloudwatch_agent_image   = var.otel_cloudwatch_agent_image
    otel_config                   = [{name:"CW_CONFIG_CONTENT",value:file("${path.module}/otel_config.json")}]
  }


  

  okta_container_map = {
    auth_image = var.auth_image,
    auth_container_env_vars = concat(local.base_environment, [
      {
        name : "API_HOST",
        value : format("http://127.0.0.1:%s", "8080") # how to reach your service container
      },
      {
        name : "DEFAULT_ALLOW",
        value : tostring(lookup(var.okta_sidecar_config, "default_allow", false))
      },
      {
        name : "AUTH_SERVER",
        value : lookup(var.okta_sidecar_config, "auth_server", "")
      },
      {
       name : "BASE_PATH",
       value : replace(var.application_paths[0], "*", "")
      },
      {
        name : "JWKS_PATH",
        value : lookup(var.okta_sidecar_config, "jwks_path", "/v1/keys")
      },
      {
        name : "AUTH_SCOPES",
        value : file("auth_scopes.json")
      },
      {
        name : "LOG_LEVEL",
        value : upper(lookup(var.okta_sidecar_config, "log_level", "DEBUG"))
      },
      {
        name : "ADD_DECODED_TOKEN",
        value : tostring(lookup(var.okta_sidecar_config, "add_decoded_token", false))
      },
      {
        name : "AUDIENCE",
        value : lookup(var.okta_sidecar_config, "audience", "trademarks")
      },
      {
        name : "CLIENT_ID",
        value : lookup(var.okta_sidecar_config, "client_id", "")
      },
      {
        name : "IP_WHITELIST",
        value : lookup(var.okta_sidecar_config, "ip_whitelist", "[]")
      }
    ]),
    auth_container_env_secrets = lookup(var.okta_sidecar_config, "client_secret_arn", "") == "" ? [] : [{ name : "CLIENT_SECRET", valueFrom : var.okta_sidecar_config["client_secret_arn"] }],
    region                     = var.region,
    environment_name           = var.environment_name,
    service_name               = var.service_name,
  }


  container_definitions = templatefile("${path.module}/${var.container_definitions_file_name}", merge(local.service_container_map, local.okta_container_map ))
}

module "ecs_task" {
  count  = var.run_internal ? 1 : 0
  source = "git::https://prod-cicm.prv.pov/gitlab/enterprise-community/infrastructure-configuration-as-code/terraform_modules.git//aws/ecs_task?ref=aws_ecs_platform_3.1.0"

        container_definitions = local.container_definitions

  application_name                   = var.service_name
  environment_name                   = var.environment_name
  ecs_task_execution_role_arn        = var.ecs_task_execution_role_arn
  task_role_arn                      = var.task_role_arn
  health_path                        = var.health_path
  desired_task_count                 = var.desired_task_count
  max_task_count                     = var.max_task_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  region                             = var.region
  service_container_name             = var.service_container_name
  service_container_port             = var.service_container_port
  lb_target_group_protocol           = var.lb_target_group_protocol

  force_new_deployment     = var.force_new_deployment
  application_paths         = var.application_paths
  alb_priority             = var.alb_priority
  cluster_name             = data.terraform_remote_state.remote_common.outputs.cluster_name
  listener_arn             = data.terraform_remote_state.remote_common.outputs.internal_lb_service_listener.arn
  source_security_group_id = data.terraform_remote_state.remote_common.outputs.internal_lb_sg_id
  vpc_id                   = data.terraform_remote_state.remote_common.outputs.vpc_id

        use_blue_green    = var.use_blue_green
  dark_listener_arn = data.terraform_remote_state.remote_common.outputs.internal_lb_dark_listener.arn
  bg_updater_role   = var.bg_updater_role

    # There are more variables available but we use their defaults.
  # We will reference those variables, and their defaults below here so you know what can be overridden
  
  # health_check_port = "" # Allows you to specify the health check port. If not set then it will default to whatnever is set on the listener.
  # keep_on_schedule = "Mo+Tu+We+Th+Fr+Sa+Su:00-23" # Add-On feature to start/stop ECS Services automatically in non-business hours. Will keep desired_count of tasks running during the specified window.
  # deployment_maximum_percent = 200 # (Optional) The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Not valid when using the DAEMON scheduling strategy.
  # health_check_interval = 100 # Approximate amount of time, in seconds, between health checks of an individual target.
  # health_check_healthy_threshold = 3 # Number of consecutive health checks successes required before considering an unhealthy target healthy.
  # wait_for_steady_state = false # If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. Default false.
  # deregistration_delay = 300 # Amount time for Elastic Load Balancing to wait before changing the state of a \nderegistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.
  # create_dashboard = false # Whether to create the ecs dashboard in CloudWatch.
  # autoscale_memory_target = 70 # The memory target for the auto-scaling configuration.
  # autoscale_cpu_target = 75 # The cpu target for the auto-scaling configuration.
  # security_group_ingress_override = [] # An override for custom task definitions to allow ingress on only the specified ports. Default is 8443 AND OR the service port that you have .
  # override_subnets = [] # An override for the subnets of the ecs service
  # use_round_robin = true # Whether to use round-robin on the target group. False uses least-outstanding-requests

}
