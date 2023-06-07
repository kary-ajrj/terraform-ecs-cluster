provider "aws" {
  region = "us-west-2"
}

module "ecs-service" {
  source                 = "../../modules/ecs-service"
  ecs_cluster_id         = data.terraform_remote_state.infra.outputs.ecs_cluster_id
  ecs_alb_tg_arn         = data.terraform_remote_state.infra.outputs.ecs_alb_target_group
  first_public_subnet_id = data.terraform_remote_state.infra.outputs.first_public_subnet_id
  ecs_security_group_id  = data.terraform_remote_state.infra.outputs.ecs_security_group_id
}