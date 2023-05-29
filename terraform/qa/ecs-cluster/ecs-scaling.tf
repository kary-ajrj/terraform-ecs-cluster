resource "aws_launch_template" "launch_config_qa" {
  image_id = "ami-0c6b5b7ffdb17cb99"
  iam_instance_profile {
    name = data.terraform_remote_state.network.outputs.iam_name
  }
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id]
  instance_type          = "t2.micro"
  key_name               = "ecs-ec2-key-pair"
  user_data              = filebase64("../user-data.sh")
}

resource "aws_autoscaling_group" "auto_scale_qa" {
  max_size = 1
  min_size = 1
  launch_template {
    id = aws_launch_template.launch_config_qa.id
  }
  vpc_zone_identifier = [data.terraform_remote_state.network.outputs.first_public_subnet_id]
}

resource "aws_ecs_capacity_provider" "capacity_provider_qa" {
  name = "capacity_provider_qa"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.auto_scale_qa.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider_qa" {
  cluster_name       = aws_ecs_cluster.ecs_cluster_qa.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider_qa.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider_qa.name
  }
}