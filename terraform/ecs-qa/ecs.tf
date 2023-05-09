provider "aws" {
  region = "us-west-2"
}

data "aws_ecr_repository" "ecr_example" {
  name = "my_terraform_ecr_example"
}

resource "aws_ecs_cluster" "ecs_cluster_qa" {
  name = "terraform-cluster"
}

resource "aws_launch_template" "launch_config_qa" {
  image_id = "ami-0c6b5b7ffdb17cb99"
  iam_instance_profile {
    name = module.networking.iam_name
  }
  vpc_security_group_ids = [module.networking.security_group_id]
  instance_type          = "t2.micro"
  key_name               = "ecs-ec2-key-pair"
  user_data              = filebase64("user-data.sh")
}

resource "aws_ecs_task_definition" "task_example_qa" {
  family                = "service"
  container_definitions = jsonencode([
    {
      name              = "hello"
      image             = data.aws_ecr_repository.ecr_example.repository_url
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

resource "aws_ecs_service" "service_example_qa" {
  name                  = "ecs-service"
  cluster               = aws_ecs_cluster.ecs_cluster_qa.id
  task_definition       = aws_ecs_task_definition.task_example_qa.arn
  launch_type           = "EC2"
  desired_count         = 1
  wait_for_steady_state = true
  load_balancer {
    container_name   = "hello"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.ecs_alb_target_group_qa.arn
  }
  network_configuration {
    subnets         = [module.networking.first_public_subnet_id]
    security_groups = [module.networking.security_group_id]
  }
}