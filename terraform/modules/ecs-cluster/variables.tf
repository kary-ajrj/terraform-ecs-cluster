variable "instance_type" {}
variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "vpc_id" {}
variable "first_public_subnet_id" {}
variable "second_public_subnet_id" {}
variable "first_pvt_subnet_id" {}
variable "second_pvt_subnet_id" {}
variable "iam_name" {}
variable "ecs_security_group_id" {}
variable "alb_security_group_id" {}