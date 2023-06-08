provider "aws" {
  region = "us-west-2"
}

module "ecs-service" {
  source                = "../../modules/ecs-service"
  ecs_cluster_id        = data.terraform_remote_state.infra.outputs.ecs_cluster_id
  ecs_alb_tg_arn        = data.terraform_remote_state.infra.outputs.ecs_alb_target_group
  ecs_security_group_id = data.terraform_remote_state.infra.outputs.ecs_security_group_id
  first_pvt_subnet_id   = data.terraform_remote_state.infra.outputs.first_pvt_subnet_id
  second_pvt_subnet_id  = data.terraform_remote_state.infra.outputs.second_pvt_subnet_id
}