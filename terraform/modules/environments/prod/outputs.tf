output "first_pvt_subnet_id" {
  value = module.network.first_pvt_subnet_id
}

output "second_pvt_subnet_id" {
  value = module.network.second_pvt_subnet_id
}

output "ecs_security_group_id" {
  value = module.network.ecs_security_group_id
}

output "ecs_cluster_id" {
  value = module.ecs-cluster.ecs_cluster_id
}

output "ecs_alb_target_group" {
  value = module.ecs-cluster.ecs_alb_target_group
}