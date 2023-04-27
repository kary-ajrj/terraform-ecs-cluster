resource "aws_ecs_cluster" "ecs_cluster" {
  name = "terraform-cluster"
}

resource "aws_launch_configuration" "launch_config" {
  image_id             = "ami-0c6b5b7ffdb17cb99"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_security_group.id]
  instance_type        = "t2.micro"
  key_name             = "ecs-ec2-key-pair"
  user_data            = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=terraform-cluster" >> /etc/ecs/ecs.config
EOF
}

resource "aws_ecs_task_definition" "task_example" {
  family                = "service"
  container_definitions = jsonencode([
    {
      name              = "hello"
      image             = aws_ecr_repository.ecr_example.repository_url
      memoryReservation = 985
      essential         = true
      portMappings      = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
}

resource "aws_ecs_service" "service_example" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_example.arn
  launch_type     = "EC2"
  desired_count   = 1
  load_balancer {
    container_name   = "hello"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
  }
  network_configuration {
    subnets         = [aws_subnet.ecs_public_subnet.id]
    security_groups = [aws_security_group.ecs_security_group.id]
  }
}