provider "aws" {
  region = "us-west-2"
}

locals {
  vpc_cidr        = "10.0.0.0/16"
  subnet_one_cidr = "10.0.1.0/24"
  subnet_two_cidr = "10.0.2.0/24"
  instance_type   = "t2.micro"
  asg_max_size    = 1
  asg_min_size    = 1
}

module "network" {
  source          = "../../modules/network"
  vpc_cidr        = local.vpc_cidr
  subnet_one_cidr = local.subnet_one_cidr
  subnet_two_cidr = local.subnet_two_cidr
}

module "ecs-cluster" {
  source                  = "../../modules/ecs-cluster"
  instance_type           = local.instance_type
  asg_max_size            = local.asg_max_size
  asg_min_size            = local.asg_min_size
  vpc_id                  = module.network.vpc_id
  first_public_subnet_id  = module.network.first_public_subnet_id
  second_public_subnet_id = module.network.second_public_subnet_id
  iam_name                = module.network.iam_name
  security_group_id       = module.network.security_group_id
}

module "ecs-service" {
  source                 = "../../modules/ecs-service"
  ecs_cluster_id         = module.ecs-cluster.ecs_cluster_id
  ecs_alb_tg_arn         = module.ecs-cluster.ecs_alb_target_group
  first_public_subnet_id = module.network.first_public_subnet_id
  security_group_id      = module.network.security_group_id
}