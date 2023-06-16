provider "aws" {
  region = "us-west-2"
}


locals {
  vpc_cidr             = "20.0.0.0/16"
  subnet_one_cidr      = "20.0.1.0/24"
  subnet_two_cidr      = "20.0.2.0/24"
  pvt_subnet_one_cidr  = "20.0.3.0/24"
  pvt_subnet_two_cidr  = "20.0.4.0/24"
  instance_type        = "t2.micro"
  asg_max_size         = 1
  asg_min_size         = 1
  asg_desired_capacity = 1
}

module "network" {
  source              = "../../network"
  vpc_cidr            = local.vpc_cidr
  subnet_one_cidr     = local.subnet_one_cidr
  subnet_two_cidr     = local.subnet_two_cidr
  pvt_subnet_one_cidr = local.pvt_subnet_one_cidr
  pvt_subnet_two_cidr = local.pvt_subnet_two_cidr
}

module "ecs-cluster" {
  source                  = "../../ecs-cluster"
  instance_type           = local.instance_type
  asg_max_size            = local.asg_max_size
  asg_min_size            = local.asg_min_size
  asg_desired_capacity    = local.asg_desired_capacity
  vpc_id                  = module.network.vpc_id
  first_public_subnet_id  = module.network.first_public_subnet_id
  second_public_subnet_id = module.network.second_public_subnet_id
  first_pvt_subnet_id     = module.network.first_pvt_subnet_id
  second_pvt_subnet_id    = module.network.second_pvt_subnet_id
  iam_name                = module.network.iam_name
  ecs_security_group_id   = module.network.ecs_security_group_id
  alb_security_group_id   = module.network.alb_security_group_id
}
