# Seperate Okta Sidecar variables into a dedicated file
# Each of these variables are optional with default values set or blank
variable "auth_image" {
  type        = string
  description = "The ECR URI of the auth image"
  default     = ""
}

variable "okta_sidecar_config" {
  description = "Config for the okta sidecar. Each of these has defaults that match the values below"
  type        = map(any)
  default = {
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
}
