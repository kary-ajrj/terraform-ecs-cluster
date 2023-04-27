resource "aws_ecs_cluster" "ecs_cluster" {
  name = "terraform-cluster"
}

resource "aws_launch_configuration" "launch_config" {
  image_id                    = "ami-0c6b5b7ffdb17cb99"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  security_groups             = [aws_security_group.ecs_security_group.id]
  instance_type               = "t2.micro"
  key_name                    = "ecs-ec2-key-pair"
  user_data                   = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=terraform-cluster" >> /etc/ecs/ecs.config
EOF
}