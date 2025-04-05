
output "health_path" {
  value = var.health_path
}

output "lb_dns" {
  value = data.terraform_remote_state.remote_common.outputs.internal_lb_dns
}

output "lb_protocol" {
  value = data.terraform_remote_state.remote_common.outputs.internal_lb_service_listener.protocol
}

output "deployment_url" {
  value = format("%s%s", "${lower(data.terraform_remote_state.remote_common.outputs.internal_lb_service_listener.protocol)}://${data.terraform_remote_state.remote_common.outputs.internal_lb_dns}",  substr(var.health_path,0,1) == "/" ? var.health_path : "/${var.health_path}")
}