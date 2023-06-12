resource "aws_autoscaling_group" "auto_scale" {
  name     = "asg-${terraform.workspace}"
  max_size = var.asg_max_size
  min_size = var.asg_min_size
  desired_capacity = var.asg_desired_capacity

  launch_template {
    id = aws_launch_template.launch_config.id
  }
  vpc_zone_identifier = [var.first_public_subnet_id, var.second_public_subnet_id]
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacity-provider-${terraform.workspace}"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.auto_scale.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}