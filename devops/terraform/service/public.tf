
module "public_ecs_task" {
  count  = var.run_public ? 1 : 0
  source = "git::https://prod-cicm.prv.pov/gitlab/enterprise-community/infrastructure-configuration-as-code/terraform_modules.git//aws/ecs_task?ref=aws_ecs_platform_3.0.0"

        container_definitions = local.container_definitions

  application_name                   = "pub-${var.service_name}"
  environment_name                   = var.environment_name
  ecs_task_execution_role_arn        = var.ecs_task_execution_role_arn
  task_role_arn                      = var.task_role_arn
  health_path                        = var.health_path
  desired_task_count                 = var.desired_task_count # You can make this separately configurable
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
  listener_arn             = data.terraform_remote_state.remote_common.outputs.public_lb_service_listener.arn
  source_security_group_id = data.terraform_remote_state.remote_common.outputs.public_lb_sg_id
  vpc_id                   = data.terraform_remote_state.remote_common.outputs.vpc_id

        use_blue_green    = var.use_blue_green
  dark_listener_arn = data.terraform_remote_state.remote_common.outputs.public_lb_dark_listener.arn
  bg_updater_role   = var.bg_updater_role
}