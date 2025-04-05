region = "us-east-1"
environment_name = "dev"
container_image = "345192829828.dkr.ecr.us-east-1.amazonaws.com/dev-divesh-api"
service_name = "divesh-api"
dashboard_name = "dev-divesh-api-dashboard"
application_paths = ["/divesh-api/api/*"]
health_path = "/divesh-api/api/actuator/health"
alb_priority = 1
run_internal = true
run_public = false
ecs_task_execution_role_arn = "arn:aws:iam::345192829828:role/prv-dev/uacs-lab-service-role-1"
desired_task_count = 1
max_task_count = 2
force_new_deployment = true

# Same as ecs_task_execution_role_arn
task_role_arn = "arn:aws:iam::345192829828:role/prv-dev/uacs-lab-service-role-1"

# Env vars to passs to the container
# Pay attention to your heap. Container has 8GB of memory; we are giving Heap 6GB. 
# We are enabling AWS Signals by Default
service_container_env_vars    = []

# Add the following to the service_container_env_vars when using Instana:
#  {"name":"ENVIRONMENT","value":"dev"},
#  {"name":"INSTANA_ENDPOINT_URL","value": "https://instana-lab.etc.prv.pov/serverless"}, 
#  {"name":"INSTANA_LOG_LEVEL","value":"DEBUG"}, 
#  {"name":"INSTANA_LOG_SPANS","value":"TRUE"}, 
#  {"name":"INSTANA_TAGS","value":"ais=COMP-747,domain=dev,service=divesh-api-dev"},
#  {"name":"INSTANA_DISABLE_MEMORY_CHECK","value":"TRUE"}, 
#  {"name":"INSTANA_SERVICE_NAME","value":"divesh-api-dev"}


# Secrets to pass to the container
# Follow Guide at: https://prod-cicm.prv.pov/gitlab/groups/enterprise-community/-/wikis/Containers/Inject-Secrets-into-ECS
service_container_env_secrets = [
{
    name="DB_URL",
    valueFrom="arn:aws:secretsmanager:us-east-1:345192829828:secret:divesh/test-Oo5dki:DB_URL::"
  },
  {
    name="DB_USER_INTERNAL",
    valueFrom="arn:aws:secretsmanager:us-east-1:345192829828:secret:divesh/test-Oo5dki:DB_USER_INTERNAL::"
  },
  {
    name="DB_PASSWORD",
    valueFrom="arn:aws:secretsmanager:us-east-1:345192829828:secret:divesh/test-Oo5dki:DB_PASSWORD::"
  },


]
# Add the following to the service_container_env_secrets when using Instana:
#  {name="INSTANA_AGENT_KEY", valueFrom="YOUR_SECRET_ARN:INSTANA-ACCESS-KEY::"}


# Details of the container that will be serving traffic from the load balancer
service_container_name = "divesh-api" # if using okta sidecar, "okta-authz"
service_container_port = 8080 # if using okta sidecar, 8443
lb_target_group_protocol = "HTTP" # if using okta sidecar, "HTTPS"

# OKTA Configuration
auth_image = "345192829828.dkr.ecr.us-east-1.amazonaws.com/okta-authz-sidecar:1.4.0"
okta_sidecar_config = {
    default_allow     = false        # Whether to allow requests unless otherwise specified
    auth_server       = ""           # URL of your okta server
    jwks_path         = "/v1/keys"   # The path on the auth server to get JWKS keys to validate tokens
    log_level         = "DEBUG"      # The log level must be one of [DEBUG, INFO, ERROR].
    add_decoded_token = false        # Whether to add the decoded token as a header for the request to the service. The header will be named AuthorizationDecoded
    audience          = "trademarks" # Audience to match tokens against. Configured in OKTA
    client_id         = ""           # Your client ID. Required for introspection
    client_secret     = ""           # The ARN for the Secrets Manager or SSM Parameter Store location of your client secret. Required for introspection
    ip_whitelist      = "[]"         # A json-encoded list of IPs to whitelist
  }


# Use a role that has Lambda as Trusted authority
bg_updater_role = "arn:aws:iam::345192829828:role/prv-dev/uacs-lab-lambda-role-1"
# Set to true if using B/G deployments. Default is FALSE.
use_blue_green = false

# This information is needed to pull data about your Shared Components (ECS Cluster & ALB etc )
shared-resource-data-config = {
  bucket         = "dev-prv-divesh-platform-terraform-state"
  key            = "platform/divesh-platform_terraform_shared.tfstate"
  region         = "us-east-1"
  dynamodb_table = "dev-prv-divesh-platform-terraform-lock"
}

# These tags will be added to your AWS Resources
# https://prvgov.sharepoint.com/sites/7a2f9c97/Pages/ssbAwsBestPractices.aspx#tagging
tags = {
  Environment = "dev"
  KeepOn = "Mo+Tu+We+Th+Fr:06-19"
  ComponentID = "13200"
  FargateMinRunningTasks = "2"
}