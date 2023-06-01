output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_alb_target_group" {
  value = aws_lb_target_group.ecs_alb_target_group.arn
}