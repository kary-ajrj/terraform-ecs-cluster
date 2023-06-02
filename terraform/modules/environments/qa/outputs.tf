output "first_public_subnet_id" {
  value = module.network.first_public_subnet_id
}

output "security_group_id" {
  value = module.network.security_group_id
}

output "ecs_cluster_id" {
  value = module.ecs-cluster.ecs_cluster_id
}

output "ecs_alb_target_group" {
  value = module.ecs-cluster.ecs_alb_target_group
}