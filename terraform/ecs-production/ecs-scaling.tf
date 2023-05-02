resource "aws_autoscaling_group" "auto_scale" {
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.launch_config.name
  vpc_zone_identifier  = [module.networking.public_subnet_id]
  health_check_type    = "EC2"
  desired_capacity     = 1
  termination_policies = [
    "OldestInstance"
  ]
  default_cooldown          = 30
  health_check_grace_period = 30
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacity_provider_example"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.auto_scale.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}