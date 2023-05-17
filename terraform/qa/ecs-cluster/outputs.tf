output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster_qa.name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster_qa.id
}

output "ecs_alb_target_group" {
  value = aws_lb_target_group.ecs_alb_target_group_qa.arn
}